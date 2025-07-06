`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:51:11 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU (
    input [31:0] a, b,
    input [3:0] aluControl,
    input isUnsigned, isShift,
    input [31:0] hi, lo,
    input isMul, isMadd, isMaddu,
    output reg [31:0] result,
    output zero, less_than, equal,
    output reg [63:0] mul_result
);
    wire [31:0] sum = a + b;
    wire [31:0] diff = a - b;
    wire [31:0] slt = (isUnsigned) ? ($unsigned(a) < $unsigned(b)) ? 32'd1 : 32'd0 :
                                (a < b) ? 32'd1 : 32'd0;
    wire [31:0] sll_result = a << b[4:0];
    wire [31:0] srl_result = a >> b[4:0];
    wire [31:0] sra_result = $signed(a) >>> b[4:0];
    reg [63:0] product;
 
    always @(*) begin
        mul_result = 64'd0;

        if (isMul || isMadd || isMaddu) begin
            
            if (isMaddu) 
                product = $unsigned(a) * $unsigned(b);
            else 
                product = $signed(a) * $signed(b);

         
            if (isMadd || isMaddu) 
                mul_result = {hi, lo} + product;
            else 
                mul_result = product;
        end
        

            
        case (aluControl)
            4'b0000: result = sum; // add/addi/lw/sw
            4'b0001: result = diff; // sub/beq/bne
            4'b0010: result = a & b; // and
            4'b0011: result = a | b; // or
            4'b0100: result = a ^ b; // xor
            4'b1001: result = (a==b)?32'd1:32'd0;//seq
            4'b0110: result = sll_result; // sll
            4'b0111: result = srl_result; // srl
            4'b1110: result = sra_result; // sra
            4'b1000: result = slt; // slt
            4'b1100: result = {b[15:0], 16'd0}; // lui
            default: result = 32'd0;
        endcase
    end 

   
    assign zero = (result == 32'd0);
    assign equal = (a == b);
    assign less_than = slt[0];

endmodule


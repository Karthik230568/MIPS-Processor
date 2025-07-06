`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:51:44 PM
// Design Name: 
// Module Name: FPU
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


module FPU (
    input [2:0] op,    
    input [31:0] a, b,
    input enable,
    output reg [31:0] result,
    output reg cc
);
    always @(*) begin
    if (enable) begin
        case (op)
            3'b000: result = $realtobits($bitstoreal(a) + $bitstoreal(b));  // add.s
            3'b001: result = $realtobits($bitstoreal(a) - $bitstoreal(b));  // sub.s
            3'b010: cc = ($bitstoreal(a) == $bitstoreal(b));                // c.eq.s
            3'b011: cc = ($bitstoreal(a) <= $bitstoreal(b));                // c.le.s
            3'b100: cc = ($bitstoreal(a) < $bitstoreal(b));                 // c.lt.s
            3'b101: cc = ($bitstoreal(a) >= $bitstoreal(b));                // c.ge.s
            3'b110: cc = ($bitstoreal(a) > $bitstoreal(b));                 // c.gt.s
            3'b111: result = b;                                             // mov.s
        endcase
        end
    end
endmodule



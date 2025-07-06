`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:50:19 PM
// Design Name: 
// Module Name: InstructionFetch
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


module InstructionFetch (
    input clk, reset, pcWrite, loadIR,
    input [31:0] nextPCInput,
    output [31:0] pcOut
    ,output reg [31:0] instructionOut
);
    reg [31:0] pc = 32'd0; 
    assign pcOut = pc;

    wire [31:0] instruction;
    ins_mem Instruction_Memory(
        .clk(clk),
        .dpra(pc[10:2]),  
        .dpo(instruction)
    );

   
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'd0;  
        end
        else if (pcWrite) begin
            pc <= nextPCInput;
        end
    end


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instructionOut <= 32'd0;  // Clear on reset
        end
        else if (loadIR) begin
            instructionOut <= instruction;
        end
    end
endmodule



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:47:45 PM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile (
	input clk,
	input reset,
	
	input regWrite,
	input [4:0] readReg1, readReg2, writeReg,
	input [31:0] writeData,
	output [31:0] readData1, readData2,

	input fprWrite,
	input [4:0] fprReadAddr1, fprReadAddr2, fprWriteAddr,
	input [31:0] fprWriteData,
	output [31:0] fprReadData1, fprReadData2,
    input hiWrite, loWrite,
    input [31:0] hiData, loData,
    output reg [31:0] hi, lo

);
    reg [31:0] gpr [0:31];
    reg [31:0] fpr [0:31];

    
    assign readData1 = (readReg1 == 5'd0) ? 32'd0 : gpr[readReg1];
    assign readData2 = (readReg2 == 5'd0) ? 32'd0 : gpr[readReg2];

 
    integer j;
    always @(posedge clk or posedge reset) begin
    
        if (reset) begin
            
            for (j = 0; j < 32; j = j + 1) begin
                gpr[j] <= 32'd0;
                fpr[j] <= 32'd0;
            end
            hi <= 32'd0;
            lo <= 32'd0;
        end
        else begin
            if (regWrite && writeReg != 5'd0) 
                gpr[writeReg] <= writeData;
            if (fprWrite) 
                fpr[fprWriteAddr] <= fprWriteData;
            if (hiWrite) hi <= hiData;
            if (loWrite) lo <= loData;
        end
        gpr[0]<=32'd0;
    end

endmodule



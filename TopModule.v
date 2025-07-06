`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:52:26 PM
// Design Name: 
// Module Name: TopModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
//Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TopModule (
	input clk, reset
);
	wire [31:0] instruction;
	wire [31:0]  nextPCInput,pc;
	wire [31:0] pc_plus_4 = (reset) ? 32'd0 : pc + 4;
	wire [31:0]  readData1, readData2, fprReadData1, fprReadData2;
	wire [31:0] aluResult, memReadData, writeBackData, fpuResult;
	wire [31:0] shamtExt = {27'd0, instruction[10:6]};
	wire [31:0] signExtImm; 
	wire [31:0] branch_offset = { {14{instruction[15]}}, instruction[15:0], 2'b00 };
	wire [31:0] branch_target = pc_plus_4 + branch_offset;
	wire [25:0] jump_addr = instruction[25:0];
	wire [31:0] jump_target = {pc_plus_4[31:28], jump_addr, 2'b00};
    wire [31:0] hi, lo;
    wire hiWrite, loWrite;
    wire [63:0] mul_result;
    wire [3:0] aluOp;
    wire [2:0] fpuOp,branchType;
    wire fpuEnable, fpuToReg;
    wire regDst;
	wire regWrite, fprWrite, aluSrc, memToReg, memWrite, memRead, branch, jump, jumpReg, isUnsigned;
	assign fpuToReg = 0;
	
	assign signExtImm= (isShift) ? shamtExt : {{16{instruction[15]}}, instruction[15:0]};
 
	
	InstructionFetch IF (
    	.clk(clk), .reset(reset), .pcWrite(1'b1), .loadIR(1'b1),
    	.nextPCInput(nextPCInput), .pcOut(pc)
    	 ,.instructionOut(instruction)
	);
    
	ControlUnit CU (
    	.opcode(instruction[31:26]), .funct(instruction[5:0]),
    	.regDst(regDst), .aluSrc(aluSrc), .memToReg(memToReg), .regWrite(regWrite),
    	.memRead(memRead), .memWrite(memWrite), .branch(branch), .jump(jump),
        .aluOp(aluOp), .fpuOp(fpuOp), .fpuEnable(fpuEnable), .jumpReg(jumpReg), .isUnsigned(isUnsigned),  
        .hiWrite(hiWrite), .loWrite(loWrite), .branchType(branchType)
	);

	RegisterFile RF (
    	.clk(clk), .reset(reset), .regWrite(regWrite),
    	.readReg1(instruction[25:21]), .readReg2(instruction[20:16]),
    	.writeReg((regDst==1) ? instruction[15:11] :( regDst == 2 ) ? 5'd31 : instruction[20:16]), .writeData(writeBackData),
    	.readData1(readData1), .readData2(readData2),
    	.fprWrite(fprWrite), .fprReadAddr1(instruction[25:21]),
    	.fprReadAddr2(instruction[20:16]), .fprWriteAddr(instruction[15:11]),
    	.fprWriteData(writeBackData), .fprReadData1(fprReadData1), .fprReadData2(fprReadData2),
        .hiWrite(hiWrite),.loWrite(loWrite),
        .hiData(mul_result[63:32]),
        .loData(mul_result[31:0]),
        .hi(hi),.lo(lo)
	);
 
	ALU alu (
    	.a(readData1), .b((aluSrc) ? signExtImm : readData2),
    	.aluControl(aluOp), .isUnsigned(isUnsigned), .isShift(isShift), .hi(hi), .lo(lo),
        .isMul(isMul),
        .isMadd(isMadd),
        .isMaddu(isMaddu),
    	.result(aluResult), .zero(zero), .less_than(less_than), .equal(equal), .mul_result(mul_result)
	);
	
	FPU fpu (
    .a(fprReadData1), .b(fprReadData2),
    .op(fpuOp),.enable(fpuEnable),
    .result(fpuResult),
    .cc(cc)
    );


    data_mem Data_Memory(.clk(clk),.we(memWrite),.a(aluResult[31:2]),.dpo(memReadData),.d(readData2),.dpra(aluResult[31:2]));

	wire branch_taken = branch && (
    (branchType == 3'b000 && equal) ||        
    (branchType == 3'b001 && !equal) ||         
    (branchType == 3'b010 && !less_than && !equal) || 
    (branchType == 3'b011 && !less_than) ||   
    (branchType == 3'b100 && (less_than || equal)) || 
    (branchType == 3'b101 && less_than) ||      
    (branchType == 3'b110 && (less_than || equal)) || 
    (branchType == 3'b111 && !less_than && !equal)  
);


    assign nextPCInput =
    	jump ? (jumpReg ? readData1 : jump_target) :
    	branch_taken ? branch_target :
    	pc_plus_4;
 

    assign writeBackData = 
        (memToReg) ? memReadData : aluResult; 

 
endmodule



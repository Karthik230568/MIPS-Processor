`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:48:35 PM
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit (
    input [5:0] opcode, funct,
    output reg regDst, aluSrc, memToReg, regWrite, memRead, memWrite, branch, jump,fprWrite,
    output reg [3:0] aluOp,
    output reg [2:0] fpuOp,
    output reg fpuEnable, jumpReg, isUnsigned, isMul, isMadd, isMaddu, isShift,
    output reg fpuToReg, 
    output reg [2:0] branchType,
    output reg hiWrite, loWrite
);
    always @(*) begin
        
        regDst = 0; aluSrc = 0; memToReg = 0; regWrite = 0;
        memRead = 0; memWrite = 0; branch = 0; jump = 0;
        aluOp = 4'b0000; fpuOp = 3'b000; fpuEnable = 0;
        jumpReg = 0; isUnsigned = 0; isMul = 0; isMadd = 0; isMaddu = 0; isShift = 0;
        hiWrite = 0; loWrite = 0; fpuToReg = 0; branchType = 3'b000;
 
    	case (opcode)
        	6'b000000: begin // R-Type
            	regDst = 1; regWrite = 1;
            	case (funct)
                	6'b100000: aluOp = 4'b0000; // add
                	6'b100010: aluOp = 4'b0001; // sub
                	6'b100001: begin aluOp = 4'b0000; isUnsigned = 1; end // addu
                	6'b100011: begin aluOp = 4'b0001; isUnsigned = 1; end // subu
                	6'b100100: aluOp = 4'b0010; // and
                	6'b100101: aluOp = 4'b0011; // or
                	6'b100110: aluOp = 4'b0100; // xor
                	6'b000000: begin aluOp = 4'b0110; aluSrc = 1; isShift = 1; end // sll
                	6'b000010: begin aluOp = 4'b0111; isShift = 1; end // srl
                	6'b000011: begin aluOp = 4'b1110; isShift = 1; end // sra
                	6'b101010: aluOp = 4'b1000; // slt
                    6'b011000: begin // mul
                          isMul = 1;
                          hiWrite = 1;
                          loWrite = 1;
                    end
                    6'b011001: begin // madd
                        isMadd = 1;
                        hiWrite = 1;
                        loWrite = 1;
                    end
                    6'b011010: begin // maddu
                        isMaddu = 1;
                        hiWrite = 1;
                        loWrite = 1;
                    end
                	6'b001000: jumpReg = 1; // jr
              
            6'b110000: begin // add.s
                fpuEnable = 1;
                fprWrite = 1;
                regWrite = 0;
                fpuOp = 3'b000;  // FP Add
            end
            6'b110001: begin // sub.s
                fpuEnable = 1;
                fprWrite = 1;
                fpuOp = 3'b001;  // FP Subtract
            end
            6'b110010: begin // c.eq.s
                fpuEnable = 1;
                fpuOp = 3'b010;  // FP Compare Equal
            end
            6'b110011: begin // c.le.s
                fpuEnable = 1;
                fpuOp = 3'b011;  // FP Compare Less/Equal
            end
            6'b110100: begin // c.lt.s
                fpuEnable = 1;
                fpuOp = 3'b100;  // FP Compare Less Than
            end
            6'b110101: begin // c.ge.s
                fpuEnable = 1;
                fpuOp = 3'b101;  // FP Compare Greater/Equal
            end
            6'b110110: begin // c.gt.s
                fpuEnable = 1;
                fpuOp = 3'b110;  // FP Compare Greater Than
            end
            6'b011110: begin // mov.s
                fpuEnable = 1;
                fprWrite = 1;
                fpuOp = 3'b111;  // FP Register Move
            end
            	endcase
        	end
        	6'b001000 : begin 
        	 aluSrc=1;
        	 regWrite=1; 
        	 aluOp=4'b0000;
        	  isUnsigned=0;
        	end // addi
        	6'b001001: begin aluSrc=1; regWrite=1; aluOp=4'b0000; isUnsigned=1; end // addiu
            6'b000100: begin branch=1; aluOp=4'b0001; branchType=3'b000; end // beq 
            6'b000101: begin branch=1; aluOp=4'b0001; branchType=3'b001; end // bne 
            6'b000110: begin branch=1; aluOp=4'b1000; branchType=3'b010; end // bgt 
            6'b000111: begin branch=1; aluOp=4'b1000; branchType=3'b011; end // bgte 
            6'b001100: begin branch=1; aluOp=4'b1000; branchType=3'b100; end // ble 
            6'b001101: begin branch=1; aluOp=4'b1000; branchType=3'b101; end // bleq 
            6'b010011: begin branch=1; aluOp=4'b1000; isUnsigned=1; branchType=3'b111; end // bgtu 

        	6'b000010: jump = 1; // j
        	6'b000011: begin jump=1; regWrite=1;regDst=2; end // jal
        	// I-Type Instructions
        	6'b100011: begin aluSrc=1; memRead=1; regWrite=1;memToReg=1;aluOp=4'b0000; end // lw
        	6'b101011: begin aluSrc=1; memWrite=1;aluOp=4'b0000;regWrite = 0; end // sw
            6'b001111: begin // lui 
            aluSrc = 1;
            regWrite = 1;
            aluOp = 4'b1100; 
    end
   6'b001010: begin // slti
        aluSrc = 1;
        regWrite = 1;
        aluOp = 4'b1000; // slt
    end
    6'b001011: begin // seq 
        aluSrc = 1;
        regWrite = 1;
        aluOp = 4'b1001; 
    end

    	endcase
	end
endmodule



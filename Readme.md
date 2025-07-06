A simplified 32-bit MIPS-inspired processor with integer and floating-point capabilities, designed for educational purposes and FPGA prototyping.\
\
## Overview\
This processor implements a subset of the MIPS ISA with custom extensions for floating-point operations. It features a pipelined architecture, separate instruction/data memory, and support for basic arithmetic, logic, control flow, and FPU instructions.\
\
## Key Features\
- **Supported Instruction Types**:\
  - R-Type (ADD, SUB, AND, OR, etc.)\
  - I-Type (ADDI, LW, SW, BEQ, etc.)\
  - J-Type (J, JAL)\
  - Floating-Point (ADD.S, MOV.S, MFC1/MTC1)\
- **Memory-Mapped I/O** via separate instruction/data memories\
- **Pipelined Execution** (5-stage: IF, ID, EX, MEM, WB)\
- **Special Registers**:\
  - HI/LO for multiplication/division\
  - Floating-Point Register File (32-bit)\
- **Control Signals**: 15+ control signals for datapath management\
\
## Modules\
| Module                 | Description                                  |\
|------------------------|----------------------------------------------|\
| `TopModule`            | Top-level processor                          |\
| `Control_Unit`         | Main control unit for instruction decoding   |\
| `ALU`                  | Arithmetic Logic Unit                        |\
| `FPU`                  | Floating-Point Unit                          |\
| `Registerfile`         | 32-bit General Purpose Register File         |\
| `Instruction_Fetch`    | Fetches the instructions                     |\
\
## Instruction Set\
### Arithmetic/Logical\
| Instruction | Opcode | Example            | Description                |\
|-------------|--------|--------------------|----------------------------|\
| ADD         | 0x00   | add $rd, $rs, $rt  | Signed addition            |\
| ADDI        | 0x0C   | addi $rt, $rs, imm | Immediate addition         |\
| AND         | 0x00   | and $rd, $rs, $rt  | Bitwise AND                |\
| OR          | 0x00   | or $rd, $rs, $rt   | Bitwise OR                 |\
\
### Data Transfer\
| Instruction | Opcode | Example            | Description                |\
|-------------|--------|--------------------|----------------------------|\
| LW          | 0x01   | lw $rt, imm($rs)   | Load word                  |\
| SW          | 0x02   | sw $rt, imm($rs)   | Store word                 |\
| MFC1        | 0x18   | mfc1 $rt, $fs      | Move from FP register      |\
| MTC1        | 0x19   | mtc1 $rt, $fs      | Move to FP register        |\
\
### Control Flow\
| Instruction | Opcode | Example            | Description                |\
|-------------|--------|--------------------|----------------------------|\
| BEQ         | 0x03   | beq $rs, $rt, imm  | Branch if equal            |\
| J           | 0x09   | j target           | Unconditional jump         |\
| JAL         | 0x0A   | jal target         | Jump and link              |\
\
### Floating-Point\
| Instruction | Opcode | Example            | Description                |\
|-------------|--------|--------------------|----------------------------|\
| ADD.S       | 0x17   | add.s $fd, $fs, $ft| FP addition                |\
| MOV.S       | 0x1E   | mov.s $fd, $fs     | FP register move           |\
\
## Getting Started\
### Prerequisites\
- Verilog simulator (Icarus Verilog/ModelSim)\
- FPGA toolchain (Vivado/Quartus) for synthesis\
- Waveform viewer (GTKWave)\
\
### Simulation\
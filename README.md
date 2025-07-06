IITK-MIPS Processor
===================
A simplified 32-bit MIPS-inspired processor with integer and floating-point capabilities, designed for educational purposes and FPGA prototyping.

Overview
--------
This processor implements a subset of the MIPS ISA with custom extensions for floating-point operations. It features a pipelined architecture, separate instruction/data memory, and support for basic arithmetic, logic, control flow, and FPU instructions.

Key Features
------------
- Supported Instruction Types:
  - R-Type (ADD, SUB, AND, OR, etc.)
  - I-Type (ADDI, LW, SW, BEQ, etc.)
  - J-Type (J, JAL)
  - Floating-Point (ADD.S, MOV.S, MFC1, MTC1)
- Memory-Mapped I/O using separate instruction and data memories
- 5-Stage Pipeline: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), Write Back (WB)
- Special Registers:
  - HI/LO for multiplication/division operations
  - 32-entry Floating-Point Register File (32-bit each)
- Control Unit with 15+ control signals for datapath coordination
- Synthesizable on Xilinx/Intel FPGAs

Modules
-------
| Module              | Description                                  |
|---------------------|----------------------------------------------|
| TopModule           | Top-level wrapper integrating all components |
| Control_Unit        | Instruction decoding and control signal gen  |
| ALU                 | Integer Arithmetic Logic Unit                |
| FPU                 | IEEE-754 compliant Floating-Point Unit       |
| Registerfile        | 32 general-purpose registers                 |
| FP_Registerfile     | 32 floating-point registers (32-bit)         |
| Instruction_Fetch   | Program Counter and instruction fetch logic  |
| Data_Memory         | Memory interface for load/store operations   |
| Hazard_Unit         | Pipeline stall and forwarding logic          |
| Pipeline_Registers  | IF/ID, ID/EX, EX/MEM, MEM/WB registers       |
| Immediate_Generator | Immediate field extraction logic             |

Instruction Set
---------------

### Arithmetic/Logical
| Instruction | Opcode | Example             | Description        |
|-------------|--------|---------------------|--------------------|
| ADD         | 0x00   | add $rd, $rs, $rt   | Signed addition    |
| SUB         | 0x00   | sub $rd, $rs, $rt   | Signed subtraction |
| AND         | 0x00   | and $rd, $rs, $rt   | Bitwise AND        |
| OR          | 0x00   | or $rd, $rs, $rt    | Bitwise OR         |
| ADDI        | 0x0C   | addi $rt, $rs, imm  | Immediate add      |

### Data Transfer
| Instruction | Opcode | Example             | Description         |
|-------------|--------|---------------------|---------------------|
| LW          | 0x01   | lw $rt, imm($rs)    | Load word           |
| SW          | 0x02   | sw $rt, imm($rs)    | Store word          |
| MFC1        | 0x18   | mfc1 $rt, $fs       | Move from FP reg    |
| MTC1        | 0x19   | mtc1 $rt, $fs       | Move to FP reg      |

### Control Flow
| Instruction | Opcode | Example             | Description          |
|-------------|--------|---------------------|----------------------|
| BEQ         | 0x03   | beq $rs, $rt, imm   | Branch if equal      |
| J           | 0x09   | j target            | Unconditional jump   |
| JAL         | 0x0A   | jal target          | Jump and link        |

### Floating-Point
| Instruction | Opcode | Example             | Description           |
|-------------|--------|---------------------|-----------------------|
| ADD.S       | 0x17   | add.s $fd, $fs, $ft | Floating-point add    |
| MOV.S       | 0x1E   | mov.s $fd, $fs      | FP register move      |

Getting Started
---------------

### Prerequisites
- Verilog simulator (Icarus Verilog or ModelSim)
- FPGA toolchain (Xilinx Vivado or Intel Quartus)
- GTKWave for waveform analysis

### Simulation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/iitk-mips.git
   cd iitk-mips
   ```
2. Run simulation using Icarus Verilog:
   ```bash
   iverilog -o mips.vvp *.v
   vvp mips.vvp
   ```
3. View waveforms:
   ```bash
   gtkwave dump.vcd
   ```

### FPGA Deployment (Vivado)
1. Open Vivado and create a new RTL project.
2. Add all Verilog source files from the repo.
3. Set the top module as `TopModule`.
4. Synthesize and implement the design.
5. Generate bitstream and program the FPGA.


Authors
-------
Developed at IIT Kanpur for educational purposes.

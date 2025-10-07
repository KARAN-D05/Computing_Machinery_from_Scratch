# Repeated Arithmetic Machine - V4

## About
- Programmable Stored instruction system
- Instructions in machine code are stored in memory and are executed sequentially
- Instead of manually controlling each operation, v4 can now load and execute a sequence of instructions stored in memory.

## Features
- A memory unit to store the program
- Can sequentially execute multiple instructions without any intervention
- Each instruction is 16 bit long
- The memory can be made as large as possible after interfacing sufficient number of memory subcircuits.
- Program have to be loaded initially through load pins in machine code
- Supports all operations 

## Purpose
- This version continues the self initiated exploration of how compuation evolves from logic gates to programmable-machines
- It bridges gap between data processing(v3) and instruction processing(v4)

## Instruction Format
- Each instruction is 16 bit long and have to be written following the instruction format
- Bit1-> Feedback
- Bit2-> Store
- Bit3-> Selector
- Bit4-> Data1
- Bit5-> Mode
- Bit6-> Reset
- Bit7->Data2
- Bit8->Multiply
- Bit9->Divide
- Bit10->Override System Halt
- Bit11->Data4
- Bit12->Data8
- Bit13->Multiplier=1
- Bit14->Multiplier=2
- Bit15->Multiplier=4
- Bit16->Multiplier=8

## How to Use Version 4 (r_a_mv4.circ)

1. **Install Logisim Evolution** 
   - Download and install from: [Logisim Evolution GitHub](https://github.com/logisim-evolution/logisim-evolution)

2. **Open the Circuit File** 
   - Navigate to the `RAM_v4` folder (or wherever `r_a_mv4.circ` is located). 
   - Open `r_a_mv4.circ` in Logisim Evolution.

3. **Understand the Instruction format and machine code programming** 
   - Start small with programs to load data and basic addition
   - After getting comfortable, try programs including feedback, multiplication, subtraction and division
   - Refer r_a_mv3 (Navigate to RAM_V3 folder and download r_a_mv3.circ) to understand how different operations are performed by hardware to write correct program      to control the machinery.

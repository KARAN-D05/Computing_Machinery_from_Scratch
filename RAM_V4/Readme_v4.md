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

## Translating the desired set of operations in a Program
- In order to do that, one should have thorough understanding of how the operations are implemented through hardware so that instructions can be sequenced properly
- Hence it is recommended to refer the previous versions(v1-v3) for the knowledge of how different operations are implemented and when to set a particular machine   code insrtuction bit high or low to control the pins essentially controlling the machine

## Program Memory
- The pins on Program active memory are labelled as Ix_y, where x is the instruction number and y is the instruction bit, each program memory module has capacity of storing 4 instructions(16 bit each), hence 8 Bytes. In the circuit provided 2 such modules have been connected giving us ability to store 16 bytes, even though more modules can be connected together to get more memory to store a program.
- Each Program Memory is made up of 4 sets of 16 D-flip flops, the set of D-flip flops connected directly to machine is called the Interface module, as it acts as an interface between machine and memory and the instruction that interface module holds is getting executed. 
- Sets of D-flip flops are Connected in such a way that after loading the program and initiating it, the instructions keep flowing from one D-flip flop set to the next getting to the interface module and controlling the machine when it has to. 

## Loading the Program
- Each instruction has to be entered manually through the initial load pins, then make Load_Ix pin high and the instruction will be stored.
- Same steps have to be followed for further instrcution loading
- Ix_y, x=1,2,3,4 is the sequence in which instuctions will be executed

## Arithmetic Operation Signals
- The default operation of the machine is addition.
- Thus in order to perform subtraction(Bit5), division(Bit9) or multiplication(Bit8) keep that respective initial load pin high along with multiplier(Bit13-Bit16)   in case of Muliplication

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

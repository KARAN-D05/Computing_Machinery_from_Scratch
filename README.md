## Computing Machinery from Scratch

This project began from a simple idea: what if the output of an arithmetic operation could be fed back into the input? 
The first prototype was very basic — it could only perform addition and take feedback. But as I explored the possibilities, I
kept improving the machine:

- [V0](RAM_Engine) -> Proof of concept
- [V1](RAM_V1) -> Manual Arithmetic Logic and 2's complement handling
- [V2](RAM_V2) -> Low level of Automation
- [V3](RAM_V3) -> Self Correction, Self-awareness and high level of automation
- [V4](RAM_V4) -> Sequential execution of Instructions stored in memory

Through each iteration, the goal was simple: make the machine **smarter, more autonomous, programmable and more reliable**.  

Today, the Repeated Arithmetic Machine(name of the computing machine) is a modular, 4-bit arithmetic computing system with feedback-driven control, automation, error handling and ability to execute programs— a full evolution from a simple prototype to a fully autonomous, intelligent machine.

[Machine Schematics - From Idea to Intelligence(V1-V3)](Images/RAM_Project_Evolution.pdf)

## Latest Development --> r_a_mv4(Stored Program Architecture)
This stage represents a significant step towards understanding and recreating principles behind early programmable computers.
This is done in order to understand how instructions can be stored in memory and executed sequentially.
The development of this version 4 is a hands on exploration of how program memory, sequencing and control logic forms basis of the **Von Neumann Architecture** or the **Stored Program Concept**.

**Progress Made:-**
- Developed instruction format
- Built Memory modules that stores the machine code instructions
- Developed units that facilitate Controlled flow for execution of instructions
- Successfully demonstrated programs like loading data, then adding them, then taking a feedback and subtracting it from some other data
- Operations that would take manual intervention have been automated through machine code programming

[More About technical details](RAM_V4/Readme_v4.md)

## Upcoming Versions:-
- Assembly language for the machine code instructions
- Assembler to convert from assembly code to machine code

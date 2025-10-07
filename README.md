## About the Repeated Arithmetic Machine

This project began from a simple idea: what if the output of an arithmetic operation could be fed back into the input? 

The first prototype was very basic — it could only perform addition and take feedback. But as I explored the possibilities, I
kept improving the machine:

- Added **subtraction** and LED indicators to show which outputs were correct.  
- Developed a **2's complement output form corrector** to handle negative results.  
- Introduced a **comparator** to automate corrections when B > A, removing the need for manual adjustments.  
- Implemented **multiplication**,**Division** convergence detectors, and other logic for advanced operations.
- Enhanced the system with **self-correcting features, self-awareness, and automatic halting** to prevent data corruption.  

Through each iteration, the goal was simple: make the machine **smarter, more autonomous, and more reliable**.  

Today, the Repeated Arithmetic Machine is a modular, 4-bit arithmetic computing system with feedback-driven control, automation, and error handling — a full evolution from a simple prototype to a fully autonomous, intelligent machine.

[Machine Schematics - From Idea to Intelligence](Images/RAM_Project_Evolution.pdf)

## Current Development --> r_a_mv4(Stored Program Architecture)
This stage represents a significant step towards understanding and recreating principles behind early programmable computers.
This is done in order to understand how instructions can be stored in memory and executed sequentially.
The development of this version 4 is a hands on exploration of how program memory, sequencing and control logic forms basis of the **Von Neumann Architecture** or the **Stored Program Concept**.

**Progress Made:-**
- Developed instruction format
- Built Memory modules that stores the machine code instructions
- Developed units that facilitate Controlled flow for execution of instructions
- Successfully demonstrated programs like loading data, then adding them, then taking a feedback and subtracting it from some other data
- Operations that would take manual intervention have been automated through machine code programming

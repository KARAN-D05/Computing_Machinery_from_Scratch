---- Repeated Arithmetic Machine - Engine(RAM_V0) ----

## About
The very first implementation of the repeated arithmetic machine idea.

## Features
- supports only 2 arithmetic operations (Addition & Subtraction) 
- A selector pin, output pin, Feedback pin, Reset pin

## Limitations
- No error correction
- No overflow detection

## Significance
- A proof of concept that repeated arithmetic and feedback could form basis of a machine

## Instructions to use
- Feed the input to A and B and choose the mode of operation and output the result!
- The output can be feeded back to the input(A) for further operations
- The machine will start giving errors once the output gets below 0 in case of subtraction and if result have gone past 15 in case of addition. 

## How to Run This Project

1. **Install Logisim Evolution** 
   - Download and install from: [Logisim Evolution GitHub](https://github.com/logisim-evolution/logisim-evolution)

2. **Clone or Download the Repository** 
   - To clone via Git (recommended):
     ```bash
     git clone https://github.com/KARAN-D05/Autonomous_Arithmetic_Machine.git
     ```
   - Or download ZIP from GitHub and extract it.

3. **Open the Circuit File** 
   - Open Logisim Evolution. 
   - Navigate to the project folder and open any `.circ` file (e.g., `r_a_m_Engine.circ`).

4. **Simulate the Machine** 
   - Use the input pins and observe the output. 
   - Follow any instructions in the README for specific versions.

5. **Optional: Explore Other Versions** 
   - Later versions (`r_a_mv1.circ`, `r_a_mv2.circ`, `r_a_mv3.circ`) include more advanced automation and self-correction.


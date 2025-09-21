# Repeated Arithmetic Machine - V2

## About
- Full automation for 2's complement result handling. 
- A minimal extension to V1, now with automatic correction for negative results.

## Features
- Automatically detects if B > A using a comparator. 
- Corrects the 2's complement output without any manual intervention. 

## Limitations
- Overflow detection is still not implemented. 

## Significance
- Demonstrates a fully automated 2's complement correction unit, removing the need for manual input adjustments. 

## How to Use Version 2 (r_a_mv2.circ)

1. **Install Logisim Evolution** 
   - Download and install from: [Logisim Evolution GitHub](https://github.com/logisim-evolution/logisim-evolution)

2. **Open the Circuit File** 
   - Navigate to the `RAM_v2` folder (or wherever `r_a_mv2.circ` is located). 
   - Open `r_a_mv2.circ` in Logisim Evolution.

3. **Understand the Inputs and Outputs** 
   - Follow the input pins labeled for arithmetic operations (addition, subtraction, etc.). 
   - Observe the output pins — Version 2 includes **fully automated 2's complement output correction**.

4. **Simulate the Machine** 
   - Apply different inputs to see the machine perform operations. 
   - Observe automatic correction for negative results. 
   - Feedback and error handling are still present.

5. **Optional: Compare with Previous Versions** 
   - You can open `r_a_mv1.circ` to see manual B > A handling. 
   - Open `r_a_mEngine.circ` to explore the base engine functionality.

6. **Tips for Users** 
   - Watch output LEDs for feedback and automatic corrections. 
   - Refer to the README for details on features and supported operations. 
   - See [RAM_Engine] for core engine functionality.

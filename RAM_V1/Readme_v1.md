---- Repeated Arithmetic Machine - V1 ----

## About
- A minimal extension to the RAM Engine.

## Features
- Handles 2's complement result and outputs correct result
- Manual pin if B>A initially in case of subtraction to get correct result.

## Limitations
- No overflow detection
- have to manually check if B>A for correct computation

## Significance
- Demonstrated a correction unit that automatically computes output in negative range.

## How to Use Version 1 (r_a_mv1.circ)

1. **Install Logisim Evolution** 
   - Download and install from: [Logisim Evolution GitHub](https://github.com/logisim-evolution/logisim-evolution)

2. **Open the Circuit File** 
   - Navigate to the `RAM_v1` folder (or wherever `r_a_mv1.circ` is located). 
   - Open `r_a_mv1.circ` in Logisim Evolution.

3. **Understand the Inputs and Outputs** 
   - Follow the input pins labeled for your arithmetic operations (addition, subtraction, etc.). 
   - Observe the output pins — Version 1 includes **2's complement output correction**.

4. **Simulate the Machine** 
   - Apply different inputs to see how the machine performs operations. 
   - Observe error handling, feedback correction, and other automated features.

5. **Optional: Explore Engine Version** 
   - For comparison, you can open `r_a_mEngine.circ` to see the base engine functionality.

6. **Tips for Users** 
   - Watch output LEDs for feedback and automatic corrections.
   - Refer to the README for details on features and supported operations.
   - See [RAM_Engine] for core functionality.

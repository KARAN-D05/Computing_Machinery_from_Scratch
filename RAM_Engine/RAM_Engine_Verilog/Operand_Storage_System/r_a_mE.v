// ============================================================
// Module : operand_storage_system
// Purpose: Stores a 4-bit operand into one of two registers
//          based on a select signal. Acts as a 2-slot register
//          bank where each slot holds one operand for Computation.
//
// Inputs:
//   data_in   [3:0] - The 4-bit operand to be stored
//   sel             - Selects destination register (0 = d_ff1, 1 = d_ff2)
//   store_clk       - Rising edge triggers the store operation
//   reset           - Asynchronous active-high reset, clears both registers
//
// Outputs:
//   d_ff1     [3:0] - Register slot 1, holds operand when sel = 0. Corresponds to Register A.
//   d_ff2     [3:0] - Register slot 2, holds operand when sel = 1. Corresponds to Register B.
//
// Behavior:
//   - On posedge store_clk : routes data_in to d_ff1 or d_ff2 via sel
//   - On posedge reset     : immediately clears both registers (async)
//   - Data is retained until overwritten or reset is asserted
// ============================================================

module operand_storage_system(
    input  [3:0] data_in,   // 4-bit input data (operand to be stored)
    input        sel,       // Select line: 0 → store in d_ff1, 1 → store in d_ff2
    input        store_clk, // Manual clock trigger (storage happens on rising edge)
    input        reset,     // Asynchronous reset (immediate clear of registers)
    output reg [3:0] d_ff1, // First 4-bit register (operand slot 1)
    output reg [3:0] d_ff2  // Second 4-bit register (operand slot 2)
);

// Sensitivity list includes both store_clk and reset so that:
//   - Normal storage is clocked (synchronous with store_clk)
//   - Reset is asynchronous (does not wait for clock edge)
always @(posedge store_clk or posedge reset) begin
    
    // Asynchronous Reset
    // Triggered immediately when reset goes HIGH, independent of
    // the clock. Both registers are cleared to 0000 instantly.
    if (reset) begin
        d_ff1 <= 4'b0000; // Clear register 1 → slot 1 holds 0
        d_ff2 <= 4'b0000; // Clear register 2 → slot 2 holds 0
    
    end else begin
        // On each rising edge of store_clk, data_in is routed
        // to the appropriate register depending on sel.
        // Only one register is written per clock cycle.
        // The other register retains its previous value.
        
        if (sel)
            d_ff2 <= data_in; // sel = 1 → write data_in into register 2
        else
            d_ff1 <= data_in; // sel = 0 → write data_in into register 1
    end
end

endmodule

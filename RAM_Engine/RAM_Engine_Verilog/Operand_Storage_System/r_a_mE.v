// Operand Storage System
// This module stores 4-bit input data into one of two registers
// based on the select signal. Think of it as a 2-slot register bank.

module operand_storage_system(
    input  [3:0] data_in,   // 4-bit input data (operand to be stored)
    input        sel,       // Select line: 0 → store in d_ff1, 1 → store in d_ff2
    input        store_clk, // Manual clock trigger (storage happens on rising edge)
    input        reset,     // Asynchronous reset (immediate clear of registers)
    output reg [3:0] d_ff1, // First 4-bit register (operand slot 1)
    output reg [3:0] d_ff2  // Second 4-bit register (operand slot 2)
);

// Sequential logic block:
// - Triggered on rising edge of store_clk (normal operation)
// - Also triggered immediately on reset (asynchronous behavior)
always @(posedge store_clk or posedge reset) begin
    
    // Asynchronous reset condition:
    // Immediately clears both registers regardless of clock
    if (reset) begin
        d_ff1 <= 4'b0000; // Clear register 1
        d_ff2 <= 4'b0000; // Clear register 2
    
    end else begin
        // Normal operation (on clock edge):
        // Route input data to one of the registers based on 'sel'
        
        if (sel)
            d_ff2 <= data_in; // If sel = 1 → store in second register
        else
            d_ff1 <= data_in; // If sel = 0 → store in first register
    end
end

endmodule

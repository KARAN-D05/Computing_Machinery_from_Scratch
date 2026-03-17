`include "r_a_mE.v"

// Testbench for operand_storage_system
// This module stimulates the DUT (Design Under Test)
// and observes how data is stored in registers.

module testbench;

  // Testbench signals (inputs to DUT)
  reg [3:0] data_in_t;   // Input data stimulus
  reg sel_t;             // Select line stimulus
  reg reset_t;           // Reset signal stimulus
  reg store_clkt;        // Manual clock stimulus

  // Outputs from DUT (observed signals)
  wire [3:0] d_ff1t;     
  wire [3:0] d_ff2t;
  
  // Instantiate DUT (Device Under Test)
  operand_storage_system dut(
    .data_in(data_in_t),
    .sel(sel_t),
    .store_clk(store_clkt),
    .reset(reset_t),
    .d_ff1(d_ff1t),
    .d_ff2(d_ff2t)
  );

  initial begin

    // Monitor prints values whenever any listed signal changes
    // Helps track behavior over simulation time
    $monitor("t=%0t | data_in = %b | sel_t = %b | store_t = %b | reset_t = %b | d_ff1t = %b | dff2t = %b",
              $time, data_in_t, sel_t, store_clkt, reset_t, d_ff1t, d_ff2t);

    // VCD dump for waveform viewing (GTKWave)
    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);
   
    // -------- Test Sequence Begins --------

    // Initial state: no clock edge yet → no storage should happen
    data_in_t = 4'b1000;
    store_clkt = 0;
    sel_t = 0;
    reset_t = 0;
    #5;

    // Rising edge → store 1000 into d_ff1 (sel = 0)
    data_in_t = 4'b1000;
    store_clkt = 1;
    sel_t = 0;
    reset_t = 0;
    #5;

    // Reset asserted → both registers should clear immediately
    data_in_t = 4'b0000;
    store_clkt = 1;
    sel_t = 1;
    reset_t = 1;
    #5;

    // Prepare next input (no clock edge yet → no write)
    data_in_t = 4'b1011;
    store_clkt = 0;
    sel_t = 1;
    reset_t = 0;
    #5;

    // Rising edge → store 1011 into d_ff2 (sel = 1)
    data_in_t = 4'b1011;
    store_clkt = 1;
    sel_t = 1;
    reset_t = 0;
    #5;

    // Prepare next input for d_ff1 (no write yet)
    data_in_t = 4'b1111;
    store_clkt = 0;
    sel_t = 0;
    reset_t = 0;
    #5;

    // Rising edge → store 1111 into d_ff1
    data_in_t = 4'b1111;
    store_clkt = 1;
    sel_t = 0;
    reset_t = 0;
    #5;

    // Direct write to d_ff2 (clock already high → no edge, so no write)
    data_in_t = 4'b1001;
    store_clkt = 1;
    sel_t = 1;
    reset_t = 0;
    #5;

    // Prepare next input (no clock edge)
    data_in_t = 4'b0001;
    store_clkt = 0;
    sel_t = 0;
    reset_t = 0;
    #5;

    // Reset again → both registers cleared
    data_in_t = 4'b1101;
    store_clkt = 0;
    sel_t = 1;
    reset_t = 1;
    #5;

    // Even with clock edge, reset dominates → still cleared
    data_in_t = 4'b1101;
    store_clkt = 1;
    sel_t = 1;
    reset_t = 1;
    #5;

    // -------- End of Simulation --------
    $display("Simulation Complete!");
    $finish;
  end

endmodule

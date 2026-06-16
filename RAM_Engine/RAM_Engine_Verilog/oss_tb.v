`include "oss.v"

module testbench;

  reg [3:0] data_in_t;
  reg [3:0] fbk_in_t;

  reg sel_t;
  reg reset_t;
  reg store_t;
  reg fbk_t;

  wire [3:0] A_t;
  wire [3:0] B_t;

  operand_storage_system dut(
    .data_in(data_in_t),
    .fbk_in(fbk_in_t),
    .sel(sel_t),
    .store(store_t),
    .reset(reset_t),
    .fbk(fbk_t),
    .A(A_t),
    .B(B_t)
  );

  initial begin

    $monitor(
    "t=%0t | data=%b | fbk_in=%b | sel=%b | store=%b | reset=%b | fbk=%b | A=%b | B=%b",
    $time,
    data_in_t,
    fbk_in_t,
    sel_t,
    store_t,
    reset_t,
    fbk_t,
    A_t,
    B_t);

    $dumpfile("Sim.vcd");
    $dumpvars(0,testbench);

    // Reset
    data_in_t = 4'b0000;
    fbk_in_t  = 4'b0000;
    sel_t     = 0;
    store_t   = 0;
    reset_t   = 1;
    fbk_t     = 0;
    #5;
   
    // Store 1010 in B
    data_in_t = 4'b1010;
    fbk_in_t  = 4'b0000;
    sel_t     = 1;
    store_t   = 1;
    reset_t   = 0;
    fbk_t     = 0;
    #5;

    store_t = 0;
    #5;

    // Store 1100 in A
    data_in_t = 4'b1100;
    fbk_in_t  = 4'b0000;
    sel_t     = 0;
    store_t   = 1;
    reset_t   = 0;
    fbk_t     = 0;
    #5;
    
    // Store 0011 in A via feedback while event_clk is level 1 
    data_in_t = 4'b0000;
    fbk_in_t  = 4'b0011;
    sel_t     = 0;
    store_t   = 0;
    reset_t   = 0;
    fbk_t     = 1;
    #5;

    fbk_t = 0;
    #5;
    
    // Store 0011 in A via feedback
    data_in_t = 4'b0000;
    fbk_in_t  = 4'b0011;
    sel_t     = 0;
    store_t   = 0;
    reset_t   = 0;
    fbk_t     = 1;
    #5;

    fbk_t = 0;
    #5;

    // Store 1111 in B via feedback
    data_in_t = 4'b0000;
    fbk_in_t  = 4'b1111;
    sel_t     = 1;
    store_t   = 0;
    reset_t   = 0;
    fbk_t     = 1;
    #5;

    fbk_t = 0;
    #5;

    // Store 1001 in A via feedback while data_in_t is also non-zero
    data_in_t = 4'b0110;
    fbk_in_t  = 4'b1001;
    sel_t     = 0;
    store_t   = 0;
    reset_t   = 0;
    fbk_t     = 1;
    #5;

    fbk_t = 0;
    #5;

    // Reset
    data_in_t = 4'b1100;
    fbk_in_t  = 4'b0000;
    sel_t     = 0;
    store_t   = 1;
    reset_t   = 1;
    fbk_t     = 1;
    #5;

    $display("Simulation Complete!");
    $finish;

  end

endmodule

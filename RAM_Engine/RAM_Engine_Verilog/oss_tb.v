`include "oss.v"

module testbench;

  reg clk;

  reg [3:0] data_in_t;
  reg [3:0] fbk_in_t;

  reg sel_t;
  reg reset_t;
  reg store_t;
  reg fbk_t;

  wire [3:0] A_t;
  wire [3:0] B_t;

  operand_storage_system dut(
    .clk(clk),
    .data_in(data_in_t),
    .fbk_in(fbk_in_t),
    .sel(sel_t),
    .store(store_t),
    .reset(reset_t),
    .fbk(fbk_t),
    .A(A_t),
    .B(B_t)
  );

  // Clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

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

    // --------------------
    // RESET
    // --------------------

    data_in_t = 4'b0000;
    fbk_in_t  = 4'b0000;
    store_t   = 0;
    sel_t     = 0;
    reset_t   = 1;
    fbk_t     = 0;
    #10;

    reset_t = 0;
    #10;

    // --------------------
    // STORE 1000 INTO A
    // --------------------

    data_in_t = 4'b1000;
    fbk_in_t  = 4'b0000;
    store_t   = 1;
    sel_t     = 0;
    reset_t   = 0;
    fbk_t     = 0;
    #10;

    store_t = 0;
    #10;

    // --------------------
    // STORE 1010 INTO B
    // --------------------

    data_in_t = 4'b1010;
    fbk_in_t  = 4'b0000;
    store_t   = 1;
    sel_t     = 1;
    reset_t   = 0;
    fbk_t     = 0;
    #10;

    store_t = 0;
    #10;

    // --------------------
    // FEEDBACK OR
    // 1001 | 0110 = 1111
    // --------------------

    data_in_t = 4'b1001;
    fbk_in_t  = 4'b0110;
    store_t   = 1;
    sel_t     = 0;
    reset_t   = 0;
    fbk_t     = 1;
    #10;

    store_t = 0;
    fbk_t   = 0;
    #10;

    // --------------------
    // 0000 | 0110 = 0110
    // --------------------

    data_in_t = 4'b0000;
    fbk_in_t  = 4'b0110;
    store_t   = 1;
    sel_t     = 0;
    reset_t   = 0;
    fbk_t     = 1;
    #10;

    store_t = 0;
    fbk_t   = 0;
    #10;

    // --------------------
    // 1001 | 0000 = 1001
    // --------------------

    data_in_t = 4'b1001;
    fbk_in_t  = 4'b0000;
    store_t   = 1;
    sel_t     = 0;
    reset_t   = 0;
    fbk_t     = 1;
    #10;

    store_t = 0;
    fbk_t   = 0;
    #10;

    // --------------------
    // RESET AGAIN
    // --------------------

    reset_t = 1;
    #10;

    reset_t = 0;
    #10;

    $display("Simulation Complete!");
    $finish;

  end

endmodule

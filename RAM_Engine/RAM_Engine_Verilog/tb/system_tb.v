`include "system.v"

module system_tb;

  reg [3:0] data_in_t;
  reg store_t;
  reg sel_t;
  reg fbk_t;
  reg reset_t;
  reg mode_t;
  reg comp_t;

  wire carry_t;
  wire [3:0] out_t;

  system dut(
    .data_in(data_in_t),
    .store(store_t),
    .sel(sel_t),
    .fbk(fbk_t),
    .reset(reset_t),
    .mode(mode_t),
    .comp(comp_t),
    .carry(carry_t),
    .out(out_t)
  );

  initial begin

    $dumpfile("system.vcd");
    $dumpvars(0, system_tb);

    $monitor(
      "t=%0t | data=%b | store=%b | sel=%b | fbk=%b | mode=%b | comp=%b | A=%b | B=%b | out=%b | carry=%b | reset = %b",
      $time,
      data_in_t,
      store_t,
      sel_t,
      fbk_t,
      mode_t,
      comp_t,
      dut.A_int,
      dut.B_int,
      out_t,
      carry_t,
      reset_t
    );

    // RESET
    data_in_t = 4'b0000;
    store_t   = 0;
    sel_t     = 0;
    fbk_t     = 0;
    reset_t   = 1;
    mode_t    = 0;
    comp_t    = 0;
    #5;

    reset_t = 0;
    #5;

    // LOAD B = 0011
    data_in_t = 4'b0011;
    sel_t     = 1;
    store_t   = 1;
    #5;

    store_t = 0;
    #5;

    // LOAD A = 0101
    data_in_t = 4'b0101;
    sel_t     = 0;
    store_t   = 1;
    #5;

    store_t = 0;
    #5;

    // COMPUTE 0101 + 0011 = 1000
    comp_t = 1;
    #5;

    comp_t = 0;
    #5;

    // FEEDBACK RESULT INTO A
    // data_in = 0000
    // A <= 0000 OR 1000 = 1000
    data_in_t = 4'b0000;
    fbk_t = 1;
    #5;

    fbk_t = 0;
    #5;

    // COMPUTE AGAIN
    // 1000 + 0011 = 1011
    comp_t = 1;
    #5;

    comp_t = 0;
    #5;

    // FEEDBACK RESULT INTO A
    // data_in = 1111
    // A <= 1111 OR 1011 = 1111
    data_in_t = 4'b1111;
    fbk_t = 1;
    #5;

    fbk_t = 0;
    #5;

    // COMPUTE AGAIN
    // 1111 + 0011 = 10010
    comp_t = 1;
    #5;

    comp_t = 0;
    #5;

    // LOAD A = 0011
    data_in_t = 4'b0011;
    sel_t     = 0;
    store_t   = 1;
    #5;

    store_t = 0;
    #5;

    // LOAD B = 0101
    data_in_t = 4'b0101;
    sel_t     = 1;
    store_t   = 1;
    #5;

    store_t = 0;
    #5;

    // SUBTRACTION
    // 0011 - 0101 = 1110 (-2)
    mode_t = 1;
    comp_t = 1;
    #5;

    comp_t = 0;
    #5;

    // LOAD A = 1001
    data_in_t = 4'b1001;
    sel_t     = 0;
    store_t   = 1;
    #5;

    store_t = 0;
    #5;

    // LOAD B = 0111
    data_in_t = 4'b0111;
    sel_t     = 1;
    store_t   = 1;
    #5;

    store_t = 0;
    #5;

    // SUBTRACTION
    // 1001 - 0111 = 0010 (2)
    mode_t = 1;
    comp_t = 1;
    #5;

    comp_t = 0;
    #5;

    // RESET
    reset_t = 1;
    #5;

    reset_t = 0;
    #5;

    $display("Simulation Complete!");
    $finish;

  end

endmodule

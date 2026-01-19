`include "r_a_mE.v"

module testbench;

  reg [3:0] data_in_t;
  reg sel_t;
  reg store_clkt;
  wire [3:0] d_ff1t;
  wire [3:0] d_ff2t;
  
  ram_engine dut(
    .data_in(data_in_t),
    .sel(sel_t),
    .store_clk(store_clkt),
    .d_ff1(d_ff1t),
    .d_ff2(d_ff2t)
  );

  initial begin

    $monitor("t=%0t | data_in = %b | sel_t = %b | store_t = %b | d_ff1t = %b | dff2t = %b", $time, data_in_t, sel_t, store_clkt, d_ff1t, d_ff2t);
    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    data_in_t = 4'b1011;
    store_clkt = 0;
    sel_t = 1;
    #5;

    data_in_t = 4'b1011;
    store_clkt = 1;
    sel_t = 1;
    #5;

    data_in_t = 4'b1000;
    store_clkt = 1;
    sel_t = 0;
    #5;

    data_in_t = 4'b1000;
    store_clkt = 0;
    sel_t = 0;
    #5;

    data_in_t = 4'b1000;
    store_clkt = 1;
    sel_t = 1;
    #5;

    data_in_t = 4'b1010;
    store_clkt = 0;
    sel_t = 0;
    #5;

    data_in_t = 4'b1010;
    store_clkt = 1;
    sel_t = 1;
    #5;

    data_in_t = 4'b0000;
    store_clkt = 0;
    sel_t = 1;
    #5;

    data_in_t = 4'b1100;
    store_clkt = 0;
    sel_t = 0;
    #5;

    data_in_t = 4'b1100;
    store_clkt = 1;
    sel_t = 0;
    #5;


    $display("Simulation Complete!");
    $finish;
  end
endmodule
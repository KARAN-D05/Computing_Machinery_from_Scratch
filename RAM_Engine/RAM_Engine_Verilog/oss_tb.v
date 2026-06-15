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
    .A(A_t),
    .B(B_t),
    .fbk(fbk_t)
  );

  initial begin

    $monitor("t=%0t | data_in = %b | fbk_in = %b | sel = %b | store = %b |reset = %b | fbk = %b | A = %b | B = %b", $time, data_in_t, fbk_in_t, sel_t, store_t, reset_t, fbk_t, A_t, B_t);
    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);
   
    data_in_t = 4'b1000;
    fbk_in_t = 4'b1111;
    store_t = 0;
    sel_t = 0;
    reset_t = 0;
    fbk_t = 0;
    #5;

    data_in_t = 4'b1000;
    fbk_in_t = 4'b1111;
    store_t = 1;
    sel_t = 0;
    reset_t = 0;
    fbk_t = 0;
    #5;

    data_in_t = 4'b1010;
    fbk_in_t = 4'b1111;
    store_t = 0;
    sel_t = 1;
    reset_t = 0;
    fbk_t = 0;
    #5;

    data_in_t = 4'b1010;
    fbk_in_t = 4'b1111;
    store_t = 1;
    sel_t = 1;
    reset_t = 0;
    fbk_t = 0;
    #5;

    data_in_t = 4'b1001;
    fbk_in_t = 4'b0110;
    store_t = 0;
    sel_t = 0;
    reset_t = 0;
    fbk_t = 1;
    #5;

    data_in_t = 4'b1001;
    fbk_in_t = 4'b0110;
    store_t = 1;
    sel_t = 0;
    reset_t = 0;
    fbk_t = 0;
    #5;

    data_in_t = 4'b1001;
    fbk_in_t = 4'b0110;
    store_t = 1;
    sel_t = 0;
    reset_t = 1;
    fbk_t = 0;
    #5;

    data_in_t = 4'b1001;
    fbk_in_t = 4'b0110;
    store_t = 1;
    sel_t = 0;
    reset_t = 0;
    fbk_t = 1;
    #5;  

    data_in_t = 4'b1111;
    fbk_in_t = 4'b1110;
    store_t = 0;
    sel_t = 1;
    reset_t = 0;
    fbk_t = 1;
    #5;

    data_in_t = 4'b1001;
    fbk_in_t = 4'b0110;
    store_t = 1;
    sel_t = 0;
    reset_t = 1;
    fbk_t = 0;
    #5;


    $display("Simulation Complete!");
    $finish;
  end
endmodule

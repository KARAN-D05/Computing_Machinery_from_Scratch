`include "au.v"

module testbench;

  reg [3:0] A_in;
  reg [3:0] B_in;
  reg mode;
  reg comp;
  reg reset;
  wire [3:0] out;
  wire carry;

  arithmetic_unit dut(
    .A_in(A_in),
    .B_in(B_in),
    .mode(mode),
    .comp(comp),
    .reset(reset),
    .out(out),
    .carry(carry)
  );

  initial begin

    $monitor("t = %0t | A_in = %b | B_in = %b | mode = %b | comp = %b | out = %b | carry = %b | reset = %b", $time, A_in, B_in, mode, comp, out, carry, reset);
    $dumpfile("Sim.vcd");
    $dumpvars(0,testbench);

    A_in = 0001;
    B_in = 0001;
    mode = 0;
    comp = 0;
    reset = 0;
    #5;

    comp = 1;
    #5;

    A_in = 0100;
    B_in = 0001;
    mode = 1;
    comp = 0;
    reset = 0;
    #5;

    comp = 1;
    #5;

    A_in = 0001;
    B_in = 0010;
    mode = 1;
    comp = 0;
    reset = 0;
    #5;

    comp = 1;
    #5;

    A_in = 1100;
    B_in = 1101;
    mode = 0;
    comp = 0;
    reset = 0;
    #5;

    comp = 1;
    #5;

    reset = 1;
    #5;

   $display("Simulation Complete!");
   $finish;

  end

endmodule

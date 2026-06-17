`include "fbk.v"

module testbench;

  reg [3:0] in;
  reg fbk;
  wire [3:0] out;

  feedback_system dut(
    .in(in),
    .fbk(fbk),
    .out(out)
  );

  initial begin

    $monitor("t=%0t | in = %b | fbk = %b | out = %b", $time, in, fbk, out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    in = 4'b1010;
    fbk = 1'b0;
    #5;

    in = 4'b1010;
    fbk = 1'b1;
    #5;

    in = 4'b1111;
    fbk = 1'b0;
    #5;

    in = 4'b1110;
    fbk = 1'b1;
    #5;

    $display("Simulation Complete!");
    $finish;
    
  end

endmodule

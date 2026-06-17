`include "oss.v"
`include "au.v"
`include "fbk.v"

module system(
    input [3:0] data_in,
    input store,
    input sel,
    input fbk,
    input reset,
    input mode,
    input comp,
    output carry,
    output [3:0] out
);

  wire [3:0] A_int, B_int, fbk_in;

  operand_storage_system oss(
    .data_in(data_in),
    .store(store),
    .sel(sel),
    .fbk(fbk),
    .reset(reset),
    .A(A_int),
    .B(B_int),
    .fbk_in(fbk_in)
  );

  arithmetic_unit au(
    .A_in(A_int),
    .B_in(B_int),
    .mode(mode),
    .comp(comp),
    .reset(reset),
    .out(out),
    .carry(carry)
  );

  feedback_system fbks(
    .in(out),
    .fbk(fbk),
    .out(fbk_in)
  );

endmodule

module feedback_system(
    input [3:0] in,
    input fbk,
    output [3:0] out
);

assign out[0] = in[0] & fbk;
assign out[1] = in[1] & fbk;
assign out[2] = in[2] & fbk;
assign out[3] = in[3] & fbk;

endmodule

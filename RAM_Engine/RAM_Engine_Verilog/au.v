module arithmetic_unit(
    input [3:0] A_in,
    input [3:0] B_in,
    input mode,
    input comp,
    input reset,
    output reg [3:0] out,
    output reg carry
);

// 2's Complement

wire Bw1, Bw2, Bw4, Bw8;
assign Bw1 = B_in[0] ^ mode;
assign Bw2 = B_in[1] ^ mode;
assign Bw4 = B_in[2] ^ mode;
assign Bw8 = B_in[3] ^ mode;

wire [3:0] B_cin;
assign B_cin[3] = Bw8;
assign B_cin[2] = Bw4;
assign B_cin[1] = Bw2;
assign B_cin[0] = Bw1;

// Arithmetic
wire [4:0] comp_res;
assign comp_res = A_in + B_cin + mode;

// Output
always@(posedge comp or posedge reset) begin

    if (reset) begin
        out <= 4'b0000;
        carry <= 1'b0;
    end
     
    else begin
       out <= comp_res[3:0];
       carry <= comp_res[4];
    end

 end

endmodule

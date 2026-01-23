module ram_engine(
    input  [3:0] data_in,
    input        sel,
    input        store_clk,   // manual clock
    input        reset,       // async reset
    output reg [3:0] d_ff1,
    output reg [3:0] d_ff2
);

always @(posedge store_clk or posedge reset) begin
    if (reset) begin
        d_ff1 <= 4'b0000;
        d_ff2 <= 4'b0000;
    end else begin
        if (sel)
            d_ff2 <= data_in;
        else
            d_ff1 <= data_in;
    end
end

endmodule
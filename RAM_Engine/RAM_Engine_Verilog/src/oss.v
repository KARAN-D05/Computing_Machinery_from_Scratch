module operand_storage_system(
    input [3:0] data_in,
    input [3:0] fbk_in,

    input store,
    input sel,
    input fbk,
    input reset,

    output reg [3:0] A,
    output reg [3:0] B
);

wire event_clk;
assign event_clk = store | fbk;

always @(posedge event_clk or posedge reset) begin

    if(reset) begin
        A <= 4'b0000;
        B <= 4'b0000;
    end

    else begin

        if(sel & ~fbk) begin
            B <= data_in;
        end

        else if(~ sel) begin
            A <= data_in | fbk_in;
        end

    end

end

endmodule

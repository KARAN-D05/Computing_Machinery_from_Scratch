module operand_storage_system(
    input wire clk,
    input wire reset,

    input wire store,
    input wire sel,
    input wire fbk,

    input wire [3:0] data_in,
    input wire [3:0] fbk_in,

    output reg [3:0] A,
    output reg [3:0] B
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        A <= 4'b0000;
        B <= 4'b0000;
    end
    else if (store) begin

        // Store into B
        if (sel)
            B <= data_in;

        // Feedback mode
        else if (fbk)
            A <= data_in | fbk_in;

        // Normal load into A
        else
            A <= data_in;

    end
end

endmodule

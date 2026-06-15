module operand_storage_system(
    input [3:0] data_in,
    input fbk,          // feed output into A
    input sel,  
    input [3:0] fbk_in,
    input store,        // manual clock
    input reset,        // async reset
    output reg [3:0] A,
    output reg [3:0] B
);

always @(posedge store or posedge reset or posedge fbk) begin
    if (reset) begin
        A <= 4'b0000;
        B <= 4'b0000;
    end else begin
        if (sel & store)
            B <= data_in;
        else if (~fbk & ~sel & store)
            A <= data_in;
        else if (fbk & ~sel & ~store)
            A <= fbk_in;
        else if (fbk & ~sel & store)
            A <= (data_in | fbk_in);
    end
end

endmodule

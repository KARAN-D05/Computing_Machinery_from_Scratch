module ram_engine(
    input [3:0] data_in,    // Input Pins
    input sel,              // Selector Pin
    input store_clk,        // Store Pin / Manual Clock
    output reg [3:0] d_ff1, // Edge-Triggered Manually Controlled Flip-Flops
    output reg [3:0] d_ff2
);

  // Initializing flip-flops to Zero
  initial d_ff1 = 4'h0;  
  initial d_ff2 = 4'h0;
  
    always@ (posedge store_clk) begin // Positive-Edge Trigger
    if (sel == 1  & store_clk == 1) begin
        d_ff2 = data_in;
    end else if (sel == 0 & store_clk == 1) begin
        d_ff1 = data_in;
    end
  end
endmodule

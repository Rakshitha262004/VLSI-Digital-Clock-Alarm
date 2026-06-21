//=============================================================
// Module: clock_divider
// Purpose: Converts 50MHz board clock into a 1Hz tick pulse
//=============================================================
module clock_divider #(
    parameter integer CLK_FREQ = 50_000_000  // 50 MHz input clock
)(
    input  wire clk,
    input  wire rst,
    output reg  tick_1hz
);

    reg [25:0] count; // enough bits to count up to 50,000,000

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count    <= 26'd0;
            tick_1hz <= 1'b0;
        end else begin
            if (count == (CLK_FREQ/2 - 1)) begin // toggle every half-second for 1Hz square wave
                count    <= 26'd0;
                tick_1hz <= ~tick_1hz;
            end else begin
                count    <= count + 1'b1;
                tick_1hz <= tick_1hz;
            end
        end
    end

endmodule
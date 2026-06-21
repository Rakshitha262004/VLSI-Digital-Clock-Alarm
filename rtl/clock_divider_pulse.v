//=============================================================
// Module: clock_divider_pulse
// Purpose: Generates a single-clock-cycle pulse every 1 second
//=============================================================
module clock_divider_pulse #(
    parameter integer CLK_FREQ = 50_000_000
)(
    input  wire clk,
    input  wire rst,
    output reg  tick_1hz   // 1-cycle-wide pulse, once per second
);

    reg [25:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count    <= 26'd0;
            tick_1hz <= 1'b0;
        end else if (count == CLK_FREQ - 1) begin
            count    <= 26'd0;
            tick_1hz <= 1'b1;   // pulse high for exactly 1 cycle
        end else begin
            count    <= count + 1'b1;
            tick_1hz <= 1'b0;
        end
    end

endmodule
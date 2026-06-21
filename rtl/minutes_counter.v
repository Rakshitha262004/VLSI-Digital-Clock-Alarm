//=============================================================
// Module: minutes_counter
// Purpose: Mod-60 counter for minutes, enabled by seconds carry
//=============================================================
module minutes_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       sec_carry,   // enable: pulses once per minute rollover
    output reg  [5:0] min,         // 0-59
    output reg         min_carry
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            min       <= 6'd0;
            min_carry <= 1'b0;
        end else if (sec_carry) begin
            if (min == 6'd59) begin
                min       <= 6'd0;
                min_carry <= 1'b1;
            end else begin
                min       <= min + 1'b1;
                min_carry <= 1'b0;
            end
        end else begin
            min_carry <= 1'b0;
        end
    end

endmodule
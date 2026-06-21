//=============================================================
// Module: seconds_counter
// Purpose: Mod-60 counter for seconds (0-59), asserts carry on rollover
//=============================================================
module seconds_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick,        // 1Hz enable pulse
    output reg  [5:0] sec,         // 0-59
    output reg         sec_carry    // pulses high for 1 cycle when 59->0
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sec       <= 6'd0;
            sec_carry <= 1'b0;
        end else if (tick) begin
            if (sec == 6'd59) begin
                sec       <= 6'd0;
                sec_carry <= 1'b1;
            end else begin
                sec       <= sec + 1'b1;
                sec_carry <= 1'b0;
            end
        end else begin
            sec_carry <= 1'b0; // ensure carry is only 1 cycle wide
        end
    end

endmodule
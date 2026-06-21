//=============================================================
// Module: hours_counter
// Purpose: Mod-24 counter for hours (0-23), enabled by minutes carry
//=============================================================
module hours_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       min_carry,
    output reg  [4:0] hour          // 0-23
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hour <= 5'd0;
        end else if (min_carry) begin
            if (hour == 5'd23) begin
                hour <= 5'd0;
            end else begin
                hour <= hour + 1'b1;
            end
        end
    end

endmodule
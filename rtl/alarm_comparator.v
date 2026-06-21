//=============================================================
// Module: alarm_comparator
// Purpose: Stores alarm time and compares against current time
//=============================================================
module alarm_comparator (
    input  wire       clk,
    input  wire       rst,
    input  wire       set_alarm,     // pulse to latch new alarm time
    input  wire [4:0] alarm_hr_in,
    input  wire [5:0] alarm_min_in,
    input  wire       alarm_enable,
    input  wire [4:0] cur_hour,
    input  wire [5:0] cur_min,
    input  wire [5:0] cur_sec,
    output reg  [4:0] alarm_hour,
    output reg  [5:0] alarm_min,
    output reg         alarm_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alarm_hour <= 5'd0;
            alarm_min  <= 6'd0;
        end else if (set_alarm) begin
            alarm_hour <= alarm_hr_in;
            alarm_min  <= alarm_min_in;
        end
    end

    // Combinational comparator, gated by enable.
    // Also gated by cur_sec==0 so alarm_out pulses only once (at the start of the matching minute)
    // instead of staying high for 60 seconds. Remove the sec check if a sustained alarm is desired.
    always @(*) begin
        if (alarm_enable &&
            (cur_hour == alarm_hour) &&
            (cur_min  == alarm_min)  &&
            (cur_sec  == 6'd0))
            alarm_out = 1'b1;
        else
            alarm_out = 1'b0;
    end

endmodule
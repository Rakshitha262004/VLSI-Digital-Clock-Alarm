//=============================================================
// Module: top_digital_clock
// Purpose: Top-level integration of digital clock with alarm
//=============================================================
module top_digital_clock (
    input  wire       clk,           // 50MHz board clock
    input  wire       rst,           // active-high reset
    input  wire       set_alarm,     // pulse to latch alarm time
    input  wire [4:0] alarm_hr_in,
    input  wire [5:0] alarm_min_in,
    input  wire       alarm_enable,

    output wire [4:0] hour_out,
    output wire [5:0] min_out,
    output wire [5:0] sec_out,
    output wire        alarm_out,
    output wire [6:0]  seg,
    output wire [5:0]  an
);

    wire tick_1hz;
    wire sec_carry;
    wire min_carry;

    clock_divider_pulse #(.CLK_FREQ(50_000_000)) u_clkdiv (
        .clk      (clk),
        .rst      (rst),
        .tick_1hz (tick_1hz)
    );

    seconds_counter u_sec (
        .clk       (clk),
        .rst       (rst),
        .tick      (tick_1hz),
        .sec       (sec_out),
        .sec_carry (sec_carry)
    );

    minutes_counter u_min (
        .clk       (clk),
        .rst       (rst),
        .sec_carry (sec_carry),
        .min       (min_out),
        .min_carry (min_carry)
    );

    hours_counter u_hour (
        .clk       (clk),
        .rst       (rst),
        .min_carry (min_carry),
        .hour      (hour_out)
    );

    alarm_comparator u_alarm (
        .clk          (clk),
        .rst          (rst),
        .set_alarm    (set_alarm),
        .alarm_hr_in  (alarm_hr_in),
        .alarm_min_in (alarm_min_in),
        .alarm_enable (alarm_enable),
        .cur_hour     (hour_out),
        .cur_min      (min_out),
        .cur_sec      (sec_out),
        .alarm_hour   (),
        .alarm_min    (),
        .alarm_out    (alarm_out)
    );

    display_mux u_disp (
        .clk  (clk),
        .rst  (rst),
        .hour (hour_out),
        .min  (min_out),
        .sec  (sec_out),
        .seg  (seg),
        .an   (an)
    );

endmodule

//=============================================================
// Testbench: tb_top_digital_clock
// Purpose: Verifies clock divider, counter rollovers, and alarm match
// NOTE: Uses a SMALL CLK_FREQ override so simulation finishes in
//       reasonable time instead of waiting for a real 50MHz/1Hz divide.
//=============================================================
`timescale 1ns/1ps

module tb_top_digital_clock;

    reg        clk;
    reg        rst;
    reg        set_alarm;
    reg  [4:0] alarm_hr_in;
    reg  [5:0] alarm_min_in;
    reg        alarm_enable;

    wire [4:0] hour_out;
    wire [5:0] min_out;
    wire [5:0] sec_out;
    wire       alarm_out;
    wire [6:0] seg;
    wire [5:0] an;

    // ---------------------------------------------------------
    // Instantiate DUT with a SMALL clock divider value so that
    // 1 "second" = a handful of clock cycles instead of 50 million.
    // This keeps simulation time practical. For real synthesis,
    // top_digital_clock defaults to 50_000_000.
    // ---------------------------------------------------------
    // To override, we instantiate a custom top using a small divider
    // directly here for verification speed:

    wire tick_1hz;
    wire sec_carry, min_carry;

    clock_divider_pulse #(.CLK_FREQ(10)) u_clkdiv ( // 10 cycles = 1 "second" for sim speed
        .clk      (clk),
        .rst      (rst),
        .tick_1hz (tick_1hz)
    );

    seconds_counter u_sec (
        .clk(clk), .rst(rst), .tick(tick_1hz),
        .sec(sec_out), .sec_carry(sec_carry)
    );

    minutes_counter u_min (
        .clk(clk), .rst(rst), .sec_carry(sec_carry),
        .min(min_out), .min_carry(min_carry)
    );

    hours_counter u_hour (
        .clk(clk), .rst(rst), .min_carry(min_carry),
        .hour(hour_out)
    );

    alarm_comparator u_alarm (
        .clk(clk), .rst(rst), .set_alarm(set_alarm),
        .alarm_hr_in(alarm_hr_in), .alarm_min_in(alarm_min_in),
        .alarm_enable(alarm_enable),
        .cur_hour(hour_out), .cur_min(min_out), .cur_sec(sec_out),
        .alarm_hour(), .alarm_min(), .alarm_out(alarm_out)
    );

    display_mux u_disp (
        .clk(clk), .rst(rst),
        .hour(hour_out), .min(min_out), .sec(sec_out),
        .seg(seg), .an(an)
    );

    // ---------------- Clock generation: 10ns period ----------------
    initial clk = 0;
    always #5 clk = ~clk;

    // ---------------- Stimulus ----------------
    initial begin
        $dumpfile("digital_clock.vcd");
        $dumpvars(0, tb_top_digital_clock);

        // 1. Reset test
        rst          = 1;
        set_alarm    = 0;
        alarm_hr_in  = 0;
        alarm_min_in = 0;
        alarm_enable = 0;
        #20;
        rst = 0;
        $display("T=%0t : RESET RELEASED. hour=%0d min=%0d sec=%0d", $time, hour_out, min_out, sec_out);

        // 2. Time increment test - let it run and watch seconds tick
        #200;
        $display("T=%0t : TIME CHECK hour=%0d min=%0d sec=%0d", $time, hour_out, min_out, sec_out);

        // 3. Set an alarm for hour=0 min=1 (reachable quickly in sim)
        alarm_hr_in  = 5'd0;
        alarm_min_in = 6'd1;
        alarm_enable = 1;
        set_alarm    = 1;
        #10;
        set_alarm = 0;
        $display("T=%0t : ALARM SET to %0d:%0d, enable=%0b", $time, alarm_hr_in, alarm_min_in, alarm_enable);

        // 4. Let simulation run long enough to reach minute rollover and alarm match
        //    With CLK_FREQ=10 (10ns each), 1 "second" = 100ns, 1 "minute" = 6000ns
        #7000;
        $display("T=%0t : POST-ALARM-WINDOW CHECK hour=%0d min=%0d sec=%0d alarm_out=%0b",
                   $time, hour_out, min_out, sec_out, alarm_out);

        // 5. Alarm disable test - confirm alarm_out drops when disabled
        alarm_enable = 0;
        #200;
        $display("T=%0t : ALARM DISABLED CHECK alarm_out=%0b (expect 0)", $time, alarm_out);

        // 6. Re-enable and check alarm fires again next match (after hour rollover would be too long;
        //    instead re-set alarm to current near-future time for a fast re-check)
        alarm_hr_in  = hour_out;
        alarm_min_in = min_out + 1;
        alarm_enable = 1;
        set_alarm    = 1;
        #10;
        set_alarm = 0;
        #7000;
        $display("T=%0t : SECOND ALARM CHECK hour=%0d min=%0d sec=%0d alarm_out=%0b",
                   $time, hour_out, min_out, sec_out, alarm_out);

        $display("=== SIMULATION COMPLETE ===");
        $finish;
    end

    // ---------------- Continuous monitor ----------------
    initial begin
        $monitor("T=%0t | rst=%b | H:M:S = %0d:%0d:%0d | alarm_en=%b | alarm_out=%b",
                  $time, rst, hour_out, min_out, sec_out, alarm_enable, alarm_out);
    end

endmodule
# Project Report: VLSI-Based Digital Clock with Alarm Functionality

## 1. Project Objective
To design, implement, and verify a synthesizable digital clock system in
Verilog that maintains accurate 24-hour timekeeping, supports a
user-configurable alarm, and drives a seven-segment display — demonstrating
core VLSI/RTL design and verification skills.

## 2. Digital Clock Concept
A digital clock converts a fixed-frequency input clock signal into
human-readable time units (hours, minutes, seconds) using a chain of
modulo counters. Unlike a mechanical clock, all timekeeping logic is
implemented as synchronous digital circuitry, making it directly portable
to ASIC or FPGA silicon.

## 3. Counter Design
Three cascaded counters form the timekeeping core:
- **Seconds counter:** mod-60, increments on each 1Hz tick, asserts a
  1-cycle carry pulse on 59→0 rollover.
- **Minutes counter:** mod-60, increments only when the seconds carry
  pulses, asserts its own carry on 59→0 rollover.
- **Hours counter:** mod-24, increments only when the minutes carry
  pulses, wraps from 23 back to 0.

This carry-cascade approach mirrors how ripple/cascade counters work in
real RTC hardware and avoids the need for a single large divide-by-86400
counter, which would be far less modular and harder to verify.

## 4. Alarm Comparator Logic
An alarm register latches a user-supplied hour and minute on a `set_alarm`
pulse. A combinational comparator continuously evaluates equality between
the live time counters and the alarm register. The comparator is gated by
an `alarm_enable` signal so the alarm can be armed/disarmed without
clearing the stored time, and is further gated by `cur_sec==0` so the
output is a clean single pulse rather than a 60-second-long level.

## 5. Seven-Segment Decoder Logic
Each of the six display digits (H-tens, H-ones, M-tens, M-ones, S-tens,
S-ones) is derived via integer division/modulo from the binary counter
values, then converted to a 7-bit segment pattern via a combinational
lookup table. A multiplexer cycles through all six digits at a rate fast
enough (~1kHz refresh) to appear continuously lit to the human eye, while
using only one shared set of segment output pins.

## 6. RTL Explanation
The design follows a strict single-responsibility module hierarchy:
clock division, each counter stage, the alarm comparator, the segment
decoder, and the display multiplexer are all independent modules,
integrated in a single `top_digital_clock` module. This structure makes
each block independently testable and reusable in other timing-based
designs (e.g., reaction timers, countdown timers).

## 7. Testbench Explanation
The testbench applies an asynchronous reset, observes free-running time
increment, programs an alarm for a near-future time, and confirms the
`alarm_out` pulse appears at the correct moment and only while
`alarm_enable` is high. A reduced `CLK_FREQ` parameter is used during
simulation so that minute-level events occur within a practical simulation
time window, while the synthesizable RTL retains the real 50MHz/100MHz
default for hardware deployment.

## 8. Waveform Results
Simulation waveforms confirm:
- Correct 1-second tick generation from the clock divider
- Accurate mod-60/mod-60/mod-24 rollover behavior with correctly
  cascaded single-cycle carry pulses
- Alarm output asserting precisely on time match and remaining
  suppressed when disabled

## 9. Synthesis Report Discussion
Vivado synthesis confirms the design maps cleanly to FPGA fabric using a
small number of LUTs and flip-flops, consistent with the simplicity of
counter and comparator logic. Timing analysis shows the design comfortably
meets setup/hold requirements at the target clock frequency, since none of
the combinational paths (comparator, decoder) are deep enough to be
critical at typical FPGA speeds.

## 10. Conclusion
This project demonstrates a complete, modular, and verifiable digital
clock with alarm functionality, covering the full RTL design flow from
specification through simulation to FPGA-ready synthesis. It reinforces
core VLSI principles — synchronous counter design, carry cascading,
combinational comparison, and display multiplexing — that directly apply
to real-world timekeeping ICs and embedded timing peripherals.
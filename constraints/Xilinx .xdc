## ===========================================================
## Constraints file: digital_clock.xdc
## Target board: Digilent Basys 3 (Artix-7)
## ===========================================================

## Clock signal - 100MHz on Basys 3 (adjust CLK_FREQ param in RTL accordingly)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset - using a slide switch
set_property PACKAGE_PIN V17 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Alarm enable switch
set_property PACKAGE_PIN V16 [get_ports alarm_enable]
set_property IOSTANDARD LVCMOS33 [get_ports alarm_enable]

## Set-alarm pushbutton
set_property PACKAGE_PIN T18 [get_ports set_alarm]
set_property IOSTANDARD LVCMOS33 [get_ports set_alarm]

## Alarm hour input switches (5 bits)
set_property PACKAGE_PIN V2 [get_ports {alarm_hr_in[0]}]
set_property PACKAGE_PIN T3 [get_ports {alarm_hr_in[1]}]
set_property PACKAGE_PIN T2 [get_ports {alarm_hr_in[2]}]
set_property PACKAGE_PIN R3 [get_ports {alarm_hr_in[3]}]
set_property PACKAGE_PIN W2 [get_ports {alarm_hr_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {alarm_hr_in[*]}]

## Alarm minute input switches (6 bits)
set_property PACKAGE_PIN U1 [get_ports {alarm_min_in[0]}]
set_property PACKAGE_PIN T1 [get_ports {alarm_min_in[1]}]
set_property PACKAGE_PIN R2 [get_ports {alarm_min_in[2]}]
set_property PACKAGE_PIN W11 [get_ports {alarm_min_in[3]}]
set_property PACKAGE_PIN V11 [get_ports {alarm_min_in[4]}]
set_property PACKAGE_PIN V10 [get_ports {alarm_min_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {alarm_min_in[*]}]

## Seven-segment display segments (a-g)
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

## Digit anode select (6 digits)
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property PACKAGE_PIN W7 [get_ports {an[4]}]
set_property PACKAGE_PIN W8 [get_ports {an[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

## Alarm output LED
set_property PACKAGE_PIN U16 [get_ports alarm_out]
set_property IOSTANDARD LVCMOS33 [get_ports alarm_out]
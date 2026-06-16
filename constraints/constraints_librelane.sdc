############
## Global ##
############

source instances.tcl


#############################
## Driving Cells and Loads ##
#############################

set_driving_cell [all_inputs] -lib_cell sg13g2_IOPadOut16mA -pin pad


##################
## Input Clocks ##
##################
puts "Clocks..."

set TCK_SYS $::env(CLOCK_PERIOD)
create_clock -name clk_sys -period $TCK_SYS [get_ports clk_i]

set TCK_JTG 25.0
create_clock -name clk_jtg -period $TCK_JTG [get_ports jtag_tck_i]

set TCK_RTC 50.0
create_clock -name clk_rtc -period $TCK_RTC [get_ports ref_clk_i]


##################################
## Clock Groups & Uncertainties ##
##################################

# Define which clocks are asynchronous to each other
# If you have added a clock it is a good idea to temporarily add -allow_paths.
# This means the paths between clocks (CDC) are timed and will show up as violations,
# making them very easy to find and write constraints for.
set_clock_groups -asynchronous -name clk_groups_async \
     -group {clk_rtc} \
     -group {clk_jtg} \
     -group {clk_sys}

# We set reasonable uncertainties in their transistion timing
# and transition (rise/fall) times for all clocks (ns)
set_clock_uncertainty $::env(CLOCK_UNCERTAINTY_CONSTRAINT) [all_clocks]
set_clock_transition $::env(CLOCK_TRANSITION_CONSTRAINT) [all_clocks]


####################
## Cdcs and Syncs ##
####################
puts "CDC/Sync..."

# Clock Domain Crossings: paths going from an FF with one clock to an FF with another.
# The setup/hold checks on these paths are deactivated by set_clock_groups -asynchronous.
# An additional requirement is that the max delay is below min($TCK_SYS, $TCK_JTG) 
# to make sure any change propages within one cycle of either clock.
# An (optional) lower delay is better for metastability recovery -> 3ns as a reasonable goal

## Constrain `cdc_2phase` for DMI request
set_max_delay 3.0 -from $JTAG_ASYNC_REQ_START -to $JTAG_ASYNC_REQ_END -ignore_clock_latency

# Constrain `cdc_2phase` for DMI response
set_max_delay 3.0 -from $JTAG_ASYNC_RSP_START -to $JTAG_ASYNC_RSP_END -ignore_clock_latency


#############
## SoC Ins ##
#############
puts "Input/Outputs..."

# Reset should propagate to system domain within a clock cycle.
set_input_delay -max [ expr $TCK_JTG * 0.10 ] [get_ports {rst_ni testmode_i}]  
set_false_path -hold   -from [get_ports {rst_ni testmode_i}]
set_max_delay $TCK_SYS -from [get_ports {rst_ni testmode_i}]


##########
## JTAG ##
##########
puts "JTAG..."

set_input_delay  -min -add_delay -clock clk_jtg [ expr $TCK_JTG * 0.10 ] [get_ports {jtag_tdi_i jtag_tms_i}]
set_input_delay  -max -add_delay -clock clk_jtg [ expr $TCK_JTG * 0.30 ] [get_ports {jtag_tdi_i jtag_tms_i}]
set_output_delay -min -add_delay -clock clk_jtg [ expr $TCK_JTG * 0.10 ] [get_ports jtag_tdo_o]
set_output_delay -max -add_delay -clock clk_jtg [ expr $TCK_JTG * 0.20 ] [get_ports jtag_tdo_o]

# Reset should propagate to system domain within a clock cycle.
set_input_delay -max [ expr $TCK_JTG * 0.10 ] [get_ports jtag_trst_ni]  
set_false_path -hold    -from [get_ports jtag_trst_ni]
set_max_delay $TCK_JTG  -from [get_ports jtag_trst_ni]


##########
## GPIO ##
##########
puts "GPIO..."

set_input_delay  -min -add_delay -clock clk_sys [ expr $TCK_SYS * 0.10 ] [get_ports {gpio*}]
set_input_delay  -max -add_delay -clock clk_sys [ expr $TCK_SYS * 0.30 ] [get_ports {gpio*}]

set_output_delay -min -add_delay -clock clk_sys [ expr $TCK_SYS * 0.10 ] [get_ports {gpio*}]
set_output_delay -max -add_delay -clock clk_sys [ expr $TCK_SYS * 0.30 ] [get_ports {gpio*}]

# The timing of these signals are not important but we want to keep them in-cycle
set_output_delay -min -add_delay -clock clk_sys [ expr $TCK_SYS * 0.10 ] [get_ports {status_o unused*}]
set_output_delay -max -add_delay -clock clk_sys [ expr $TCK_SYS * 0.10 ] [get_ports {status_o unused*}]


##########
## UART ##
##########
puts "UART..."

set_input_delay  -min -add_delay -clock clk_sys [ expr $TCK_SYS * 0.10 ] [get_ports uart_rx_i]
set_input_delay  -max -add_delay -clock clk_sys [ expr $TCK_SYS * 0.30 ] [get_ports uart_rx_i]
set_output_delay -min -add_delay -clock clk_sys [ expr $TCK_SYS * 0.10 ] [get_ports uart_tx_o]
set_output_delay -max -add_delay -clock clk_sys [ expr $TCK_SYS * 0.30 ] [get_ports uart_tx_o]

# Backend constraints

##################
## Input Clocks ##
##################
puts "Clocks..."

set TCK_SYS $::env(CLOCK_PERIOD)
create_clock -name clk_sys -period $TCK_SYS [get_ports clk_i]

set_clock_uncertainty $::env(CLOCK_UNCERTAINTY_CONSTRAINT) [all_clocks]
set_clock_transition $::env(CLOCK_TRANSITION_CONSTRAINT) [all_clocks]

#############
## SoC Ins ##
#############
puts "Input/Outputs..."

set output_ports [all_outputs]
set_output_delay -min -add_delay -clock clk_sys [ expr $TCK_SYS * 0.20 ] [get_ports $output_ports]
set_output_delay -max -add_delay -clock clk_sys [ expr $TCK_SYS * 0.30 ] [get_ports $output_ports]

set clk_input [get_port clk_i]
set clk_indx [lsearch [all_inputs] $clk_input]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx ""]
set rst_input [get_port rst_ni]
set rst_indx [lsearch [all_inputs] $rst_input]
set all_inputs_wo_clk_rst [lreplace $all_inputs_wo_clk $rst_indx $rst_indx ""]
set input_ports $all_inputs_wo_clk_rst

set_input_delay  -min -add_delay -clock clk_sys [ expr $TCK_SYS * 0.20 ] $input_ports
set_input_delay  -max -add_delay -clock clk_sys [ expr $TCK_SYS * 0.30 ] $input_ports

# "Disable" timing on pseudo-static signals (all interrupts are level-triggered)
set_max_delay $TCK_SYS -from [get_ports {rst_ni boot_addr_i* fetch_enable_i test_enable_i irqs_i* timer_irq_i software_irq_i}]
set_false_path -hold -from [get_ports {rst_ni boot_addr_i* fetch_enable_i test_enable_i irqs_i* timer_irq_i software_irq_i}]


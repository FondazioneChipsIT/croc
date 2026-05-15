# Copyright 2024 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Authors:
# - Philippe Sauter <phsauter@iis.ee.ethz.ch>

# Backend constraints

############
## Global ##
############

source src/instances.tcl


##################
## Input Clocks ##
##################
puts "Clocks..."

# We target 100 MHz
set TCK_SYS 10.0
create_clock -name clk_sys -period $TCK_SYS [get_ports clk_i]

set_clock_uncertainty 0.1 [all_clocks]
set_clock_transition 0.2 [all_clocks]

#############
## SoC Ins ##
#############
puts "Input/Outputs..."

set_ideal_network [get_ports rst_ni]
set_ideal_network [get_ports clk_i ]

set dont_touch_signals {rst_ni clk_i}

set output_ports [all_outputs]
set_output_delay [expr {$TCK_SYS * 0.15}] -clock clk_sys [get_ports $output_ports]

#set input_ports [remove_from_collection [all_inputs] $dont_touch_signals]
set input_ports [all_inputs]

set_input_delay [expr {$TCK_SYS * 0.15}] -clock clk_sys [get_ports $input_ports]

set_false_path -hold -through [get_ports $input_ports] -through [get_ports $output_ports]

# "Disable" timing on pseudo-static signals
set_max_delay $TCK_SYS -through [get_ports {boot_addr_i* fetch_enable_i test_enable_i}]
set_false_path -hold -through [get_ports {boot_addr_i* fetch_enable_i test_enable_i}]



# Copyright 2023 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Authors:
# - Tobias Senti      <tsenti@ethz.ch>
# - Jannis Schönleber <janniss@iis.ee.ethz.ch>
# - Philippe Sauter   <phsauter@iis.ee.ethz.ch>

# Stage 06: Static Timing Analysis

###############################################################################
# Setup
###############################################################################
source scripts/startup.tcl

# Load checkpoint from previous stage
#load_checkpoint 05_${proj_name}.final

# Set layers used for estimate_parasitics
#setDefaultParasitics
#set_dont_use $dont_use_cells


utl::report "###############################################################################"
utl::report "# Stage 06: Static Timing Analysis"
utl::report "###############################################################################"

read_verilog $netlist
link_design $top_design
read_sdf -corner tt ${out_dir}/${proj_name}.sdf
read_spef -corner tt ${out_dir}/${proj_name}.spef  
read_sdc src/constraints.sdc
report_checks -path_delay max > ${verif_dir}/timing.rpt

utl::report "###############################################################################"
utl::report "# Stage 06 complete: Static Timing Analysis performed"
utl::report "###############################################################################"

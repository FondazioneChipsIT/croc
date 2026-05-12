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
load_checkpoint 05_${proj_name}.final

utl::report "###############################################################################"
utl::report "# Stage 06: Static Timing Analysis"
utl::report "###############################################################################"

read_sdf -corner tt ${out_dir}/${proj_name}.sdf
read_spef -corner tt ${out_dir}/${proj_name}.spef  
read_sdc src/constraints.sdc
report_metrics "06_${proj_name}.sta"
exec cp ${report_dir}/06_${proj_name}.sta.rpt ${verif_dir}/sta.rpt

utl::report "###############################################################################"
utl::report "# Stage 06 complete: Static Timing Analysis performed"
utl::report "###############################################################################"

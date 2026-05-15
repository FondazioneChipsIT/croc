# Copyright 2023 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Authors:
# - Tobias Senti <tsenti@ethz.ch>
# - Jannis Schönleber <janniss@iis.ee.ethz.ch>
# - Philippe Sauter   <phsauter@iis.ee.ethz.ch>

# Power planning

utl::report "Power Grid"
# ToDo: Check connectivity on left and right power pad cells
source scripts/floorplan_util.tcl

##########################################################################
# Reset
##########################################################################

if {[info exists power_grid_defined]} {
    pdngen -ripup
    pdngen -reset
} else {
    set power_grid_defined 1
}


##########################################################################
##  Power settings
##########################################################################
# Core Power Ring
## Space between pads and core -> used for power ring
set PowRingSpace  35
## Spacing must meet TM2 rules
set pgcrSpacing 4
## Width must meet TM2 rules
set pgcrWidth 8
## Offset from core to power ring
set pgcrOffset [expr ($PowRingSpace - $pgcrSpacing - 2 * $pgcrWidth) / 2]

# TopMetal1 Core Power Grid
set tpg1Width     3; # arbitrary number
set tpg1Pitch   228; # multiple of pad-pitch
set tpg1Spacing  60; # big enough to skip over a pad
set tpg1Offset   97; # offset from leftX of core

# Macro Power Rings -> M3 and M2
## Spacing must be larger than pitch of M2/M3
set mprSpacing 0.6
## Width
set mprWidth 2
## Offset from Macro to power ring
set mprOffsetX 2.4
set mprOffsetY 0.6

# macro power grid (stripes on TopMetal1/TopMetal2 depending on orientation)
set mpgWidth 3
set mpgSpacing 4
set mpgOffset 20; # arbitrary

##########################################################################
##  Core Power
##########################################################################
# Top 1 - Top 2
add_pdn_ring -grid {core_grid} \
   -layer        {TopMetal1 TopMetal2} \
   -widths       "$pgcrWidth $pgcrWidth" \
   -spacings     "$pgcrSpacing $pgcrSpacing" \
   -core_offsets "$pgcrOffset $pgcrOffset" \
   -add_connect                       


# M1 Standardcell Rows (tracks)
add_pdn_stripe -grid {core_grid} -layer {Metal1} -width {0.32} -offset {0} \
               -followpins -extend_to_core_ring


# Top power grid
# Top 1 Stripe
add_pdn_stripe  -grid {core_grid} -layer {TopMetal1} -width $tpg1Width \
                -pitch $tpg1Pitch -spacing $tpg1Spacing -offset $tpg1Offset \
                -extend_to_core_ring -snap_to_grid -number_of_straps 7

# "The add_pdn_connect command is used to define which layers in the power grid are to be connected together.
#  During power grid generation, vias will be added for overlapping power nets and overlapping ground nets."
# vertical TopMetal1 to below horizonals (M1 has horizontal power tracks)
add_pdn_connect -grid {core_grid} -layers {TopMetal1 Metal1}
#add_pdn_connect -grid {core_grid} -layers {TopMetal1 Metal3}
#add_pdn_connect -grid {core_grid} -layers {TopMetal1 Metal5}

# power ring to standard cell rails
#add_pdn_connect -grid {core_grid} -layers {Metal3 Metal2}
#add_pdn_connect -grid {core_grid} -layers {Metal2 Metal1}


##########################################################################
##  Generate
##########################################################################
pdngen -failed_via_report ${report_dir}/01_${proj_name}_pdngen.rpt

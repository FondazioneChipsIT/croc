# Copyright 2024 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Authors:
# - Philippe Sauter <phsauter@iis.ee.ethz.ch>

# Macro names as produced by the yosys synthesis
# Used for manual macro placement

set CROC            i_croc_soc/i_croc
set JTAG            $CROC/i_dmi_jtag

# JTAG request and response CDCs
# Goal: Find the async nets and their source and destination cells
# We only want to constrain paths internal to the CDC and going through the async nets.
# It is more complex than usual due to how OpenROAD currently dissolves hierarchy when reading in designs.
set JTAG_CDC_REQ $JTAG/i_dmi_cdc.i_cdc_req
# find all startpoints (flops) that drive through async_data nets and flops that directly drive async nets
set JTAG_ASYNC_REQ_START [get_fanin -to [get_nets $JTAG_CDC_REQ/*async_data*] -flat -startpoints_only -only_cells]
# find all endpoints (flops) that are driven through async nets and are in the CDC
set JTAG_ASYNC_REQ_END [list]
set JTAG_ASYNC_REQ_CANDIDATES [get_fanout -from [get_nets $JTAG_CDC_REQ/*async_data*] -flat -endpoints_only -only_cells]
foreach cell $JTAG_ASYNC_REQ_CANDIDATES {
	lappend JTAG_ASYNC_REQ_END $cell
}

# The same for the response CDC
set JTAG_CDC_RSP $JTAG/i_dmi_cdc.i_cdc_resp
set JTAG_ASYNC_RSP_START [get_fanin -to [get_nets $JTAG_CDC_RSP/*async_data*] -flat -startpoints_only -only_cells]
set JTAG_ASYNC_RSP_END [list]
set JTAG_ASYNC_RSP_CANDIDATES [get_fanout -from [get_nets $JTAG_CDC_RSP/*async_data*] -flat -endpoints_only -only_cells]
foreach cell $JTAG_ASYNC_RSP_CANDIDATES {
	lappend JTAG_ASYNC_RSP_END $cell
}


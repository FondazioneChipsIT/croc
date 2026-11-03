# Source Librelane utility scripts
source $::env(SCRIPTS_DIR)/openroad/common/io.tcl
# Load design in OpenROAD
read_current_odb

# Save a png image of the design
save_image -width 2000 cve2.png

# Save updated design views (odb, def, verilog ...)
write_views
report_design_area_metrics
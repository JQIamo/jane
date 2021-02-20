

#Plot logo (in green) for fun
puts -nonewline $color::green
pyrpu::logo
puts -nonewline $color::reset


#the top module is set elsewere in the code and here is placed as
#reminder for future uses
set top_module ""
set _xil_proj_name_ "npm"
set script_file "create_npm.tcl"


#Initialize project by setting part and setting board
set_part $project_part
set_property -name "board_part" -value "$board_part" -objects [current_project]

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Suppressing warnings
#Connections overriden by users... we do that a lot and we don't care!
set_msg_config -id "BD 41-1306" -suppress

#reading ip sources
set_property "ip_repo_paths" "[file normalize "$origin_dir/ip_repo"]" -objects [current_project]

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

#Reading the hdl source files
foreach verilog_file [glob [file normalize $source_dir/hdl]/*.*] {read_verilog $verilog_file}

#Setting up compile order
set_property source_mgmt_mode All [current_project]


# Creating the block diagram
source -notrace "[file normalize "$source_dir/tcl/$block_diagram_script"]"
generate_target all [get_files -of [get_filesets sources_1] "[current_bd_design].bd"]

#Writing hardware definition file
#write_hwdef -file hardware_definition.hwdef

#Generating a wrapper for the board design
set wrapper_file_to_be_added "[make_wrapper -files [get_files -of [get_filesets sources_1] "[current_bd_design].bd"] -top]"
read_verilog $wrapper_file_to_be_added

#Setting the block design as top module
set_property top "top" [current_fileset]

#Reading constraint files
foreach constraint_file [glob [file normalize $source_dir/constraints]/*.*] {read_xdc $constraint_file}


# Set 'utils_1' fileset object
#set obj [get_filesets utils_1]
#Adding the pre-bitstream file

# Set 'utils_1' fileset properties
#set obj [get_filesets utils_1]
#set_property -name "name" -value "utils_1" -objects $obj

# Adding sources referenced in BDs, if not already added
# Nothing here


#Plotting files in compile order

puts -nonewline $color::cyan
puts "Files in compile order:"
foreach line [get_files -compile_order sources -used_in synthesis] {puts "   [file tail $line]"}


#set tcl_interactive true

#Plots total time
puts -nonewline $color::green
puts [concat {Hours, min, secs elapsed} [clock format [expr {[clock seconds]-$timeread}] -gmt 1 -format %H:%M:%S]]

#Tells current status
puts -nonewline $color::yellow
puts "Status:"
puts "   Full project loaded in memory."
puts -nonewline $color::reset

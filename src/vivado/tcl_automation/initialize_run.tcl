

#To avoid echoes when in interactive desktop uncomment next line
#set tcl_interactive false



set timeread [clock seconds]


#This line prevents Xilinx from gathering information during runs.
# At least with the bitfile generation having Webtalk disabled speeds up the
# process a bit.
config_webtalk -user off


# Set paths
set script_location [file normalize "[info script]/../"]
set origin_dir "[file normalize "$script_location/../../"]"
set source_dir "[file normalize "$script_location/../"]"
set tcl_config "[file normalize "$source_dir/tcl_config"]"

# add this script folder location in the TCL auto path
lappend auto_path $script_location
#Running the package index to enable commands
source -notrace [file normalize $script_location/pkgIndex.tcl]
source -notrace [file normalize $script_location/color.tcl]


#Set configuration
set project_part            xc7z020clg400-1
set board_part              ""
#set board_id                MicroZed
set block_diagram_script    "system.tcl"

#set simulation_top_module "four_inputs_adder_tb"

set proj_target_language	VHDL
set user_wrapper 			false
set run_synthesis			false
set run_implementation		false
set gen_bitstream			false


puts -nonewline $color::red
puts "Vivado initialized"
puts -nonewline $color::green
puts "run source tcl_automation/create_npm.tcl"
puts -nonewline $color::cyan
puts "Additional vivado native functions: "
puts "   start_gui"
puts "             Opens the vivado GUI allowing to inspect the design"
puts "   stop_gui"
puts "             Stops the GUI without quitting vivado: it must be called from"
puts "             within the TCL box in the GUI"
puts -nonewline $color::yellow
puts "Status:"
puts "   Part initialized as $project_part. No project is currently in memory."
puts -nonewline $color::reset

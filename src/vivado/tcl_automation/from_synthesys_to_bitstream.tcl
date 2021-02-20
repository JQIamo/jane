set timeread [clock seconds];


if { $argc == 0 } {
    set bitfile_name "pyncmaster_DMA.bit"
    puts "Bitfile name is $bitfile_name"
} else {
    set bitfile_name [lindex $argv 0]
    }

set outputDir "$origin_dir/Output_files_folder"
file mkdir $outputDir
set files [glob -nocomplain "$outputDir/*"]
if {[llength $files] != 0} {
    # clear folder contents
    #puts "deleting contents of $outputDir"
    #file delete -force {*}[glob -directory $outputDir *];
} else {
    puts "$outputDir is empty"
}


# synthesis related settings
set SYNTH_ARGS ""
append SYNTH_ARGS " " -flatten_hierarchy " " full " "
append SYNTH_ARGS " " -gated_clock_conversion " " off " "
append SYNTH_ARGS " " -bufg " {" 12 "} "
append SYNTH_ARGS " " -fanout_limit " {" 4 "} "
append SYNTH_ARGS " " -directive " " AlternateRoutability " "
append SYNTH_ARGS " " -fsm_extraction " " auto " "
#append SYNTH_ARGS " " -keep_equivalent_registers " "
append SYNTH_ARGS " " -resource_sharing " " auto " "
append SYNTH_ARGS " " -control_set_opt_threshold " " auto " "
#append SYNTH_ARGS " " -no_lc " "
#append SYNTH_ARGS " " -shreg_min_size " {" 3 "} "
append SYNTH_ARGS " " -shreg_min_size " {" 5 "} "
append SYNTH_ARGS " " -max_bram " {" -1 "} "
append SYNTH_ARGS " " -max_dsp " {" -1 "} "
append SYNTH_ARGS " " -cascade_dsp " " auto " "
append SYNTH_ARGS " " -verbose
append SYNTH_ARGS " " -max_bram_cascade_height " {" -1 "} "
append SYNTH_ARGS " " -max_uram_cascade_height " {" -1 "} "
append SYNTH_ARGS " " -max_uram " {" -1 "} "
append SYNTH_ARGS " " -retiming


eval "synth_design -top top -part $project_part $SYNTH_ARGS"
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt


#opt_design -directive Explore
#opt_design -remap -aggressive_remap

#place_design -directive Explore
                                    #-directive EarlyBlockPlacement
#phys_opt_design -directive AggressiveFanoutOpt
#phys_opt_design -directive Explore
#phys_opt_design -directive AggressiveExplore

#route_design -directive Explore
#phys_opt_design -directive AggressiveExplore


#Bitstream
#write_bitstream -force $bitfile_name


#On writing checkpoints:
#write_checkpoint -force $name_of_checkpoint
# NOTE: write_checkpoint and read_checkpoint have the option -incremental_checkpoint
# that must be used for incremental design.

#On opening a checkpoint: Opening is not enough. linking the dcp file to the design
# allows to continue the operations from where the design was stopped.
# Maybe setting an empy project before is not necessary: something it can be tried.

#set_part $project_part
#read_checkpoint $name_of_checkpoint
#link_design


puts [concat {Total time: } [clock format [expr {[clock seconds]-$timeread}] -gmt 1 -format %H:%M:%S]];

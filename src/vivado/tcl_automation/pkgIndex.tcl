#Package registration
package provide pyrpu 0.4
package require Tcl 8.5

#Namespace creation
namespace eval ::pyrpu {
    # Export commands
    variable ::pyrpu::script_location [file normalize "[info script]/../"]

    # Set up state
    variable secret
    variable id 0
}



#Compile to bitfile
proc ::pyrpu::compile_to_bitfile {bitfile_name} {
    variable ::pyrpu::script_location
    upvar 1 name_arg name_temp
    set folder_name_temp $bitfile_name
    uplevel 1 {set argv $name_arg;source -notrace [file normalize "${::pyrpu::script_location}/from_synthesys_to_bitstream.tcl"]}

}


#Build_the bulk structure
proc ::pyrpu::process_folder {folder_name} {
    variable ::pyrpu::script_location
    upvar 1 name_arg name_temp
    set name_temp $folder_name
    uplevel 1 {set argv $name_arg;source -notrace [file normalize "${::pyrpu::script_location}/process_folder.tcl"]}

}



#Replace the RPU source file
proc ::pyrpu::replace_rpu {rpu_path} {
    variable ::pyrpu::script_location
    upvar 1 name_arg name_temp
    set name_temp $rpu_path
    uplevel 1 {set argv $name_arg;source -notrace [file normalize "${::pyrpu::script_location}/replace_rpu.tcl"]}

}


#Build_the bulk structure
proc ::pyrpu::build_bulk {} {
    variable ::pyrpu::script_location
    uplevel 1 {source -notrace [file normalize "${::pyrpu::script_location}/large_unmutable_partition.tcl"]}

}
#Build the RPU
proc ::pyrpu::build_rpu {} {
    variable ::pyrpu::script_location
    uplevel 1 {source -notrace [file normalize "${::pyrpu::script_location}/partition_design.tcl"]}

}

#Build the RPU
proc ::pyrpu::fuse_parts {} {
    variable ::pyrpu::script_location
    uplevel 1 {source -notrace [file normalize "${::pyrpu::script_location}/fuse_parts.tcl"]}

}

#Build the RPU
proc ::pyrpu::build_npm {} {
    variable ::pyrpu::script_location
    uplevel 1 {source -notrace [file normalize "${::pyrpu::script_location}/full_structure.tcl"]}

}


proc ::pyrpu::logo {} {


    puts " ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄"
    puts "▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌"
    puts "▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌"
    puts "▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌"
    puts "▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌"
    puts "▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌"
    puts "▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌"
    puts "▐░▌               ▐░▌     ▐░▌     ▐░▌  ▐░▌          ▐░▌       ▐░▌"
    puts "▐░▌               ▐░▌     ▐░▌      ▐░▌ ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌"
    puts "▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌          ▐░░░░░░░░░░░▌"
    puts " ▀                 ▀       ▀         ▀  ▀            ▀▀▀▀▀▀▀▀▀▀▀ "
    puts ""
    puts "              PyRPU is runnig fast now! Very Fast! "
    puts ""

}

proc ::pyrpu::help {} {
    puts "Available commands:"
    puts "   pyrpu::buid_npm"
    puts "            Generates a full project in non-project mode "
    puts "   pyrpu::process_folder <folder_path>"
    puts "            Takes the contents of a folder and creates bitfiles"
    puts "            in the same  folders based on available verilog files"
    puts "            that describe different RPUs"
    puts "   pyrpu::compile_to_bitfile <filename.bit>"
    puts "            Takes the project in memory and synthesizes a bitfile with the"
    puts "            name filename.bit"
    puts "            The process takes around 20 minutes in a 4.3Ghz i7 with 64G ram"
    puts "   pyrpu::replace_rpu <rpu_full_path/filename.v>"
    puts "            Replaces the default RPU in the project with a source file"
    puts "            specified by rpu_full_path/filename.v"
    puts "            After that the design is updated and ready for running"
    puts "            pyrpu::compile_to_bitfile <filename.bit>"
    puts "   pyrpu::build_bulk"
    puts "            Generates a *.dcp file that contains the bulk of the design,"
    puts "            that is the part that contains the communication and control,"
    puts "            leaving empty space for the insertion of the actual RPU. "
    puts "   pyrpu::build_rpu"
    puts "            Generates a RPU in the shortest possibile time"
    puts "   pyrpu::fuse_parts"
    puts "            fuses together the pre-designed bulk of the design with the RPU."
    puts "            the operation is fast and produces a bitfile"
    puts "   pyrpu::logo"
    puts "            Prints an eye candy PyRPU logo"


}


set SRC_ROOT [file normalize "[get_property DIRECTORY [current_project]]/../"]
set FILESETS [get_filesets]
set RUNS [get_runs]

puts "The current project folder is the following: $SRC_ROOT"
puts "I've found the following filesets: $FILESETS"
puts "The following runs have been created: $RUNS"

puts "Making a copy of relevant files..."

foreach fileset $FILESETS {
    set destination $SRC_ROOT
    switch $fileset {
        sources_1 {
            append destination "/hdl/"
        }
        constrs_1 {
            append destination "/constraints/"
        }
        sim_1 {
            append destination "/testbenches/"
        }
        utils_1 {
            append destination "/util/"
        }
    }
    foreach src_file [filter -regexp [get_files -of $fileset] {NAME!~{.*\/bd\/.*}}] {
        file mkdir $destination
        file copy -force $src_file $destination[file tail $src_file]
    }
}

puts "Creating scripts from block diagrams"

foreach bd [get_bd_designs] {
    open_bd $bd
    file mkdir "$SRC_ROOT/tcl/"
    write_bd_tcl -f "$SRC_ROOT/tcl/$bd"
}

#To do:
#puts "Generating build.tcl file from template"

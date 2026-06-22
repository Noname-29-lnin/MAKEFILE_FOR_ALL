###############################################################################
### 
### Synthesis 
###
###############################################################################
set start_time [clock seconds]
echo [string toupper inform:] Start time [clock format ${start_time} -gmt false]

puts "Synthesis started on host: [sh hostname] ([sh date])"

foreach name [array names env] {
    set "$name" "$env($name)"
}

set LIBRARY_DIR ""
set TARGET_LIBRARY_FILES ""

source -echo -verbose ./config_syn.tcl

set ALIB_DIR    "./"
set WORK_DIR    "./work"

if { [info exist ALIB_DIR] && $ALIB_DIR != "" } {
   set_app_var alib_library_analysis_path ${ALIB_DIR}
}

if {![file exists $WORK_DIR] } { file mkdir $WORK_DIR }
if {[info exist WORK_DIR] && ${WORK_DIR} != ""} {
        define_design_lib WORK -path ${WORK_DIR}
}

puts "print LIBRARY_DIR"
foreach item $LIBRARY_DIR {
    puts $item
}

puts "print TARGET_LIBRARY_FILES"
foreach item $TARGET_LIBRARY_FILES {
    puts $item
}

set symbol_library      ""
set synthetic_library   ""
set search_path         "$LIBRARY_DIR"
set link_library        "$synthetic_library $TARGET_LIBRARY_FILES"

if { ![file exists $REPORT_DIR] } { file mkdir $REPORT_DIR }
if { ![file exists $OUTPUT_DIR] } { file mkdir $OUTPUT_DIR }
if { ![file exists $LOG_DIR] }    { file mkdir $LOG_DIR }
#if { ![file exists $INPUT_DIR] }  { file mkdir $INPUT_DIR }

### Specifies the name of the file to which is written a log of the
### initial values of variables and executed commands.
set sh_command_log_file ${LOG_DIR}/command.log
### Specifies the name of the filename log file to be used in case a fatal error
### occurs during execution of design_analyzer or dc_shell.
set filename_log_file   ${LOG_DIR}/filenames.log

### Disables  printing  of one or more informational or warning messages.
if {$message_for_suppress != ""} {
    foreach mfs $message_for_suppress {
        suppress_message $mfs
    }
}

### Set some information about diagnostic messages.
if {$var_message_info != ""} {
    foreach vmi $var_message_info {
        set_message_info -id $vmi -limit 3
        puts "set_message_info -id $vmi -limit 3"
    }
}

puts "Setting host options for CPU cores: $MAX_CORES"
set_host_options -max_cores $MAX_CORES
puts "Reporting core options"
report_host_options

set report_default_significant_digits   $SIGNIFICANT_DIGIT
set sh_source_uses_search_path          true


###############################################################################
###  Search Path, Library and Operating Condition Section                   ###
###############################################################################
set_app_var search_path         [concat $search_path $LIBRARY_DIR]
set_app_var synthetic_library   dw_foundation.sldb
set_app_var target_library      ${TARGET_LIBRARY_FILES}
set_app_var link_library     "* ${TARGET_LIBRARY_FILES} $synthetic_library"



###############################################################################
### Guide Hierarchical Map(GHM) Flow 
### 
### Generates a Formality setup information file for efficient compare 
### point matching in Formality.
### Enable HDL Compiler to generate guide_hier_map guidance in SVF.
###############################################################################
set_svf $OUTPUT_DIR/${TOP_DESIGN}.svf
set_app_var hdlin_enable_hier_map true


###############################################################################
### APP_VAR_LIST (app_var & variables) RUN
###############################################################################
foreach AVL $APP_VAR_LIST {
    regsub -all "\{|\}" $AVL "" run_avl1
    puts $run_avl1
    eval $run_avl1
}
puts ""
puts ""
foreach AVL $APP_VAR_LIST {
    regsub -all "\{|\}" $AVL "" run_avl2
    set  idx0 [lindex $run_avl2 0]
    set  idx1 [lindex $run_avl2 1]
    set  idx2 [lindex $run_avl2 2]
    if {$idx0 == "set_app_var"} {
        printvar $idx1
    } elseif {$idx0 == "set"} {
        puts "$idx1 = $idx2"
    }
}

read_ddc ${OUTPUT_DIR}/${TOP_DESIGN}.presyn.ddc
current_design ${TOP_DESIGN}
### for Guide Hierarchical Map(GHM)
set_verification_top

if {[link] == 0} {
  error "Link command Failed"
  quit
}


###############################################################################
# Load UPF
###############################################################################
if { $LOAD_UPF } {
    load_upf  ${UPF_FILE}  > ./${LOG_DIR}/upf.log
    source -echo -verbose $VOLTAGE_FILE
}


###############################################################################
# Check Design before compile
###############################################################################
check_design > ./${REPORT_DIR}/check_design.presyn.rpt

### Checks for violations in a multivoltage design.
if { $LOAD_UPF } {
    check_mv_design -verbose > ./logs/check_mv_design.presyn.log
    write -format ddc -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.presyn.mv.ddc
}


###############################################################################
# Kill DFT Functions
###############################################################################
if { $SYNTHESIS_W_DFTED_RTL } {
   set src_file ${DFT_HOME}/SDC/kill_dft.sdc
   if [file exist $src_file] {
       source $src_file
   } else {
       puts "\[ERROR\]: $src_file does not exist"
       return
   }
}


###############################################################################
###
### set_dont_touch
###
### Sets the dont_touch attribute on cells, nets, references, and designs
### in the current design, and on library cells, to prevent modification
### or replacement of these objects during optimization.
###
###############################################################################
set gcudont [get_cells -hierarchical *u_dont_touch*]
if {$gcudont != ""} {
   set_dont_touch [get_cells -hierarchical *u_dont_touch*]
}

if {[info exists DONT_TOUCH_CELLS] && ($DONT_TOUCH_CELLS != "")} {
    set get_cells_cmd get_cells
    foreach cell $DONT_TOUCH_CELLS {
        if {![string match "*/*" $cell]} {
            lappend get_cells_cmd "-hier"
        }
        set_dont_touch [eval $get_cells_cmd $cell]
        set get_cells_cmd "get_cells"
    }
} else {
    puts "\n\[PDI_INFO\]  :  Done touch cell does not exist"
}

if {[info exists DONT_TOUCH_NETS] && $DONT_TOUCH_NETS != ""} {
    set_dont_touch [get_nets $DONT_TOUCH_NETS] true
} else  {
    puts "\n\[PDI_INFO\]  :  Done touch net does not exist"
}

if {[info exists FREEZE_NETS] && $FREEZE_NETS != ""} {
    set_attribute  [get_nets $FREEZE_NETS] physical_status locked
    set_dont_touch [get_nets $FREEZE_NETS] true
} else {
    puts "\n\[PDI_INFO\]  :  freeze net does not exist"
}
   

###############################################################################
###
### set_dont_use
###
### Sets the dont_use attribute on library  cells, modules, and implementations.
### Library objects with the dont_use attribute are excluded 
### from the target library during optimization.
###
###############################################################################
if {$DONT_USE_CELLS != ""} {
    set dont_use_lib ""
    foreach dont_use $DONT_USE_CELLS {
        set_dont_use [get_lib_cells */$dont_use]
        set dont_use_lib [concat $dont_use_lib */$dont_use]
    }
    if [file exist $DONT_USE_FILES] {
        set no_of_dont_use_files [llength $DONT_USE_FILES]
        for {set duf 0} {$duf < $no_of_dont_use_files} {incr duf} {
            set dont_use_file_name [lindex $DONT_USE_FILES ${duf}]
            set filei [open ${dont_use_file_name} "r"]
            while {[gets $filei line] >= 0} {
                set_dont_use [get_lib_cells */$line]
                set dont_use_lib [concat $dont_use_lib */$line]
            }
            close $filei
        }
    }
    puts "\n\[PDI_INFO\] : dont_use : $dont_use_lib \n"
} else {
    puts  "\n\[PDI_INFO\] : dont_use list does not exist. \n"
}


###############################################################################
###
### set_ungroup
###
### Sets the ungroup attribute on specified designs, cells, or references,
### indicating that they are to be ungrouped during compile.
###
###############################################################################
if [file exist $DONT_UNGROUP_FILE] {
    set filei [open $DONT_UNGROUP_FILE r]
    while {[gets $filei line] >= 0} {
        if {[get_cells -hierarchical [lindex $line 0]] == ""} {
            puts "\n\[PDI_INFO\]  : [lindex $line 0] does not exist in this design"
        } else {
            set su_cmd "set_ungroup \[get_cells -hierarchical $line\] false"
            eval $su_cmd
        }
    }
    close $filei
}


###############################################################################
###
### set_multibit_options 
###
### Allows the user to customize and setup the multi-bit optimization flow
###
###############################################################################
if [file exist $MULTIBIT_EXCLUDE_FILE] {
    set filei [open $MULTIBIT_EXCLUDE_FILE r]
    while {[gets $filei line] >= 0} {
        if {[get_cells -hierarchical [lindex $line 0]] == ""} {
            puts "\n\[PDI_INFO\]  : [lindex $line 0] does not exist in this design"
        } else {
            set smo_cmd "set_multibit_options -exclude \[get_cells -hierarchical $line\]"
            eval $smo_cmd
        }
    }
    close $filei
}


#####################################################################################
###
### set_size_only
###
### Controls whether the specified leaf cells can only be sized during optimization
###
#####################################################################################
if [file exist $SIZE_ONLY_FILE] {
    set filei [open $SIZE_ONLY_FILE r]
    while {[gets $filei line] >= 0} {
        if {[get_cells -hierarchical [lindex $line 0]] == ""} {
            puts "\n\[PDI_INFO\]  : [lindex $line 0] does not exist in this design"
        } else {
            set ungroup_false_cells "set_ungroup \[get_cells -hierarchical $line\] false"
            set sso_cmd "set_size_only \[get_cells -hierarchical $line\]"
            eval $sso_cmd
        }
    }
    close $filei
}

### foreach_in_collection col [get_pins -h -filter "full_name =~ *bda_persistent_buf_tdr_control*/udnt_buf/Y"] {
###     puts "\[INFO\]: set_case_analysis 0 [get_attribute $col full_name]"
###     set_case_analysis 0 [get_attribute $col full_name]
### }


###############################################################################
### Read in a SDC file
###############################################################################
source -echo -verbose ${SDC_FILE} > ./${LOG_DIR}/mission_sdc.log

#quit
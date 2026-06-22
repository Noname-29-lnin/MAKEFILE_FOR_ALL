###############################################################################
### 
### Synthesis 
###
###############################################################################
set start_time [clock seconds]
echo [string toupper inform:] Start time [clock format ${start_time} -gmt false]

puts "Synthesis started on host: [sh hostname] ([sh date])"


###############################################################################
### Set Environmental Variables and Source user configuration file
###############################################################################
foreach name [array names env] {
    set "$name" "$env($name)"
}

if {![info exist DK_HOME] || $DK_HOME == "" } {
    puts "ERROR: DK_HOME is not defined. Exiting."
    puts "INFO : Please source SourceMe.csh in N1 working repository"
    quit
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

if {$std_lib_track == "sec_6p25t"} { source ./lib_tcl/set_library_std_sec_6p25t.tcl }

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


###############################################################################
### analyze & elaborate
###
### Analyzes the specified HDL source files and stores the resulting templates
### into the specified library in a format ready to specialize and elaborate 
### to form linkable cells of a full design.
###############################################################################
set analyze_vcs_filelist_vhd_tmp ""
set analyze_vcs_filelist_tmp ""
if { $SYNTHESIS_W_DFTED_RTL } {
  if {[info exists dftedRTLFileList_vhd]} {
    foreach fl1 $dftedRTLFileList_vhd {
      lappend analyze_vcs_filelist_vhd_tmp "-f $fl1"
    }
  }
  foreach fl1 $dftedRTLFileList {
    lappend analyze_vcs_filelist_tmp "-f $fl1"
  }
} else {
  if {[info exists RTLFileList_vhd]} {
    foreach fl1 $RTLFileList_vhd {
      lappend analyze_vcs_filelist_vhd_tmp "-f $fl1"
    }
  }
  foreach fl1 $RTLFileList {
    lappend analyze_vcs_filelist_tmp "-f $fl1"
  }
}
set analyze_vcs_filelist_vhd [regsub -all "{|\}" $analyze_vcs_filelist_vhd_tmp ""]
if {[string length $analyze_vcs_filelist_vhd] > 0} {
  analyze -format vhdl -vcs "$analyze_vcs_filelist_vhd"
}
set analyze_vcs_filelist [regsub -all "{|\}" $analyze_vcs_filelist_tmp ""]
if {[string length $analyze_vcs_filelist] > 0} {
  analyze -format sverilog -vcs "$analyze_vcs_filelist" -define "${define_list}"
}
if { $HPDF_flow } {
    set noHPDF [llength $HPDF_sub_block_name]
    for {set nh 0} {$nh < $noHPDF} {incr nh} {
        set_top_implementation_options -block_references [lindex $HPDF_sub_block_name $nh]
        read_ddc [lindex $HPDF_sub_block_ddc $nh]
    }
}
elaborate ${TOP_DESIGN} > ./${LOG_DIR}/elab.log

#read_ddc ${OUTPUT_DIR}/${TOP_DESIGN}.presyn.ddc
current_design ${TOP_DESIGN}
### for Guide Hierarchical Map(GHM)
set_verification_top

if {[link] == 0} {
  error "Link command Failed"
  quit
}
write -format ddc -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.presyn.ddc


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
       source -e -v $src_file > ./${LOG_DIR}/dft_kill_function.log
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


set preicgdont [get_cells -hierarchical *u_dont_touch_preicg*]
if {$preicgdont != ""} {
  remove_attribute [get_cells -hier *u_dont_touch_preicg*] dont_touch
  set pwr_cg_preservation_type preserve
  set_preserve_clock_gate [get_cells -hier *u_dont_touch_preicg*]
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
# if [file exist $DONT_UNGROUP_FILE] {
#     set filei [open $DONT_UNGROUP_FILE r]
#     while {[gets $filei line] >= 0} {
#         if {[get_cells -hierarchical [lindex $line 0]] == ""} {
#             puts "\n\[PDI_INFO\]  : [lindex $line 0] does not exist in this design"
#         } else {
#             set su_cmd "set_ungroup \[get_cells -hierarchical $line\] false"
#             eval $su_cmd
#         }
#     }
#     close $filei
# }
if {($SYNTHESIS_W_DFTED_RTL == "true")} {
    #set src_file /workspace/users/pdi/golden_scripts/psyn/etc/dont_ungroup.tcl
    set src_file ${SYN_HOME}/infeed/dont_ungroup.tcl
    if [file exist $src_file] {
       puts "*Info> source $src_file by DFT's request"
       source -e -v $src_file
    } else {
       puts "Error: $src_file does not exist"
    }
}


###############################################################################
###
### set_multibit_options 
###
### Allows the user to customize and setup the multi-bit optimization flow
###
###############################################################################
# if [file exist $MULTIBIT_EXCLUDE_FILE] {
#     set filei [open $MULTIBIT_EXCLUDE_FILE r]
#     while {[gets $filei line] >= 0} {
#         if {[get_cells -hierarchical [lindex $line 0]] == ""} {
#             puts "\n\[PDI_INFO\]  : [lindex $line 0] does not exist in this design"
#         } else {
#             set smo_cmd "set_multibit_options -exclude \[get_cells -hierarchical $line\]"
#             eval $smo_cmd
#         }
#     }
#     close $filei
# }
if {($SYNTHESIS_W_DFTED_RTL == "true")} {
    #set src_file /workspace/users/pdi/golden_scripts/psyn/etc/multibit_exclude.tcl
    set src_file ${SYN_HOME}/infeed/multibit_exclude.tcl
    if [file exist $src_file] {
       puts "*Info> source $src_file by DFT's request"
       source -e -v $src_file
    } else {
       puts "Error : $src_file does not exist"
    }
}


#####################################################################################
###
### set_size_only
###
### Controls whether the specified leaf cells can only be sized during optimization
###
#####################################################################################
# if [file exist $SIZE_ONLY_FILE] {
#     set filei [open $SIZE_ONLY_FILE r]
#     while {[gets $filei line] >= 0} {
#         if {[get_cells -hierarchical [lindex $line 0]] == ""} {
#             puts "\n\[PDI_INFO\]  : [lindex $line 0] does not exist in this design"
#         } else {
#             set ungroup_false_cells "set_ungroup \[get_cells -hierarchical $line\] false"
#             set sso_cmd "set_size_only \[get_cells -hierarchical $line\]"
#             eval $sso_cmd
#         }
#     }
#     close $filei
# }
if {($SYNTHESIS_W_DFTED_RTL == "true")} {
    #set src_file /workspace/users/pdi/golden_scripts/psyn/etc/size_only.tcl
    set src_file ${SYN_HOME}/infeed/size_only.tcl
    if [file exist $src_file] {
       puts "*Info> source $src_file by DFT's request"
       source -e -v $src_file
    } else {
       puts "Error : $src_file does not exist"
    }
}

### foreach_in_collection col [get_pins -h -filter "full_name =~ *bda_persistent_buf_tdr_control*/udnt_buf/Y"] {
###     puts "\[INFO\]: set_case_analysis 0 [get_attribute $col full_name]"
###     set_case_analysis 0 [get_attribute $col full_name]
### }


###############################################################################
### Read in a SDC file
###############################################################################
source -echo -verbose ${SDC_FILE} > ./${LOG_DIR}/mission_sdc.log


###############################################################################
###
### set_clock_gating_style
###
### Sets the clock-gating style for clock-gate insertion and replacement.
###
###############################################################################
set set_cg_style_cmd "set_clock_gating_style  -sequential_cell $user_cg_style_sequential_cell \
    -max_fanout $user_cg_style_man_fanout \
    -minimum_bitwidth $user_cg_style_bitwidth \
    -num_stages $user_cg_style_num_stage \
    -control_point $user_cg_style_control_point \
    -control_signal $user_cg_style_control_signal"
if {$user_cg_style_positive_edge_logic != ""} {
    set set_cg_style_cmd [concat $set_cg_style_cmd "-positive_edge_logic ${user_cg_style_positive_edge_logic}"]
}
if {$user_cg_style_negative_edge_logic != ""} {
    set set_cg_style_cmd [concat $set_cg_style_cmd "-negative_edge_logic ${user_cg_style_negative_edge_logic}"]
}
puts $set_cg_style_cmd
eval $set_cg_style_cmd


###############################################################################
### Merge DFT Functions
###############################################################################
### Merge DFT SDC to Optimize DFT Logics during synthesis 
### Add IJTAG Clock and enables BIST At-speed clock
if { $SYNTHESIS_W_DFTED_RTL } {
    set src_file ${DFT_HOME}/SDC/merge_dft.sdc
    if [file exist $src_file] {
       source -e -v $src_file > ./${LOG_DIR}/dft_merge_function.log
    } else {
       puts "\[ERROR\]: $src_file does not exist"
       return
    }
}

### Removes the multiply instantiated hierarchy in the current design 
### by creating a unique design for each cell instance.
uniquify -force

if {[regexp {^BOS_BUS} $TOP_DESIGN]} {
    ungroup -start_level 3 -all -flatten
}
 
current_design ${TOP_DESIGN}
link

#if {$TOP_DESIGN == "BLK_CPU_WRAPPER"} {
#    current_design BOS_BUS_CPU_PDM_CPU_0
#    ungroup -start_level 3 -all -flatten
#
#    current_design ${TOP_DESIGN}
#    link
#}


###############################################################################
# Protects DFT logics from Optimization
###############################################################################
if { $SYNTHESIS_W_DFTED_RTL } {
   set src_file ${DFT_HOME}/SDC/insert_scan.before_compile.tcl
   if [file exist $src_file] {
       source -e -v $src_file > ./${LOG_DIR}/dft_insert_scan.log
   } else {
       puts "\[ERROR\]: $src_file does not exist"
       return
   }
}

set ports_clock_root [get_ports [all_fanout -flat -clock_tree -level 0]]
set exist_regs [sizeof_collection [all_registers]]
set CG_cell [get_cells -quiet -of_objects [get_pins -hierarchical *ECK]]

group_path -name feedthrough_path  -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_outputs]
if { $exist_regs } {
  group_path -name in2reg_path       -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_registers]
  group_path -name reg2out_path      -from [all_registers] -to [all_outputs]
  if {$CG_cell != ""} {group_path -name reg2gating_path   -from [all_registers] -to [get_pins -of_objects [get_cells -hierarchical $CG_cell] -filter {name == E}]}
}

if [file exist $pre_defined_constraint] { source $pre_defined_constraint }

set_max_fanout 32 [get_designs $TOP_DESIGN]

###############################################################################
### Performs Logic Synthesis and Optimization 
###############################################################################
set COMPILE_COMMAND "compile_ultra -gate_clock -scan"
if { ! $USE_BOUNDARY_OPT } {
   set COMPILE_COMMAND [concat $COMPILE_COMMAND -no_boundary_optimization]
}
if { ! $USE_AUTOUNGROUP } {
   set COMPILE_COMMAND [concat $COMPILE_COMMAND -no_autoungroup]
}
if { ! $USE_SEQ_INVERSION } {
   set COMPILE_COMMAND [concat $COMPILE_COMMAND -no_seq_output_inversion]
}
puts "INFO: Running following compile_ultra command using pre-defined compile strategy"
puts "$COMPILE_COMMAND"
eval  $COMPILE_COMMAND


### Write SDC before applying change_names
if { $SYNTHESIS_W_DFTED_RTL } {
    write_sdc -nosplit                       ${OUTPUT_DIR}/${TOP_DESIGN}.dft.b4cn.sdc
} else {
    write_sdc -nosplit                       ${OUTPUT_DIR}/${TOP_DESIGN}.b4cn.sdc
}

### Apply change_names before write out the synthesized netlist.
change_names -rules verilog -hierarchy

###############################################################################
### Reports
###############################################################################
### Displays clock-related information.
report_clock -nosplit -attributes -skew -groups > ${REPORT_DIR}/clock_gating.clock.rpt

### Reports the Power Compiler tool's clock-gating details.
report_clock_gating -gated -nosplit         > ${REPORT_DIR}/clock_gating.gated.rpt
report_clock_gating -ungated -nosplit       > ${REPORT_DIR}/clock_gating.ungated.rpt
report_clock_gating -verbose -nosplit       > ${REPORT_DIR}/clock_gating.verbose.rpt

### Displays constraint-related information about a design.
report_constraint                           > ${REPORT_DIR}/constraint.rpt
report_constraint -verbose                  > ${REPORT_DIR}/constraint_detail.rpt
report_constraint -all_violator -verbose    > ${REPORT_DIR}/constraint_all_vio.rpt
report_constraint -max_delay -all_violators -nosplit > ${REPORT_DIR}/${TOP_DESIGN}.all_violators.rpt

### Displays QoR information and statistics for the current design.
report_qor                                  > ${REPORT_DIR}/qor_summary.rpt

### Displays timing information about a design.
report_timing -transition_time -nets -attributes -nosplit -significant_digits 4 > ${REPORT_DIR}/${TOP_DESIGN}.timing.rpt

### Displays area information for the current design or instance.
report_area -nosplit                        > ${REPORT_DIR}/area.rpt
report_hierarchy -nosplit    -full           > ${REPORT_DIR}/hierarchy.rpt


set     rpt_file [open "$REPORT_DIR/area.rpt" "a"]
puts    $rpt_file ""
set     mem_cells [get_cells -hierarchical -filter "is_memory_cell == true"]
set     mem_count [sizeof_collection $mem_cells]
puts    $rpt_file "Count of Memory : $mem_count"
puts    $rpt_file ""
close   $rpt_file

report_area -hierarchy -nosplit             > ${REPORT_DIR}/area_hier.rpt

### Displays information about references in the current instance or in the current design.
report_reference -hierarchy                 > ${REPORT_DIR}/ref_hier.rpt

### Calculates and reports dynamic and static power for the design or instance.
report_power -nosplit                       > ${REPORT_DIR}/power.rpt
### Displays information about the compile command options for the design
### of the current instance if set; or for the current design otherwise.
report_compile_options -nosplit             > ${REPORT_DIR}/compile_options.rpt
### Reports the units used for resistance, capacitance, timing, leakage power, current,
### and voltage in the flow. The units must be consistent with the main library units.
report_units                                > ${REPORT_DIR}/units.rpt

# Group internal paths between registers


###############################################################################
### Check Design after compile & Write Output Files
###############################################################################
if { $LOAD_UPF } {
    check_mv_design -verbose > ${REPORT_DIR}/check_mv_design.postsyn.rpt
    save_upf  ${OUTPUT_DIR}/${TOP_DESIGN}.upf
}


###############################################################################
### write db
###############################################################################
if { $SYNTHESIS_W_DFTED_RTL } {
    write -format verilog -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.dft.v
    write -format ddc     -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.dft.ddc

    remove_path_group {feedthrough_path}
    if { $exist_regs } {
      if {$CG_cell != ""} {
          remove_path_group {in2reg_path reg2out_path reg2gating_path}
      } else {
          remove_path_group {in2reg_path reg2out_path}
      }
    }
    write_sdc -nosplit                       ${OUTPUT_DIR}/${TOP_DESIGN}.dft.sdc

    group_path -name feedthrough_path  -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_outputs]
    if { $exist_regs } {
      group_path -name in2reg_path       -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_registers]
      group_path -name reg2out_path      -from [all_registers] -to [all_outputs]
      if {$CG_cell != ""} {group_path -name reg2gating_path   -from [all_registers] -to [get_pins -of_objects [get_cells -hierarchical $CG_cell] -filter {name == E}]}
      group_path -name reg2reg           -from [all_registers] -to [all_registers]
    }

    create_block_abstraction
    write -format ddc     -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.dft.abs.ddc
} else {
    write -format verilog -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.v
    write -format ddc     -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.ddc

    remove_path_group {feedthrough_path}
    if { $exist_regs } {
      if {$CG_cell != ""} {
          remove_path_group {in2reg_path reg2out_path reg2gating_path}
      } else {
          remove_path_group {in2reg_path reg2out_path}
      }
    }
    write_sdc -nosplit                       ${OUTPUT_DIR}/${TOP_DESIGN}.sdc

    group_path -name feedthrough_path  -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_outputs]
    if { $exist_regs } {
      group_path -name in2reg_path       -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_registers]
      group_path -name reg2out_path      -from [all_registers] -to [all_outputs]
      if {$CG_cell != ""} {group_path -name reg2gating_path   -from [all_registers] -to [get_pins -of_objects [get_cells -hierarchical $CG_cell] -filter {name == E}]}
      group_path -name reg2reg           -from [all_registers] -to [all_registers]
    }

    create_block_abstraction
    write -format ddc     -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.abs.ddc
}
set_svf -off
if { $exist_regs } {
  report_timing -group reg2gating -nworst 200 > ${REPORT_DIR}/report_timing.reg2gating.200.rpt
  report_timing -group reg2reg    -nworst 200 > ${REPORT_DIR}/report_timing.reg2reg.200.rpt
}

set k 0
set filew [open "${REPORT_DIR}/report_memory_name_and_instance_name.rpt" "w"]
foreach_in_collection gch [get_cells -hier] {
    set mct [get_attribute -quiet $gch is_memory_cell]
    if {$mct == "true"} {
        incr k
        puts $filew "$k : [get_object_name [get_lib_cells -of_object $gch]] : [get_object_name $gch]"
    }
}
close $filew
puts "Total Number of Memory is $k"

#sizeof_collection [get_cells * -hierarchical -filter "dont_touch == true"] > ${REPORT_DIR}/dont_touch_cells_counts.rpt
source -e -v ${SYN_HOME}/report.misc.tcl

###############################################################################
### The following script is related to Scan Stitching, it's OK to commented out
###############################################################################
### # Need to updated after making a file policy for memory ctl file.
### foreach dir $LIBRARY_DIR {
###     foreach ctl [exec find [file dir $dir] -name "*.ctl"] {
###    set root_name [file root [file tail $ctl]]
###    if [sizeof_collection [get_cells -quiet -h -f "ref_name == $root_name"]] {
### #      puts $ctl
###        puts "\[INFO\]:read ctl model from $ctl"
###        read_test_model -format ctl -design $root_name $ctl
###    }
###    foreach_in_collection col [get_cells -quiet -h -f "ref_name == $root_name"] {
###        set instance_name [get_attribute $col full_name]
###        puts "\[INFO\]:use test model for $instance_name"
###        use_test_model -true $col
###    }
###     }
### }
### 
### if { $SYNTHESIS_W_DFTED_RTL } {
###    set src_file ./tcl/insert_scan.after_compile.tcl
###    if [file exist $src_file] {
###        source $src_file 
###    } else {
###        puts "\[ERROR\]: $src_file does not exist"
###        return
###    }
### }
### 
### set_svf -off
set end_time [clock seconds]
echo [string toupper inform:] End time [clock format ${end_time} -gmt false]
# Total script wall clock run time
echo "[string toupper inform:] Time elapsed: [format %02d [expr ($end_time - $start_time)/86400]]d \
      [clock format [expr ($end_time - $start_time)] -format %Hh%Mm%Ss -gmt true]"


exec touch DONE
exec touch ${TOP_DESIGN}_SYN_DONE

###############################################################################
# Terminate
###############################################################################
#quit
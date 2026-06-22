###############################################################################
### 
### LINT 
###
###############################################################################
set start_time [clock seconds]
echo [string toupper inform:] Start time [clock format ${start_time} -gmt false]

puts "LINT started on host: [sh hostname] ([sh date])"

###############################################################################
### Set Environmental Variables and Source user configuration file
###############################################################################
#if { ![info exists ::env(N1_ASIC_HOME)] || $::env(N1_ASIC_HOME) == "" } {
#    puts "ERROR: N1_ASIC_HOME is not defined. Exiting."
#    puts "INFO : Please source SourceMe.csh in N1 working repository"
#    quit
#}


#if {![info exists ::env(ML_NAME)] || $::env(ML_NAME) == "" } {
#    puts "ERROR: ML_NAME is not defined or empty string. Exiting."
#    puts "INFO : Please setenv ML_NAME MLxxx in N1 working repository"
#    quit
#}


source -echo -verbose ./config_lint.tcl
###############################################################################
### IF GUI SESSION EXIST 
###############################################################################
if {$env(GUI)} {
  if { [file exists "${TOP_DESIGN}_rtdb"] } {
    restore_session -session ${TOP_DESIGN}
    if {$WAIVER_IP_LIST != ""} {
      foreach wfl $WAIVER_IP_LIST {
        puts "INFO: add waiver ip: $wfl"
        waive_lint -ip $wfl -add WAIVER_$wfl
      }
    } else {
      puts "**************************************** "
      puts "INFO: DONT LOAD WAIVER IP"
      puts "**************************************** "
    }
    if {$WAIVER_PATH != ""} {
      foreach wfl $WAIVER_PATH {
        puts "INFO: add waiver file: $wfl"
        manage_waiver_file -add $wfl
      }
    }
    view_activity
    return
  } else {
    puts "ERROR: NO SAVED session for gui start"
    quit
  }
}
###############################################################################
# LIBRARY Setting
###############################################################################
set LIBRARY_DIR ""
set TARGET_LIBRARY_FILES ""
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
###############################################################################
###  START LINT CHECKING Section                                            ###
###############################################################################

##Wait 20 minutes before it is timeout
#get_license VC-STATIC-COMPILE -licwait 20
#get_license VC-LINT-BASE -licwait 20

set cpu_core_num "8"
set lint_no_of_formal_processes_value "4"
set ignore_encrypted_module_violations_value "true"
set elab_summary_report_max_inst_value "-1"
set report_all_hdl_errors_value "false"
set lint_enable_coverage_flow_value "false"
set lint_ignore_syncreset_for_asyncflop_value "true"

#allow to set application variable for specific value:VC spyglass Lint flow
set_app_var enable_lint true

#enable VC Spyglass Functional Lint 
#Enable the formal mode for lint checks. Noisy lint checks like Width-Mismatch, Index-Overflow,
#DeadCode, FSM will leverage formal technology.
set_app_var lint_functional_mode true

if {$env(SAM)} {
    variable enable_abstraction
    set_app_var enable_abstraction true
}

#This variable lists names in the report containing generate label for VHDL.
#Note that this app var is available only for language checks.
set_app_var ignore_encrypted_module_violations $ignore_encrypted_module_violations_value

#Customize printing number of instances perdesign unit in elab_summary.rpt report.
# >=1 : is the maximum of instances per design is displayed in the elab_summary.rpt report
# 0   : zero instance is displayed
# -1  : all instances is dispalyed
set elab_summary_report_max_inst $elab_summary_report_max_inst_value

#Report all Verilog syntax errors in a signgle run.
#By default, only the first syntax error is reported byut when this variable is set to true, 
#all syntax errors are reported. For VHDL designs, all syntax errors are reported at once 
#irrespective of this application variable.
set report_all_hdl_errors $report_all_hdl_errors_value

#When this application variable is set to true, synchronous resets are not detected
#for flops having asynchronous resets.
set lint_ignore_syncreset_for_asyncflop $lint_ignore_syncreset_for_asyncflop_value

#Enable functional lint coverage checks for the following rules
# DeadCode-ML
# NoExitFsmState
# NotReachableFsmState
# MissingFsmStateTransition
# RegisterStuckInResetState-ML
#set lint_enable_coverage_flow $lint_enable_coverage_flow_value
set_app_var lint_enable_coverage_flow true

#Sets the number of processes in which the formal engine is split in the functional lint.
#It's value will be equal to (cpu_core_num-2), unless specified otherwise. Since cpu_core_num's
#default value is 4, so it's default value will be 2 here.
set_app_var lint_no_of_formal_processes $lint_no_of_formal_processes_value

set_app_var disable_rtl_deadcode_extended true

configure_lint_setup -goal "BOS_LINT_RULE" -j $cpu_core_num
#configure_lint_setup -goal "BOS_LINT_RULE" 

source $env(VC_STATIC_HOME)/auxx/monet/tcl/GuideWare/block/initial_rtl/lint/lint_functional_rtl.tcl

if {![info exists CHECK_STRICT_RULE]} {
    set CHECK_STRICT_RULE false
}

if { $CHECK_STRICT_RULE } {
    source $env(VC_STATIC_HOME)/auxx/monet/tcl/GuideWare/block/initial_rtl/lint/lint_formality.tcl
    source $env(VC_STATIC_HOME)/auxx/monet/tcl/GuideWare/block/initial_rtl/lint/lint_synth.tcl
}

##Check for missing reset 
configure_lint_tag -enable -tag "STARC05-3.3.1.4b" -goal BOS_LINT_RULE -severity Error

##Check not reset array(for static)
configure_lint_tag -enable -tag "W88" -goal BOS_LINT_RULE

##Check width missmatch
configure_lint_tag_parameter -tag W164a -parameter CHECK_STATIC_VALUE -value yes

if {$blackbox != "" } {
    foreach bbl $blackbox {
        set_blackbox -design $bbl
    }
}
###############################################################################
# Load SAM
# == simple format ==============================================
# set_abstract_model                                     \
#                  [-module <block_module_name>]         \
#                  [-path <abstract_location>]           \
#                  [-user_mode <mode_name>]              \
#                  [-instances <list_of_instance_names>] \
#                  [-enable_auto_abstraction]
# ===============================================================
# == Example=====================================================
# set_abstract_model -module "BOS_CM7" -path "$CM7_HOME/CDC/sam_BOS_CM7" 
###############################################################################
if {![info exist SAM_IP_LIST] } {
   set SAM_IP_LIST "" 
}

if {${SAM_IP_LIST} != ""} {
  foreach {ipName ipSamDir} $SAM_IP_LIST {
    eval set resolvedPath $ipSamDir
    puts "INFO: Load SAM file of $ipName $resolvedPath"
    set_abstract_model -module $ipName -path $resolvedPath
  }       
}

###############################################################################
### 
### analyze
###
### Analyzes the specified HDL source files and stores the resulting templates
### into the specified library in a format ready to specialize and elaborate 
### to form linkable cells of a full design.
###############################################################################
set analyze_vcs_filelist_vhd_tmp ""
set analyze_vcs_filelist_tmp ""
if { $CHECK_DFTED_RTL } {
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
    puts $analyze_vcs_filelist_tmp
set analyze_vcs_filelist_vhd  [regsub -all "{|\}" $analyze_vcs_filelist_vhd_tmp ""]
if {[string length $analyze_vcs_filelist_vhd] > 0} {
  analyze -format vhdl      -vcs "$analyze_vcs_filelist_vhd" 
}
set analyze_vcs_filelist      [regsub -all "{|\}" $analyze_vcs_filelist_tmp ""]
if {[string length $analyze_vcs_filelist] > 0} {
  analyze -format sverilog  -vcs "$analyze_vcs_filelist" -define "${define_list} -timescale=1ns/10ps"
}
###############################################################################
## Link design
###############################################################################
elaborate ${TOP_DESIGN} 

check_lint

###############################################################################
## save session
###############################################################################
if {$env(SESSION)} {
 save_session -session ${TOP_DESIGN}
}
###############################################################################
### Manage Waiver Files and report
###############################################################################
if {$WAIVER_IP_LIST != ""} {
  foreach wfl $WAIVER_IP_LIST {
    puts "INFO: add waiver ip: $wfl"
    waive_lint -ip $wfl -add WAIVER_$wfl
  }
} else {
  puts "**************************************** "
  puts "INFO: DONT LOAD WAIVER IP"
  puts "**************************************** "
}
if {$WAIVER_PATH != ""} {
  foreach wfl $WAIVER_PATH {
    puts "INFO: add waiver file: $wfl"
    manage_waiver_file -add $wfl
  }
} else {
  puts "**************************************** "
  puts "INFO: DONT LOAD WAIVER FILER"
  puts "**************************************** "
}
# Report LINT
#report_lint -verbose -limit 0 -file ${REPORT_DIR}/report_lint.full.log
report_violations -app {lint} -verbose -include_compressed -limit 0 -file ${REPORT_DIR}/report_lint.full.log
report_violations -app {lint} -verbose -include_compressed -only_waived -limit 0 -file ${REPORT_DIR}/report_lint.waived.log

#if {$AUTO_SANITY_DIR ne ""} {
#  puts "AUTO_SANITY_DIR: $AUTO_SANITY_DIR"
#  # dest folder check or create
#  if {![file isdirectory $AUTO_SANITY_DIR]} {
#      file mkdir $AUTO_SANITY_DIR
#  }
#  # copy
#  file copy -force ${REPORT_DIR}/report_lint.full.log $AUTO_SANITY_DIR
#  puts "Log file (${REPORT_DIR}/report_lint.full.log) copied to $AUTO_SANITY_DIR"
#}

#source $env(VC_STATIC_HOME)/auxx/monet/tcl/lint_module_based_report.tcl
#get_module_violations -goal "BOS_LINT_RULE" -session vcst_rtdb -useModel SGUM


if {$env(SAM)} {
    puts "START GENERATE SAM"
    # generate SAM
    create_lint_abstract_model -full_logic
    write_abstract_model -path sam_${TOP_DESIGN}
  puts "END GENERATE SAM"
}
#view_activity

set end_time [clock seconds]
echo [string toupper inform:] End time [clock format ${end_time} -gmt false]
# Total script wall clock run time
echo "[string toupper inform:] Time elapsed: [format %02d [expr ($end_time - $start_time)/86400]]d \
      [clock format [expr ($end_time - $start_time)] -format %Hh%Mm%Ss -gmt true]"

# Exit CDC
if {$env(QUIT_VC)} {
 quit
}
###############################################################################
### CDC 
###############################################################################
set start_time [clock seconds]
echo [string toupper inform:] Start time [clock format ${start_time} -gmt false]

puts "CDC started on host: [sh hostname] ([sh date])"
###############################################################################
### Set Environmental Variables and Source user configuration file
###############################################################################
if { ![info exists ::env(CDC_HOME)] || $::env(CDC_HOME) == "" } {
    puts "ERROR: CDC_HOME is not defined. Exiting."
    puts "INFO : Please source SourceMe.csh in N1 working repository"
    quit
}

foreach name [array names env] {
    set "$name" "$env($name)"
}

if {![info exist DK_HOME] || $DK_HOME == "" } {
    puts "ERROR: DK_HOME is not defined. Exiting."
    puts "INFO : Please source SourceMe.csh in N1 working repository"
    quit
}

#if {![info exists ::env(ML_NAME)] || $::env(ML_NAME) == "" } {
#    puts "ERROR: ML_NAME is not defined or empty string. Exiting."
#    puts "INFO : Please setenv ML_NAME MLxxx in N1 working repository"
#    quit
#}
source -echo -verbose ./config_cdc.tcl
###############################################################################
### IF GUI SESSION EXIST 
###############################################################################
if {$GUI} {
  if { [file exists "${TOP_DESIGN}_rtdb"] } {
    restore_session -session ${TOP_DESIGN}
    if {$WAIVER_IP_LIST != ""} {
      foreach wfl $WAIVER_IP_LIST {
        puts "INFO: add waiver ip: $wfl"
        waive_cdc -ip $wfl -add WAIVER_$wfl
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
set synthesic_library   ""
set search_path         "$LIBRARY_DIR"
set link_library        "$synthesic_library $TARGET_LIBRARY_FILES"
###############################################################################
# CDC Application Variable
###############################################################################
# Enable the VC Spyglass CDC flow
set_app_var enable_cdc true
# Enable save and restore session flow
set_app_var enable_cdc_save true
# Enable abstract generation (SAM)
set_app_var enable_abstraction true
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
if {${SAM_IP_LIST} == ""} {
  puts "**************************************** "
  puts "INFO: DONT LOAD SAM IP "
  puts "**************************************** "
} else {
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
set analyze_vcs_filelist_tmp ""
if { $CHECK_DFTED_RTL } {
  foreach fl1 $dftedRTLFileList {
    lappend analyze_vcs_filelist_tmp "-f $fl1"
  }
} else {
  foreach fl1 $RTLFileList {
    lappend analyze_vcs_filelist_tmp "-f $fl1"
  }
}
set analyze_vcs_filelist [regsub -all "{|\}" $analyze_vcs_filelist_tmp ""]
analyze -format sverilog -vcs "$analyze_vcs_filelist" -define "${define_list} -timescale=1ns/10ps"
###############################################################################
## Link design
###############################################################################
elaborate ${TOP_DESIGN} 
###############################################################################
## Read SDC of Design
read_sdc ${SDC_PATH}
###############################################################################
# Verify CDC setup, integ, sync, struct
check_cdc
###############################################################################
## save session
###############################################################################
if {$SESSION} {
 save_session -session ${TOP_DESIGN}
}
###############################################################################
### Manage Waiver Files and report
###############################################################################
if {$WAIVER_IP_LIST != ""} {
  foreach wfl $WAIVER_IP_LIST {
    puts "INFO: add waiver ip: $wfl"
    waive_cdc -ip $wfl -add WAIVER_$wfl
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
# Report CDC
set report_full_log_file "${REPORT_DIR}/report_cdc.full.log"
report_cdc -include_compressed -verbose -limit 0 -file ${report_full_log_file}
set top_design_name_new_line "TopLevelModule: ${TOP_DESIGN}"
exec sh -c "sed -i '1i\\$top_design_name_new_line' ${report_full_log_file}"

# Report waiver file only
report_cdc -include_compressed -only_waived -verbose -limit 0 -file ${REPORT_DIR}/report_cdc.waived.log

#if {$AUTO_SANITY_DIR ne ""} {
#  puts "AUTO_SANITY_DIR: $AUTO_SANITY_DIR"
#  # dest folder check or create
#  if {![file isdirectory $AUTO_SANITY_DIR]} {
#      file mkdir $AUTO_SANITY_DIR
#  }
#  # copy
#  file copy -force ${REPORT_DIR}/report_cdc.full.log $AUTO_SANITY_DIR
#  puts "Log file (${REPORT_DIR}/report_cdc.full.log) copied to $AUTO_SANITY_DIR"
#}

# Report synchronizer information
if {![info exist SYNC_INFO_RPT] } {
   set SYNC_INFO_RPT "true" 
}
if {$SYNC_INFO_RPT} {
    # Report Synchronize information
    report_cdc -report SynchInfo -dir ${REPORT_DIR}
}
###############################################################################
## Generate SAM
###############################################################################
if {$SAM} {
  puts "START GENERATE SAM"
  # generate SAM
  create_cdc_abstract_model -full_logic
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
if {$QUIT_CDC} {
 #quit
}
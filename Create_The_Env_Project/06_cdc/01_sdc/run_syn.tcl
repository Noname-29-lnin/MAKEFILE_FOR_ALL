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
if { ![info exists ::env(N1_ASIC_HOME)] || $::env(N1_ASIC_HOME) == "" } {
    puts "ERROR: N1_ASIC_HOME is not defined. Exiting."
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

source -echo -verbose ./../config_cdc.tcl

set ALIB_DIR    "./"
set WORK_DIR    "./work"

if { [info exist ALIB_DIR] && $ALIB_DIR != "" } {
   set_app_var alib_library_analysis_path ${ALIB_DIR}
}

if {![file exists $WORK_DIR] } { file mkdir $WORK_DIR }
if {[info exist WORK_DIR] && ${WORK_DIR} != ""} {
        define_design_lib WORK -path ${WORK_DIR}
}

set LIBRARY_DIR ""
set TARGET_LIBRARY_FILES ""

if {$USE_OD == "false"} {

    if {$std_lib_track == "sec_6p25t"   } { source ${DK_HOME}/lib_tcl/set_library_std_sec_6p25t.tcl   }
#    if {$std_lib_track == "sec_7p94t"   } { source ${DK_HOME}/lib_tcl/set_library_std_sec_7p94t.tcl   }
    
    if {$use_gpio		} { source ${DK_HOME}/lib_tcl/set_library_gpio.tcl       }
    if {$use_gbe		} { source ${DK_HOME}/lib_tcl/set_library_gbe_phy.tcl    }
    if {$use_usb_dp		} { source ${DK_HOME}/lib_tcl/set_library_usb32dp.tcl    }
    if {$use_por        } { source ${DK_HOME}/lib_tcl/set_library_por.tcl        }
    if {$use_pcie		} { source ${DK_HOME}/lib_tcl/set_library_pcie.tcl       }
    if {$use_tmu		} { source ${DK_HOME}/lib_tcl/set_library_tmu.tcl        }
    if {$use_promise	} { source ${DK_HOME}/lib_tcl/set_library_promise.tcl    }
    if {$use_ucie_cxs	} { source ${DK_HOME}/lib_tcl/set_library_ucie.tcl       }
    if {$use_uciea		} { source ${DK_HOME}/lib_tcl/set_library_uciea.tcl      }
    if {$use_adc		} { source ${DK_HOME}/lib_tcl/set_library_adc.tcl        }
    if {$use_prtn		} { source ${DK_HOME}/lib_tcl/set_library_prtn.tcl       }
    if {$use_pll		} { source ${DK_HOME}/lib_tcl/set_library_pll.tcl       }
    if {$use_drd		} { source ${DK_HOME}/lib_tcl/set_library_drd.tcl       }
    if {$use_ndline		} { source ${DK_HOME}/lib_tcl/set_library_ndline.tcl       }
    if {$use_otp		} { source ${DK_HOME}/lib_tcl/set_library_otp.tcl       }
    if {$use_imem   	} { source ${DK_HOME}/lib_tcl/set_library_imem.tcl    }
    if {$use_mphy   	} { source ${DK_HOME}/lib_tcl/set_library_mphy.tcl    }

} else {

    if {$std_lib_track == "sec_6p25t"   } { source ${DK_HOME}/lib_tcl/OD/set_library_std_sec_6p25t_OD.tcl   }
#    if {$std_lib_track == "sec_7p94t"   } { source ${DK_HOME}/lib_tcl/OD/set_library_std_sec_7p94t_OD.tcl   }
    
    if {$use_gpio		} { source ${DK_HOME}/lib_tcl/OD/set_library_gpio_OD.tcl       }
    if {$use_gbe		} { source ${DK_HOME}/lib_tcl/OD/set_library_gbe_phy_OD.tcl    }
    if {$use_usb_dp		} { source ${DK_HOME}/lib_tcl/OD/set_library_usb32dp_OD.tcl    }
    if {$use_por        } { source ${DK_HOME}/lib_tcl/OD/set_library_por_OD.tcl        }
    if {$use_pcie		} { source ${DK_HOME}/lib_tcl/OD/set_library_pcie_OD.tcl       }
    if {$use_tmu		} { source ${DK_HOME}/lib_tcl/OD/set_library_tmu_OD.tcl        }
    if {$use_promise	} { source ${DK_HOME}/lib_tcl/OD/set_library_promise_OD.tcl    }
    if {$use_ucie_cxs	} { source ${DK_HOME}/lib_tcl/OD/set_library_ucie_OD.tcl       }
    if {$use_uciea		} { source ${DK_HOME}/lib_tcl/OD/set_library_uciea_OD.tcl      }
    if {$use_adc		} { source ${DK_HOME}/lib_tcl/OD/set_library_adc_OD.tcl        }
    if {$use_prtn		} { source ${DK_HOME}/lib_tcl/OD/set_library_prtn_OD.tcl       }
    if {$use_pll		} { source ${DK_HOME}/lib_tcl/OD/set_library_pll_OD.tcl       }
    if {$use_drd		} { source ${DK_HOME}/lib_tcl/OD/set_library_drd_OD.tcl       }
    if {$use_ndline		} { source ${DK_HOME}/lib_tcl/OD/set_library_ndline_OD.tcl       }
    if {$use_otp		} { source ${DK_HOME}/lib_tcl/OD/set_library_otp_OD.tcl       }
    if {$use_imem   	} { source ${DK_HOME}/lib_tcl/OD/set_library_imem_OD.tcl    }
    if {$use_mphy   	} { source ${DK_HOME}/lib_tcl/OD/set_library_mphy_OD.tcl    }

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
#if { ![file exists $OUTPUT_DIR] } { file mkdir $OUTPUT_DIR }
if { ![file exists $LOG_DIR] }    { file mkdir $LOG_DIR }
#if { ![file exists $INPUT_DIR] }  { file mkdir $INPUT_DIR }

### Specifies the name of the file to which is written a log of the
### initial values of variables and executed commands.
set sh_command_log_file ${LOG_DIR}/command.log
### Specifies the name of the filename log file to be used in case a fatal error
### occurs during execution of design_analyzer or dc_shell.
set filename_log_file   ${LOG_DIR}/filenames.log


#puts "Setting host options for CPU cores: $MAX_CORES"
#set_host_options -max_cores $MAX_CORES
puts "Reporting core options"
report_host_options

set sh_source_uses_search_path          true


###############################################################################
###  Search Path, Library and Operating Condition Section                   ###
###############################################################################
set_app_var search_path         [concat $search_path $LIBRARY_DIR]
set_app_var synthetic_library   dw_foundation.sldb
set_app_var target_library      ${TARGET_LIBRARY_FILES}
set_app_var link_library     "* ${TARGET_LIBRARY_FILES} $synthetic_library"

### Generates a Formality setup information file for efficient compare point matching in Formality.
#set_svf $OUTPUT_DIR/${TOP_DESIGN}.svf


###############################################################################
### APP_VAR_LIST (app_var & variables) RUN
###############################################################################
#foreach AVL $APP_VAR_LIST {
#    regsub -all "\{|\}" $AVL "" run_avl1
#    puts $run_avl1
#    eval $run_avl1
#}
#puts ""
#puts ""
#foreach AVL $APP_VAR_LIST {
#    regsub -all "\{|\}" $AVL "" run_avl2
#    set  idx0 [lindex $run_avl2 0]
#    set  idx1 [lindex $run_avl2 1]
#    set  idx2 [lindex $run_avl2 2]
#    if {$idx0 == "set_app_var"} {
#        printvar $idx1
#    } elseif {$idx0 == "set"} {
#        puts "$idx1 = $idx2"
#    }
#}
#

###############################################################################
### 
### analyze & elaborate
###
### Analyzes the specified HDL source files and stores the resulting templates
### into the specified library in a format ready to specialize and elaborate 
### to form linkable cells of a full design.
###############################################################################
set analyze_vcs_filelist_tmp ""
if { $SYNTHESIS_W_DFTED_RTL } {
    foreach fl1 $dftedRTLFileList {
        lappend analyze_vcs_filelist_tmp "-f $fl1"
    }
} else {
    foreach fl1 $RTLFileList {
        lappend analyze_vcs_filelist_tmp "-f $fl1"
    }
}
set analyze_vcs_filelist [regsub -all "{|\}" $analyze_vcs_filelist_tmp ""]
analyze -format sverilog -vcs "$analyze_vcs_filelist" -define "${define_list}"

elaborate ${TOP_DESIGN} > ./${LOG_DIR}/elab.log

#read_ddc ${OUTPUT_DIR}/${TOP_DESIGN}.presyn.ddc
current_design ${TOP_DESIGN}
if {[link] == 0} {
  error "Link command Failed"
  quit
}
#write -format ddc -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.presyn.ddc


###############################################################################
# Load UPF
###############################################################################
#if { $LOAD_UPF } {
#    load_upf  ${UPF_FILE}  > ./${LOG_DIR}/upf.log
#}


###############################################################################
# Check Design before compile
###############################################################################
check_design > ./${REPORT_DIR}/check_design.presyn.rpt

### Checks for violations in a multivoltage design.
#if { $LOAD_UPF } {
#    check_mv_design -verbose > ./logs/check_mv_design.presyn.log
#    write -format ddc -hierarchy -output ${OUTPUT_DIR}/${TOP_DESIGN}.presyn.mv.ddc
#}


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
### set_ungroup
###
### Sets the ungroup attribute on specified designs, cells, or references,
### indicating that they are to be ungrouped during compile.
###
###############################################################################
#if {$DONT_UNGROUP_LIST != ""} {
#    foreach ul $DONT_UNGROUP_LIST {
#        set_ungroup [get_cells -hierarchical $ul] false
#    }
#}

### foreach_in_collection col [get_pins -h -filter "full_name =~ *bda_persistent_buf_tdr_control*/udnt_buf/Y"] {
###     puts "\[INFO\]: set_case_analysis 0 [get_attribute $col full_name]"
###     set_case_analysis 0 [get_attribute $col full_name]
### }


###############################################################################
### Read in a SDC file
###############################################################################
source -echo -verbose ${SDC_FILE} > ./${LOG_DIR}/mission_sdc.log


###############################################################################
### write db
###############################################################################
write_sdc -nosplit                       dc_output_${TOP_DESIGN}.sdc

#set sec_6t_2depth [get_cells -quiet -hierarchical -filter "((ref_name =~ SDFFYRPQ2DRLV*)|(ref_name =~ SDFFYSQ2DRLV*)) && is_hierarchical==false "]

set end_time [clock seconds]
echo [string toupper inform:] End time [clock format ${end_time} -gmt false]
# Total script wall clock run time
echo "[string toupper inform:] Time elapsed: [format %02d [expr ($end_time - $start_time)/86400]]d \
      [clock format [expr ($end_time - $start_time)] -format %Hh%Mm%Ss -gmt true]"


###############################################################################
# Terminate
###############################################################################
quit
###########################################################################################
# Set up for CDC task  
###########################################################################################
# Set TOP MODULE name of function RTL
# EX: set FUNC_TOP_DESIGN   "BOS_CM7"
set FUNC_TOP_DESIGN   "BOS_MMU"
# Set TOP MODULE name of DFT RTL
set DFTed_TOP_DESIGN  ""

# Set your IP_HOME or BLK_HOME
# EX: set DIR_HOME          "${CM7_HOME}"
set DIR_HOME          "$env(MMU_DIR_HOME)"

# Set true when you want to check CDC with DFTed RTL
set CHECK_DFTED_RTL "false"
puts "CHECK CDC WITH DFTED RTL: $CHECK_DFTED_RTL"

# Set your sdc path for CDC RUN
set SDC_PATH          "01_sdc/vc_top.sdc" 

###########################################################################################
# Set parameter for making sdc using SYNOPSYS Design Compiler 
#   
# source -echo -verbose ${SDC_FILE} > ./${LOG_DIR}/mission_sdc.log
# write_sdc -nosplit    dc_output_${TOP_DESIGN}.dft.sdc 
###########################################################################################
# Set your sdc file for Design Compiler input
set SDC_FILE          "${DIR_HOME}/SDC/mission_sdc.tcl"
set USE_SDC_TCL_FOR_NETLIST "false"
# If your design is HPDF and using DFT Synthesis flow, please set true.
set SYNTHESIS_W_DFTED_RTL   "false"

###########################################################################################
# Set waiver path 
# If you have many waiver path, let's add them as following
# set WAIVER_PATH       "waiver/vc_waiver_new.tcl \
#                       waiver/vc_waiver.tcl"
###########################################################################################
set WAIVER_PATH       "vc_waiver.tcl"
###########################################################################################
### WAIVER IP LIST
###
### FORMAT:   set WAIVER_IP_LIST { <IP_NAME_0> \
###                             <IP_NAME_1> }
###
### EXAMPLE:
###  set WAIVER_IP_LIST {BOS_CM7                   \
###                      BOS_ERROR_HANDLER_WRAPPER \
###                      BOS_SAFE_TIMER            \
###                      BOS_SAFE_MAILBOX          \
###                      BOS_QSPI_CTRL             \
###                      BOS_ADC_TOP               \
###                      BOS_FAD_TOP               \
###                      BOS_PRCM_SAFE             \
###                      BOS_BUS_SAFE              \
###                      BOS_BUS_IST_PDM_SAFE      \
###                      BOS_BUS_CPU_PDM_SAFE      \
###                      }
###########################################################################################
set WAIVER_IP_LIST {} 

###########################################################################################
### SAM IP LIST 
### FORMAT: 
### set SAM_IP_LIST {
###   <IP_NAME_0> <SAM_DIR_0>
###   <IP_NAME_1> <SAM_DIR_1>
### }
###########################################################################################
set SAM_IP_LIST {}      


###########################################################################################
#                RTL LIST & BBOX setting
#
# List all the files to be used
#
# Ex. 
#     set RTLFileList         "${MSHC_HOME}/RTL/filelist.f ${MSHC_HOME}/RTL/filelist_common.f"
#     set dftedRTLFileList    "${MSHC_HOME}/RTL/filelist.f 
#                              ${MSHC_HOME}/RTL/filelist_common.f"
#
###########################################################################################
# File list for function RTL
set RTLFileList       "${DIR_HOME}/RTL/filelist.f"
#                     "${DIR_HOME}/RTL/filelist.common.f"

# File list for dfted RTL
set dftedRTLFileList  "${DIR_HOME}/RTL/filelist_dft.f \
                       ${DIR_HOME}/RTL/filelist_common.f"

# Define list, it should be same as SYNC env.
set define_list       "SYNTHESIS SEC_6P25T"             ;# "SYNTHESIS IMPL ORBIT_LIB_USE_STANDARD_CELLS"

# Set blackbox
# format: set blackbox <module_name>
set blackbox          ""

###########################################################################################
###  Set up Library to be used in current Design
#
# USER must select IPs that to be used in current Design
# 
# Select what kind of standard cell library to be used in current design
# Select one of list "sec_6t, sec_7p5t, arm_6t, arm_7p5t"
#
# "true"  if you need to use
# "false" if you don't need to use
# 
###########################################################################################

set USE_ND            "true"      ;# false : ND corner / true : OD corner

set std_lib_track     "sec_6p25t"  ;# sec_6p25t, sec7p94t
set use_gpio		      "false"      ;# false | true
set use_gbe		        "false"      ;# false | true
set use_usb_dp		    "false"      ;# false | true
set use_por           "false"      ;# false | true
set use_pcie		      "false"      ;# false | true
set use_tmu		        "false"      ;# false | true
set use_promise	      "false"      ;# false | true
set use_ucie_cxs	    "flase"      ;# false | true
set use_uciea		      "false"       ;# false | true
set use_adc		        "false"      ;# false | true
set use_prtn		      "false"      ;# false | true
set use_imem   	      "false"      ;# false | true
set use_pll   	      "false"      ;# false | true
set use_drd   	      "false"      ;# false | true
set use_ndline        "false"      ;# false | true
set use_otp           "false"      ;# false | true
set use_mphy          "false"      ;# false | true
set use_mif           "false"      ;# false | true
set use_dcphy         "false"      ;# false | true


###########################################################################################
set REPORT_DIR        ./reports
set LOG_DIR           ./logs
#set OUTPUT_DIR       ./outputs
#set INPUT_DIR        ./data

#set AUTO_SANITY_BASE_DIR "/workspace/project/N1B0/design/SANITY"
#
## check env(ML_NAME)
#if {[info exists ::env(ML_NAME)] && $::env(ML_NAME) != "" } {
#    set AUTO_SANITY_RELESE_DIR $::env(ML_NAME)
#} else {
#    puts "ERROR: ML_NAME is not defined or empty string. Exiting."
#    puts "INFO : Please setenv ML_NAME MLxxx in N1 working repository"
#    quit
#}
#puts "Using ML_NAME: $AUTO_SANITY_RELESE_DIR"
#
#if {[string match "BLK_*" $FUNC_TOP_DESIGN]} {
#    set AUTO_SANITY_TOP_FOLDER "BLK"
#} else {
#    set AUTO_SANITY_TOP_FOLDER "IP"
#}

################################################################################
### Sets the value of an application variables
### Format: set <VARIABLE> true/false
################################################################################
# Some encrypted RTL cannot be recognize synchronizer. In some case, set false. default: true.
set SYNC_INFO_RPT "true" ;#if set true, SynchInfo is reported.

###########################################################################################
# DO NOT CHANGE THIS
###########################################################################################
if {$CHECK_DFTED_RTL} {
    set TOP_DESIGN   $DFTed_TOP_DESIGN
    # # Leave this variable empty if you do not want to use it.
    # set AUTO_SANITY_DIR ""
    #set AUTO_SANITY_DIR "$AUTO_SANITY_BASE_DIR/$AUTO_SANITY_RELESE_DIR/$AUTO_SANITY_TOP_FOLDER/$TOP_DESIGN/CDC/DFT/"
} else {
    set TOP_DESIGN   $FUNC_TOP_DESIGN
    # # Leave this variable empty if you do not want to use it.
    # set AUTO_SANITY_DIR ""
    #set AUTO_SANITY_DIR "$AUTO_SANITY_BASE_DIR/$AUTO_SANITY_RELESE_DIR/$AUTO_SANITY_TOP_FOLDER/$TOP_DESIGN/CDC/FUNC/"
}

################################################################################
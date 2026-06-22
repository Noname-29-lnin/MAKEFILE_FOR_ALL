###########################################################################################
# Set up for LINT task  
###########################################################################################
# Set TOP MODULE name of function RTL
# EX: set FUNC_TOP_DESIGN   "BOS_CM7"
set FUNC_TOP_DESIGN   "BOS_MMU"
# Set TOP MODULE name of DFT RTL
set DFTed_TOP_DESIGN  ""

# Set your IP_HOME or BLK_HOME
# EX: set DIR_HOME          "${CM7_HOME}"
# set DIR_HOME          "$AXI_TO_APB_BRIDGE_HOME"
set DIR_HOME            "$env(MMU_DIR_HOME)"
# Set true when you want to check CDC with DFTed RTL
set CHECK_DFTED_RTL "false"
puts "CHECK LINT WITH DFTED RTL: $CHECK_DFTED_RTL"


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
set RTLFileList           "${DIR_HOME}/RTL/filelist.f"
set RTLFileList_vhd       ""

# File list for dfted RTL
set dftedRTLFileList      "${DIR_HOME}/RTL/filelist_dft.f \
                           ${DIR_HOME}/RTL/filelist_common.f"
set dftedRTLFileList_vhd  ""

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
set use_gpio          "false"      ;# false | true
set use_gbe           "false"      ;# false | true
set use_usb_dp        "false"      ;# false | true
set use_por           "false"      ;# false | true
set use_pcie          "false"      ;# false | true
set use_tmu           "false"      ;# false | true
set use_promise       "false"      ;# false | true
set use_ucie_cxs      "false"      ;# false | true
set use_uciea         "false"      ;# false | true
set use_adc           "false"      ;# false | true
set use_prtn          "false"      ;# false | true
set use_imem          "false"      ;# false | true
set use_pll           "false"      ;# false | true
set use_drd           "false"      ;# false | true
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
## check env(ML_NAME)
#if {[info exists ::env(ML_NAME)] && $::env(ML_NAME) != "" } {
#    set AUTO_SANITY_RELESE_DIR $::env(ML_NAME)
#} else {
#    puts "ERROR: ML_NAME is not defined or empty string. Exiting."
#    puts "INFO : Please setenv ML_NAME MLxxx in N1 working repository"
#    quit
#}
#puts "Using ML_NAME: $AUTO_SANITY_RELESE_DIR"

if {[string match "BLK_*" $FUNC_TOP_DESIGN]} {
    set AUTO_SANITY_TOP_FOLDER "BLK"
} else {
    set AUTO_SANITY_TOP_FOLDER "IP"
}

################################################################################
### Sets the value of an application variables
### Format: set_app_var <VARIABLE> true/false
################################################################################


###########################################################################################
# DO NOT CHANGE THIS
###########################################################################################
# set DFT_DIR [file tail [pwd]]
# if [regexp {DFT} $DFT_DIR] {
#     set CHECK_DFTED_RTL "true"
# } else {
#     set CHECK_DFTED_RTL "false"
# }
# puts "CHECK LINT WITH DFTED RTL: $CHECK_DFTED_RTL"

if {$CHECK_DFTED_RTL} {
    set TOP_DESIGN   $DFTed_TOP_DESIGN
    # # Leave this variable empty if you do not want to use it.
    # set AUTO_SANITY_DIR ""
    #set AUTO_SANITY_DIR "$AUTO_SANITY_BASE_DIR/$AUTO_SANITY_RELESE_DIR/$AUTO_SANITY_TOP_FOLDER/$TOP_DESIGN/LINT/DFT/"
} else {
    set TOP_DESIGN   $FUNC_TOP_DESIGN
    # # Leave this variable empty if you do not want to use it.
    # set AUTO_SANITY_DIR ""
    #set AUTO_SANITY_DIR "$AUTO_SANITY_BASE_DIR/$AUTO_SANITY_RELESE_DIR/$AUTO_SANITY_TOP_FOLDER/$TOP_DESIGN/LINT/FUNC/"
}
puts $TOP_DESIGN

###########################################################################################
### SAM LIST
###
### FORMAT:   set SAM_IP_LIST { <IP_NAME_0>  "<SAM_IP_PATH>" \
###                             <IP_NAME_1>  "<SAM_IP_PATH>"}
###
### EXAMPLE:
###  set SAM_IP_LIST {BOS_CM7                   "$CM7_HOME/CDC/sam_BOS_CM7"                               \
###                   BOS_ERROR_HANDLER_WRAPPER "$ERROR_HANDLER_HOME/CDC/sam_BOS_ERROR_HANDLER_WRAPPER"   \
###                   BOS_SAFE_TIMER            "$TIMER_HOME/CDC/SAFE_TIMER/sam_BOS_SAFE_TIMER"           \
###                   BOS_SAFE_MAILBOX          "$MAILBOX_HOME/CDC_SAFE_MAILBOX/sam_BOS_SAFE_MAILBOX"     \
###                   BOS_QSPI_CTRL             "$SPI_HOME/CDC_QSPI/sam_BOS_QSPI_CTRL"                    \
###                   BOS_ADC_TOP               "$ADC_HOME/CDC/sam_BOS_ADC_TOP"                           \
###                   BOS_FAD_TOP               "$FAD_HOME/CDC/sam_BOS_FAD_TOP"                           \
###                   BOS_PRCM_SAFE             "$PRCM_HOME/CDC/PRCM_SAFE/sam_BOS_PRCM_SAFE"              \
###                   BOS_BUS_SAFE              "$BUS_HOME/CDC/BUS_SAFE/SAM"                              \
###                   BOS_BUS_IST_PDM_SAFE      "$BUS_HOME/CDC/BUS_IST/PDM_SAFE/SAM"                      \
###                   BOS_BUS_CPU_PDM_SAFE      "$BUS_HOME/CDC/BUS_CPU/PDM_SAFE/SAM"                      \
###                   }
###########################################################################################
set SAM_IP_LIST {} 
################################################################################
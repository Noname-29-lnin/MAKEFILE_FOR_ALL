###########################################################################################
### Set up DESIGN NAME & VERILOG NETLIST and SDC from Design Compiler
###########################################################################################
### 
### Modify the following according to your environment 
### Declare the TOP_DESIGN name that is module name of IP, not standalone IP name
###
### Ex.
###     set IP_HOME             "$MSHC_HOME"
###     set TOP_DESIGN          "BOS_MSHC"
###     set TOP_DESIGN_HOME     "$MSHC_HOME"
###
set IP_HOME             "$env(MMU_DIR_HOME)"
set TOP_DESIGN          "BOS_MMU"
set TOP_DESIGN_HOME     "$env(MMU_DIR_HOME)"


###
### List all the files to be used
###
### Ex. 
###     set RTLFileList         "${MSHC_HOME}/RTL/filelist.f ${MSHC_HOME}/RTL/filelist_common.f"
###     set dftedRTLFileList    "${MSHC_HOME}/RTL/filelist.f 
###                              ${MSHC_HOME}/RTL/filelist_common.f"
###

### Set true when you want to synthesis with DFTed RTL
set SYNTHESIS_W_DFTED_RTL       "false"

set RTLFileList                 "${IP_HOME}/RTL/filelist.f"
set dftedRTLFileList            ""
### Select list : STD_6T, SEC_6T, SEC_7P5T
set define_list                 "SYNTHESIS SEC_6P25T IMPL ORBIT_LIB_USE_STANDARD_CELLS"   ;# "SYNTHESIS STD_6T IMPL ORBIT_LIB_USE_STANDARD_CELLS"


####################################################################################################
### If the current design has HPDF Sub Block, then 
### set the following variables
### 
### set HPDF_flow               "true"
### set HPDF_sub_block_name     "BOS_MIF_WRAPPER"
### set HPDF_sub_block_ddc      "${MIF_WRAPPER_HOME}/SYN/${OUTPUT_DIR}/BOS_MIF_WRAPPER.abs.ddc"
### # If SYNTHESIS_W_DFTED_RTL is true, then
### set HPDF_sub_block_ddc      "${MIF_WRAPPER_HOME}/SYN/${OUTPUT_DIR}/BOS_MIF_WRAPPER.dft.abs.ddc"
###
####################################################################################################
set HPDF_flow                   "false"
set HPDF_sub_block_name         ""
set HPDF_sub_block_ddc          ""


###########################################################################################
### Set up Library to be used in current Design
###########################################################################################
###
### USER must select IPs that to be used in current Design
### 
### Select what kind of standard cell library to be used in current design
### Select one of list "sec_6t, sec_7p5t, arm_6t, arm_7p5t"
### 
set std_lib_track   "sec_6p25t"  ;# sec_6p25t, sec7p94t

set REPORT_DIR                  ./reports
set OUTPUT_DIR                  ./outputs
set LOG_DIR                     ./logs

### Specify the name of SDC
set SDC_FILE                    "${IP_HOME}/SDC/mission_sdc.tcl"
set USE_SDC_TCL_FOR_NETLIST     "false"     ;# <-- Don't modify in Synthesis Stage

### Set true when you want to load upf (true/flase)
set LOAD_UPF                    "false"
### Specifies the name of the file containing UPF commands to be executed.
set UPF_FILE                    "${IP_HOME}/UPF/${TOP_DESIGN}.upf"
set VOLTAGE_FILE                "${IP_HOME}/UPF/${TOP_DESIGN}_set_voltage.tcl"

set pre_defined_constraint      "./pre_defined_constraint.tcl"


################################################################################
###
### ICG Cell List 
### 
### ARM 7.5T    PREICG_X4N_A7P5PP60TL_C8    | PREICGN_X4N_A7P5PP60TL_C8
### ARM 6T      PREICG_X4N_A6ZTL_C8         | PREICGN_X4N_A6ZTL_C8
### SEC 7.5T    PREICGL_D4_N_M7P5TL_C60L08  | PREICGNL_D4_N_M7P5TL_C60L08
### SEC 6T      PREICG_D4_N_S6TL_C54L08     | PREICGN_D4_N_S6TL_C54L08
###
### ARM 7.5T    PREICG_X4N_A7P5PP60TL_C10   | PREICGN_X4N_A7P5PP60TL_C10
### 
################################################################################
set user_cg_style_sequential_cell       "latch"
set user_cg_style_man_fanout            16
set user_cg_style_bitwidth              4
set user_cg_style_num_stage             3
set user_cg_style_control_point         before
set user_cg_style_control_signal        scan_enable


if {$std_lib_track == "sec_6p25t"} {
    set user_cg_style_positive_edge_logic   "integrated:PREICG_D4_N_S6P25TL_C54L04"
    set user_cg_style_negative_edge_logic   "integrated:PREICGN_D4_N_S6P25TL_C54L04"
}

set DONT_TOUCH_CELLS        ""
set DONT_TOUCH_NETS         ""
set FREEZE_NETS             ""
set DONT_USE_FILES          ""

if {$std_lib_track == "sec_6p25t"} {
    set DONT_USE_CELLS      ""
    #set DONT_USE_FILES      "${SYN_HOME}/ARM_6T_dont_use.track.list"
}

set DONT_UNGROUP_FILE       "./infeed/dont_ungroup_file"
set MULTIBIT_EXCLUDE_FILE   "./infeed/multibit_exclude_file"
set SIZE_ONLY_FILE          "./infeed/size_only_file"


### Specifies that no hierarchical boundary optimization is to be performed.
set USE_BOUNDARY_OPT            "false"         ; # true/false
### Specifies that automatic ungrouping is completely disabled. 
### All hierarchies are preserved.
set USE_AUTOUNGROUP             "false"         ; # true/false
### Disables sequential output inversion.
set USE_SEQ_INVERSION           "false"         ; # true/false

### Specifies the maximum number of CPU cores that are allowed for parallel execution.
set MAX_CORES                   4
### Sets the default number of significant digits for many reports.
set SIGNIFICANT_DIGIT           4


################################################################################
###
### Sets the value of an application variables
### 
################################################################################
set APP_VAR_LIST ""

### Controls automatic selection of wire load model.
lappend APP_VAR_LIST "set_app_var auto_wire_load_selection true"
### Enables  analysis  of multiple clocks that reach a single register
lappend APP_VAR_LIST "set_app_var timing_enable_multiple_clocks_per_reg true"
### Controls whether the tool accepts recovery and removal arcs specified in the technology library
lappend APP_VAR_LIST "set_app_var enable_recovery_removal_arcs true"
### Determines whether a default clock is assumed at input ports for 
### which a clock-specific input external delay is not defined.
lappend APP_VAR_LIST "set_app_var timing_input_port_default_clock true"
### Controls register replication with the compile_ultra and compile commands
lappend APP_VAR_LIST "set_app_var compile_register_replication false"
### Instructs the Verilog writer to write out all of the unconnected instance pins, 
### when connecting module ports by name.
lappend APP_VAR_LIST "set_app_var verilogout_show_unconnected_pins true"
### Controls the identification of shift registers in compile -scan
lappend APP_VAR_LIST "set_app_var compile_seqmap_identify_shift_registers false"
### Controls  whether shift registers that contain synchronous logic
### between the registers are identified
lappend APP_VAR_LIST "set_app_var compile_seqmap_identify_shift_registers_with_synchronous_logic false"
### FROM ADT ######################################
### MUX Congestion opt.
lappend APP_VAR_LIST "set compile_prefer_mux true"
# ### For leakage opt.
# lappend APP_VAR_LIST "set compile_enable_enhanced_leakage_optimization true"
### Identify architecturally instantiated clock gates
lappend APP_VAR_LIST "set power_cg_auto_identify   true"
### Identifies clock-gating circuitry inserted by power compiler form a strctural netlist.
lappend APP_VAR_LIST "set_app_var power_cg_auto_identify true"
lappend APP_VAR_LIST "set_app_var report_default_significant_digits 4"
### Case analysis required to support EMA value setting for memories
lappend APP_VAR_LIST "set_app_var case_analysis_with_logic_constants true"
### Specifies to the tool that nets are to receive the same names as the ports to which the nets are connected.
### nets are to receive the same names as the ports to which the nets are connected.
lappend APP_VAR_LIST "set write_name_nets_same_as_ports true"
###Declares three-state nets as Verilog wire instead  of  tri. 
lappend APP_VAR_LIST "set verilogout_no_tri true"
###T his variable controls whether the Presto HDL Compiler compresses  long names for elaborated modules.
lappend APP_VAR_LIST "set hdlin_module_name_limit 100"
lappend APP_VAR_LIST "set hdlin_shorten_long_module_name true"
##############################################################
# ### Don't optimize constants for Formality and ID registers.
# lappend APP_VAR_LIST "set_app_var compile_seqmap_propagate_constants false"
# ### Controls whether a warning  message is issued for latches inferred by incomplete combinational assignments.
# lappend APP_VAR_LIST "set_app_var hdlin_check_no_latch true"
# ### Controls whether the tool accepts recovery and removal arcs specified in the technology library.
# lappend APP_VAR_LIST "set_app_var enable_recovery_removal_arcs true"
# ### Enables and disables the support of via resistance for RC estimation.
# lappend APP_VAR_LIST "set_app_var physopt_enable_via_res_support true"
# ### Writes Verilog "modules" so that the higher-level designs come before lower-level designs, as defined by the design hierarchy.
# lappend APP_VAR_LIST "set_app_var verilogout_higher_designs_first true"
# ### Determines whether or not the write_sdc and write_script commands output net loads.
# lappend APP_VAR_LIST "set_app_var write_sdc_output_lumped_net_capacitance false"
# ### Determines whether or not the write_sdc and write_script commands output net resistance.
# lappend APP_VAR_LIST "set_app_var write_sdc_output_net_resistance false"
################################################################################
lappend APP_VAR_LIST "set_app_var compile_automatic_clock_phase_inference none"
### for using Multibit Latch & Registers  ######################################
lappend APP_VAR_LIST "set hdlin_infer_multibit default_all"
### for keeping floating pins as floating pins  ################################
lappend APP_VAR_LIST "set bind_unused_hierarchical_pins false"
################################################################################

set message_for_suppress    ""
set var_message_info        "VER-130 VER-936 VER-173"

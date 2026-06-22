###################################################################################################
#  ___ ____    _     _______     _______ _     
# |_ _|  _ \  | |   | ____\ \   / / ____| |    
#  | || |_) | | |   |  _|  \ \ / /|  _| | |    
#  | ||  __/  | |___| |___  \ V / | |___| |___ 
# |___|_|     |_____|_____|  \_/  |_____|_____|
#
#  _ __ ___ (_)___ ___(_) ___  _ __      ___  __| | ___ 
# | '_ ` _ \| / __/ __| |/ _ \| '_ \    / __|/ _` |/ __|
# | | | | | | \__ \__ \ | (_) | | | |   \__ \ (_| | (__ 
# |_| |_| |_|_|___/___/_|\___/|_| |_|___|___/\__,_|\___|
#                                  |_____|              
# Ver 1.00
#
# Update history
#
# - 2023-09-21 (Harold) Release the common IP mission_sdc.tcl format
# - 2024-07-30 (grkoo)  Release revised the common IP mission_sdc.tcl format
# 
###################################################################################################


###################################################################################################
# 1. Variable
# 
# * Please fill in the all variables used in own IP
# * Period variable is defined in "set_param.tcl" file
# * Declare a parameter to link the incoming clock and data paths from the PAD
# * Please modify and use IP_HOME variable according to your IP HOME
#   
###################################################################################################

# Modify your own directory name for IP_HOME variable
###########
set IP_HOME "$env(MMU_DIR_HOME)"

###########
if {$USE_SDC_TCL_FOR_NETLIST == true} {
    source -echo -verbose                 ${IP_HOME}/SDC/DA/set_param.tcl
    set create_clock_path                 ${IP_HOME}/SDC/DA/create_clock.tcl
    set generated_clock_path              ${IP_HOME}/SDC/DA/generated_clock.tcl
    set clock_groups_path                 ${IP_HOME}/SDC/DA/clock_groups.tcl
    set case_analysis_path                ${IP_HOME}/SDC/DA/case_analysis.tcl
    set ideal_network_path                ${IP_HOME}/SDC/DA/ideal_network.tcl
    set io_constraint_path                ${IP_HOME}/SDC/DA/io_constraint.tcl
    set pre_exception_for_allow_path_path ${IP_HOME}/SDC/DA/pre_exception_for_allow_path.tcl
    set exception_path                    ${IP_HOME}/SDC/DA/exception.tcl
    set unset_param_path                  ${IP_HOME}/SDC/DA/unset_param.tcl
} else {
    source -echo -verbose                 ${IP_HOME}/SDC/set_param.tcl
    set create_clock_path                 ${IP_HOME}/SDC/create_clock.tcl
    set generated_clock_path              ${IP_HOME}/SDC/generated_clock.tcl
    set clock_groups_path                 ${IP_HOME}/SDC/clock_groups.tcl
    set case_analysis_path                ${IP_HOME}/SDC/case_analysis.tcl
    set ideal_network_path                ${IP_HOME}/SDC/ideal_network.tcl
    set io_constraint_path                ${IP_HOME}/SDC/io_constraint.tcl
    set pre_exception_for_allow_path_path ${IP_HOME}/SDC/pre_exception_for_allow_path.tcl
    set exception_path                    ${IP_HOME}/SDC/exception.tcl
    set unset_param_path                  ${IP_HOME}/SDC/unset_param.tcl
}



###################################################################################################
# 2. Clocks
# 
# * Please fill in the all clocks by using PRCM SDC clock name.
#   (ex) create_clock -name CLOCK_TOP_BLK_CPU_CMU_CPU_DIV_CPU_PDBGCLK -period $PERIOD_375 ...
# * If PRCM doesn't have your clock, You can make the clock name by yourself.
# * Please keep the naming convention when you make the clock name by yourslef.
# 
###################################################################################################
if {$USE_SDC_TCL_FOR_NETLIST == true} {
    if {[file exists $create_clock_path]} {
        source /workspace/user/pdi/Scripts/SDC/IP_ONLY/ip_create_clock_change.tcl
        source -echo -verbose $create_clock_modified_path
    } else {
        puts "\[PDI ERROR\] : create_clock.tcl doesn't exist"
    }
} else {
    if {[file exists $create_clock_path]} {
        source -echo -verbose $create_clock_path
    } else {
        puts "\[PDI ERROR\] : create_clock.tcl doesn't exist"
    }
}

if {$USE_SDC_TCL_FOR_NETLIST == true} {
    if {[file exists $generated_clock_path]} {
        source -echo -verbose /workspace/user/pdi/Scripts/SDC/IP_ONLY/ip_generated_clock_change.tcl
        source -echo -verbose $generated_clock_modified_path
    } else {
        puts "\[PDI ERROR\] : generated_clock.tcl doesn't exist"
    }
} else {
    if {[file exists $generated_clock_path]} {
        source -echo -verbose $generated_clock_path
    } else {
        puts "\[PDI ERROR\] : generated_clock.tcl doesn't exist"
    }
}


###################################################################################################
# 3. Clock groups
# 
# * Please fill in the all clock groups by using clock name.
#   
# [NOTE] 
# You should check if "set_clock_groups" uses "allow_paths" option or not.
# And, if you make "set_clock_groups" constraints by yourself, 
# Please add "allow_paths" in the following situation. 
# 
# (ex)
# if you use "set_max_delay -from CLK_A -to CLK_B"
# Then, you should add "allow_paths" option in "set_clock_groups" as following.
# "set_clock_groups -async -group CLK_A -group CLK_B -allow_paths"
# 
###################################################################################################
if {$USE_SDC_TCL_FOR_NETLIST == true} {
    if {[file exists $clock_groups_path]} {
        source -echo -verbose /workspace/user/pdi/Scripts/SDC/IP_ONLY/ip_clock_groups_change.tcl
        source -echo -verbose $clock_groups_modified_path
    } else {
        puts "\[PDI ERROR\] : clock_groups.tcl doesn't exist"
    }
} else {
    if {[file exists $clock_groups_path]} {
        source -echo -verbose $clock_groups_path
    } else {
        puts "\[PDI ERROR\] : clock_groups.tcl doesn't exist"
    }
}


###################################################################################################
# 4. Case analysis
# 
# * Please fill in the all case analysis
#
# [NOTE]
# You should add IP_HIER variable for the all point path.
# And, for the block level synthesis,
# You need to change from "get_ports" to "get_pins" (if $IP_HIER != "").
# 
###################################################################################################
if {$USE_SDC_TCL_FOR_NETLIST == true} {
    if {[file exists $case_analysis_path]} {
        source -echo -verbose /workspace/user/pdi/Scripts/SDC/IP_ONLY/ip_case_analysis_change.tcl
        source -echo -verbose $case_analysis_modified_path
    } else {
        puts "\[PDI ERROR\] : case_analysis.tcl doesn't exist"
    }
} else {
    if {[file exists $case_analysis_path]} {
        source -echo -verbose $case_analysis_path
    } else {
        puts "\[PDI ERROR\] : case_analysis.tcl doesn't exist"
    }
}


###################################################################################################
# 5. Ideal network
# 
# * Please fill in the all ideal network for reset and specific signals.
# 
###################################################################################################
if {$PRE_SYN} {
    if {$USE_SDC_TCL_FOR_NETLIST == true} {
        if {[file exists $ideal_network_path]} {
            source -echo -verbose /workspace/user/pdi/Scripts/SDC/IP_ONLY/ip_ideal_network_change.tcl
            source -echo -verbose $ideal_network_modified_path
        } else {
            puts "\[PDI ERROR\] : ideal_network.tcl doesn't exist"
        }
    } else {
        if {[file exists $ideal_network_path]} {
            source -echo -verbose $ideal_network_path
        } else {
            puts "\[PDI ERROR\] : ideal_network.tcl doesn't exist"
        }
    }
}


###################################################################################################
# 6. Input / Output delay
# 
# * Please fill in the all TOP IO delay.
# * If you want to add delay for clock or reset lines, You should add delay as 0.
# * If you don't know input or output delay ratio, 
#   You need to use 40% ratio for clock derating period by using IO_DELAY_RATIO variable.
#   If 3rd party vendor uses the specific ratio, you should use the ratio from verdor.
# 
###################################################################################################
if {$USE_SDC_TCL_FOR_NETLIST == true} {
    if {[file exists $io_constraint_path]} {
        source -echo -verbose /workspace/user/pdi/Scripts/SDC/IP_ONLY/ip_io_constraint_change.tcl
        source -echo -verbose $io_constraint_modified_path
    } else {
        puts "\[PDI ERROR\] : io_constraint.tcl doesn't exist"
    }
} else {
    if {[file exists $io_constraint_path]} {
        source -echo -verbose $io_constraint_path
    } else {
        puts "\[PDI ERROR\] : io_constraint.tcl doesn't exist"
    }
}


###################################################################################################
# 7. Exception
# 
# * Please fill in the all exception
#   such as "set_max_delay", "set_false_path", "set_multicycle_path" and etc...
# * You should add IP_HIER variable for the all point path.
# * If the point path was top port of your IP for "set_multicycle_path", "set_false_path",
#   You need to change the constraints by following reference.
#   (ex) 
#   [Original SDC] set_false_path -from [get_ports I_TEST]
#
#                             |
#                             |
#                            \|/
#                             V
#
#   [On-board SDC] set_false_path -through [get_pins ${IP_HIER}I_TEST]
#
#   [Summary changed points] get_ports -> get_pins / -from -> -through / -to -> -through 
#
###################################################################################################
if {$USE_SDC_TCL_FOR_NETLIST == true} {
    if {[file exists $pre_exception_for_allow_path_path]} {
        source -echo -verbose /workspace/user/pdi/Scripts/SDC/IP_ONLY/ip_pre_exception_for_allow_path_change.tcl
        source -echo -verbose $pre_exception_for_allow_path_modified_path
    } else {
        puts "\[PDI ERROR\] : pre_exception_for_allow_path.tcl doesn't exist"
    }
} else {
    if {[file exists $pre_exception_for_allow_path_path]} {
        source -echo -verbose $pre_exception_for_allow_path_path
    } else {
        puts "\[PDI ERROR\] : pre_exception_for_allow_path.tcl doesn't exist"
    }
}

if {$USE_SDC_TCL_FOR_NETLIST == true} {
    if {[file exists $exception_path]} {
        source -echo -verbose /workspace/user/pdi/Scripts/SDC/IP_ONLY/ip_exception_change.tcl
        source -echo -verbose $exception_modified_path
    } else {
        puts "\[PDI ERROR\] : exception.tcl doesn't exist"
    }
} else {
    if {[file exists $exception_path]} {
        source -echo -verbose $exception_path
    } else {
        puts "\[PDI ERROR\] : exception.tcl doesn't exist"
    }
}


###################################################################################################
# 8. Un-set parameters
#
# * To avoid overwriting value because of the same parameter names.
#
###################################################################################################
if {[file exists $unset_param_path]} {
    source -echo -verbose $unset_param_path
} else {
    puts "\[PDI ERROR\] : unset_param.tcl doesn't exist"
}
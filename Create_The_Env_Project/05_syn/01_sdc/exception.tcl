###################################################################################################
# 7. Exception
# 
# * Filename    : exception.tcl
# * Command     : set_false_path
#                 set_multicycle_path
#                 set_max_delay
#                 set_min_delay
#                 set_disable_timing
# * Description : set_false_path : Identifies paths in a design to mark as false, so that they
#                                  are not considered during timing analysis
#                 set_multicycle_path : Defines the multicycle path
#                 set_max_delay : Specifies a maximum delay for timing paths
#                 set_min_delay : Specifies a minimum delay for timing paths 
#                 set_disable_timing : Disable timing arcs in a circuit
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

if {$IP_HIER == "" } {
  # Write your exception constraints
  # (ex) set_false_path -from [${get_ports_or_pins} ${IP_HIER}I_TEST]

  set_max_delay $PERIOD_ACLK -from [get_pins u_BOS_APB_SFR/r_pt_base_addr*/clocked_on] -through [get_pins u_BOS_APB_SFR/O_SFR_PT_BASE_ADDR*]
} else {
  # Write your exception constraints
  # (ex) set_false_path -through [get_pins ${IP_HIER}I_TEST]
}


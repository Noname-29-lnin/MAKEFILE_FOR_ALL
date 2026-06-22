###################################################################################################
# 4. Case analysis 
# 
# * Filename    : case_analysis.tcl
# * Command     : set_case_analysis
# * Description : Specify that a port or pin is at a constant logic value static, 1 or 0, or
#                 is considered with arising or falling transition
#
# * Please fill in the all case analysis
#
# [NOTE]
# You should add IP_HIER variable for the all point path.
# When setting the por or pin names, please use ${IP_HIER} variable
# If you use get_ports command then use ${get_port_or_pins} variable instead of "get_ports"
# 
###################################################################################################

if {$IP_HIER == ""} {
  # For the IP level,
    puts "\n4. Case Analysis - IP_LEVEL"
} else {
  # For the BLOCK level,
}

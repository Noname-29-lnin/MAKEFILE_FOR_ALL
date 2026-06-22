########################################################################################################################### 
# 1. Variable : set_param.tcl
# 
# * Defined common variables by set_common_param.tcl
# * Please fill in the all variables used in own IP
# * Period variable(PERIOD_F#) is defined in "set_common_param.tcl"
# * Please use the reserved variable(PERIOD_F#) that is pre-defined in "set_common_param.tcl" file
# * Declare a parameter to link the incoming clock and data paths from the PAD
#
########################################################################################################################### 

source -echo -verbose ${MMU_DIR_HOME}/SDC/set_common_param_for_ip.tcl

###################################################################
## Modify the following Variables according to your own environment
###################################################################
##  Set your own IP_NAME in below
set IP_NAME     "BOS_TOP"


###################################################################
## Ports
###################################################################
  set PORT_AW_IN  [get_ports "I_*_AW_*"       -filter {@direction==in}]
  set PORT_W_IN	  [get_ports "I_*_W_*"	      -filter {@direction==in}]
  set PORT_B_IN	  [get_ports "I_*_B_*"        -filter {@direction==in}]
  set PORT_AR_IN  [get_ports "I_*_AR_*"	      -filter {@direction==in}]
  set PORT_R_IN	  [get_ports "I_*_R_*"        -filter {@direction==in}]
  set PORT_P_IN   [get_ports "I_P*"	          -filter {@direction==in}]

  set PORT_P_OUT  [get_ports "O_P*"	          -filter {@direction==out}]
  set PORT_AW_OUT [get_ports "O_*_AW_*"       -filter {@direction==out}]
  set PORT_AR_OUT [get_ports "O_*_AR_*"       -filter {@direction==out}]
  set PORT_W_OUT  [get_ports "O_*_W_*"        -filter {@direction==out}]
  set PORT_B_OUT  [get_ports "O_*_B_*"	      -filter {@direction==out}]
  set PORT_R_OUT  [get_ports "O_*_R_*"	      -filter {@direction==out}]

###################################################################

###################################################################
## Clock Period Variables
###################################################################
if {$IP_HIER == ""} {
  # IP level
  # Format: set FREQ_<CLK_NAME>     <FREQ_Mhz>
  set FREQ_ACLK				1000
  set FREQ_PCLK				500 
 
  # Format:   PERIOD_<CLK_NAME>     [period_ns $FREQ_<CLK_NAME>]
  set PERIOD_ACLK			[period_ns $FREQ_ACLK]
  set PERIOD_PCLK			[period_ns $FREQ_PCLK]

} else {
  # BLK/TOP level
  # Fomat: set PERIOD_<CLK_NAME>    $PERIOD_<BLK_NAME>_<CLK_NAME>
}
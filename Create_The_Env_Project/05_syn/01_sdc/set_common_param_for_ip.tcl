########################################################################################################################### 
# 1. Variable : set_common_param.tcl
# 
# * Please fill in the all variables used in own IP
# * Period variables are defined in "mission_sdc.tcl" file 
# * Please use the variable that is pre-defined in mission_sdc.tcl
# * Declare a parameter to link the incoming clock and data paths from the PAD
#
########################################################################################################################### 

################################################# Don't modify this file ################################################## 
if {![info exists PRE_SYN]} {
	set PRE_SYN   true
	puts "Info : PRE_SYN variable does not exist, setting it to true."
}

if {![info exists IP_HIER]} {
    set IP_HIER          ""
} else {
    puts "IP_HIER value is ${IP_HIER}"
}

##################################################################################################
# Description :
#   Calculate the clock period (unit: ns) from a given input frequency (unit: MHz).
#   The period is adjusted by the global margin variable 'CLK_MARGIN'.
#
# Usage :
#   set FREQ_<CLK_NAME>    <frequency_in_MHz>
#   set PERIOD_<CLK_NAME>  [period_ns $FREQ_<CLK_NAME>]
#
# Example :
#   set FREQ_PCLK          200
#   set PERIOD_PCLK        [period_ns $FREQ_PCLK]
#
# Note :
#   - Input frequency must be provided in MHz.
#   - Returned value is the computed period in nanoseconds.
#   - Global variable 'CLK_MARGIN' must be set before using this procedure.
##################################################################################################

set CLK_MARGIN          0.4
set IO_DELAY_RATIO      0.4

proc period_ns {freq_MHz} {
  global CLK_MARGIN
  return [expr {floor((10000000.0 / $freq_MHz) * (1.0 - $CLK_MARGIN)) / 10000.0}]
}
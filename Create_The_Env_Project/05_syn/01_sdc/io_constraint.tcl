###################################################################################################
# 6. Input / Output delay
# 
# * Filename : io_constraint.tcl #
# * Command  : set_input_delay
#              set_output_delay
#
# * Please fill in the all TOP IO delay.
# * If you want to add delay for clock or reset lines, You should add delay as 0.
# * If you don't know input or output delay ratio, 
#   You need to use 40% ratio for clock derating period by using IO_DELAY_RATIO
#   variable.  If 3rd party vendor uses the specific ratio, you should use the
#   ratio from verdor.
# 
###################################################################################################

if {$IP_HIER == ""} { 
  set IO_DERATE_ACLK	[expr $IO_DELAY_RATIO*$PERIOD_ACLK] 
  set IO_DERATE_PCLK	[expr $IO_DELAY_RATIO*$PERIOD_PCLK]

  # Write your IO constraints define input/output constraints
  # -------------------------Inputs--------------------------
  set_input_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_AW_IN
  set_input_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_W_IN  
  set_input_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_B_IN	
  set_input_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_AR_IN		 
  set_input_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_R_IN		
  set_input_delay $IO_DERATE_PCLK -clock [get_clocks PCLK] $PORT_P_IN		 

  # -------------------------Outputs--------------------------
  set_output_delay $IO_DERATE_PCLK -clock [get_clocks PCLK] $PORT_P_OUT		 
  set_output_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_AW_OUT		
  set_output_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_AR_OUT		
  set_output_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_W_OUT		 
  set_output_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_B_OUT		 
  set_output_delay $IO_DERATE_ACLK -clock [get_clocks ACLK] $PORT_R_OUT		 
}
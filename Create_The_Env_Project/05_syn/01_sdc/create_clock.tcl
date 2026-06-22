###################################################################################################
# 2. Clocks 
# 
# * Filename    : create_clock.tcl
# * Command     : create_clock
# * Description : Create clock object
#
# * Please fill in the all clocks by using PRCM SDC clock name.
#   (ex) create_clock -name CLK_${CKPRCM}_DIV_CPU_PDBGCLK -period $PERIOD_375 ...
# * If PRCM doesn't have your clock, You can make the clock name by yourself.
# * Please keep the naming convention when you make the clock name by yourslef.
# 
###################################################################################################

# Ex.
#    create_clock -name CLK_${CKPRCM}_ClockName [${${get_ports_or_pins}_or_pins} ${IP_HIER}ACLK] -period $PERIOD_F400
#
if {$IP_HIER == ""} {
	create_clock -name PCLK [get_ports I_P_CLK] -period $PERIOD_PCLK 
	create_clock -name ACLK [get_ports I_A_CLK] -period $PERIOD_ACLK
}
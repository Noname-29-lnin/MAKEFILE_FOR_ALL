########################################################################################################################### 
# 1. Variable : unset_param.tcl
# 
# * Please unset the all variables used in set_param.tcl file
#
########################################################################################################################### 

if {[info exists IP_HOME]}                { unset IP_HOME }               else { puts "\[PDI INRO\] No IP_HOME                 variable is defined " }
if {[info exists IP_HIER]}                { unset IP_HIER }               else { puts "\[PDI INRO\] No IP_HIER                 variable is defined " }
if {[info exists CHECK_CDC]}              { unset CHECK_CDC }             else { puts "\[PDI INRO\] No CHECK_CDC               variable is defined " }
if {[info exists PRE_SYN]}                { unset PRE_SYN }               else { puts "\[PDI INRO\] No PRE_SYN                 variable is defined " }
if {[info exists IO_DELAY_RATIO]}         { unset IO_DELAY_RATIO }        else { puts "\[PDI INRO\] No IO_DELAY_RATIO          variable is defined " }
if {[info exists CLK_MARGIN]}             { unset CLK_MARGIN }            else { puts "\[PDI INRO\] No CLK_MARGIN              variable is defined " }
if {[info exists get_ports_or_pins]}      { unset get_ports_or_pins }     else { puts "\[PDI INRO\] No get_ports_or_pins       variable is defined " }
if {[info exists IP_NAME]}                { unset IP_NAME }               else { puts "\[PDI INRO\] No IP_NAME                 variable is defined " }
if {[info exists CKBLK_HIER]}             { unset CKBLK_HIER }            else { puts "\[PDI INRO\] No CKBLK_HIER              variable is defined " }

## In below, Add your own variables defined in set_param.tcl

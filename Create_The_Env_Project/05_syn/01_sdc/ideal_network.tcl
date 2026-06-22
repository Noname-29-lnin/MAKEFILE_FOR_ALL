##################################################################################################################
# 5. Ideal network
# 
# * Filename    : ideal_network.tcl
# * Command     : set_ideal_network
# * Description : Marks a set of ports or pins in the design as sources of an ideal network
#                 This disables timing update of cells and nets in the transitive fanout of the specified objects 
#
# * Please fill in the all ideal network for reset and specific signals.
# 
##################################################################################################################

if {$PRE_SYN} {
  if {$IP_HIER == ""} {
    # Write your ideal network constraints
    set_ideal_network [get_ports I_A_CLK]
    set_ideal_network [get_ports I_P_CLK]
    set_ideal_network [get_ports I_A_RESETN]
    set_ideal_network [get_ports I_P_RESETN]
  }
}


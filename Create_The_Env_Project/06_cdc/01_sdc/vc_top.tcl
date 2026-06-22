############################################################################
### List all sdc of your module in this file
############################################################################
source -echo -verbose 01_sdc/vc_static_${TOP_DESIGN}.sdc
source -echo -verbose 01_sdc/vc_add.tcl

############################################################################
### Configure CDC
############################################################################
# Configure the multi-flop synchronizer detection
#configure_cdc_nff_sync -allowed_modules BOS_SOC_SYNCHSR_LVT -depth 1
configure_cdc_nff_sync -allowed_modules BOS_SYNCHRONIZER     -depth 1

# Configure the reset path multi-flop synchronizers detection criteria
configure_cdc_asyncrst_nff_sync -allowed_modules BOS_SYNCHRONIZER_LVT -data_pin_connectivity tied_1 -depth 1

# Model all inputs into different virtual domain and do not report any crossings on the output ports and enable verification for virtual domain
configure_unconstrained_ports -module ${TOP_DESIGN} -input_model virtual_diff_bits -output_model no_cross          -use_inferred_domains

# Model all inputs/output port of black-boxes into different virtual domain and enable verification for virtual domain
configure_unconstrained_ports -all_bbox -input_model virtual_diff_vector -output_model virtual_diff_vector -use_inferred_domains

###############################################################################
### Use this command to specify the design object (port/pin/net) which must be treatd as Quasi-static signal
## Example: create_static -name [get_ports SFR_CM7_CFGSTCALIB       ]
###############################################################################


###############################################################################
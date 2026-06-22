#==============================================================================
# W240: BOS_APB_SFR - I_PWDATA[31:20] declared but not read
#==============================================================================

waive_lint -add W240_BOS_APB_SFR_I_PWDATA_RESERVED_BITS \
  -comment {
    Author - Nguyen Hoan Khanh

    Description - Lint W240 reports that input I_PWDATA[31:20] is declared but not read.
    I_PWDATA is a 32-bit APB write data bus, but this APB SFR block only uses
    I_PWDATA[19:0] for the implemented PT_BASE_ADDR register field.

    Reason - This warning can be waived because I_PWDATA[31:20] corresponds to
    reserved/unimplemented register bits in the BOS_APB_SFR register map. The
    implemented PT_BASE_ADDR field is [19:0]. The upper bits [31:20] are
    intentionally ignored and should not affect the SFR output value or MMU
    address translation behavior.
  } \
  -tag {W240} \
  -severity {warning} \
  -filter {
    (
      (Module == "BOS_APB_SFR") &&
      (Signal == "I_PWDATA[31:20]") &&
      (HIERARCHY == ":BOS_MMU:u_BOS_APB_SFR@BOS_APB_SFR")
    )
  } \
  -regexp


#==============================================================================
# W240: BOS_APB_SFR - I_PSTRB[3] declared but not read
#==============================================================================

waive_lint -add W240_BOS_APB_SFR_I_PSTRB_UPPER_BYTE_UNUSED \
  -comment {
    Author - Nguyen Hoan Khanh

    Description - Lint W240 reports that input I_PSTRB[3] is declared but not read.
    I_PSTRB is the APB byte strobe bus for the 32-bit APB write data bus.

    Reason - This warning can be waived because I_PSTRB[3] controls byte lane
    I_PWDATA[31:24]. In this APB SFR block, bits [31:20] of PT_BASE_ADDR are
    reserved/unimplemented, and no implemented writable field exists in byte lane
    [31:24]. Therefore I_PSTRB[3] is intentionally ignored. This does not affect
    functional behavior.
  } \
  -tag {W240} \
  -severity {warning} \
  -filter {
    (
      (Module == "BOS_APB_SFR") &&
      (Signal == "I_PSTRB[3]") &&
      (HIERARCHY == ":BOS_MMU:u_BOS_APB_SFR@BOS_APB_SFR")
    )
  } \
  -regexp


#==============================================================================
# W528: BOS_TL_BUFFER - w_victim_lzc_count[2] set but not read
#==============================================================================

waive_lint -add W528_BOS_TL_BUFFER_W_VICTIM_LZC_COUNT_MSB_UNUSED \
  -comment {
    Author - Nguyen Hoan Khanh

    Description - Lint W528 reports that w_victim_lzc_count[2] is set but not read.
    This signal is driven by the O_COUNT output of the LZC instance used for TLB
    victim-way selection.

    Reason - This warning can be waived because the LZC count output is wider
    than the index width required by the current TLB way configuration. The TLB
    has 4 ways, so only 2 bits are required to select one way. Therefore the MSB
    w_victim_lzc_count[2] is intentionally unused. This does not affect victim
    way selection because only the needed lower count bits are used by the TLB
    replacement logic.
  } \
  -tag {W528} \
  -severity {warning} \
  -filter {
    (
      (Module == "BOS_TL_BUFFER") &&
      (VariableName == "w_victim_lzc_count[2]") &&
      (HIERARCHY == ":BOS_MMU:u_BOS_TL_BUFFER@BOS_TL_BUFFER")
    )
  } \
  -regexp


#==============================================================================
# W528: BOS_TL_BUFFER - w_data_lzc_count[2] set but not read
#==============================================================================

waive_lint -add W528_BOS_TL_BUFFER_W_DATA_LZC_COUNT_MSB_UNUSED \
  -comment {
    Author - Nguyen Hoan Khanh

    Description - Lint W528 reports that w_data_lzc_count[2] is set but not read.
    This signal is driven by the O_COUNT output of the LZC instance used for TLB
    data hit/index decoding.

    Reason - This warning can be waived because the LZC count output is wider
    than the index width required by the current TLB way configuration. The TLB
    has 4 ways, so only 2 bits are required to select one way. Therefore the MSB
    w_data_lzc_count[2] is intentionally unused. This does not affect TLB lookup
    behavior because only the needed lower count bits are used.
  } \
  -tag {W528} \
  -severity {warning} \
  -filter {
    (
      (Module == "BOS_TL_BUFFER") &&
      (VariableName == "w_data_lzc_count[2]") &&
      (HIERARCHY == ":BOS_MMU:u_BOS_TL_BUFFER@BOS_TL_BUFFER")
    )
  } \
  -regexp


#==============================================================================
# W528: BOS_PT_WALKER - w_PTE_address[32] set but not read
#==============================================================================

waive_lint -add W528_BOS_PT_WALKER_PTE_ADDRESS_OVERFLOW_BIT_UNUSED \
  -comment {
    Author - Nguyen Hoan Khanh

    Description - Lint W528 reports that w_PTE_address[32] is set but not read.
    The expression r_pt_base_addr + w_PTW_vpn can produce a 33-bit result, while
    the MMU address interface uses a 32-bit address.

    Reason - This warning can be waived because BOS_MMU uses a 32-bit address
    space. The PTE address is generated from the configured page-table base and
    VPN-derived PTE offset, and the valid software/programming sequence is
    expected to keep the generated PTE address inside the supported 32-bit range.
    Therefore the overflow bit w_PTE_address[32] is intentionally unused.
  } \
  -tag {W528} \
  -severity {warning} \
  -filter {
    (
      (Module == "BOS_PT_WALKER") &&
      (VariableName == "w_PTE_address[32]") &&
      (HIERARCHY == ":BOS_MMU:u_BOS_PT_WALKER@BOS_PT_WALKER")
    )
  } \
  -regexp
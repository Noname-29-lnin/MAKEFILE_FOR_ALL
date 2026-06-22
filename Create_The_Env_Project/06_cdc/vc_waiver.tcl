##---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## CDC waiver
## Module: BOS_CM7.sv
##---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## ===== Simple waiver format =====================================================================================================================================================
# Simple waiver format
## waive_cdc  \
## 		-add     { <${IP/BLK_NAME}_waiver_name>}                                        \
## 		-comment { <Give the reason why this error/warning message is ok, no problem.>} \
##    -filter  { <expression>}                                                        \
## 		-tag     { tag_name }
##---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## ===== EXAMPLE  ================================================================================================================================================================
## waive_cdc  \
## 		-add {CM7_SETUP_PORT_UNCONSTRAINED_1}   \
## 		-comment {TRUCVO, Following are async signal, we already prepare synchronize circuit for them. we already create virtual clock for them in cdc env, so it is no problem}   \
##     -filter {(PortName =~ "SFR_CM7_CTLPPBLOCK[0]"                OR \
##               PortName =~ "SAFE_ATBASYNC_SI2_SYNC_DONE"          )} \
## 		-tag { SETUP_PORT_UNCONSTRAINED }
## 
## waive_cdc  \
## 		-add {CM7_SETUP_PORT_PARTIALLY_CONSTRAINED_1}                                                                                        \
## 		-comment {TRUCVO, this is async reset, we already create reset in setup file and specify virtual clock for them. It is  no problem.} \
## 		-filter {(Direction == "Input") AND                                                                                                  \
## 						 (Status == "Partially constrained") AND                                                                                     \
## 						 (Constraints:Constraint == "create_reset") AND                                                                              \
## 						 (PotentialSourceClockList:DataPathSourceClock:ClockName =~ "_AUTO_VCLK_PORT_*_") AND                                        \
##      (PortName == "SYSRESETN" OR                                                                                                        \
##       PortName == "CPUPORESETN")}                                                                                                       \
## 		-tag { SETUP_PORT_PARTIALLY_CONSTRAINED }
## waive_cdc                                                                                                                                                                               \
##     -add {CM7_INTEGRITY_ASYNCRESET_COMBO_MUX_761}                                                                                                                                           \
##     -comment {TRUCVO, reset pin of this ff is driven by combination reset signal, that are poresetn and sysresetn. it's no problem due to they are dont assert reset at the same time.} \
##     -filter {(SeqElement == "u_sync_sfr_cm7_cpuwait/sync_inst[0].genblk1.u_dont_touch_sync_dff2/Q") AND                                                                                 \
##              (ComboType == "combinational logic") AND                                                                                                                                   \
##              (Module == "BOS_CM7")}                                                                                                                                                     \
##     -msg {Clear pin of sequential element u_sync_sfr_cm7_cpuwait/sync_inst[0].genblk1.u_dont_touch_sync_dff2/Q is driven by combinational logic}                                        \
##     -tag { INTEGRITY_ASYNCRESET_COMBO_MUX }                                                                                                                                            
##---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## ===== Common waiver  ================================================================================================================================================================
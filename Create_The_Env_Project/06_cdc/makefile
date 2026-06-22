export PYTHON311 :=  /Infra/Tools/python/3.11.11/bin/python3.11
export SRAP_HOME := /Infra/Tools/SRAP/srap-compiler
export SANITY_CHECKER :=${SRAP_HOME}/bin/sanity_checker
export PYTHONPATH := ${SRAP_HOME}:${PYTHONPATH}
export CDC_HOME := ${MMU_DIR_HOME}/CDC/FUNC
help:
	-@echo "######################################################################"
	-@echo "make cdc		=> Run CDC (setup, integ, sync, struct), save session, dont create SAM"
	-@echo "make cdc_quick		=> Run CDC (setup, integ, sync, struct), dont save session, dont create SAM"
	-@echo "make gui		=> check cdc results in GUI"
	-@echo "make sam		=> Run CDC (setup, integ, sync, struct), dont save session, create SAM"
	-@echo " "
	-@echo "@Caution - DO NOT CLEAN for restore session"
	-@echo "make clean		=> Clean up the outputs of running. ./reports folder will be not deleted. "
	-@echo "make clean_sam		=> Clean up SAM file"
	-@echo " "
	-@echo "make help		=> Generate this help menu      "
	-@echo "######################################################################"

cdc_quick:
	-@\mkdir -p logs
	-@\mkdir -p reports
	export QUIT_CDC=true;\
	export GUI=false;\
	export SESSION=false;\
	export SAM=false;\
	$(VC_STATIC_HOME)/bin/vc_static_shell   \
		-mode64                               \
	  -lic_wait 0                           \
	  -lic_report                           \
	  -f ${CDC_HOME}/run_cdc.tcl \
	  -output_log_file logs/vcst.screen.log

sam:
	-@\mkdir -p logs
	-@\mkdir -p reports
	export GUI=false;\
	export SESSION=false;\
	export SAM=true;\
	export QUIT_CDC=true;\
	$(VC_STATIC_HOME)/bin/vc_static_shell   \
		-mode64                               \
	  -lic_wait 0                           \
	  -lic_report                           \
	  -f ${CDC_HOME}/run_cdc.tcl \
	  -output_log_file logs/vcst.screen.log

cdc:
	-@\mkdir -p logs
	-@\mkdir -p reports
	export GUI=false;\
	export SESSION=true;\
	export SAM=false;\
	export QUIT_CDC=true;\
	$(VC_STATIC_HOME)/bin/vc_static_shell   \
		-mode64                               \
	  -lic_wait 0                           \
	  -lic_report                           \
	  -f ${CDC_HOME}/run_cdc.tcl \
	  -output_log_file logs/vcst.screen.log

cdc_post:
	${PYTHON311} ${SANITY_CHECKER} cdc reports/report_cdc.full.log

gui:
	export GUI=true;\
	export SESSION=false;\
	export SAM=true;\
	export QUIT_CDC=true;\
	$(VC_STATIC_HOME)/bin/vc_static_shell \
	-mode64                               \
  -f ${CDC_HOME}/run_cdc.tcl

excel:
	-@if [ -e ./reports/report_cdc.full.log  ]; then  \
		python3 ${CDC_HOME}/script/auto.py \
		reports/report_cdc.full.log report_cdc.full ;\
	else \
		echo "Any report file is not founded. Rerun CDC."; \
	fi

waiver:
	-@if [ -e ./vc_waiver.tcl  ]; then  \
		echo "Already waiver.tcl is exist"; \
		echo "Move to another directory original vc_waiver.tcl" ; \
	else \
		echo "copy empty vc_waiver.tcl"; \
		\cp ${CDC_HOME}/vc_waiver.tcl . ;\
		python3 ${CDC_HOME}/script/auto.py \
		report_cdc.full.xlsx vc_waiver.tcl 1 2 ;\
	fi

clean:
	-@\rm -rf db_read.log
	-@\rm -rf elab*
	-@\rm -rf upf_command.log 
	-@\rm -rf vcst_command.log
	-@\rm -rf vcst_rtdb
	-@\rm -rf *_rtdb
	-@\rm -rf vcst_rtdb.bak
	-@\rm -rf novas*
	-@\rm -rf report
	-@\rm -rf *.log
	-@\rm -rf *.log.bak
	-@\rm -rf *.rc
	-@\rm -rf verdiLog
	-@\rm -rf spyglass-*
	-@\rm -rf logs*
	-@\rm -rf session*
	-@\rm -rf work*
	-@\rm -rf vcst_session.log*
	-@\rm -rf .dw_map_file
	-@\rm -rf .vcstPref
	-@\rm -rf .samWrite.lock

clean_sam:
	-@\rm -rf sam_*


setup: 
	-@if [ -e ./config_cdc.tcl  ]; then  \
		echo "Already config_cdc.tcl is exist"; \
		echo "If you want to copy from DM, please delete original config_cdc.tcl" ; \
		gvimdiff config_cdc.tcl ${CDC_HOME}/config_cdc.tcl ; \
	else \
		echo "copy config_cdc.tcl"; \
		\cp ${CDC_HOME}/config_cdc.tcl ./ ; \
	fi
	-@if [ -e ./01_sdc  ]; then  \
		echo "Already 01_sdc is exist" ; \
		echo "If you want to copy from DM, please delete original 01_sdc folder" ; \
		gvimdiff 01_sdc/vc_top.sdc ${CDC_HOME}/01_sdc/vc_top.sdc ;\
		gvimdiff 01_sdc/vc_add.tcl ${CDC_HOME}/01_sdc/vc_add.tcl ;\
		\cp -r ${CDC_HOME}/01_sdc/run_syn.tcl ./01_sdc/ ;\
		\cp -r ${CDC_HOME}/01_sdc/run_sdc2cdc.py ./01_sdc/ ;\
		\cp -r ${CDC_HOME}/01_sdc/:run_syn.csh ./01_sdc/ ;\
		\cp -r ${CDC_HOME}/01_sdc/HOW_TO_MAKE_SDC.md ./01_sdc/ ;\
	else \
		echo "copy 01_sdc folder"; \
		\cp -r ${CDC_HOME}/01_sdc ./ ;\
	fi
		
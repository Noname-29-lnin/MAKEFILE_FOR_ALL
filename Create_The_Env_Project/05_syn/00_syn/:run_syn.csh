#!/usr/bin/env csh

if ( ! -d logs/ ) then
    mkdir logs
endif
set log_date = `date "+%Y%m%d_%H%M%S"`
dc_shell -f run_syn.tcl | tee logs/run_syn_${log_date}.log
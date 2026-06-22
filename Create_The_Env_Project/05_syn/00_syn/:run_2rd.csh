#!/usr/bin/env csh

if ( ! -d logs/ ) then
    mkdir logs
endif
set log_date = `date "+%Y%m%d_%H%M%S"`
dc_shell -f run_2nd.tcl | tee logs/run_2nd_${log_date}.log
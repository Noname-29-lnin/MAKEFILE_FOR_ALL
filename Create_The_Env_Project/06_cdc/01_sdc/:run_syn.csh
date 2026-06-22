#!/usr/bin/env csh


set filename1 = `ls dc_output*.sdc | head -n 1`
if ("$filename1" != "") then
    set filename2 = `echo $filename1 | sed 's/^dc_output/vc_static/'`
    python3 run_sdc2cdc.py $filename1 $filename2
else
    source /tools/env_synopsys.csh
    if ( ! -d logs/ ) then
        mkdir logs
    endif
    set log_date = `date "+%Y%m%d_%H%M%S"`
    dc_shell -f run_syn.tcl | tee logs/run_syn.log
    rm -rf work
    rm -rf default.svf
    rm -rf filenames.log
    echo "Run dc_shell for writing sdc"
    set filename1 = `ls dc_output*.sdc | head -n 1`
    set filename2 = `echo $filename1 | sed 's/^dc_output/vc_static/'`
    python3 run_sdc2cdc.py $filename1 $filename2    
endif

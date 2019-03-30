#!/bin/bash

function getB(){
    mkdir $1_$2_$3_$4_results
    cd $1_$2_$3_$4_results
    
    PIDS=()
    sar -r 1 -u > cpu_sar.txt &
    PIDS+=($!)

    vmstat 1 > mem_vmstat.txt &
    PIDS+=($!)

    pidstat -u 1 > cpu_pidstat.txt &
    PIDS+=($!)

    pidstat -r 1 > mem_pidstat.txt &
    PIDS+=($!)

    sar -r 1 > mem_sar.txt &
    PIDS+=($!)

    iostat -d 1 > disk_iostat.txt &
    PIDS+=($!)

    vmstat -d 1 > disk_vmstat.txt &
    PIDS+=($!)

    sar -r 1 -n DEV > network_usage_sar.txt &
    PIDS+=($!)

    sar -r 1 -n EDEV > network_saturation_sar.txt &
    PIDS+=($!)

    ../bin/ft.A.x

    for pid in ${PIDS[@]}
    do
        kill -9 $pid
    done
}

function bench(){
    if [[ $vect -eq $3 ]]; then
        make compiler=$1 opt=$2 vect=1 CLASS=$4
    else
        make compiler=$1 opt=$2 CLASS=$4
    fi

    getB $1 $2 $3 $4
    make clean
}

#GNU compiler

#-O1
bench GNU 1 0 A
#-O2
bench GNU 2 0 A
#-O3
bench GNU 3 0 A
#-Os
bench GNU S 0 A
#-Ofast
bench GNU F 0 A
#-02 -ftree-vectorize
bench GNU 2 1 A

#Intel compiler

#-O1
bench INTEL 1 0 A
#-O2
bench INTEL 2 0 A
#-O3
bench INTEL 3 0 A
#-Os
bench INTEL S 0 A
#-Ofast
bench INTEL F 0 A
#-02 -ftree-vectorize
bench INTEL 2 1 A
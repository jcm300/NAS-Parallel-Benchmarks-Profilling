#!/bin/bash

function getB(){
    RESULT_DIR=../../../../Scripts/FT/$6/$5/$1_$2_$3_$4_results
    mkdir -p $RESULT_DIR

    CMDS=("sar -r 1 -u > $RESULT_DIR/cpu_sar.txt&" 
    "vmstat 1 > $RESULT_DIR/mem_vmstat.txt" 
    "pidstat -u 1 > $RESULT_DIR/cpu_pidstat.txt"
    "pidstat -r 1 > $RESULT_DIR/mem_pidstat.txt"
    "sar -r 1 > $RESULT_DIR/mem_sar.txt"
    "iostat -d 1 > $RESULT_DIR/disk_iostat.txt"
    "vmstat -d 1 > $RESULT_DIR/disk_vmstat.txt"
    "sar -r 1 -n DEV > $RESULT_DIR/network_usage_sar.txt"
    "sar -r 1 -n EDEV > $RESULT_DIR/network_saturation_sar.txt")

    for (( i = 0; i < ${#CMDS[@]}; i++ ))
    do
        ${CMDS[$i]}
        PID=($!)
        ../bin/ft.A.x
        kill -9 $pid
    done
}


function bench(){
    mkdir ../bin

    if [[ $compiler -eq "GNU" ]]; then
        module load gcc/5.3.0
    else
        source /share/apps/intel/parallel_studio_xe_2019/compilers_and_libraries_2019/linux/bin/compilervars.sh intel64
    fi

    if [[ $vect -eq $3 ]]; then
        make compiler=$1 opt=$2 vect=1 CLASS=$4 suite
    else
        make compiler=$1 opt=$2 CLASS=$4 suite
    fi

    getB $1 $2 $3 $4 $5 $6
    make clean
}

function runBench(){
    #cd ../../Benchmarks/IS_FT/$1/FT
    cd Benchmarks/IS_FT/$1/FT

    #GNU compiler

    #-O1
    bench GNU 1 0 A $1 $2
    #-O2
    bench GNU 2 0 A $1 $2
    #-O3
    bench GNU 3 0 A $1 $2
    #-Os
    bench GNU S 0 A $1 $2
    #-Ofast
    bench GNU F 0 A $1 $2
    #-02 -ftree-vectorize
    bench GNU 2 1 A $1 $2

    #Intel compiler

    #-O1
    bench INTEL 1 0 A $1 $2
    #-O2
    bench INTEL 2 0 A $1 $2
    #-O3
    bench INTEL 3 0 A $1 $2
    #-Os
    bench INTEL S 0 A $1 $2
    #-Ofast
    bench INTEL F 0 A $1 $2
    #-02 -ftree-vectorize
    bench INTEL 2 1 A $1 $2
}

#SEQ
runBench NPB3.3-SER $1 
#OMP
runBench NPB3.3-OMP $1
#MPI
runBench NPB3.3-MPI $1

#!/bin/bash

function getB(){
    CUR_RESULT_DIR=$RESULT_DIR/$6/$5/$1_$2_$3_$4_results
    mkdir -p $CUR_RESULT_DIR

    CMDS=("sar -r 1 -u"
    "vmstat 1"
    "pidstat -u 1"
    "pidstat -r 1"
    "sar -r 1"
    "iostat -d 1"
    "vmstat -d 1"
    "sar -r 1 -n DEV"
    "sar -r 1 -n EDEV")

    OUTPUT_DIR=("$CUR_RESULT_DIR/cpu_sar.txt" 
    "$CUR_RESULT_DIR/mem_vmstat.txt" 
    "$CUR_RESULT_DIR/cpu_pidstat.txt"
    "$CUR_RESULT_DIR/mem_pidstat.txt"
    "$CUR_RESULT_DIR/mem_sar.txt"
    "$CUR_RESULT_DIR/disk_iostat.txt"
    "$CUR_RESULT_DIR/disk_vmstat.txt"
    "$CUR_RESULT_DIR/network_usage_sar.txt"
    "$CUR_RESULT_DIR/network_saturation_sar.txt")

    for (( i = 0; i < ${#CMDS[@]}; i++ ))
    do
        ${CMDS[$i]} > ${OUTPUT_DIR[$i]} &
        PID=($!)
        if [[ $5 == "NPB3.3-MPI" ]]; then
            bin/is.$4.8
        else
            if [[ $5 == "NPB3.3-OMP" ]]; then
                setenv OMP_NUM_THREADS 8
            fi
            bin/is.$4.x
        fi
        kill -9 $PID
    done

}


function bench(){
    mkdir bin

    make COMPILER_T=$1 OPT=$2 VECT=$3 suite

    getB $1 $2 $3 $4 $5 $6

    rm -r bin
    make clean
}

function runBench(){
    cd $PROJ_ROOT/Benchmarks/IS/$1/

    #GNU compiler

    #-O1
    #bench GNU 1 0 B $1 $2
    #-O2
    bench GNU 2 0 B $1 $2
    #-O3
    bench GNU 3 0 B $1 $2
    #-Os
    #bench GNU S 0 B $1 $2
    #-Ofast
    bench GNU F 0 B $1 $2
    #-02 -ftree-vectorize
    #bench GNU 2 1 B $1 $2

    #Intel compiler

    #-O1
    #bench INTEL 1 0 B $1 $2
    #-O2
    bench INTEL 2 0 B $1 $2
    #-O3
    bench INTEL 3 0 B $1 $2
    #-Os
    #bench INTEL S 0 B $1 $2
    #-Ofast
    bench INTEL F 0 B $1 $2
    #-02 -ftree-vectorize
    #bench INTEL 2 1 B $1 $2
}

PROJ_ROOT=$PWD
RESULT_DIR=$PROJ_ROOT/FT_RESULTS

module load gcc/5.3.0
module load gnu/openmpi_eth/1.8.2
module load intel/openmpi_eth/1.8.2 
source /share/apps/intel/parallel_studio_xe_2019/compilers_and_libraries_2019/linux/bin/compilervars.sh intel64

#SEQ
runBench NPB3.3-SER $1 
#OMP
runBench NPB3.3-OMP $1
#MPI
runBench NPB3.3-MPI $1

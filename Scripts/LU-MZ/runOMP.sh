#!/bin/bash

function getB(){
    CUR_RESULT_DIR=$RESULT_DIR/$5/$4/$1_$2_$3_results
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
        
	if [[ $1 == "INTEL" ]]; then
            source /share/apps/intel/parallel_studio_xe_2019/compilers_and_libraries_2019/linux/bin/compilervars.sh intel64
        else
            module load gcc/5.3.0
        fi
	export OMP_STACKSIZE=500m
	export KMP_STACKSIZE=500m
	export GOMP_STACKSIZE=500m
	export OMP_NUM_THREADS=16
	../bin/lu-mz.$3.x
        kill -9 $PID
    done

}


function bench(){
    rm -rf bin
    mkdir bin

    cd LU-MZ
    if [[ $1 == "INTEL" ]]; then
        source /share/apps/intel/parallel_studio_xe_2019/compilers_and_libraries_2019/linux/bin/compilervars.sh intel64
    else
        module load gcc/5.3.0
    fi
    
    make COMPILER_T=$1 OPT=$2 CLASS=$3

    getB $1 $2 $3 $4 $5

    cd ..
    make clean
}

function runBench(){
    cd $PROJ_ROOT/Benchmarks/LU-MZ/$1

    #GNU compiler
    #-O2
    bench GNU 2 $3 $1 $2
    #-O3
    bench GNU 3 $3 $1 $2
    #-Ofast
    bench GNU F $3 $1 $2

    #Intel compiler
    #-O2
    bench INTEL 2 $3 $1 $2
    #-O3
    bench INTEL 3 $3 $1 $2
    #-Ofast
    bench INTEL F $3 $1 $2

}

PROJ_ROOT=$PWD
RESULT_DIR=$PROJ_ROOT/LU-MZ_RESULTS

#SEQ
#runBench NPB3.3-MZ-SER $1 $2
#OMP
runBench NPB3.3-MZ-OMP $1 A
runBench NPB3.3-MZ-OMP $1 B
#MPI
#runBench NPB3.3-MZ-MPI $1 $2

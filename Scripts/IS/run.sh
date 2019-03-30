#!/bin/sh
#
#PBS -N IS
#PBS -l walltime=05:00
#PBS -l nodes=1:ppn=1
#PBS -q mei

function getB(){
    sar -u 1 > sarU_$1_$2_$3_$4.txt &
    ../bin/is.A.x
    vmstat 1 > vmstat_$1_$2_$3_$4.txt &
    ../bin/is.A.x
    pidstat -u 1 > pidstatU_$1_$2_$3_$4.txt &
    ../bin/is.A.x
    pidstat -r 1 > pidstatR_$1_$2_$3_$4.txt &
    ../bin/is.A.x
    vmstat -d 1 > vmstatD_$1_$2_$3_$4.txt &
    ../bin/is.A.x
    sar -n DEV > sarNDEV_$1_$2_$3_$4.txt &
    ../bin/is.A.x
    sar -n EDEV > sarNEDEV_$1_$2_$3_$4.txt &
    ../bin/is.A.x
    rm ../bin/is.A.x
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

cd ../../Kernels/SEQ/IS

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
#!/bin/sh

function getB(){
    folder=../../../../Scripts/IS/$6/$5/$1_$2_$3_$4_results
    mkdir -p $folder

    sar -r 1 -u > $folder/cpu_sar.txt &
    PID=$!
    ../bin/is.A.x
    kill -9 $PID

    vmstat 1 > $folder/mem_vmstat.txt &
    PID=$!
    ../bin/is.A.x
    kill -9 $PID

    pidstat -u 1 > $folder/cpu_pidstat.txt &
    PID=$!
    ../bin/is.A.x
    kill -9 $PID

    pidstat -r 1 > $folder/mem_pidstat.txt &
    PID=$!
    ../bin/is.A.x
    kill -9 $PID

    sar -r 1 > $folder/mem_sar.txt &
    PID=$!
    ../bin/is.A.x
    kill -9 $PID

    iostat -d 1 > $folder/disk_iostat.txt &
    PID=$!
    ../bin/is.A.x
    kill -9 $PID

    vmstat -d 1 > $folder/disk_vmstat.txt &
    PID=$!
    ../bin/is.A.x
    kill -9 $PID

    sar -r 1 -n DEV > $folder/network_usage_sar.txt &
    PID=$!
    ../bin/is.A.x
    kill -9 $PID

    sar -r 1 -n EDEV > $folder/network_saturation_sar.txt &
    PID=($!)
    ../bin/is.A.x
    kill -9 $PID

    rm ../bin/is.A.x
}

function bench(){
    mkdir ../bin

    if [[ $compiler -eq "GNU" ]]; then
        #module load gcc/7.2.0
        module load gcc/5.3.0 #o 7.2.0 estava a dar erro de load, usar este
    else
        source /share/apps/intel/parallel_studio_xe_2019/compilers_and_libraries_2019/linux/bin/compilervars.sh intel64
    fi

    if [[ $vect -eq $3 ]]; then
        make compiler=$1 opt=$2 vect=1 CLASS=$4
    else
        make compiler=$1 opt=$2 CLASS=$4
    fi

    getB $1 $2 $3 $4 $5 $6
    make clean
}

function runBench(){
    #cd ../../Benchmarks/IS_FT/$1/IS
    cd Benchmarks/IS_FT/$1/IS #no Cluster ao fazer qsub tem de ser assim

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

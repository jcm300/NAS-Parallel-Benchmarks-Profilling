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
	    if [[ $1 == "INTEL" ]]; then
	        if [[ $6 == "FTr641Myri" ]]; then
                module load intel/openmpi_mx/1.8.2
                /share/apps/openmpi/1.8.2/intel/mx/bin/mpirun -rr -genv I_MPI_FABRICS mx -np 8 ./ft.$4.8
	        else
                module load intel/openmpi_eth/1.8.2
                /share/apps/openmpi/1.8.2/intel/eth/bin/mpirun -rr -np 8 ./ft.$4.8
	        fi
	    else
	    	if [[ $6 == "FTr641Myri" ]]; then
			    module load gnu/openmpi_mx/1.8.2
                /share/apps/openmpi/1.8.2/gnu/mx/bin/mpirun --map-by node btl mx -np 8 ./ft.$4.8
		    else
			    module load gnu/openmpi_eth/1.8.2
                /share/apps/openmpi/1.8.2/gnu/eth/bin/mpirun --map-by node -np 8 ./ft.$4.8
		    fi
	    fi
	else
        ./ft.$4.x
	fi
        kill -9 $PID
    done

}


function bench(){
    mkdir bin

    make COMPILER_T=$1 OPT=$2 VECT=$3 suite
	
    cd bin

    getB $1 $2 $3 $4 $5 $6
	
    cd ..

    rm -r bin
    make clean
}

function runBench(){
    cd $PROJ_ROOT/Benchmarks/FT/$1/

    #Class A

    #GNU compiler

    #-O2
    bench GNU 2 0 A $1 $2
    #-O3
    bench GNU 3 0 A $1 $2
    #-Ofast
    bench GNU F 0 A $1 $2

    #Intel compiler

    #-O2
    bench INTEL 2 0 A $1 $2
    #-O3
    bench INTEL 3 0 A $1 $2
    #-Ofast
    bench INTEL F 0 A $1 $2

    #Class B

    #GNU compiler

    #-O2
    bench GNU 2 0 B $1 $2
    #-O3
    bench GNU 3 0 B $1 $2
    #-OfBst
    bench GNU F 0 B $1 $2

    #Intel compiler

    #-O2
    bench INTEL 2 0 B $1 $2
    #-O3
    bench INTEL 3 0 B $1 $2
    #-OfBst
    bench INTEL F 0 B $1 $2
}

PROJ_ROOT=$PWD
RESULT_DIR=$PROJ_ROOT/FT_RESULTS

module load gcc/5.3.0
source /share/apps/intel/parallel_studio_xe_2019/compilers_and_libraries_2019/linux/bin/compilervars.sh intel64

if [[ $1 == "FTr641Myri" ]]; then
    #MPI
    runBench NPB3.3-MPI $1
else
    #SEQ
    runBench NPB3.3-SER $1 
    #OMP
    runBench NPB3.3-OMP $1
    #MPI
    runBench NPB3.3-MPI $1
fi

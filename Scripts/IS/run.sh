#!/bin/sh
#
#PBS -N IS
#PBS -l walltime=05:00
#PBS -l nodes=1:ppn=1
#PBS -q mei

cd ../Kernels/SEQ/IS


#GNU compiler

#-O1
make compiler=GNU opt=1 CLASS=

#-O2
make compiler=GNU opt=2 CLASS=

#-O3
make compiler=GNU opt=3 CLASS=

#-Os
make compiler=GNU opt=S CLASS=

#-Ofast
make compiler=GNU opt=F CLASS=

#-02 -ftree-vectorize
make compiler=GNU opt=2 vect=1 CLASS=

#Intel compiler

#-O1
make compiler=INTEL opt=1 CLASS=

#-O2
make compiler=INTEL opt=2 CLASS=

#-O3
make compiler=INTEL opt=3 CLASS=

#-Os
make compiler=INTEL opt=S CLASS=

#-Ofast
make compiler=INTEL opt=F CLASS=

#-02 -ftree-vectorize
make compiler=INTEL opt=2 vect=1 CLASS=

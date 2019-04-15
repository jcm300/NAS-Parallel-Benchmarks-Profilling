mkdir -p ~/LU-MZ_RESULTS

qsub -N FTr641 -l nodes=1:r641:ppn=32 -l walltime=150:00 -q mei run.sh -F "FTr641"

qsub -N FTr432 -l nodes=1:r432:ppn=24 -l walltime=150:00 -q mei run.sh -F "FTr432"

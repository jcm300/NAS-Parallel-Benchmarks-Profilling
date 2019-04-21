mkdir -p ~/FT_RESULTS

qsub -N FTr641 -l nodes=1:r641:ppn=32 -l walltime=120:00 -q mei run.sh -F "FTr641"

qsub -N FTr431 -l nodes=1:r431:ppn=24 -l walltime=120:00 -q day run.sh -F "FTr431"


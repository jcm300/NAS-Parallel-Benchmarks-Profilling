mkdir -p ~/FT_RESULTS

qsub -N FTr662 -l nodes=1:r662:ppn=48 -l walltime=120:00 -q mei run.sh -F "FTr662"

qsub -N FTr641 -l nodes=1:r641:ppn=32 -l walltime=120:00 -q mei run.sh -F "FTr641"

qsub -N FTr432 -l nodes=1:r432:ppn=24 -l walltime=120:00 -q mei run.sh -F "FTr432"

qsub -N FTr781 -l nodes=1:r781:ppn=64 -l walltime=120:00 -q day run.sh -F "FTr781"

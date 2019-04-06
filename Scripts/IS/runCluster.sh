qsub -N ISr662 -l nodes=1:r662:ppn=48 -l walltime=30:00 -q mei run.sh -F "ISr662"

qsub -N ISr641 -l nodes=1:r641:ppn=32 -l walltime=30:00 -q mei run.sh -F "ISr641"

qsub -N ISr432 -l nodes=1:r432:ppn=24 -l walltime=30:00 -q mei run.sh -F "ISr432"

qsub -N ISr781 -l nodes=1:r781:ppn=64 -l walltime=30:00 -q mei run.sh -F "ISr781"

qsub -N ISr662 -l nodes=1:r662:ppn=48 -l walltime=120:00 -q mei run.sh -F "ISr662"

qsub -N ISr662Myri -l nodes=1:r662:myri:ppn=48 -l walltime=120:00 -q mei run.sh -F "ISr662Myri"

qsub -N ISr432 -l nodes=1:r432:ppn=24 -l walltime=120:00 -q mei run.sh -F "ISr432"

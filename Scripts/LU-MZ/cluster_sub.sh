mkdir -p ~/LU-MZ_RESULTS

qsub -N LUMZr641 -l nodes=1:r641:ppn=32 -l walltime=180:00 -q day run.sh -F "LUMZr641"

qsub -N LUMZr432 -l nodes=1:r432:ppn=24 -l walltime=360:00 -q day run.sh -F "LUMZr432"

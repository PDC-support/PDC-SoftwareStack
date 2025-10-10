#!/bin/bash
#SBATCH -A pdc.staff
#SBATCH -J vasp
#SBATCH -t 02:00:00
#SBATCH -p gpugh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 72
#SBATCH --gpus-per-task 1

# Run time modules and executable paths
ml cpeNVIDIA
# Set UPPASDPATH and UPPASDEXEC

# Runtime environment
export OMP_NUM_THREADS=72
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

echo "Script initiated at `date` on `hostname`"
time $UPPASDPATH/bin/$UPPASDEXEC > out.log
echo "Script finished at `date` on `hostname`"

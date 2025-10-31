#!/bin/bash
#SBATCH -A pdc.staff
#SBATCH -J qe
#SBATCH -t 02:00:00
#SBATCH -p gpugh
#SBATCH -N 2
#SBATCH -n 8
#SBATCH -c 72
#SBATCH --gpus-per-task 1

# Run time modules and executable paths
ml PDC/25.03
ml quantum-espresso/7.5.0

# Runtime environment
export MPICH_GPU_SUPPORT_ENABLED=1
export PMPI_GPU_AWARE=1
export OMP_NUM_THREADS=72
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

echo "Script initiated at `date` on `hostname`"
srun --hint=nomultithread pw.x -in C_diamond.in > myjob.out
echo "Script finished at `date` on `hostname`"

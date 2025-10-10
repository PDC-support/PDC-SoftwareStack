#!/bin/bash
#SBATCH -A pdc.staff
#SBATCH -J vasp
#SBATCH -t 02:00:00
#SBATCH -p gpugh
#SBATCH -N 2
#SBATCH -n 8
#SBATCH -c 72
#SBATCH --gpus-per-task 1

# Run time modules and executable paths
ml cpeNVIDIA
export LD_LIBRARY_PATH=/opt/nvidia/hpc_sdk/Linux_aarch64/24.11/compilers/extras/qd/lib/:$LD_LIBRARY_PATH
export PATH=/pdc/software/25.03/other/vasp/vasp-source/vasp.6.5.1-gh13/bin/:$PATH

# Runtime environment
export MPICH_GPU_SUPPORT_ENABLED=1
export PMPI_GPU_AWARE=1
export OMP_NUM_THREADS=72
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

echo "Script initiated at `date` on `hostname`"
time srun -n 8 vasp_std
echo "Script finished at `date` on `hostname`"

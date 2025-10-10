#!/bin/bash
#SBATCH -A pdc.staff
#SBATCH -J gpaw
#SBATCH -t 02:00:00
#SBATCH -p gpugh
#SBATCH -n 4
#SBATCH -c 72
#SBATCH --gpus-per-task=1
#SBATCH -x nid002897

# Modules and paths for GPAW on Dardel
# To use, set the variable GPAWROOT in the shell
ml cpeNVIDIA
source $GPAWROOT/GPAWgpucpenvidia/gpaw-25.7.0/gpawenv/bin/activate
export LD_LIBRARY_PATH=$GPAWROOT/GPAWgpucpenvidia/gpaw-25.7.0/libxc-7.0.0/build/install/lib:$LD_LIBRARY_PATH

# Runtime environment
export MPICH_GPU_SUPPORT_ENABLED=1
export PMPI_GPU_AWARE=1
export OMP_NUM_THREADS=72
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
export GPAW_NEW=1
export GPAW_USE_GPUS=1
export CUDA_VISIBLE_DEVICES=1,2,3,4

echo "Script initiated at `date` on `hostname`"
time srun -n 4 gpaw python gaasbi_gpu.py
echo "Script finished at `date` on `hostname`"

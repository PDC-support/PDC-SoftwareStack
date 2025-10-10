#!/bin/bash

#SBATCH -A pdc.staff
#SBATCH -J vasp
#SBATCH -t 02:00:00
#SBATCH -p gpugh
#SBATCH -n 4
#SBATCH -c 16

# Job script for VASP 6.5.1 on Dardel Grace Hopper nodes

# Runtime environment
ml cpeNVIDIA
export LD_LIBRARY_PATH=/opt/nvidia/hpc_sdk/Linux_aarch64/24.11/compilers/extras/qd/lib/:$LD_LIBRARY_PATH
export MPICH_GPU_SUPPORT_ENABLED=1
export PMPI_GPU_AWARE=1
export OMP_NUM_THREADS=16
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
#srun --hint=nomultithread vasp

echo === hostname ===
hostname
echo

echo === workdir ===
pwd
echo

export VASP_TESTSUITE_EXE_STD="srun -n 4 $PWD/bin/vasp_std"
export VASP_TESTSUITE_EXE_GAM="srun -n 4 $PWD/bin/vasp_gam"
export VASP_TESTSUITE_EXE_NCL="srun -n 4 $PWD/bin/vasp_ncl"

make test_all

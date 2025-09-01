#!/bin/bash

#SBATCH -A pdc.staff
#SBATCH -J vasp
#SBATCH -t 24:00:00
#SBATCH -p gpugh
#SBATCH -n 4
#SBATCH -c 72
#SBATCH --gpus-per-task 1
#SBATCH -x nid002897

# Add to module path
module use /opt/cray/pe/lmod/modulefiles/comnet/nvidia/23.11/ofi/1.0
module use /opt/cray/pe/lmod/modulefiles/compiler/nvidia/23.9

# Load modules
ml PrgEnv-nvidia
ml cuda/12.6
ml cudatoolkit/24.11_12.6
ml craype-arm-grace
ml craype-accel-nvidia90
ml cray-fftw/3.3.10.10

# Run time linking
export LD_LIBRARY_PATH=/opt/nvidia/hpc_sdk/Linux_aarch64/24.11/cuda/12.6/targets/sbsa-linux/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/nvidia/hpc_sdk/Linux_aarch64/24.11/compilers/extras/qd/lib/:$LD_LIBRARY_PATH:$LD_LIBRARY_PATH

# Runtime environment
export MPICH_GPU_SUPPORT_ENABLED=1
export PMPI_GPU_AWARE=1
export OMP_NUM_THREADS=72
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

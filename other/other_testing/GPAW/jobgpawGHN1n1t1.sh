#!/bin/bash
#SBATCH -A pdc.staff
#SBATCH -J gpaw
#SBATCH -t 02:00:00
#SBATCH -p gpugh
#SBATCH -n 4
#SBATCH -c 72
#SBATCH --gpus-per-task=1

# Environment for GPAW on  Dardel
ml cray-python/3.11.7
source /cfs/klemming/home/h/hellsvik/Thora/Codes/GPAW/GPAWgpugh257s/gpaw-25.7.0/gpawenv/bin/activate
module use /opt/cray/pe/lmod/modulefiles/comnet/nvidia/23.11/ofi/1.0
module use /opt/cray/pe/lmod/modulefiles/compiler/nvidia/23.9
ml PrgEnv-nvidia
ml cuda/12.6
ml cray-fftw/3.3.10.10
ml craype-arm-grace
ml craype-accel-nvidia90
export LD_LIBRARY_PATH=/opt/nvidia/hpc_sdk/Linux_aarch64/24.11/cuda/12.6/targets/sbsa-linux/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/nvidia/hpc_sdk/Linux_aarch64/24.11/compilers/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/nvidia/hpc_sdk/Linux_aarch64/24.11/math_libs/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/cfs/klemming/home/h/hellsvik/Thora/Codes/GPAW/GPAWgpugh257s/gpaw-25.7.0/libxc-7.0.0/build/install/lib:$LD_LIBRARY_PATH

# Runtime environment
export MPICH_GPU_SUPPORT_ENABLED=1
#export PMPI_GPU_AWARE=1
export OMP_NUM_THREADS=1
export OMP_PLACES=cores
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
export GPAW_NEW=1
export GPAW_USE_GPUS=1

echo "Script initiated at `date` on `hostname`"
time srun -n 1 gpaw python gaasbi_gpu.py
echo "Script finished at `date` on `hostname`"

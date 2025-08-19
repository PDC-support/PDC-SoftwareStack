#!/bin/bash
#SBATCH -A pdc.staff
#SBATCH -J vasp
#SBATCH -t 02:00:00
#SBATCH -p gpugh
#SBATCH -n 4
#SBATCH -c 16

# Build instructions for VASP 6.5.1 on Dardel Grace Hopper nodes

# Add to module path
module use /opt/cray/pe/lmod/modulefiles/comnet/nvidia/23.11/ofi/1.0
module use /opt/cray/pe/lmod/modulefiles/compiler/nvidia/23.11

# Load build environment
ml PrgEnv-nvidia
ml cuda/12.6
ml cudatoolkit/24.11_12.6
ml cray-fftw/3.3.10.10

# Why are not these loaded by default?
ml craype-network-ofi
ml cray-mpich/8.1.32

export CRAY_ACCEL_TARGET=nvidia90

# Compile time linking
export LIBRARY_PATH=/opt/nvidia/hpc_sdk/Linux_aarch64/24.11/comm_libs/12.6/openmpi4/openmpi-4.1.5/lib/:$LIBRARY_PATH

echo === hostname ===
hostname
echo

echo === workdir ===
pwd
echo

echo === loaded modules ===
ml

make

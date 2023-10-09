#!/bin/bash
#SBATCH -A pdc.staff          # Set the allocation to be charged for this job
#SBATCH -J buildgmx           # The name of the script is myjob
#SBATCH -t 24:00:00           # 24 hours wall-clock time
#SBATCH -p gpu                # The partition
#SBATCH -N 1                  # Number of nodes
#SBATCH -n 8                  # Number of tasks
#SBATCH -c 8                 # Number of cpus per task

# Build instructions for GROMACS 2023.2 OpenSYCL GPU version on Dardel

# Download and untar the source code
#wget https://gitlab.com/gromacs/gromacs/-/archive/v2023.2/gromacs-v2023.2.tar.gz
tar xvf gromacs-v2023.2.tar.gz
cd gromacs-v2023.2

# Load the environment
ml PDC/22.06
ml rocm/5.3.3
ml cray-fftw/3.3.10.1
ml craype-hugepages8M
ml craype-accel-amd-gfx90a
ml cmake/3.23.0
ml hipsycl/0.9.4-cpeGNU-22.06-rocm-5.3.3-llvm
ml heffte/2.3.0-cpeGNU-22.06

# Configure Single precision GPU SYCL
mkdir buildGPU
cd buildGPU

cmake .. -DCMAKE_BUILD_TYPE=Release -DGMX_BUILD_OWN_FFTW=OFF \
      -DGMX_SIMD=AVX2_256 -DGMX_OPENMP=ON -DGMXAPI=ON -DGMX_MPI=ON\
      -DCMAKE_INSTALL_PREFIX=`pwd`/install \
      -DCMAKE_C_COMPILER=${ROCM_PATH}/llvm/bin/clang \
      -DCMAKE_CXX_COMPILER=${ROCM_PATH}/llvm/bin/clang++ \
      -DCMAKE_CXX_FLAGS=-fuse-ld=ld -DCMAKE_C_FLAGS=-fuse-ld=ld \
      -DGMX_GPU_FFT_LIBRARY=rocFFT -DGMX_USE_HEFFTE=ON \
      -DGMX_GPU=SYCL -DGMX_SYCL_HIPSYCL=ON -DHIPSYCL_TARGETS='hip:gfx90a' > BuildGROMACS_CMakeLog.txt 2>&1

# Build and install
make -j 64 > BuildGROMACS_make.txt 2>&1
make -j 64 check > BuildGROMACS_check.txt 2>&1
make install

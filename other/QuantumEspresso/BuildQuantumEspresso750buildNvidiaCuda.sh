#!/bin/bash
# Build instructions for Quantum Espresso on Dardel Grace Hopper nodes

# Download and untar the source code
wget https://gitlab.com/QEF/q-e/-/archive/qe-7.5/q-e-qe-7.5.tar.gz
tar xvf q-e-qe-7.5.tar.gz
cd q-e-qe-7.5

# Load the environment, Gnu toolchain
ml PrgEnv-nvidia
ml cudatoolkit/24.11_12.6
ml craype-accel-nvidia90
ml cray-fftw/3.3.10.10
ml cray-hdf5/1.14.3.5
ml cmake/4.1.2

# Configure
mkdir buildNvidiaCuda
cd buildNvidiaCuda

cmake .. -DQE_ENABLE_LIBXC=0 -DQE_ENABLE_OPENMP=1 -DQE_ENABLE_SCALAPACK=1 \
      -DQE_ENABLE_WANNIER90=0 -DQE_ENABLE_ELPA=0 -DQE_ENABLE_HDF5=1 \
      -DBLAS_LIBRARIES="-L${CRAY_LIBSCI_PREFIX_DIR}/lib -lsci_nvidia_mp" \
      -DLAPACK_LIBRARIES="-L${CRAY_LIBSCI_PREFIX_DIR}/lib -lsci_nvidia_mp" \
      -DSCALAPACK_LIBRARIES="-L${CRAY_LIBSCI_PREFIX_DIR}/lib -lsci_nvidia_mp" \
      -DFFTW3_INCLUDE_DIRS="${FFTW_INC}" \
      -DQE_ENABLE_CUDA=1 \
      -DQE_ENABLE_MPI_GPU_AWARE=1 \
      -DQE_ENABLE_OPENACC=1 \
      -DCMAKE_INSTALL_PREFIX=/pdc/software/25.03/other/quantum-espresso/7.5.0 \
      > BuildQuantumEspresso_CMakeLog.txt 2>&1

# Build and install
make -j 72 all > BuildQuantumEspresso_make.txt 2>&1
make install

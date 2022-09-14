# Build instructions for Wien2K on Dardel

# Intel OneAPI build environment

ml PDC/21.11
ml intel-oneapi/2022.0.2

export PATH=/pdc/software/21.11/other/intel/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/pdc/software/21.11/other/intel/openmpi/lib:$LD_LIBRARY_PATH

# Use configuration files as contained in this directory
WIEN2k_OPTIONS
WIEN2k_COMPILER
WIEN2k_MPI
WIEN2k_parallel_options
WIEN2k_SYSTEM
WIEN2k_VERSION

# Build instructions for Wien2k on Dardel

# Gnu build environment
ml PrgEnv-gnu
ml cray-fftw/3.3.8.12

# Use configuration files as contained in this directory
WIEN2k_OPTIONS
WIEN2k_COMPILER
WIEN2k_MPI
WIEN2k_parallel_options
WIEN2k_SYSTEM
WIEN2k_VERSION

# Use the makefiles as contained in directories SRC_*/

# Update in "x_lapw" on line 1063 from
"set $def" to "set def"

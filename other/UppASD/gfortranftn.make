## Makefile Settings for UppASD on HPE Cray EX
## with Gnu compiler for AMD EPYC Zen2 CPU
# Cray compiler wrappers
FC = ftn
CC = cc
CXX = CC
# Compiler flags
FCFLAGS = -O3 -ffree-line-length-0 -ffast-math -funroll-loops -fopenmp -fallow-argument-mismatch -march=znver2 -mtune=znver2 -mfma -mavx2 -m3dnow -fomit-frame-pointer
CCFLAGS = -O3 -march=znver2 -mtune=znver2 -mfma -mavx2 -m3dnow -fomit-frame-pointer
FCMODFLAG = -J
PREPROC = -cpp

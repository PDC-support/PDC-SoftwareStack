#!/bin/bash -l

#SBATCH -A dardel.test
#SBATCH -p main
#SBATCH -J cp2ktest
#SBATCH -t 1-00:00:00
# number of nodes
#SBATCH --nodes=1
# Number of MPI processes per node
#SBATCH --ntasks-per-node=16

ml PDC
ml CP2K/9.1-cpeGNU-21.11

# First build with
#make -j 32 ARCH=CP2K-9.1-cpeGNU.psmp VERSION=psmp

# then run the tests with the -nobuild switch
tools/regtesting/do_regtest_dardel.sh -arch CP2K-9.1-cpeGNU -version psmp -nobuild -mpiranks 16 -ompthreads 8

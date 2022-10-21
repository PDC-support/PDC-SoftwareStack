#!/bin/bash -l

#SBATCH -A pdc.staff
#SBATCH -p main
#SBATCH -J cp2ktest
#SBATCH -t 1-00:00:00
# number of nodes
#SBATCH --nodes=1
# Number of MPI processes per node
#SBATCH --ntasks-per-node=128

ml PDC/21.11
ml EasyBuild-user/4.5.0
ml CP2K/2022.2-cpeGNU-21.11

# First build with
#make -j 32 ARCH=CP2K-2022.2-cpeGNU.psmp VERSION=psmp

# then run the tests with the -nobuild switch
tools/regtesting/do_regtest_dardel.sh -arch CP2K-2022.2-cpeGNU -version psmp -nobuild -mpiranks 128 -maxtasks 128 -ompthreads 1

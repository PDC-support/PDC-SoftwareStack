# Installation Instructions for Elk

## Obtain the source code

* Download and untar the latest release of Elk from https://elk.sourceforge.io/

## Build on Beskow Cray XC40

* Load the environment

```bash
module swap PrgEnv-cray PrgEnv-gnu
module swap gcc/8.1.0 gcc/9.3.0
module add cray-fftw/3.3.8.6
```

* Compile and link

```bash
tar xf elk-7.2.42.tgz
cd elk-7.2.42/
./setup
#cp -p make.inc make.inc.org
# Copy make.inc.gfortran.beskow make.inc
# Revise the make.inc if needed
make
```

* Test Elk

```bash
cd tests
# Test with nranks=1, omp_num_threads=32
srun -n 1 ./test-threads32.sh
# Test with nranks=8, omp_num_threads=4
./test.sh test-mpi-srun.sh
```

* Expected output: 28 passed, 0 skipped

## Build on Dardel HPE Cray EX

* Load the enviroment

```bash
ml swap PrgEnv-cray/8.2.0 PrgEnv-gnu/8.2.0
ml add cray-fftw/3.3.8.12
```

* Compile and link

```bash
tar xf elk-7.2.42.tgz
cd elk-7.2.42/
./setup
#cp -p make.inc make.inc.org
# Copy make.inc.gfortran.dardel.optimized make.inc
# Revise the make.inc if needed
make
```

* Test Elk

```bash
cd tests
# Test with nranks=1, omp_num_threads=32 (interactive)
salloc -N 1 -t 1:00:00
srun -n 1 ./test-threads32.sh
# Test with nranks=4, omp_num_threads=32 (batch)
sbatch jobtest-mpi-srun-N1n4t32.sh
# Test with nranks=32, omp_num_threads=32 (batch)
sbatch jobtest-mpi-srun-N8n32t32.sh
```

* Expected output: 28 passed, 0 skipped

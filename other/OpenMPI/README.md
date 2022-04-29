# OpenMPI installation on Dardel

### Step 00 - Download source code

- Assuming you will be installing openmpi under ~/opt and the source code will be downloaded to ~/source
- While on login node, download the source code

```
AUTO_VERSION=2.71
OPENMPI_VERSION=4.1.3

mkdir -p ~/source && cd ~/source
wget http://ftp.gnu.org/gnu/autoconf/autoconf-$AUTO_VERSION.tar.gz
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-$OPENMPI_VERSION.tar.gz
tar -xvzf autoconf-$AUTO_VERSION.tar.gz
tar -xvzf openmpi-$OPENMPI_VERSION.tar.gz
```
### Step 01 - Compile Autoconf and OpenMPI
- Request a compute node allocation to do the build - we don't want to do heavy builds on Login node.
```
salloc --ntasks=16 -t 01:00:00 -p shared
srun --pty bash -i
```
- Once we are on compute node, we can build Autoconf and OpenMPI
```
AUTO_VERSION=2.71
OPENMPI_VERSION=4.1.3
mkdir -p ~/opt/autoconf/$AUTO_VERSION
mkdir -p ~/opt/openmpi/$OPENMPI_VERSION

# Compile AutoConf
cd ~/source/autoconf-$AUTO_VERSION
./configure --prefix=$HOME/opt/autoconf/$AUTO_VERSION
make -j 12
make install

# Compile OpenMPI
export PATH=~/opt/autoconf/$AUTO_VERSION/bin:$PATH
cd ~/source/openmpi-$OPENMPI_VERSION
mkdir build && cd build
../configure --with-pmi --with-pmi-libdir=/usr/lib64 --with-slurm --prefix=$HOME/opt/openmpi/$OPENMPI_VERSION --with-libfabric=/opt/cray/libfabric/1.11.0.4.67
make -j 16
make install
```

### Step 03 - Compile application against OpenMPI
- You will need to set following environment variables
```
module unload cray-mpich
OPENMPI_VERSION=4.1.3
export PATH=~/opt/openmpi/$OPENMPI_VERSION/bin:$PATH
export LD_LIBRARY_PATH=~/opt/openmpi/$OPENMPI_VERSION/lib:$LD_LIBRARY_PATH
```

### Step 04 - Submit SLURM Job

- Here is a sample SLURM Job, please note as for now 'srun' is not working when using this installation of OpenMPI, you will have to launch with 'mpirun'

```
#!/bin/bash
#SBATCH -J OpenMPI
#SBATCH -p main
#SBATCH --time=00:05:00
#SBATCH -N 2
#SBATCH --ntasks-per-node=128
#SBATCH --output=slurm-run-%j.out
#SBATCH --error=slurm-run-%j.err

module unload cray-mpich
export PATH=~/opt/openmpi/4.1.3/bin:$PATH
export LD_LIBRARY_PATH=~/opt/openmpi/4.1.3/lib:$LD_LIBRARY_PATH

# Compile the source code
mpicc -o hello-mpi.o hello-mpi.c

# Launch simulation
mpirun -np 256 ./hello-mpi.o
```

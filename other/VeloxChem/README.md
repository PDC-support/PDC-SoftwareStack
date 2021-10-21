# Installation Instructions for VeloxChem

## Obtain the source code

* A development version (commit 58f09276) is provided by Xin Li
* A public release will soon be available

## Load Cray modules

```bash
module swap PrgEnv-cray PrgEnv-gnu
module load cdt/20.06
module load cray-python/3.8.2.1
```

## Create Python environment 

```bash
python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip setuptools
```

## Install Python modules

```bash
CC=cc MPICC=cc python3 -m pip install mpi4py -v --no-deps --no-binary mpi4py
python3 -m pip install numpy pybind11 pytest
```

## Install VeloxChem

```bash
tar xf VeloxChemMP-rc2.tar.gz
cd VeloxChemMP-rc2/

export CRAYPE_LINK_TYPE=dynamic
export CRAY_ROOTFS=DSL

CXX=CC VLX_NUM_BUILD_JOBS=32 srun -n 1 python3 setup.py install
CC=gcc CXX=g++ python3 -m pip install cppe==0.2.1
```

## Test VeloxChem

```bash
OMP_NUM_THREADS=16 srun -n 2 pytest -v --pyargs veloxchem
```

* Expected output: 140 passed, 1 skipped

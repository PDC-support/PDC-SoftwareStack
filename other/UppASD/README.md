# Installation Instructions for UppASD

## Obtain the source code

* Download and untar the latest release of UppASD from https://github.com/UppASD/UppASD
* https://github.com/UppASD/UppASD/archive/refs/tags/v5.1.1.tar.gz

##  Build on Beskow Cray XC40

* Load the environment

```bash
module switch gcc/8.1.0 gcc/8.3.0
module switch PrgEnv-cray/ PrgEnv-gnu

```

* Compile and link UppASD

```bash
tar xf UppASD-5.1.1.tar.gz
cd UppASD-5.1.1
make deps
# copy [gfortranftn.make](./gfortranftn.make) to source/make/user_profiles/
make gfortranftn
```

* Test UppASD

```bash
OMP_NUM_THREADS=16 make asd-tests
```

* Expected output: 29 passed, 0 skipped

##  Build on Dardel HPE Cray EX

* Load the environment

```bash
ml swap PrgEnv-cray/8.1.0 PrgEnv-gnu/8.1.0
ml swap gcc/11.2.0 gcc/9.3.0
```

* Compile and link UppASD

```bash
tar xf UppASD-5.1.1.tar.gz
cd UppASD-5.1.1
make deps
# copy [gfortranftn.make](./gfortranftn.make) to source/make/user_profiles/
make gfortranftn
```

* Test UppASD

```bash
OMP_NUM_THREADS=16 make asd-tests
```

* Expected output: 29 passed, 0 skipped

# Installation Instructions for RSPt

## Obtain the source code

* Request access to the RPSt GitHub repository by contacting the developers.
* https://www.physics.uu.se/research/materials-theory/ongoing-research/code-development/rspt-main/
* Download and untar the latest release of RSPt.

## Build on Beskow Cray XC40

* Load the environment

```bash
module switch PrgEnv-cray PrgEnv-gnu
module switch gcc/8.1.0 gcc/9.3.0
module add cray-fftw/3.3.8.6
```

* Compile and link

```bash
unzip rspt-master.zip
cd rspt-master
# cp -p RSPTmake.inc.gfortranftn.beskow RSPtmake.inc
# Cross compile on compute node
salloc -N 1 -t 0:10:00 -A <project name>
srun -n 1 make
```

* Test RSPt - editing of the tests scripts needed

```bash
cd testsuite
cp -p runcommand.default runcommand
# edit runcommand
# use number of ranks consistent with input files
srun make test
```

* Expected output: MMM passed, NNN skipped

## Build on Dardel HPE Cray EX

* Load the environment

```bash
ml swap PrgEnv-cray/8.1.0 PrgEnv-gnu/8.1.0
ml add cray-fftw/3.3.8.11
```

* Compile and link

```bash
unzip rspt-master.zip
cd rspt-master
# cp -p RSPTmake.inc.gfortranftn.dardel RSPtmake.inc
make
```

* Test RSPt - editing of the tests scripts needed

```bash
cd testsuite
cp -p runcommand.default runcommand
# edit runcommand
# use number of ranks consistent with input files
srun make test
```

* Expected output: MMM passed, NNN skipped

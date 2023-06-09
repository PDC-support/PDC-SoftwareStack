# RT253190

# xtb was requested to be installed with support for 
# 64bit integers. (otherwise, maximum matrix size
# is ~36000)


Modifications needed in source code:

Line 173 in src/api/environment.f90

!.. Original code that fails //TKL, 2021-08-20
!if (.not.any(env%ptr%unit /= [-1, stdout, stderr])) then

!.. New that works
if (.not.any(env%ptr%unit /= [-1, int(stdout), int(stderr)])) then


Old installation instructions:
TKL, 2022-11-14
===============

ml PDC/21.11
ml intel-oneapi/2022.0.2
ml CMake

git clone https://github.com/grimme-lab/xtb.git xtb


To get meson, ninja, I cheat

ml Anaconda3

Install meson, ninja (I prefer py38)

export MKLROOT=""
export install_path_xtb=""
export LIBRARY_PATH=$LIBRARY_PATH:$LD_LIBRARY_PATH


* Standing inside the git directory, use the following configuration line:
FC=ifort CC=icc MKLROOT=$MKLROOT meson setup _build_ilp64 -Dfortran_args="-i8 -qmkl=parallel" -Dfortran_link_args=" -L${MKLROOT}/lib/intel64 -liomp5 -lpthread -lm -ldl " -Dla_backend=custom -Dcustom_libraries="mkl_intel_ilp64,mkl_intel_thread,mkl_core" --prefix=$install_path_xtb



TKL, 2021-08-20
===============



* Clone latest xtb repo
git clone https://github.com/grimme-lab/xtb.git xtb

* One change in source code is needed:

Line 173 in src/api/environment.f90

!.. Original code that fails
!if (.not.any(env%ptr%unit /= [-1, stdout, stderr])) then

!.. New that works
if (.not.any(env%ptr%unit /= [-1, int(stdout), int(stderr)])) then


* Make sure following software is installed/available
- meson
- ninja
- intel mkl
- fortran compiler, I used ifort 19.1.3

* Installation needs access to mkl files and location of final binary.
Fill in the paths in the following lines and execute them in the terminal
export MKLROOT=""
export install_path_xtb=""
export LIBRARY_PATH=$LIBRARY_PATH:$LD_LIBRARY_PATH


* Standing inside the git directory, use the following configuration line:
FC=ifort CC=icc MKLROOT=$MKLROOT meson setup _build_ilp64 -Dfortran_args="-i8 -mkl=parallel" -Dfortran_link_args=" -L${MKLROOT}/lib/intel64 -liomp5 -lpthread -lm -ldl " -Dla_backend=custom -Dcustom_libraries="mkl_intel_ilp64,mkl_intel_thread,mkl_core" --prefix=$install_path_xtb

* Finally, use ninja to build the binary
ninja -j 4 -C _build_ilp64 install



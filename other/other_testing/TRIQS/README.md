# Build instructions for TRIQS on Dardel

# The manual procedure is to be ported to easyconfig

# Load the environment
ml PDC/21.11
ml CMake/3.21
ml cray-fftw/3.3.8.12
ml mpi4py/3.1.3-gcc11.2-py38
ml Mako/1.1.2-cpeGNU-21.11-python3
ml Boost/1.77.0-cpeGNU-21.11
ml GMP/6.2.1-cpeGNU-21.11

# Run build script
./BuildTRIQS.sh

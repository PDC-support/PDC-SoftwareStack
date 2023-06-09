################################################
# BAGEL is not installed system-wide, but
# a user requested it in RT270253.
#
# I here provide the installation instructions and
# information for the submit script.
#
# /Tor (2023-06-09)
#################################################

#.. BAGEL installation, Dardel s11-partition

#.. Load modules
ml PDCTEST/22.06
ml buildtools/22.06
ml boost/1.79.0-cpeGNU-22.06
ml ScaLAPACK/3.2-cpeGNU-22.06-amd
ml libxc/6.0.0-cpeGNU-22.06

#.. Standing in the directory you want to download files to:

git clone https://github.com/nubakery/bagel.git
cd bagel/

#.. Run following commands

libtoolize
aclocal
autoconf
autoheader
automake -a

#.. Get access to MKL without loading intel module

export Ipath1=/opt/intel/oneapi/mkl/2022.0.2/
export MKLROOT=/pdc/software/22.06/other/intel/oneapi/mkl/2022.0.2/
export C_INCLUDE_PATH=$Ipath1/include/:$C_INCLUDE_PATH
export CPATH=$Ipath1/include/:$CPATH
export INTEL_PATH=/opt/intel/oneapi/compiler/2022.0.2
export LD_LIBRARY_PATH=$Ipath1/lib/intel64:$INTEL_PATH/linux/lib:$INTEL_PATH/linux/lib/x64:$INTEL_PATH/linux/lib/oclfpga/host/linux64/lib:$INTEL_PATH/linux/compiler/lib/intel64_lin:$LD_LIBRARY_PATH
export LIBRARY_PATH=$Ipath1/lib/intel64:$INTEL_PATH/linux/lib:$INTEL_PATH/linux/lib/x64:$INTEL_PATH/linux/lib/oclfpga/host/linux64/lib:$INTEL_PATH/linux/compiler/lib/intel64_lin:$LIBRARY_PATH


#.. Unload obsolete buildtools
ml unload buildtools/22.06

#.. Create obj-directory to build code in
mkdir obj
cd obj

#.. Run configuration (it says "openmpi", but will be cray-mpich on our systems)
../configure F77=ftn F90=ftn MPIF90=ftn CXX=CC CC=cc MPICXX=CC MPICC=cc CXXFLAGS="-DNDEBUG -O3 -mavx" --prefix=<where-to-install-to> --exec_prefix=<where-to-install-to> --with-boost=$BOOST_ROOT --with-libxc --with-mpi=openmpi --enable-smith --enable-mkl --enable-scalapack

#.. Run make
make -j8
make install

#---------------------------------#

#.. In you submit script, following is needed

ml PDCTEST/22.06
ml boost/1.79.0-cpeGNU-22.06
ml ScaLAPACK/3.2-cpeGNU-22.06-amd
ml libxc/6.0.0-cpeGNU-22.06

export Ipath1=/opt/intel/oneapi/mkl/2022.0.2/
export MKLROOT=/pdc/software/22.06/other/intel/oneapi/mkl/2022.0.2/
export C_INCLUDE_PATH=$Ipath1/include/:$C_INCLUDE_PATH
export CPATH=$Ipath1/include/:$CPATH
export INTEL_PATH=/opt/intel/oneapi/compiler/2022.0.2
export LD_LIBRARY_PATH=$Ipath1/lib/intel64:$INTEL_PATH/linux/lib:$INTEL_PATH/linux/lib/x64:$INTEL_PATH/linux/lib/oclfpga/host/linux64/lib:$INTEL_PATH/linux/compiler/lib/intel64_lin:$LD_LIBRARY_PATH
export LIBRARY_PATH=$Ipath1/lib/intel64:$INTEL_PATH/linux/lib:$INTEL_PATH/linux/lib/x64:$INTEL_PATH/linux/lib/oclfpga/host/linux64/lib:$INTEL_PATH/linux/compiler/lib/intel64_lin:$LIBRARY_PATH

#.. This one is crucial!
export MPIR_CVAR_CH4_OFI_ENABLE_RMA=0


parallel_python_interpreter = True
mpi = True
compiler = 'cc'
compiler_args = []
libraries = []
library_dirs = []
include_dirs = []
extra_compile_args = [
'-g',
'-O3',
'-fopenmp',
'-fPIC',
'-Wall',
]
extra_link_args = ['-fopenmp']

libraries += ['fftw3']
library_dirs += ['/opt/cray/pe/fftw/3.3.10.8/arm_grace/lib']

#libraries += ['scalapack']
#library_dirs += ['/opt/cray/pe/libsci/24.07.0/NVIDIA/23.11/aarch64/lib']
#library_dirs += ['/opt/cray/pe/libsci_acc/24.07.0/aarch64/lib']

libraries += ['xc']
library_dirs += ['/cfs/klemming/home/h/hellsvik/Thora/Codes/GPAW/GPAWgpugh/gpaw-25.1.0/libxc-7.0.0/build/install/lib']
include_dirs += ['/cfs/klemming/home/h/hellsvik/Thora/Codes/GPAW/GPAWgpugh/gpaw-25.1.0/libxc-7.0.0/build/install/include']

define_macros += [('GPAW_ASYNC', None)]
gpu = True
gpu_target = 'cuda'
gpu_compiler = 'nvcc'
gpu_compile_args = [
'-g',
'-O3',
'-arch=compute_90',
'-code=sm_90',
#'-gencode',
#'-arch=compute_90,code=sm_90',
]
libraries += ['cudart', 'cublas']

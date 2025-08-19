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
'-Wno-stringop-overflow', # suppress warnings from MPI_STATUSES_IGNORE
]
extra_link_args = ['-fopenmp']

libraries += ['fftw3']
library_dirs += ['/opt/cray/pe/fftw/3.3.10.9/x86_rome/lib']

libraries += ['scalapack']
library_dirs += ['/pdc/software/24.11/eb/software/scalapack/4.0-cpeGNU-24.11-amd/lib']

libraries += ['xc']
library_dirs += ['/pdc/software/24.11/eb/software/libxc/7.0.0-cpeGNU-24.11/lib']
include_dirs += ['/pdc/software/24.11/eb/software/libxc/7.0.0-cpeGNU-24.11/include']

define_macros += [('GPAW_ASYNC', None)]
gpu = True
gpu_target = 'hip-amd'
gpu_compiler = 'hipcc'
gpu_include_dirs = []
gpu_compile_args = [
'-g',
'-O3',
'--offload-arch=gfx90a',
]
libraries += ['amdhip64', 'hipblas']

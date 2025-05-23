###############################################################################
#                                                                             #
#                          Generic Makefile for 3ddens                        #
#                                                                             #
#  make           ... generate executable for the sequential version          #
#  make clean     ... delete unnecessary files                                #
#                                                                             #
###############################################################################

.SUFFIXES:	  .f
.SUFFIXES:        .F
SHELL = /bin/sh

###############################################################################
#                           User defined variables                            #
###############################################################################

#---------------- compilers ----------------
FC = ftn


#------------------- fftw ------------------
#FFTW_VERSION = FFTW3
#FFTWROOT = /opt/cray/pe/fftw/3.3.8.12/x86_rome/
#FFTW_LIB = lib
#FFTW_LIBNAME = fftw3
#ifneq ($(FFTWROOT),)
FFTW_FOPT = -DFFTW3 -DFFTW_OMP -I$(FFTW_INC)
FFTW_LIBS = 
#endif

#------------- compiler options ------------
OMP_SWITCH = -fopenmp
FOPT =  -ffree-form -O2 -ftree-vectorize -march=znver2 -ffree-line-length-none -ffpe-summary=none -fallow-argument-mismatch $(FFTW_FOPT) $(OMP_SWITCH)

#-------------- loader options -------------
LDFLAGS  = $(FOPT) 
R_LIBS     = $(FFTW_LIBS)

###############################################################################
#                       End of user defined variables                         #
###############################################################################

DESTDIR  = ./

EXECNAME = 3ddens

###############################################################################
###############################################################################

EXEC   = $(DESTDIR)$(EXECNAME)

#..............................................................................
#
#  All object files 
#
OBJS  =  modules.o fft_modules.o 3ddens.o setfft2.o \
         stern.o rotdef.o rotato.o rotat.o charge.o calculate_neighbours.o \
         ylm.o radial.o sum.o interp.o gener.o vnorm.o latgen.o rotate.o reduc.o \
         write_xsf.o write_stm.o primitive_cell.o read_struct.o atom_sphere_dens.o #outerr.o

#........................................................................

$(EXEC) :  $(OBJS)
	$(FC) -o $(EXEC) $(OBJS) $(R_LIBS) $(LDFLAGS)


#..............................................................................
#  remove unnecessary files (executable(s) are not removed)
#
clean:
	rm -f $(OBJS) *.mod

$(OBJS):	param.inc Makefile modules.o fft_modules.o fftpack_helpers.o
#$(OBSMOD):	modules.o fft_modules.o fftpack_helpers.o      

#..............................................................................
#
#  define inference rules to generate object files from source files
#
.f.o:
	$(FC) -c $(FOPT) $<
.F.o:
	$(FC) -c $(FOPT) $<

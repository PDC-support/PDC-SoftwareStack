###############################################################################
#                                                                             #
#                           Generic Makefile for hf                           #
#                                                                             #
#  make           ... generate executable for the REAL sequential version     #
#  make real      ... generate executable for the REAL sequential version     #
#  make complex   ... generate executable for the COMPLEX sequential version  #
#  make rp        ... generate executable for the REAL parallel version       #
#  make cp        ... generate executable for the COMPLEX parallel version    #
#  make all       ... generate real, complex, rp, cp                          #
#  make last      ... repeat latest make (real, complex, rp, or cp)           #
#  make clean     ... delete unnecessary files                                #
#                                                                             #
###############################################################################

.SUFFIXES:      .F
.SUFFIXES:      .F90
SHELL = /bin/sh

###############################################################################
#                           User defined variables                            #
###############################################################################

#---------------- compilers ----------------
FC = ftn
MPF = ftn
CC = cc

#---------------- scalapack ----------------
SCALAPACKROOT = 
SCALAPACK_LIBNAME = 
BLACSROOT = 
BLACS_LIBNAME = 
MKL_TARGET_ARCH = 
ifneq ($(SCALAPACKROOT),)
  ifeq ($(SCALAPACKROOT),$(MKLROOT))
    ifeq ($(BLACSROOT),$(MKLROOT))
      SCALAPACK_LIBS = -l$(SCALAPACK_LIBNAME) -l$(BLACS_LIBNAME)
    else
      SCALAPACK_LIBS = -L$(SCALAPACKROOT)$(MKL_TARGET_ARCH) -l$(SCALAPACK_LIBNAME) \
                       -L$(BLACSROOT)$(MKL_TARGET_ARCH) -l$(BLACS_LIBNAME)
    endif
  else
    SCALAPACK_LIBS = -L$(SCALAPACKROOT)$(MKL_TARGET_ARCH) -l$(SCALAPACK_LIBNAME) \
                     -L$(BLACSROOT)$(MKL_TARGET_ARCH) -l$(BLACS_LIBNAME)
  endif
endif

#------------------- fftw ------------------
#FFTW_VERSION = FFTW3
#FFTWROOT = 
#FFTW_LIB = lib
#FFTW_LIBNAME = fftw3
#ifneq ($(FFTWROOT),)
FFTW_FOPT = -DFFT3 -DFFTW_OMP -I$(FFTW_INC)
FFTW_LIBS = 
#endif

#------------- compiler options ------------
OMP_SWITCH = -fopenmp
OMP_SWITCHP = -fopenmp
FOPT =  -ffree-form -O2 -ftree-vectorize -march=znver2 -ffree-line-length-none -ffpe-summary=none -fallow-argument-mismatch $(FFTW_FOPT) $(OMP_SWITCH)
FPOPT =  -ffree-form -O2 -ftree-vectorize -march=native -ffree-line-length-none -ffpe-summary=none -fallow-argument-mismatch $(FFTW_FOPT) $(OMP_SWITCHP)
DParallel = '-DParallel'
FGEN = $(PARALLEL)

#-------------- loader options -------------
LDFLAGS = $(FOPT) 
R_LIBS = $(FFTW_LIBS)
C_LIBS = $(R_LIBS)
RP_LIBS = $(FFTW_LIBS) 
RPP_LIBS = $(RP_LIBS) $(SCALAPACK_LIBS) 
CPP_LIBS = $(RPP_LIBS)

###############################################################################
#                       End of user defined variables                         #
###############################################################################

DESTDIR = .

R_EXECNAME = hf
C_EXECNAME = hfc
RP_EXECNAME = hf_mpi
CP_EXECNAME = hfc_mpi

###############################################################################
###############################################################################

R_EXEC = $(DESTDIR)/$(R_EXECNAME)
C_EXEC = $(DESTDIR)/$(C_EXECNAME)
RP_EXEC = $(DESTDIR)/$(RP_EXECNAME)
CP_EXEC = $(DESTDIR)/$(CP_EXECNAME)

#..............................................................................
#
#  All object files,
#    including files in $(RC_OBJS), $(SP_OBJS), $(OBJSMOD)
#
OBJS = modules.o W2kinit.o charge.o abc.o add_hvxhfvc.o add_hvxsl_int.o \
       add_hvxsl_sph.o add_vklioldcc.o add_vklioldvv_int.o add_vklioldvv_sph.o \
       atpar.o c3fft.o calc_abc_hf.o calc_abc_sl.o calc_cnk.o calc_exhf.o \
       calc_exhfcc.o calc_exhfvc.o calc_exhfvv.o calc_gaunt.o \
       calc_gaunt_vklioldcc.o calc_gaunt_vxsl.o calc_h_1.o calc_h_2.o \
       calc_ifflim.o calc_indices.o calc_klicc.o calc_klicv.o calc_klivv.o \
       calc_overlap_sph.o calc_rhovalvxsl.o calc_slatercc.o calc_slatervc.o \
       calc_slatervv.o calc_tdde.o calc_tddh.o calc_theta.o calc_ucuchucuc.o \
       calc_ucuchucuckli.o calc_ucuchucucsla.o calc_ucvkliolducg.o calc_uu.o \
       calc_uuchucu.o calc_uuchucuh.o calc_uuchucukli.o calc_uuchucusla.o \
       calc_uuguu.o calc_uuguuh.o calc_uuguukli.o calc_uuguusla.o calc_uui.o \
       calc_uuih.o calc_uuisla.o calc_uukli.o calc_uvklioldug.o calc_uvxslug.o \
       calc_vcvcint.o calc_vklioldtheta.o calc_vxsltheta.o cbcomb.o \
       cputim.o create_stars.o dergl.o diracout.o dvbes1.o errclr.o errflg.o \
       fftw_seq.o gaunt.o getfft.o gtfnam.o hf.o ifflim.o inouh.o inth.o \
       latgen.o lomain.o make_alms.o msbi.o msbj.o msbk.o notri.o \
       opnfs.o outerr.o outwin.o ph.o read_cnk.o read_input.o read_rhoval.o \
       read_struct.o read_uc.o read_vkliold.o read_vxsl.o read_weight.o \
       rint13.o rotate.o rotdef.o setfft.o sphbes.o sphi.o sphk.o stern.o \
       t3j.o t3j0.o vklioldshift.o W2kutils.o write_slater.o ylm.o
#
# Object files with !_REAL and !_COMPLEX
#
RC_OBJS = modules.o add_hvxhfvc.o add_hvxsl_int.o add_hvxsl_sph.o \
          add_vklioldvv_int.o calc_abc_hf.o calc_abc_sl.o calc_cnk.o \
          calc_exhfvv.o calc_h_1.o calc_h_2.o calc_klivv.o calc_overlap_sph.o \
          calc_rhovalvxsl.o calc_slatervv.o calc_theta.o getfft.o lomain.o \
          make_alms.o read_cnk.o setfft.o stern.o
#
# Object files for parallel and sequential
#
SP_OBJS = modules.o W2kinit.o add_hvxhfvc.o add_hvxsl_int.o add_hvxsl_sph.o \
          calc_exhfvc.o calc_exhfvv.o calc_h_1.o calc_h_2.o calc_klivv.o \
          calc_slatervv.o gtfnam.o outerr.o
#
# Object files using modules
#
OBJSMOD = W2kinit.o charge.o abc.o add_hvxhfvc.o add_hvxsl_int.o add_hvxsl_sph.o \
          add_vklioldcc.o add_vklioldvv_int.o add_vklioldvv_sph.o atpar.o \
          calc_abc_hf.o calc_abc_sl.o calc_cnk.o calc_exhf.o calc_exhfcc.o \
          calc_exhfvc.o calc_exhfvv.o calc_gaunt.o calc_gaunt_vklioldcc.o \
          calc_gaunt_vxsl.o calc_h_1.o calc_h_2.o calc_ifflim.o calc_indices.o \
          calc_klicc.o calc_klicv.o calc_klivv.o calc_overlap_sph.o \
          calc_rhovalvxsl.o calc_slatercc.o calc_slatervc.o calc_slatervv.o \
          calc_tdde.o calc_tddh.o calc_theta.o calc_ucuchucuc.o calc_ucuchucuckli \
          calc_ucuchucucsla.o calc_ucvkliolducg.o calc_uu.o calc_uuchucu.o \
          calc_uuchucuh.o calc_uuchucukli.o calc_uuchucusla.o calc_uuguu.o \
          calc_uuguuh.o calc_uuguukli.o calc_uuguusla.o calc_uui.o calc_uuih.o \
          calc_uuisla.o calc_uukli.o calc_uvklioldug.o calc_uvxslug.o \
          calc_vcvcint.o calc_vklioldtheta.o calc_vxsltheta.o cbcomb.o \
          create_stars.o dergl.o diracout.o fftw_seq.o gtfnam.o hf.o \
          inouh.o latgen.o lomain.o make_alms.o opnfs.o outwin.o read_cnk.o \
          read_input.o read_rhoval.o read_struct.o read_uc.o read_vkliold.o \
          read_vxsl.o read_weight.o rint13.o stern.o vklioldshift.o \
          write_slater.o 
#
#..............................................................................
#
#  Object files for REAL and COMPLEX versions
#
R_OBJS = $(OBJS)
C_OBJS = $(OBJS)

#..............................................................................
#
#  Build executable (either REAL or COMPLEX versions)
#

default: real

all:    
	make real complex rp cp

last:
	if [ ! -f .real -a ! -f .complex  -o ! -f .sequential -a ! -f .parallel ]; then make real; fi
	if [ -f .real -a -f .sequential ]; then make real; fi
	if [ -f .complex -a -f .sequential ]; then make complex; fi
	if [ -f .real -a -f .parallel ]; then make rp; fi
	if [ -f .complex -a -f .parallel ]; then make cp; fi
        

real: keep_rs_files
	$(MAKE) TYPE='REAL' TYPE_COMMENT='\!_REAL' \
	  $(R_EXEC) FORT=$(FC) FFLAGS='$(FGEN) $(FOPT)'

complex: keep_cs_files
	$(MAKE) TYPE='COMPLEX' TYPE_COMMENT='\!_COMPLEX' \
	  $(C_EXEC) FORT=$(FC) FFLAGS='$(FGEN) $(FOPT)'

rp: keep_rp_files
	$(MAKE) PARALLEL=$(DParallel) TYPE='REAL' TYPE_COMMENT='\!_REAL' \
	  $(RP_EXEC) FORT=$(MPF) FFLAGS='$(FGEN) $(FPOPT) $(DParallel)'

cp: keep_cp_files
	$(MAKE) PARALLEL=$(DParallel) TYPE='COMPLEX' TYPE_COMMENT='\!_COMPLEX' \
	  $(CP_EXEC) FORT=$(MPF) FFLAGS='$(FGEN) $(FPOPT) $(DParallel)'

#..............................................................................

$(R_EXEC): $(R_OBJS)
	$(FORT) $(LFLAGS) -o $(R_EXEC) $(R_OBJS) $(LDFLAGS) $(R_LIBS) $(LFLAGS)

$(C_EXEC): $(C_OBJS)
	$(FORT) $(LFLAGS) -o $(C_EXEC) $(C_OBJS) $(LDFLAGS) $(C_LIBS) $(LFLAGS)

$(RP_EXEC): $(R_OBJS)
	$(FORT) $(LFLAGS) -o $(RP_EXEC) $(R_OBJS) $(LDFLAGS) $(RPP_LIBS) $(LFLAGS)

$(CP_EXEC): $(C_OBJS)
	$(FORT) $(LFLAGS) -o $(CP_EXEC) $(C_OBJS) $(LDFLAGS) $(CPP_LIBS) $(LFLAGS)

# real and sequential
keep_rs_files:
	if [ -f .complex ]; then \
	   rm -f .complex $(RC_OBJS) *.mod; \
	fi
	touch .real
	if [ -f .parallel ]; then \
	   rm -f .parallel $(SP_OBJS) *.mod; \
	fi
	touch .sequential

# complex and sequential
keep_cs_files:
	if [ -f .real ]; then \
	   rm -f .real $(RC_OBJS) *.mod; \
	fi
	touch .complex
	if [ -f .parallel ]; then \
	   rm -f .parallel $(SP_OBJS) *.mod; \
	fi
	touch .sequential

# real and parallel
keep_rp_files:
	if [ -f .complex ]; then \
	   rm -f .complex $(RC_OBJS) *.mod; \
	fi
	touch .real
	if [ -f .sequential ]; then \
	   rm -f .sequential $(SP_OBJS) *.mod; \
	fi
	touch .parallel

# complex and parallel
keep_cp_files:
	if [ -f .real ]; then \
	   rm -f .real $(RC_OBJS); \
	fi
	touch .complex
	if [ -f .sequential ]; then \
	   rm -f .sequential $(SP_OBJS) *.mod; \
	fi
	touch .parallel

#..............................................................................
#
#  All routines depend upon an include file (contains common PARAMETERS)
#
$(R_OBJS):		param.inc Makefile
$(C_OBJS):		param.inc Makefile
$(OBJSMOD):		modules.o W2kinit.o

#..............................................................................
#
#  remove unnecessary files (executable(s) are not removed)
#
clean:
	rm -f *.o *_tmp_.* *.P .real .complex .sequential .parallel *.mod
#..............................................................................
#
#  define inference rules to generate object files from source files
#  (From .F files the appropriatly typed subroutine (REAL/COMPLEX) has to
#  be chosen.)
#
.f.o:
	$(FORT) $(FFLAGS) -c $<
#.F.o:
#	$(FORT) $(FFLAGS) -D$(TYPE_COMMENT)= -c $<
.F.o:
	@sed -e 's/^$(TYPE_COMMENT)//'   $< >$*_tmp_.F
	@echo "$<: $(TYPE) version extracted"
	$(FORT) $(FFLAGS) -c $*_tmp_.F
	mv $*_tmp_.o $*.o
	rm $*_tmp_.F
.c.o:
	$(CC) -c $<
.f90.o:
	$(FORT) $(FFLAGS) -c $<
.F90.o:
	@sed -e 's/^$(TYPE_COMMENT)//'   $< >$*_tmp_.F90
	@echo "$<: $(TYPE) version extracted"
	$(FORT) $(FFLAGS) -c $*_tmp_.F90
	mv $*_tmp_.o $*.o
	rm $*_tmp_.F90

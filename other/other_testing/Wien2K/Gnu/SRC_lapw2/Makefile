###############################################################################
#                                                                             #
#                          Generic Makefile for lapw2                         #
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
#FFTWROOT = /opt/cray/pe/fftw/3.3.8.12/x86_rome/
#FFTW_LIB = lib
#FFTW_LIBNAME = fftw3
#ifneq ($(FFTWROOT),)
FFTW_FOPT = -DFFTW3 -DFFTW_OMP -I$(FFTW_INC)
FFTW_LIBS = 
FFTW_PLIBS = 
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
R_LIBS =  
RR_LIBS = $(FFTW_LIBS) $(R_LIBS)
C_LIBS = $(RR_LIBS)
RP_LIBS =  
RPP_LIBS = $(FFTW_PLIBS) $(FFTW_LIBS)  $(RP_LIBS) $(SCALAPACK_LIBS) 
CP_LIBS = $(RPP_LIBS)

###############################################################################
#                       End of user defined variables                         #
###############################################################################

DESTDIR = ./

R_EXECNAME = lapw2
C_EXECNAME = lapw2c
RP_EXECNAME = lapw2_mpi
CP_EXECNAME = lapw2c_mpi

###############################################################################
###############################################################################

R_EXEC = $(DESTDIR)$(R_EXECNAME)
C_EXEC = $(DESTDIR)$(C_EXECNAME)
RP_EXEC = $(DESTDIR)$(RP_EXECNAME)
CP_EXEC = $(DESTDIR)$(CP_EXECNAME)

#..............................................................................
#
#  Object files common to both REAL and COMPLEX type subroutines
#
OBJS    =  W2kinit.o cputim.o reallocate.o modules.o qdmft.o \
           abc.o  addtinv.o atpar.o c3fft.o charge.o csplit.o \
           dfrad.o d5splt.o dergl.o dergl_rlo.o deter.o diracout.o dvbes1.o \
           efgsplit.o  errclr.o errflg.o essl.o f7splt.o fermi.o fermi5.o  \
           fftw_seq.o fomai1.o fomai2.o fomai3.o fourir.o fsumai1.o  \
           gaunt.o getfft.o gtfnam.o harmon.o ifflim.o inouh.o inth.o \
           kdelta.o l2main.o lapw2.o latgen.o locmat.o lomain.o mag.o mknam.o \
           notri.o open_helpfile.o outerr.o outp.o outwin.o p3splt.o ph.o \
           psplit.o read_vec.o recfil.o recpr.o rint13.o rotate.o rotdef.o \
           rotmat_angular.o rotmat_dmft.o setfft1.o setfft2.o sphbes.o \
           spline.o sortag.o stern.o sumupfft.o  symmetrization.o SymmRot.o \
           timeinv1.o t3j.o t3j0.o vdrho.o xsplt.o ylm.o W2kutils.o\
           OutputQ.o ALMDPrint.o WriteEFG.o \
           fermi_totnos.o fermi_efi.o fermi_drval.o fermi_initdr.o fermi5_rtbis.o


RC_OBJS = essl.o fourir.o fsumai1.o getfft.o l2main.o lapw2.o modules.o \
          qdmft.o read_vec.o recpr.o setfft1.o setfft2.o stern.o ALMDPrint.o

SP_OBJS = ALMDPrint.o atpar.o fermi5.o fermi.o fourir.o fsumai1.o gtfnam.o \
          l2main.o lapw2.o modules.o qdmft.o read_vec.o W2kinit.o 

OBJSMOD = abc.o atpar.o charge.o csplit.o d5splt.o dergl.o dfrad.o diracout.o \
          efgsplit.o errflg.o f7splt.o fermi.o fermi5.o fftw_seq.o fomai1.o \
          fomai2.o fomai3.o fourir.o fsumai1.o getfft.o gtfnam.o harmon.o \
          inouh.o kdelta.o l2main.o lapw2.o latgen.o lomain.o outp.o \
          outwin.o p3splt.o psplit.o qdmft.o reallocate.o recfil.o recpr.o \
          rint13.o read_vec.o rotdef.o setfft1.o setfft2.o sortag.o sphbes.o \
          stern.o symmetrization.o vdrho.o xsplt.o W2kinit.o ALMDPrint.o \
          OutputQ.o WriteEFG.o fermi_efi.o fermi5_rtbis.o
          
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
	$(FORT) $(LFLAGS) -o $(R_EXEC) $(R_OBJS) $(LDFLAGS) $(RR_LIBS) $(LFLAGS)

$(C_EXEC): $(C_OBJS)
	$(FORT) $(LFLAGS) -o $(C_EXEC) $(C_OBJS) $(LDFLAGS) $(C_LIBS) $(LFLAGS)

$(RP_EXEC): $(R_OBJS)
	$(FORT) $(LFLAGS) -o $(RP_EXEC) $(R_OBJS) $(LDFLAGS) $(RPP_LIBS) $(LFLAGS)

$(CP_EXEC): $(C_OBJS)
	$(FORT) $(LFLAGS) -o $(CP_EXEC) $(C_OBJS) $(LDFLAGS) $(CP_LIBS) $(LFLAGS)

# real and sequential
keep_rs_files:
	if [ -f .complex ]; then \
	   rm -f .complex $(RC_OBJS)  *.mod; \
	fi
	touch .real
	if [ -f .parallel ]; then \
	   rm -f .parallel $(SP_OBJS) *.mod; \
	fi
	touch .sequential

# complex and sequential
keep_cs_files:
	if [ -f .real ]; then \
	   rm -f .real $(RC_OBJS)  *.mod; \
	fi
	touch .complex
	if [ -f .parallel ]; then \
	   rm -f .parallel $(SP_OBJS) *.mod; \
	fi
	touch .sequential

# real and parallel
keep_rp_files:
	if [ -f .complex ]; then \
	   rm -f .complex $(RC_OBJS)  *.mod; \
	fi
	touch .real
	if [ -f .sequential ]; then \
	   rm -f .sequential $(SP_OBJS) *.mod; \
	fi
	touch .parallel

# complex and parallel
keep_cp_files:
	if [ -f .real ]; then \
	   rm -f .real $(RC_OBJS) ; \
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
$(R_OBJS):		 Makefile
$(C_OBJS):		 Makefile
$(OBJSMOD):		modules.o fft_modules.o

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

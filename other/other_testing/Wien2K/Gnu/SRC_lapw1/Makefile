###############################################################################
#                                                                             #
#                          Generic Makefile for lapw1                         #
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

#------------------ elpa -------------------
ELPAROOT = 
ELPA_VERSION = 
ELPA_LIB = 
ELPA_LIBNAME = 
ifneq ($(ELPAROOT),)
  ELPA_OPT = -DELPA -I$(ELPAROOT)include/$(ELPA_LIBNAME)-$(ELPA_VERSION)/elpa \
                    -I$(ELPAROOT)include/$(ELPA_LIBNAME)-$(ELPA_VERSION)/modules
  ELPA_LIBS = -l$(ELPA_LIBNAME) -L$(ELPAROOT)$(ELPA_LIB) -Wl,-rpath=$(ELPAROOT)$(ELPA_LIB)
endif

#------------- compiler options ------------
OMP_SWITCH = -fopenmp
OMP_SWITCHP = -fopenmp
FOPT =  -ffree-form -O2 -ftree-vectorize -march=znver2 -ffree-line-length-none -ffpe-summary=none -fallow-argument-mismatch $(OMP_SWITCH)
FPOPT = -ffree-form -O2 -ftree-vectorize -march=native -ffree-line-length-none -ffpe-summary=none -fallow-argument-mismatch $(ELPA_OPT) $(OMP_SWITCHP)
DParallel = '-DParallel'
FGEN = $(PARALLEL)

#-------------- loader options -------------
LDFLAGS = $(FOPT) -L../SRC_lib
R_LIBS = -lpthread
C_LIBS = $(R_LIBS)
RP_LIBS = 
RPP_LIBS = $(SCALAPACK_LIBS) $(ELPA_LIBS) $(RP_LIBS) 
CPP_LIBS = $(RPP_LIBS)

###############################################################################
#                       End of user defined variables                         #
##############################################################################

DESTDIR = ./

R_EXECNAME = lapw1
C_EXECNAME = lapw1c
RP_EXECNAME = lapw1_mpi
CP_EXECNAME = lapw1c_mpi

###############################################################################
###############################################################################

R_EXEC = $(DESTDIR)$(R_EXECNAME)
C_EXEC = $(DESTDIR)$(C_EXECNAME)
RP_EXEC = $(DESTDIR)$(RP_EXECNAME)
CP_EXEC = $(DESTDIR)$(CP_EXECNAME)

#..............................................................................
#
#  All object files,
#    including files in $(RC_OBJS), $(SP_OBJS), $(OBJSMOD)
#
OBJS =	\
	abc.o atpar.o bandv1.o calkpt.o cbcomb.o charge.o coors.o cputim.o \
	dblr2k.o dgeqrl.o dgewy.o dgewyg.o dlbrfg.o dsbein1.o \
	dscgst.o dstebz2.o dsyevx2.o dsyr2m.o dsyrb4.o \
	dsyrb5l.o dsyrdt4.o dsywyv.o dsyxev4.o dvbes1.o \
	eisps.o errclr.o errflg.o find_nloat.o forfhs.o gaunt.o \
	gbass.o gtfnam.o hamilt.o hns.o horb.o inikpt.o \
	inilpw.o lapw1.o latgen.o lmsort.o locdef.o lohns.o \
	lopw.o matmm.o matrix_complete.o modules.o nn.o outerr.o outwinb.o \
	ph.o prtkpt.o prtres.o pzheevx16.o rdswar.o \
	rint13.o rotate.o rotdef.o seclit.o seclr4.o seclr5.o \
	select.o service.o setkpt.o setwar.o sphbes.o stern.o SymmRot.o \
	tapewf.o t3j.o t3j0.o ustphx.o warpin.o wfpnt.o wfpnt1.o \
	ylm.o zhcgst.o zheevx2.o zher2m.o \
	jacdavblock.o make_albl.o make_alblH.o global2local.o \
	par_syrk.o my_dsygst.o refblas_dtrsm.o seclit_par.o \
	pdsyevx17.o pdstebz17.o pdgetri_my.o pzgetri_my.o  \
	pdgetrf_my.o pzgetrf_my.o W2kutils.o W2kinit.o 
#	pdsyr2m.o pzher2m.o 
#
# Object files with !_REAL and !_COMPLEX
#
RC_OBJS = calkpt.o hamilt.o hns.o horb.o modules.o seclit.o seclr4.o seclr5.o \
        tapewf.o ustphx.o wfpnt.o wfpnt1.o jacdavblock.o stern.o warpin.o \
	setwar.o par_syrk.o seclit_par.o matrix_complete.o 
#
# Object files for parallel and sequential
#
SP_OBJS = calkpt.o find_nloat.o gtfnam.o hamilt.o hldau.o hns.o modules.o pdsyevx17.o \
        pdstebz17.o prtkpt.o pzheevx16.o seclit.o seclr4.o seclr5.o \
	inikpt.o inilpw.o lapw1.o setkpt.o par_syrk.o matrix_complete.o \
	make_albl.o make_alblH.o jacdavblock.o seclit_par.o pdgetri_my.o \
	pzgetri_my.o W2kinit.o pdgetrf_my.o pzgetrf_my.o 
#	pdsyr2m.o pzher2m.o 
#
# Object files using modules
#
OBJSMOD = abc.o atpar.o calkpt.o find_nloat.o hamilt.o hns.o hldau.o inilpw.o outwinb.o \
	prtkpt.o seclr4.o seclr5.o gtfnam.o lapw1.o seclit.o select.o \
        cbcomb.o coors.o forfhs.o gaunt1.o gaunt2.o horb.o inikpt.o latgen.o \
	lohns.o lopw.o make_albl.o make_alblH.o matrix_complete.o nn.o prtres.o rdswar.o  \
	rint13.o rotdef.o setkpt.o setwar.o tapewf.o ustphx.o wfpnt.o wfpnt1.o \
	par_syrk.o jacdavblock.o seclit_par.o W2kinit.o zhcgst.o dscgst.o
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

###############################################################################
#                                                                             #
#                           Generic Makefile for nmr                          #
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
FFTW_FOPT = -DFFTW3 -I$(FFTW_INC)
FFTW_LIBS = 
FFTW_PLIBS = 
#endif

#------------- compiler options ------------
FOPT = -ffree-form -O2 -ftree-vectorize -march=znver2 -ffree-line-length-none -ffpe-summary=none -fallow-argument-mismatch $(FFTW_FOPT)
FPOPT = -ffree-form -O2 -ftree-vectorize -march=native -ffree-line-length-none -ffpe-summary=none -fallow-argument-mismatch $(FFTW_FOPT)
DParallel = '-DParallel'
FGEN = $(PARALLEL)

#-------------- loader options -------------
LDFLAGS = $(FOPT)
R_LIBS = 
RP_LIBS =  
RR_LIBS = $(FFTW_LIBS) $(R_LIBS)
C_LIBS = $(RR_LIBS)
RPP_LIBS = $(FFTW_LIBS) $(FFTW_PLIBS) $(RP_LIBS) $(SCALAPACK_LIBS) 
CP_LIBS = $(RPP_LIBS)

###############################################################################
#                       End of user defined variables                         #
###############################################################################

DESTDIR = ./

R_EXECNAME = nmr
C_EXECNAME = nmrc
RP_EXECNAME = nmr_mpi
CP_EXECNAME = nmrc_mpi
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
        W2kinit.o modules.o cmdlineparam.o get_nkpt.o make_dradf.o make_klist.o \
        make_step.o nmr.o read_vector.o rint13.o write_qvec.o \
        init_nmr.o make_current_spheres.o make_current_int.o make_cxyz_sp.o make_cxyz_int.o open_units.o \
        read_weigh.o read_energy.o vector_product.o set_gaunt.o get_nlo.o \
        write_current.o cputim.o update_sxyz.o make_plot.o read_current.o \
        get_value_atom.o get_value_int.o write_dx_2d.o ylm.o interp.o where_is_it.o \
        even.o write_dx_2d_ncm.o  setfft.o summffts.o rean_fft.o c3fft.o ifflim.o \
        rint_current.o rad_int_curr.o gen_cells_list.o Bin_other_atoms.o integrate_current.o \
        Bin_central_atom.o get_moments.o get_ps_charge.o sph_sub_pw.o sphbes.o \
        resample_int.o Bin_pw.o convert_gvec.o make_current.o make_int_cxyz.o make_alms.o \
        lomain.o atpar.o dergl.o diracout.o inth.o inouh.o abc.o outwin.o dvbes1.o \
        readwrite_xim.o make_xim.o get_core_states.o \
        get_lj_from_icore.o  make_current_cores.o make_xim_cores.o \
        make_vectest.o make_charge.o sumpara.o test_radial_at_ene.o \
        make_atoms_NMR.o get_gvec.o make_in1.o read_innmrplot.o make_coresigma.o \
        make_fopvec_green.o make_fopvec_leq.o new_iemin_iemax.o make_current_semicore.o \
        make_sumrule.o make_int_cxyz_core.o make_cxyz_cc.o make_current_cc.o \
        read_inputnmr.o scaninput.o select.o outerr.o outwinb.o \
        make_radf_duc.o make_eneduc.o make_int_cxyz_duc.o make_cxyz_duc.o make_current_duc.o \
        invers.o symmetrize.o get_qvalue.o scan_in2.o make_weigh.o find_efer.o \
	magnetic_moment.o magnetic_moment_sp.o magnetic_moment_int.o \
	exec_lapw.o scan_energyfile.o W2kutils.o restart.o make_iffs.o fftw_seq.o

#
# Object files with !_REAL and !_COMPLEX
#
RC_OBJS = $(OBJS)

#
# Object files for parallel and sequential
#
SP_OBJS = $(OBJS)

#
# Object files using modules
#
OBJSMOD = $(OBJS)

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
	$(MAKE) TYPE='REAL' TYPE_COMMENT='\!_real' \
	  $(R_EXEC) FORT=$(FC) FFLAGS='$(FGEN) $(FOPT)'

complex: keep_cs_files
	$(MAKE) TYPE='COMPLEX' TYPE_COMMENT='\!_complex' \
	  $(C_EXEC) FORT=$(FC) FFLAGS='$(FGEN) $(FOPT)'

rp: keep_rp_files
	$(MAKE) PARALLEL=$(DParallel) TYPE='REAL' TYPE_COMMENT='\!_real' \
	  $(RP_EXEC) FORT=$(MPF) FFLAGS='$(FGEN) $(FPOPT) $(DParallel)'

cp: keep_cp_files
	$(MAKE) PARALLEL=$(DParallel) TYPE='COMPLEX' TYPE_COMMENT='\!_complex' \
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
$(R_OBJS):		Makefile
$(C_OBJS):		Makefile
$(OBJSMOD):		modules.o

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

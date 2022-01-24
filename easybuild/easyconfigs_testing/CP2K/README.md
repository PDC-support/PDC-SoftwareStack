# Build status of the CP2K recipes

###
CP2K-8.2.69b8c2e-cpeGNU-21.11.eb
- The required dependencies are installed with EasyBuild on Dardel
- Compilation of CP2K interrupts with the error
Error: Type mismatch in argument 'default_values' at (1); passed INTEGER(4) to LOGICAL(4)
This is the error that GNU Fortran versions 10 and 11 gives for argument type mismatches.
The build log shows that the -fallow-argument-mismatch flag is used in the build, so it is
unclear why the error was not turned into a warning.

###
CP2K-8.2.69b8c2e-cpeGNU-21.08.eb
- Works on eiger.cscs.ch

###
CP2K-9.1-cpeGNU-21.08.eb
CP2K-9.1-cpeGNU.psmp
- Works on LUMI

###
CP2K-9.1-cpeGNU-21.11.eb    # moved to easyconfigs/c/
CP2K-9.1-cpeGNU.psmp        # moved to easyconfigs/c/
- 21.11 version of the LUMI recipe
- Builds on Dardel
- Todo: Run test suite and scaling analysis suite

###
job_CP2K_build_test.sh
do_regtest_dardel.sh
- Scripts to run test suite as batch job on Dardel

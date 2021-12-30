# Build status of the CP2K recipes

## CP2K-8.2.69b8c2e-cpeGNU-21.11.eb
- The required dependencies are installed with EasyBuild on Dardel
- Compilation of CP2K interrupts with the error
Error: Type mismatch in argument 'default_values' at (1); passed INTEGER(4) to LOGICAL(4)
This is the error that GNU Fortran versions 10 and 11 gives for argument type mismatches.
The build log shows that the -fallow-argument-mismatch flag is used in the build, so it is
unclear why the error was not turned into a warning.

## CP2K-8.2.69b8c2e-cpeGNU-21.08.eb
- Works on eiger.cscs.ch

whatis('This module makes all packages built by Spack visible')
help(
[[

Description
===========

This module adds the Spack module directory to the MODULEPATH, so that you can see everything that has been built by Spack, e.g. small libraries and build dependencies used by big software packages.
]])
local cpe_version = '22.06'
local spack_version = '0.18.1'

prepend_path( 'MODULEPATH','/pdc/software/' .. cpe_version .. '/spack/' .. spack_version .. '/prod/modules/cray-sles15-zen2')


help([==[

Description
===========
Cray Programming Environment 21.11
]==])

whatis([==[Description: 
    CPE for user to built software
]==])

local cpe_version = "21.11"

conflict("PDC")

setenv("CRAY_PE_VERSION", cpe_version)
local root = "/pdc/software/PDC/" 

prepend_path("MODULEPATH", pathJoin(root, cpe_version, "eb"))
prepend_path("MODULEPATH", pathJoin(root, cpe_version, "other"))
prepend_path("MODULEPATH", pathJoin(root, cpe_version, "spack"))

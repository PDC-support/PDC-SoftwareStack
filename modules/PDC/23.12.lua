help([==[

Description
===========
Cray Programming Environment 23.12
]==])

whatis([==[Description: 
    CPE for user to built software
]==])

local cpe_version = "23.12"
family("cpe")

conflict("PDC")
local root = "/pdc/software"

setenv("CRAY_PE_VERSION", cpe_version)
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "other"))
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "spack"))
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "spack_zen2"))
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "eb"))
load("cpe/" .. cpe_version)

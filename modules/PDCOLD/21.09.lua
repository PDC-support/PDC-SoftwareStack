help([==[

Description
===========
Cray Programming Environment 21.09
]==])

whatis([==[Description: 
    CPE for user to built software
]==])

local cpe_version = "21.09"
family("cpe")

conflict("PDC")
local root = "/pdc/software"

setenv("CRAY_PE_VERSION", cpe_version)
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "eb"))
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "other"))
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "spack"))
load("cpe/" .. cpe_version)

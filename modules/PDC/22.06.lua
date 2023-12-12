help([==[

Description
===========
Cray Programming Environment 22.06
]==])

whatis([==[Description: 
    CPE for user to built software
]==])

local cpe_version = "22.06"
family("cpe")

conflict("PDC")
local root = "/pdc/software"

setenv("CRAY_PE_VERSION", cpe_version)
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "eb", "modules"))
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "other", "modules"))
prepend_path("MODULEPATH", pathJoin(root, "PDC", cpe_version, "spack"))
load("cpe/" .. cpe_version)

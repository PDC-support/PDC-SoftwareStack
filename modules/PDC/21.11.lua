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
local root = "/pdc/software/" .. cpe_version .. "/"

prepend_path("MODULEPATH", pathJoin(root, "other/modules"))
prepend_path("MODULEPATH", pathJoin(root, "eb/modules/all"))
prepend_path("MODULEPATH", pathJoin(root, "spack/modules"))

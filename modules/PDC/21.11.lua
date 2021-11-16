help([==[

Description
===========
Cray Programming Environment 21.11
]==])

whatis([==[Description: 
    CPE for user to built software
]==])

setenv("CRAY_PE_VERSION", "21.11")
local root = "/pdc/software/" .. os.getenv("CRAY_PE_VERSION") .. "/"

append_path("MODULEPATH", pathJoin(root, "other/modules"))
append_path("MODULEPATH", pathJoin(root, "eb/modules/all"))
append_path("MODULEPATH", pathJoin(root, "spack/modules"))

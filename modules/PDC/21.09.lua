help([==[

Description
===========
Cray Programming Environment 21.09
]==])

whatis([==[Description: 
    CPE for user to built software
]==])

local root = "/pdc/software/21.09/"

append_path("MODULEPATH", pathJoin(root, "other/modules"))
append_path("MODULEPATH", pathJoin(root, "eb/modules/all"))
append_path("MODULEPATH", pathJoin(root, "spack/modules"))

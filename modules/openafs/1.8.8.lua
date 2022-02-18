help([==[

Description
===========
AFS is a distributed filesystem product that offers a client-server architecture for federated file sharing and replicated read-only content distribution, providing location independence, scalability, security, and transparent migration capabilities.

More information
================
 - Homepage: https://www.openafs.org/ 
]==])

whatis([==[AFS is a distributed filesystem]==])
whatis([==[Homepage: https://www.openafs.org/]==])
whatis([==[URL: https://www.openafs.org/]==])

local root = "/pdc/vol/openafs/1.8.8-4.12.14-197.78_9.1.60-cray_shasta_c/"

conflict("openafs")

prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("PATH", pathJoin(root, "bin"))
execute {cmd="/pdc/vol/openafs/1.8.8-4.12.14-197.78_9.1.60-cray_shasta_c/bin/aklog",modeA={"load"}}

help([==[

Description
===========
Custom system Environment module for PDC

More information
================
 - Homepage: https://www.pdc.kth.se/
]==])

whatis([==[Description: 
    This is an environment module for custom applications and scripts at PDC
]==])
add_property("lmod","sticky")
prepend_path("PATH","/pdc/software/modules/systemdefault/bin")
append_path("PATH","/pdc/software/tools")
prepend_path("MODULEPATH","/pdc/software/eb/modules/all")

-- Local paths
local cfs = "/cfs/klemming/"
local user = os.getenv("USER")
local home = os.getenv("HOME")
local user_dir = string.sub(user, 1, 1) .. "/" .. user .. "/"

if user ~= "root" then
  setenv("PDC_BACKUP", home)
  setenv("PDC_TMP", cfs .. "scratch/" .. user_dir)
  end

setenv("PDC_SITE", "pdc")
setenv("PDC_RESOURCE", "dardel")
-- Software specific environment variables
setenv("PDC_REFRAME", "/pdc/software/resources/reframe")
setenv("PDC_SHUB", "/pdc/software/resources/sing_hub")
setenv("BLASTDB", "/pdc/software/resources/blastdb")

--- Temporary fix for CPE/23.12
--- This will now only work for CPE/23.12
--- As there are some issues with LUA detecting environment variables
--- If this is unloaded it might lead to CRAY not finding the appropriate libsci, but at least will not crash
  setenv("CRAY_LIBSCI_PREFIX_DIR", os.getenv("CRAY_PE_LIBSCI_PREFIX_DIR") or "")
  setenv("CRAY_LIBSCI_VERSION", os.getenv("CRAY_PE_LIBSCI_VERSION") or "")
  setenv("CRAY_LIBSCI_BASE_DIR", os.getenv("CRAY_PE_LIBSCI_BASE_DIR") or "")
  setenv("CRAY_LIBSCI_PREFIX", os.getenv("CRAY_PE_LIBSCI_PREFIX") or "")
---  end
set_alias("build_container","$PDC_SHUB/build_container.sh")

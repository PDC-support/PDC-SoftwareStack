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
setenv("PDC_REFRAME", "/pdc/software/resources/reframe")
setenv("PDC_SHUB", "/pdc/software/resources/sing_hub")

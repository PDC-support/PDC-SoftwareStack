help([==[

Description
===========
Environment module for SNIC

More information
================
 - Homepage: https://snic.se/
]==])

whatis([==[Description: 
    This is an environment module so that SNIC users will be familiar with the setup.
]==])

add_property("lmod","sticky")

-- Local paths
local cfs = "/cfs/klemming/"
local user = os.getenv("USER")
local home = os.getenv("HOME")
local user_dir = string.sub(user, 1, 1) .. "/" .. user .. "/"

if user ~= "root" then
  setenv("SNIC_BACKUP", home)
  setenv("SNIC_TMP", cfs .. "scratch/" .. user_dir)
  end

setenv("SNIC_SITE", "pdc")
setenv("SNIC_RESOURCE", "dardel")

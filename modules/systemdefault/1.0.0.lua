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
set_alias("projinfo","/afs/pdc.kth.se/misc/pdc/adm/Allocation/plasma/projinfo.py")
prepend_path("PATH","/pdc/software/modules/systemdefault/bin")

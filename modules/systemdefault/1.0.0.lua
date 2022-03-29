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

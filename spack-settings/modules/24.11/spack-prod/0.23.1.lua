help( [[
A module to activate Spack and configure it to install packages in a directory. See $SPACK_USER_PREFIX.
The set-up is such that you use a common central Spack instance in, but you install packages in your own directory.
Thus, you cannot change the configurations and update the Spack package repository.
But you save the hassle of having to clone your own spack directory and write the configuration files.
]]
)
whatis("Version: 24.11")
whatis("Keywords: Spack")
whatis("Description: the Spack package manager configured to install in a user specified directory")

-- Is this needed?
-- family("cpe")

local spack_version = "0.23.1"
local cpe_version = os.getenv("CRAY_PE_VERSION")
local spack_type = "prod"
local spack_root = "/pdc/software/" .. cpe_version .. "/other/spack/" .. spack_version .. "/" .. spack_type
local installdir = "/pdc/software/" .. cpe_version .. "/spack"

require("lfs")

-- Utility to check for the existence of a directory
function isDir(name)
    if type(name)~="string" then
      return false
    end
    local cwd = lfs.currentdir()
    local is = lfs.chdir(name) and true or false
    lfs.chdir(cwd)
    return is
end

if mode() == "load" then
  prepend_path("SPACK_USER_PREFIX", installdir)

  -- Sanity check of the path
  if string.sub(installdir,1,6) == "/appl/" then
    LmodError("You cannot set $SPACK_USER_PREFIX to somewhere in the /appl filesystem, because it is read-only.")
  end

  LmodMessage("$SPACK_USER_PREFIX = " .. installdir)

  -- Check that the install directory actually exists, create it otherwise
  -- Note: the code below does not create the subdirectories, if they don't exist
  -- they will be created in the next step anyhow
  if not isDir(installdir) then
    LmodMessage("Creating the directory " .. installdir)
    ok,_,_ = os.execute("mkdir -p " .. installdir)
    if not ok then
      LmodError("The directory (" .. installdir .. ") specified in $SPACK_USER_PREFIX does not exist and the Spack module tried to create it, but it did not work.")
    end
  end

  -- Check for the modules directory and try to create it
  local moduledir = installdir .. "/modules/tcl"
  if not isDir(moduledir) then
    LmodMessage("Creating the Spack modules directory " .. (installdir .. "/modules/tcl"))
    ok,_,_ = os.execute("mkdir -p " .. installdir .. "/modules/tcl")
    if not ok then
      LmodError("The modules directory (" .. moduledir .. ") specified in $SPACK_USER_PREFIX does not exist and the Spack module tried to create it, but it did not work.")
    end
  end

  -- Check for the cache directory and try to create it
  local cachedir = installdir .. "/cache"
  if not isDir(cachedir) then
    LmodMessage("Creating the Spack cache directory " .. (installdir .. "/cache"))
    ok,_,_ = os.execute("mkdir -p " .. installdir .. "/cache")
    if not ok then
      LmodError("The cache directory (" .. cachedir .. ") specified in $SPACK_USER_PREFIX does not exist and the Spack module tried to create it, but it did not work.")
    end
  end

  LmodMessage("Spack module directory = " .. moduledir)
  LmodMessage("Spack cache directory = " .. cachedir)
end

-- This adds the "spack" binary (but not the spack shell functions)
prepend_path("PATH", spack_root .. "/bin")

-- The Spack root directory needs to be set
setenv("SPACK_ROOT", spack_root)

-- Override the user settings in the home directory
setenv("SPACK_DISABLE_LOCAL_CONFIG","true")

-- Add Spack's modules
prepend_path("MODULEPATH", installdir .. "/modules/tcl/linux-sles15-zen")
prepend_path("MODULEPATH", installdir .. "/modules/tcl/linux-sles15-zen2")

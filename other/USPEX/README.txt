### Building USPEX on Dardel ###

# Register as an USPEX user and download the USPEX installer
# from the USPEX web page
https://uspex-team.org/en

# Load the environment
ml cray-python/3.9.4.2
ml PDC/21.11
ml SQLite/3.36.0-cpeGNU-21.11

# Create a Python virtual environment
python -m venv uspex_env
source uspex_env/bin/activate
pip install spglib pysqlite3 ase torch

# Install USPEX by running its installer
tar xf USPEX-10.5.tar.gz
cd USPEX_v10.5
./install.sh

# Select non-graphical install (2)
# Specify a path to the installation
# Use here a local path in your home or project directory



### Running USPEX on Dardel ###

# First load the environment
ml cray-python/3.9.4.2
ml PDC/21.11
ml SQLite/3.36.0-cpeGNU-21.11
source uspex_env/bin/activate

# then run USPEX. For a tutorial see
https://uspex-team.org/online_utilities/uspex_manual_release/EnglishVersion/uspex_manual_english/sect0013.html

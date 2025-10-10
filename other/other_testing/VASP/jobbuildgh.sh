#!/bin/bash
#SBATCH -A pdc.staff
#SBATCH -J vasp
#SBATCH -t 02:00:00
#SBATCH -p gpugh
#SBATCH -n 4
#SBATCH -c 16

# Build instructions for VASP 6.5.1 on Dardel Grace Hopper nodes

# Load build environment
ml cpeNVIDIA

echo === hostname ===
hostname
echo

echo === workdir ===
pwd
echo

echo === loaded modules ===
ml

make

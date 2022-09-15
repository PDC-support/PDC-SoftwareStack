#!/bin/bash
#SBATCH -A pdc.staff
#SBATCH -p shared
#SBATCH -J w2k
#SBATCH -t 10:00:00
#SBATCH -n 64

ml PDC/21.11
ml wien2k/21.1

export OMP_NUM_THREADS=1

init_lapw -b -vxc 5 -numk 2000 -ecut -10.0

# set .machines for parallel job
# lapw0 running on one node
echo -n "lapw0: " > .machines
echo -n $SLURM_JOB_NODELIST >> .machines
echo "$i:8" >> .machines
# run job on each core (splitting k-mesh over all cores)
for i in $SLURM_JOB_NODELIST
do
  echo "1:$i:32 " >> .machines
done
echo granularity:1 >> .machines
echo extrafine:1   >> .machines

run_lapw -p -i 100

#! /bin/sh
# Test suite script for the Elk Code

for i in test_*
do
  cd $i
  echo
  echo "Running test in directory $i..."
  \rm -f *.OUT gmon.out fort.*
  OMP_NUM_THREADS=8 srun -n 4 ../../src/elk > test.log
  #OMP_NUM_THREADS=8 OMP_STACKSIZE=20M OMP_PROC_BIND=true OMP_PLACES=cores srun -n 1 ../../src/elk > test.log
  NERROR=`grep -c Error test.log`
  if test $NERROR -gt 0
  then
    echo " Failed! See test.log and output files"
  else
    echo " Passed"
    \rm -f *.OUT test.log fort.* gmon.out
  fi
  cd ..
done


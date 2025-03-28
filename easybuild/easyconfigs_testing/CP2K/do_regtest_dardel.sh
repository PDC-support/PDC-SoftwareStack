#!/bin/bash

###################################################################################
# do_regtest some info [Joost VandeVondele, 2005-02-25]
# Major revision of the script [Marko Misic, PRACE, July - August 2013]
###################################################################################

###################################################################################
#
# command line argument passing
#
###################################################################################

# ensure error messages are in English
export LC_ALL=C

# init
dir_base=$PWD
full_time_t1=$(date +%s)
date_stamp=$(date '+%F_%H-%M-%S')
ndirstoskip=0
skip_dirs[1]=""
ndirstorestrict=0
restrict_dirs[1]=""
default_err_tolerance="1.0E-14"
mpiexec="srun"
ishard=1
nshards=1

# parse options
while [ $# -ge 1 ]; do
 case $1 in
 # load system-specific configuration file, which can directly change all variables in this script.. powerful ;-)
 -c|-config)
  [[ -f $2 ]] || { echo "ERROR: Configuration file $2 not found"; exit 1; }
  source $2   || { echo "ERROR: Sourcing of the configuration file $2 failed" ; exit 1; }
  shift;;
 # make VERSION=...
 -version)
  cp2k_version=$2
  shift ;;
 # make ARCH=...
 -arch)
  dir_triplet=$2
  shift ;;
 # location of cp2k relative the the current working directory (i.e. ${dir_base}/${cp2k_dir}/exe can be found)
 -cp2kdir)
  cp2k_dir=$2
  shift ;;
 # location for the arch files
 -archdir)
  arch_dir=$2
  shift ;;
 # root path of output folder (default is ${dir_base})
 -dirout)
  dir_out=$2
  shift ;;
 # MPI executable
 -mpiexec)
  mpiexec=$2
  shift;;
 # MPI ranks
 -mpiranks)
  numprocs=$2
  shift;;
 # OMP threads
 -ompthreads)
  numthreads=$2
  shift;;
 # maximum total number of tasks (processes)
 -maxtasks)
  maxtasks=$2
  shift;;
 -maxbuildtasks)
  maxbuildtasks=$2
  shift;;
 # maximum time for a job [in s]
 -jobmaxtime)
  job_max_time=$2
  shift;;
 # sharding
 -shard)
  let ishard=$2
  let nshards=$3
  (( ishard < 1 )) && { echo "ERROR: Shard number too low."; exit 1; }
  (( nshards < 1 )) && { echo "ERROR: Number of shards too low."; exit 1; }
  (( ishard > nshards )) && { echo "ERROR: Shard number too high."; exit 1; }
  shift 2;;
 # build a list of directories to skip
 -skipdir)
  let ndirstoskip=ndirstoskip+1
  skip_dirs[ndirstoskip]=$2
  shift;;
 -skipunittest)
  do_unit_test="no" ;;
 # build a list of directories to restrict, i.e. only matching dirs will be run
 -restrictdir)
  let ndirstorestrict=ndirstorestrict+1
  restrict_dirs[ndirstorestrict]=$2
  shift;;
 # enable partial testing of only those directories that contain failed tests
 -retest)
  doretest="yes";;
 # do not do a realclean before building
 -quick)
  quick="quick";;
 # Overwrite internal date stamp
 -date_stamp)
  date_stamp=$2
  shift;;
 -farming)
  farming="yes";;
 # do not check if code has changed
 -nobuild)
  quick="quick"; nobuild="nobuild";;
 # do not test, actually.
 -skiptest)
  skiptest="skiptest";;
 # print help
 -help|-h|--help)
  echo "Usage: do_regtest [OPTION]"
  echo "Run the CP2K regression test suite"
  echo "Example: do_regtest -c my_regtest.conf"
  echo ""
  echo "General:"
  echo "  -h, -help, --help         print this help screen."
  echo "  -c, -config FILE          read any of the following configuration switches from FILE."
  echo "  -cp2kdir PATH             location of cp2k source tree relative to current working directory."
  echo "  -dirout PATH              root path of output folder (default: current working directory)."
  echo "  -mpiexec EXE              name of the executable to run mpi-ranks. Default: mpiexec."
  echo ""
  echo "Build:"
  echo "  -version VERSION          VERSION passed to make. Default: sopt."
  echo "  -arch ARCH                ARCH passed to make. Default: Linux-x86-64-gfortran."
  echo "  -quick                    rebuild if needed, but without realclean. Default: off."
  echo "  -nobuild                  do not build cp2k, rely on user's build. Default: off."
  echo ""
  echo "Runtime:"
  echo "  -mpiranks NRANKS          number of mpi-ranks. Default: 2 for parallel versions, 1 for serial."
  echo "  -ompthreads NTHREADS      number of OpenMP threads. Default: 2 for smp versions otherwise 1."
  echo "  -maxtasks NPROCS          total number of processor to use. Default: \`nproc\`."
  echo "  -maxbuildtasks NPROCS     total number of processor to use for compilation. Default taken from -maxtasks."
  echo "  -jobmaxtime SECONDS       maximum execution time of a single test. Default 600."
  echo "  -farming                  test via a single farming run (only for parallel cp2k)."
  echo ""
  echo "Testing:"
  echo "  -shard ISHARD NSHARDS     do sharding: Divide the test dirs into NSHARD subsets and only run the ISHARD-th set."
  echo "  -skiptest                 do not run test, only build. Default: off."
  echo "  -skipunittest             do not run unit tests. Default: off."
  echo "  -skipdir TESTDIR          do not run tests in TESTDIR. This switch can repeated."
  echo "  -restrictdir TESTDIR      run only tests in TESTDIR. This switch can repeated."
  echo "  -retest                   run only tests in directories, which had failing tests in previous run."
  echo ""
  echo "Exit codes:"
  echo "    0   clean exit with testing"
  echo "    3   problem with realclean"
  echo "    4   build errors"
  echo "    5   problem with retest option - no TEST directory with latest test results found"
  echo "    6   problem with retest option - no error summary exists in the last TEST directory"
  echo "    7   reference directory is locked"
  echo "    8   ctrl-C (SIGINT) and various other signals trapped"
  echo ""
  echo "For more information visit: <http://cp2k.org/dev:regtesting>"
  exit 0;;
 # stop on invalid flag
 -*)
  echo "ERROR: Invalid command line flag $1 found"
  exit 1;;
 # Default case
 *)
  echo "ERROR: Unknown command line string $1 found"
  exit 1;;
 esac
 shift
done

###################################################################################
#
# default settings for various flags, if not defined by flags or conf files
#
###################################################################################
cp2k_version=${cp2k_version:-sopt}
dir_out=${dir_out:-${dir_base}}
dir_triplet=${dir_triplet:-Linux-x86-64-gfortran}
leakcheck=${leakcheck:-"NO"}
doretest=${doretest:-"no"}
nobuild=${nobuild:-"build"}
cp2k_run_postfix=${cp2k_run_postfix:-""}
make=${make:-make}
awk=${awk:-awk}
quick=${quick:-"noquick"}
skiptest=${skiptest:-"noskiptest"}
do_unit_test=${do_unit_test:-"yes"}
farming=${farming:-"no"}
#
# guessing the number of tasks / threads / ranks
#
# by default we use all available processors, obeys e.g. docker --cpuset-cpus
maxtasksdefault=$(nproc)
maxtasks=${maxtasks:-${maxtasksdefault}}
maxbuildtasks=${maxbuildtasks:-${maxtasks}}

if [[ $dir_triplet == *valgrind* ]] ; then
   valgrindstring="valgrind $VALGRIND_OPTIONS"
   job_max_time=${job_max_time:-7200}
else
   valgrindstring=""
   job_max_time=${job_max_time:-400}
fi

if [[ $cp2k_version == p* ]] ; then
    numprocs=${numprocs:-2}
else
    numprocs=${numprocs:-1}
fi

mem_limit=unlimited

if [[ $numprocs -gt 1 ]] ; then
    if [[ "$farming" == "yes" ]]; then
       cp2k_run_prefix=${cp2k_run_prefix:-"${mpiexec} -n $(($maxtasks + 1)) ${valgrindstring}"}
    else
       cp2k_run_prefix=${cp2k_run_prefix:-"${mpiexec} -n ${numprocs} ${valgrindstring}"}
    fi
else
    cp2k_run_prefix=${cp2k_run_prefix:-"${valgrindstring}"}
fi

if [[ $cp2k_version == *smp* ]] ; then
    numthreads=${numthreads:-2}
else
    numthreads=${numthreads:-1}
fi

export OMP_NUM_THREADS=${numthreads}
export CP2K_DATA_DIR=${cp2k_data_dir:-"${dir_base}/${cp2k_dir}/data"}

#
# these should not be needed
#
export ARCH=${dir_triplet}
ARCH_SPEC="ARCH=${ARCH}${arch_dir:+ ARCHDIR=$arch_dir} "
cp2k_prefix=${cp2k_prefix:-"${cp2k_run_prefix} ${dir_base}/${cp2k_dir}/exe/${dir_triplet}/cp2k.${cp2k_version}"}
cp2k_postfix=${cp2k_postfix:-"${cp2k_run_postfix}"}

###################################################################################
#
# the rest should be internals.
#
###################################################################################
###################################################################################
#
# set up the initial directory structures
#
###################################################################################
repo_dir=${dir_base}/${cp2k_dir}
test_types_file=${repo_dir}/tests/TEST_TYPES
lastdir=LAST-${dir_triplet}-${cp2k_version}
dir_last=${dir_base}/${lastdir}
testdir=TEST-${dir_triplet}-${cp2k_version}-${date_stamp}
dir_test=${dir_out}/${testdir}
changelog=${dir_last}/ChangeLog
changelog_diff=${changelog}.diff
changelog_new=${changelog}.new
changelog_old=${changelog}.old
changelog_tests=${changelog}-tests
changelog_tests_diff=${changelog_tests}.diff
changelog_tests_new=${changelog_tests}.new
changelog_tests_old=${changelog_tests}.old
mkdir -p ${dir_test}
mkdir -p ${dir_last}
make_out=${dir_test}/make.out
error_description_file=${dir_test}/error_summary
>${error_description_file}
memory_description_file=${dir_test}/memory_summary
>${memory_description_file}
summary=${dir_test}/summary.txt
timings=${dir_test}/timings.txt
printf "Summary of the regression tester run from ${date_stamp} using ${dir_triplet} ${cp2k_version} \n" >${summary}


###################################################################################
#
# function to grep for changes in the output. Takes five arguments
#
###################################################################################
function do_test_grep(){
 output_new=$1
 output_old=$2
 error_file=$3
 grep_string=$4
 grep_field=$5
 error_tolerance=$6
 ref_value=$7

 if [ -n "${ref_value}" ]; then
   e1=$ref_value
   label="ref"
 else
   e1=$(grep -a "${grep_string}" ${output_old} | tail -1 | ${awk} -v f=${grep_field} '{print $f}')
   label="old"
 fi

 e2=$(grep -a "${grep_string}" ${output_new} | tail -1 | ${awk} -v f=${grep_field} '{print $f}')
 big=$(echo "${e1} ${e2} ${error_tolerance}" | ${awk} '{if($2==0){v=sqrt(($1-$2)^2)}else{v=sqrt((($1-$2)/$2)^2)}; if (v>$3) printf("%16.8e",v); else printf("0") ;}')

 case ${big} in
 0)
  # ok, same energy
  return 0 ;;
 *)
  # nope too large
  echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_file}
  echo "${output_new} : " >> ${error_file}
  echo " ${grep_string} : ${label} = ${e1} new = ${e2}  " >> ${error_file}
  echo " relative error : ${big} >  numerical tolerance = ${error_tolerance}  " >>${error_file}
  echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_file}
  return 1 ;;
 esac
}

###################################################################################
#
# function to select which test to run
#
###################################################################################
function do_test() {
 which_test=$1
 num_tolerance=$2
 ref_value=$3
 output_new=$4
 output_old=$5
 error_file=$6
 case ${which_test} in
 0)
   #just be happy you executed
   return 0;;
 *)
   do_test_grep ${output_new} ${output_old} ${error_file} "${test_grep[which_test]}" "${test_col[which_test]}" "${num_tolerance}" "${ref_value}"
   return $? ;;
 esac
}

###################################################################################
#
# function to run an entire regtest dir
#
###################################################################################
function run_regtest_dir() {
  dir=$1
  task=${dir//\//-}
  touch ${dir_test}/status/REGTEST_RUNNING-$task
  n_runtime_error=0
  n_wrong_results=0
  n_correct=0
  n_tests=0

  cd ${dir_test}/tests/${dir}
  mkdir -p ${dir_test}/${dir}
  mkdir -p ${dir_last}/${dir}

  #
  # run the tests now
  #
  echo "Starting regression tests in ${dir_test}/tests/${dir} (${idir} of ${ndir})"
  echo ">>> ${dir_test}/tests/${dir}" > ${dir_test}/status/REGTEST_TASK_TESTS-$task
  ntest=$(grep '^\s*\w' TEST_FILES | wc -l)
  t1=$(date +%s)
  for ((itest=1;itest<=ntest;itest++));
  do
     touch ${lockfile}
     n_tests=$((n_tests+1))
     this_test=""
     input_file=$(grep '^\s*\w' TEST_FILES | ${awk} -v itest=$itest '{c=c+1;if (c==itest) print $1}')
     test_type=$(grep '^\s*\w' TEST_FILES | ${awk} -v itest=$itest '{c=c+1;if (c==itest) print $2}')
     # third field allows numerical tolerances to be read from the TEST_FILES
     # if value does not exist set to the default of 1.0E-14
     test_tolerance=$(grep '^\s*\w' TEST_FILES | ${awk} -v itest=$itest -v def_err_tol=$default_err_tolerance '{c=c+1;if (c==itest) if (NF >= 3) { print $3 } else { print def_err_tol } }')
     test_ref_value=$(grep '^\s*\w' TEST_FILES | ${awk} -v itest=$itest '{c=c+1;if (c==itest) if (NF == 4) { print $4 } }')

     output_file=${dir_test}/${dir}/${input_file}.out
     output_last=${dir_last}/${dir}/${input_file}.out


     #
     # look here for the actual place where cp2k runs....
     #
     if [[ "$farming" == "yes" ]]; then
       if [ -f ${output_file} ]; then
          cp2k_exit_status=0
       else
          cp2k_exit_status=43
       fi
     else
       ( ulimit -t ${job_max_time} -v ${mem_limit} ; ${cp2k_prefix} ${input_file} ${cp2k_postfix} &> ${output_file} ) >& /dev/null
       (( cp2k_exit_status = $? ))
     fi
     # check if this was a valgrinded run, and adjust exit status as needed
     grep -a "^==[0-9][0-9]*== ERROR SUMMARY" ${output_file} &> /dev/null
     if (( $? == 0 )); then
        grep -a "^==[0-9][0-9]*== ERROR SUMMARY: 0 errors from 0 contexts" ${output_file} &> /dev/null
        # nonzero error count
        if (( $? )); then
           cp2k_exit_status=42
        fi
     fi
     if (( cp2k_exit_status )); then
        # CP2K failed obviously
        if (( cp2k_exit_status == 137 )); then
           # SIGKILL = 9 ... exit code 9+128
           # usually caused by time-out
           this_test="KILLED"
        else
           if (( cp2k_exit_status == 43 )); then
             this_test="FAILED START"
           else
             this_test="RUNTIME FAIL"
           fi
        fi
        # failed starts (farming) are not interesting
        if (( cp2k_exit_status != 43 )); then
          echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
          echo ${output_file} >>${error_description_file}
          tail -n 100 ${output_file} >>${error_description_file}
          # append an eventual valgrind report to the file
          grep "^==[0-9][0-9]*== " ${output_file} | head -n 20 >> ${error_description_file}
          echo "EXIT CODE: " $cp2k_exit_status " MEANING: " $this_test >>${error_description_file}
          echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
          n_runtime_error=$((n_runtime_error+1))
          failed_tests="${failed_tests} ${output_file}"
        fi
     else
        # ran but did not end !?
        grep -a "ENDED" ${output_file} &> /dev/null
        if (( $? )); then
           echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
           echo ${output_file} >>${error_description_file}
           tail -n 100 ${output_file} >>${error_description_file}
           # append an eventual valgrind report to the file
           grep "^==[0-9][0-9]*== " ${output_file} | head -n 20 >> ${error_description_file}
           echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
           this_test="RUNTIME FAIL"
           n_runtime_error=$((n_runtime_error+1))
           failed_tests="${failed_tests} ${output_file}"
        else
           # Still running, you must be joking...
           # see if we manage to pass the testing
           # but only if we can compare (or don't need to)
           if [ -f ${output_last} ] || [ -n "${test_ref_value}" ] || [ "${test_type}" == "0" ]; then
              do_test "${test_type}" "${test_tolerance}" "${test_ref_value}" "${output_file}" "${output_last}" "${error_description_file}"
              if (( $? )); then
                 this_test="WRONG RESULT TEST ${test_type}"
                 n_wrong_results=$((n_wrong_results+1))
              else
                 this_test="OK"
                 n_correct=$((n_correct+1))
              fi
           else
              this_test="MISSING REFERENCE"
              n_wrong_results=$((n_wrong_results+1))
           fi
        fi
     fi
     # Keep the output up-to-date
     timing=0
     if [[ ${this_test} == "OK" ]]; then
        timing=$(grep -a "CP2K   " ${output_file} | tail -n 1 | ${awk} '{printf("%7.2f",$NF)}')
        this_test="${this_test} (${timing} sec)"
     fi
     leak_marker=""
     if [[ ${leakcheck} == "YES" ]]; then
        if [[ -n $(echo ${cp2k_prefix} | grep "valgrind") ]]; then
           leak_error_string="ERROR SUMMARY:"
           nerror=$(grep -i "${leak_error_string}" ${output_file} | awk '{print $4}')
           dum=""
           (( nerror > 0 )) && dum=${nerror}
        else
           case ${FORT_C_NAME} in
              gfortran*) leak_error_string="SUMMARY: LeakSanitizer:";;
           esac
           dum=$(grep -l "${leak_error_string}" ${output_file})
        fi
        if [[ ${dum} != "" ]]; then
           leak_marker="!"
           echo "XXXXXXXX  ${output_file} XXXXXXX" >>${memory_description_file}
           grep -i "${leak_error_string}" ${output_file} >>${memory_description_file}
        fi
     fi

     # grep numeric test value from output again
     test_value="-"
     if [[ ${test_type} != 0 ]]; then
       grep_string="${test_grep[test_type]}"
       grep_field="${test_col[test_type]}"
       if [ -f ${output_file} ]; then
          test_value=$(grep -a "${grep_string}" ${output_file} | tail -1 | ${awk} -v f=${grep_field} '{print $f}')
       fi
     fi

     printf "    %-50s %25s %20s %s\n" "${input_file}" "${test_value}" "${this_test}" "${leak_marker}" >> ${dir_test}/status/REGTEST_TASK_TESTS-$task
     printf "%7.2f  %s\n" "${timing}" "${dir}/${input_file}" >> "${timings}"
  done

  t2=$(date +%s)
  timing_all=$((1+t2-t1))
  printf "%s %0.2f %s\n" "<<< ${dir_test}/tests/${dir} (${idir} of ${ndir}) done in" ${timing_all} "sec"  >> ${dir_test}/status/REGTEST_TASK_TESTS-$task
  echo "${n_runtime_error} ${n_wrong_results} ${n_correct} ${n_tests}" > ${dir_test}/status/REGTEST_TASK_RESULT-$task
  cat ${dir_test}/status/REGTEST_TASK_TESTS-$task
  rm -f ${dir_test}/status/REGTEST_TASK_TESTS-$task ${dir_test}/status/REGTEST_RUNNING-$task
}


###################################################################################
#
# function to run a unit test
#
###################################################################################
function run_unittest() {
  dir=$1
  task=${dir//\//-}
  touch ${dir_test}/status/REGTEST_RUNNING-$task
  n_runtime_error=0
  n_correct=0

  mkdir -p ${dir_test}/UNIT
  mkdir -p ${dir_test}/tests/${dir}
  cd ${dir_test}/tests/${dir}

  echo "Starting unit test in ${dir_test}/test/${dir} (${idir} of ${ndir})"
  echo ">>> ${dir_test}/${dir}" > ${dir_test}/status/REGTEST_TASK_TESTS-$task

  t1=$(date +%s)
  output_file=${dir_test}/${dir}.out
  unittest=${dir##*/}
  if [[ "${cp2k_version}" == "sopt" ]]; then
     ext="ssmp"
  elif [[ "${cp2k_version}" == "popt" ]]; then
     ext="psmp"
  else
     ext="${cp2k_version}"
  fi
  testcmd="${cp2k_run_prefix} ${dir_base}/${cp2k_dir}/exe/${dir_triplet}/${unittest}.${ext} ${dir_base}/${cp2k_dir}"
  ( ulimit -t ${job_max_time} -v ${mem_limit} ; ${testcmd} &> ${output_file} ) >& /dev/null
  (( cp2k_exit_status = $? ))
  t2=$(date +%s)
  timing=$((1+t2-t1))

  # check if this was a valgrinded run, and adjust exit status as needed
  grep -a "^==[0-9][0-9]*== ERROR SUMMARY" ${output_file} &> /dev/null
  if (( $? == 0 )); then
     grep -a "^==[0-9][0-9]*== ERROR SUMMARY: 0 errors from 0 contexts" ${output_file} &> /dev/null
     # nonzero error count
     if (( $? )); then
        cp2k_exit_status=42
     fi
  fi

  if (( cp2k_exit_status == 0)); then
     this_test=$(printf "OK (%7.2f sec)" ${timing})
     n_correct=$((n_correct+1))
  else
     # CP2K failed obviously
     if (( cp2k_exit_status == 137 )); then
        # SIGKILL = 9 ... exit code 9+128
        # usually caused by time-out
        this_test="KILLED"
     else
        this_test="RUNTIME FAIL"
     fi
     #
     echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
     echo ${output_file} >>${error_description_file}
     tail -40 ${output_file} >>${error_description_file}
     # append an eventual valgrind report to the file
     grep "^==[0-9][0-9]*== " ${output_file} | head -n 20 >> ${error_description_file}
     echo "EXIT CODE: " $cp2k_exit_status " MEANING: " $this_test >>${error_description_file}
     echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
     n_runtime_error=$((n_runtime_error+1))
     failed_tests="${failed_tests} ${output_file}"
  fi

  leak_marker=""
  if [[ ${leakcheck} == "YES" ]]; then
     if [[ -n $(echo ${cp2k_prefix} | grep "valgrind") ]]; then
        leak_error_string="ERROR SUMMARY:"
        nerror=$(grep -i "${leak_error_string}" ${output_file} | awk '{print $4}')
        dum=""
        (( nerror > 0 )) && dum=${nerror}
     else
        case ${FORT_C_NAME} in
           gfortran*) leak_error_string="SUMMARY: LeakSanitizer:";;
        esac
        dum=$(grep -l "${leak_error_string}" ${output_file})
     fi
     if [[ ${dum} != "" ]]; then
        leak_marker="!"
        echo "XXXXXXXX  ${output_file} XXXXXXX" >>${memory_description_file}
        grep -i "${leak_error_string}" ${output_file} >>${memory_description_file}
     fi
  fi

  printf "    %-50s %25s %20s %s\n" "${dir##*/}" "-" "${this_test}" "${leak_marker}" >> ${dir_test}/status/REGTEST_TASK_TESTS-$task
  printf "%s %0.2f %s\n" "<<< ${dir_test}/tests/${dir} (${idir} of ${ndir}) done in" ${timing} "sec"  >> ${dir_test}/status/REGTEST_TASK_TESTS-$task
  echo "${n_runtime_error} 0 ${n_correct} 1" > ${dir_test}/status/REGTEST_TASK_RESULT-$task
  cat ${dir_test}/status/REGTEST_TASK_TESTS-$task
  rm -f ${dir_test}/status/REGTEST_TASK_TESTS-$task ${dir_test}/status/REGTEST_RUNNING-$task
  printf "%7.2f  %s\n" "${timing}" "UNIT/${dir##*/}" >> "${timings}"
}

###################################################################################
###################################################################################


# Check for lockfile
lockfile=${dir_last}/LOCKFILE

# install a trap handler for ctrl-C and other ways to die, doing IO is no good in case of SIGPIPE
# kills all processes that have a PID of ppid (good for running jobs), removes the lockfile, and exits with code 8
pgid=$(ps -o "%r" $$ | grep "[0-9]")
trapcommand="rm -f ${lockfile} ; kill -- -$pgid  >& out.kill ; exit 8"
trap "$trapcommand" SIGINT SIGTERM SIGPIPE SIGHUP SIGQUIT

if [[ -f ${lockfile} ]]; then
   # the lockfile is touched before the start of any new regtest. If it hasn't been touched
   # recently (i.e. less than the time a single test is allowed to run), the lockfile is considered stale.
   job_max_time_stale=$((job_max_time+10))
   if [[ $(date +%s -r ${lockfile}) -gt $(date +%s --date="${job_max_time_stale} sec ago") ]]; then
      echo "ERROR: Directory ${dir_last} is locked"
      echo "       Check if a regtest is already running for the same directory and if not then"
      echo "       remove the lockfile ${lockfile}"
      echo "       first and retry"
      rm -rf ${dir_test}
      echo -e "\nSummary: Test directory is locked."
      echo -e "Status: UNKNOWN\n"
      exit 7
    else
      echo "WARNING: stale lockfile in directory ${dir_last} "
      echo "         continuing regtest"
      touch ${lockfile}
    fi
else
   touch ${lockfile}
fi

if (( maxtasks < numprocs*OMP_NUM_THREADS )); then
   echo "ERROR: maxtasks should be greater or equal numprocs*OMP_NUM_THREADS"
   echo "       maxtasks        = ${maxtasks}"
   echo "       numprocs        = ${numprocs}"
   echo "       OMP_NUM_THREADS = ${OMP_NUM_THREADS}"
   rm -rf ${dir_test} ${lockfile}
   exit 8
fi

if [[ ${leakcheck} == "YES" ]]; then
   if [[ ! -f ${dir_base}/suppr.txt ]]; then
      echo "NOTE: Suppression file ${dir_base}/suppr.txt is missing"
      touch ${dir_base}/suppr.txt
      echo "NOTE: An empty suppression file has been created"
   fi
fi

function file_info() {
echo " regtesting location summary file: $summary"
echo " regtesting location error_summary file: $error_description_file"
echo " regtesting location memory_summary file: $memory_description_file"
echo " regtesting location output dir: $dir_test"
echo " regtesting location last dir: $dir_last"
}

# Start testing
echo "*************************** testing started ******************************"
echo " started on " $(date)
echo " configuration: ${dir_triplet}-${cp2k_version} "
file_info
#
# should include all flags, ideally
#
echo "---------------------------- Settings ------------------------------------"
echo "maxtasks         = ${maxtasks}"
echo "numprocs         = ${numprocs}"
echo "OMP_NUM_THREADS  = ${OMP_NUM_THREADS:-(default)}"
echo "OMP_STACKSIZE    = ${OMP_STACKSIZE:-(default)}"
echo "KMP_STACKSIZE    = ${KMP_STACKSIZE:-(not set)}"
echo "cp2k_run_prefix  = ${cp2k_run_prefix}"
echo "cp2k_run_postfix = ${cp2k_run_postfix}"
echo "cp2k_prefix      = ${cp2k_prefix}"
echo "cp2k_postfix     = ${cp2k_postfix}"
echo "cp2k_version     = ${cp2k_version}"
echo "dir_triplet      = ${dir_triplet}"
echo "job_max_time     = ${job_max_time}"
echo "leakcheck        = ${leakcheck}"
echo "doretest         = ${doretest}"
echo "nobuild          = ${nobuild}"
echo "quick            = ${quick}"
echo "shard            = ${ishard} / ${nshards}"
echo "skiptest         = ${skiptest}"
echo "do_unit_test     = ${do_unit_test}"
echo "farming          = ${farming}"
echo "maxbuildtasks    = ${maxbuildtasks}"
echo "mem_limit        = ${mem_limit}"

t=1
while [ $t -le ${ndirstoskip} ]; do
 echo "skip_dirs        = ${skip_dirs[t]}"
 let t=t+1
done
t=1
while [ $t -le ${ndirstorestrict} ]; do
 echo "restrict_dirs    = ${restrict_dirs[t]}"
 let t=t+1
done

echo "--------------------------- GIT ------------------------------------------"

git_sha="<N/A>"
submodule_sha=()

if [[ -d "${dir_base}/${cp2k_dir}/.git" ]] ; then
   head_ref=$(<"${dir_base}/${cp2k_dir}/.git/HEAD")

   if [[ ${head_ref} =~ ^ref:\ (.*) ]] ; then
      ref_file="${dir_base}/${cp2k_dir}/.git/${BASH_REMATCH[1]}"

      if [[ -f "${ref_file}" ]] ; then
         git_sha=$(<"${ref_file}")
      fi
   else
      # this is a detached HEAD, no further deref needed
      git_sha="${head_ref}"
   fi

   modules_git_dir="${dir_base}/${cp2k_dir}/.git/modules/"

   # find submodule indexes, if any
   while IFS=  read -r -d $'\0'; do
       submodule_basedir="${REPLY%/*}"
       submodule_hash=$(<"${submodule_basedir}/HEAD")
       submodule_dir="${submodule_basedir#${modules_git_dir}}"
       submodule_sha+=("${submodule_dir}:${submodule_hash}")
   done < <(find "${modules_git_dir}" -name index -print0)
fi

echo "CommitSHA: ${git_sha}"

for submodule in "${submodule_sha[@]}" ; do
   echo "Commmit SHA of submodule in ${submodule%%:*}: ${submodule##*:}"
done

# add some more information about that last commit if `git` is available
if [[ "${git_sha}" != "<N/A>" ]] && command -v git >/dev/null 2>&1 ; then
   GIT_WORK_TREE="${dir_base}/${cp2k_dir}" GIT_DIR="${dir_base}/${cp2k_dir}/.git" \
      git --no-pager \
         log -n 1 \
         --format="CommitTime: %ci%nCommitAuthor: %an%nCommitAuthorEmail: %ae%nCommitSubject: %s%n" \
         "${git_sha}"
fi

echo "--------------------------- Resource limits ------------------------------"
prlimit

echo "--------------------------- SELinux --------------------------------------"
if [[ -f /usr/sbin/getenforce ]]; then
   echo "SELinux is installed and is $(/usr/sbin/getenforce)"
else
   echo "No SELinux installation found"
fi

echo "--------------------------- Preparations ---------------------------------"

# make realclean
if [[ ${quick} != "quick" ]]; then
   cd ${dir_base}/${cp2k_dir}
   if [[ "${cp2k_version}" == "sopt" ]]; then
      ext="sopt ssmp"
   elif [[ "${cp2k_version}" == "popt" ]]; then
      ext="popt psmp"
   else
      ext="${cp2k_version}"
   fi
   ${make} realclean ${ARCH_SPEC} VERSION="${ext}" >>${make_out} 2>&1
   if (( $? )); then
      echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
      cat ${make_out} >>${error_description_file}
      echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
      echo "ERROR: ${make} realclean ${ARCH_SPEC} VERSION=\"${ext}\" failed ... bailing out" >>${error_description_file}
      cat "${error_description_file}"
      rm ${lockfile}
      exit 3
   else
      echo "${make} realclean ${ARCH_SPEC} VERSION=\"${ext}\" went fine"
   fi
else
   echo "Quick testing, no realclean"
fi

# from here failures are likely to be bugs in cp2k
if [[ ${nobuild} != "nobuild" ]]; then
   echo "--------------------------- ARCH-file ------------------------------------"
   cat "${arch_dir:-${dir_base}/${cp2k_dir}/arch}/${ARCH}.${cp2k_version}"
   echo "-------------------------- Build-Tools -----------------------------------"
   cd ${dir_base}/${cp2k_dir}
   ${make} toolversions ${ARCH_SPEC} VERSION=${cp2k_version}
   echo "----------------------- External Modules ---------------------------------"
   cd ${dir_base}/${cp2k_dir}
   ${make} extversions ${ARCH_SPEC} VERSION=${cp2k_version}
   echo "---------------------------- Modules -------------------------------------"
   if [ "$(type -t module)" = 'function' ]; then
      module list 2>&1
   else
      echo "Module system not installed."
   fi
   echo "------------------------ compiling cp2k ----------------------------------"
   echo "${make} -j $((maxbuildtasks)) ${ARCH_SPEC} VERSION=${cp2k_version}"
   echo "(make output is written to ${make_out})"
   ${make} -j ${maxbuildtasks} ${ARCH_SPEC} VERSION=${cp2k_version} >>${make_out} 2>&1
   if (( $? )); then
      echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
      cat ${make_out} >>${error_description_file}
      echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" >>${error_description_file}
      echo "ERROR: ${make} -j $((maxbuildtasks)) ${ARCH_SPEC} VERSION=${cp2k_version} failed" >>${error_description_file}
      cat "${error_description_file}"
      echo -e "\nSummary: Compilation failed."
      echo -e "Status: FAILED\n"
      rm ${lockfile}
      exit 4
   else
      compile_warnings=$(grep -i "Warning" ${make_out} | wc -l)
      echo "${make} -j $((maxbuildtasks)) ${ARCH_SPEC} VERSION=${cp2k_version} went fine (${compile_warnings} warnings)"
   fi
else
   echo "No build, continue regression testing"
fi

if [[ ${skiptest} != "skiptest" ]]; then
   echo "------------------------ regtesting cp2k ---------------------------------"

   ###################################################################################
   #
   # parse the TEST_TYPES file to do different kinds of test
   #
   # tests grep for the last line in the file where a string matches (test_grep)
   # and compares a numeric field at a given column (test_col)
   #
   # the format of the TEST_TYPES file is (notice the '!' as a field separator, to allow
   # for spaces in the test_grep)
   #
   # Ntest_types
   # test_grep_1 ! test_col_1
   # test_grep_2 ! test_col_2
   # ....
   # followed by comment lines
   #
   ###################################################################################
   Ntest_types=$(awk -v l=1 -v c=1 'BEGIN{FS="!"}{lr=lr+1;if (lr==l) print $c}' ${test_types_file})
   test_grep[0]=""
   test_col[0]=1
   t=1
   while [ $t -le ${Ntest_types} ]; do
   test_grep[t]=$(${awk} -v l=$t -v c=1 'BEGIN{FS="!"}{lr=lr+1;if (lr==l+1) print $c}' ${test_types_file})
   test_col[t]=$(${awk} -v l=$t -v c=2 'BEGIN{FS="!"}{lr=lr+1;if (lr==l+1) print $c}' ${test_types_file})
   let t=t+1
   done

   ###################################################################################
   #
   # *** now start testing
   # *** for a given directory we do a run on all files in TEST_FILES and
   # *** do the test as indicated by the number
   # *** files are run in order so that they can e.g. restart
   #
   ###################################################################################
   n_runtime_error=0
   n_wrong_results=0
   n_correct=0
   n_tests=0

   echo "------------------------- dynamic libraries linked -----------------------"
   echo "ldd  ${dir_base}/${cp2k_dir}/exe/${dir_triplet}/cp2k.${cp2k_version} : "
   ldd  ${dir_base}/${cp2k_dir}/exe/${dir_triplet}/cp2k.${cp2k_version}
   echo "--------------------------------------------------------------------------"

   printf "Copying tests into working directory ... "

   # Copy the tests into the working regtest directory.
   if df --output=target >/dev/null ; then
     # GNU coreutils version for Linux etc.
     source_device=$(df --output=target ${dir_base}/${cp2k_dir}/tests | tail -1)
     target_device=$(df --output=target ${dir_test} | tail -1)
     if [[ -f /.dockerenv ]]; then
       printf "Inside Docker, using normal copy ... "
       cp -a ${dir_base}/${cp2k_dir}/tests ${dir_test}
     elif [[ ${source_device} == "/afs" || ${target_device} == "/afs" ]]; then
       printf "cannot use hard links with AFS.\n"
       printf "Using normal copy instead ... "
       cp -a ${dir_base}/${cp2k_dir}/tests ${dir_test}
     elif [[ ${source_device} == ${target_device} ]]; then
        cp -al ${dir_base}/${cp2k_dir}/tests ${dir_test}/tests || \
        cp -rpl ${dir_base}/${cp2k_dir}/tests ${dir_test}/tests
     else
       echo "cannot use hard links to copy the tests folder."
       echo "Source device is ${source_device} for ${dir_base}/${cp2k_dir}/tests"
       echo "Target device is ${target_device} for ${dir_test}"
       printf "Using normal copy instead ... "
       cp -a ${dir_base}/${cp2k_dir}/tests ${dir_test}
     fi
   else
     # Probably running on a mac, just use normal cp
     cp -a ${dir_base}/${cp2k_dir}/tests ${dir_test}
   fi

   printf "done!\n"

   #
   # preprocess the restrict directories if the retest is enabled
   #
   last_test_dir=""
   retest_dirs=""
   if [[ $doretest == "yes" ]]; then
     last_test_dir=$(ls ${dir_out} | grep ^TEST-${dir_triplet}-${cp2k_version}- | tail -2 | head -1)
     if [[ "${testdir}" == "${last_test_dir}" ]]; then
       echo "No TEST directory with latest test results found. Nothing to test!"
       rm ${lockfile}
       rm -rf ${dir_test}
       exit 5
     elif [[ ! -f "${dir_out}/${last_test_dir}/error_summary" ]]; then
       echo "No error summary exists in the last TEST directory. Nothing to test!"
       rm ${lockfile}
       rm -rf ${dir_test}
       exit 6
     else
       retest_dirs=$(grep .inp.out ${dir_out}/${last_test_dir}/error_summary | awk -F/ '{ test = 0; for (i = 1; i < NF; i++) { if (test == 1) { printf "%s/", $i } if ($i ~ /TEST/) test = 1; } printf "\n" }' | sort | sed 's/\/$//' | awk '!x[$0]++')
       for t in ${retest_dirs}; do
         let ndirstorestrict=ndirstorestrict+1;
         restrict_dirs[ndirstorestrict]=$t;
       done
       if (( ndirstorestrict == 0 )); then
          echo "No error occurred during the last run. Nothing to retest!"
          rm ${lockfile}
          rm -rf ${dir_test}
          exit 0
       fi
     fi
   fi

   #
   # get the cp2k flags for supported features
   #
   cp2kflags=$(${cp2k_prefix} --version ${cp2k_postfix} < /dev/null 2>&1 | grep cp2kflags )
   echo "CP2K supports: $cp2kflags"

   # get a list of regtest directories
   dirs=$(cat ${dir_test}/tests/TEST_DIRS | grep -v "#" | awk '{print $1}')

   # prepend list of unit-tests to dirs, use a special "UNIT/" prefix
   if [[ "$do_unit_test" == "yes" ]]; then
      if [[ "${cp2k_version}" == "sopt" ]]; then
         ext="ssmp"
      elif [[ "${cp2k_version}" == "popt" ]]; then
         ext="psmp"
      else
         ext="${cp2k_version}"
      fi
      for unittest in ${dir_base}/${cp2k_dir}/exe/${dir_triplet}/*_unittest.${ext}
      do
       t=${unittest##*/}
       dirs="UNIT/${t%.*} $dirs "
      done
   fi

   # sharding
   new_dirs=""
   t=1
   for dir in ${dirs} ; do
     if ((t % nshards + 1 == ishard )) ; then
       new_dirs="$new_dirs $dir"
     fi
     let t=t+1
   done
   dirs=$new_dirs

   # filter out test-dir that should be skipped
   new_dirs=""
   for dir in ${dirs}
   do
     dir=${dir%/}
     match="no"
     t=1
     # Match to exclusion list
     while [ $t -le ${ndirstoskip} ]; do
        if [[ "${skip_dirs[t]}" == "${dir}" ]]; then
           match="yes"
        fi
        let t=t+1
     done
     # Match to the restrict list, if no restrict list is found, all dirs match
     if [ ${ndirstorestrict} -gt 0 ]; then
        restrictmatch="no"
        t=1
        while [ $t -le ${ndirstorestrict} ]; do
           if [[ "${restrict_dirs[t]%/}" == "${dir}" ]]; then
              restrictmatch="yes"
           fi
           let t=t+1
        done
     else
       restrictmatch="yes"
     fi

     # does this dir require features we do not have ?
     featurematch="yes"
     features_required=$(cat ${dir_test}/tests/TEST_DIRS | grep -v "#" | awk -v dir="$dir" '{if ($1==dir) for(i=2;i<=NF;i++) printf("%s ",$i)}')
     for fr in $features_required
     do
        # allow a specification on the mpiranks needed e.g. fr="mpiranks>2&&mpiranks<6"
        echo $fr | grep mpiranks >& /dev/null
        if [[ "$?" == "1" ]]; then
          echo $cp2kflags | grep $fr >& /dev/null
          res=$?
        else
          res=$(echo "" | awk -v mpiranks=$numprocs "{print !($fr)}")
        fi
        if [[ "$res" == "1" ]]; then
           featurematch="no"
           echo "Skipping $dir : missing required feature : $fr"
        fi
     done

     # If not excluded add to list of dirs
     if [[ "${match}" == "no" && "${restrictmatch}" == "yes" && "${featurematch}" == "yes" ]]; then
        new_dirs="$new_dirs $dir"
     fi
   done
   dirs=$new_dirs

   # Just to be sure, clean possible existing status files.
   cd ${dir_test}
   mkdir ${dir_test}/status
   rm -f ${dir_test}/status/REGTEST_RUNNING-* \
       ${dir_test}/status/REGTEST_TASK_RESULT-* \
       ${dir_test}/status/REGTEST_TASK_TESTS-*

   #
   # generate farming input
   #
   if [[ "$farming" == "yes" ]]; then
   echo "generating farming input "
   ijob=0
   cat << EOF > ${dir_test}/farming.inp
&GLOBAL
  PROJECT farming
  PROGRAM FARMING
  RUN_TYPE NONE
&END GLOBAL
&FARMING
  GROUP_SIZE $numprocs
  MASTER_SLAVE
EOF
   idir=0
   for dir in ${dirs}; do
     if [[ $dir != UNIT/* ]]; then
       # generate output dir
       mkdir -p ${dir_test}/${dir}
       #
       # generate the equivalent farming input
       #
       idir=$((idir+1))
       ntest=$(grep '^\s*\w' ${dir_test}/tests/${dir}/TEST_FILES | ${awk} '{c=c+1}END{print c}')
       for ((itest=1;itest<=ntest;itest++));
       do
         input_file=$(grep '^\s*\w' ${dir_test}/tests/${dir}/TEST_FILES | ${awk} -v itest=$itest '{c=c+1;if (c==itest) print $1}')
         output_file=${dir_test}/${dir}/${input_file}.out
         jobid=$((idir*100000+itest))
         if [[ $itest != 1 ]]; then
            jobid_prev=$((idir*100000+itest-1))
            depstr="DEPENDENCIES $jobid_prev"
         else
            depstr=""
         fi
         ijob=$((ijob+1))
         printf "&JOB \n   DIRECTORY ${dir_test}/tests/${dir} \n   INPUT_FILE_NAME ${input_file} \n   OUTPUT_FILE_NAME ${output_file} \n   JOB_ID $jobid \n   $depstr \n&END JOB\n" >> ${dir_test}/farming.inp
       done
     fi
   done
   printf "&END FARMING\n" >> ${dir_test}/farming.inp
   echo "Running farming for $ijob jobs"
   ${cp2k_prefix} ${dir_base}/${cp2k_dir}/exe/${dir_triplet}/cp2k.${cp2k_version} farming.inp ${cp2k_postfix} < /dev/null >& farming.out
   if (( $? )); then # on failed farming, provide info
      echo "==================== Farming terminated with an error, dumping output  ========================"
      cat farming.out
      echo "==============================================================================================="
   else
      echo "farming went fine"
   fi
   fi

   #
   # execute all regtests
   #
   (( ndir = $(echo ${dirs} | wc -w) ))
   (( idir = 0 ))
   for dir in ${dirs}; do
    (( idir++ ))
    # tests in different dirs can run in parallel. We spawn processes up to a given maximum
    (
     if [[ $dir == UNIT/* ]]; then
         run_unittest $dir
     else
         run_regtest_dir $dir
     fi
    )&


    #
    # Here we allow only a given maximum of tasks
    #
    runningtasks=10000
    while (( runningtasks >= maxtasks/(numprocs*OMP_NUM_THREADS) )); do
       sleep 0.1
       runningtasks=$(ls -1 ${dir_test}/status/REGTEST_RUNNING-* 2>/dev/null | wc -l)
    done

   done

   #
   # wait for all tasks to finish
   #
   wait


   #
   # generate results
   #
   for dir in ${dirs};
   do
     task=${dir//\//-}
     file=${dir_test}/status/REGTEST_TASK_RESULT-$task
     tmp=$(awk '{print $1}' $file)
     n_runtime_error=$((n_runtime_error+tmp))
     tmp=$(awk '{print $2}' $file)
     n_wrong_results=$((n_wrong_results+tmp))
     tmp=$(awk '{print $3}' $file)
     n_correct=$((n_correct+tmp))
     tmp=$(awk '{print $4}' $file)
     n_tests=$((n_tests+tmp))
     rm -f $file
   done

   echo "--------------------------------------------------------------------------"
   cat "${error_description_file}"
   echo "--------------------------------------------------------------------------"
   file_info
   echo ""
   echo "--------------------------------- Timings --------------------------------"
   ${dir_base}/${cp2k_dir}/tools/regtesting/timings.py "${timings}"
   echo ""
   echo "--------------------------------- Summary --------------------------------"
   if [[ ${quick} != "quick" ]]; then
      printf "Number of COMPILE warns %d\n" ${compile_warnings} | tee -a ${summary}
   fi
   printf "Number of FAILED  tests %d\n" ${n_runtime_error}  | tee -a ${summary}
   printf "Number of WRONG   tests %d\n" ${n_wrong_results}  | tee -a ${summary}
   printf "Number of CORRECT tests %d\n" ${n_correct}        | tee -a ${summary}
   printf "Total number of   tests %d\n" ${n_tests}          | tee -a ${summary}

   if [[ ${leakcheck} == "YES" ]]; then
      echo "--------------------------------------------------------------------------" | tee -a ${summary}
      case ${FORT_C_NAME} in
         gfortran*)
          n_leaking_tests=$(grep "XXXXXXXX" ${memory_description_file} | wc | ${awk} '{print $1}')
          n_leaks=$(grep "SUMMARY" ${memory_description_file} | ${awk} 'BEGIN{n=0}{n=n+$7}END{print n}')
          printf "Number of LEAKING tests %d\n" ${n_leaking_tests} | tee -a ${summary}
          ;;
      esac
      (( n_leaks == 0 )) && echo "No memory leaks detected" >>${memory_description_file}
      printf "Number of memory  leaks %d\n" ${n_leaks} | tee -a ${summary}
      if [[ -s ${dir_base}/suppr.txt ]]; then
         echo "--------------------------------------------------------------------------" | tee -a ${summary}
         printf "Note, that the following leak suppressions are currently active:\n" | tee -a ${summary}
         cat ${dir_base}/suppr.txt | tee -a ${summary}
      fi
      echo "--------------------------------------------------------------------------" | tee -a ${summary}
      echo "GREPME ${n_runtime_error} ${n_wrong_results} ${n_correct} 0 ${n_tests} ${n_leaks}"
   else
      echo "No memory leak check was performed" >>${memory_description_file}
      echo "GREPME ${n_runtime_error} ${n_wrong_results} ${n_correct} 0 ${n_tests} X"
   fi

   full_time_t2=$(date +%s)
   full_timing_all=$((1+full_time_t2-full_time_t1))

   REPORT_SUMMARY=$(printf "correct: %d / %d" ${n_correct} ${n_tests})
   if (( n_wrong_results > 0 )); then
       REPORT_SUMMARY+=$(printf "; wrong: %d" ${n_wrong_results})
   fi
   if (( n_runtime_error > 0 )); then
       REPORT_SUMMARY+=$(printf "; failed: %d" ${n_runtime_error})
   fi
   if (( n_leaks > 0 )); then
       REPORT_SUMMARY+=$(printf "; memleaks: %d" ${n_leaks})
   fi
   REPORT_SUMMARY+=$(python3 -c "print('; %.0fmin'%(${full_timing_all}/60.0))")
   echo -e "\nSummary: ${REPORT_SUMMARY}"

   if ((n_wrong_results > 0)) || ((n_runtime_error > 0)) || ((n_leaks > 0)); then
       echo -e "Status: FAILED\n"
   else
       echo -e "Status: OK\n"
   fi

   echo "--------------------------------------------------------------------------"
   printf "Regtest took %0.2f seconds.\n" ${full_timing_all}
   echo "--------------------------------------------------------------------------"
   date
   echo "*************************** testing ended ********************************"
fi

rm ${lockfile}
exit 0

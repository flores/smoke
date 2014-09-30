#!/bin/bash
usage() { 
  cat <<EOF
smoke.sh runs smoke tests on your box
usage: smoke.sh <option>

where option can be:
  -l <file> :silently write logs to <file>. default: /var/log/smoke.log
  -f :only output failures. default: false
  -d <directory> :runs tests in <directory>. default: tests/
  -h :prints this message
EOF
}

test_dir="$(dirname $0)/tests"

output_failure="/dev/stderr"
output_standard="/dev/stdout"

color_red=$(tput setaf 1)
color_green=$(tput setaf 2)
color_clear=$(tput sgr0)

while getopts "l:d:hfa" OPTION; do
  case $OPTION in
  l)
    output_failure=$OPTARG
    output_standard=$OPTARG
    ;;
  f)
    output_standard="/dev/null"
    ;;
  d)
    test_dir=$OPTARG
    ;;
  h)
    usage
    exit 1
    ;;
  a)
    output_failure="/var/log/smoke.log"
    output_standard="/var/log/smoke.log"
    ;;
  esac
  shift
done

exit=0

display_result () {
  testname=$1
  status=$2

  header="========================="

  output="%s${header}\n"
  output+="%s: %s %s %s\n"
  output+="${header}${color_clear}\n"

  if [[ $status -ne 0 ]]; then
    printf "$output" $color_red "FAIL" $testname "exited status" $status
  else
    printf "$output" $color_green "PASS" $testname "OK"  ""
  fi
}

for testname in $(/bin/ls $test_dir); do
  echo "running $testname..." &> $output_standard
  $test_dir/$testname &> $output_standard

  status=$?

  display_result $testname $status

done

exit $exit

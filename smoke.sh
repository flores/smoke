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

color_red='\e[0;31m'
color_green='\e[0;32m'
color_clear='\e[0m'

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
  test=$1
  status=$2

  header="========================="

  output="%s${header}\n"
  output+="%s: %s %s %s\n"
  output+="${header}${color_clear}\n"

  if [ $status -ne 0 ]; then
    printf "$output" $color_red "FAIL" $test "exited status" $status
  else
    printf "$output" $color_green "PASS" $test "OK"  ""
  fi
}

for test in `/bin/ls $test_dir`; do
  echo "running $test..." &> $output_standard
  #readlink -f $i
  $test_dir/$test &> $output_standard

  status=$?

  display_result $test $status

done

exit $exit

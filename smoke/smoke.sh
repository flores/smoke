#!/bin/bash
##################
#
# smoke runs an audit/smoketest on your server
#
##################

output_failure="/dev/stdout"
output_standard="/dev/stdout"

set -- $(getopt "lh:" -- "$@")

while [ $# -gt 0 ]; do
  case "$1" in
  -l|--log)
    output_failure="/var/log/smoke.log"
    output_standard="/dev/null"
    ;;
  -h|--help|\?)
    echo -e "usage: `basename $0` <option>\nwhere option can be:\n--log|-l silently writes failure to /var/log/smoke.log\n--logall|-a writes all output to /var/log/smoke.log\n--help|-h prints this message"
    exit 1
    ;;
  -a|--logall)
    output_failure="/var/log/smoke.log"
    output_standard="/var/log/smoke.log"
    ;;
  esac
  shift
done

exit=0

for test in tests/*; do
  echo "running $test..." &>>$output_standard
  #readlink -f $i
  $test &>>$output_standard

  status=$?

  if test $status -ne 0; then
    exit=1
    echo "^[[0;31;40m

=========================
FAIL: $test exited status $status!
=========================
^[[0;;m" &>>$output_failure

  else
    echo "^[[0;32;40m

=========================
PASS: $test OK
=========================
^[[0;;m" &>>$output_standard
  fi

done

exit $exit

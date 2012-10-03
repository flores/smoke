#!/bin/bash
usage=`cat <<EOF
smoke.sh runs smoke tests on your box\n
usage: smoke.sh <option>\n
\n
where option can be:\n
\t-l <file> :silently write logs to <file>. default: /var/log/smoke.log\n
\t-f :only output failures. default: not set\n
\t-d <directory> :runs tests in <directory>. default: tests/\n
\t-h :prints this message\n
EOF
`

test_dir="tests"
output_failure="/dev/stdout"
output_standard="/dev/stdout"


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
    echo -e $usage
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

for test in `ls $test_dir`; do
  echo "running $test..." &> $output_standard
  #readlink -f $i
  $test_dir/$test &> $output_standard

  status=$?

  if test $status -ne 0; then
    exit=1
    echo "^[[0;31;40m

=========================
FAIL: $test exited status $status!
=========================
^[[0;;m" &> $output_failure

  else
    echo "^[[0;32;40m

=========================
PASS: $test OK
=========================
^[[0;;m" &> $output_standard
  fi

done

exit $exit

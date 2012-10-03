#!/bin/bash
usage=` cat <<END
${basename $0} runs smoke tests on your box\n
usage: ${basename $0} <option>\n
where option can be:\n
  --log|-l <file> :silently write logs to <file\n
  --failures|-f :only output failures\n
  --directory|-d <directory> :run tests in <directory>\n
  --help|-h prints this message\n
END`

test_dir="tests"
output_failure="/dev/stdout"
output_standard="/dev/stdout"

set -- $(getopt "l:d:hfa" -- "$@")

while [ $# -gt 0 ]; do
  case "$1" in
  -l|--log)
    output_failure="${OPTARG}"
    output_standard="${OPTARG}"
    ;;
  -f|--failures)
    output_standard="/dev/null"
    ;;
  -d|--directory)
    test_dir="${OPTARG}"
    ;;
  -h|--help|\?)
    echo -e $usage
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
  echo "running $test..." &> $output_standard
  #readlink -f $i
  $test &> $output_standard

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

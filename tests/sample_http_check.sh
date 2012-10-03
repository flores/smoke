#!/bin/bash

connections=`netstat -ano |egrep -c '^:80$'`;
if [ $connections -lt 1 ]; then
	echo "status err no server listening!"
	exit 1
else
	echo "status OK, port 80 has a listener"
fi

#!/bin/bash

connections=`netstat -ano |egrep '^:80$'`;
if [ $SIMULTANEOUS -lt 1 ]; then
	echo "status err no server listening!"
	exit 1
else
	echo "status OK, port 80 has a listener"
fi

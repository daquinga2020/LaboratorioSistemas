#!/bin/sh

usage()
{
	echo usage: waitrun.sh cmd 1>&2
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

while ! [ -f "/tmp/go" ]
do	
	sleep 1
done

$1

exit 0

#!/bin/sh

usage(){
	echo "usage: $0 [-r]" 1>&2
	exit 1
}

if [ $# -gt 1 ]; then
	usage
fi

RECUR=false
if [ $# -eq 1 ]; then
	if [ "$1" = "-r" ]; then
		RECUR=true
	else
		usage
	fi
fi

if [ "$RECUR" = true ]; then
	fich=$(find . -type f -printf "%f %s\n" | sort -k2 -nr | head -n 1 | awk '{print $1}')
else
	fich=$(ls -l | egrep ^- | sort -rn -k5 | head -n 1 | awk '{print $9}')
fi

if [ -z "$fich" ]; then
	echo "no command to print" 1>&2
	exit 1
fi

fich=$(realpath $fich)
echo "mv $fich $fich.old"

exit 0

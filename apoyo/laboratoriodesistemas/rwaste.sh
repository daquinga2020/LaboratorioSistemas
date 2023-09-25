#!/bin/sh

usage(){
	echo "usage: $0 [-c N | -m N]" 1>&2
	exit 1
}

if [ $# -ne 2 ]; then
	usage
fi

case $1 in
	"-c")
		ps -A -o pmem,user | grep [0-9] | sort -r -k2 | uniq -f1 | sort -rn -k2 |\
		awk '{print $2}' | head -n $2
		;;
	"-m")
		ps -A -o pmem,user | grep [0-9] | sort -r -k2 | uniq -f1 | sort -rn -k2 |\
		awk '{print $2}' | head -n $2
		;;
	*)
		usage
		;;
esac
exit 0

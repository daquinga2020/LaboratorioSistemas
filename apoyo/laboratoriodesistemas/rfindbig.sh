#!/bin/sh

usage(){
	echo "usage: $0 N [user]" 1>&2
	exit 1
}

case $# in
	1)
		find . -type f -printf "%s %f\n" | sort -nr |\
		awk '{print $2" "}' | head -n $1 | tr -d "\n"
		echo
		;;
	2)
		find . -type f -printf "%u %f %s\n" | egrep ^$2 | sort -nr -k3 |\
                awk '{print $2" "}' | head -n $1 | tr -d "\n"
		echo
		;;
	*)
		usage
		;;
esac

exit 0

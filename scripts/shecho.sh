#!/bin/sh

usage()
{
	echo usage: shecho.sh [-s] [arg] ... 1>&2
	exit 1
}

if [ "$1" = "-h" ]; then
       usage
fi

case "$1" in
"-s")
	shift
	for i in $@; do
		echo -n "$i\t"
	done | sed -E 's/\t$//g'
	echo
	;;
*)
	for i in "$@"; do
		echo -n $i"\t"
	done | sed -E 's/\t$//g'
	echo
	;;
esac

exit 0 

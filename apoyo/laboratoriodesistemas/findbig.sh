#!/bin/sh

case "$#" in

0)
	echo "Error: Introduzca al menos un parámetro" 1>&2
	exit 1
	;;
1)
	find . -type f -printf "%s %p\n" | sort -r -n | head -n $1 |\
	awk -F/ '{print $NF" "}' | tr -d "\n"
	echo
	exit 0
	;;
2)
	find . -type f -user $2 -printf "%s %p\n" | sort -r -n | head -n $1 |\
	awk -F/ '{print $NF" "}' | tr -d "\n"
	echo
	exit 0
	;;
*)
	echo "Error: Exceso de parámetros" 1>&2
	exit 1
	;;
esac

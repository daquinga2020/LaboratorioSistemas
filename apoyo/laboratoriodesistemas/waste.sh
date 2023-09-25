#!/bin/sh

if echo $2 | egrep -v -q ^[0-9]+$ || [ $# -ne 2 ]
then
        echo "usage: ./waste.sh [-c N | -m N]" 1>&2
        exit 1
fi

case $1 in
"-c")
	ps -A -o pcpu,user | grep [0-9] | sort -r -k2 |\
	uniq -f1 | sort -rn | head -n $2 | awk '{print $NF}'
	;;
"-m")
	ps -A -o pmem,user | grep [0-9] | sort -r -k2 |\
	uniq -f1 | sort -rn | head -n $2 | awk '{print $NF}'
	;;
*)
        echo "usage: ./waste.sh [-c N | -m N]" 1>&2
        exit 1
        ;;
esac
exit 0

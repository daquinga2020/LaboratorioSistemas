#!/bin/sh

if test $# -eq 0 > /dev/null 2>&1;then
	echo usage: findbig N [USER]
fi

if test $# -eq 1 > /dev/null 2>&1;then
	echo $(find ./ -type f -printf '%s %p\n'| sort -nr | head -$1 |awk -F '/' '{print $NF}'|awk '{ printf "%s ", $0 }')
fi

if test $# -eq 2 > /dev/null 2>&1;then
	echo $(find ./ -type f -user $2 -printf '%s %p\n'| sort -nr | head -$1 |awk -F '/' '{print $NF}'|awk '{ printf "%s ", $0 }')
fi

exit 0

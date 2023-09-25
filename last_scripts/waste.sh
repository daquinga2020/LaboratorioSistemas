#!/bin/sh

CPU="-c"
MEM="-m"

if test $# -eq 0 > /dev/null 2>&1;then
	echo usage: ./waste.sh "[-c N |-m N]"

elif test $# -eq 2 > /dev/null 2>&1;then
	if test "$1" = "$CPU" > /dev/null 2>&1; then
		ps -A -o pcpu,user| sed -E '/\%CPU USER/d'| sort -nr | uniq -1 | sort -k 2 -r | uniq -1 | sort -nr| awk '{print $2}' | head -$2

	elif test "$1" = "$MEM" > /dev/null 2>&1; then
		ps -A -o pmem,user| sed -E '/\%MEM USER/d'| sort -nr | uniq -1 | sort -k 2 -r | uniq -1 | sort -nr| awk '{print $2}' | head -$2
	else
		echo usage: ./waste.sh "[-c N |-m N]"
	fi
else
	echo usage: ./waste.sh "[-c N |-m N]"
fi

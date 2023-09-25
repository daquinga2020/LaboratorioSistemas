#!/bin/sh

usage(){
	echo "usage: $0 command pids [pids ...]"
	exit 1
}

if [ $# -lt 2 ]; then
	usage
fi

command="$1"
shift

for i in $@; do
	if echo $i |  egrep -q -v ^[0-9]+$; then
		usage
	fi
done

for pid in $@; do
	finish=false
	for i in $(seq 1 20); do
		if ! ps -aux | awk '{print $2}' | egrep -q ^$i$; then
			finish=true
			break
		fi
		sleep 1
	done

	if [ $finish = false ]; then
		echo kill -KILL $pid #sería sin el echo
	else
		$command
	fi
done

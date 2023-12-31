#!/bin/sh

usage(){
	echo "usage: $0 [-r]" 1>&2
	exit 1
}

recurfile(){
	files=$(du -ab | sort -nr | awk '{print $2}')
	for i in $files; do
		if [ -f "$i"]; then
			echo "$i"
			return
		fi
	done
	echo /
}


RECURR=false

if[ $# -eq 1 ] && [ $1 = '-r' ]; then
	shift
	RECURR=true
fi

if[ $# -ne 0 ]; then
	usage
fi

if [ $RECURR = false ]; then
	bigfile=$(ls -l | grep '^-'| sort -nr -k5,5 | awk '{print $9}' | sed 1q)

else
	bigfile=$(recurfile)
fi

echo mv $PWD/$bigfile $PWD/$bigfile.old

exit 0

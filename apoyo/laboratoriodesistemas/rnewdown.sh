#!/bin/sh

usage(){
	echo "usage: $0 [N]" 1>&2
	exit 1
}

if [ $# -gt 1 ]; then
	usage
fi

N=0
if [ $# -eq 1 ]; then
	N=$1
fi

current=$(($(date +%s) - $(($N * 3600 * 24))))

for i in $(ls -l $HOME/rep | egrep ^- | awk '{print $NF}'); do
	datefich=$(date  +%s -r $HOME/rep/$i)
	if [ "$datefich" -le "$current" ]; then
		times=$(echo "$times $datefich"_"$i" | tr " " "\n")
	fi
done

echo "$times" | sed 's/_/ /' | sort -rn | head -n 3 | awk '{print $2}'

exit 0

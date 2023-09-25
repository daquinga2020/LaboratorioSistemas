#!/bin/sh

usage(){
	echo "usage: $0 dir"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

cd $1
rm -f ?.output

for i in $(ls -l | egrep ^- | awk '{print $NF}' | sed 's/[A-Z]/\L&/' | sed -E 's/(.).*/\1/' | sort -u); do
	fich=$(ls | egrep -i ^$i.*.txt | sort)
	if ! [ -z "$fich" ]; then
		cat $fich > $i.output
	fi
done
exit 0

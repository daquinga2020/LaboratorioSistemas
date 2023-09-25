#!/bin/sh

usage(){
	echo "usage: $0 dir" 1>&2
	exit 1
}

if [ $# -ne 1 ] || ! [ -d "$1" ]; then
	usage
fi
dirname=$1

cd $dirname
rm -f ?.output

for i in $(ls | sed -E 's/(.).*/\1/' | sed 's/[A-Z]/\L&/g' | sort -u); do
	names=$(ls | egrep -i ^$i.*'.txt'$ | sort)
	if ! [ -z "$names" ]; then
		cat $names > $i.output
	fi
done

exit 0

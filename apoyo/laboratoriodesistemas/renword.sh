#!/bin/sh

usage(){
	echo "usage: $0 string" 1>&2
	exit 1
}

if [ $# -ne 1 ];then
	usage
fi

for i in $(ls); do
	if file --mime-type $i | awk '{print $2}' | egrep -q ^image; then
		mv $i "foto_"$i
	elif file --mime-type $i | awk '{print $2}' | egrep -q ^text; then
		if cat $i | egrep -q ^$1; then
			mv $i $1.$i
		fi
	fi
done
exit 0

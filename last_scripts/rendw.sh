#!/bin/sh


for i in $(ls);do
	t=$(file --mime-type $i|awk '{print $2}')

	if [ $(file --mime-type $i|awk '{print $2}'|grep -E "text") ] > /dev/null 2>&1; then
		for j in $(awk '{print $1}' $i); do
		if [ $j = "$1" ] > /dev/null 2>&1; then
			mv $i $i.$1
		fi
		done
	elif [ $(file --mime-type $i|awk '{print $2}'|grep -E 'image') ] > /dev/null 2>&1; then
		mv $i foto_$i
	fi

done

#!/bin/sh

usage(){
	echo "usage: $0 word [word ...] msg"
	exit 1
}

if [ $# -lt 2 ]; then
	usage
fi

for i in $@; do
	str=$i
done
for i in $@; do

	if dmesg | awk -F "]" '{print $2}'| egrep -E "^ $i" | egrep -E "$str"; then
		dmesg | awk -F "]" '{print $2}'| egrep -E "^ $i" | egrep -E "$str"|sed -E 's/:/\\\t/'|sed -E 's/\ (.*)\\/!\1!/'
	fi
done

exit 0

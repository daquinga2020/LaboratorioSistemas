#!/bin/sh

usage(){
	echo "usage: $0 dir" 1>&2
	exit 1
}

if [ $# -ne 1 ] || ! [ -d "$1" ]; then
	usage
fi

cd $1

dir=$(date +%d_%b_%Y)

if [ -d "$dir" ]; then
	echo "$dir has already exits" 1>&2
	exit 1
fi
mkdir $dir

for i in $(ls | sort); do
	photos=$(echo $photos $(file --mime-type $i | awk -v f=$i '$2 ~ /^image/ {print f}'))
done

n=$(($(echo $photos | wc -w | wc -m) - 2))
count=0
for i in $photos; do
	name=$count
	while [ $n -ge $(($(echo $name | wc -m) - 1)) ]; do
		name=$(echo 0$name)
	done
	count=$(($count + 1))
	final=$(echo $i | awk -F. '{print $NF}')
	cp $i $dir/$name.$final
done
exit 0

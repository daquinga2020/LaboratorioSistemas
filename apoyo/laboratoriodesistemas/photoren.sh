#!/bin/sh

usage(){
	echo usage: $0 dir 1>&2
	exit 1
}

namefile(){
        lnum=$(($(echo "$1" | wc -m) - 1))
        name=''
	dif=$(($2 - $lnum))
	for var in $(seq $dif); do
		name=$(echo 0$name)
	done
        echo $name$1
}

if [ "$#" != 1 ] || ! [ -d "$1" ]; then
	usage
fi

namedir=$(date +%d_%b_%Y)
if [ -d "$namedir" ]; then #comprobar si ya existe un directorio con ese nombre => mkdir da error
	echo "error: dir $namedir has alredy exits" 1>&2
	exit 1
fi
mkdir $namedir

for i in $(ls $1); do
	image=$(file --mime-type $i | egrep 'image/[a-z]+$' | awk -F: '{print $1}')
	if ! [ -z "$image" ]; then
		cp $1/$image $PWD/$namedir/$image
	fi
done

numimg=$(($(ls -l $PWD/$namedir | wc -l) - 1))
long=$(($(echo $numimg | wc -m) - 1))
n=0
for i in $(ls $PWD/$namedir); do
	namefile=$(namefile $n $long)
	final=$(echo $i | awk -F. '{print $2}')
	mv $PWD/$namedir/$i $PWD/$namedir/$namefile.$final
	n=$(($n + 1))
done

exit 0

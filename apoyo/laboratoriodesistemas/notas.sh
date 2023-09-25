#!/bin/sh

usage(){
	echo "usage: $0 fich..." 1>&2
	exit 1
}

if [ $# -eq 0 ] || [ "$rango" = false ]; then
	usage
fi

if [ -e NOTAS ]; then
	echo "file NOTAS has already exits" 1>&2
	exit 1
fi

for i in $@; do
	if ! [ -f "$i" ]; then
		usage
	fi

	if ! $(cat $i | awk '($2 < 0.0 || $2 > 10.0) {exit (1);}'); then
		echo "bad rank" 1>&2
		exit 1
	fi
done

echo "#dni nota" > NOTAS
names=$(cat $@ | awk '{print $1}' | sort | uniq)

for i in $names; do
	count=0
	for f in $@; do
		if $(cat $f | grep -q $i); then
			count=$(($count + 1))
		fi
	done
	if [ $count -eq $# ]; then
		total=0
		avg=$(cat $@ | grep $i | awk -v n=$# -v t=$total '{t+=$2} END{printf "%.1f", t / n}')
		echo $i $avg >> NOTAS
	else
		echo $i "NP" >> NOTAS
	fi
done
exit 0

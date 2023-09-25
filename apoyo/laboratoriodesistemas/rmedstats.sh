#!/bin/sh

usage(){
	echo "usage: $0 file..." 1>&2
	exit 1
}

median(){
	middle=$(($1 / 2 + 2))
	if [ $(($1 % 2)) -eq 0 ]; then
		middle2=$(($1 / 2 + 1))
		cat $2 | sed -n ''${middle2},${middle}p'' | awk -v c=$3 -v total=0 '{total+=$c} END{printf "%.2f", total / 2}'
	else
		cat $2 | sed -n ''${middle}p'' | awk -v c=$3 '{printf "%.2f", $c}'
	fi
}

if [ $# -eq 0 ]; then
	usage
fi

for i in $@; do
	if ! [ -f "$i" ]; then
		usage
	fi
done

for fich in $@; do
	echo $fich
	c=$(cat $fich | sed '1q' | wc -w)
	r=$(($(cat $fich | wc -l) - 1))
	echo $r
	for i in $(seq $c); do
		name=$(cat $fich | sed '1q' | sed 's/#//' | awk -v n=$i '{print $n}')
		med=$(median $r $fich $i)
		avg=$(cat $fich | sed '1d' | awk -v total=0 -v r=$r -v c=$i '{total+=$c} END{printf "%.2f", total / r}')
		echo | awk -v OFS='\t' -v n=$name -v a=$avg -v m=$med '{print "", n":", "avg:", a, "median:", m}'
	done
done
exit 0

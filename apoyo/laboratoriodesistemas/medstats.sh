#!/bin/sh

usage(){
	echo "usage: $0 file..." 1>&2
	exit 1
}

avg(){
	total=0
	for var in $(seq 2 $(($2 + 1)));do
		a=$(cat $1 | sed -n ''${var}'p'| awk -v n=$3 '{print $n}')
 		total=$(echo | awk -v t=$total -v e=$a 'BEGIN{t+=e} {print t}')
	done
	echo | awk -v t=$total -v n=$2 '{printf "%.2f\n", t / n}'
}

med(){
	b=$(cat $1 | tail -n $2 | sort -n -k$3 | sed -n ''${4}'p' | awk -v n=$3 '{print $n}')

	if [ $(($2 % 2)) = 0 ]; then
		half=$(($4 - 1))
		a=$(cat $1 | tail -n $2 | sort -n -k$3 | sed -n ''${half}'p' | awk -v n=$3 '{print $n}')
		b=$(awk -v t1=$a -v t2=$b 'BEGIN{sum = (t1 + t2) / 2} END{printf "%.2f\n", sum}')
	fi
	echo | awk -v t2=$b '{printf ("%.2f\n", t2)}'
}

if [ $# = 0 ]; then
	usage
fi

for i in $@; do
	if ! [ -f "$i" ]; then
		usage
	fi

	if file --mime-type $i | awk '{print $2}' | egrep -v -q ^text; then
		echo "error: $i is not a text file" 1>&2
		exit 1
	fi
done

for f in "$@"; do

	echo $f:

	numcolumns=$(cat $f | head -n 1 | wc -w)
	nums=$(($(cat $f | wc -l) - 1))
	middle=$(($nums / 2 + 1))

	for i in $(seq $numcolumns); do
		name=$(cat $f | head -n 1 | awk -v n=$i '{print $n}' | sed -E 's/^#//')

		avarage=$(avg $f $nums $i)

		median=$(med $f $nums $i $middle)

		echo | awk -v OFS='\t' -v noun=$name -v avg=$avarage -v m=$median '{print "",noun":", "avg:", avg",", "median:", m}'
	done
done

exit 0

#!/bin/sh

usage(){
	echo "usage: $0 file..." 1>&2
	exit 1
}

if [ $# -ge 1 ]; then
	for param in $@; do
		if  ! [ -f "$param" ]; then
			echo "error file $param not found" 1>&2
			exit 1
		fi

		if ! file --mime-type "$param" | awk -F '[:]' '{print $2}' | awk -F '[/]' '{print $1}'| grep 'text' >/dev/null 2>&1; then
			echo "error file $param not is text" 1>&2
			exit 1
		fi

	done
fi

if [ $# = 0 ]; then
	usage
fi

for fich in $@; do
	LONG=$(cat $fich | sed -E '/^#/d' | awk '{n++} END{print n}')
	LONG=$((($LONG / 2)+1))

	ING=$(cat $fich | head -1 | awk '{print $1":"}'| sed -E 's/#//')
	OUTG=$(cat $fich | head -1 | awk '{print $2":"}')
	TIMG=$(cat $fich | head -1 | awk '{print $3":"}')

	MEDIANIN=$(cat $fich | sed -E '/^#/d' | awk '{print $1}'| sort -g |awk -v long="$LONG" ' NR == long {printf "%.2f \n",$1}')
	MEDIANOUT=$(cat $fich | sed -E '/^#/d' | awk '{print $2}'| sort -g |awk -v long="$LONG" ' NR == long {printf "%.2f \n",$1}')
	MEDIANTIME=$(cat $fich | sed -E '/^#/d' | awk '{print $3}'| sort -g |awk -v long="$LONG" ' NR == long {printf "%.2f \n",$1}')

	AVGIN=$(cat $fich | sed -E '/^#/d' | awk '{total += $1; n++} END{printf "%.2f \n", total/n}' | awk '{print $1","}')
	AVGOUT=$(cat $fich | sed -E '/^#/d'| awk '{print $2}' | awk '{total += $1; n++} END{printf "%.2f \n", total/n}'|awk '{print $1","}')
	AVGTIME=$(cat $fich | sed -E '/^#/d'| awk '{print $3}' | awk '{total += $1; n++} END{printf "%.2f \n", total/n}' | awk '{print $1","}')

	echo "$fich:"
	echo|awk -v medianin="$MEDIANIN" -v ing="$ING" -v avgin="$AVGIN" -v OFS='\t' '{print "",ing,"avg:",avgin,"median:",medianin}'
	echo|awk -v medianout="$MEDIANOUT" -v outg="$OUTG" -v avgout="$AVGOUT" -v OFS='\t' '{print "",outg,"avg:",avgout,"median:",medianout}'
	echo|awk -v mediantime="$MEDIANTIME" -v timg="$TIMG" -v avgtime="$AVGIN" -v OFS='\t' '{print "",timg,"avg:",avgtime,"median:",mediantime}'
done

exit 0

#!/bin/sh

# codigo del examen final de laboratorio de sistemas
# esta regular hecho

usage(){
	echo "usage: $0 cad file.mup [file.mup...]" 1>&2
	exit 1
}

if [ $# -lt 2 ]; then
	usage
fi

cad=$1
shift

for i in $@; do
	if ! [ -f "$i" ] || echo $i | egrep -v -q .mup$; then
		usage
	fi
done

for i in $@; do
	touch intermedio
	nlines=$(cat $i | wc -l)
	for n in $(seq $nlines); do
		line=$(cat $i | sed -n ''${n}p'')
		if echo $line | egrep -q  ^"--$cad COMMENT"; then
			newline=$(echo $line | egrep ^"--$cad COMMENT" | sed -E 's/^--'${cad}' COMMENT(.*)/#\1#/')
		elif echo $line | egrep -q ^"--$cad TXT"; then
			newline=$(echo $line | sed -E 's/^--'${cad}' TXT(.*)/\1/')
		fi

		if [ -n "$newline" ];then
			echo $newline >> intermedio
		fi
		echo $newline >> intermedio
	done
	cat intermedio > $i
	rm intermedio
done
exit 0

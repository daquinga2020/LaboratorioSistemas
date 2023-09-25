#!/bin/sh

# muestra un comando que renombra el fichero más grande añadiendo al final .old
	#(directorio actual)
# si nos dicen Fgreat -r lo hace de forma recursiva

usage(){
	echo "usage: $0 [-r]" 1>&2
	exit 1
}

#otra forma de hacerlo
recurfile(){
	files=$(du -ab | sort -nr | awk '{print $NF}')
	for i in $files; do
		if [ -f $i ]; then
			echo $i
			return
		fi
	done
}

RECURR=false
if [ $# = 1 ] && [ $1 = "-r" ]; then
	shift
	RECURR=true
fi

if [ $# != 0 ]; then
	usage
fi

if [ $RECURR = false ]; then
	bigfile=$(ls -l | awk '/^-/ {print $5, $NF}' | sort -nr | head -n 1 | awk '{print $2}')
else
	bigfile=$(find . -type f -printf "%s %p\n" | sort -nr | head -n 1 | awk '{print $NF}')
fi

if ! [ -f "$bigfile" ]; then
	echo "no files to print command" 1>&2
	exit 1
fi

bigfile=$(realpath $bigfile)
echo mv $bigfile $bigfile.old

exit 0

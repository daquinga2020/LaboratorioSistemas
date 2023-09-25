#!/bin/bash

if [ $# -gt 1 ]
then
        echo "Modo de uso : newdown [número]" 1>&2
        exit 1
fi

if [ $# -eq 0 ]
then
	var=1
else
	var=$1
fi

ahora=$(date +"%s")
segpar=$(( 86400 * "$var" ))
tope=$(( "$ahora" - "$segpar" ))

stat -c "%Y %n %F" $HOME/Descargas/* | grep "fichero regular" |\
sort -n -r | awk -v  t=$tope '{if ($1 > t) print $2 }'| head -n 3

exit 0

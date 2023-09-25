#!/bin/sh

usage() {
    echo "usage: $0 [-r]" >&2
    exit 1
}

if [ $# -gt 1 ]; then
    usage
fi

if [ $# -eq 1 ] && [ $1 != "-r" ]; then
    usage
fi

name_f=""
case "$1" in
"-r")
    name_f=`ls -lSR | sort -nrk5 | egrep "^-" | awk '{print $9}' | head -1`
    name_f=`du -a | awk '{print $2}' | grep "$name_f"`
    name_f=`realpath $name_f`
    ;;
*)
    name_f=`ls -lS | egrep "^-" | awk '{print $9}' | head -1`
    ;;
esac


if [ -f "$name_f" ]; then
    echo "mv $name_f $name_f.old" 
else
    echo error: no hay ficheros en el directorio actual >&2
fi


exit 0
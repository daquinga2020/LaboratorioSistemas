#!/bin/sh

usage() {
    echo "usage: $0 dir ext" 1>&2
    exit 1
}

err() {
    echo 'error:' "$1" 1>&2
    exit 1
}

if [ "$#" -ne 2 ]; then
    usage
fi

dir=$1
ext=$2
shift
shift

if ! [ -d $dir ]; then
    err 'not a dir'
fi

pth_act=$(pwd)
cd $dir || err "could not open dir $dir from $pth_act"

pos_fich=$(ls -l | egrep -- '^.r--r--r--' | awk '/.*\.[^ro]+$/ {print $9}')

for i in $pos_fich; do
    if [ -f "$i" ]; then
        file_ext=$(echo $i | sed -E 's/.*\.([^.]+$)/\1/')
        if [ "$file_ext" != "$ext" ]; then
            mv "$i" "$i.ro"
        fi
    fi
done

exit 0
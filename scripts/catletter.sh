#!/bin/sh

usage() {
    echo "usage: $0 dir" >&2
    exit 1
}

if ! [ $# -eq 1 ] || ! [ -d "$1" ]; then
    usage
fi

dir=`realpath $1`
shift

for i in `ls "$dir" | egrep ".+\.output$" 2> /dev/null`; do
    rm "$dir/$i" 2> /dev/null
done

files=`ls "$dir" | egrep ".+\.txt$" | sort -d`
letter=""
for i in $files; do
    letter=`echo "$i" | sed -E 's/(^.).*/\1/g' | tr "[A-Z]" "[a-z]"`
    cat "$dir/$i" >> "$dir/$letter.output"
done



exit 0
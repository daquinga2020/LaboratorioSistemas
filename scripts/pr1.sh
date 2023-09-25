#!/bin/sh

usage() {
    echo "usage: $0 file -f file" 1>&2
    exit 1
}

nastr() {
    astr=""
    for i in `seq 2 $(echo $1 | wc -m)`; do
        astr="$astr*"
    done
    echo "$astr"
}

err() {
    echo 'error:' "$1" 1>&2
    exit 1
}

if [ $# -ne 3 ]; then
    usage
fi

if [ "$2" != "-f" ] || ! [ -f "$1" ] || ! [ -f "$3" ]; then
    usage
fi

f_text="$1"
text=$(cat "$1")
w_cens=$(cat "$3" | tr " " "\n")
shift
shift
shift

astr=""
for wd in $w_cens; do
    astr=`nastr $wd`
    text=`echo "$text" | sed -E "s/$wd/$astr/g"`
done

echo "$text" > $f_text

exit 0
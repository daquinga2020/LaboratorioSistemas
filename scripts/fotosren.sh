#!/bin/sh

usage() {
    echo "usage: $0 [dir]" >&2
    exit 1
}

err() {
    echo 'error:' "$1" >&2
    exit 1
}

if [ $# -gt 1 ]; then
    usage
fi

dir=`pwd`
if [ $# -eq 1 ]; then
    dir=$(realpath "$1")
    shift
fi

if ! [ -d "$dir" ]; then
    err "$dir is not a dir"
fi

if ! cd "$dir"; then
    exit 1
fi

dt=`date | awk '{print $2"_"$3"_"$4}'`

imgs=`file --mime-type * | egrep "image/.+$" | awk '{print $1}' | sed -E 's/:$//g'`

n_img=`echo -n "$imgs"| wc -l`

if [ $n_img -eq 0 ]; then
    echo any image found "in $dir"
    exit 0
fi

newnames=`seq -w 0 $n_img`

for i in $newnames; do
    file=$(echo "$imgs" | head -n $(($i+1)) | tail -n1)
    ext=$(echo $file| sed -E 's/.+(\.[a-zA-Z]+)$/\1/g')
    echo "mv $dir/$file $dir/$dt/$i$ext"
done


exit 0
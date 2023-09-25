#!/bin/sh 

usage() {
    echo "usage: $0 dir" 1>&2
    exit 1
}

empty() {
    echo "no files" 1>&2
    exit 1
}

err() {
    echo 'error: ' "$1" >&2
    exit 1
}

if [ "$#" -ne 1 ]; then
    usage
fi

dir=$1
shift

if ! [ -d $dir ]; then
    err 'not a dir'
fi

pth_act=$(pwd)
cd $dir || err "could not open dir $dir from $pth_act"

pos_fichs=$(ls | awk '/^[^._]+_[^._]+\.col$/{print}')
fichs=""
cont=0

for i in $pos_fichs; do
    if [ -f "$i" ]; then
        fichs="$fichs$i "
        cont=$((cont+1))
    fi
done

if [ $cont -eq 0 ]; then
    empty
fi

for i in $pos_fichs; do
    fich_col_1=$(echo "$i" | sed -E 's/(.*)_(.*).col/\1.1/g')
    fich_col_2=$(echo "$i" | sed -E 's/(.*)_(.*).col/\2.2/g')
    cat "$i" | awk '{print $1}' > "$fich_col_1"
    cat "$i" | awk '{print $2}' > "$fich_col_2"
done

exit 0
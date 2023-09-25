#!/bin/sh

usage()
{
	echo usage: $0 [dir] 1>&2
	exit 1
}

dir="."

if [ "$1" ]; then
	dir=$1
	shift
fi

if [ $# -ne 0 ] ; then
	usage
fi

if ! cd $dir 2> /dev/null; then
	echo error: $dir doesn\'t exist or cd can\'t access 2>&1
	exit 1
fi

ext="_image.jpg"

fich_img=$(file --mime-type * | awk '{if ( $2 == "image/jpeg") {print $1;}}' | sed -E 's/(:)$//g')


for i in $fich_img;
do
	newfich=$(echo $i|sed -E 's/(\.[^.]*)$//g')
	mv $i $newfich$ext
done


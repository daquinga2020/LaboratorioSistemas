#!/bin/sh

TYPNAME=$(file --mime-type * | egrep -e '(text/plain)$' -e '(image/jpeg)$')

ANWNAME=".$1"
FNWNAME="foto_"

for i in $TYPNAME; do

	case $i in
	text/*)
	if egrep -e "^($1)" $ARCHIVO  > /dev/null 2>&1; then
		mv $ARCHIVO $ARCHIVO$ANWNAME
	fi
	;;
	image/*)
	mv $ARCHIVO $FNWNAME$ARCHIVO
	;;
	*)
	ARCHIVO=$(echo $i |tr -d :)
	esac

done

exit 0

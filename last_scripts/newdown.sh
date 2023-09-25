#!/bin/sh
cd 
FECHA=$(ls -lc Descargas/|sed "1d"|awk '{print $7, $6, $8, $9}')
COMP=$(date --date="-$1 day" +%s)
COMP1=$(date --date="-1 day" +%s)
cont=0
reset=-1
FILEDATE=""
ARCH=""
nrecent=""

if test $# -le 1 > /dev/null 2>&1;then
	if test $# -eq 1 > /dev/null 2>&1;then
		for i in $FECHA; do

			if test $cont -eq 3 > /dev/null 2>&1;then
				ARCH=$i
				cont=$reset
				FILEDATE=$(echo $FILEDATE|cut -d " " -f 1-2)
				FILEDATE=$(date -d "$FILEDATE" +%s)
				if test $COMP -ge $FILEDATE > /dev/null 2>&1;then
                                        nrecent=$nrecent" "$ARCH
                                fi

				FILEDATE=""
			else
				FILEDATE=$FILEDATE" "$i
			fi
			cont=$(( $cont + 1 ))

		done
		echo $(echo $n| awk '{print $1, $2, $3}')
	else
		for i in $FECHA; do

                        if test $cont -eq 3 > /dev/null 2>&1;then
                                ARCH=$i
                                cont=$reset
                                FILEDATE=$(echo $FILEDATE|cut -d " " -f 1-2)
                                FILEDATE=$(date -d "$FILEDATE" +%s)
                                if test $COMP1 -ge $FILEDATE > /dev/null 2>&1;then
                                        nrecent=$nrecent" "$ARCH
                                fi

                                FILEDATE=""

                        else
                                FILEDATE=$FILEDATE" "$i
                        fi

                        cont=$(( $cont + 1 ))

                done
                echo $(echo $nrecent| awk '{print $1, $2, $3}')

	fi

else
	echo usage: newdown [N]
fi

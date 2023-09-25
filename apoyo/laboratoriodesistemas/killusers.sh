#!/bin/sh

# lsof => que procesos tienen que direcotrios abiertos
# otra forma(libro): mirar en /proc => ls -ld /proc/[0-9]*/cwd | grep -- '->' | awk '{print $11}'

usage(){
	echo "usage: $0 [-d] dir.." 1>&2
	exit 1
}

exitisnotdir(){
	if ! [ -d $dir ]; then
		echo "error dir $dir not found" 1>&2
		exit 1
	fi
}

R=false
if [ $# -ge 1 ] && [ $1 = '-d' ]; then
	shift
	R=true
fi

if [ $# = 0 ]; then
	usage
fi

cd / # evitar que se mate a si mismo

TOTALPIDS=''
for dir in "$@"; do
	# da los directorios limpios, sin  . ni ..
	dir=$(realpath $dir)

	exitisnotdir $dir

	# prohibir directorio raiz para que no se mate todo
	if [ $dir = '/' ]; then
		echo "error $0: / is not valid" 1>&2
		exit 1
	fi

	# eliminar lso errores por no tener permisos
	# en la cuarta columna contiene cwd => directorio de trabajo
	listpids=$(lsof +D $dir 2>/dev/null | awk '$4 ~ /^cwd$/ {print $2}')

	# juntar todos los pids en una misma lista
	TOTALPIDS="$TOTALPIDS $listpids"
done

# comprobar si la lista est vacía => ningún proceso
if  echo $TOTALPIDS | egrep -vq [0-9]; then
	exit 0
fi

KILLCMD='KILL -KILL'
if [ $R = 'true' ]; then
	echo $KILLCMD $TOTALPIDS
else
	$KILLCMD $TOTALPIDS
fi

exit 0

#!/bin/sh

usage() {
    echo "usage: $0 fich ..." >&2
    exit 1
}

err() {
    echo 'error:' "$1" >&2
    exit 1
}

badgrade () {
    echo "bad grade" >&2
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

cont=0
files=""
for i in $*; do
    if [ -f "$i" ]; then
        cont=$(($cont + 1))
        files="$files$i "
    fi
done

if [ $cont -eq 0 ]; then
    err "no files found"
fi

#cat $@ | awk '($2<0.0 || $2>10.0) || ($2 !~ /\./) {exit (1);}' || badgrade

n=0
content=""
dni=""
for i in $files; do
    dni=$(cat "$i"| awk '{print $1}')" $dni"
    
    if [ `cat "$i" | awk '{print}'|wc -l` -gt $n ]; then
        n=`cat "$i" | awk '{print}'|wc -l`
    fi
done

dni=`echo -n "$dni" | tr " " "\n" | sort -u`
notas=""
echo \#dni notas
for i in $dni; do
    echo -n "$i "
    if ! echo "$i" | egrep -q "^[0-9]+[A-Z]$"; then
        err "bad dni $i"
    fi
    for j in $files; do
        if [ `cat "$j" | grep "$i" | awk '{print $2}'` ]; then
            notas=`cat "$j" | grep "$i" | awk '{print $2}'`" $notas"
        fi
    done
    notas=`echo "$notas"| tr " " "\n"| sed -E 's/\n$//g' | tr "." ","`
    echo "$notas" | awk -v cont=$n '{sum += $1; n++} END{if (cont==n) printf "%.1f\n", sum/cont; else printf "NP\n"}'
    #comrprobar si esta entre 0 y 10
    notas=""
done
# | awk '{cont += $2;n++} END{printf "%.1f\n", cont/n}'
exit 0
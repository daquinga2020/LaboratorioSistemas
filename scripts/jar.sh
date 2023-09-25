#/bin/sh

usage(){
    echo "usage: $0 classpath FILE.java [FILE.java]..." 1>&2
    exit 1
}

err() {
    echo 'error:' "$1" 1>&2
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

classpath=$(echo $1 | tr : "\n")
shift
dir=""
paths=""
for i in $classpath; do
    if [ -d $i ] || ([ -f $i ] && echo $i| egrep -q "^.*\.jar$"); then
        dir=$(realpath $i)
        paths="$paths$dir "
    else
        err "$i not a value param"
    fi
done

paths=$(echo "$paths" | tr " " "\n")

imports=""
sv_imports=""
files=""
for i in $@; do
    if ! [ -f "$i" ] && ! echo "$i"| egrep -q "^.*\.java$"; then
        err "$i not a value file"
    fi
    shift
    files="$i $files"
    imports=$(cat "$i" | tr ";" "\n" | egrep "^import [^java].+$" | sed -E 's/import (.*)/\1/g')
    sv_imports="$imports $sv_imports"
done

files=$(echo $files | tr ' ' "\n" | sort -u)
sv_imports=$(echo $sv_imports | tr ' ' "\n" | sort -u)

f_class=""
sv_files_class=""
for i in $paths; do
    for j in $sv_imports; do
        f_class="$(echo $j | tr . /)"
        f_class="$(echo $i/$f_class.class | tr " " "\n")"
        sv_files_class="$f_class $sv_files_class"
    done
done

jar=0
f_class=""
res_files=""
for i in $sv_imports; do
    res_files=$(fgrep -H $i $files | awk -F: '{print $1}' | tr '\n' , | sed -E 's/,$//g')
    pr=$(echo $i | awk -F. '{print $1}')
    echo -ne "$i\t$res_files\t"
    for j in $paths; do
        if echo $j| egrep -q "^.*\.jar$"; then
            if jar tvf $j| grep -q $(echo $i| tr . /); then
                echo $j
                jar=1
            fi
        elif ls $j | egrep -q "^.*\.jar$"; then
            if jar tvf $j/*.jar| grep -q $(echo $i| tr . /); then
                echo $j/*.jar
                jar=1
            fi
        fi
    done

    if [ $jar -eq 1 ]; then
        jar=0
        continue
    fi

    for j in $sv_files_class; do
        if [ -f "$j" ] && echo $j | fgrep -q "$pr"; then
            f_class="$j,$f_class"
        fi
    done

    if [ $f_class ]; then
        echo $f_class | sed -E 's/,$//g'
    else
        echo ??
    fi
    f_class=""
done


exit 0
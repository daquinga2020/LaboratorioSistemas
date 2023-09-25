#!/bin/sh

names=$(ls -l | egrep ^- | awk '{print $NF}')

for i in $names; do
	n=$(du -a $i | awk '{print $1}')
	ls -li $i | awk -v OFS='\t' -v second=$n '$2 ~ /^-/ {print $1, second" "$2, $3" "$4, $5, $6" "$7" "$8" "$9" ./"$10}'
done
exit 0

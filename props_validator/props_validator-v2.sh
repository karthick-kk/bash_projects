#!/bin/bash
#
files=`find . -type f -regextype sed -regex ".*/*/[^/]*.txt" -exec ls {} \;`

if [[ "$files" == "" ]]; then
	echo "No files detected"
fi

declare -a arr=(\
	"/.*\s:/p"\
       	"/.*=:/p"\
       	"/\s.*:/p"\
       	"/.*\s.*:/p"\
	"/.*['].*:/p"\
	"/.*[\[].*:/p"\
	"/.*[\]].*:/p"\
	"/.*[\@].*:/p"\
	"/.*[\~].*:/p"\
       	"/.*^[\s].*:/p")
err=false
for file in $files
do
	IFS=''
	i=0
cat $file | while read line
do
	((i=i+1))
	for cond in "${arr[@]}"
	do
	if [[ -n `echo $line|sed -rn "{$cond}"` ]]; then
		if [[ "$err" == "false" ]]; then
		echo "key error: $file: Line:$i -> $line"
		err=true
		fi
	fi
	done
	err=false
done
IFS=
done

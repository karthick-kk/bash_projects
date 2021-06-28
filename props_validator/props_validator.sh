#!/bin/bash
#
if [ "$1" == "" ]; then
	echo "FileInput NOT provided"
	exit 1
else
	if [ ! -f $1 ]; then
		echo "File $1 NOT found"
		exit 1
	fi
fi

declare -a arr=(\
	"/.*\s:/p"\
       	"/.*=:/p"\
       	"/.*\s=:/p"\
       	"/\s.*:/p"\
       	"/.*\s.*:/p"\
	"/.*['].*:/p"\
	"/.*[\[].*:/p"\
	"/.*[\]].*:/p"\
	"/.*[\@].*:/p"\
       	"/.*^[\s].*:/p")
err=false
IFS=''
cat $1 | while read line
do
	for cond in "${arr[@]}"
	do
	if [[ -n `echo $line|sed -rn "{$cond}"` ]]; then
		if [[ "$err" == "false" ]]; then
		echo "key error: $1 -> $line"
		err=true
		fi
	fi
	done
	err=false
done

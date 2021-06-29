#!/bin/bash
#
files=`find . -type f -regextype sed -regex ".*/*/[^/]*.txt" -exec ls {} \;`

if [[ "$files" == "" ]]; then
	echo "No files detected"
fi

declare -a arr=(\
	"/.*[=].*:/p|specialchar(=)"\
       	"/.*\s.*:/p|whitespace"\
	"/.*['].*:/p|specialchar(')"\
	"/.*[\[].*:/p|specialchar([)"\
	"/.*[\]].*:/p|specialchar(])"\
	"/.*[\@].*:/p|specialchar(@)"\
	"/.*[\~].*:/p|specialchar(~)"\
	"/.*[\!].*:/p|specialchar(!)")
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
		rex=`echo $cond|awk -F\| '{print $1}'`
		exp=`echo $cond|awk -F\| '{print $NF}'`
		if [[ -n `echo $line|sed -rn "{$rex}"` ]]; then
			echo "key error: File:$file: Line:$i Type:$exp -> $line"
		fi
	done
	err=false
done
IFS=
done

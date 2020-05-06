#!/bin/bash

srcdir=meta
dstdir=core-resources
find $srcdir -maxdepth 8 -type d -exec ls -d "{}" \; > /tmp/filelist

cat /tmp/filelist | while read entry
do
	file=`echo $entry|awk -F/ '{print $NF}'`
	target=`echo $entry|awk -v ddir=$dstdir '$1=ddir' FS=/ OFS=/`
	if [[ -f $entry/$file.json && -f $target/$file.json ]]
	then
#		echo "meta json found under $file"
		echo "Replacing $target/$file.json ..."
		cp $entry/$file.json $target/$file.json
	fi
done


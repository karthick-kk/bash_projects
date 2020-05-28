#!/bin/bash
srcdir=1
dstdir=2
find $srcdir -maxdepth 8 -type d -exec ls -d "{}" \; > /tmp/filelist

 

cat /tmp/filelist | while read entry
do
        file=`echo $entry|awk -F/ '{print $NF}'`
        target=`echo $entry|awk -v ddir=$dstdir '$1=ddir' FS=/ OFS=/`
        if [[ -f $entry/$file.json && -f $target/$file.json ]]
        then
#               echo "meta json found under $file"
		chk=`cat $target/$file.json| jq -r '.resource_type'|jq -e 'keys_unsorted as $keys | ($keys | length == 1) and .[($keys[0])] == []'|head -1`
		if [ "$chk" == "true" ]
		then
			echo "Replacing $target/$file.json ..."
        		jq 'del(.resource_type[])' $target/$file.json > "$target/$file"_tmp.json; mv "$target/$file"_tmp.json $target/$file.json
		fi
               # cp $entry/$file.json $target/$file.json
        fi
done

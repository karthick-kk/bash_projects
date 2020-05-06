#!/bin/bash
#
srcdir=$1
csvfile=$2
if [[ "$srcdir" == "" || "$csvfile" == "" ]]
then
	echo "missing required input"
	exit
fi

cat $csvfile|grep -v Template|while read line
do

tmpl=`echo $line|awk -F";" '{print $1}'`
class=`echo $line|awk -F";" '{print $2}'`
subclass=`echo $line|awk -F";" '{print $3}'`
restype=`echo $line|awk -F";" '{print $4}'`

#tmpl=AWS_Create_Lambda_Function_CFN
cd $srcdir
## Add new meta
jq '. += {resource_type: []}' $tmpl/$tmpl.json > "$tmpl/$tmpl"_tmp.json; mv "$tmpl/$tmpl"_tmp.json $tmpl/$tmpl.json
jq '. += {sub_classification: []}' $tmpl/$tmpl.json > "$tmpl/$tmpl"_tmp.json; mv "$tmpl/$tmpl"_tmp.json $tmpl/$tmpl.json
jq 'del(.classification[])' $tmpl/$tmpl.json > "$tmpl/$tmpl"_tmp.json; mv "$tmpl/$tmpl"_tmp.json $tmpl/$tmpl.json


## Update meta
jq --arg class $class '.classification[.classification| length] |= . + $class' $tmpl/$tmpl.json > "$tmpl/$tmpl"_tmp.json; mv "$tmpl/$tmpl"_tmp.json $tmpl/$tmpl.json

for var in $subclass
do
        jq --arg var $var '.sub_classification[.sub_classification| length] |= . + $var' $tmpl/$tmpl.json > "$tmpl/$tmpl"_tmp.json; mv "$tmpl/$tmpl"_tmp.json $tmpl/$tmpl.json
done

for var in $restype
do
        jq --arg var $var '.resource_type[.resource_type| length] |= . + $var' $tmpl/$tmpl.json > "$tmpl/$tmpl"_tmp.json; mv "$tmpl/$tmpl"_tmp.json $tmpl/$tmpl.json
done
restype=""

done

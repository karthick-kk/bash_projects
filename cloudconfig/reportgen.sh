#!/bin/bash -xe

mkdir -p json_out

# Sample values
#export RESOURCE_NAME="TBD"
#export RESOURCE_EMAIL="Channer.Dwight@mayo.edu"
#export RESOURCE_PROJECT="Mayo Mobile App"
#export RESOURCE_ORGANIZATION="Connected Care Mobile Unit"
#export RESOURCE_PAU="301-43541"

ser=0
cat PAU-Email.csv|tr -d '"' | while read line
do
ser=$((ser+1))

RESOURCE_NAME="TBD"
RESOURCE_EMAIL=`echo $line|awk -F, '{print $4}'`
RESOURCE_PROJECT=`echo $line|awk -F, '{print $1}'`
RESOURCE_ORGANIZATION=`echo $line|awk -F, '{print $2}'`
RESOURCE_PAU=`echo $line|awk -F, '{print $3}'`
export RESOURCE_NAME RESOURCE_EMAIL RESOURCE_PROJECT RESOURCE_ORGANIZATION RESOURCE_PAU 

tagdat="tags.Organization=='$RESOURCE_ORGANIZATION' and tags.PAU=='$RESOURCE_PAU' and tags.Billing Project=='$RESOURCE_PROJECT'"
tempdat="Org: $RESOURCE_ORGANIZATION | Billing Project: $RESOURCE_PROJECT | PAU: $RESOURCE_PAU"
export tagdat
export tempdat

if [[ -n RESOURCE_NAME && -n RESOURCE_EMAIL && -n RESOURCE_PROJECT && -n RESOURCE_ORGANIZATION && -n RESOURCE_PAU ]]
then
cat template.json | \
jq '.Name=env.RESOURCE_NAME' | \
jq '.Audience.Name=env.RESOURCE_ORGANIZATION' | \
jq '.Data=env.tagdat' | \
jq '.TEMP=env.tempdat' | \
jq '.Tags=[env.RESOURCE_NAME]' | \
jq '.Audience.Members=[env.RESOURCE_EMAIL]' \
> resource-changes.$$.json
fname=`echo ${RESOURCE_ORGANIZATION// /_}-${RESOURCE_PROJECT// /_}-${RESOURCE_PAU// /_}`
if [ -f resource-changes.$$.json ]
then
#mv resource-changes.$$.json json_out/$fname.json
mv resource-changes.$$.json json_out/resource-changes.$ser.json
fi
fi

done

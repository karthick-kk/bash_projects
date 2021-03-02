#!/bin/bash

## Source server user
user=osboxes
# Source Path
spath=/csplogs/csp/logs/tomcat
# Destination Path
dpath=/csplogs/csp/logs/tomcat/attAAPItmp

## List of servers
hosts="osboxes 10.0.2.15"

for host in $hosts
do
	ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no $user@$host exit 2>/dev/null
	if [ $? -eq 0 ]
	then
	echo "Copying logs from $host ..."
	ssh -o StrictHostKeyChecking=no $user@$host tar czf - $spath > $dpath/"$host"_logarchive_`date +"%d-%m-%Y"`.tgz
	fi
done

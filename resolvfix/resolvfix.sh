#!/bin/bash
file=/etc/resolv.conf
dnslistfile=dnslist
echo "Backing up file ..."
cp $file "$file".`date '+%Y%m%d'`
cat $file | awk '{print $NF}' | while read nsip
do
  ping -c 1 -w 2 $nsip > /dev/null
  if [ $? -ne 0 ]; then
  	echo "nameserver $nsip is down"
        sort -R $dnslistfile | grep -v $nsip > /tmp/wip
  	cat /tmp/wip | while read freeip
	do
		if [[ ! `grep $freeip $file` ]]; then
			ping -c 1 -w 2 $freeip > /dev/null
			if [ $? -eq 0 ]; then
			echo "Replacing $nsip with $freeip"
			sed -i "s/$nsip/$freeip/g" $file
			break
			fi
		fi 
	done
  else
  	echo "nameserver $nsip is alive"
  fi
done

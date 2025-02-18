#!/usr/bin/ksh
USER=`id | awk -F\( '{print $2}' | awk -F\) '{print $1}'`
#count=`ps -efo user,args | grep "$USER" | grep "consumer_roaming.pl"  | grep -v grep |grep -v "sh -c"|wc -l`
count=`ps -ef | grep "consumer_roaming.pl" | grep -v grep | wc -l`


if [ $count -gt 1 ]; then
echo "Process already running... "
exit 1
fi


##Cleanup activities##

echo "Starting Cleanup...."
archive_dir=./archive/archive_$(date +%Y%m%d%H%M%S)
#archive_dir=/var/portal/td_sampling/archive/archive_$(date +%Y%m%d%H%M%S)
mkdir $archive_dir

val=`ls -lrt ./roaming_logs/*.* | wc -l`

if [ $val -gt 0 ]; then
mv ./roaming_logs/*.* $archive_dir
fi


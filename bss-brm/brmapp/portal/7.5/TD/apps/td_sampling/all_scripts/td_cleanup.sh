#!/usr/bin/ksh
USER=`id | awk -F\( '{print $2}' | awk -F\) '{print $1}'`
#count=`ps -efo user,args | grep "$USER" | grep "sampling_control.pl"  | grep -v grep |grep -v "sh -c"|wc -l`
count=`ps -ef | grep "sampling_control.pl" | grep -v grep | wc -l`


if [ $count -gt 1 ]; then
echo "Process already running... "
exit 1
fi


##Cleanup activities##

echo "Starting Cleanup...."
archive_dir=./archive/archive_$(date +%Y%m%d%H%M%S)
#archive_dir=/var/portal/td_sampling/archive/archive_$(date +%Y%m%d%H%M%S)
mkdir $archive_dir

val=`ls -lrt ./scenario_logs/*.* | wc -l`

if [ $val -gt 0 ]; then
mv ./scenario_logs/*.* $archive_dir
fi

nval=`ls -lrt ./input_files/*.* | wc -l`

if [ $nval -gt 0 ]; then
mv ./input_files/*.* $archive_dir
fi


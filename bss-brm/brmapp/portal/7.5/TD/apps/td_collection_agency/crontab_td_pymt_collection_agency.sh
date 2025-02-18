#####################################################################
# Wrapper script to call the td_pymt_collection_agency 
# application td_pymt_collection_agency.pl
# from the cronrab environment
####################################################################

#!/bin/bash
cd $PIN_HOME
source $PIN_HOME/source.me.sh

#Name of the script
SCRIPT_NAME="crontab_td_pymt_collection_agency.sh"
echo "#################################################################"
echo "$SCRIPT_NAME started at "`date`
echo "#################################################################"
echo 

cd $PIN_HOME/TD/apps/td_collection_agency
echo "Current Working Directory: $PIN_HOME/TD/apps/td_collection_agency"
echo
# "Check if the script is already running"

USER=`id | awk -F\( '{print $2}' | awk -F\) '{print $1}'`
#count=`ps -efo user,args | grep "$USER" | grep "sampling_control.pl"  | grep -v grep |grep -v "sh -c"|wc -l`
count=`ps -ef | grep "$USER" | grep "td_pymt_collection_agency.pl" | grep -v grep | wc -l`


if [ $count -gt 1 ]; then
echo "Process already running... "
exit 1
fi

echo "#################################################################"
echo " Starting Process Execution: "
echo "#################################################################"

./td_pymt_collection_agency.pl -verbose

echo "End of td_pymt_collection_agency"
echo
echo "#################################################################"
echo "$SCRIPT_NAME finished at "`date`
echo "#################################################################"
echo

 

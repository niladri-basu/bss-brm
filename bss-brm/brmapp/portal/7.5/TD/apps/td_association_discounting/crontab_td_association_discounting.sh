#####################################################################
# Wrapper script to call the td_association_discounting 
# application crontab_td_association_discounting.sh
# from the crontab environment
####################################################################

#!/bin/bash
PIN_HOME=/brmapp/portal/7.5
cd $PIN_HOME
source $PIN_HOME/source.me.sh

#Name of the script
SCRIPT_NAME="crontab_td_association_discounting.sh"
echo "#################################################################"
echo "$SCRIPT_NAME started at "`date`
echo "#################################################################"
echo 


cd $PIN_HOME/TD/apps/td_association_discounting
echo "Current Working Directory: $PIN_HOME/TD/apps/td_association_discounting"

# "Check if the script is already running"

USER=`id | awk -F\( '{print $2}' | awk -F\) '{print $1}'`
#count=`ps -efo user,args | grep "$USER" | grep "sampling_control.pl"  | grep -v grep |grep -v "sh -c"|wc -l`
count=`ps -ef | grep "$USER" | grep "td_association_discounting.sh" | grep -v grep | wc -l`


if [ $count -gt 1 ]; then
echo "Process already running... "
exit 1
fi

echo "#################################################################"
echo " Starting Process Execution: "
echo "#################################################################"

echo "./td_association_discounting `date +"%e"`"
#./td_association_discounting $1


echo " End of processing of the script"
echo
echo "#################################################################"
echo "$SCRIPT_NAME finished at "`date`
echo "#################################################################"
echo

 

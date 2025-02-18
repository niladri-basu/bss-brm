#####################################################################
# Wrapper script to call the payment processing mta 
# application td_payment_processing_mta
# from the cronrab environment
####################################################################

#!/bin/bash
PIN_HOME=/brmapp/portal/7.5
cd $PIN_HOME
source $PIN_HOME/source.me.sh
source /home/pin/.bash_profile
#Name of the script
SCRIPT_NAME="crontab_td_payment_processing.sh"
#echo "script started"
echo "#################################################################" >> crontab_td_payment_processing.log
echo "$SCRIPT_NAME started at "`date` >> crontab_td_payment_processing.log
echo "#################################################################" >> crontab_td_payment_processing.log
echo 
USER=`id | awk -F\( '{print $2}' | awk -F\) '{print $1}'`
count=`ps -ef | grep "$USER" | grep "td_payment_processing_mta" | grep -v grep | wc -l`
echo $count 
if [ $count -gt 2 ]; then
echo "Process already running... "
exit 1
fi

echo "#################################################################" >> crontab_td_payment_processing.log
echo "$SCRIPT_NAME started at "`date`  >> crontab_td_payment_processing.log
echo "#################################################################" >> crontab_td_payment_processing.log
echo

echo "#################################################################"
echo "$SCRIPT_NAME started at "`date` >> crontab_td_payment_processing.log
echo "#################################################################"
echo 

cd $PIN_HOME/TD/apps/td_payment_processing
echo "I am at $PIN_HOME/TD/apps/td_payment_processing"

####################################################################
# Execute the paymnet processing mta executable from here
####################################################################
./td_payment_processing_mta -verbose  >> crontab_td_payment_processing.log

echo "End of payment processing mta" >> crontab_td_payment_processing.log
echo
echo "#################################################################" >> crontab_td_payment_processing.log
echo "$SCRIPT_NAME finished at "`date` >> crontab_td_payment_processing.log
echo "#################################################################" >> crontab_td_payment_processing.log
echo

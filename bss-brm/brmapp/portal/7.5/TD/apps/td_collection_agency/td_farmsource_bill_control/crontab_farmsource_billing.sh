#####################################################################
# Wrapper script to call the billing_file_control
# application farmsource_billing.pl
# from the crontab environment
####################################################################

#!/bin/bash
PIN_HOME=/brmapp/portal/7.5
cd $PIN_HOME
source $PIN_HOME/source.me.sh
source /home/pin/.bash_profile
echo "input is"
echo $2
#Name of the script
SCRIPT_NAME="td_fs_billing_crontab.sh"
USER=`id | awk -F\( '{print $2}' | awk -F\) '{print $1}'`
count=`ps -ef | grep "$USER" | grep "crontab_farmsource_billing.sh" | grep -v grep | wc -l`
if [ $count -gt 2 ]; then
echo "Process already running... "
exit 1
fi
echo "#################################################################"
echo "$SCRIPT_NAME started at "`date`  >> /brmapp/portal/7.5/TD/apps/td_farmsource_bill_control/td_fs_bill_control_crontab.log
echo "#################################################################"
echo

cd $PIN_HOME/TD/apps/td_farmsource_bill_control
echo "I am at $PIN_HOME/TD/apps/td_farmsource_bill_control"

####################################################################
# Execute the billing_file_control scripts
####################################################################
#./billing_file_control.pl  >> /brmapp/portal/7.5/TD/apps/td_farmsource_billing/td_fs_billing_crontab.log

if [ "$#" -eq  "0" ]
   then
     ./billing_file_control.pl  >> /brmapp/portal/7.5/TD/apps/td_farmsource_bill_control/td_fs_bill_control_crontab.log
 else
     ./billing_file_control.pl -i $2  >> /brmapp/portal/7.5/TD/apps/td_farmsource_bill_control/td_fs_bill_control_crontab.log
fi

echo "End of farmsource_billing_control"
echo
echo "#################################################################"
echo "$SCRIPT_NAME finished at "`date`
echo "#################################################################"
echo


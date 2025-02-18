#####################################################################
# Wrapper script to call the td_pre_bill_process.pl
# application 
# from the crontab environment
####################################################################

#!/bin/bash
PIN_HOME=/brmapp/portal/7.5
cd $PIN_HOME
source $PIN_HOME/source.me.sh
source /home/pin/.bash_profile

#Name of the script
SCRIPT_NAME="td_pre_bill_process.pl"
DATE=`date +"%Y%m%d"`
echo "#################################################################"
echo "$SCRIPT_NAME started at "`date` >> /brmapp/portal/7.5/TD/apps/td_prebill_process/crontab_td_pre_bill_process.log
echo "#################################################################"
echo

cd $PIN_HOME/TD/apps/td_prebill_process
echo "I am at $PIN_HOME/TD/apps/td_prebill_process"

####################################################################
# Execute pin_collections_process from here
####################################################################
perl ./td_pre_bill_process.pl -d $DATE >> /brmapp/portal/7.5/TD/apps/td_prebill_process/crontab_td_pre_bill_process.log

echo "End of td_pre_bill_process.pl"
echo
echo "#################################################################"
echo "$SCRIPT_NAME finished at "`date` >> /brmapp/portal/7.5/TD/apps/td_prebill_process/crontab_td_pre_bill_process.log
echo "#################################################################"
echo


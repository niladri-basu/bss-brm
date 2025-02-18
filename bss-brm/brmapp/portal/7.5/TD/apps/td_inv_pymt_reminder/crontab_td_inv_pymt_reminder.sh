#####################################################################
# Wrapper script to call the invoice payment reminder mta 
# application td_inv_pymt_reminder_mta
# from the cronrab environment
####################################################################

#!/bin/bash
PIN_HOME=/brmapp/portal/7.5
cd $PIN_HOME
source $PIN_HOME/source.me.sh
source /home/pin/.bash_profile
#Name of the script
SCRIPT_NAME="crontab_td_inv_pymt_reminder.sh"
echo "#################################################################"
echo "$SCRIPT_NAME started at "`date`
echo "#################################################################"
echo 

cd $PIN_HOME/TD/apps/td_inv_pymt_reminder
echo "I am at $PIN_HOME/TD/apps/td_inv_pymt_reminder"

####################################################################
# Execute the invoice paymnet reminder mta executable from here
####################################################################
./td_inv_pymt_reminder.pl >> /brmapp/portal/7.5/TD/apps/td_inv_pymt_reminder/td_inv_reminder_crontab.log

echo "End of Invoice payment reminder mta"
echo
echo "#################################################################"
echo "$SCRIPT_NAME finished at "`date`
echo "#################################################################"
echo

 

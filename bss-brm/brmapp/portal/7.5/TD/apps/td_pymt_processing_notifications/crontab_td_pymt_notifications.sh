#####################################################################
# Wrapper script to call the payment processing mta 
# application td_payment_processing_mta
# from the cronrab environment
####################################################################

#!/bin/bash
PIN_HOME=/brmapp/portal/7.5
cd $PIN_HOME
source $PIN_HOME/source.me.sh

#Name of the script
SCRIPT_NAME="crontab_td_payment_processing.sh"
echo "#################################################################"
echo "$SCRIPT_NAME started at "`date`
echo "#################################################################"
echo 

cd $PIN_HOME/TD/apps/td_pymt_processing_notifications
echo "I am at $PIN_HOME/TD/apps/td_pymt_processing_notifications"

####################################################################
# Execute the paymnet processing mta executable from here
####################################################################
./td_pymt_processing_notifications_mta -verbose

echo "End of payment processing mta"
echo
echo "#################################################################"
echo "$SCRIPT_NAME finished at "`date`
echo "#################################################################"
echo

 

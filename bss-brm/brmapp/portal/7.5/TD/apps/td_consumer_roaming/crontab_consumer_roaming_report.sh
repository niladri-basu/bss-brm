#####################################################################
# Wrapper script to call the consumer roaming
# application consumer_roaming.pl
# from the crontab environment
####################################################################

#!/bin/bash
PIN_HOME=/brmapp/portal/7.5
cd $PIN_HOME
source $PIN_HOME/source.me.sh
source /home/pin/.bash_profile

#Name of the script
SCRIPT_NAME="td_consumer_roaming_crontab.sh"
echo "#################################################################"
echo "$SCRIPT_NAME started at "`date`  >> /brmapp/portal/7.5/TD/apps/td_consumer_roaming/td_consumer_roaming_crontab.log
echo "#################################################################"
echo

cd $PIN_HOME/TD/apps/td_consumer_roaming
echo "I am at $PIN_HOME/TD/apps/td_consumer_roaming"

####################################################################
# Execute the consumer_roaming scripts
####################################################################
#./consumer_roaming.pl  >> /brmapp/portal/7.5/TD/apps/td_consumer_roaming/td_consumer_roaming_crontab.log

if [ "$#" -eq  "0" ]
   then
     ./consumer_roaming.pl  >> /brmapp/portal/7.5/TD/apps/td_consumer_roaming/td_consumer_roaming_crontab.log
 else
     ./consumer_roaming.pl -i $1  >> /brmapp/portal/7.5/TD/apps/td_consumer_roaming/td_consumer_roaming_crontab.log
fi

echo "End of consumer_roaming"
echo
echo "#################################################################"
echo "$SCRIPT_NAME finished at "`date`
echo "#################################################################"
echo


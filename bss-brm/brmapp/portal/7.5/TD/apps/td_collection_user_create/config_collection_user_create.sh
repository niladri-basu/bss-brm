#####################################################################
####################################################################

#!/bin/bash
PIN_HOME=/brmapp/portal/7.5
cd $PIN_HOME
source $PIN_HOME/source.me.sh

#Name of the script
SCRIPT_NAME="config_collection_user_create.sh"
echo "#################################################################"
echo "$SCRIPT_NAME started at "`date`
echo "#################################################################"
echo

cd $PIN_HOME/TD/apps/td_collection_user_create
echo "I am at $PIN_HOME/TD/apps/td_collection_user_create:"
echo "#################################################################"
./td_collection_user_create.pl

echo "#################################################################"
echo "End of collection_user_create"
echo
echo "#################################################################"
echo "$SCRIPT_NAME finished at "`date`
echo "#################################################################"
echo


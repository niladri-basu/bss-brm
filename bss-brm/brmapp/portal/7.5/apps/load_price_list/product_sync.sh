#!/bin/bash
#--------------------------------------------------------------------------------------------------------
# Ankit.Chakraborty@techmahindra.com
# Date: 09/07/2018
# Description: This is a wapper script to extract the pricelist package and load the pricing data in BRM.
#--------------------------------------------------------------------------------------------------------

PACKAGE_NAME="price_list_20_plan.tar"
PRE_SUF="20Plan*.xml"
NWLINE="\n------------------------------------------------------------\n"

echo -e "$NWLINE Unzipping the package $NWLINE"
tar -xvf $PACKAGE_NAME
sleep 3

echo -e "$NWLINE Executing loadpricelist utility"

echo -e "$NWLINE Loading the product : \$20 Plan"
loadpricelist -v -f -d -c 20Plan.xml
sleep 3

echo -e "$NWLINE Loading the product : \$20 Plan Voice"
loadpricelist -v -f -d -c 20PlanVoice.xml
sleep 3

echo -e "$NWLINE Loading the product : \$20 Plan Data"
loadpricelist -v -f -d -c 20PlanData.xml
sleep 3

echo -e "$NWLINE loadpricelist execution is completed !"

#rm $PRE_SUF


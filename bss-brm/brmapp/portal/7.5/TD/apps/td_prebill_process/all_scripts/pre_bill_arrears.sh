#!/usr/bin/ksh

TEMPFILE1=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_create.log/'`
TEMPFILE2=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/stg_create.log/'`
TEMPFILE3=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/report_create.log/'`


if [ "$1" -lt "1" ]
  then echo "Incorrect Execution: Execute as pre_bill_arrears.sh DOM"
  exit
fi

bill_dom=$1
bill_next=$2


echo "Starting pre-billing manual calculation execution at: "
date

#### Starting IOT creation ####

echo "Starting iot_create.sh at: "
date
sh ./all_scripts/iot_create.sh

        IS_ERROR=`grep ORA- ${TEMPFILE1}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE1}
                        exit 0
                fi
echo "Completed iot_create.sh at: "
date



#### Starting staging table creation ####

echo "Starting stg_create.sh at: "
date
sh ./all_scripts/stg_create.sh $bill_dom $bill_next

        IS_ERROR=`grep ORA- ${TEMPFILE2}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE2}
                        exit 0
                fi
echo "Completed stg_create.sh at: "
date



#### Starting Report table creation ####

echo "Starting report_create.sh at: "
date
sh ./all_scripts/report_create.sh 

        IS_ERROR=`grep ORA- ${TEMPFILE3}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE3}
                        exit 0
                fi
echo "Completed report_create.sh at: "
date

#!/usr/bin/ksh

TEMPFILE1=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_create.log/'`
TEMPFILE2=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/stg_create.log/'`
TEMPFILE3=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/report_create.log/'`



bill_dom=$1
bill_next=$2


echo "Starting pre-billing manual calculation execution at: "
date

#### Starting IOT creation ####

echo "Starting ac_iot_create.sh at: "
date
sh ./all_scripts/ac_iot_create.sh

        IS_ERROR=`grep ORA- ${TEMPFILE1}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE1}
                        exit 0
                fi
echo "Completed ac_iot_create.sh at: "
date



#### Starting staging table creation ####

echo "Starting ac_stg_create.sh at: "
date
sh ./all_scripts/ac_stg_create.sh 

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

echo "Starting ac_report_create.sh at: "
date
sh ./all_scripts/ac_report_create.sh 

        IS_ERROR=`grep ORA- ${TEMPFILE3}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE3}
                        exit 0
                fi
echo "Completed ac_report_create.sh at: "
date

#!/usr/bin/ksh

#=============================================================
# Author : Rakesh Nair
# Date   : 1-Jan-2015
# Descr  : Script to generate unbilled GL report generation
# Exec   : td_get_unbilled_revenue_report.sh YYYYMMDs YYYYMMDDe:
#          where YYYYMMDDs should correspond to billing start date
#          and YYYYMMDDe corresponds to billing end date
#          Eg: td_get_unbilled_revenue_report.sh 20150201 20150301
#=============================================================


LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
DST_VAL=`egrep -v "#" login.cfg | grep "DST_VALUE" |cut -d'=' -f2`
#TEMPFILE1=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_unbilled_create.log/'`
TEMPFILE2=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/td_unbilled_gl_proc.log/'`
TEMPFILE3=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/td_bip_entry.log/'`

if [ "$1" -lt "1" ]
  then echo "Incorrect Execution: Execute as td_get_unbilled_revenue_report.sh YYYYMMDD"
  exit
fi

bill_start_date=$1
bill_end_date=$2

end_timestamp=`$ORACLE_HOME/bin/sqlplus -s $LOGINSQL<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200

set serveroutput on size 2000
select td_nz_to_unix(to_date('$bill_end_date','YYYYMMDD'))-$DST_VAL td from dual;
exit;
EOF`

start_timestamp=`$ORACLE_HOME/bin/sqlplus -s $LOGINSQL<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200

set serveroutput on size 2000
select td_nz_to_unix(to_date('$bill_start_date','YYYYMMDD'))-$DST_VAL td from dual;
exit;
EOF`


echo "Starting timestamp for $bill_start_date is $start_timestamp"
echo "Ending timestamp for $bill_end_date is $end_timestamp"

yy=${bill_start_date:2:2}
mm=${bill_start_date:4:2}
dd=${bill_start_date:6:2}

yye=${bill_end_date:2:2}
mme=${bill_end_date:4:2}
dde=${bill_end_date:6:2}

#### Starting unbilled GL report generation ####

echo "Starting Unbilled GL report generation starting from $bill_start_date to $bill_end_date: "
date

echo "pin_ledger_report -mode run_report -start $mm/$dd/$yy -end $mme/$dde/$yye -type billed -detail -verbose"
pin_ledger_report -mode run_report -start $mm/$dd/$yy  -end $mme/$dde/$yye -type billed -detail -verbose

echo "pin_ledger_report -mode run_report -start $mm/$dd/$yy -end $mme/$dde/$yye -type unbilled_earned -detail -verbose"
pin_ledger_report -mode run_report -start $mm/$dd/$yy -end $mme/$dde/$yye -type unbilled_earned -detail -verbose

echo "pin_ledger_report -mode run_report -start $mm/$dd/$yy -end $mme/$dde/$yye -type unbilled_unearned -detail -verbose"
pin_ledger_report -mode run_report -start $mm/$dd/$yy -end $mme/$dde/$yye -type unbilled_unearned -detail -verbose

echo "Completed Unbilled GL report generation at: "
date



echo "Starting td_unbilled_gl_proc.sh at: "
date 
sh ./all_scripts/td_unbilled_gl_proc.sh $start_timestamp $end_timestamp $DST_VAL

        IS_ERROR=`grep ORA- ${TEMPFILE2}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE2}
                        exit 0
                fi
echo "Completed td_unbilled_gl_proc.sh at: "
date


echo "Starting td_trigger_bip_report.sh at: "
date
sh ./all_scripts/td_trigger_bip_report.sh GL_Report_Unbilled $bill_end_date


        IS_ERROR=`grep ORA- ${TEMPFILE3}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${TEMPFILE3}
                        exit 0
                fi
echo "Completed td_trigger_bip_report.sh at: "
date













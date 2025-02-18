#!/bin/sh

#=====================================================================
# Author : Rakesh Nair
# Date   : 1-Jan-2015
# Descr  : Script to generate pre-bill check/pre-bill reports from BIP
# Exec	 : td_prebill_report.sh YYYYMMDD: 
#	   where YYYYMMDD should correspond to billing DOM
#	   Eg: td_prebill_report.sh 20150101
#======================================================================


LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
BIPLOGINSQL=`egrep -v "#" login.cfg | grep "BIP_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/pre_bill_logs.log/'`


echo "Login : " $LOGINSQL
echo "BIP Login: " $BIPLOGINSQL
echo "outfile value: " $outfile


if [ "$1" -lt "1" ]
  then echo "Incorrect Execution: Execute as td_prebill_report.sh YYYYMMDD"
  exit
fi

bill_date=$1

timestamp=`$ORACLE_HOME/bin/sqlplus -s $LOGINSQL<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200

set serveroutput on size 2000
select td_nz_to_unix(to_date('$bill_date','YYYYMMDD')) td from dual;
exit;
EOF`

echo "timestamp value: " $timestamp


echo "Starting pre_bill_arrears.sh for bill date $bill_date at"
date
`./all_scripts/pre_bill_arrears.sh $bill_date $timestamp > $outfile`

IS_ERROR=`grep ORA- ${outfile}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${outfile}
                        exit 0
                fi

echo "Completed pre_bill_arrears.sh for bill date $bill_date at"
date


#free_space=`df -k | awk '(NF<5){f=$1; next} (NF>5){f=$1} {print f, $2, $3, $NF}' | sed -e 's/\s\+/,/g'`
free_space=0


$ORACLE_HOME/bin/sqlplus -s $BIPLOGINSQL>$outfile<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200
set serveroutput on size 2000

insert into BIP_BRM_REPORT values (sysdate, 'Server_Space_Report', '$free_space', 'N');
commit;

exit;
EOF

IS_ERROR=`grep ORA- ${outfile}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${outfile}
                        exit 0
                fi

$ORACLE_HOME/bin/sqlplus -s $BIPLOGINSQL>$outfile<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200
set serveroutput on size 2000

insert into BIP_BRM_REPORT values (sysdate, 'Missing Payment Term Report', '$timestamp', 'N');
insert into BIP_BRM_REPORT values (sysdate, 'Missing Billing EMail Report', '$timestamp', 'N');
insert into BIP_BRM_REPORT values (sysdate, 'Error CDR Report', '$timestamp', 'N');
insert into BIP_BRM_REPORT values (sysdate, 'Prebill Report', '$timestamp', 'N');
insert into BIP_BRM_REPORT values (sysdate, 'Prebill Rental Report', '$timestamp', 'N');
commit;

exit;
EOF

IS_ERROR=`grep ORA- ${outfile}|wc -l`
                if [ $IS_ERROR -gt 0 ];
                        then
                        echo "ORACLE ERROR"
                        cat ${outfile}
                        exit 0
                fi



echo "Pre-bill Report Generation Process completed at: " `date`


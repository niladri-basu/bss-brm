#!/usr/bin/ksh

#=====================================================================
# Author : Rakesh Nair
# Date   : 1-Jan-2015
# Descr  : Script to generate post-bill reports from BIP
# Exec	 : td_postbill_report.sh YYYYMMDD: 
#	   where YYYYMMDD should correspond to billing DOM
#	   Eg: td_postbill_report.sh 20150101
#======================================================================


LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
BIPLOGINSQL=`egrep -v "#" login.cfg | grep "BIP_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/post_bill_logs.log/'`
DST_VAL=`egrep -v "#" login.cfg | grep "DST_VALUE" |cut -d'=' -f2`


if [ "$1" -lt "1" ]
  then echo "Incorrect Execution: Execute as td_postbill_report.sh YYYYMMDD"
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


$ORACLE_HOME/bin/sqlplus -s $BIPLOGINSQL>$outfile<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200
set serveroutput on size 2000

insert into BIP_BRM_REPORT values (sysdate, 'Postbill Report', '$timestamp', 'N');
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



echo "Post-bill Report Generation Process completed at: " `date`


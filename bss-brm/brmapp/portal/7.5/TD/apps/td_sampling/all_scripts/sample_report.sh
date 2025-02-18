#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/Sample_Report.csv/'`
sqlplus -s $LOGINSQL <<EOF > $outfile
set heading off
set serveroutput off
set feedback 0
SET WRAP ON
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
set verify off
set auto off
set termout off
select distinct billinfo_obj_id0||','||scenario_no from td_sampled_accounts_t;
clear buffer
EXIT
EOF

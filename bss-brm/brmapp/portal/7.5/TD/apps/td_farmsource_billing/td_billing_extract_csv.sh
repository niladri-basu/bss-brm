#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile='/brmapp/portal/7.5/TD/apps/td_farmsource_billing/fs_logs/fs_billing_create.log'
actg_dom=$1;
#csvfile='/brmapp/portal/7.5/TD/apps/td_farmsource_billing/farmsource.csv' 
csvpath='/brmapp/portal/7.5/TD/apps/td_farmsource_billing/csv'
filename='2DegreesMobileLtd'$actg_dom'_payment'.csv
csvfile=$csvpath/$filename
dbfailure=$log_dir/$dbfailure$now.txt

$ORACLE_HOME/bin/sqlplus -s $LOGINSQL>$csvfile<<EOF
SET WRAP off
set heading off;
set feedback off;
set linesize 150;
set trimout ON;
set trimspool ON;
set serveroutput off;
SET PAGESIZE 0;
SET COLSEP ","

SELECT 
	   ACCOUNT_NO || ',' ||
       INVOICE_NO || ',' ||
       sum(TOTAL_AMT_INCL_GST)
FROM   TD_FS_BILLING_FILE_EXT_T
GROUP BY ACCOUNT_NO,INVOICE_NO;
clear buffer
EXIT
EOF

awk 'NF { $1=$1; }' $csvfile
echo "CSV Generation completed "
exit;
EOF

#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
LOG_DIR=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
now=`date +'%Y%m%d%H'`
target_dir=`egrep -v "#" login.cfg | grep "FETCH_PAY_EVENT_OUT_DIR" |cut -d'=' -f2`
log_dir=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
#$OUT_DIR/BRM_NON0_EVENT_EXPORT-$date_run-$now.txt
filename="payments"
dbfailure="db_failure"
outfile=$target_dir/$filename$now.txt
dbfailure=$log_dir/$dbfailure$now.txt

echo "exit" | sqlplus -L $LOGINSQL | grep Connected >> $LOG_DIR/td_fetch_gl_details_extract.log
if [ $? -eq 0 ]
then
   echo "DB Connected is OK at time "$now >> $LOG_DIR/td_fetch_gl_details_extract.log
   
else
	echo "Not Connected due to DB connection failure at time "$now >>$dbfailure
	exit 1
   
fi
#echo "Now executing event fetch" 

records=$($ORACLE_HOME/bin/sqlplus -s $LOGINSQL>>$outfile<<EOF
set heading OFF
set serveroutput off
set feedback 30000
SET LINESIZE 300
SET WRAP OFF
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS OFF VERIFY OFF;
set verify off
set auto off
set termout off
spool $outfile 
select 
  ET.ACCOUNT_OBJ_ID0 ||'*'||
	TO_CHAR(PIN.td_unix_to_nz(ET.CREATED_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||
	ET.DESCR ||'*'||
	TO_CHAR(PIN.td_unix_to_nz(ET.END_T),'DD-MM-YYYY HH24:MI:SS')||'*'||
	ET.EVENT_NO ||'*'||
	ET.ITEM_OBJ_ID0 ||'*'||
	TO_CHAR(PIN.td_unix_to_nz(ET.MOD_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||
	ET.NET_QUANTITY ||'*'||
	ET.POID_ID0 ||'*'||
	ET.POID_TYPE ||'*'||
	ET.SERVICE_OBJ_TYPE ||'*'||
	TO_CHAR(PIN.td_unix_to_nz(ET.START_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||
	BAL.AMOUNT||'*'||
	BAL.GL_ID||'*'||
	BAL.IMPACT_TYPE||'*'||
	BAL.OFFERING_OBJ_ID0 ||'*'||
	BAL.PRODUCT_OBJ_ID0 ||'*'||
	BAL.QUANTITY ||'*'||
	BAL.RESOURCE_ID ||'*'||
	BAL.TAX_CODE||'*'||
	BAL.REC_ID ||'*'||
	IT.AR_BILLINFO_OBJ_ID0||'*'||
	IT.BILLINFO_OBJ_ID0||'*'||
	IT.AR_BILL_OBJ_ID0||'*'||
	IT.BILL_OBJ_ID0 data_records
from 
  PIN.EVENT_T ET,
  PIN.EVENT_BAL_IMPACTS_T BAL,
  PIN.ITEM_T IT,
  pin.account_nameinfo_t an
where
    ET.POID_ID0 >=(select TO_NUMBER(TO_CHAR((TO_DATE(TRUNC(sysdate)-1) - TO_DATE('1-Jan-1970') )*power(2,44)) ) from DUAL) 
and ET.POID_ID0 < (select TO_NUMBER(TO_CHAR((TO_DATE(TRUNC(sysdate)) - TO_DATE('1-Jan-1970') )*power(2,44)) ) from DUAL)
and ET.POID_ID0 = BAL.OBJ_ID0
and BAL.AMOUNT != 0
and IT.POID_ID0 = BAL.ITEM_OBJ_ID0
and BAL.RESOURCE_ID = '554'
and ET.account_obj_id0 = an.obj_id0
and AN.REC_ID = '1'
and substr(an.company,1,11) != 'TestAccount';
clear buffer
spool off
EXIT
EOF)

#echo $records > $outfile

records1=$($ORACLE_HOME/bin/sqlplus -s $LOGINSQL<<EOF
set heading OFF
set serveroutput off
set feedback 30000
SET LINESIZE 20
SET WRAP OFF
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS OFF VERIFY OFF;
set verify off
set auto off
set termout off
select sum(bal.amount) as SUM_AMOUNT
from 
  PIN.EVENT_T ET,
  PIN.EVENT_BAL_IMPACTS_T BAL,
  PIN.ITEM_T IT,
  pin.account_nameinfo_t an
where
    ET.POID_ID0 >=(select TO_NUMBER(TO_CHAR((TO_DATE(TRUNC(sysdate)-1) - TO_DATE('1-Jan-1970') )*power(2,44)) ) from DUAL) 
and ET.POID_ID0 < (select TO_NUMBER(TO_CHAR((TO_DATE(TRUNC(sysdate)) - TO_DATE('1-Jan-1970') )*power(2,44)) ) from DUAL)
and ET.POID_ID0 = BAL.OBJ_ID0
and BAL.AMOUNT != 0
and IT.POID_ID0 = BAL.ITEM_OBJ_ID0
and BAL.RESOURCE_ID = '554'
and ET.account_obj_id0 = an.obj_id0
and AN.REC_ID = '1'
and substr(an.company,1,11) != 'TestAccount';
clear buffer
EXIT
EOF)

amount_total="Amount_sum*"$records1
echo $amount_total | sed  s/\ //g>>$outfile
#echo "Amount_sum*"$records1>>$outfile


exit 0
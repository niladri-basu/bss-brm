#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
LOG_DIR=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
#now=`date +'%Y%m%d`
now=`date -d yesterday +'%Y%m%d'`
target_dir=`egrep -v "#" login.cfg | grep "FETCH_PAY_EVENT_OUT_DIR" |cut -d'=' -f2`
pay_poid_type=`egrep -v "#" login.cfg | grep "pay_poid_type" |cut -d'=' -f2`
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

#records=$($ORACLE_HOME/bin/sqlplus -s $LOGINSQL>>$outfile<<EOF
sqlplus -s $LOGINSQL <<EOF > $outfile
set heading OFF
#SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS OFF VERIFY OFF;
set pagesize 0
SET LINESIZE 900
SET WRAP OFF
set trimspool ON
select 
  ET.ACCOUNT_OBJ_ID0 ||'*'||
	TO_CHAR(PIN.td_unix_to_nz(ET.CREATED_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||
	null ||'*'||
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
	case when BAL.GL_ID = 109
                 then 990209000
              ELSE BAL.GL_ID END||'*'||    
	BAL.IMPACT_TYPE||'*'||
	BAL.OFFERING_OBJ_ID0 ||'*'||
	BAL.PRODUCT_OBJ_ID0 ||'*'||
	BAL.QUANTITY ||'*'||
	BAL.RESOURCE_ID ||'*'||
	case when ET.POID_TYPE like '/event/billing/payment/%' then 'NILGST' else BAL.TAX_CODE end||'*'||
	BAL.REC_ID ||'*'||
	IT.AR_BILLINFO_OBJ_ID0||'*'||
	IT.BILLINFO_OBJ_ID0||'*'||
	IT.AR_BILL_OBJ_ID0||'*'||
	IT.BILL_OBJ_ID0||'*'||
	ET.PROGRAM_NAME||'*'||
	EBP.CHANNEL_ID
from 
  PIN.EVENT_T ET,
  PIN.EVENT_BAL_IMPACTS_T BAL,
  PIN.ITEM_T IT,
  PIN.EVENT_BILLING_PAYMENT_T EBP,
  pin.account_nameinfo_t an
where
    ET.POID_ID0 >=(select TO_NUMBER(TO_CHAR((TO_DATE(TRUNC(sysdate)-1) - TO_DATE('1-Jan-1970') )*power(2,44)) ) from DUAL) 
and ET.POID_ID0 < (select TO_NUMBER(TO_CHAR((TO_DATE(TRUNC(sysdate)) - TO_DATE('1-Jan-1970') )*power(2,44)) ) from DUAL)
and ET.POID_ID0 = BAL.OBJ_ID0
and BAL.AMOUNT != 0
and ET.POID_TYPE in $pay_poid_type
and IT.POID_ID0 = BAL.ITEM_OBJ_ID0
and EBP.OBJ_ID0 = BAL.OBJ_ID0
and BAL.RESOURCE_ID = '554'
and ET.account_obj_id0 = an.obj_id0
and AN.REC_ID = '1'
and substr(nvl(an.company,'0'),1,11) != 'TestAccount';
clear buffer
exit;
EOF

#echo $records > $outfile

records1=$($ORACLE_HOME/bin/sqlplus -s $LOGINSQL<<EOF
set heading OFF
set serveroutput off
set feedback 30000
SET LINESIZE 200
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
and ET.POID_TYPE in $pay_poid_type
and IT.POID_ID0 = BAL.ITEM_OBJ_ID0
and BAL.RESOURCE_ID = '554'
and ET.account_obj_id0 = an.obj_id0
and AN.REC_ID = '1'
and substr(nvl(an.company,'0'),1,11) != 'TestAccount';
EXIT
EOF)

amount_total="Amount_sum*"$records1
echo $amount_total | sed  s/\ //g>>$outfile
#echo "Amount_sum*"$records1>>$outfile


exit 0

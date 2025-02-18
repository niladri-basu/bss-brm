#!/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
LOG_DIR=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
now=`date +'%Y%m%d%H'`
target_dir=`egrep -v "#" login.cfg | grep "FETCH_PRODUCT_OUT_DIR" |cut -d'=' -f2`
log_dir=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
#$OUT_DIR/BRM_NON0_EVENT_EXPORT-$date_run-$now.txt
filename="Product_extract"
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
select a.ACCOUNT_NO||'*'||b.BILL_INFO_ID||'*'||b.ACTG_CYCLE_DOM||'*'||st.NAME||'*'||p.NAME ||'*'||
CASE  WHEN pp.cycle_fee_flags >1024 THEN pp.cycle_fee_amt
      WHEN rb.scaled_amount = 0 THEN pp.cycle_fee_amt 
      WHEN pp.cycle_fee_amt = 0 THEN rb.scaled_amount
      else pp.cycle_fee_amt end||'*'|| TO_CHAR(td_unix_to_nz(pp.CYCLE_START_T),'DD-MM-YYYY HH24:MI:SS')||'*'||pp.STATUS ||'*'||TO_CHAR(td_unix_to_nz(pp.CYCLE_END_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||TO_CHAR(td_unix_to_nz(b.LAST_BILL_T),'DD-MM-YYYY HH24:MI:SS')||'*'||TO_CHAR(td_unix_to_nz(b.NEXT_BILL_T) ,'DD-MM-YYYY HH24:MI:SS')||'*'||rb.GL_ID||'*'||a.POID_ID0||'*'||b.POID_ID0 ||'*'||pp.POID_ID0 ||'*'||s.POID_ID0 ||'*'||p.POID_ID0 ||'*'||pp.NODE_LOCATION
from 
PIN.ACCOUNT_T a,PIN.SERVICE_ALIAS_LIST_T st,PIN.PURCHASED_PRODUCT_T pp,PIN.SERVICE_T s,PIN.PRODUCT_T p,PIN.RATE_T r,PIN.RATE_PLAN_T rp,PIN.RATE_BAL_IMPACTS_T rb,PIN.BAL_GRP_T bg,PIN.BILLINFO_T b,pin.account_nameinfo_t an
where
s.poid_id0=pp.service_obj_id0 
and s.account_obj_id0=a.poid_id0
and s.poid_type = '/service/telco/gsm'
and rp.event_type='/event/billing/product/fee/cycle/cycle_arrear'
and s.poid_id0=st.obj_id0
and pp.product_obj_id0=p.poid_id0
and rp.product_obj_id0=p.poid_id0
and r.rate_plan_obj_id0=rp.poid_id0
and r.poid_id0=rb.obj_id0
and s.bal_grp_obj_id0=bg.poid_id0
and bg.billinfo_obj_id0=b.poid_id0
and a.poid_id0 = an.obj_id0
and an.rec_id = '1'
and substr(nvl(an.company,'0'),1,11) != 'TestAccount'
and pp.status != 3 
and s.status != 10103
and (rb.scaled_amount != 0 or pp.cycle_fee_amt != 0)
and b.pay_type <> '10000';
clear buffer
EXIT;
EOF

exit 0


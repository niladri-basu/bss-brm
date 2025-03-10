#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
LOG_DIR=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
#now=`date +'%Y%m%d%H'`
now=`date -d yesterday +'%Y%m%d'`
target_dir=`egrep -v "#" login.cfg | grep "FETCH_ACCOUNT_OUT_DIR" |cut -d'=' -f2`
log_dir=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
#$OUT_DIR/BRM_NON0_EVENT_EXPORT-$date_run-$now.txt
filename="Account_extract"
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
select at.POID_ID0||'*'||at.ACCOUNT_NO||'*'||ccs.CUST_SEG_DESC||'*'||TO_CHAR(td_unix_to_nz(at.CREATED_T),'DD-MM-YYYY HH24:MI:SS')||'*'||TO_CHAR(td_unix_to_nz(at.MOD_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||bt.POID_ID0||'*'||bt.AR_BILLINFO_OBJ_ID0||'*'||bt.BILL_INFO_ID||'*'||TO_CHAR(td_unix_to_nz(bt.CREATED_T),'DD-MM-YYYY HH24:MI:SS')||'*'||TO_CHAR(td_unix_to_nz(bt.MOD_T),'DD-MM-YYYY HH24:MI:SS')||'*'||bt.PAY_TYPE||'*'||bt.ACTG_CYCLE_DOM||'*'||bt.BILLING_STATUS||'*'||bt.STATUS||'*'||bt.NUM_SUPPRESSED_CYCLES||'*'||bt.EXEMPT_FROM_COLLECTIONS||'*'||bt.SCENARIO_OBJ_ID0 
from PIN.account_t at, PIN.billinfo_t bt,PIN.CONFIG_CUSTOMER_SEGMENT_T ccs, PIN.account_nameinfo_t act
where at.poid_id0=bt.account_obj_id0
and at.cust_seg_list=ccs.rec_id
and at.poid_id0=act.obj_id0
and act.REC_ID = '1'
and substr(nvl(act.company,'0'),1,11) != 'TestAccount';
clear buffer
EXIT;
EOF

exit 0

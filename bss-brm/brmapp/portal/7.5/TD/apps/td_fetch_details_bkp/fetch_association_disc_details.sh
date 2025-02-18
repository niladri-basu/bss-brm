#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
LOG_DIR=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
now=`date +'%Y%m%d%H'`
target_dir=`egrep -v "#" login.cfg | grep "FETCH_AMD_OUT_DIR" |cut -d'=' -f2`
log_dir=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
#$OUT_DIR/BRM_NON0_EVENT_EXPORT-$date_run-$now.txt
filename="AMD_extract"
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
SET LINESIZE 5000
SET WRAP OFF
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS OFF VERIFY OFF;
set verify off
set auto off
set termout off
set trimspool on
spool $outfile 
select a.ACCOUNT_NO||'*'||b.BILL_INFO_ID||'*'||b.ACTG_CYCLE_DOM||'*'||
st.NAME||'*'||pod.NAME||'*'||TO_CHAR(td_unix_to_nz(pd.CYCLE_START_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||pd.STATUS||'*'||TO_CHAR(td_unix_to_nz(pd.CYCLE_END_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||TO_CHAR(td_unix_to_nz(b.LAST_BILL_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||TO_CHAR(td_unix_to_nz(b.NEXT_BILL_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||a.POID_ID0||'*'||b.POID_ID0||'*'||pd.POID_ID0||'*'||s.POID_ID0||'*'||dt.POID_ID0||'*'||pd.NODE_LOCATION
from
PIN.ACCOUNT_T a,PIN.SERVICE_ALIAS_LIST_T st,PIN.PURCHASED_DISCOUNT_T pd,PIN.SERVICE_T s,PIN.DISCOUNT_T dt,PIN.BILLINFO_T b,PIN.BAL_GRP_T bg,
PIN.PROFILE_OFFER_DETAILS_t pdt,PIN.profile_t prf,PIN.PROFILE_OFFER_DETAILS_DATA_T pod
where
s.poid_id0=pd.service_obj_id0 
and s.account_obj_id0=a.poid_id0
and s.poid_id0=st.obj_id0
and pd.discount_obj_id0=dt.poid_id0
and s.bal_grp_obj_id0=bg.poid_id0
and b.pay_type <> '10000'
and bg.billinfo_obj_id0=b.poid_id0
and pdt.offering_obj_id0=pd.poid_id0
and pod.obj_id0=pdt.obj_id0
and prf.poid_id0=pdt.obj_id0
and pd.created_t >= td_nz_to_unix(TRUNC(SYSDATE-120)) 
and pd.created_t < td_nz_to_unix(TRUNC(SYSDATE));
clear buffer
spool off
EXIT
EOF)

exit 0
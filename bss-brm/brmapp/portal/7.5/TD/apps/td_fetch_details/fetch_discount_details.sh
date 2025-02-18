#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
LOG_DIR=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
now=`date +'%Y%m%d%H'`
target_dir=`egrep -v "#" login.cfg | grep "FETCH_DISCOUNT_OUT_DIR" |cut -d'=' -f2`
log_dir=`egrep -v "#" login.cfg | grep "LOG_DIR" |cut -d'=' -f2`
#$OUT_DIR/BRM_NON0_EVENT_EXPORT-$date_run-$now.txt
filename="discount_extract"
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
select to_char(act.ACCOUNT_NO)||'*'||bill.BILL_INFO_ID||'*'||bill.ACTG_CYCLE_DOM||'*'||to_char(salt.NAME)||'*'||podd.name||'*'||(select max(PDD.VALUE)
    from PIN.PROFILE_T PROF,PIN.PROFILE_OFFER_DETAILS_DATA_T PDDT,PIN.PROFILE_OFFER_DETAILS_DATA_T PDD
where
    PROF.POID_ID0 = PDDT.OBJ_ID0
and PROF.ACCOUNT_OBJ_ID0 in ('125245087')
and PROF.POID_ID0 = PDD.OBJ_ID0
and PDDT.name = 'OWNER_NAME'
and PDDT.value = PODD.value
AND PDD.NAME = 'DISCOUNT_PERCENT')||'*'||TO_CHAR(td_unix_to_nz(prod.CYCLE_START_T),'DD-MM-YYYY HH24:MI:SS')||'*'||
prod.STATUS||'*'||TO_CHAR(td_unix_to_nz(prod.CYCLE_END_T),'DD-MM-YYYY HH24:MI:SS')||'*'||
TO_CHAR(td_unix_to_nz(bill.LAST_BILL_T),'DD-MM-YYYY HH24:MI:SS')||'*'||TO_CHAR(td_unix_to_nz(bill.NEXT_BILL_T),'DD-MM-YYYY HH24:MI:SS')||'*'||
to_char(act.POID_ID0)||'*'||to_char(bill.POID_ID0)||'*'||to_char(prod.POID_ID0)||'*'||to_char(ser.POID_ID0)||'*'||to_char(p.POID_ID0)||'*'||prod.NODE_LOCATION    
FROM 
  PIN.ACCOUNT_T ACT,
  PIN.BILLINFO_T BILL,
  PIN.SERVICE_ALIAS_LIST_T SALT,
  PIN.SERVICE_T SER,
  PIN.BAL_GRP_T BGP,
  PIN.PURCHASED_discount_T PROD,
  PIN.DISCOUNT_T P,
  PIN.PROFILE_OFFER_DETAILS_T POD,
  pin.profile_offer_details_data_t podd,
pin.account_nameinfo_t an
WHERE
    ACT.POID_ID0 = BILL.ACCOUNT_OBJ_ID0
AND SALT.OBJ_ID0 = SER.POID_ID0
AND SER.BAL_GRP_OBJ_ID0 = BGP.POID_ID0
AND BGP.BILLINFO_OBJ_ID0 = BILL.POID_ID0
AND PROD.SERVICE_OBJ_ID0 = SER.POID_ID0
AND PROD.DISCOUNT_OBJ_ID0 = P.POID_ID0
and PROD.POID_ID0 = POD.OFFERING_OBJ_ID0
and act.poid_id0 = an.obj_id0
and an.rec_id = '1'
and substr(nvl(an.company,'0'),1,11) != 'TestAccount'
and prod.status != 3
and ser.status != 10103
and POD.OBJ_ID0 = PODD.OBJ_ID0
and PODD.name = 'OWNER_NAME'
union all
select 
 to_char(act.ACCOUNT_NO)||'*'||bill.BILL_INFO_ID||'*'||bill.ACTG_CYCLE_DOM||'*'||to_char(salt.NAME)||'*'||p.name||'*'||(select 
  to_char(max(bal.grant_units*-100)) discount_per
from 
  PIN.DISCOUNT_T D,
  PIN.DISCOUNT_USAGE_MAP_T DUM,
  INTEGRATE.IFW_DISCOUNTMODEL DM,
  INTEGRATE.IFW_DSCMDL_CNF DSC,
  INTEGRATE.IFW_DISCOUNTRULE DRULE,
  INTEGRATE.IFW_DISCOUNTSTEP DSTEP,
  integrate.IFW_DSCBALIMPACT bal
where
    D.POID_ID0 = DUM.OBJ_ID0
and DUM.DISCOUNT_MODEL = DM.CODE
and DM.DISCOUNTMODEL = DSC.DISCOUNTMODEL
and DSC.DISCOUNTRULE = DRULE.DISCOUNTRULE
and DRULE.DISCOUNTRULE = DSTEP.DISCOUNTRULE
and DSTEP.DISCOUNTSTEP = BAL.DISCOUNTSTEP
and d.poid_id0 = p.poid_id0
)||'*'||
TO_CHAR(td_unix_to_nz(prod.CYCLE_START_T),'DD-MM-YYYY HH24:MI:SS') ||'*'||
prod.STATUS||'*'||TO_CHAR(td_unix_to_nz(prod.CYCLE_END_T),'DD-MM-YYYY HH24:MI:SS')||'*'||
TO_CHAR(td_unix_to_nz(bill.LAST_BILL_T),'DD-MM-YYYY HH24:MI:SS')||'*'||tO_CHAR(td_unix_to_nz(bill.NEXT_BILL_T),'DD-MM-YYYY HH24:MI:SS')
||'*'||to_char(act.POID_ID0)||'*'||to_char(bill.POID_ID0)||'*'||to_char(prod.POID_ID0)||'*'||to_char(ser.POID_ID0)||'*'||to_char(p.POID_ID0)||'*'||prod.NODE_LOCATION
from 
  pin.purchased_discount_t prod,
  pin.discount_t p,
  pin.service_alias_list_t salt,
  pin.service_t ser,
  pin.bal_grp_t bgp,
  pin.billinfo_t bill,
  PIN.ACCOUNT_T ACT,
pin.account_nameinfo_t an
where 
    p.poid_id0 = prod.discount_obj_id0
and salt.obj_id0 = ser.poid_id0
and ser.bal_grp_obj_id0 = bgp.poid_id0
and BGP.BILLINFO_OBJ_ID0 = BILL.POID_ID0
and act.poid_id0 = bill.account_obj_id0
and ser.poid_id0 = prod.service_obj_id0
and act.poid_id0 = an.obj_id0
and an.rec_id = '1'
and substr(nvl(an.company,'0'),1,11) != 'TestAccount'
and PROD.STATUS != 3
and P.name != 'Association Member - Discount'
and P.name != 'Landline on Your Mobile Discount'
and P.name != 'FCN Discount'
and P.name != 'Group Text Discount';
clear buffer
EXIT;
EOF

exit 0

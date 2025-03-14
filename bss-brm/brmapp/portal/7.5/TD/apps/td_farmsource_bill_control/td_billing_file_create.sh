#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile='/brmapp/portal/7.5/TD/apps/td_farmsource_bill_control/fs_control_logs/fs_billing_control_create.log'
#echo $LOGINSQL
$ORACLE_HOME/bin/sqlplus -s $LOGINSQL>>$outfile<<EOF
SET WRAP ON
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
set linesize 200
set serveroutput on size 2000

DECLARE

        v_ddl_stmt VARCHAR2(32767);
        v_ddl_stmt1 VARCHAR2(32767);
        v_ddl_stmt2 VARCHAR2(32767);
        v_ddl_stmt3 VARCHAR2(32767);
        v_ddl_stmt4 VARCHAR2(32767);
        v_ddl_stmt5 VARCHAR2(32767);
        v_ddl_stmt6 VARCHAR2(32767);
        v_errmsg VARCHAR2(200);
        v_count number(5) := 0;
		v_count1 number(5) := 0;
BEGIN
	 select count(1) into v_count from user_tables where table_name='TD_FS_BILLING_CONTROL_T';
        if v_count <> 1
        then

v_ddl_stmt := 'create table TMP_FS_CTL_AMOUNT as (
select distinct acc.account_no, bi.BILL_INFO_ID, bt.bill_no, fb.FS_ACCOUNT_NO, bt.previous_total balance_forward , 
bt.current_total , bt.total_due 
from TD_FS_BILLING_EXTRACT_T fb, bill_t bt , billinfo_t bi , account_t acc , TD_BILL_TAX_T tbt
where fb.INVOICE_NO = bt.BILL_NO
and bt.BILLINFO_OBJ_ID0 = bi.poid_id0
and acc.poid_id0 = bi.account_obj_id0
and acc.poid_id0 = tbt.account_obj_id0
and tbt.BILL_OBJ_ID0 = bt.POID_ID0
and acc.poid_id0 = tbt.account_obj_id0)';

        EXECUTE IMMEDIATE v_ddl_stmt;

v_ddl_stmt1 := 'create table TMP_FS_CTL_FS_TOTAL as (
select distinct acc.account_no, bi.BILL_INFO_ID, bt.bill_no, sum(fb.total_amount_incl_gst) as total_amount_incl_gst
from TD_FS_BILLING_EXTRACT_T fb, bill_t bt , billinfo_t bi , account_t acc , TD_BILL_TAX_T tbt
where fb.INVOICE_NO = bt.BILL_NO
and bt.BILLINFO_OBJ_ID0 = bi.poid_id0
and acc.poid_id0 = bi.account_obj_id0
and acc.poid_id0 = tbt.account_obj_id0
and tbt.BILL_OBJ_ID0 = bt.POID_ID0
and acc.poid_id0 = tbt.account_obj_id0
group by acc.account_no, bi.BILL_INFO_ID, bt.bill_no)';

        EXECUTE IMMEDIATE v_ddl_stmt1;


v_ddl_stmt2 := 'create table TMP_FS_CTL_MRO as (
select distinct acc.account_no, bi.BILL_INFO_ID, bt.bill_no, fb.FS_ACCOUNT_NO, sum(fb.total_amount_incl_gst) as MRO
from TD_FS_BILLING_EXTRACT_T fb, bill_t bt , billinfo_t bi , account_t acc , TD_BILL_TAX_T tbt
where fb.INVOICE_NO = bt.BILL_NO
and bt.BILLINFO_OBJ_ID0 = bi.poid_id0
and acc.poid_id0 = bi.account_obj_id0
and acc.poid_id0 = tbt.account_obj_id0
and tbt.BILL_OBJ_ID0 = bt.POID_ID0
and acc.poid_id0 = tbt.account_obj_id0
and fb.ARTICLE_CODE=2
group by acc.account_no, bi.BILL_INFO_ID, bt.bill_no, fb.FS_ACCOUNT_NO)';


        EXECUTE IMMEDIATE v_ddl_stmt2;

v_ddl_stmt3 := 'create table TMP_FS_CTL_NIL_GST as (
select distinct acc.account_no, bi.BILL_INFO_ID, bt.bill_no, fb.FS_ACCOUNT_NO, sum(fb.total_amount_incl_gst) as NIL_GST
from TD_FS_BILLING_EXTRACT_T fb, bill_t bt , billinfo_t bi , account_t acc , TD_BILL_TAX_T tbt
where fb.INVOICE_NO = bt.BILL_NO
and bt.BILLINFO_OBJ_ID0 = bi.poid_id0
and acc.poid_id0 = bi.account_obj_id0
and acc.poid_id0 = tbt.account_obj_id0
and tbt.BILL_OBJ_ID0 = bt.POID_ID0
and acc.poid_id0 = tbt.account_obj_id0
and fb.ARTICLE_CODE=1
group by acc.account_no, bi.BILL_INFO_ID, bt.bill_no, fb.FS_ACCOUNT_NO)';

        EXECUTE IMMEDIATE v_ddl_stmt3;

v_ddl_stmt4 := 'create table TMP_FS_CTL_PAYMENT_TMP as (
select distinct acc.account_no as BRM_ACCOUNT_NO ,bi.BILL_INFO_ID, bt.bill_no, ebp.trans_id,  ebp.amount as FS_PYMT
from TD_FS_BILLING_EXTRACT_T fb, bill_t bt , billinfo_t bi , account_t acc ,  EVENT_BILLING_PAYMENT_t ebp, event_t et, item_t it, EVENT_BAL_IMPACTS_T ebi
where fb.INVOICE_NO = bt.BILL_NO
and bt.BILLINFO_OBJ_ID0 = bi.poid_id0
and acc.poid_id0 = bi.account_obj_id0
and acc.poid_id0 = et.account_obj_id0
and et.poid_id0 = ebp.obj_id0
and it.billinfo_obj_id0 = bi.poid_id0
and ebi.ITEM_OBJ_ID0 = it.poid_id0
and ebi.obj_id0 = ebp.obj_id0
and et.created_t between bi.last_bill_t and bi.NEXT_BILL_T)';

        EXECUTE IMMEDIATE v_ddl_stmt4;

v_ddl_stmt6 := 'create table TMP_FS_CTL_PAYMENT as (
select  BRM_ACCOUNT_NO ,BILL_INFO_ID, bill_no, sum (FS_PYMT) as FS_PAYMENT
from TMP_FS_CTL_PAYMENT_TMP
group by BRM_ACCOUNT_NO ,BILL_INFO_ID, bill_no)';

        EXECUTE IMMEDIATE v_ddl_stmt6;


v_ddl_stmt5 := 'create table TD_FS_BILLING_CONTROL_T as (
select distinct am.account_no as Customer_No,
am.BILL_INFO_ID as BILL_PROFILE_ID, 
am.bill_no as Invoice_No,
am.FS_ACCOUNT_NO as Farmsource_Account_No, 
am.balance_forward as Balance_Carried_Forward, 
am.Current_Total as Total_Charges,
am.total_due as Total_Owing,
fst.total_amount_incl_gst as Total_Billed_To_FarmSource,
abs(py.FS_PAYMENT) as Amount_of_Farmsource_Payment,
(am.total_due - py.FS_PAYMENT  ) as Balance_After_Payment,
mr.mro as MRO , 
(select  decode(sum(fb.total_amount_incl_gst),NULL,0,sum(fb.total_amount_incl_gst))
from TD_FS_BILLING_EXTRACT_T fb
where fb.ARTICLE_CODE=3
and fb.account_no = mr.account_no) as OTHER_NIL_GST,
ng.NIL_GST as INCLUDING_GST,
round(ng.NIL_GST * 3/23,2) as Actual_GST
from TMP_FS_CTL_AMOUNT am,TMP_FS_CTL_FS_TOTAL fst, TMP_FS_CTL_MRO mr, TMP_FS_CTL_NIL_GST ng,  TMP_FS_CTL_PAYMENT py
where am.account_no = mr.account_no
and am.BILL_NO = ng.bill_no
and  am.account_no= fst.account_no
and  py.bill_no= fst.bill_no
and fst.bill_no= am.bill_no
and mr.BILL_NO = am.BILL_NO
and py.BRM_ACCOUNT_NO=fst.account_no)';

        EXECUTE IMMEDIATE v_ddl_stmt5;
	end if;	
END;
/

exit;
EOF

#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile='/brmapp/portal/7.5/TD/apps/td_farmsource_billing/fs_logs/fs_billing_create.log'
actg_dom=$1;
echo $actg_dom
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
        v_errmsg VARCHAR2(200);
        v_count number(5) := 0;
		v_count1 number(5) := 0;
BEGIN
	select count(1) into v_count from user_tables where table_name='TD_FS_BILLING_EXTRACT_T';
        if v_count <> 1
        then
v_ddl_stmt := 'create table TD_FS_BILLING_EXTRACT_T 
(FS_ACCOUNT_NO,FS_ACCOUNT_NAME,ACCOUNT_NO,INVOICE_NO,ARTICLE_CODE,transaction_date,bill_start,QUANTITY,NET_AMOUNT,GST_AMOUNT,TOTAL_AMOUNT_INCL_GST,EVENT_POID,TAG
)
as (
( select 
pfs.FS_ACCOUNT_NO ,
pfs.FS_ACCOUNT_NAME,
ACT.ACCOUNT_NO ,
b.BILL_NO ,
''1'' as ARTICLE_CODE,
PIN.TD_UNIX_TO_NZ(b.end_t ) ,
PIN.td_unix_to_nz(b.start_t) ,
''1.00'' as QUANTITY,
round((TBILL.AMOUNT_TAXED+tbill.amount_adjusted)-(TBILL.TAX+TBILL.adjusted_tax),2),
round((TBILL.TAX+TBILL.adjusted_tax),2),
round((TBILL.AMOUNT_TAXED+tbill.amount_adjusted),2),
0 as event_poid,
''2degrees Mobile Plan Charges'' as tag
FROM
pin.payinfo_t py, pin.payinfo_farmsource_t pfs, pin.Billinfo_t bi, pin.account_t act, pin.td_bill_tax_t tbill, pin.bill_t b
where
bi.next_bill_t=(select pin.td_nz_to_unix(to_date(''$actg_dom'',''YYYYMMDD'')) from dual)
and bi.billing_status<>1
and bi.pay_type=''10101''
and py.created_t < bi.last_bill_t
and py.poid_id0=bi.payinfo_obj_id0
and pfs.obj_id0=py.poid_id0
and act.poid_id0=bi.account_obj_id0
and tbill.AR_BILLINFO_OBJ_ID0=bi.poid_id0
and b.poid_id0=tbill.bill_obj_id0
and b.end_t >=bi.last_bill_t
and b.end_t <= bi.Next_bill_t)

Union all

(select
pfs.FS_ACCOUNT_NO ,
pfs.FS_ACCOUNT_NAME,
ACT.ACCOUNT_NO ,
b.BILL_NO ,
''2'' as ARTICLE_CODE,
PIN.TD_UNIX_TO_NZ(b.end_t ) ,
PIN.td_unix_to_nz(b.start_t) ,
''1.00'' as QUANTITY,
EB.AMOUNT ,
0 as GST ,
EB.AMOUNT ,
eb.obj_id0 ,
''2degrees Handset Repayments'' as tag
FROM
pin.payinfo_t py, pin.payinfo_farmsource_t pfs, pin.Billinfo_t bi, pin.account_t act, pin.bill_t b,pin.event_t e,pin.event_bal_impacts_t eb,pin.item_t i
where
bi.next_bill_t=(select pin.td_nz_to_unix(to_date(''$actg_dom'',''YYYYMMDD'')) from dual)
and bi.billing_status<>1
and bi.pay_type=''10101''
and py.created_t < bi.last_bill_t
and py.poid_id0=bi.payinfo_obj_id0
and pfs.obj_id0=py.poid_id0
and act.poid_id0=bi.account_obj_id0
and b.billinfo_obj_id0=bi.poid_id0
and b.end_t >=bi.last_bill_t
and b.end_t <= bi.Next_bill_t
and i.bill_obj_id0=b.poid_id0
and e.item_obj_id0=i.poid_id0
and eb.gl_id in (''800200022'',''800200023'',''800200032'',''800200010'',''800200011'',''800200020'',''800200033'',''700600715'',''700600716'',''700600713'',''800200024'',''800200440'',''800200441'',''800200442'',''800200443'')
and eb.obj_id0=e.poid_id0
and eb.resource_id=''554'')

Union all

(select 
pfs.FS_ACCOUNT_NO ,
pfs.FS_ACCOUNT_NAME,
ACT.ACCOUNT_NO ,
b.BILL_NO ,
''2'' as ARTICLE_CODE,
PIN.TD_UNIX_TO_NZ(b.end_t ) ,
PIN.td_unix_to_nz(b.start_t) ,
''1.00'' as QUANTITY,
EB.AMOUNT ,
0 as GST ,
EB.AMOUNT ,
eb.obj_id0 ,
''2degrees Handset Repayments'' as tag
FROM
pin.payinfo_t py, pin.payinfo_farmsource_t pfs, pin.Billinfo_t bi, pin.account_t act, pin.bill_t b,pin.event_t e,pin.event_bal_impacts_t eb,pin.item_t i,pin.td_bill_tax_t tbill,pin.bal_grp_t bg
where
bi.next_bill_t=(select pin.td_nz_to_unix(to_date(''$actg_dom'',''YYYYMMDD'')) from dual)
and bi.billing_status<>1
and bi.pay_type=''10101''
and py.created_t < bi.last_bill_t
and py.poid_id0=bi.payinfo_obj_id0
and pfs.obj_id0=py.poid_id0
and act.poid_id0=bi.account_obj_id0
and b.billinfo_obj_id0=bi.poid_id0
and b.end_t >=bi.last_bill_t
and b.end_t <= bi.Next_bill_t
and tbill.AR_BILLINFO_OBJ_ID0=bi.poid_id0
and b.poid_id0=tbill.bill_obj_id0
and e.created_t > (select pin.td_nz_to_unix(to_date(sysdate-45)) from dual)
and e.start_t >=td_nz_to_unix(ADD_MONTHS(td_unix_to_nz(bi.last_bill_t) , - 1))
and e.start_t <(bi.last_bill_t)
and bg.poid_id0=eb.BAL_GRP_OBJ_ID0
and bi.poid_id0=bg.BILLINFO_OBJ_ID0
and i.poid_type = ''/item/adjustment''
and i.AR_BILLINFO_OBJ_ID0 = b.AR_BILLINFO_OBJ_ID0
and i.EFFECTIVE_T > b.START_T
and i.EFFECTIVE_T <= b.END_T
and eb.impact_type !=4
and eb.tax_code is null
and e.item_obj_id0=i.poid_id0
and e.poid_type not like ''%transfer%''
and eb.gl_id in (''800200022'',''800200023'',''800200032'',''800200010'',''800200011'',''800200020'',''800200033'',''700600715'',''700600716'',''700600713'',''800200024'',''800200440'',''800200441'',''800200442'',''800200443'')
and eb.obj_id0=e.poid_id0
and eb.obj_id0=e.poid_id0
and eb.resource_id=''554''
)


Union all

(select 
pfs.FS_ACCOUNT_NO ,
pfs.FS_ACCOUNT_NAME,
ACT.ACCOUNT_NO ,
b.BILL_NO ,
''3'' as ARTICLE_CODE,
PIN.TD_UNIX_TO_NZ(b.end_t ) ,
PIN.td_unix_to_nz(b.start_t) ,
''1.00'' as QUANTITY,
EB.AMOUNT ,
0 as GST ,
EB.AMOUNT ,
eb.obj_id0 ,
''2degrees Nil Tax Mobile Charges'' as tag
FROM
pin.payinfo_t py, pin.payinfo_farmsource_t pfs, pin.Billinfo_t bi, pin.account_t act, pin.bill_t b,pin.event_t e,pin.event_bal_impacts_t eb,pin.item_t i
where
bi.next_bill_t=(select pin.td_nz_to_unix(to_date(''$actg_dom'',''YYYYMMDD'')) from dual)
and bi.billing_status<>1
and bi.pay_type=''10101''
and py.created_t < bi.last_bill_t
and py.poid_id0=bi.payinfo_obj_id0
and pfs.obj_id0=py.poid_id0
and act.poid_id0=bi.account_obj_id0
and b.billinfo_obj_id0=bi.poid_id0
and b.end_t >=bi.last_bill_t
and b.end_t <= bi.Next_bill_t
and i.bill_obj_id0=b.poid_id0
and i.poid_type like ''%niltax%''
and e.item_obj_id0=i.poid_id0
and e.poid_type not like ''%transfer%''
and eb.obj_id0=e.poid_id0
and eb.gl_id not in (''800200022'',''800200023'',''800200032'',''800200010'',''800200011'',''800200020'',''800200033'',''700600715'',''700600716'',''700600713'',''800200024'',''800200440'',''800200441'',''800200442'',''800200443'')
and eb.tax_code is NULL
and eb.resource_id=''554''
)

Union all


(select 
pfs.FS_ACCOUNT_NO ,
pfs.FS_ACCOUNT_NAME,
ACT.ACCOUNT_NO ,
b.BILL_NO ,
''3'' as ARTICLE_CODE,
PIN.TD_UNIX_TO_NZ(b.end_t ) ,
PIN.td_unix_to_nz(b.start_t) ,
''1.00'' as QUANTITY,
EB.AMOUNT ,
0 as GST ,
EB.AMOUNT ,
eb.obj_id0 ,
''2degrees Nil Tax Mobile Charges'' as tag
FROM
pin.payinfo_t py, pin.payinfo_farmsource_t pfs, pin.Billinfo_t bi, pin.account_t act, pin.bill_t b,pin.event_t e,pin.event_bal_impacts_t eb,pin.item_t i,pin.td_bill_tax_t tbill,pin.bal_grp_t bg
where
bi.next_bill_t=(select pin.td_nz_to_unix(to_date(''$actg_dom'',''YYYYMMDD'')) from dual)
and bi.billing_status<>1
and bi.pay_type=''10101''
and py.created_t < bi.last_bill_t
and py.poid_id0=bi.payinfo_obj_id0
and pfs.obj_id0=py.poid_id0
and act.poid_id0=bi.account_obj_id0
and b.billinfo_obj_id0=bi.poid_id0
and b.end_t >=bi.last_bill_t
and b.end_t <= bi.Next_bill_t
and tbill.AR_BILLINFO_OBJ_ID0=bi.poid_id0
and b.poid_id0=tbill.bill_obj_id0
and e.created_t > (select pin.td_nz_to_unix(to_date(sysdate-45)) from dual)
and e.start_t >=td_nz_to_unix(ADD_MONTHS(td_unix_to_nz(bi.last_bill_t) , - 1))
and e.start_t <(bi.last_bill_t)
and bg.poid_id0=eb.BAL_GRP_OBJ_ID0
and bi.poid_id0=bg.BILLINFO_OBJ_ID0
and i.poid_type = ''/item/adjustment''
and i.AR_BILLINFO_OBJ_ID0 = b.AR_BILLINFO_OBJ_ID0
and i.EFFECTIVE_T > b.START_T
and i.EFFECTIVE_T <= b.END_T
and eb.impact_type !=4
and eb.tax_code is null
and e.item_obj_id0=i.poid_id0
and e.poid_type not like ''%transfer%''
and eb.gl_id not in (''800200022'',''800200023'',''800200032'',''800200010'',''800200011'',''800200020'',''800200033'',''700600715'',''700600716'',''700600713'',''800200024'',''800200440'',''800200441'',''800200442'',''800200443'')
and eb.obj_id0=e.poid_id0
and eb.obj_id0=e.poid_id0
and eb.resource_id=''554''
)
)';

        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;
		
		select count(1) into v_count from user_tables where table_name='TD_FS_BILLING_FILE_EXT_T';

        if v_count <> 1
        then
v_ddl_stmt := 'create table TD_FS_BILLING_FILE_EXT_T nologging parallel 4
as

(select ''D'' as Row_Type,FS_ACCOUNT_NO,FS_ACCOUNT_NAME,ACCOUNT_NO,INVOICE_NO,ARTICLE_CODE,TRANSACTION_DATE,TAG,QUANTITY,sum(NET_AMOUNT) as NET_AMOUNT,GST_AMOUNT,sum(TOTAL_AMOUNT_INCL_GST) as TOTAL_AMT_INCL_GST
from TD_FS_BILLING_EXTRACT_T where INVOICE_NO in (select INVOICE_NO
from TD_FS_BILLING_EXTRACT_T 
group by FS_ACCOUNT_NO,INVOICE_NO,TRANSACTION_DATE 
having sum(TOTAL_AMOUNT_INCL_GST) >0 ) 
group by FS_ACCOUNT_NO,FS_ACCOUNT_NAME,ACCOUNT_NO,INVOICE_NO,ARTICLE_CODE,TRANSACTION_DATE,TAG,QUANTITY,GST_AMOUNT
)';	
        EXECUTE IMMEDIATE v_ddl_stmt;
		end if;		
END;
/

exit;
EOF

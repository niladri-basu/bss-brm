#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/td_revenue_report_monthly_create.log/'`
#evt_poid_type=`egrep -v "#" login.cfg | grep "evt_poid_type" |cut -d'=' -f2`
#evt_mp_poid_type=`egrep -v "#" login.cfg | grep "evt_mp_poid_type" |cut -d'=' -f2`
sql_fromdate=$1;
sql_todate=$2;
#echo $LOGINSQL
echo "sql_fromdate";
echo $sql_fromdate;
#echo "sql_todate";
echo $sql_todate;
echo "sql_todate"
$ORACLE_HOME/bin/sqlplus -s $LOGINSQL>>$outfile<<EOF
SET WRAP ON
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
set linesize 200
set serveroutput on size 2000
DECLARE
        v_ddl_stmt VARCHAR2(4000);
        v_errmsg VARCHAR2(200);
        v_count number(5) := 0;
BEGIN
        
		select count(1) into v_count  from user_objects where object_name = 'TMP_TD_BSMS_ALL_T' and object_type ='TABLE';
        if v_count <> 1
        then
v_ddl_stmt := 'create table TMP_TD_BSMS_ALL_T as 
(select  
(td_unix_to_nz(e.start_t)) as start_t,
bi.poid_id0 as BILLINFO_POID,
bi.ACCOUNT_OBJ_ID0,
e.poid_id0 as epoid,
es.calling_from,
es.called_to 
from  pin.event_t e, pin.event_dlay_sess_tlcs_t es,pin.billinfo_t bi,pin.account_nameinfo_t act,pin.account_t a--,pin.purchased_product_t ppt
where e.poid_id0=es.obj_id0
and bi.account_obj_id0=e.account_obj_id0
and act.obj_id0=a.poid_id0
and act.obj_id0=e.account_obj_id0
and bi.pay_type not in (''10000'',''10007'')
--and ppt.product_obj_id0 =''38801061''
--and e.account_obj_id0=ppt.account_obj_id0
and act.REC_ID = ''1''
and substr(act.company,1,11) != ''TestAccount''
and e.poid_type=''/event/delayed/session/telco/gsm/sms''
and es.svc_type=''B''
and es.svc_code=''SMS''
and e.start_t >= (td_nz_to_unix(''$sql_fromdate''))
and e.start_t < (td_nz_to_unix(''$sql_todate'')))';

        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;
		select count(1) into v_count  from user_objects where object_name = 'TMP_TD_BSMS_ADJ_ALL_T' and object_type ='TABLE';
        if v_count <> 1
        then
v_ddl_stmt := 'create table TMP_TD_BSMS_ADJ_ALL_T as 
(select  
(td_unix_to_nz(e.start_t)) as start_t,
bi.poid_id0 as BILLINFO_POID,
bi.ACCOUNT_OBJ_ID0,
e.poid_id0 as epoid
from  pin.event_t e, pin.event_bal_impacts_t eb,pin.billinfo_t bi,pin.account_nameinfo_t act,pin.account_t a
where eb.gl_id in (''500205411'',''610205411'')
and e.poid_id0=eb.obj_id0  
and bi.account_obj_id0=e.account_obj_id0 
and act.obj_id0=a.poid_id0
and a.poid_id0=e.account_obj_id0
and bi.pay_type not in (''10000'',''10007'')
and act.REC_ID = ''1''
and substr(act.company,1,11) != ''TestAccount''
and e.poid_type in (''/event/billing/adjustment/account'',''/event/billing/adjustment/tax_event'',''/event/billing/adjustment/item'',''/event/billing/adjustment/event'',''/event/billing/adjustment/bill'')
and e.start_t >= (td_nz_to_unix(''$sql_fromdate''))
and e.start_t < (td_nz_to_unix(''$sql_todate'')))';

        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;
		select count(1) into v_count  from user_objects where object_name = 'TD_REVENUE_MONTHLY_REPORT_T' and object_type ='TABLE';

        if v_count <> 1
        then

v_ddl_stmt := 'create table TD_REVENUE_MONTHLY_REPORT_T  as 
select 
(select to_char((TRUNC(tba.start_t)),''Month'') from tmp_td_bsms_all_t tba where rownum=1) as "Month",
(select count(1) from pin.event_bal_impacts_t eb, pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=''1000116'') as "total no of msgs",
(select sum(eb.amount) as "BR_AUS_USA" from pin.event_bal_impacts_t eb, pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554) as "billed revenue",
(select sum(eb.amount) as "Credits_refunds" from pin.event_bal_impacts_t eb, pin.TMP_TD_BSMS_ADJ_ALL_T tba where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554) as "credits/Refunds",
(select count(1) from pin.event_bal_impacts_t eb, pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and eb.impact_category =''NZLOC'' and eb.RESOURCE_ID=1000116) as "no of msgs to NZ numbers",
(select sum(eb.amount) from  pin.tmp_td_bsms_all_t tba,pin.event_bal_impacts_t eb
where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554  and eb.impact_category  =''NZLOC'') as "BR_NZ",
(select count(1) from pin.event_bal_impacts_t eb,pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and eb.impact_category  in (''NZAUS'',''NZUSA'') and eb.RESOURCE_ID=1000116) as "no of msgs to AUS/USA",
(select sum(eb.amount) from  pin.tmp_td_bsms_all_t tba,pin.event_bal_impacts_t eb
where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554  and eb.impact_category  in (''NZAUS'',''NZUSA'')) as "BR_AUS/USA",
(select count(1) from pin.event_bal_impacts_t eb,pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and eb.impact_category  =''NZOTH'' and eb.RESOURCE_ID=1000116) as "no of msgs to OTHER numbers",
(select sum(eb.amount) from pin.tmp_td_bsms_all_t tba,pin.event_bal_impacts_t eb
where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554  and eb.impact_category  =''NZOTH'') as "BR_OTH"
from dual';


    EXECUTE IMMEDIATE v_ddl_stmt;	
        end if;
		
END;
/

exit;
EOF

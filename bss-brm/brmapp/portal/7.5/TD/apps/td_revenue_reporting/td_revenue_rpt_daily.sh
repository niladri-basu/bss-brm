#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/td_revenue_rpt_daily_create.log/'`
#evt_poid_type=`egrep -v "#" login.cfg | grep "evt_poid_type" |cut -d'=' -f2`
#evt_mp_poid_type=`egrep -v "#" login.cfg | grep "evt_mp_poid_type" |cut -d'=' -f2`
sql_currdate=$1;
#sql_todate=$2;
#echo $LOGINSQL
#echo "daily_report"
echo $sql_currdate
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
        select count(1) into v_count  from user_objects where object_name = 'TD_REVENUE_DAILY_REPORT_T' and object_type ='TABLE';

        if v_count <> 1
        then

v_ddl_stmt := 'create table TD_REVENUE_DAILY_REPORT_T (
	start_date DATE,
	TOTAL_NO_MSGS VARCHAR2(50),
	BILLED_REVENUE VARCHAR2(50),
	CREDITS_REFUNDS VARCHAR2(50),
	MSGS_TO_NZ VARCHAR2(50),
	BR_NZ VARCHAR2(50),
	MSGS_TO_AUS_USA VARCHAR2(50),
    BR_AUS_USA VARCHAR2(50),
	MSGS_TO_OTHER VARCHAR2(50),
	BR_OTHER VARCHAR2(50))';
    EXECUTE IMMEDIATE v_ddl_stmt;	
	else 
v_ddl_stmt := 'Insert into TD_REVENUE_DAILY_REPORT_T 
	(start_date,
	TOTAL_NO_MSGS,
	BILLED_REVENUE,
	CREDITS_REFUNDS,
	MSGS_TO_NZ,
	BR_NZ,
	MSGS_TO_AUS_USA ,
	BR_AUS_USA,
	MSGS_TO_OTHER ,
	BR_OTHER)
	select 
(select (TO_DATE(''$sql_currdate'')) from dual) as "start_date",
(select count(1) from pin.event_bal_impacts_t eb, pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=1000116
and  tba.start_t >= (TO_DATE(''$sql_currdate''))
and tba.start_t < ((TO_DATE(''$sql_currdate'')+ 1))) as "total no of msgs",
(select sum(eb.amount) as "BR_AUS_USA" from pin.event_bal_impacts_t eb, pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554
and tba.start_t >= (TO_DATE(''$sql_currdate''))
and tba.start_t < ((TO_DATE(''$sql_currdate'')+ 1))) as "billed revenue",
(select sum(eb.amount) as "Credits_refunds" from pin.event_bal_impacts_t eb, pin.TMP_TD_BSMS_ADJ_ALL_T tba where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554
and tba.start_t >= (TO_DATE(''$sql_currdate''))
and tba.start_t < ((TO_DATE(''$sql_currdate'')+ 1))) as "Credits_refunds",
(select count(1) from pin.event_bal_impacts_t eb, pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and eb.impact_category =''NZLOC'' and eb.RESOURCE_ID=1000116
and tba.start_t >= (TO_DATE(''$sql_currdate''))
and tba.start_t < ((TO_DATE(''$sql_currdate'')+ 1))) as "no of msgs to NZ numbers",
(select sum(eb.amount) from  pin.tmp_td_bsms_all_t tba,pin.event_bal_impacts_t eb
where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554  and eb.impact_category  =''NZLOC''
and tba.start_t >= (TO_DATE(''$sql_currdate''))
and tba.start_t < (TO_DATE(''$sql_currdate'')+ 1)) as "BR_NZ",
(select count(1) from pin.event_bal_impacts_t eb,pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and  eb.impact_category  in (''NZAUS'',''NZUSA'') and eb.RESOURCE_ID=1000116
and tba.start_t >= (TO_DATE(''$sql_currdate''))
and tba.start_t < (TO_DATE(''$sql_currdate'')+ 1)) as "no of msgs to AUS/USA",
(select sum(eb.amount) from  pin.tmp_td_bsms_all_t tba,pin.event_bal_impacts_t eb
where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554  and eb.impact_category  in (''NZAUS'',''NZUSA'')
and tba.start_t >= (TO_DATE(''$sql_currdate''))
and tba.start_t < (TO_DATE(''$sql_currdate'')+ 1)) as "BR_AUS/USA",
(select count(1) from pin.event_bal_impacts_t eb,pin.tmp_td_bsms_all_t tba where eb.obj_id0=tba.epoid and eb.impact_category  =''NZOTH'' and eb.RESOURCE_ID=1000116
and tba.start_t >= (TO_DATE(''$sql_currdate''))
and tba.start_t < (TO_DATE(''$sql_currdate'')+ 1)) as "no of msgs to OTHER numbers",
(select sum(eb.amount) from pin.tmp_td_bsms_all_t tba,pin.event_bal_impacts_t eb where eb.obj_id0=tba.epoid and eb.RESOURCE_ID=554  and eb.impact_category =''NZOTH''
and tba.start_t >= (TO_DATE(''$sql_currdate''))
and tba.start_t < (TO_DATE(''$sql_currdate'')+ 1)) as "BR_OTH"
from dual';
		EXECUTE IMMEDIATE v_ddl_stmt;
		end if;
v_ddl_stmt := 'commit';
	EXECUTE IMMEDIATE v_ddl_stmt;
        
		
END;
/

exit;
EOF

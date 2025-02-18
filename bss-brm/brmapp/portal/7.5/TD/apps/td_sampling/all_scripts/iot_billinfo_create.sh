#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_billinfo_create.log/'`
actg_dom=$1;
echo $LOGINSQL
$ORACLE_HOME/bin/sqlplus -s $LOGINSQL>>$outfile<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200
set serveroutput on size 2000


DECLARE

        v_ddl_stmt VARCHAR2(4000);
        v_errmsg VARCHAR2(200);
        v_count number(5) := 0;

BEGIN

        select count(1) into v_count from user_tables where table_name='IOT_PCFT_T';

        if v_count <> 1
        then

v_ddl_stmt := 'CREATE TABLE IOT_PCFT_T (obj_id0, CHARGED_FROM_T,CHARGED_TO_T,MONTHS_BETWEEN,  CONSTRAINT pk_iot_pcft_x PRIMARY KEY(obj_id0) )
ORGANIZATION INDEX
as
select /*+ full(pcft) parallel(pcft,4) */ obj_id0, CHARGED_FROM_T,CHARGED_TO_T, months_between( unix_to_date(pcft.CHARGED_TO_T), unix_to_date(pcft.CHARGED_FROM_T)) MONTHS_BETWEEN
from purchased_product_cycle_fees_t pcft where rec_id=1';

        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;

        select count(1) into v_count from user_tables where table_name='IOT_BILLINFO_T';

        if v_count <> 1
        then

v_ddl_stmt := 'CREATE TABLE IOT_BILLINFO_T (item_poid_id0, billinfo_poid_id0, CONSTRAINT pk_iot_billinfo_x PRIMARY KEY(item_poid_id0) ) 
ORGANIZATION INDEX 
as
select it.poid_id0, bi.poid_id0
from billinfo_t bi, item_t it
where bi.poid_id0=it.billinfo_obj_id0
and bi.next_bill_t=(select td_nz_to_unix(to_date(''$actg_dom'', ''YYYYMMDD'')) from dual)
and bi.billing_status<>1
and it.status=1
and bi.pay_type not in (10000,10007)';

        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;

        select count(1) into v_count from user_tables where table_name='TD_USGEVENT_DETAILS';

        if v_count <> 1
        then

v_ddl_stmt := 'create table td_usgevent_details nologging parallel 4
as
select /*+ full(iot) full(evt) full(ebi) full(edsc) full(eds) parallel(iot,4) parallel(evt,4) parallel(ebi,4) parallel(edsc,4) parallel(eds,4)*/ 
iot.ITEM_POID_ID0, iot.billinfo_poid_id0 poid_id0, evt.poid_id0 event_poid_id0, evt.descr, evt.poid_type, ebi.gl_id, edsc.ORIGINATING_ZONE, edsc.DESTINATION_ZONE,ebi.AMOUNT,edsc.ACCOUNT_TYPE, edsc.cash_amount_quantity,edsc.OVERRIDDEN_TARIFF_PLAN, eds.called_to,evt.start_t, evt.service_obj_id0,ebi.product_obj_id0,ebi.offering_obj_id0,ebi.tax_code,eds.usage_type
from IOT_BILLINFO_T iot, 
event_t evt, event_bal_impacts_t ebi, event_dlyd_session_custom_t edsc, event_dlay_sess_tlcs_t eds
where evt.poid_id0=ebi.obj_id0
and evt.poid_id0=edsc.obj_id0
and evt.poid_id0=eds.obj_id0
and ebi.RESOURCE_ID=554
and iot.item_poid_id0=evt.item_obj_id0
and evt.poid_id0>(select to_number(to_char((to_date(sysdate-60) - to_date(''1-Jan-1970'') + 1)*power(2,44)) + power(2,60)) from dual)';

        EXECUTE IMMEDIATE v_ddl_stmt;

v_ddl_stmt := 'create index td_glid_idx on td_usgevent_details(gl_id) nologging parallel 4';
	EXECUTE IMMEDIATE v_ddl_stmt;
        end if;

       select count(1) into v_count from user_tables where table_name='TD_BSMS_USGDETAILS_T';

        if v_count <> 1
        then

v_ddl_stmt := 'create table TD_BSMS_USGDETAILS_T nologging parallel 4
as
select /*+ full(e) full(es) full(it) parallel(e,4) parallel(es,4) parallel(it,4)*/
tud.POID_ID0,tud.item_poid_id0 ITEM_POID
from pin.event_bal_impacts_t ebi,pin.td_usgevent_details tud
where ebi.obj_id0=tud.event_poid_id0
and tud.poid_type=''/event/delayed/session/telco/gsm/sms''
and ebi.RESOURCE_ID=1000116';

        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;


END;
/

exit;
EOF

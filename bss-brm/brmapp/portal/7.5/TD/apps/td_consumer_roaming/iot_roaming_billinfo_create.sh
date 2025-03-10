#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_roaming_billinfo_create.log/'`
evt_poid_type=`egrep -v "#" login.cfg | grep "evt_poid_type" |cut -d'=' -f2`
evt_mp_poid_type=`egrep -v "#" login.cfg | grep "evt_mp_poid_type" |cut -d'=' -f2`
actg_dom=$1;
echo $actg_dom
echo $LOGINSQL
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
		v_count1 number(5) := 0;
BEGIN
        select count(1) into v_count from user_tables where table_name='IOT_CONSUMER_BILLINFO_T';
        if v_count <> 1
        then
v_ddl_stmt := 'CREATE TABLE IOT_CONSUMER_BILLINFO_T (item_poid_id0, billinfo_poid_id0,bill_info_id,pay_type, CONSTRAINT pk_iot_consumer_billinfo_x PRIMARY KEY(item_poid_id0)) 
ORGANIZATION INDEX 
as
select it.poid_id0, bi.poid_id0,bi.bill_info_id,bi.pay_type
from billinfo_t bi, item_t it
where bi.poid_id0=it.billinfo_obj_id0
and bi.next_bill_t=(select pin.td_nz_to_unix(to_date(''$actg_dom'', ''YYYYMMDD'')) from dual)
and bi.billing_status<>1
and it.status=1
and bi.pay_type not in (10000,10007)';

        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;
        select count(1) into v_count from user_tables where table_name='TMP_MISTAKEN_PURCHASE_T';

        if v_count <> 1
        then

v_ddl_stmt := 'create table tmp_mistaken_purchase_t  
as 
select  /*+ full(iot) full(et) full(es) parallel(iot,4) parallel(et,4) parallel(es,4)*/
count(1) as count,es.calling_from as name, et.account_obj_id0,et.item_obj_id0, TO_DATE(TRUNC(td_unix_to_nz(et.start_t))) as start_date
from pin.IOT_CONSUMER_BILLINFO_T iot,pin.event_t et,pin.event_dlay_sess_tlcs_t es
where et.descr = ''\$7 Daily Roaming'' 
and et.poid_id0=es.obj_id0
and iot.item_poid_id0=et.item_obj_id0
and et.poid_type=''/event/delayed/session/telco/gsm/valuepack''
and et.poid_id0>(select to_number(to_char((to_date(sysdate-60) - to_date(''1-Jan-1970'') + 1)*power(2,44)) + power(2,60)) from dual)
group by es.calling_from,et.account_obj_id0,et.item_obj_id0, TO_DATE(TRUNC(td_unix_to_nz(et.start_t))) 
having count(1)>=1';


    EXECUTE IMMEDIATE v_ddl_stmt;
	v_ddl_stmt := 'create index td_startdate_idx on tmp_mistaken_purchase_t(start_date) nologging parallel 4';
	EXECUTE IMMEDIATE v_ddl_stmt;
	v_ddl_stmt := 'create index td_name_idx on tmp_mistaken_purchase_t(name) nologging parallel 4';
	EXECUTE IMMEDIATE v_ddl_stmt;	
	v_ddl_stmt := 'create index td_itemobj_idx on tmp_mistaken_purchase_t(item_obj_id0) nologging parallel 4';
	EXECUTE IMMEDIATE v_ddl_stmt;	
        end if;

       select count(1) into v_count from user_tables where table_name='TMP_SHARES_MSISDN_T';

        if v_count <> 1
        then

v_ddl_stmt := 'create table TMP_SHARES_MSISDN_T (SHARERS_MSISDN VARCHAR2(50) )';
        EXECUTE IMMEDIATE v_ddl_stmt;
		end if;
	
		select count(1) into v_count from user_tables where table_name='TMP_SHARES_MSISDN_T';
        if v_count = 1
        then
v_ddl_stmt :='Insert into TMP_SHARES_MSISDN_T (SHARERS_MSISDN) select /*+ full(e) full(ecs) full(tmp) parallel(e,4) parallel(ecs,4) parallel(tmp,4)*/ distinct ecs.SHARERS_MSISDN from pin.event_t e, pin.EVENT_DLYD_SESSION_CUSTOM_T ecs ,pin.tmp_mistaken_purchase_t tmp
where e.poid_id0=ecs.obj_id0 
and tmp.name =ecs.SHARERS_MSISDN
and ecs.SHARERS_MSISDN is not null 
and e.start_t > td_nz_to_unix(tmp.START_DATE)
and e.start_t < td_nz_to_unix((tmp.START_DATE)+1)';
		EXECUTE IMMEDIATE v_ddl_stmt;
		end if;
		
		select count(1) into v_count1 from DUAL;
		if v_count1 = 1
        then
		v_ddl_stmt := 'Insert into PIN.TMP_SHARES_MSISDN_T ( SHARERS_MSISDN ) values (''2020200200'')';
		EXECUTE IMMEDIATE v_ddl_stmt;
		end if;
		
		v_ddl_stmt := 'commit';
		EXECUTE IMMEDIATE v_ddl_stmt;
		
		v_ddl_stmt := 'create index td_msisdn_idx on PIN.TMP_SHARES_MSISDN_T(SHARERS_MSISDN) nologging parallel 4';
		EXECUTE IMMEDIATE v_ddl_stmt;
		
		 select count(1) into v_count from user_tables where table_name='TMP_VALUEPACKS_MSISDN_FOUND_T';

        if v_count <> 1
        then
v_ddl_stmt := 'create table TMP_VALUEPACKS_MSISDN_FOUND_T nologging parallel 4
as

select 
/*+ full(e) full(tmp) full(a) full(st) full(act) full(eb) full(iot) parallel(e,4) parallel(tmp,4) parallel(a,4) parallel(st,4) parallel(act,4)  parallel(eb,4) pparallel(iot,4) */
row_number() over(partition by st.name,act.FIRST_NAME,act.LAST_NAME,act.EMAIL_ADDR,a.account_no,iot.bill_info_id,
TO_DATE(TRUNC(td_unix_to_nz(e.start_t))),eb.amount,tmp.ACCOUNT_OBJ_ID0,tmp.item_OBJ_ID0 
order by TO_DATE(TRUNC(td_unix_to_nz(e.start_t)))) row_num,

st.name as MSISDN,act.FIRST_NAME ,act.LAST_NAME , act.EMAIL_ADDR ,a.account_no ,iot.bill_info_id ,
TO_DATE(TRUNC(td_unix_to_nz(e.start_t))) as Start_date,eb.amount ,tmp.ACCOUNT_OBJ_ID0,tmp.item_OBJ_ID0
from pin.event_t e,pin.TMP_MISTAKEN_PURCHASE_t tmp,pin.account_t a, pin.service_alias_list_t st,pin.account_nameinfo_t act,
pin.event_bal_impacts_t eb,pin.IOT_CONSUMER_BILLINFO_T iot
where 
e.ACCOUNT_OBJ_ID0 = tmp.ACCOUNT_OBJ_ID0 
and e.ITEM_OBJ_ID0 = tmp.item_obj_id0
and e.start_t >= td_nz_to_unix(tmp.START_DATE)
and e.start_t <= td_nz_to_unix((tmp.START_DATE)+1)
and st.obj_id0=e.service_obj_id0
and iot.item_poid_id0=e.item_obj_id0
and a.poid_id0=e.account_obj_id0
and act.obj_id0=a.poid_id0
and eb.obj_id0=e.poid_id0
and tmp.name not in (SELECT SHARERS_MSISDN FROM pin.tmp_shares_msisdn_t)
and e.POID_TYPE not in $evt_poid_type
and e.descr = ''\$7 Daily Roaming''
and not exists (select tmp1.name from pin.event_t e1,pin.TMP_MISTAKEN_PURCHASE_t tmp1 where 
 e1.ITEM_OBJ_ID0 = tmp1.item_obj_id0 
and tmp.ACCOUNT_OBJ_ID0 = tmp1.ACCOUNT_OBJ_ID0 
and tmp1.ITEM_OBJ_ID0 = tmp.item_obj_id0
and tmp1.count >=1
and e1.start_t >= td_nz_to_unix(tmp.START_DATE)
and e1.start_t <= td_nz_to_unix((tmp.START_DATE)+1)
and e1.POID_TYPE  in $evt_poid_type)';

        EXECUTE IMMEDIATE v_ddl_stmt;
		v_ddl_stmt := 'create index td_msisdn_tmvf_idx on pin.TMP_VALUEPACKS_MSISDN_FOUND_T(MSISDN) nologging parallel 4';
		EXECUTE IMMEDIATE v_ddl_stmt;
		v_ddl_stmt := 'create index td_rownum_tmvf_idx on TMP_VALUEPACKS_MSISDN_FOUND_T(row_num) nologging parallel 4';
		EXECUTE IMMEDIATE v_ddl_stmt;
		v_ddl_stmt := 'create index td_billinfoid_tmvf_idx on TMP_VALUEPACKS_MSISDN_FOUND_T(bill_info_id) nologging parallel 4';
		EXECUTE IMMEDIATE v_ddl_stmt;
		end if;
		
		select count(1) into v_count from user_tables where table_name='TMP_MULTI_VP_AND_USG_T';

        if v_count <> 1
        then
v_ddl_stmt := 'create table TMP_MULTI_VP_AND_USG_T nologging parallel 4
as

select 
/*+ full(et) full(tmpt) full(ac) full(sat) full(acct) full(ebt) full(iott) parallel(et,4) parallel(tmpt,4) parallel(ac,4) parallel(sat,4) parallel(acct,4)  parallel(ebt,4) pparallel(iott,4) */
(row_number() over (partition by sat.name,acct.FIRST_NAME,acct.LAST_NAME,acct.EMAIL_ADDR,ac.account_no,iott.bill_info_id,
TO_DATE(TRUNC(td_unix_to_nz(et.start_t))),ebt.amount,tmpt.ACCOUNT_OBJ_ID0,tmpt.item_OBJ_ID0 
order by TO_DATE(TRUNC(td_unix_to_nz(et.start_t))))-1) as row_num,
  sat.name,acct.FIRST_NAME,acct.LAST_NAME,acct.EMAIL_ADDR,ac.account_no,iott.bill_info_id,TO_DATE(TRUNC(td_unix_to_nz(et.start_t))) as start_date,
 ebt.amount,tmpt.ACCOUNT_OBJ_ID0,tmpt.item_OBJ_ID0
from pin.event_t et,pin.TMP_MISTAKEN_PURCHASE_t tmpt,pin.account_t ac, pin.service_alias_list_t sat,pin.account_nameinfo_t acct,
pin.event_bal_impacts_t ebt,pin.IOT_CONSUMER_BILLINFO_T iott
where 
et.ACCOUNT_OBJ_ID0 = tmpt.ACCOUNT_OBJ_ID0 
and et.ITEM_OBJ_ID0 = tmpt.item_obj_id0
and et.start_t >= td_nz_to_unix(tmpt.START_DATE)
and et.start_t <= td_nz_to_unix((tmpt.START_DATE)+1)
and sat.obj_id0=et.service_obj_id0
and iott.item_poid_id0=et.item_obj_id0
and ac.poid_id0=et.account_obj_id0
and acct.obj_id0=ac.poid_id0
and ebt.obj_id0=et.poid_id0
and et.POID_TYPE  in $evt_mp_poid_type
and et.descr = ''\$7 Daily Roaming''
and tmpt.count >1';

        EXECUTE IMMEDIATE v_ddl_stmt;
		v_ddl_stmt := 'create index td_msisdn_tmvu_idx on pin.TMP_MULTI_VP_AND_USG_T(NAME) nologging parallel 4';
		EXECUTE IMMEDIATE v_ddl_stmt;
		v_ddl_stmt := 'create index td_rownum_tmvu_idx on pin.TMP_MULTI_VP_AND_USG_T(row_num) nologging parallel 4';
		EXECUTE IMMEDIATE v_ddl_stmt;
		v_ddl_stmt := 'create index td_billinfoid_tmvu_idx on pin.TMP_MULTI_VP_AND_USG_T(bill_info_id) nologging parallel 4';
		EXECUTE IMMEDIATE v_ddl_stmt;
		end if;
		
		select count(1) into v_count from user_tables where table_name='TMP_VP_TO_ADJUST_T';

        if v_count <> 1
        then
v_ddl_stmt := 'create table TMP_VP_TO_ADJUST_T nologging parallel 4
as

(select tvmf.* ,''N'' as Flag from pin.TMP_VALUEPACKS_MSISDN_FOUND_T tvmf) 
union
(select  tmvu.*, (case when row_num = 0 then ''Y'' else ''N'' END) as flag  from pin.TMP_MULTI_VP_AND_USG_T tmvu)';

        EXECUTE IMMEDIATE v_ddl_stmt;
		v_ddl_stmt := 'create index td_billinfoid_tma_idx on TMP_MULTI_VP_AND_USG_T(start_date) nologging parallel 4';
		EXECUTE IMMEDIATE v_ddl_stmt;
		end if;
		
		
END;
/

exit;
EOF

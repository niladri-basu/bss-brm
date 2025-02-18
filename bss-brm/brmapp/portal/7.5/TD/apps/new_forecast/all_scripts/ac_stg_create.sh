#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/stg_create.log/'`
$ORACLE_HOME/bin/sqlplus -s $LOGINSQL>$outfile<<EOF
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
	v_dml_stmt VARCHAR2(4000);
	v_errmsg VARCHAR2(200);
	v_count number(5) := 0;

BEGIN
	
	select count(1) into v_count from user_tables where table_name='AC_FORECAST_STAGING_T';

	if v_count <> 0
	then
	v_ddl_stmt := 'DROP TABLE AC_FORECAST_STAGING_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;

        v_ddl_stmt :=  'create table AC_FORECAST_STAGING_T nologging as
	select /*+ full(at) full(bt) full(bgt) full(st) full(sat) full(ppt) full(ppcft) full(iot) full(csgt)*/
		bt.account_obj_id0 ,  bt.poid_id0 as billinfo_obj_id0,ppt.poid_id0 as offering_obj_id0,
                        ppt.product_obj_id0, at.currency, iot.gl_id, iot.tax_code,
                        bt.actg_cycle_dom actg_dom, bt.last_bill_t, bt.next_bill_t, at.account_no,  bt.bill_info_id,
                        iot.name,
                        pcft.charged_from_t charge_from, pcft.charged_to_t charge_to,
                        ppt.status_flags override_flag, ppt.cycle_fee_amt override_amt,
                        iot.fix_amount, iot.scaled_amount, iot.prorate_first, iot.cycle_fee_flags, 
                        iot.p_flags,ppt.node_location
                        from account_t at, billinfo_t bt,
                        purchased_product_t ppt, purchased_product_cycle_fees_t pcft, 
                        ac_iot_arrear_product_t iot
                        where at.poid_id0=bt.account_obj_id0
                        and at.poid_id0 = ppt.account_obj_id0
                        and ppt.poid_id0=pcft.obj_id0
                        and ppt.product_obj_id0=iot.poid_id0
                        and ppt.status=1
                        and bt.billing_status<>1';
        EXECUTE IMMEDIATE v_ddl_stmt;

END;
/

exit;
EOF

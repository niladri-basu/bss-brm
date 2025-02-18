#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/stg_create.log/'`
dom=$1
next_t=$2
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
	
	select count(1) into v_count from user_tables where table_name='TD_PREBILL_STAGING_T';

	if v_count <> 0
	then
	v_ddl_stmt := 'DROP TABLE TD_PREBILL_STAGING_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;

        v_ddl_stmt :=  'create table td_prebill_staging_t nologging as
			select /*+ full(at) full(bt) full(bgt) full(st) full(sat) full(ppt) full(ppcft) full(iot) full(csgt)*/ 
            		$dom as actg_dom, bt.last_bill_t, bt.next_bill_t, at.account_no, csgt.cust_seg_desc, bt.bill_info_id, iot.name, iot.tax_code,
			pcft.charged_from_t charge_from, pcft.charged_to_t charge_to, 
			ppt.status_flags override_flag, ppt.cycle_fee_amt override_amt,
			iot.fix_amount, iot.scaled_amount, iot.prorate_first, iot.cycle_fee_flags, sat.name MSISDN, iot.p_flags,ppt.node_location
			from account_t at, billinfo_t bt, bal_grp_t bgt, service_t st, service_alias_list_t sat,
			purchased_product_t ppt, purchased_product_cycle_fees_t pcft, iot_arrear_product_t iot, config_customer_segment_t csgt
			where at.poid_id0=bt.account_obj_id0
			and bt.poid_id0=bgt.billinfo_obj_id0
			and bgt.poid_id0=st.bal_grp_obj_id0
			and st.poid_id0=ppt.service_obj_id0
			and st.poid_id0=sat.obj_id0
			and sat.rec_id=1
			and ppt.poid_id0=pcft.obj_id0
			and ppt.product_obj_id0=iot.poid_id0
			and ppt.status=1
			and bt.next_bill_t=$next_t
            		and at.cust_seg_list=csgt.rec_id
			and bt.billing_status<>1
			and (pcft.charged_from_t >= bt.last_bill_t and pcft.charged_from_t  <= bt.next_bill_t)
			and (pcft.charged_to_t >= bt.last_bill_t and pcft.charged_to_t  <= bt.next_bill_t)
			and pcft.charged_from_t <> pcft.charged_to_t';

        EXECUTE IMMEDIATE v_ddl_stmt;

END;
/

exit;
EOF

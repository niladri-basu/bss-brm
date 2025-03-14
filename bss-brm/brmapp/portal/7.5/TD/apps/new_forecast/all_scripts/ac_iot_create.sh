#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_create.log/'`


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
        v_errmsg VARCHAR2(200);
        v_count number(5) := 0;

BEGIN

        select count(1) into v_count from user_tables where table_name='IOT_ARREAR_PRODUCT_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE IOT_ARREAR_PRODUCT_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;

        v_ddl_stmt :=  'CREATE TABLE IOT_ARREAR_PRODUCT_T (poid_id0, name, fix_amount, scaled_amount, tax_code, cycle_fee_flags, prorate_first, p_flags, 			     count,
			CONSTRAINT pk_iot_arrear_prod_x PRIMARY KEY(poid_id0) ) 
			ORGANIZATION INDEX 
			as
			select pt.poid_id0, pt.name, rbi.fix_amount, rbi.scaled_amount, rpt.tax_code, rpt.cycle_fee_flags, rt.prorate_first, rbi.flags, 			     count(1) cnt
			from product_t pt, product_usage_map_t pumt, rate_plan_t rpt, rate_t rt, rate_quantity_tiers_t rtt, rate_bal_impacts_t rbi
			where pt.poid_id0=pumt.obj_id0
			and pt.poid_id0=rpt.product_obj_id0
			and rpt.poid_id0=rt.rate_plan_obj_id0
			and rt.poid_id0=rbi.obj_id0
			and rt.poid_id0=rtt.obj_id0
			and rbi.element_id=554
			and pumt.event_type=''/event/billing/product/fee/cycle/cycle_arrear''
			and rpt.event_type=''/event/billing/product/fee/cycle/cycle_arrear''
			group by pt.name, pt.poid_id0, rbi.fix_amount, rbi.scaled_amount, rpt.tax_code, rpt.cycle_fee_flags, rt.prorate_first, rbi.flags
			having count(1)=1';


        EXECUTE IMMEDIATE v_ddl_stmt;


END;
/

exit;
EOF


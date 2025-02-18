#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/report_create.log/'`
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

        select count(1) into v_count from user_tables where table_name='AC_FORECAST_REPORT_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE AC_FORECAST_REPORT_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;


 v_ddl_stmt :=  'create table ac_forecast_report_t as
		select td.account_obj_id0, td.billinfo_obj_id0, td.offering_obj_id0, td.product_obj_id0, td.currency, td.gl_id, 
		td.TAX_CODE, td.CHARGE_FROM EARNED_START_T, td.CHARGE_TO EARNED_END_T,1 as QUANTITY,
case
                 when override_flag in (33554432,33554433,33554440) and prorate_first=702 and p_flags in (2,3,6,10,7,11,14,15)
                 then round((((td_unix_to_nz(charge_to)-td_unix_to_nz(charge_from))/EXTRACT(DAY FROM LAST_DAY(td_unix_to_nz(charge_from)))) * (override_amt+fix_amount)),6)
                 when override_flag in (33554432,33554433,33554440) and prorate_first=702 and p_flags not in (2,3,6,10,7,11,14,15)
                 then round(override_amt+fix_amount,6)
                 when override_flag in (33554432,33554433,33554440) and prorate_first=701
                 then round(override_amt+fix_amount,6)
                 when override_flag in (33554432,33554433,33554440) and prorate_first=0
                 then round(override_amt+fix_amount,6)
                 when override_flag in (33554432,33554433,33554440) and prorate_first=703
                 then
                         case
                         when (td_unix_to_nz(charge_to)-td_unix_to_nz(charge_from))/EXTRACT(DAY FROM LAST_DAY(td_unix_to_nz(charge_from)))=1
                         then round(override_amt+fix_amount,6)
                         else
                         0
                         end
                 when override_flag in (0,1,8,9,10) and prorate_first=702 and p_flags in (2,3,6,10,7,11,14,15)
                 then round(((td_unix_to_nz(charge_to)-td_unix_to_nz(charge_from))/EXTRACT(DAY FROM LAST_DAY(td_unix_to_nz(charge_from))) * (scaled_amount+fix_amount)),6)
                 when override_flag in (0,1,8,9,10) and prorate_first=702 and p_flags not in (2,3,6,10,7,11,14,15)
                 then round(scaled_amount+fix_amount,6)
                 when override_flag in (0,1,8,9,10) and prorate_first=701
                 then round(scaled_amount+fix_amount,6)
                 when override_flag in (0,1,8,9,10) and prorate_first=0
                 then round(scaled_amount+fix_amount,6)
                 when override_flag in (0,1,8,9,10) and prorate_first=703
                 then
                    case
                         when (td_unix_to_nz(charge_to)-td_unix_to_nz(charge_from))/EXTRACT(DAY FROM LAST_DAY(td_unix_to_nz(charge_from)))=1
                         then round(scaled_amount+fix_amount,6)
                         else
                         0
                         end
                 else NULL
                 end as amount
                 from AC_FORECAST_STAGING_T td';

        EXECUTE IMMEDIATE v_ddl_stmt;




END;
/

exit;
EOF

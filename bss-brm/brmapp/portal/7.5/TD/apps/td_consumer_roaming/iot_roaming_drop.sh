#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_roaming_drop.log/'`


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

        select count(1) into v_count from user_tables where table_name='TMP_MISTAKEN_PURCHASE_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE TMP_MISTAKEN_PURCHASE_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;


        select count(1) into v_count from user_tables where table_name='TMP_SHARES_MSISDN_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE TMP_SHARES_MSISDN_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;

        select count(1) into v_count from user_tables where table_name='IOT_CONSUMER_BILLINFO_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE IOT_CONSUMER_BILLINFO_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;
		
		select count(1) into v_count from user_tables where table_name='TMP_VALUEPACKS_MSISDN_FOUND_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE TMP_VALUEPACKS_MSISDN_FOUND_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;
		
		select count(1) into v_count from user_tables where table_name='TMP_MULTI_VP_AND_USG_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE TMP_MULTI_VP_AND_USG_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;
		
		select count(1) into v_count from user_tables where table_name='TMP_VP_TO_ADJUST_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE TMP_VP_TO_ADJUST_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;
END;
/

exit;
EOF


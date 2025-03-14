#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_create.log/'`


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

        select count(1) into v_count from user_tables where table_name='IOT_SCENARIO_STATUS_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE IOT_SCENARIO_STATUS_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;

        v_ddl_stmt :=  'CREATE TABLE IOT_SCENARIO_STATUS_T (scenario_no, status, 
			CONSTRAINT pk_iot_scenariost_x PRIMARY KEY(scenario_no) ) 
			ORGANIZATION INDEX 
			as
			select distinct scenario_no, ''N'' from td_sample_account_t';


        EXECUTE IMMEDIATE v_ddl_stmt;

END;
/

exit;
EOF


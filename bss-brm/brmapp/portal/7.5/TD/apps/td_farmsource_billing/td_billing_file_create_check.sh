#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
#outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/fs_billing_create_check.log/'`
outfile=/brmapp/portal/7.5/TD/apps/td_farmsource_billing/fs_logs/fs_billing_create_check.log
#echo $outfile

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

 select count(1) into v_count from user_tables where table_name='TD_FS_BILLING_EXTRACT_T';

   WHILE v_count = 0 LOOP

        dbms_lock.sleep(10);
	select count(1) into v_count from user_tables where table_name='TD_FS_BILLING_EXTRACT_T';

   END LOOP;

END;
/

exit;
EOF


#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/td_gl_proc.log/'`

$ORACLE_HOME/bin/sqlplus -s $LOGINSQL>$outfile<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200

set serveroutput on size 2000
@./all_scripts/td_gl_billed_proc.sql;
exec td_gl_report_proc($1,$2,$3);

exit;
EOF

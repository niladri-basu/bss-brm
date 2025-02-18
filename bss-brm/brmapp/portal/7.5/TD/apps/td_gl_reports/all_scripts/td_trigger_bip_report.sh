#!/usr/bin/ksh
BIPLOGINSQL=`egrep -v "#" login.cfg | grep "BIP_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/td_bip_entry.log/'`

$ORACLE_HOME/bin/sqlplus -s $BIPLOGINSQL>$outfile<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200
set serveroutput on size 2000

insert into BIP_BRM_REPORT values (sysdate, '$1', '$2', 'N');
commit;

exit;
EOF

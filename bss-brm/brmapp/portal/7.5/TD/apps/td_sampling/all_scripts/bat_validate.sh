#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/bat_validate.log/'`

$ORACLE_HOME/bin/sqlplus -s $LOGINSQL>>$outfile<<EOF
SET WRAP ON
--
set heading off;
set feedback off;
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
--
set linesize 200
set serveroutput on size unlimited


DECLARE
	v_count number; 
    v_dml_stmt varchar2(2000);
	v_startRows number:=0;

BEGIN
	
	for rec in (select * from td_sampled_accounts_t )
	loop
			--dbms_output.put_line(' billinfo_obj_id0 ' || rec.billinfo_obj_id0);
			--dbms_output.put_line(' scenario_no ' || rec.scenario_no);
                    v_dml_stmt:='insert into td_bat_validate_t select billinfo_obj_id0, scenario_no,''N'' from td_sampled_accounts_t where billinfo_obj_id0='||rec.billinfo_obj_id0 ||' and scenario_no='''||rec.scenario_no||'''';
                    execute immediate v_dml_stmt;
					commit;
                   
		v_startRows:= v_startRows+1;
		v_dml_stmt:='';
        end loop;

END;
/

exit;
EOF


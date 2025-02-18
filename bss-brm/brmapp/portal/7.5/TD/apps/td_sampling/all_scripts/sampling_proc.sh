#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/sampling_proc.log/'`


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

        v_billinfo number;
	v_count number;
	v_dml_stmt varchar2(2000);
	v_ddl_stmt varchar2(2000);


BEGIN

	v_ddl_stmt := 'truncate table td_sampled_accounts_t';
	execute immediate v_ddl_stmt;

		loop
		    select billinfo_obj_id0 into v_billinfo 
		    from 
		    (select billinfo_obj_id0, count(1) 
		    from td_sample_account_t a, IOT_SCENARIO_STATUS_T b
		    where a.scenario_no=b.scenario_no
		    and b.status='N'
		    group by  a.billinfo_obj_id0
		    order by count(1) desc)
		    where rownum=1;    


		    v_dml_stmt:='insert into td_sampled_accounts_t select billinfo_obj_id0, scenario_no 
		    from td_sample_account_t where status=''N'' and billinfo_obj_id0='||v_billinfo;

		    execute immediate v_dml_stmt;


		    v_dml_stmt:='update IOT_SCENARIO_STATUS_T set status=''Y'' 
             			 where scenario_no in 
             			 (select scenario_no from td_sample_account_t where status=''N'' and billinfo_obj_id0='||v_billinfo||')';

		    execute immediate v_dml_stmt;

		    commit;

		    select count(1) into v_count 
		    from IOT_SCENARIO_STATUS_T 
		    where status='N';
    
		    if v_count = 0 then
		    exit;
		    end if;

		end loop;

END;
/

exit;
EOF

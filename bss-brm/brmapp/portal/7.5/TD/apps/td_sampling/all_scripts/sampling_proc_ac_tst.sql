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


set newpage 0
set space 0
set linesize 512
set pagesize 0
set echo off
set feedback off
set heading off
set recsep off
set trim on
set trims on
set termout off

spool &1;

select '# RATEPLAN'||CHR(9)||'SERVICE TYPE'
from dual;

select rp.code||CHR(9)||s.pin_servicetype
from ifw_rateplan_cnf rpc, ifw_rateplan rp, ifw_service s
where rp.rateplan = rpc.rateplan and
      s.servicecode = rpc.servicecode
group by rp.code, s.pin_servicetype;

spool out;

quit;

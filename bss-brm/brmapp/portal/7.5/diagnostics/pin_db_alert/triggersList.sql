--      Copyright (c) 2007 Oracle. All rights reserved.
--
--      This material is the confidential property of Oracle Corporation or
--      its licensors and may be used, reproduced, stored or transmitted only
--      in accordance with a valid Oracle license or sublicense agreement.
--
--
--      sql file to create the list of indexes in a given schema.
--     
----------------------------------------------------------------------------

SET LINESIZE 120;
SET PAGESIZE 3000;
SET ARRAYSIZE 5;
SET HEADING OFF;
SET FEEDBACK OFF
column column_name format A40

spool  triggersList_ACTIVETRIGGERS.out

select status, trigger_name from user_triggers;

spool off;

exit;


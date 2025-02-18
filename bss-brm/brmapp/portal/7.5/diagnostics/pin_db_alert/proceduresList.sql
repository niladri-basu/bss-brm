--  @(#) % %
--
--      Copyright (c) 2007 Oracle. All rights reserved.
--
--      This material is the confidential property of Oracle Corporation or
--      its licensors and may be used, reproduced, stored or transmitted only
--      in accordance with a valid Oracle license or sublicense agreement.
--
--
--      sql file to create the list of proceduress in a given schema.
--   
----------------------------------------------------------------------------

SET LINESIZE 132;
SET PAGESIZE 3000;
SET ARRAYSIZE 5;
SET HEADING OFF;
SET FEEDBACK OFF;
column object_name format a40
column status format a15

spool proceduresList_PROCEDURES.out

select object_name,status from user_objects where object_type in ('PROCEDURE','PACKAGE','FUNCTION');

spool off;

exit;


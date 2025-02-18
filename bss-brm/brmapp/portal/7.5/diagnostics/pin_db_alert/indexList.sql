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
SET FLUSH OFF;
SET FEEDBACK OFF;

column table_name format A30
column column_name  format A30
column index_name  format A30
column uniqueness format A9

spool indexList_INDEXES.out

SELECT
        A.table_name,
        B.column_name,
        A.index_name,
        A.uniqueness
FROM
        user_indexes A, user_ind_columns B
WHERE A.index_name = B.index_name
      and A.uniqueness = 'UNIQUE'
      and A.index_name NOT IN ( SELECT C.index_name from user_indexes C where C.index_name LIKE '%SYS%' )
ORDER BY
        A.table_name, A.index_name, B.column_position;

spool off;

exit;


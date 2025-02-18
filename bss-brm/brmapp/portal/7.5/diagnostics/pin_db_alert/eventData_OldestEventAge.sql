--
-- @(#)%Portal Version: eventData_OldestEventAge.sql:RWSmod7.3.1Int:1:2007-Jul-03 00:51:43 %
--
-- Copyright (c) 2007 Oracle. All rights reserved.
--
-- This material is the confidential property of Oracle Corporation or
-- its licensors and may be used, reproduced, stored or transmitted only
-- in accordance with a valid Oracle license or sublicense agreement.
--
-- Sql file for getting the age of the oldest record in the target table in number of days. 

set HEADING OFF;
set FEEDBACK OFF;
set FLUSH OFF;
set LINESIZE 100;
set VERIFY OFF;
set ECHO OFF;
set SERVEROUTPUT ON;
column column_name format A40;

-- &1 points to table name passed from eventData.pm.
-- &2 points to column name passed from eventData.pm.
-- &3 points to operator passed from eventData.pm.
-- &4 points to column value passed from eventData.pm.
DECLARE
	v_num_days  NUMBER;
BEGIN
	v_num_days :=0;
	select max(round(sysdate-(to_date('01-jan-1970', 'dd-mon-yyyy') + (created_t / 86400)))) into v_num_days from &1 where &2 &3 '&4' ;
	DBMS_OUTPUT.PUT_LINE('&1'||'|'||v_num_days);
END;
/
exit;

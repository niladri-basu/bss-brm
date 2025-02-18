--
-- @(#)%Portal Version: auditSize_AuditTableSize.sql:RWSmod7.3.1Int:1:2007-Jul-03 00:51:51 %
--
-- Copyright (c) 2007 Oracle. All rights reserved.
--
-- This material is the confidential property of Oracle Corporation or
-- its licensors and may be used, reproduced, stored or transmitted only
-- in accordance with a valid Oracle license or sublicense agreement.
--
-- Sql file to get the count of rows in the repective audit table.

set HEADING OFF
set FEEDBACK OFF
set FLUSH OFF
set LINESIZE 100
set VERIFY OFF
set ECHO OFF
set SERVEROUTPUT ON
column column_name format A40;

DECLARE
	v_num_rows  NUMBER;
BEGIN
	v_num_rows :=0;
	select count(*) into v_num_rows from &1;
	DBMS_OUTPUT.PUT_LINE('&1'||'|'||v_num_rows);
END;
/
exit;

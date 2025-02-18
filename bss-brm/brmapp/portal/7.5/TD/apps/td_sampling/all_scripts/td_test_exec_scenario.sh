#!/bin/sh

exec_file=$1
out_file=$2

$ORACLE_HOME/bin/sqlplus -s pin/Brm_213pin@BRMUAT >$out_file<<EOF
 SET WRAP ON
 --
 set heading off;
 set feedback off;
 SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
 --
 set linesize 200
 set serveroutput on size 2000
 @$exec_file;
 exit;
 EOF


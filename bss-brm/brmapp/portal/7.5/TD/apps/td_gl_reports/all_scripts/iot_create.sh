#!/usr/bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "OUTFILE_DIR" |cut -d'=' -f2 |sed -e 's/$/\/iot_create.log/'`


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

        v_ddl_stmt VARCHAR2(4000);
        v_ddl_stmt_t VARCHAR2(4000);
        v_errmsg VARCHAR2(200);
        v_count number(5) := 0;

BEGIN

        select count(1) into v_count from user_tables where table_name='IOT_GL_BILL_T';

        if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE IOT_GL_BILL_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;

	select count(1) into v_count from user_tables where table_name='TD_GL_REPORT_T';

	if v_count <> 0
        then
        v_ddl_stmt := 'DROP TABLE TD_GL_REPORT_T';
        EXECUTE IMMEDIATE v_ddl_stmt;
        end if;


        v_ddl_stmt :=  'CREATE TABLE IOT_GL_BILL_T (billinfo_poid, bill_poid, start_t, end_t, customer_type, 
			CONSTRAINT pk_iot_glbill_x PRIMARY KEY(bill_poid) ) 
			ORGANIZATION INDEX 
			as
			select bi.poid_id0 billinfo_poid, bl.poid_id0 bill_poid, bl.start_t, bl.end_t,
			csg.cust_seg_desc customer_type
			from account_t ac, billinfo_t bi, config_customer_segment_t csg, bill_t bl
			where ac.poid_id0=bi.account_obj_id0
			and ac.cust_seg_list=csg.rec_id(+)
			and bi.last_bill_obj_id0=bl.poid_id0
			and bl.ar_billinfo_obj_id0=bi.poid_id0
			and bl.bill_no is not null
			and bi.pay_type <> ''10000''
			and bl.end_t = $1
			and billing_status<>1
union all
			select bi.poid_id0 billinfo_poid, bl.poid_id0 bill_poid, bl.start_t, bi.next_bill_t,
                        csg.cust_seg_desc customer_type
                        from account_t ac, billinfo_t bi, config_customer_segment_t csg, bill_t bl
                        where ac.poid_id0=bi.account_obj_id0
                        and ac.cust_seg_list=csg.rec_id(+)
                        and bi.next_bill_obj_id0=bl.poid_id0
                        and bl.ar_billinfo_obj_id0=bi.poid_id0
                        and bi.pay_type <> ''10000''
                        and billing_status=1
                        and bi.next_bill_t =$1';


        EXECUTE IMMEDIATE v_ddl_stmt;

	v_ddl_stmt_t :=  'CREATE TABLE TD_GL_REPORT_T
(
  REPORT_NAME       CHAR(17 BYTE),
  BILL_CYCLE        VARCHAR2(8 BYTE),
  CUSTOMER_TYPE     VARCHAR2(1023 BYTE),
  BILL_CYCLE_START  VARCHAR2(20 BYTE),
  BILL_CYCLE_END    VARCHAR2(20 BYTE),
  GL_ID             INTEGER,
  DESCR             VARCHAR2(255 BYTE),
  TAX_CODE          VARCHAR2(255 BYTE),
  AMOUNT            NUMBER,
  COUNT               NUMBER
)';

	EXECUTE IMMEDIATE v_ddl_stmt_t;



END;
/

exit;
EOF

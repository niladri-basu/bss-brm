CREATE OR REPLACE PROCEDURE td_gl_report_proc (
   start_t    IN   NUMBER,
   end_t      IN   NUMBER,
   offset_t   IN   NUMBER
)
IS
   TYPE myarray IS TABLE OF td_gl_report_t%ROWTYPE;

   l_gl_data      myarray;
   j              NUMBER          := 0;
   k              NUMBER          := 0;
   v_ledgerpoid   NUMBER          := 0;
   ERRORS         PLS_INTEGER;
   dml_errors     EXCEPTION;
   PRAGMA EXCEPTION_INIT (dml_errors, -24381);
   v_start_t      NUMBER          := start_t;
   v_end_t        NUMBER          := end_t;
   v_offset_t     NUMBER          := offset_t;
   v_ddl_stmt     VARCHAR2 (1000);

   CURSOR cur_billedgl (ledger_poid NUMBER)
   IS
      SELECT   /*+ full(lrat) full(AT) full(act) full(bt) full(bit) full(it) parallel(lrat,4) parallel(AT,4) parallel(act,4) parallel(bt,4) parallel(bit,4) parallel(it,4) */  
	       'Bill Cycle Report' report_name,
               TO_CHAR (td_unix_to_nz ((bt.end_t + v_offset_t)),
                        'YYYYMMDD'
                       ) bill_cycle,
               ccst.cust_seg_desc customer_type,
	       case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end as TEST_ACCOUNT, 
               TO_CHAR (td_unix_to_nz ((bt.start_t + v_offset_t)),
                        'DD-Mon-YYYY'
                       ) bill_cycle_start,
               TO_CHAR (td_unix_to_nz ((bt.end_t + v_offset_t)),
                        'DD-Mon-YYYY'
                       ) bill_cycle_end,
           CASE 
                 when lrat.gl_id = '109' or lrat.gl_id ='990209000'
                    then  990209000
                 else lrat.gl_id
                 end as gl_id, 
        cgt.descr,
               CASE
                  WHEN lrat.item_name LIKE '%NIL Tax%' --or lrat.item_name like '%Upfront%' --Commented for issue 525
                     THEN NULL
                  WHEN item_name IN
                                 ('Payment', 'Payment Reversal')
                     THEN NULL
                  ELSE 'GST'
               END AS tax_code,
               SUM ((cr_ar_net_amt * -1) + db_ar_net_amt) amount,
               COUNT (1) COUNT
          FROM ledger_report_accts_t lrat,
               account_t AT,
               account_nameinfo_t act,
               bill_t bt,
               config_customer_segment_t ccst,
               config_glid_t cgt,
               billinfo_t bit,
           item_t it
         WHERE lrat.obj_id0 = ledger_poid
           --AND lrat.account_no = '0.0.0.1-23327326'
       --AND lrat.account_no in  ('502081', '502115', '502082', '502083', '502087', '502091', '502088', '502095', '502094')
           AND lrat.account_no = AT.account_no
           AND AT.poid_id0 = bt.account_obj_id0
           AND (lrat.bill_no = bt.bill_no OR lrat.bill_no = '-- N/A --')
           AND AT.cust_seg_list = ccst.rec_id(+)
           AND lrat.gl_id = cgt.rec_id(+)
           AND AT.poid_id0 = bit.account_obj_id0
           AND bit.poid_id0 = bt.ar_billinfo_obj_id0
           AND bit.last_bill_obj_id0 = bt.poid_id0
           AND bit.last_bill_t = v_end_t
           AND BIT.POID_ID0 = IT.AR_BILLINFO_OBJ_ID0
	   AND bit.pay_type <> '10000'
           AND lrat.effective_t > bt.start_t
           AND lrat.effective_t <= bt.end_t
           AND item_name NOT like 'Adjustment'
       AND lrat.item_no = it.item_no
       and act.obj_id0=AT.poid_id0
       and act.rec_id=1
           and it.billinfo_obj_id0=bit.poid_id0
      GROUP BY bt.start_t,
               ccst.cust_seg_desc,
	       case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end,
               bt.end_t,
               lrat.gl_id,
               cgt.descr,
               lrat.item_name;

   CURSOR cur_adjustmentgl (ledger_poid NUMBER)
   IS
      SELECT  /*+ full(lrat) full(AT) full(act) full(bt) full(bit) full(et) full(ebit) full(it) parallel(lrat,4) parallel(AT,4) parallel(act,4) parallel(bt,4) parallel(bit,4) parallel(et,4) parallel(ebit,4) parallel(it,4)*/ 
	       'Bill Cycle Report' report_name,
               TO_CHAR (td_unix_to_nz ((bt.end_t + v_offset_t)),
                        'YYYYMMDD'
                       ) bill_cycle,
               ccst.cust_seg_desc customer_type,
           case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end as TEST_ACCOUNT, 
               TO_CHAR (td_unix_to_nz ((bt.start_t + v_offset_t)),
                        'DD-Mon-YYYY'
                       ) bill_cycle_start,
               TO_CHAR (td_unix_to_nz ((bt.end_t + v_offset_t)),
                        'DD-Mon-YYYY'
                       ) bill_cycle_end,
               lrat.gl_id, cgt.descr,
               CASE
                  WHEN ebi.tax_code IS NULL
                     THEN NULL
                  ELSE 'GST'
               END AS tax_code,
               SUM ((cr_ar_net_amt * -1) + db_ar_net_amt) amount,
               COUNT (1) COUNT
          FROM ledger_report_accts_t lrat,
               account_t AT,
               account_nameinfo_t act,
               bill_t bt,
               config_customer_segment_t ccst,
               config_glid_t cgt,
               billinfo_t bit,
               event_t et,
               event_bal_impacts_t ebi,
               item_t it
         WHERE lrat.obj_id0 = ledger_poid
           --AND lrat.account_no = '0.0.0.1-23327326'
       --AND lrat.account_no in ('502081', '502115', '502082', '502083', '502087', '502091', '502088', '502095', '502094') 
           AND lrat.account_no = AT.account_no
           AND AT.poid_id0 = bt.account_obj_id0
           AND lrat.bill_no = '-- N/A --'
           AND lrat.item_no = it.item_no
           AND et.item_obj_id0 = it.poid_id0
           AND ebi.obj_id0 = et.poid_id0
           AND ebi.resource_id = 554
           AND et.poid_type NOT LIKE '%transfer%'
           AND ebi.amount <> 0
           AND AT.cust_seg_list = ccst.rec_id(+)
           AND lrat.gl_id = cgt.rec_id(+)
           AND AT.poid_id0 = bit.account_obj_id0
           AND bit.poid_id0 = bt.ar_billinfo_obj_id0
	   AND BIT.POID_ID0 = IT.AR_BILLINFO_OBJ_ID0
           AND bit.last_bill_obj_id0 = bt.poid_id0
           AND bit.pay_type <> '10000'
           AND bit.last_bill_t = v_end_t
           AND lrat.effective_t > bt.start_t
           AND lrat.effective_t <= bt.end_t
           and act.obj_id0=AT.poid_id0
           and act.rec_id=1
           AND item_name = 'Adjustment'
	   and et.poid_id0 > 298856056522539008
           and et.poid_id0 < 1152921504606846976
      GROUP BY bt.start_t,
               ccst.cust_seg_desc,
           case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end,
               bt.end_t,
               lrat.gl_id,
               cgt.descr,
               ebi.tax_code;
BEGIN
   SELECT poid_id0
     INTO v_ledgerpoid
     FROM ledger_report_t
    WHERE start_t = v_start_t
      AND TYPE = 2
      AND created_t IN (SELECT MAX (created_t)
                          FROM ledger_report_t
                         WHERE start_t = v_start_t AND TYPE = 2);

   v_ddl_stmt := 'truncate table td_gl_report_t';
   EXECUTE IMMEDIATE v_ddl_stmt;

   OPEN cur_billedgl (v_ledgerpoid);

   LOOP
      FETCH cur_billedgl
      BULK COLLECT INTO l_gl_data LIMIT 1000;

      FORALL j IN 1 .. l_gl_data.COUNT SAVE EXCEPTIONS
         INSERT INTO td_gl_report_t
              VALUES l_gl_data (j);
      COMMIT;
      EXIT WHEN cur_billedgl%NOTFOUND;
   END LOOP;

   CLOSE cur_billedgl;

   OPEN cur_adjustmentgl (v_ledgerpoid);

   LOOP
      FETCH cur_adjustmentgl
      BULK COLLECT INTO l_gl_data LIMIT 1000;

      FORALL k IN 1 .. l_gl_data.COUNT SAVE EXCEPTIONS
         INSERT INTO td_gl_report_t
              VALUES l_gl_data (k);
      COMMIT;
      EXIT WHEN cur_adjustmentgl%NOTFOUND;
   END LOOP;

   CLOSE cur_adjustmentgl;

   INSERT INTO td_gl_reports_exec_logs_t
        VALUES (SYSDATE, 'Bill Cycle Report', v_ledgerpoid, v_start_t,
                v_end_t);

   COMMIT;


EXCEPTION
   WHEN dml_errors
   THEN
      ERRORS := SQL%BULK_EXCEPTIONS.COUNT;
      DBMS_OUTPUT.put_line
                         (   'Number of INSERT statements that
    failed: '
                          || ERRORS
                         );
END;
/



CREATE OR REPLACE PROCEDURE td_unbilled_gl_report_proc (
   start_t    IN   NUMBER,
   end_t      IN   NUMBER,
   offset_t   IN   NUMBER
)
IS
   TYPE myarray IS TABLE OF td_gl_unbilled_report_t%ROWTYPE;

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

   CURSOR cur_unbilled_earned_gl (ledger_poid NUMBER)
   IS
      SELECT   /*+ full(lrat) full(AT) full(act) full(bit) full(ibit) parallel(lrat,4) parallel(AT,4) parallel(act,4) parallel(bit,4) parallel(ibit,4) */
      'Unbilled Revenue Report' report_name,
               TO_CHAR (td_unix_to_nz ((bit.next_bill_t + v_offset_t)),
                        'YYYYMMDD'
                       ) bill_cycle,
               ccst.cust_seg_desc customer_type,
               case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end as TEST_ACCOUNT, 
               TO_CHAR
                  (td_unix_to_nz ((bit.last_bill_t + v_offset_t)),
                   'DD-Mon-YYYY'
                  ) bill_cycle_start,
               TO_CHAR
                    (td_unix_to_nz ((bit.next_bill_t + v_offset_t)),
                     'DD-Mon-YYYY'
                    ) bill_cycle_end,
           CASE 
                 when lrat.gl_id = '109' or lrat.gl_id ='990209000'
                    then  990209000
                 else lrat.gl_id
                 end as gl_id, 
        cgt.descr,
           COUNT (1) COUNT,
               CASE
                  WHEN lrat.item_name LIKE '%NIL Tax%' --or lrat.item_name like '%Upfront%'
                     THEN NULL
                  ELSE 'GST'
               END AS tax_code,
               SUM ((cr_ar_net_amt * -1) + db_ar_net_amt) earned_amount,
               0 unearned_amount
          FROM ledger_report_accts_t lrat,
               account_t AT,
               account_nameinfo_t act,
               config_customer_segment_t ccst,
               config_glid_t cgt,
               billinfo_t bit,
	       (select /*+ full(A) parallel(A,4) */ poid_id0 FROM billinfo_t A WHERE created_t IN
	       (SELECT MIN(created_t) FROM billinfo_t B WHERE A.account_obj_id0=B.account_obj_id0 and B.pay_type <> '10000')) ibit
         WHERE lrat.obj_id0 = ledger_poid
           AND lrat.account_no = AT.account_no
           AND AT.cust_seg_list = ccst.rec_id(+)
           AND lrat.gl_id = cgt.rec_id(+)
           AND AT.poid_id0 = bit.account_obj_id0
           and act.obj_id0=AT.poid_id0
           and act.rec_id=1
           AND bit.pay_type <> '10000'
           and bit.poid_id0 = ibit.poid_id0
      GROUP BY bit.last_bill_t,
               bit.next_bill_t,
               ccst.cust_seg_desc,
               case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end,
               lrat.gl_id,
               cgt.descr,
               lrat.item_name;

   CURSOR cur_unbilled_unearned_gl (ledger_poid NUMBER)
   IS
      SELECT   /*+ full(lrat) full(AT) full(act) full(bit) full(ibit) parallel(lrat,4) parallel(AT,4) parallel(act,4) parallel(bit,4) parallel(ibit,4) */
      'Unbilled Revenue Report' report_name,
               TO_CHAR (td_unix_to_nz ((bit.next_bill_t + v_offset_t)),
                        'YYYYMMDD'
                       ) bill_cycle,
               ccst.cust_seg_desc customer_type,
               case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end as TEST_ACCOUNT, 
               TO_CHAR
                  (td_unix_to_nz ((bit.last_bill_t + v_offset_t)),
                   'DD-Mon-YYYY'
                  ) bill_cycle_start,
               TO_CHAR
                    (td_unix_to_nz ((bit.next_bill_t + v_offset_t)),
                     'DD-Mon-YYYY'
                    ) bill_cycle_end,
               lrat.gl_id, cgt.descr, 
           COUNT (1) COUNT,
               CASE
                  WHEN lrat.item_name LIKE '%NIL Tax%' --or lrat.item_name like '%Upfront%'
                     THEN NULL
                  ELSE 'GST'
               END AS tax_code,
               0 earned_amount,
               SUM ((cr_ar_net_amt * -1) + db_ar_net_amt) unearned_amount
          FROM ledger_report_accts_t lrat,
               account_t AT,
               account_nameinfo_t act,
               config_customer_segment_t ccst,
               config_glid_t cgt,
               billinfo_t bit,
	       (select /*+ full(A) parallel(A,4) */ poid_id0 FROM billinfo_t A WHERE created_t IN
	       (SELECT MIN(created_t) FROM billinfo_t B WHERE A.account_obj_id0=B.account_obj_id0 and B.pay_type <> '10000')) ibit
         WHERE lrat.obj_id0 = ledger_poid
           AND lrat.account_no = AT.account_no
           AND AT.cust_seg_list = ccst.rec_id(+)
           AND lrat.gl_id = cgt.rec_id(+)
           AND AT.poid_id0 = bit.account_obj_id0
           and act.obj_id0=AT.poid_id0
           and act.rec_id=1
           AND bit.pay_type <> '10000'
           and bit.poid_id0 = ibit.poid_id0
           GROUP BY bit.last_bill_t,
               bit.next_bill_t,
               ccst.cust_seg_desc,
               case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end,
               lrat.gl_id,
               cgt.descr,
               lrat.item_name;

   CURSOR cur_billed_payment_gl (ledger_poid NUMBER)
   IS
      SELECT   /*+ full(lrat) full(AT) full(act) full(bit) full(it) parallel(lrat,4) parallel(AT,4) parallel(act,4) parallel(bit,4) parallel(it,4) */
	       'Unbilled Revenue Report' report_name,
               TO_CHAR (td_unix_to_nz ((bit.next_bill_t + v_offset_t)),
                        'YYYYMMDD'
                       ) bill_cycle,
               ccst.cust_seg_desc customer_type,
               case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end as TEST_ACCOUNT, 
               TO_CHAR
                  (td_unix_to_nz ((bit.last_bill_t + v_offset_t)),
                   'DD-Mon-YYYY'
                  ) bill_cycle_start,
               TO_CHAR
                    (td_unix_to_nz ((bit.next_bill_t + v_offset_t)),
                     'DD-Mon-YYYY'
                    ) bill_cycle_end,
           CASE 
                 when lrat.gl_id = '109' or lrat.gl_id ='990209000'
                    then  990209000
                 else lrat.gl_id
                 end as gl_id, 
        cgt.descr,
           COUNT (1) COUNT, NULL AS tax_code,
               SUM ((cr_ar_net_amt * -1) + db_ar_net_amt) earned_amount,
               0 unearned_amount
          FROM ledger_report_accts_t lrat,
               account_t AT,
               account_nameinfo_t act,
               config_customer_segment_t ccst,
               config_glid_t cgt,
               billinfo_t bit,
               item_t it
         WHERE lrat.obj_id0 = ledger_poid
           AND lrat.account_no = AT.account_no
           AND AT.cust_seg_list = ccst.rec_id(+)
           AND lrat.gl_id = cgt.rec_id(+)
           AND lrat.item_name IN ('Payment', 'Payment Reversal')
           AND AT.poid_id0 = bit.account_obj_id0
           AND bit.pay_type <> '10000'
           AND lrat.item_no = it.item_no
           and act.obj_id0=AT.poid_id0
           and act.rec_id=1
           and it.ar_billinfo_obj_id0=bit.poid_id0
           and lrat.effective_t > bit.last_bill_t
      GROUP BY bit.last_bill_t,
               bit.next_bill_t,
               ccst.cust_seg_desc,
               case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end,
               lrat.gl_id,
               cgt.descr,
               lrat.item_name;

   CURSOR cur_billed_adjustments_gl (ledger_poid NUMBER)
   IS
      SELECT  /*+ full(lrat) full(AT) full(act) full(bit) full(et) full(ebit) full(it) parallel(lrat,4) parallel(AT,4) parallel(act,4) parallel(bit,4) parallel(et,4) parallel(ebit,4) parallel(it,4)*/ 
	       'Unbilled Revenue Report' report_name,
               TO_CHAR (td_unix_to_nz ((bit.next_bill_t + v_offset_t)),
                        'YYYYMMDD'
                       ) bill_cycle,
               ccst.cust_seg_desc customer_type,
               case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end as TEST_ACCOUNT, 
               TO_CHAR
                  (td_unix_to_nz ((bit.last_bill_t + v_offset_t)),
                   'DD-Mon-YYYY'
                  ) bill_cycle_start,
               TO_CHAR
                    (td_unix_to_nz ((bit.next_bill_t + v_offset_t)),
                     'DD-Mon-YYYY'
                    ) bill_cycle_end,
               lrat.gl_id, cgt.descr, COUNT (1) COUNT,
               CASE
                  WHEN ebi.tax_code <> 'GST'
                     THEN NULL
                  ELSE 'GST'
               END AS tax_code,
               SUM ((cr_ar_net_amt * -1) + db_ar_net_amt) earned_amount,
               0 unearned_amount
          FROM ledger_report_accts_t lrat,
               account_t AT,
               account_nameinfo_t act,
               config_customer_segment_t ccst,
               config_glid_t cgt,
               billinfo_t bit,
               item_t it,
               event_t et,
               event_bal_impacts_t ebi
         WHERE lrat.obj_id0 = ledger_poid
           AND lrat.account_no = AT.account_no
           AND AT.cust_seg_list = ccst.rec_id(+)
           AND lrat.gl_id = cgt.rec_id(+)
           AND lrat.item_name = 'Adjustment'
           AND lrat.item_no = it.item_no
           AND et.item_obj_id0 = it.poid_id0
           AND ebi.obj_id0 = et.poid_id0
           AND ebi.resource_id = 554
           AND et.poid_type NOT LIKE '%transfer%'
           AND ebi.amount <> 0
           AND AT.poid_id0 = bit.account_obj_id0
           and act.obj_id0=AT.poid_id0
           and act.rec_id=1
           and it.ar_billinfo_obj_id0=bit.poid_id0
           AND bit.pay_type <> '10000'
           and lrat.effective_t > bit.last_bill_t
	   and et.poid_id0>298856056522539008 and et.poid_id0<1152921504606846976
      GROUP BY bit.last_bill_t,
               bit.next_bill_t,
               ccst.cust_seg_desc,
               case
                    when act.company like 'TestAccount%' then 'Y'
                    else 'N'
               end,
               lrat.gl_id,
               cgt.descr,
               ebi.tax_code,
               lrat.item_name;
BEGIN
/* To begin with unbilled_earned */
   SELECT poid_id0
     INTO v_ledgerpoid
     FROM ledger_report_t
    WHERE start_t = v_start_t
      AND TYPE = 4
      AND created_t IN (SELECT MAX (created_t)
                          FROM ledger_report_t
                         WHERE start_t = v_start_t AND TYPE = 4);

   v_ddl_stmt := 'truncate table td_gl_unbilled_report_t';

   EXECUTE IMMEDIATE v_ddl_stmt;

   OPEN cur_unbilled_earned_gl (v_ledgerpoid);

   LOOP
      FETCH cur_unbilled_earned_gl
      BULK COLLECT INTO l_gl_data LIMIT 1000;

      FORALL j IN 1 .. l_gl_data.COUNT SAVE EXCEPTIONS
         INSERT INTO td_gl_unbilled_report_t
              VALUES l_gl_data (j);
      COMMIT;
      EXIT WHEN cur_unbilled_earned_gl%NOTFOUND;
   END LOOP;

   CLOSE cur_unbilled_earned_gl;

   INSERT INTO td_gl_reports_exec_logs_t
        VALUES (SYSDATE, 'Unbilled Earned Revenue Report', v_ledgerpoid,
                v_start_t, v_end_t);

   COMMIT;

   /* To begin with unbilled_unearned */
   SELECT poid_id0
     INTO v_ledgerpoid
     FROM ledger_report_t
    WHERE start_t = v_start_t
      AND TYPE = 16
      AND created_t IN (SELECT MAX (created_t)
                          FROM ledger_report_t
                         WHERE start_t = v_start_t AND TYPE = 16);

   OPEN cur_unbilled_unearned_gl (v_ledgerpoid);

   LOOP
      FETCH cur_unbilled_unearned_gl
      BULK COLLECT INTO l_gl_data LIMIT 1000;

      FORALL j IN 1 .. l_gl_data.COUNT SAVE EXCEPTIONS
         INSERT INTO td_gl_unbilled_report_t
              VALUES l_gl_data (j);
      COMMIT;
      EXIT WHEN cur_unbilled_unearned_gl%NOTFOUND;
   END LOOP;

   CLOSE cur_unbilled_unearned_gl;

   INSERT INTO td_gl_reports_exec_logs_t
        VALUES (SYSDATE, 'Unbilled Unearned Revenue Report', v_ledgerpoid,
                v_start_t, v_end_t);

   COMMIT;

   /* To begin with billed_payments */
   SELECT poid_id0
     INTO v_ledgerpoid
     FROM ledger_report_t
    WHERE start_t = v_start_t
      AND TYPE = 2
      AND created_t IN (SELECT MAX (created_t)
                          FROM ledger_report_t
                         WHERE start_t = v_start_t AND TYPE = 2);

   OPEN cur_billed_payment_gl (v_ledgerpoid);

   LOOP
      FETCH cur_billed_payment_gl
      BULK COLLECT INTO l_gl_data LIMIT 1000;

      FORALL j IN 1 .. l_gl_data.COUNT SAVE EXCEPTIONS
         INSERT INTO td_gl_unbilled_report_t
              VALUES l_gl_data (j);
      COMMIT;
      EXIT WHEN cur_billed_payment_gl%NOTFOUND;
   END LOOP;

   CLOSE cur_billed_payment_gl;

   INSERT INTO td_gl_reports_exec_logs_t
        VALUES (SYSDATE, 'Unbilled Payment Revenue Report', v_ledgerpoid,
                v_start_t, v_end_t);

   COMMIT;

   /* To begin with billed_adjustments */
   OPEN cur_billed_adjustments_gl (v_ledgerpoid);

   LOOP
      FETCH cur_billed_adjustments_gl
      BULK COLLECT INTO l_gl_data LIMIT 1000;

      FORALL j IN 1 .. l_gl_data.COUNT SAVE EXCEPTIONS
         INSERT INTO td_gl_unbilled_report_t
              VALUES l_gl_data (j);
      COMMIT;
      EXIT WHEN cur_billed_adjustments_gl%NOTFOUND;
   END LOOP;

   CLOSE cur_billed_adjustments_gl;

   INSERT INTO td_gl_reports_exec_logs_t
        VALUES (SYSDATE, 'Unbilled Adjustments Revenue Report', v_ledgerpoid,
                v_start_t, v_end_t);

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






#! /bin/ksh
LOGINSQL=`egrep -v "#" login.cfg | grep "DB_LOGIN" |cut -d'=' -f2`
outfile=`egrep -v "#" login.cfg | grep "INFILE_DIR_INPUT" |cut -d'=' -f2 |sed -e 's/$/\/input_file/'`
sqlplus -s $LOGINSQL <<EOF > $outfile
set heading off
set serveroutput off
set feedback 0
SET WRAP ON
SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD OFF TRIMS ON VERIFY OFF;
set verify off
set auto off
set termout off

select distinct
pur_prod.account_obj_id0||'|'||
rate_plan.currency||'|'||
(b.next_bill_t-1) ||'|'||
(b.next_bill_t-1) 
 value
from
purchased_product_t pur_prod, product_t prod, rate_plan_t rate_plan, 
purchased_product_cycle_fees_t cycle_fee, service_t service,billinfo_t b
where pur_prod.product_obj_id0=prod.poid_id0
and rate_plan.product_obj_id0=prod.poid_id0
and rate_plan.event_type='/event/billing/product/fee/cycle/cycle_arrear'
and rate_plan.currency = 554
and pur_prod.status=1
and pur_prod.account_obj_id0 = b.account_obj_id0
and cycle_fee.obj_id0=pur_prod.poid_id0
and service.poid_id0=pur_prod.service_obj_id0
and b.billing_status <> 1
and b.pay_type <> 10000
and pur_prod.account_obj_id0 in (1301244634,
1332315980,
1332260066,
1332365716,
1332290345,
1332297875,
1332298448,
1332255088,
1332267165,
1332350498,
1332292329,
1332321238,
1332334296,
1332317582,
1332265532)
and rownum < 1000;
clear buffer
EXIT
EOF



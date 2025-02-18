select distinct iot.billinfo_poid_id0 ||',10_688'
from purchased_product_t ppt, service_t st, product_t pt, bal_grp_t bgt, 
(select distinct billinfo_poid_id0 from IOT_BILLINFO_T) iot, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0=pt.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and ppt.status=3
and ppt.node_location='Plan Charges'
and ppt.cycle_end_t between bt.last_bill_t and (bt.next_bill_t-86401) 
and ppt.product_obj_id0 in
(select distinct poid_id0 from
(select pt.poid_id0, pt.name, rbi.fix_amount, rbi.scaled_amount, rpt.tax_code, rpt.cycle_fee_flags, rt.prorate_first, rbi.flags,      count(1) cnt
from product_t pt, product_usage_map_t pumt, rate_plan_t rpt, rate_t rt, rate_quantity_tiers_t rtt, rate_bal_impacts_t rbi
where pt.poid_id0=pumt.obj_id0
and pt.poid_id0=rpt.product_obj_id0
and rpt.poid_id0=rt.rate_plan_obj_id0
and rt.poid_id0=rbi.obj_id0
and rt.poid_id0=rtt.obj_id0
and rbi.element_id=554
and pumt.event_type='/event/billing/product/fee/cycle/cycle_arrear'
and rpt.event_type='/event/billing/product/fee/cycle/cycle_arrear'
group by pt.name, pt.poid_id0, rbi.fix_amount, rbi.scaled_amount, rpt.tax_code, rpt.cycle_fee_flags, rt.prorate_first, rbi.flags
having count(1)=1));

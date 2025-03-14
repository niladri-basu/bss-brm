select distinct iot.billinfo_poid_id0 ||',10_668'
from  purchased_product_t ppt, product_t pt, bal_grp_t brt, service_t st,
  (select distinct billinfo_poid_id0 from IOT_BILLINFO_T) iot, billinfo_t bit
where ppt.product_obj_id0 = pt.poid_id0
and ppt.service_obj_id0 = st.poid_id0
and st.bal_grp_obj_id0 = brt.poid_id0
and brt.billinfo_obj_id0 = iot.billinfo_poid_id0
and bit.poid_id0 = iot.billinfo_poid_id0
and ppt.cycle_end_t >= bit.next_bill_t
and pt.name = 'Samsung Trade Up Fee Credit' and ppt.status=1
and exists
(select 1
from  purchased_product_t ppt, product_t pt, bal_grp_t brt, service_t st
where ppt.product_obj_id0 = pt.poid_id0
and ppt.service_obj_id0 = st.poid_id0
and st.bal_grp_obj_id0 = brt.poid_id0
and iot.billinfo_poid_id0 = brt.billinfo_obj_id0
and pt.name = 'Trade Up Monthly Fee')
and exists
(select 1
from  purchased_product_t ppt, product_t pt, bal_grp_t brt, service_t st
where ppt.product_obj_id0 = pt.poid_id0
and ppt.service_obj_id0 = st.poid_id0
and st.bal_grp_obj_id0 = brt.poid_id0
and iot.billinfo_poid_id0 = brt.billinfo_obj_id0
and pt.name = 'MRO Monthly Installment'
and ppt.descr like 'Samsung%');

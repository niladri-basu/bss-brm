select distinct iot.billinfo_poid_id0 ||',10_669'
from purchased_product_t ppt, product_t  pt, service_t st, bal_grp_t bgt, billinfo_t bt, iot_billinfo_t iot
where pt.poid_id0 = ppt.product_obj_id0
and st.poid_id0 = ppt.service_obj_id0
and st.bal_grp_obj_id0 = bgt.poid_id0
and bt.poid_id0  = bgt.billinfo_obj_id0
and iot.billinfo_poid_id0 = bt.poid_id0
and iot.billinfo_poid_id0 = bgt.billinfo_obj_id0
and ppt.purchase_start_t between bt.last_bill_t and bt.next_bill_t
and pt.name = 'MRO Final Installment';

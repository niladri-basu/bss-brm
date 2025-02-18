select distinct iot.billinfo_poid_id0 ||',12_318'
from purchased_product_t ppt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0=2774260709
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.purchase_start_t between bt.last_bill_t and bt.next_bill_t
and ppt.status=1;
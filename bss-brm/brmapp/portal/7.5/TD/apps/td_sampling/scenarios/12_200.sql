select distinct iot.billinfo_poid_id0 ||',12_200'
from purchased_product_t ppt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot, billinfo_t bt,payinfo_t py
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0 in (2532898025,2532897257)
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.status=1
and py.poid_id0=bt.payinfo_obj_id0
and bt.payinfo_obj_type='/payinfo/invoice'
and py.inv_type='1';
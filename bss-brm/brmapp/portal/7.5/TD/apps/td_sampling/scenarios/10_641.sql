select distinct iot.billinfo_poid_id0 ||',10_641'
from purchased_product_t ppt, service_t st, product_t pt, bal_grp_t bgt, IOT_BILLINFO_T iot, purchased_product_cycle_fees_t pcft, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0=pt.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.poid_id0=pcft.obj_id0
and ppt.status=2
and pt.name='Trade Up Monthly Fee'
and pcft.CHARGED_TO_T between bt.last_bill_t and bt.next_bill_t;

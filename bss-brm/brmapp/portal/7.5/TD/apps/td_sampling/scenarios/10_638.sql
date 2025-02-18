select distinct iot.billinfo_poid_id0 ||',10_638'
from purchased_product_t ppt, service_t st, product_t pt, bal_grp_t bgt, IOT_BILLINFO_T iot, IOT_PCFT_T pcft, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0=pt.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.poid_id0=pcft.obj_id0
and ppt.status=1
and pt.name='MRO Monthly Installment'
and months_between<>1
and pcft.CHARGED_TO_T >= bt.next_bill_t;
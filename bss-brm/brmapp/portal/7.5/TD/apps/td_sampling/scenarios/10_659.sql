select distinct iot.billinfo_poid_id0 ||',10_659'
from purchased_discount_t ppt, service_t st, discount_t pt, bal_grp_t bgt, IOT_BILLINFO_T iot
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.DISCOUNT_OBJ_ID0=pt.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and ppt.status=1
and pt.name='Data Plan Discount';
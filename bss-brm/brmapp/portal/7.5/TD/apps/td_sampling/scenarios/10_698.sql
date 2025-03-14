select distinct iot.billinfo_poid_id0 ||',10_698'
from purchased_product_t ppt, service_t st, product_t pt, bal_grp_t bgt, IOT_BILLINFO_T iot, purchased_product_cycle_fees_t pcft
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0=pt.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and ppt.poid_id0=pcft.obj_id0
and ppt.status=1
and pt.name = 'Government Zero Plan'
and exists
(select 1
from purchased_product_t a, product_t b
where a.product_obj_id0=b.poid_id0
and a.account_obj_id0=ppt.account_obj_id0
and a.service_obj_id0=ppt.service_obj_id0
and b.name='AoG CUG Member $15');

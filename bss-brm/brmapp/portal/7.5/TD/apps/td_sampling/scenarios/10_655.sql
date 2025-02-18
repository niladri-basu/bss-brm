select distinct iot.billinfo_poid_id0 ||',10_655'
from purchased_product_t ppt, service_t st, product_t pt, bal_grp_t bgt, IOT_BILLINFO_T iot, IOT_PCFT_T pcft
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0=pt.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and ppt.poid_id0=pcft.obj_id0
and ppt.status=1
and pt.name='$149.95 Business Share Everything Plan'
and months_between<>1
and exists 
(select 1 from purchased_discount_t pd, discount_t dt 
where pd.discount_obj_id0=dt.poid_id0 and 
pd.account_obj_id0=ppt.account_obj_id0 and
pd.service_obj_id0=ppt.service_obj_id0 and 
dt.name ='Co-op Taxi Discount $30');
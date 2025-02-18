select distinct iot.billinfo_poid_id0 ||',12_161'
from purchased_product_t ppt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.PRODUCT_OBJ_ID0 in (2030802157,2030804333,1245003313,1244999729,1245002193,1656132392,1245000913,2395591117,2395594189,2402034755)
and (ppt.ACCOUNT_OBJ_ID0, ppt.SERVICE_OBJ_ID0) in (
select ppt.ACCOUNT_OBJ_ID0, ppt.SERVICE_OBJ_ID0
from purchased_product_t ppt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0=2549919655
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.status=1);
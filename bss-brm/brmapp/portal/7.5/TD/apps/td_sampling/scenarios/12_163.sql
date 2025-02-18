select distinct iot.billinfo_poid_id0 ||',12_163'
from purchased_product_t ppt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.PRODUCT_OBJ_ID0 in (1672114294,2287947738,1672117878,2287944762,2877803028,2877800724)
and (ppt.ACCOUNT_OBJ_ID0, ppt.SERVICE_OBJ_ID0) in (
select ppt.ACCOUNT_OBJ_ID0, ppt.SERVICE_OBJ_ID0
from purchased_product_t ppt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0=2549919655
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.status=1);

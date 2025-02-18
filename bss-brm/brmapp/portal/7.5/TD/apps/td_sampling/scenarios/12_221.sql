select distinct iot.billinfo_poid_id0 ||',12_221'
from purchased_product_t ppt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.status=1
and ppt.PRODUCT_OBJ_ID0 in ('2395591117','2395594189','2402034755','1245003313','1244999729','1245002193','1245000913','2528666006','2528669078','2528667542')
and (ppt.ACCOUNT_OBJ_ID0, ppt.SERVICE_OBJ_ID0) 
in (
select pp.ACCOUNT_OBJ_ID0, pp.SERVICE_OBJ_ID0
from purchased_product_t pp, service_t s, bal_grp_t bg, IOT_BILLINFO_T io, billinfo_t b,product_t p
where pp.SERVICE_OBJ_ID0=s.poid_id0
and pp.PRODUCT_OBJ_ID0=p.poid_id0
and pp.descr ='BYOD Data Only Lite'
and s.BAL_GRP_OBJ_ID0=bg.poid_id0
and io.billinfo_poid_id0=bg.BILLINFO_OBJ_ID0
and io.billinfo_poid_id0=b.poid_id0
and pp.cycle_start_t < b.LAST_BILL_T
and pp.status=1);
select distinct iot.billinfo_poid_id0 ||',11_928'
from purchased_product_t pdt, service_t st, product_t dt, bal_grp_t bgt, IOT_BILLINFO_T iot,billinfo_t bt
where pdt.SERVICE_OBJ_ID0=st.poid_id0
and bt.poid_id0=iot.BILLINFO_POID_ID0
and pdt.product_obj_id0=dt.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and pdt.status=1
and dt.name='MRO Final Installment'
and pdt.SERVICE_OBJ_ID0 in 
(
select distinct pdt.SERVICE_OBJ_ID0
from purchased_product_t pdt, service_t st, product_t dt, bal_grp_t bgt, IOT_BILLINFO_T iot,billinfo_t bt
where pdt.SERVICE_OBJ_ID0=st.poid_id0
and bt.poid_id0=iot.BILLINFO_POID_ID0
and pdt.product_obj_id0=dt.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and pdt.status=1
and dt.name='MRO Final Installment Reversal'
);
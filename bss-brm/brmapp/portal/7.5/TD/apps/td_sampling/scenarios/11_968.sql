select distinct iot.billinfo_poid_id0 ||',11_968'
from purchased_discount_t pdt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot,billinfo_t bt, profile_offer_details_data_t pdd,
profile_offer_details_t pd
where pdt.SERVICE_OBJ_ID0=st.poid_id0
and bt.poid_id0=iot.BILLINFO_POID_ID0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and bt.poid_id0=bgt.BILLINFO_OBJ_ID0
and pdt.status=1
and pdt.discount_obj_id0='123613346'
and pd.offering_obj_id0=pdt.poid_id0
and pdd.obj_id0=pd.obj_id0
and pdd.value ='1-3595892497'
and pd.LABEL='cAssociationMemberDiscount'
and pdt.cycle_start_t < bt.LAST_BILL_T
and pdt.cycle_end_t = 0;	
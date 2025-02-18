select distinct iot.billinfo_poid_id0 ||',12_166'
from purchased_discount_t pdt, service_t st, discount_t dt, bal_grp_t bgt, IOT_BILLINFO_T iot,billinfo_t bt
where pdt.SERVICE_OBJ_ID0=st.poid_id0
and bt.poid_id0=iot.BILLINFO_POID_ID0
and pdt.discount_obj_id0=dt.poid_id0
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and pdt.status=1
and dt.poid_id0='2558355158'
and pdt.cycle_start_t <= bt.LAST_BILL_T
and pdt.cycle_end_t >= bt.next_BILL_T;		
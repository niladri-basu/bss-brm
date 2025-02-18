select distinct iot.billinfo_poid_id0 ||',12_127'
from purchased_product_t ppt, service_t st, bal_grp_t bgt, IOT_BILLINFO_T iot, billinfo_t bt
where ppt.SERVICE_OBJ_ID0=st.poid_id0
and ppt.PRODUCT_OBJ_ID0=2379937883
and st.BAL_GRP_OBJ_ID0=bgt.poid_id0
and iot.billinfo_poid_id0=bgt.BILLINFO_OBJ_ID0
and iot.billinfo_poid_id0=bt.poid_id0
and ppt.status=1
and months_between(TO_DATE(trunc(unix_to_nzdate(bt.next_BILL_T)),'dd/mm/yyyy'),
                        TO_DATE(trunc(unix_to_nzdate(ppt.cycle_start_t)),'dd/mm/yyyy')) >= 1;

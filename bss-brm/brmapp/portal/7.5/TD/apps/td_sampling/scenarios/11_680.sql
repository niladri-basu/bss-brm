select distinct iot.billinfo_poid_id0 ||',11_680' 
from item_t it, billinfo_t bi, event_t et , event_billing_reversal_t ebt, (select distinct billinfo_poid_id0 from IOT_BILLINFO_T) iot
where it.poid_type = '/item/payment/reversal'
and iot.billinfo_poid_id0=bi.poid_id0
and iot.billinfo_poid_id0=it.billinfo_obj_id0
and it.billinfo_obj_id0=bi.poid_id0
and it.EFFECTIVE_T between bi.LAST_BILL_T and bi.NEXT_BILL_T
and et.item_obj_id0=it.poid_id0
and et.poid_type not like '%transfer%'
and et.poid_id0=ebt.obj_id0;
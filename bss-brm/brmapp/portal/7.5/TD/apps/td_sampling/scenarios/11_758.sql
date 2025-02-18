select distinct iot.billinfo_poid_id0 ||',11_758'
from item_t it, billinfo_t bi, event_t et , event_billing_payment_t ebt,  IOT_BILLINFO_T iot
where it.poid_type='/item/payment'
and it.billinfo_obj_id0=bi.poid_id0
and iot.billinfo_poid_id0=bi.poid_id0
and it.EFFECTIVE_T between bi.LAST_BILL_T and bi.NEXT_BILL_T
and et.item_obj_id0=it.poid_id0
and et.poid_id0=ebt.obj_id0
and et.poid_type='/event/billing/payment/poli'
and ebt.sub_trans_id is not null
and it.status = 2
and  not exists
  (select 1 from event_billing_reversal_t ebrt
  where ebrt.payment_trans_id = ebt.trans_id)
and exists
(select 1
from event_billing_payment_t ebpt1, event_t et1, item_t it1
where ebpt1.obj_id0=et1.poid_id0
and et1.item_obj_id0=it1.poid_id0
and ebpt1.sub_trans_id=ebt.sub_trans_id
having count(distinct it1.billinfo_obj_id0)>1);

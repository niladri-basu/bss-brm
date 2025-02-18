select distinct iot.billinfo_poid_id0 ||',11_771'
from item_t it, billinfo_t bi, event_t et , event_billing_payment_t ebt, IOT_BILLINFO_T iot
where it.poid_type='/item/payment'
and it.billinfo_obj_id0=bi.poid_id0
and iot.billinfo_poid_id0=bi.poid_id0
and it.EFFECTIVE_T between bi.LAST_BILL_T and bi.NEXT_BILL_T
and it.poid_id0= et.item_obj_id0
and et.poid_type='/event/billing/payment/creditcard'
and ebt.sub_trans_id is null
and et.poid_id0=ebt.obj_id0
and it.status = 2
and ebt.channel_id = 31
and  not exists
  (select 1 from event_billing_reversal_t ebrt
  where ebrt.payment_trans_id = ebt.trans_id);

select distinct billinfo_poid_id0 ||',11_757' from
(select billinfo_poid_id0, count(1) from
(select distinct iot.billinfo_poid_id0 , it.item_no
from item_t it, billinfo_t bi, event_t et , event_billing_payment_t ebt, IOT_BILLINFO_T iot
where it.poid_type='/item/payment'
and it.billinfo_obj_id0=bi.poid_id0
and iot.billinfo_poid_id0=bi.poid_id0
and it.EFFECTIVE_T between bi.LAST_BILL_T and bi.NEXT_BILL_T
and et.item_obj_id0=it.poid_id0
and et.poid_type='/event/billing/payment/poli'
and et.poid_id0=ebt.obj_id0
and ebt.sub_trans_id is null
and  not exists
  (select 1 from event_billing_reversal_t ebrt
  where ebrt.payment_trans_id = ebt.trans_id))
group by billinfo_poid_id0
having count(1) >1);

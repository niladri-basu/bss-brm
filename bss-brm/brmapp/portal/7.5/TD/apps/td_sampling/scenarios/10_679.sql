select distinct iot.billinfo_poid_id0 ||',10_679'
FROM iot_billinfo_t iot, event_t e, event_bal_impacts_t ebi , product_t p, billinfo_t bit
where e.poid_id0 = ebi.obj_id0
and ebi.product_obj_id0 = p.poid_id0
and iot.billinfo_poid_id0 = bit.poid_id0
and iot.item_poid_id0 = e.item_obj_id0
and iot.item_poid_id0 = ebi.item_obj_id0
and e.start_t between bit.last_bill_t and bit.next_bill_t
and e.poid_type = '/event/billing/product/fee/cancel'
and p.name like '%Security Deposit%';

SELECT
  DISTINCT iot.billinfo_poid_id0||'11_778'
FROM
  pin.iot_billinfo_t iot,
  pin.event_t et,
  pin.event_billing_misc_t ebt
WHERE
    iot.item_poid_id0 = et.item_obj_id0
AND et.poid_id0 = ebt.obj_id0
AND ebt.reason_domain_id = '1'
AND ebt.reason_id = '122'
AND et.poid_type IN ('/event/billing/adjustment/account');

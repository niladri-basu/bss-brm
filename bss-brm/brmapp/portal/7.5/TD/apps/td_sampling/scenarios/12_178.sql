select distinct TD.POID_ID0 ||',12_178'
from
  PIN.td_usgevent_details TD,event_bal_impacts_t eb
where
eb.obj_id0=TD.EVENT_POID_ID0
and eb.resource_id='1000116'
and eb.impact_category  ='NZAUS'
--AND TD.CALLED_TO LIKE '64%'
AND EB.RATE_TAG='T1';
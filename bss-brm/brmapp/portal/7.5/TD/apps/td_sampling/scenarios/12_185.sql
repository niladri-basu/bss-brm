select distinct TD.POID_ID0 ||',12_185'
from
  PIN.td_usgevent_details TD,event_bal_impacts_t eb
where
eb.obj_id0=TD.EVENT_POID_ID0
and eb.resource_id='1000116'
and eb.impact_category  ='NZLOC'
--AND TD.CALLED_TO LIKE '64%'
AND eb.RATE_TAG='T3';
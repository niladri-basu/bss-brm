select distinct TD.POID_ID0 ||',12_123'
from td_usgevent_details td
where td.poid_type = '/event/delayed/session/telco/gsm/valuepack'
and td.descr='Prepay Max Speed Reload';
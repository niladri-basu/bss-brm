select distinct TD.POID_ID0 ||',12_122'
from td_usgevent_details td
where td.poid_type = '/event/delayed/session/telco/gsm/valuepack'
and td.descr='40GB Max speed Data reload';
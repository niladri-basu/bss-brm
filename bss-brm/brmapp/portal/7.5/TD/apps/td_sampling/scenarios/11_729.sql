select /*+ full(td) parallel(td,2) */ distinct td.poid_id0 ||',11_729'
from td_usgevent_details td
where td.poid_type = '/event/delayed/session/telco/gsm/valuepack'
and td.descr='$15 Aussie Pack';

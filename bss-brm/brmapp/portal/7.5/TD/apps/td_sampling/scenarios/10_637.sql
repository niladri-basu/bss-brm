select /*+ full(td) parallel(td,2) */ distinct td.poid_id0 ||',10_637'
from td_usgevent_details td
where td.poid_type = '/event/delayed/session/telco/gsm/valuepack'
and td.descr='Sharing Unlimited Calls and Text Promo';
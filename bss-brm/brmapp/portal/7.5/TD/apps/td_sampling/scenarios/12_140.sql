select distinct TD.POID_ID0 ||',12_140'
from td_usgevent_details td
where td.poid_type = '/event/delayed/session/telco/gsm/sms'
and td.GL_ID='400201615'
and TD.AMOUNT='0.79';

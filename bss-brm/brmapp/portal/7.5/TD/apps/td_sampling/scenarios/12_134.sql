select distinct TD.POID_ID0 ||',12_134'
from td_usgevent_details td
where td.poid_type = '/event/delayed/session/telco/gsm/valuepack'
and td.descr='Fair Plan Add-on';
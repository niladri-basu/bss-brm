select  distinct td.poid_id0 ||',11_958'
from
td_usgevent_details td
where td.poid_type = '/event/delayed/session/telco/gsm/voice'
and td.gl_id = '300201240'
and td.AMOUNT = 0
and td.ACCOUNT_TYPE in (SELECT PC.PACKAGE_CODE_V FROM MB_PACKAGE_CLASSIFICATION PC WHERE PC.PACKAGE_CLASSIFICATION = 'Corporate');

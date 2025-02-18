INSERT INTO IFW_REF_MAP ( ID, REF_OBJ, REF_COL, REF_PARAM ) VALUES ( 
'CustomerData', '/service/telco/gsm/telephony', NULL, '/event/delayed/session/telco/gsm'); 
INSERT INTO IFW_REF_MAP ( ID, REF_OBJ, REF_COL, REF_PARAM ) VALUES ( 
'CustomerData', '/service/ip/gprs', NULL, '/event/delayed/session/gprs'); 
INSERT INTO IFW_REF_MAP ( ID, REF_OBJ, REF_COL, REF_PARAM ) VALUES (
'CustomerData', '/service/telco/gprs', NULL, '/event/delayed/session/telco/gprs');
INSERT INTO IFW_REF_MAP ( ID, REF_OBJ, REF_COL, REF_PARAM ) VALUES ( 
'CustomerData', '/service/wap/interactive', NULL, '/event/delayed/activity/wap/interactive'); 
INSERT INTO IFW_REF_MAP ( ID, REF_OBJ, REF_COL, REF_PARAM ) VALUES ( 
'CustomerData', '/service/telco/gsm/sms', NULL, '/event/delayed/session/telco/gsm'); 
INSERT INTO IFW_REF_MAP ( ID, REF_OBJ, REF_COL, REF_PARAM ) VALUES ( 
'CustomerData', '/service/telco/gsm/data', NULL, '/event/delayed/session/telco/gsm'); 
INSERT INTO IFW_REF_MAP ( ID, REF_OBJ, REF_COL, REF_PARAM ) VALUES ( 
'CustomerData', '/service/telco/gsm/fax', NULL, '/event/delayed/session/telco/gsm'); 
INSERT INTO IFW_REF_MAP ( ID, REF_OBJ, REF_COL, REF_PARAM ) VALUES (
'CustomerData', '/service/settlement/roaming/outcollect', NULL, '/event/delayed/session/telco/roaming');
INSERT INTO IFW_REF_MAP ( ID, REF_OBJ, REF_COL, REF_PARAM ) VALUES (
'CustomerData', '/service/settlement/roaming/incollect', NULL, '/event/delayed/session/telco/roaming');
commit;

INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS,
LOCARIND_VASEVENT, QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE,
INT_SERVICECLASS ) VALUES (
'ALL_RATE', 5, 'DATA Identification out of CDR', 'DAT.*', '.*', '.*', '.*', '.*'
, '.*', 'DATA', 'DEF');
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS,
LOCARIND_VASEVENT, QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE,
INT_SERVICECLASS ) VALUES (
'ALL_RATE', 6, 'FAX Identification out of CDR', 'FAX.*', '.*', '.*', '.*', '.*', '.*'
, 'FAX', 'DEF');
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS,
LOCARIND_VASEVENT, QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE,
INT_SERVICECLASS ) VALUES (
'ALL_RATE', 1, 'Telephony Identification out of CDR', 'TEL.*', '.*', '.*', '.*', '.*'
, '.*', 'TEL', 'DEF');
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS,
LOCARIND_VASEVENT, QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE,
INT_SERVICECLASS ) VALUES (
'ALL_RATE', 2, 'SMS Identification out of CDR', 'SMS.*', '.*', '.*', '.*', '.*', '.*'
, 'SMS', 'DEF');
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS,
LOCARIND_VASEVENT, QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE,
INT_SERVICECLASS ) VALUES (
'ALL_RATE', 3, 'Telco GPRS Identification out of CDR', 'GPRT.*', '.*', '.*', '.*', '.*'
, '.*', 'GPRST', 'DEF');
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS,
LOCARIND_VASEVENT, QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE,
INT_SERVICECLASS ) VALUES (
'ALL_RATE', 8, 'IP GPRS Identification out of CDR', 'GP.*', '.*', '.*', '.*', '.*'
, '.*', 'GPRSI', 'DEF');
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS,
LOCARIND_VASEVENT, QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE,
INT_SERVICECLASS ) VALUES (
'ALL_RATE', 4, 'WAP Identification out of CDR', 'WAP.*', '.*', '.*', '.*', '.*', '.*'
, 'WAP', 'DEF');
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS,
LOCARIND_VASEVENT, QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE,
INT_SERVICECLASS ) VALUES (
'ALL_RATE', 99, 'Everything else is treated as TEL', '.*', '.*', '.*', '.*', '.*'
, '.*', 'TEL', 'DEF');
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS, LOCARIND_VASEVENT,
QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE, INT_SERVICECLASS) VALUES ( 
'OUTCOLLECT', 1, 'Everything else is treated as SET_O', '.*', '.*', '.*', '.*', '.*'
, '.*', 'SET_O', 'DEF'); 
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS, LOCARIND_VASEVENT,
QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE, INT_SERVICECLASS) VALUES ( 
'INCOLLECT', 1, 'Everything else is treated as SET_I', '.*', '.*', '.*', '.*', '.*'
, '.*', 'SET_I', 'DEF');
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS, LOCARIND_VASEVENT,
QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE, INT_SERVICECLASS ) VALUES ( 
'ALL_RATE', 9, 'Telephony Identification out of CDR', '.*11', '.*', '.*', '.*', '.*'
, '.*', 'TEL', 'DEF'); 
INSERT INTO IFW_SERVICE_MAP ( MAP_GROUP, RANK, NAME, EXT_SERVICECODE, USAGECLASS, LOCARIND_VASEVENT,
QOS_REQUESTED, QOS_USED, RECORDTYPE, INT_SERVICECODE, INT_SERVICECLASS ) VALUES ( 
'ALL_RATE', 10, 'GPRS Identification out of CDR', '813', '.*', '.*', '.*', '.*', '.*'
, 'GPRST', 'DEF');
commit;

INSERT INTO IFW_DISCARDING ( PIPELINE, RANK, NAME, RECORDTYPE, SOURCE_NETWORK, CALL_COMPLETION,
LONG_DURATION, USAGECLASS, SERVICECODE, SWITCH, TARIFFCLASS, TARIFFSUBCLASS, CONNECTTYPE,
CONNECTSUBTYPE, B_NUMBER, MAX_AGE, WS_NULL ) VALUES ( 
'ALL_RATE', 1, 'Old Calls > 180 days', '.*', '.*', '.*', '.*', '.*', '.*', '.*', '.*'
, '.*', '.*', '.*', '.*', 180, 0); 

INSERT INTO IFW_DISCARDING ( PIPELINE, RANK, NAME, RECORDTYPE, SOURCE_NETWORK, CALL_COMPLETION,
LONG_DURATION, USAGECLASS, SERVICECODE, SWITCH, TARIFFCLASS, TARIFFSUBCLASS, CONNECTTYPE,
CONNECTSUBTYPE, B_NUMBER, MAX_AGE, WS_NULL ) VALUES ( 
'ALL_RATE', 3, 'Zero-Duration Calls', '.*', '.*', '03', '.*', '.*', '.*', '.*', '.*'
, '.*', '.*', '.*', '.*', NULL, 0); 
commit;
 

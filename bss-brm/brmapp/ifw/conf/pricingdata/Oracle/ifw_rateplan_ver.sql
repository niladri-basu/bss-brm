INSERT INTO IFW_RATEPLAN_VER ( RATEPLAN, VERSION, VALID_FROM, STATUS, ZONEMODEL, BASIC_RATEPLAN,
BASIC_VERSION, BASIC) VALUES ( 
20001, 1,  TO_Date( '01/01/1999 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'A', 20000
, NULL, NULL, 1); 
INSERT INTO IFW_RATEPLAN_VER ( RATEPLAN, VERSION, VALID_FROM, STATUS, ZONEMODEL, BASIC_RATEPLAN,
BASIC_VERSION, BASIC) VALUES ( 
20002, 1,  TO_Date( '01/01/1999 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'A', 20000
, NULL, NULL, 1); 
INSERT INTO IFW_RATEPLAN_VER ( RATEPLAN, VERSION, VALID_FROM, STATUS, ZONEMODEL, BASIC_RATEPLAN,
BASIC_VERSION, BASIC) VALUES ( 
20003, 1,  TO_Date( '01/01/1999 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'A', 20000
, 20002, 1, 1); 
INSERT INTO IFW_RATEPLAN_VER ( RATEPLAN, VERSION, VALID_FROM, STATUS, ZONEMODEL, BASIC_RATEPLAN,
BASIC_VERSION, BASIC) VALUES ( 
20004, 1,  TO_Date( '01/01/1999 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'A', 20000
, NULL, NULL, 1); 
INSERT INTO IFW_RATEPLAN_VER ( RATEPLAN, VERSION, VALID_FROM, STATUS, ZONEMODEL, BASIC_RATEPLAN,
BASIC_VERSION, BASIC) VALUES ( 
20005, 1,  TO_Date( '01/01/1999 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'A', 20000
, 20005, 1, 1); 
commit;
 

--
-- @(#)device_t.ctl 2
--
--     Copyright (c) 2004-2006 Oracle. All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted 
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE DEVICE_T
   (
	POID_DB 		INTEGER EXTERNAL TERMINATED BY ',',
 	POID_ID0		INTEGER EXTERNAL TERMINATED BY ',',
 	POID_TYPE		CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	CREATED_T		INTEGER EXTERNAL TERMINATED BY ',',
	ACCOUNT_OBJ_DB		INTEGER EXTERNAL TERMINATED BY ',',
	DEVICE_ID		CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	SOURCE			CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	MANUFACTURER		CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	MODEL			CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	STATE_ID		INTEGER EXTERNAL TERMINATED BY ',',
 -- Constant Values
	POID_REV		CONSTANT '0',
	READ_ACCESS		CONSTANT 'L',
	WRITE_ACCESS		CONSTANT 'A',
	ACCOUNT_OBJ_ID0		CONSTANT '1',
	ACCOUNT_OBJ_TYPE	CONSTANT '/account',
	ACCOUNT_OBJ_REV		CONSTANT '0'
-- These values will be entered as NULL
--	MOD_T			NULL
--	DESCR			NULL
    )

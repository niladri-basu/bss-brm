--
-- @(#)group_sharing_members_t.ctl 2
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
   INTO TABLE GROUP_SHARING_MEMBERS_T
   (
	OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID			INTEGER EXTERNAL TERMINATED BY ',',
	ACCOUNT_OBJ_DB		INTEGER EXTERNAL TERMINATED BY ',',
	ACCOUNT_OBJ_ID0		INTEGER EXTERNAL TERMINATED BY ',',
	SERVICE_OBJ_DB		INTEGER EXTERNAL TERMINATED BY ',',
	SERVICE_OBJ_ID0		INTEGER EXTERNAL TERMINATED BY ',',
	SERVICE_OBJ_TYPE	CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
-- Constant Values
	ACCOUNT_OBJ_TYPE	CONSTANT '/account',
	ACCOUNT_OBJ_REV		CONSTANT '0',
	SERVICE_OBJ_REV		CONSTANT '0'
   )	

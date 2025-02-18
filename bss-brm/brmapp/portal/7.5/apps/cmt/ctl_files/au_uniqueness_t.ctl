--
-- @(#)au_uniqueness_t.ctl 3
--
--     Copyright (c) 2004-2007 Oracle. All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted 
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE AU_UNIQUENESS_T
   (
	POID_DB				INTEGER EXTERNAL TERMINATED BY ',', 
	POID_ID0			INTEGER EXTERNAL TERMINATED BY ',', 
	CREATED_T			INTEGER EXTERNAL TERMINATED BY ',', 
	MOD_T				INTEGER EXTERNAL TERMINATED BY ',', 
	ACCOUNT_NO			CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"', 
	ACCOUNT_OBJ_DB			INTEGER EXTERNAL TERMINATED BY ',', 
	ACCOUNT_OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',', 
	EFFECTIVE_T			INTEGER EXTERNAL TERMINATED BY ',',
	LOGIN				CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"', 
	SERVICE_OBJ_DB			INTEGER EXTERNAL TERMINATED BY ',', 
	SERVICE_OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',', 
	SERVICE_OBJ_TYPE		CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"', 
	TYPE				INTEGER EXTERNAL TERMINATED BY ',', 
	AU_PARENT_OBJ_DB		INTEGER EXTERNAL TERMINATED BY ',', 
	AU_PARENT_OBJ_ID0		INTEGER EXTERNAL TERMINATED BY ',', 
--	Constant Values
        POID_TYPE                       CONSTANT '/au_uniqueness',
        POID_REV                        CONSTANT '0',
        READ_ACCESS                     CONSTANT 'L',
        WRITE_ACCESS                    CONSTANT 'L',
        SERVICE_OBJ_REV                 CONSTANT '0',
	STATUS				CONSTANT '2',
        ACCOUNT_OBJ_TYPE                CONSTANT '/account',
        ACCOUNT_OBJ_REV                 CONSTANT '0',
	AU_PARENT_OBJ_TYPE		CONSTANT '/uniqueness',
	AU_PARENT_OBJ_REV		CONSTANT '0',
        OBJECT_CACHE_TYPE       	CONSTANT '0'
)

--
-- @(#)ordered_balgroup_t.ctl 3
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
   INTO TABLE AU_ORDERED_BALGROUP_T
   (
	ACCOUNT_OBJ_DB                  INTEGER EXTERNAL TERMINATED BY ',',
	ACCOUNT_OBJ_ID0                 INTEGER EXTERNAL TERMINATED BY ',',
	CREATED_T                       INTEGER EXTERNAL TERMINATED BY ',',
	POID_DB                         INTEGER EXTERNAL TERMINATED BY ',',
	POID_ID0                        INTEGER EXTERNAL TERMINATED BY ',',
	SERVICE_OBJ_DB                  INTEGER EXTERNAL TERMINATED BY ',',
	SERVICE_OBJ_ID0                 INTEGER EXTERNAL TERMINATED BY ',',
	SERVICE_OBJ_TYPE                CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        EFFECTIVE_T                     INTEGER EXTERNAL TERMINATED BY ',',

-- Constant Values	
	ACCOUNT_OBJ_TYPE                CONSTANT '/account',
	ACCOUNT_OBJ_REV                 CONSTANT '0',
	POID_TYPE                       CONSTANT '/au_ordered_balgrp',
	POID_REV                        CONSTANT '1',
	READ_ACCESS                     CONSTANT 'L',
	WRITE_ACCESS                    CONSTANT 'L',
	SERVICE_OBJ_REV                 CONSTANT '1',
        OBJECT_CACHE_TYPE       	CONSTANT '0'
-- These fields will be entered as NULL
--	MOD_T				NULL
   )	

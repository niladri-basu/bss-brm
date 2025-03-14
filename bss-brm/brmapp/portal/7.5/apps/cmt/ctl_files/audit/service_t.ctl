--
-- @(#)service_t.ctl 4
--
-- Copyright (c) 2004, 2014, Oracle and/or its affiliates. All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted 
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE AU_SERVICE_T
   (
	 ACCOUNT_OBJ_DB         INTEGER EXTERNAL TERMINATED BY ',',
 	 ACCOUNT_OBJ_ID0        INTEGER EXTERNAL TERMINATED BY ',',
	 CLOSE_WHEN_T           INTEGER EXTERNAL TERMINATED BY ',',
	 CREATED_T              INTEGER EXTERNAL TERMINATED BY ',',
  	 MOD_T			INTEGER EXTERNAL TERMINATED BY ',',
	 LAST_STATUS_T          INTEGER EXTERNAL TERMINATED BY ',',
	 ITEM_POID_LIST		CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	 NEXT_ITEM_POID_LIST	CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	 LOGIN                  CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	 PASSWD                 CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	 POID_DB                INTEGER EXTERNAL TERMINATED BY ',',
	 POID_ID0               INTEGER EXTERNAL TERMINATED BY ',',
	 POID_TYPE              CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	 EFFECTIVE_T            INTEGER EXTERNAL TERMINATED BY ',',
	 SUBSCRIPTION_OBJ_DB	INTEGER EXTERNAL TERMINATED BY ',',
	 SUBSCRIPTION_OBJ_ID0	INTEGER EXTERNAL TERMINATED BY ',',
	 SUBSCRIPTION_OBJ_TYPE	CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	 BAL_GRP_OBJ_DB         INTEGER EXTERNAL TERMINATED BY ',',
	 BAL_GRP_OBJ_ID0        INTEGER EXTERNAL TERMINATED BY ',',
	 STATUS			INTEGER EXTERNAL TERMINATED BY ',',
	 STATE_EXPIRATION_T	INTEGER EXTERNAL TERMINATED BY ',',
	 SERVICE_ID             CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
-- Constant Values	 
	 ACCOUNT_OBJ_TYPE       CONSTANT '/account',
	 ACCOUNT_OBJ_REV        CONSTANT '0',
	 NAME                   CONSTANT 'PIN Service Object',
	 POID_REV               CONSTANT '1',
	 PROFILE_OBJ_DB         CONSTANT '0',	  
	 PROFILE_OBJ_ID0	CONSTANT '0',
	 PROFILE_OBJ_REV        CONSTANT '0',
	 READ_ACCESS            CONSTANT 'L',
	 STATUS_FLAGS           CONSTANT '0',
	 SUBSCRIPTION_OBJ_REV   CONSTANT '0',
	 TYPE			CONSTANT '0',
	 WRITE_ACCESS           CONSTANT 'L',
	 BAL_GRP_OBJ_TYPE	CONSTANT '/balance_group',
	 BAL_GRP_OBJ_REV        CONSTANT '0',
	 LIFECYCLE_STATE        CONSTANT '0',
         OBJECT_CACHE_TYPE      CONSTANT '0'
-- These fields will be entered as NULL
--	AAC_ACCESS		NULL
--	AAC_PACKAGE		NULL
--	AAC_PROMO_CODE		NULL
--	AAC_SERIAL_NUM		NULL
--	AAC_SOURCE		NULL
--	AAC_VENDOR		NULL
--	LASTSTAT_CMNT           NULL
-- 	PROFILE_OBJ_TYPE	NULL
   )

--
-- @(#)event_t.ctl 2
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
   INTO TABLE EVENT_T
   (
	ACCOUNT_OBJ_DB                     INTEGER EXTERNAL TERMINATED BY ',',      
	ACCOUNT_OBJ_ID0                    INTEGER EXTERNAL TERMINATED BY ',',   
	CREATED_T                          INTEGER EXTERNAL TERMINATED BY ',',	
	CURRENCY                           INTEGER EXTERNAL TERMINATED BY ',',	
	EARNED_END_T                       INTEGER EXTERNAL TERMINATED BY ',',
	EARNED_START_T                     INTEGER EXTERNAL TERMINATED BY ',',	
	EFFECTIVE_T                        INTEGER EXTERNAL TERMINATED BY ',',
	END_T                              INTEGER EXTERNAL TERMINATED BY ',',
	ITEM_OBJ_DB                        INTEGER EXTERNAL TERMINATED BY ',',	
	ITEM_OBJ_ID0                       INTEGER EXTERNAL TERMINATED BY ',',	
	NET_QUANTITY                       INTEGER EXTERNAL TERMINATED BY ',',
	POID_DB                            INTEGER EXTERNAL TERMINATED BY ',',
	POID_ID0                           INTEGER EXTERNAL TERMINATED BY ',',
	POID_TYPE                          CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"', 
	START_T                            INTEGER EXTERNAL TERMINATED BY ',',
-- Constant Values
	ACCOUNT_OBJ_TYPE                   CONSTANT '/account',
	ACCOUNT_OBJ_REV                    CONSTANT '0',
	ARCHIVE_STATUS                     CONSTANT '0',
	EARNED_TYPE                        CONSTANT '0',
	EVENT_NO                           CONSTANT '0',
	FLAGS                              CONSTANT '0',
	GROUP_OBJ_ID0                      CONSTANT '0',
	GROUP_OBJ_DB                       CONSTANT '0',
	GROUP_OBJ_REV                      CONSTANT '0',
	INCR_QUANTITY                      CONSTANT '0',
	INCR_UNIT                          CONSTANT '0',
	ITEM_OBJ_TYPE                      CONSTANT '/item/misc',
	ITEM_OBJ_REV                       CONSTANT '0',
	MIN_QUANTITY                       CONSTANT '0',
	MIN_UNIT                           CONSTANT '0',
	NAME                               CONSTANT 'Billing Event Log',	
	POID_REV                           CONSTANT '0',
	PROGRAM_NAME                       CONSTANT 'cm',
	PROVIDER_ID_DB                     CONSTANT '0',
	PROVIDER_ID_REV                    CONSTANT '0',	
	PROVIDER_ID_ID0                    CONSTANT '0',
	PROVIDER_IPADDR                    CONSTANT '0',
	READ_ACCESS                        CONSTANT 'L',
	RERATE_OBJ_DB                      CONSTANT '0',
	RERATE_OBJ_ID0                     CONSTANT '0',	
	RERATE_OBJ_REV                     CONSTANT '0',
	SERVICE_OBJ_DB                     CONSTANT '0',
	SERVICE_OBJ_ID0                    CONSTANT '0', 
	SERVICE_OBJ_REV                    CONSTANT '0',
	SESSION_OBJ_DB                     CONSTANT '0',
	SESSION_OBJ_ID0                    CONSTANT '0',
	SESSION_OBJ_REV                    CONSTANT '0',
	TAX_SUPPLIER                	   CONSTANT '0',
	TIMEZONE_ADJ_START_T               CONSTANT '0',
	TIMEZONE_ADJ_END_T                 CONSTANT '0',
	TIMEZONE_MODE                      CONSTANT '0',
	TOD_MODE                           CONSTANT '0',
	UNIT                               CONSTANT '0',
	UNRATED_QUANTITY                   CONSTANT '0',
	USERID_DB                          CONSTANT '0',
	USERID_ID0                         CONSTANT '0',
	USERID_REV                         CONSTANT '0',
	WRITE_ACCESS                       CONSTANT 'L'
-- These fields will be entered as NULL
--	DESCR                              NULL
--	GROUP_OBJ_TYPE			   NULL
--	INVOICE_DATA                       NULL
--	MOD_T				   NULL
--	PROVIDER_DESCR                     NULL
--	RATED_TIMEZONE_ID                  NULL
--	RERATE_OBJ_TYPE                    NULL
--	ROUNDING_MODE                      NULL
--	RUM_NAME                           NULL
--	SERVICE_OBJ_TYPE                   NULL
--	SESSION_OBJ_TYPE                   NULL
--	TAX_LOCALES                        NULL
--	TIMEZONE_ID                        NULL
--	USERID_TYPE                        NULL
--	PROVIDER_ID_TYPE                   NULL
--	SYS_DESCR                          NULL
   )	

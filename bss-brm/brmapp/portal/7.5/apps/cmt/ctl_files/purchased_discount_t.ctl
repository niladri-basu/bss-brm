--
-- @(#)purchased_discount_t.ctl 3
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
   INTO TABLE PURCHASED_DISCOUNT_T
   (
	POID_DB				INTEGER EXTERNAL TERMINATED BY ',',
	POID_ID0			INTEGER EXTERNAL TERMINATED BY ',',
	CREATED_T			INTEGER EXTERNAL TERMINATED BY ',',
        MOD_T                  		INTEGER EXTERNAL TERMINATED BY ',',
	EFFECTIVE_T			INTEGER EXTERNAL TERMINATED BY ',',
        ACCOUNT_OBJ_DB                  INTEGER EXTERNAL TERMINATED BY ',',
        ACCOUNT_OBJ_ID0                 INTEGER EXTERNAL TERMINATED BY ',',
	CYCLE_START_T                  	INTEGER EXTERNAL TERMINATED BY ',',
	CYCLE_START_DETAILS             INTEGER EXTERNAL TERMINATED BY ',',
	CYCLE_END_T                  	INTEGER EXTERNAL TERMINATED BY ',',
	CYCLE_END_DETAILS               INTEGER EXTERNAL TERMINATED BY ',',
	DEAL_OBJ_DB                    	INTEGER EXTERNAL TERMINATED BY ',',
	DEAL_OBJ_ID0                   	INTEGER EXTERNAL TERMINATED BY ',',
	PLAN_OBJ_DB                    	INTEGER EXTERNAL TERMINATED BY ',',
	PLAN_OBJ_TYPE                  	CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	PLAN_OBJ_ID0                   	INTEGER EXTERNAL TERMINATED BY ',',
	DISCOUNT_OBJ_DB                	INTEGER EXTERNAL TERMINATED BY ',',
	DISCOUNT_OBJ_ID0               	INTEGER EXTERNAL TERMINATED BY ',',
	PURCHASE_START_T               	INTEGER EXTERNAL TERMINATED BY ',',
	PURCHASE_START_DETAILS          INTEGER EXTERNAL TERMINATED BY ',',
	PURCHASE_END_T               	INTEGER EXTERNAL TERMINATED BY ',',
	PURCHASE_END_DETAILS            INTEGER EXTERNAL TERMINATED BY ',',
	QUANTITY                       	INTEGER EXTERNAL TERMINATED BY ',',
	SERVICE_OBJ_DB                 	INTEGER EXTERNAL TERMINATED BY ',',
	SERVICE_OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',',
	SERVICE_OBJ_TYPE               	CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	STATUS                         	INTEGER EXTERNAL TERMINATED BY ',',
	USAGE_START_T                  	INTEGER EXTERNAL TERMINATED BY ',',
	USAGE_START_DETAILS             INTEGER EXTERNAL TERMINATED BY ',',
	USAGE_END_T                  	INTEGER EXTERNAL TERMINATED BY ',',
	USAGE_END_DETAILS               INTEGER EXTERNAL TERMINATED BY ',',
	PACKAGE_ID	    		INTEGER EXTERNAL TERMINATED BY ',',
	STATUS_FLAGS                    INTEGER EXTERNAL TERMINATED BY ',' "nvl(:STATUS_FLAGS,'0')",
        FLAGS                           INTEGER EXTERNAL TERMINATED BY ',' "nvl(:FLAGS,'3')",
	DESCR                          	CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' "nvl(:DESCR,'')",
	INSTANTIATED_T			INTEGER EXTERNAL TERMINATED BY ',',
-- Constant values
	POID_TYPE        		CONSTANT '/purchased_discount',
	POID_REV         		CONSTANT '0',
 	ACCOUNT_OBJ_TYPE		CONSTANT '/account',
	ACCOUNT_OBJ_REV			CONSTANT '1',
	DEAL_OBJ_TYPE                  	CONSTANT '/deal',
	DEAL_OBJ_REV                   	CONSTANT '0',
	READ_ACCESS 			CONSTANT 'L',
	WRITE_ACCESS 			CONSTANT 'L',
	PLAN_OBJ_REV                   	CONSTANT '0',
	DISCOUNT_OBJ_TYPE              	CONSTANT '/discount',
	DISCOUNT_OBJ_REV               	CONSTANT '0',
	SERVICE_OBJ_REV                	CONSTANT '0',
	OBJECT_CACHE_TYPE       	CONSTANT '0'
-- These fields will be entered
--	NODE_LOCATION			NULL
)

--
-- @(#)event_bal_impacts_t_with_virtual_cols.ctl 2
--
-- Copyright (c) 2004, 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted 
--     only in accordance with a valid Oracle license or sublicense agreement.
--
-- This CTL will be used when virtual column feature is enabled.
-- If virtual column feature is enabled, then no insert operations are allowed.
LOAD DATA
APPEND
   INTO TABLE EVENT_BAL_IMPACTS_T
   (
        OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',',
        REC_ID			INTEGER EXTERNAL TERMINATED BY ',',
        ACCOUNT_OBJ_DB          INTEGER EXTERNAL TERMINATED BY ',',
        ACCOUNT_OBJ_ID0         INTEGER EXTERNAL TERMINATED BY ',',
        BAL_GRP_OBJ_DB          INTEGER EXTERNAL TERMINATED BY ',',
        BAL_GRP_OBJ_ID0         INTEGER EXTERNAL TERMINATED BY ',',
        AMOUNT			INTEGER EXTERNAL TERMINATED BY ',',
	GL_ID			INTEGER EXTERNAL TERMINATED BY ',',
        ITEM_OBJ_DB    		INTEGER EXTERNAL TERMINATED BY ',',
        ITEM_OBJ_ID0 	        INTEGER EXTERNAL TERMINATED BY ',',
	PRODUCT_OBJ_DB		INTEGER EXTERNAL TERMINATED BY ',',
	PRODUCT_OBJ_ID0		INTEGER EXTERNAL TERMINATED BY ',',
	PRODUCT_OBJ_TYPE_ID	INTEGER EXTERNAL TERMINATED BY ',',	
	PRODUCT_OBJ_REV		INTEGER EXTERNAL TERMINATED BY ',',
	RATE_OBJ_DB		INTEGER EXTERNAL TERMINATED BY ',',
	RATE_OBJ_ID0		INTEGER EXTERNAL TERMINATED BY ',',
	RATE_OBJ_TYPE_ID	INTEGER EXTERNAL TERMINATED BY ',',
	ACCOUNT_OBJ_TYPE_ID     INTEGER EXTERNAL TERMINATED BY ',',
	BAL_GRP_OBJ_TYPE_ID     INTEGER EXTERNAL TERMINATED BY ',',
	ITEM_OBJ_TYPE_ID	INTEGER EXTERNAL TERMINATED BY ',',	
	RATE_OBJ_REV		INTEGER EXTERNAL TERMINATED BY ',',	
	RESOURCE_ID		INTEGER EXTERNAL TERMINATED BY ',',
-- Constant Values
        ACCOUNT_OBJ_REV         CONSTANT '0',
        BAL_GRP_OBJ_REV         CONSTANT '0',
	AMOUNT_DEFERRED		CONSTANT '0',
	AMOUNT_ORIG		CONSTANT '0',
	DISCOUNT		CONSTANT '0',
	IMPACT_CATEGORY		CONSTANT '/default',
	IMPACT_TYPE		CONSTANT '1',
        ITEM_OBJ_REV   	        CONSTANT '0',
	PERCENT			CONSTANT '1.0',
	QUANTITY		CONSTANT '1',
	RATE_TAG		CONSTANT 'rate tag',
	RESOURCE_ID_ORIG	CONSTANT '0',
	RUM_ID			CONSTANT '0'
-- These fields will be entered as NULL
--      TAX_CODE                NULL
--      NODE_LOCATION           NULL
--     	LINEAGE			NULL 
--	DISCOUNT_INFO		NULL
   )



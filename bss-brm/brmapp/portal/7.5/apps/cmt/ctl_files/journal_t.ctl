--
-- @(#) journal_t.ctl 2
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
   INTO TABLE JOURNAL_T 
   (
        POID_DB			INTEGER EXTERNAL TERMINATED BY ',',
        POID_ID0		INTEGER EXTERNAL TERMINATED BY ',',
        CREATED_T		INTEGER EXTERNAL TERMINATED BY ',',
        MOD_T			INTEGER EXTERNAL TERMINATED BY ',',
        ACCOUNT_OBJ_DB	        INTEGER EXTERNAL TERMINATED BY ',',
        ACCOUNT_OBJ_ID0         INTEGER EXTERNAL TERMINATED BY ',',
        ITEM_OBJ_DB    		INTEGER EXTERNAL TERMINATED BY ',',
        ITEM_OBJ_ID0 	        INTEGER EXTERNAL TERMINATED BY ',',
	GL_ID			INTEGER EXTERNAL TERMINATED BY ',',
	RESOURCE_ID		INTEGER EXTERNAL TERMINATED BY ',',
	EARNED_START_T		INTEGER EXTERNAL TERMINATED BY ',',
	EARNED_END_T		INTEGER EXTERNAL TERMINATED BY ',',
	DB_AR_NET_AMT		INTEGER EXTERNAL TERMINATED BY ',',
	CR_AR_NET_AMT		INTEGER EXTERNAL TERMINATED BY ',',
-- Constant Values
	POID_TYPE   	 	CONSTANT '/journal',	
        POID_REV   	        CONSTANT '0',
        READ_ACCESS		CONSTANT 'L',
        WRITE_ACCESS		CONSTANT 'L',
        ACCOUNT_OBJ_TYPE        CONSTANT '/account',
        ACCOUNT_OBJ_REV         CONSTANT '0',
        ITEM_OBJ_TYPE  	        CONSTANT '/item/misc',
        ITEM_OBJ_REV   	        CONSTANT '0',
        DB_AR_DISC_AMT  	CONSTANT '0',
        DB_AR_TAX_AMT  		CONSTANT '0',
        CR_AR_DISC_AMT  	CONSTANT '0',
        CR_AR_TAX_AMT  		CONSTANT '0'
   )


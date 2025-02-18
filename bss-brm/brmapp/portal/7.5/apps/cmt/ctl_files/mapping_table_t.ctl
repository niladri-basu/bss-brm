--
-- @(#)mapping_table_t.ctl 2
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
   INTO TABLE MAPPING_TABLE_T
   (
	ACCOUNT_OBJ_DB		INTEGER EXTERNAL TERMINATED BY ',',
	ACCOUNT_OBJ_ID0		INTEGER EXTERNAL TERMINATED BY ',',	
	CREATED_T		INTEGER EXTERNAL TERMINATED BY ',',	
	POID_DB			INTEGER EXTERNAL TERMINATED BY ',',
	POID_ID0		INTEGER EXTERNAL TERMINATED BY ',',
-- Constant Values
	ACCOUNT_OBJ_TYPE	CONSTANT '/account',
	ACCOUNT_OBJ_REV		CONSTANT '0',
	POID_TYPE		CONSTANT '/balgrp_map',
	POID_REV		CONSTANT '0',
	READ_ACCESS		CONSTANT 'L',
	WRITE_ACCESS		CONSTANT 'L'
-- These fields will be entered as NULL
--	MOD_T			NULL		
   )	

--
-- @(#)group_billing_members_t.ctl 2
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
   INTO TABLE GROUP_BILLING_MEMBERS_T
   (
	OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID			INTEGER EXTERNAL TERMINATED BY ',',
	OBJECT_DB		INTEGER EXTERNAL TERMINATED BY ',',
	OBJECT_ID0		INTEGER EXTERNAL TERMINATED BY ',',
-- Constant values
	OBJECT_TYPE		CONSTANT '/account',
	OBJECT_REV		CONSTANT '1'
-- NULL values	
--	ACCOUNT_TAG		NULL
    )	

--
-- @(#)event_essentials_t.ctl 2
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
INFILE * "str '|'"
APPEND
   INTO TABLE EVENT_ESSENTIALS_T
   FIELDS TERMINATED BY ','
   (
        OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',',
	BALANCES_SMALL		CHAR(4000) ENCLOSED BY '***' and '***',	
        ACCOUNT_OBJ_ID0         INTEGER EXTERNAL TERMINATED BY ',',
        END_T			INTEGER EXTERNAL TERMINATED BY ','

-- These fields will be entered as NULL
--      BALANCES_LARGE		NULL

   )

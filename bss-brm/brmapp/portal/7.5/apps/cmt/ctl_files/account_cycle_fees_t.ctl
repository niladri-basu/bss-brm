--
-- @(#)account_cycle_fees_t.ctl 2
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
   INTO TABLE ACCOUNT_CYCLE_FEES_T
   (
	OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID			INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID2			INTEGER EXTERNAL TERMINATED BY ',',
	CHARGED_FROM_T		INTEGER EXTERNAL TERMINATED BY ',',
	CHARGED_TO_T           	INTEGER EXTERNAL TERMINATED BY ',',
	CYCLE_FEE_START_T	INTEGER EXTERNAL TERMINATED BY ',',
	CYCLE_FEE_END_T        	INTEGER EXTERNAL TERMINATED BY ',',
	UNIT                   	INTEGER EXTERNAL TERMINATED BY ',',
	COUNT			INTEGER EXTERNAL TERMINATED BY ','
    )

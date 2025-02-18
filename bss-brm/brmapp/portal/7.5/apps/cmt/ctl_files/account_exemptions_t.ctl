--
-- @(#)account_exemptions_t.ctl 2
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
   INTO TABLE ACCOUNT_EXEMPTIONS_T
(
	OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID			INTEGER EXTERNAL TERMINATED BY ',',	
	PERCENT			INTEGER EXTERNAL TERMINATED BY ',',
	TYPE			INTEGER EXTERNAL TERMINATED BY ',',
	CERTIFICATE_NUM		CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	EXEMPT_START_T		INTEGER EXTERNAL TERMINATED BY ',',
	EXEMPT_END_T		INTEGER EXTERNAL TERMINATED BY ','
)

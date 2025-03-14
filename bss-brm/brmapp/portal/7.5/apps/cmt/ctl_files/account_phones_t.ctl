--
-- @(#)account_phones_t.ctl 2
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
   INTO TABLE ACCOUNT_PHONES_T
(
	OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID			INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID2			INTEGER EXTERNAL TERMINATED BY ',',
	PHONE			CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	TYPE			INTEGER EXTERNAL TERMINATED BY ','
)

--
-- @(#)device_num_t.ctl 2
--
-- Copyright (c) 2004, 2013, Oracle and/or its affiliates. All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted 
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE DEVICE_NUM_T
   (
	OBJ_ID0                 INTEGER EXTERNAL TERMINATED BY ',',
	CATEGORY_ID             INTEGER EXTERNAL TERMINATED BY ',',
	CATEGORY_VERSION        INTEGER EXTERNAL TERMINATED BY ',',
	NETWORK_ELEMENT         CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	VANITY                  INTEGER EXTERNAL TERMINATED BY ',',
	PERMITTED               CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	ORIG_NETWORK_ID         CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	RECENT_NETWORK_ID       CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    )

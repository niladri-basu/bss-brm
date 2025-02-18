--
-- @(#)profile_serv_extrating_data_t.ctl 2
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
   INTO TABLE AU_PROFILE_SERV_EXTRATING_DA_T
   (
	OBJ_ID0             INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID              INTEGER EXTERNAL TERMINATED BY ',',
	NAME                CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	VALUE               CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	VALID_TO            INTEGER EXTERNAL TERMINATED BY ',',
	VALID_FROM          INTEGER EXTERNAL TERMINATED BY ','
    )

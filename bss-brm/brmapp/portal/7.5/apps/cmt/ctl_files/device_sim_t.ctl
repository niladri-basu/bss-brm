--
-- @(#)device_sim_t.ctl 2
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
   INTO TABLE DEVICE_SIM_T
   (
	OBJ_ID0               INTEGER EXTERNAL TERMINATED BY ',',
	IMSI                  CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	PIN1                  CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	PIN2                  CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	PUK1                  CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	PUK2                  CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	KI                    CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	ADM1                  CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	NETWORK_ELEMENT       CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    )

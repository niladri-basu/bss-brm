--
-- @(#)profile_serv_extrating_t.ctl 2
--
--     Copyright (c) 2004-2007 Oracle. All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted 
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE PROFILE_SERV_EXTRATING_T
   (
	OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',',        
	STATUS 			INTEGER EXTERNAL TERMINATED BY ',',        
	LABEL 			CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
-- Constant Values	
	REFERENCE_COUNT		CONSTANT '1'
    )

--
-- @(#)group_sharing_profiles_t.ctl 1
--
--     Copyright (c) 2007 Oracle. All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted 
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE GROUP_SHARING_PROFILES_T
   (
	OBJ_ID0                           INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID                            INTEGER EXTERNAL TERMINATED BY ',',
	PROFILE_OBJ_DB                    INTEGER EXTERNAL TERMINATED BY ',',
	PROFILE_OBJ_ID0                   INTEGER EXTERNAL TERMINATED BY ',',
	PROFILE_OBJ_TYPE                  CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
--Constant Values
	PROFILE_OBJ_REV                   CONSTANT '0'
   )	
	

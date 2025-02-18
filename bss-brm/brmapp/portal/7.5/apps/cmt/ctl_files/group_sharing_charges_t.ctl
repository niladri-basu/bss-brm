--
-- @(#)group_sharing_charges_t.ctl 2
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
   INTO TABLE GROUP_SHARING_CHARGES_T
   (
	OBJ_ID0                           INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID                            INTEGER EXTERNAL TERMINATED BY ',',
	SPONSOR_OBJ_DB                    INTEGER EXTERNAL TERMINATED BY ',',
	SPONSOR_OBJ_ID0                   INTEGER EXTERNAL TERMINATED BY ',',
--Constant Values
	SPONSOR_OBJ_TYPE                  CONSTANT '/sponsorship',
	SPONSOR_OBJ_REV                   CONSTANT '0'
   )	
	

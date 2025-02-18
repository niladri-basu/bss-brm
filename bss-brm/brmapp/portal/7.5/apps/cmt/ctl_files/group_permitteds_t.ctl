--
-- @(#)group_permitteds_t.ctl 2
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
   INTO TABLE GROUP_PERMITTEDS_T
   TRAILING NULLCOLS
   (
	OBJ_ID0        	INTEGER EXTERNAL TERMINATED BY ',',
	OBJ_TYPE	CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
-- Constant Values	
	REC_ID         	CONSTANT '0'
   )	

--
-- @(#)au_uniqueness_alias_list_t.ctl 2
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
   INTO TABLE AU_UNIQUENESS_ALIAS_LIST_T
   (
	OBJ_ID0			INTEGER EXTERNAL TERMINATED BY ',', 
	REC_ID			INTEGER EXTERNAL TERMINATED BY ',', 
	NAME			CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' 
)

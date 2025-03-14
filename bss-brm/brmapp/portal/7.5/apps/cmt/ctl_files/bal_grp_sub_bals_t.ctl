--
-- @(#)bal_grp_sub_bals_t.ctl 3
--
-- Copyright (c) 2004, 2014, Oracle and/or its affiliates. All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted 
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE BAL_GRP_SUB_BALS_T
   (
	OBJ_ID0                  INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID                   INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID2                  INTEGER EXTERNAL TERMINATED BY ',',
	CURRENT_BAL              INTEGER EXTERNAL TERMINATED BY ',',	
	ROLLOVER_DATA            INTEGER EXTERNAL TERMINATED BY ',',
	VALID_FROM               INTEGER EXTERNAL TERMINATED BY ',',
	VALID_FROM_DETAILS       INTEGER EXTERNAL TERMINATED BY ',',
	VALID_TO                 INTEGER EXTERNAL TERMINATED BY ',',
	VALID_TO_DETAILS         INTEGER EXTERNAL TERMINATED BY ',',
	CONTRIBUTOR		 CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	GRANTOR_OBJ_DB		 INTEGER EXTERNAL TERMINATED BY ',',
	GRANTOR_OBJ_ID0		 INTEGER EXTERNAL TERMINATED BY ',',
	GRANTOR_OBJ_TYPE	 CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	GRANTOR_OBJ_REV      	 INTEGER EXTERNAL TERMINATED BY ',',

-- Constant Values
	NEXT_BAL		 CONSTANT '0',
	DELAYED_BAL		 CONSTANT '0'

   )

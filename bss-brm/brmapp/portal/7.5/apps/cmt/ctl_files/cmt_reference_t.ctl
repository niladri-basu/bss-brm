--
-- @(#) cmt_reference_t.ctl 2
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
   INTO TABLE cmt_reference_t
  (
	POID_DB 		INTEGER  EXTERNAL TERMINATED BY ',',
  	POID_ID0 		INTEGER EXTERNAL TERMINATED BY ',',
	CREATED_T		INTEGER EXTERNAL TERMINATED BY ',',  	
	MOD_T 			INTEGER  EXTERNAL TERMINATED BY ',',
	BATCH_ID		INTEGER  EXTERNAL TERMINATED BY ',',
	ACCT_BILLINFO_ID	CHAR TERMINATED BY ',',	
	INPUT_ID		CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',	
	OBJ_TYPE		CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',	
  	POID_ID 		INTEGER EXTERNAL TERMINATED BY ',',
  	STAGE_ID 		INTEGER EXTERNAL TERMINATED BY ',',
  	DEPLOY_STATUS		INTEGER EXTERNAL TERMINATED BY ',',
  	CYCLE_DOM		INTEGER EXTERNAL TERMINATED BY ',',

-- Constant vlaues

	POID_TYPE 		CONSTANT '/cmt_reference',
	POID_REV 		CONSTANT '1',
	READ_ACCESS 		CONSTANT 'L',
	WRITE_ACCESS 		CONSTANT 'L'
)

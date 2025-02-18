--
-- @(#)payinfo_inv_t.ctl 2
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
   INTO TABLE PAYINFO_INV_T
   (
	OBJ_ID0               INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID                INTEGER EXTERNAL TERMINATED BY ',',
	ADDRESS               CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	CITY                  CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	COUNTRY               CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	DELIVERY_DESCR        CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	DELIVERY_PREFER       INTEGER EXTERNAL TERMINATED BY ',',
	EMAIL_ADDR            CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	INV_INSTR             CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	NAME		      CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	STATE                 CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	ZIP                   CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',

-- CONSTANT fields
	INV_TERMS             CONSTANT '0'

    )	

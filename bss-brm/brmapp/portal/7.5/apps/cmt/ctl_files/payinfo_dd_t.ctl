--
-- @(#)payinfo_dd_t.ctl 2
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
   INTO TABLE PAYINFO_DD_T
   (
	OBJ_ID0                   INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID                    INTEGER EXTERNAL TERMINATED BY ',',
	NAME                      CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	ADDRESS                   CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	CITY                      CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	STATE                     CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	ZIP                       CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	COUNTRY                   CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	BANK_NO                   CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	DEBIT_NUM                 CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	TYPE                      INTEGER EXTERNAL TERMINATED BY ',',
	MANDATE_STATUS            INTEGER EXTERNAL TERMINATED BY ',',
	DD_ACTIVATION_DATE        INTEGER EXTERNAL TERMINATED BY ',',
	MAN_RECEIVED_DATE         INTEGER EXTERNAL TERMINATED BY ',',
	FIAS_ID                   CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
   )	

--
-- @(#)purchased_bundle_t.ctl 3
--
-- Copyright (c) 2011, 2013, Oracle and/or its affiliates. All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE PURCHASED_BUNDLE_T
   (
	POID_DB                         INTEGER EXTERNAL TERMINATED BY ',', 
        POID_ID0                        INTEGER EXTERNAL TERMINATED BY ',', 
        CREATED_T                       INTEGER EXTERNAL TERMINATED BY ',', 
        MOD_T                           INTEGER EXTERNAL TERMINATED BY ',', 
        ACCOUNT_OBJ_DB                  INTEGER EXTERNAL TERMINATED BY ',', 
        ACCOUNT_OBJ_ID0                 INTEGER EXTERNAL TERMINATED BY ',',  
        NAME			        CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	DESCR                           CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' "nvl(:DESCR,'')",
	VALID_FROM                      INTEGER EXTERNAL TERMINATED BY ',', 
	VALID_TO                        INTEGER EXTERNAL TERMINATED BY ',', 
	STATUS                      	INTEGER EXTERNAL TERMINATED BY ',', 
-- Constant values
        POID_TYPE                       CONSTANT '/purchased_bundle', 
        POID_REV                        CONSTANT '0',
        ACCOUNT_OBJ_TYPE                CONSTANT '/account', 
        ACCOUNT_OBJ_REV                 CONSTANT '1', 
        READ_ACCESS                     CONSTANT 'L', 
        WRITE_ACCESS                    CONSTANT 'L'
)

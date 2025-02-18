-- @(#)% %
--
-- Copyright (c) 2003, 2009, Oracle and/or its affiliates. 
-- All rights reserved. 
--      This material is the confidential property of Oracle Corporation
--      or its licensors and may be used, reproduced, stored
--      or transmitted only in accordance with a valid Oracle license
--      or sublicense agreement.
--
UNRECOVERABLE
LOAD DATA
CHARACTERSET UTF8
APPEND
INTO TABLE EVENT_DLYD_SESSION_VP_T
SINGLEROW
PARTITION (P_1D)
TRAILING NULLCOLS
-- Note: In order to handle SVC_TYPE and SVC_CODE, we do not use
--       the global "FIELDS TERMINATED BY X'09'".
(
  -- From the Infranet Detail record
  RECORD_TYPE                   FILLER TERMINATED BY X'09', -- Not loaded
  EXT1				CHAR TERMINATED BY X'09',
  EXT2				CHAR TERMINATED BY X'09',
  EXT4                          CHAR TERMINATED BY X'09',
  CHARGE_EXPIRY			CHAR TERMINATED BY X'09',
  CHARGE_NAME			CHAR TERMINATED BY X'09',
  NEW_ACCT_EXPIRY		CHAR TERMINATED BY X'09',
  NEW_BALANCE_EXPIRIES		CHAR TERMINATED BY X'09',
  NEW_CHARGE_STATE		CHAR TERMINATED BY X'09',
  OLD_ACCT_EXPIRY		CHAR TERMINATED BY X'09',
  OLD_BALANCE_EXPIRIES		CHAR TERMINATED BY X'09',
  OLD_CHARGE_EXPIRY		CHAR TERMINATED BY X'09',
  OLD_CHARGE_STATE		CHAR TERMINATED BY X'09',
  PARTNER			CHAR TERMINATED BY X'09',
  PAYMENT			CHAR TERMINATED BY X'09',
  REFERENCE			CHAR TERMINATED BY X'09',
  RESULT			CHAR TERMINATED BY X'09',
  TX_ID				CHAR TERMINATED BY X'09',
  VOUCHER_TYPE			CHAR TERMINATED BY X'09',
  VP_TYPE			CHAR TERMINATED BY X'09',
  EXT3                          CHAR TERMINATED BY X'09',
  DESCRIPTION2                  CHAR TERMINATED BY X'09',
  DESCRIPTION3                  CHAR TERMINATED BY X'09',
  VOLUME                        CHAR TERMINATED BY X'09',
  UNIT                          CHAR TERMINATED BY X'09',
  PK_GROUP                      CHAR TERMINATED BY X'09',
  OBJ_ID0                       INTEGER EXTERNAL TERMINATED BY X'09' -- Populated by REL
)

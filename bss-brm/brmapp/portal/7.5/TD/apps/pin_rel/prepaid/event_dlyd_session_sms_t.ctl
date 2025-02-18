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
INTO TABLE EVENT_DLYD_SESSION_SMS_T
SINGLEROW
PARTITION (P_1D)
TRAILING NULLCOLS
-- Note: In order to handle SVC_TYPE and SVC_CODE, we do not use
--       the global "FIELDS TERMINATED BY X'09'".
(
  -- From the Infranet Detail record
  RECORD_TYPE                   FILLER TERMINATED BY X'09', -- Not loaded
  EVENT_CLASS			CHAR TERMINATED BY X'09',
  EVENT_NAME			CHAR TERMINATED BY X'09',
  EVENT_COST			CHAR TERMINATED BY X'09',
  EVENT_TIME_COST		CHAR TERMINATED BY X'09',
  EVENT_DATA_COST		CHAR TERMINATED BY X'09',
  EVENT_UNIT_COST		CHAR TERMINATED BY X'09',
  CASCADE			CHAR TERMINATED BY X'09',
  PROD_CAT_ID			CHAR TERMINATED BY X'09',
  OBJ_ID0                       INTEGER EXTERNAL TERMINATED BY X'09' -- Populated by REL
)

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
INTO TABLE EVENT_DLYD_SESSION_DATA_T
SINGLEROW
PARTITION (P_1D)
TRAILING NULLCOLS
-- Note: In order to handle SVC_TYPE and SVC_CODE, we do not use
--       the global "FIELDS TERMINATED BY X'09'".
(
  -- From the Infranet Detail record
  RECORD_TYPE                   FILLER TERMINATED BY X'09', -- Not loaded
  CS				CHAR TERMINATED BY X'09',
  DISCOUNT_TYPE			CHAR TERMINATED BY X'09',
  MULTIPLIER			CHAR TERMINATED BY X'09',
  OPROD				CHAR TERMINATED BY X'09',
  UMS				CHAR TERMINATED BY X'09',
  UPROD				CHAR TERMINATED BY X'09',
  OBJ_ID0                       INTEGER EXTERNAL TERMINATED BY X'09' -- Populated by REL
)

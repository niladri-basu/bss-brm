-- @(#)% %
--
--      Copyright (c) 2005-2006 Oracle. All rights reserved.
--      This material is the confidential property of Oracle Corporation
--      or its licensors and may be used, reproduced, stored
--      or transmitted only in accordance with a valid Oracle license
--      or sublicense agreement.
--

UNRECOVERABLE
LOAD DATA
CHARACTERSET UTF8
APPEND
INTO TABLE EVENT_RUM_MAP_T
SINGLEROW
PARTITION (P_1D)
FIELDS TERMINATED BY X'09'
(
  RECORD_TYPE                           FILLER, -- Not loaded
  RECORD_NUMBER                         FILLER, -- Not loaded
  RUM_NAME                              CHAR,
  NET_QUANTITY                          FLOAT EXTERNAL,
  UNRATED_QUANTITY                      FLOAT EXTERNAL,
  OBJ_ID0                               INTEGER EXTERNAL, -- Filled in by REL
  REC_ID                                INTEGER EXTERNAL  -- Filled in by REL
)

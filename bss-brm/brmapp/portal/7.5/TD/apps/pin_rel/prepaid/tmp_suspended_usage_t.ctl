-- @(#)% %
--
--      Copyright (c) 2003-2006 Oracle. All rights reserved.
--      This material is the confidential property of Oracle Corporation
--      or its licensors and may be used, reproduced, stored
--      or transmitted only in accordance with a valid Oracle license
--      or sublicense agreement.
--

UNRECOVERABLE
LOAD DATA
CHARACTERSET UTF8
TRUNCATE
INTO TABLE TMP_SUSPENDED_USAGE_T
SINGLEROW 
FIELDS TERMINATED BY X'09'
(
  RECORD_TYPE				FILLER, -- Not loaded
  SUSPENSE_ID                           INTEGER EXTERNAL,
  STATUS                                INTEGER EXTERNAL,
  SUSPENSE_REASON                       INTEGER EXTERNAL,
  SUSPENSE_SUBREASON                    INTEGER EXTERNAL,
  ERROR_CODE                            INTEGER EXTERNAL,
  RECYCLE_MODE                          INTEGER EXTERNAL,
  RECYCLE_KEY                           INTEGER EXTERNAL,
  RECYCLE_T                             INTEGER EXTERNAL,
  POID_ID0                              INTEGER EXTERNAL,

  -- Constant fields
  POID_REV				CONSTANT 0,
  READ_ACCESS				CONSTANT 'L',
  WRITE_ACCESS				CONSTANT 'L',

  -- Fields modified by REL at run-time
  CREATED_T				CONSTANT 1044035814,
  MOD_T					CONSTANT 1044035814,
  POID_DB                               CONSTANT 1,
  POID_TYPE                             CONSTANT '/tmp_suspended_usage'
)


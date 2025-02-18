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
APPEND
INTO TABLE SUSPENDED_USAGE_T
SINGLEROW 
FIELDS TERMINATED BY X'09'
(
  RECORD_TYPE2                          FILLER, -- Not loaded
  SUSPENSE_REASON                       INTEGER EXTERNAL,
  SUSPENSE_SUBREASON                    INTEGER EXTERNAL,
  RECYCLE_KEY			        CHAR,
  ERROR_CODE                            INTEGER EXTERNAL,
  PIPELINE_NAME                         CHAR,
  FILENAME                              CHAR,
  SERVICE_CODE                          CHAR,
  RECORD_TYPE                           CHAR,
  EDR_SIZE                              INTEGER EXTERNAL,
  ACCOUNT_OBJ_DB                        INTEGER EXTERNAL TERMINATED BY X'20', -- ACCOUNT_POID
  ACCOUNT_OBJ_TYPE                      CHAR TERMINATED BY X'20', -- ACCOUNT_POID
  ACCOUNT_OBJ_ID0                       INTEGER EXTERNAL TERMINATED BY X'20', -- ACCOUNT_POID
  ACCOUNT_OBJ_REV                       INTEGER EXTERNAL, -- ACCOUNT_POID
  BATCH_ID                              CHAR,
  SUSPENDED_FROM_BATCH_ID		CHAR,
  TIMEZONE_OFFSET                       INTEGER EXTERNAL,
  PIPELINE_CATEGORY      		CHAR,
  POID_ID0                              INTEGER EXTERNAL,

  -- Constant fields
  POID_REV				CONSTANT 0,
  READ_ACCESS				CONSTANT 'L',
  WRITE_ACCESS				CONSTANT 'A',
  STATUS                                CONSTANT 0,
  NUM_RECYCLES                          CONSTANT 0,
  RECYCLE_T                             CONSTANT 0,
  RECYCLE_OBJ_DB                        CONSTANT 0,
  RECYCLE_OBJ_ID0                       CONSTANT 0,
  RECYCLE_OBJ_TYPE                      CONSTANT '',
  RECYCLE_OBJ_REV                       CONSTANT 0,
  TEST_SUSP_REASON                      CONSTANT 65534,
  TEST_SUSP_SUBREASON                   CONSTANT 65534,
  TEST_ERROR_CODE                       CONSTANT 0,
  EDITED                                CONSTANT 0,

  -- Fields modified by REL at run-time
  CREATED_T				CONSTANT 1044035814,
  MOD_T					CONSTANT 1044035814,
  POID_DB                               CONSTANT 1,
  POID_TYPE                             CONSTANT '/suspended_usage/telco'
)


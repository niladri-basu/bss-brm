-- @(#)% %
--
--      Copyright (c) 2005-2006 Oracle. All rights reserved.
--      This material is the confidential property of Oracle Corporation
--      or its licensors and may be used, reproduced, stored
--      or transmitted only in accordance with a valid Oracle license
--      or sublicense agreement.
--

-- UNRECOVERABLE
LOAD DATA
CHARACTERSET UTF8
APPEND
INTO TABLE TMP_SUSPENDED_USAGE_T
SINGLEROW 
FIELDS TERMINATED BY X'09'
(
  RECORD_TYPE               FILLER, -- Not loaded
  RECORD_NUMBER             FILLER, -- Not loaded
  SUSPENSE_ID               INTEGER EXTERNAL,
  PIPELINE_NAME             FILLER, -- Not loaded          
  SOURCE_FILENAME           FILLER, -- Not loaded        
  SERVICE_CODE              FILLER, -- Not loaded           
  EDR_RECORD_TYPE           FILLER, -- Not loaded        
  ACCOUNT_POID              FILLER, -- Not loaded           
  OVERRIDE_REASONS          FILLER, -- Not loaded       
  SUSPENDED_FROM_BATCH_ID   FILLER, -- Not loaded
  RECYCLE_KEY               INTEGER EXTERNAL,
  RECYCLE_T                 INTEGER EXTERNAL,
  POID_ID0                  INTEGER EXTERNAL,

  -- Constant fields
  STATUS                    CONSTANT 0,
  SUSPENSE_REASON           CONSTANT 0,
  SUSPENSE_SUBREASON        CONSTANT 0,
  ERROR_CODE                CONSTANT 0,
  RECYCLE_MODE              CONSTANT 0,
  POID_REV                  CONSTANT 0,
  READ_ACCESS               CONSTANT 'L',
  WRITE_ACCESS              CONSTANT 'L',

  -- Fields modified by REL at run-time
  CREATED_T                 CONSTANT 1044035814,
  MOD_T                     CONSTANT 1044035814,
  POID_DB                   CONSTANT 1,
  POID_TYPE                 CONSTANT '/tmp_suspended_usage'
)



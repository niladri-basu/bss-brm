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
INFILE * "var 5"
APPEND
INTO TABLE SUSP_USAGE_EDR_BUF
SINGLEROW 
(
  RECORD_TYPE                           FILLER TERMINATED BY X'09', -- Not loaded
  OBJ_ID0                               INTEGER EXTERNAL TERMINATED BY X'09',

  -- the size of EDR_BUF may be modified by suspense_preprocess.pl at run-time if
  -- edr size found from input file is greater than current specified size
  EDR_BUF                               CHAR(8000)
)


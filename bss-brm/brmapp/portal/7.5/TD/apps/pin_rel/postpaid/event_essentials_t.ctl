-- @(#)% %
--
--      Copyright (c) 2004-2006 Oracle. All rights reserved.
--      This material is the confidential property of Oracle Corporation
--      or its licensors and may be used, reproduced, stored
--      or transmitted only in accordance with a valid Oracle license
--      or sublicense agreement.
--

UNRECOVERABLE
LOAD DATA
CHARACTERSET UTF8
INFILE * "var 10"
APPEND 
INTO TABLE EVENT_ESSENTIALS_T
SINGLEROW 
PARTITION (P_1D)
FIELDS TERMINATED BY X'09'
(
  -- From the serialized SUB_BAL_IMP and SUB_BALANCES records
  OBJ_ID0                               INTEGER EXTERNAL, -- Populated by REL
  BALANCES_SMALL                        CHAR(4000), -- Populated by REL

  -- the size of BALANCES_LARGE may be modified by pin_rel_preprocess.pl at run-time if
  -- data size found from input file is greater than current specified size
  BALANCES_LARGE                        CHAR(20000), -- Populated by REL

  ACCOUNT_OBJ_ID0                       INTEGER EXTERNAL, -- Populated by REL
  END_T                                 INTEGER EXTERNAL -- CHARGING_END_TIMESTAMP
)

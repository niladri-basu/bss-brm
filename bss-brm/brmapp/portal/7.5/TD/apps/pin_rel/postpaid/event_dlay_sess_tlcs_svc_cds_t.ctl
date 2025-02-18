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
INTO TABLE EVENT_DLAY_SESS_TLCS_SVC_CDS_T
SINGLEROW
PARTITION (P_1D)
FIELDS TERMINATED BY X'09'
TRAILING NULLCOLS
(
  -- From the Infranet GSM Supplementary Service record
  RECORD_TYPE				FILLER, -- Not loaded
  RECORD_NUMBER				FILLER, -- Not loaded
  SS_ACTION_CODE			CHAR, -- ACTION_CODE
  SS_CODE				CHAR, -- SS_CODE
  CLIR_INDICATOR                        FILLER, -- Not loaded
  OBJ_ID0				INTEGER EXTERNAL, -- Populated by REL
  REC_ID				INTEGER EXTERNAL -- Populated by REL
)

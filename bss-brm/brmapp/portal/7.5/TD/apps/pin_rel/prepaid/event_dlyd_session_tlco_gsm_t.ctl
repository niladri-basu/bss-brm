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
INTO TABLE EVENT_DLYD_SESSION_TLCO_GSM_T
SINGLEROW
PARTITION (P_1D)
FIELDS TERMINATED BY X'09'
TRAILING NULLCOLS
(
  -- From the Infranet Detail record
  RECORD_TYPE                       FILLER, -- Not loaded
  RECORD_NUMBER                     FILLER, -- Not loaded
  EVENT_NO			    FILLER, -- Not loaded
  BATCH_ID                          FILLER, -- Not loaded
  ORIGINAL_BATCH_ID                 FILLER, -- Not loaded
  CHAIN_REFERENCE                   FILLER, -- Not loaded
  SOURCE_NETWORK                    FILLER, -- Not loaded
  DESTINATION_NETWORK               FILLER, -- Not loaded
  A_NUMBER                          FILLER, -- Not loaded
  CALLED_NUM_MODIF_MARK             INTEGER EXTERNAL, -- B_MODIFICATION_INDICATOR
  B_NUMBER                          FILLER, -- Not loaded
  DESCRIPTION                       FILLER, -- Not loaded
  DIRECTION                         INTEGER EXTERNAL, -- USAGE_DIRECTION
  CONNECT_TYPE                      FILLER, -- Not loaded
  CONNECT_SUB_TYPE                  FILLER, -- Not loaded
  BASIC_SERVICE                     FILLER, -- Not loaded
  QOS_REQUESTED                     INTEGER EXTERNAL, -- QOS_REQUESTED
  QOS_NEGOTIATED                    INTEGER EXTERNAL, -- QOS_USED
  CALL_COMPLETION_INDICATOR         FILLER, -- Not loaded  
  SUB_TRANS_ID                      INTEGER EXTERNAL, -- LONG_DURATION_INDICATOR
  UTC_TIME_OFFSET                   FILLER, -- Not loaded
  BYTES_OUT                         INTEGER EXTERNAL, -- VOLUME_SENT
  BYTES_IN                          INTEGER EXTERNAL, -- BYTES_IN
  NUMBER_OF_UNITS                   FLOAT EXTERNAL, -- NUMBER_OF_UNITS
  USAGE_CLASS                       FILLER, -- Not loaded
  USAGE_TYPE                        FILLER, -- Not loaded
  PREPAID_INDICATOR                 FILLER, -- Not loaded
  INTERN_PROCESS_STATUS             FILLER, -- Not loaded
  CHARGING_START_TIMESTAMP          FILLER, -- Not loaded
  CHARGING_END_TIMESTAMP            FILLER, -- Not loaded
  NET_QUANTITY                      FILLER, -- Not loaded
  OBJ_ID0                           INTEGER EXTERNAL, -- Populated by REL

  -- From the Infranet Associated GSM record
  RECORD_TYPE2                      FILLER, -- Not loaded
  RECORD_NUMBER2                    FILLER, -- Not loaded
  PORT_NUMBER                       FILLER, -- Not loaded
  A_NUMBER_USED                     FILLER, -- Not loaded
  NUMBER_OF_SS_EVENT_PACKETS        FILLER  -- Not loaded
)

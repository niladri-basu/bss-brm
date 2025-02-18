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
INTO TABLE EVENT_DLAY_SESS_TLCS_T
SINGLEROW
PARTITION (P_1D)
TRAILING NULLCOLS
-- Note: In order to handle SVC_TYPE and SVC_CODE, we do not use
--       the global "FIELDS TERMINATED BY X'09'".
(
  -- From the Infranet Detail record
  RECORD_TYPE                       FILLER TERMINATED BY X'09', -- Not loaded
  RECORD_NUMBER                     FILLER TERMINATED BY X'09', -- Not loaded
  EVENT_NO			    FILLER TERMINATED BY X'09', -- Not loaded
  BATCH_ID                          FILLER TERMINATED BY X'09', -- Not loaded
  ORIGINAL_BATCH_ID                  FILLER TERMINATED BY X'09', -- Not loaded
  NETWORK_SESSION_ID                CHAR TERMINATED BY X'09', -- CHAIN_REFERENCE
  ORIGIN_NETWORK                    CHAR TERMINATED BY X'09', -- SOURCE_NETWORK
  DESTINATION_NETWORK               CHAR TERMINATED BY X'09', -- DESTINATION_NETWORK
  PRIMARY_MSID                      CHAR TERMINATED BY X'09', -- A_NUMBER
  B_MODIFICATION_INDICATOR          FILLER TERMINATED BY X'09', -- Not loaded
  CALLED_TO                         CHAR TERMINATED BY X'09', -- B_NUMBER
  DESCRIPTION                       FILLER TERMINATED BY X'09', -- Not loaded
  USAGE_DIRECTION                   FILLER TERMINATED BY X'09', -- Not loaded
  CONNECT_TYPE                      FILLER TERMINATED BY X'09', -- Not loaded
  CONNECT_SUB_TYPE                  FILLER TERMINATED BY X'09', -- Not loaded
  SVC_TYPE                          CHAR(1), -- BASIC_SERVICE (1st char)
  SVC_CODE                          CHAR TERMINATED BY X'09', -- BASIC_SERVICE (2nd char onwards)
  QOS_REQUESTED                     FILLER TERMINATED BY X'09', -- Not loaded
  QOS_USED                          FILLER TERMINATED BY X'09', -- Not loaded
  TERMINATE_CAUSE                   INTEGER EXTERNAL TERMINATED BY X'09', -- CALL_COMPLETION_INDICATOR
  LONG_DURATION_INDICATOR           FILLER TERMINATED BY X'09', -- Not loaded
  UTC_TIME_OFFSET                   FILLER TERMINATED BY X'09', -- Not loaded
  VOLUME_SENT                       FILLER TERMINATED BY X'09', -- Not loaded
  BYTES_IN                          FILLER TERMINATED BY X'09', -- Not loaded
  NUMBER_OF_UNITS                   FILLER TERMINATED BY X'09', -- Not loaded
  USAGE_CLASS                       CHAR TERMINATED BY X'09', -- USAGE_CLASS
  USAGE_TYPE                        CHAR TERMINATED BY X'09', -- USAGE_TYPE
  PREPAID_INDICATOR                 FILLER TERMINATED BY X'09', -- Not loaded
  INTERN_PROCESS_STATUS             FILLER TERMINATED BY X'09', -- Not loaded
  CHARGING_START_TIMESTAMP          FILLER TERMINATED BY X'09', -- Not loaded
  CHARGING_END_TIMESTAMP            FILLER TERMINATED BY X'09', -- Not loaded
  NET_QUANTITY                      FILLER TERMINATED BY X'09', -- Not loaded
  OBJ_ID0                           INTEGER EXTERNAL TERMINATED BY X'09', -- Populated by REL

  -- From the Infranet Associated GSM record
  RECORD_TYPE2                      FILLER TERMINATED BY X'09', -- Not loaded
  RECORD_NUMBER2                    FILLER TERMINATED BY X'09', -- Not loaded
  SECONDARY_MSID                    CHAR TERMINATED BY X'09', -- PORT_NUMBER
  CALLING_FROM                      CHAR TERMINATED BY X'09', -- A_NUMBER_USED
  NUMBER_OF_SS_EVENT_PACKETS        FILLER -- Not loaded
)

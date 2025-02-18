-- @(#)% %
--
-- Copyright (c) 2001, 2009, Oracle and/or its affiliates. 
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
INTO TABLE EVENT_DELAYED_ACT_WAP_INTER_T
SINGLEROW
PARTITION (P_1D)
FIELDS TERMINATED BY X'09'
TRAILING NULLCOLS
(
  -- From the Infranet Detail record
  RECORD_TYPE                       FILLER, -- Not loaded
  RECORD_NUMBER                     FILLER, -- Not loaded
  EVENT_ID			    FILLER, -- Not loaded 
  BATCH_ID                          FILLER, -- Not loaded
  ORIGINAL_BATCH_ID                  FILLER, -- Not loaded
  CHAIN_REFERENCE                   FILLER, -- Not loaded
  SOURCE_NETWORK                    FILLER, -- Not loaded
  DESTINATION_NETWORK               FILLER, -- Not loaded
  MSISDN                            CHAR, -- A_NUMBER
  B_MODIFICATION_INDICATOR          FILLER, -- Not loaded
  B_NUMBER                          FILLER, -- Not loaded
  DESCRIPTION                       FILLER, -- Not loaded
  USAGE_DIRECTION                   FILLER, -- Not loaded
  CONN_TYPE                         INTEGER EXTERNAL, -- CONNECT_TYPE
  CONNECT_SUB_TYPE                  FILLER, -- Not loaded
  BASIC_SERVICE                     FILLER, -- Not loaded
  QOS_REQUESTED                     FILLER, -- Not loaded
  QOS_USED                          FILLER, -- Not loaded
  CALL_COMPLETION_INDICATOR         FILLER, -- Not loaded
  LONG_DURATION_INDICATOR           FILLER, -- Not loaded
  UTC_TIME_OFFSET                   FILLER, -- Not loaded
  VOLUME_SENT                       FILLER, -- Not loaded
  BYTES_IN                          INTEGER EXTERNAL, -- VOLUME_RECEIVED
  NUMBER_OF_UNITS                   FLOAT EXTERNAL, -- NUMBER_OF_UNITS
  USAGE_CLASS                       CHAR, -- USAGE_CLASS
  USAGE_TYPE                        CHAR, -- USAGE_TYPE
  PREPAID_INDICATOR                 CHAR, -- PREPAID_INDICATOR
  INTERN_PROCESS_STATUS             FILLER, -- Not loaded
  CHARGING_START_TIMESTAMP          FILLER, -- Not loaded
  CHARGING_END_TIMESTAMP            FILLER, -- Not loaded
  NET_QUANTITY                      FILLER, -- Not loaded
  OBJ_ID0                           INTEGER EXTERNAL, -- Populated by REL

  -- From the Infranet Associated WAP record
  RECORD_TYPE2                      FILLER, -- Not loaded
  RECORD_NUMBER2                    FILLER, -- Not loaded
  IMSI                              CHAR, -- PORT_NUMBER
  IMEI                              CHAR, -- DEVICE_NUMBER
  SESSION_ID                        INTEGER EXTERNAL, -- SESSION_ID
  RECORDING_ENTITY                  CHAR, -- RECORDING_ENTITY
  TERMINAL_IP_ADDRESS               CHAR, -- TERMINAL_IP_ADDRESS
  URL                               CHAR(1024), -- DOMAIN_URL
  BEARER_TYPE                       CHAR, -- BEARER_SERVICE
  HTTP_STATUS                       INTEGER EXTERNAL, -- HTTP_STATUS
  WAP_STATUS                        INTEGER EXTERNAL, -- WAP_STATUS
  WAP_ACK_STATUS                    INTEGER EXTERNAL, -- ACKNOWLEDGE_STATUS
  ACK_TIME                          INTEGER EXTERNAL, -- ACKNOWLEDGE_TIME
  GGSN_ADDRESS                      CHAR, -- GGSN_ADDRESS
  SERVER_TYPE                       CHAR, -- SERVER_TYPE
  CHARGING_ID                       CHAR, -- CHARGING_ID
  LOGIN                             CHAR -- WAP_LOGIN
)

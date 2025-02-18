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
INTO TABLE EVENT_DELAYED_SESSION_GPRS_T
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
  ANONYMOUS_LOGIN                   INTEGER EXTERNAL, -- CONN_TYPE
  CONNECT_SUB_TYPE                  FILLER, -- Not loaded
  BASIC_SERVICE                     FILLER, -- Not loaded
  QOS_REQUESTED                     FILLER, -- Not loaded
  QOS_USED                          FILLER, -- Not loaded
  CLOSE_CAUSE                       INTEGER EXTERNAL, -- CALL_COMPLETION_INDICATOR
  SUB_TRANS_ID2                     FILLER, -- LONG_DURATION_INDICATOR
  UTC_TIME_OFFSET                   FILLER, -- Not loaded
  BYTES_OUT                         INTEGER EXTERNAL, -- BYTES_OUT
  BYTES_IN                          INTEGER EXTERNAL, -- BYTES_IN
  NUMBER_OF_UNITS                   FLOAT EXTERNAL, -- NUMBER_OF_UNITS
  USAGE_CLASS                       CHAR, -- USAGE_CLASS
  USAGE_TYPE                        CHAR, -- USAGE_TYPE
  PREPAID_INDICATOR                 FILLER, -- Not loaded
  INTERN_PROCESS_STATUS             FILLER, -- Not loaded
  CHARGING_START_TIMESTAMP          FILLER, -- Not loaded
  CHARGING_END_TIMESTAMP            FILLER, -- Not loaded
  NET_QUANTITY                      FILLER, -- Not loaded
  OBJ_ID0                           INTEGER EXTERNAL, -- Populated by REL

  -- From the Infranet Associated GPRS record
  RECORD_TYPE2                      FILLER, -- Not loaded
  RECORD_NUMBER2                    FILLER, -- Not loaded
  IMSI                              CHAR, -- PORT_NUMBER
  IMEI                              CHAR, -- DEVICE_NUMBER
  ROUTING_AREA                      CHAR, -- ROUTING_AREA
  LOC_AREA_CODE                     CHAR, -- LOCATION_AREA_INDICATOR
  SESSION_ID                        CHAR, -- CHARGING_ID
  SGSN_ADDRESS                      CHAR, -- SGSN_ADDRESS
  GGSN_ADDRESS                      CHAR, -- GGSN_ADDRESS
  APN                               CHAR, -- APN_ADDRESS
  NODE_ID                           CHAR, -- NODE_ID
  TRANS_ID                          CHAR, -- TRANS_ID
  SUB_TRANS_ID                      CHAR, -- SUB_TRANS_ID
  NI_PDP                            INTEGER EXTERNAL, -- NETWORK_INITIATED_PDP
  PDP_TYPE                          CHAR, -- PDP_TYPE
  PDP_ADDRESS                       CHAR, -- PDP_ADDRESS
  PDP_RADDRESS                      CHAR, -- PDP_REMOTE_ADDRESS
  PDP_DYNADDR                       CHAR, -- PDP_DYNAMIC_ADDRESS
  DIAGNOSTICS                       CHAR, -- DIAGNOSTICS
  CELL_ID                           CHAR, -- CELL_ID
  CHANGE_CONDITION                  INTEGER EXTERNAL, -- CHANGE_CONDITION
  QOS_REQ_PRECEDENCE                INTEGER EXTERNAL, -- QOS_REQUESTED_PRECEDENCE
  QOS_REQ_DELAY                     INTEGER EXTERNAL, -- QOS_REQUESTED_DELAY
  QOS_REQ_RELIABILITY               INTEGER EXTERNAL, -- QOS_REQUESTED_RELIABILITY
  QOS_REQ_PEAK_THROUGH              INTEGER EXTERNAL, -- QOS_REQUESTED_PEAK_THROUGHPUT
  QOS_REQ_MEAN_THROUGH              INTEGER EXTERNAL, -- QOS_REQUESTED_MEAN_THROUGHPUT
  QOS_NEGO_PRECEDENCE               INTEGER EXTERNAL, -- QOS_USED_PRECEDENCE
  QOS_NEGO_DELAY                    INTEGER EXTERNAL, -- QOS_USED_DELAY
  QOS_NEGO_RELIABILITY              INTEGER EXTERNAL, -- QOS_USED_RELIABILITY
  QOS_NEGO_PEAK_THROUGH             INTEGER EXTERNAL, -- QOS_USED_PEAK_THROUGHPUT
  QOS_NEGO_MEAN_THROUGH             INTEGER EXTERNAL, -- QOS_USED_MEAN_THROUGHPUT
  NETWORK_CAPABILITY                CHAR, -- NETWORK_CAPABILITY
  SGSN_CHANGE                       INTEGER EXTERNAL -- SGSN_CHANGE  
)

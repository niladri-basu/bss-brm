-- @(#)% %
--
-- Copyright (c) 2006, 2009, Oracle and/or its affiliates. 
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
  ORIGINAL_BATCH_ID                 FILLER TERMINATED BY X'09', -- Not loaded
  NETWORK_SESSION_ID                CHAR TERMINATED BY X'09', -- CHAIN_REFERENCE
  ORIGIN_NETWORK                    CHAR TERMINATED BY X'09', -- SOURCE_NETWORK
  DESTINATION_NETWORK               CHAR TERMINATED BY X'09', -- DESTINATION_NETWORK
  PRIMARY_MSID			    CHAR TERMINATED BY X'09', -- A_NUMBER
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
  BYTES_UPLINK			    FLOAT EXTERNAL TERMINATED BY X'09', -- BYTES_OUT 
  BYTES_DOWNLINK		    FLOAT EXTERNAL TERMINATED BY X'09', -- BYTES_IN
  NUMBER_OF_UNITS                   FILLER TERMINATED BY X'09', -- Not loaded
  USAGE_CLASS                       CHAR TERMINATED BY X'09', -- USAGE_CLASS
  USAGE_TYPE                        CHAR TERMINATED BY X'09', -- USAGE_TYPE
  PREPAID_INDICATOR                 FILLER TERMINATED BY X'09', -- Not loaded
  INTERN_PROCESS_STATUS             FILLER TERMINATED BY X'09', -- Not loaded
  CHARGING_START_TIMESTAMP          FILLER TERMINATED BY X'09', -- Not loaded
  CHARGING_END_TIMESTAMP            FILLER TERMINATED BY X'09', -- Not loaded
  NET_QUANTITY                      FILLER TERMINATED BY X'09', -- Not loaded
  OBJ_ID0                           INTEGER EXTERNAL TERMINATED BY X'09', -- Populated by REL

  -- From the Infranet Associated GPRS record
  RECORD_TYPE2                      FILLER TERMINATED BY X'09', -- Not loaded
  RECORD_NUMBER2                    FILLER TERMINATED BY X'09', -- Not loaded
  SECONDARY_MSID                    CHAR TERMINATED BY X'09', -- PORT_NUMBER
  DEVICE_NUMBER			    FILLER TERMINATED BY X'09', -- Not loaded 
  ROUTING_AREA			    FILLER TERMINATED BY X'09', -- Not loaded
  LOCATION_AREA_INDICATOR	    FILLER TERMINATED BY X'09', -- Not loaded
  CHARGING_ID			    FILLER TERMINATED BY X'09', -- Not loaded
  SGSN_ADDRESS			    FILLER TERMINATED BY X'09', -- Not loaded
  GGSN_ADDRESS			    FILLER TERMINATED BY X'09', -- Not loaded
  APN_ADDRESS			    FILLER TERMINATED BY X'09', -- Not loaded
  NODE_ID			    FILLER TERMINATED BY X'09', -- Not loaded
  TRANS_ID			    FILLER TERMINATED BY X'09', -- Not loaded
  SUB_TRANS_ID			    FILLER TERMINATED BY X'09', -- Not loaded
  NETWORK_INITIATED_PDP		    FILLER TERMINATED BY X'09', -- Not loaded
  PDP_TYPE			    FILLER TERMINATED BY X'09', -- Not loaded
  PDP_ADDRESS			    FILLER TERMINATED BY X'09', -- Not loaded
  PDP_REMOTE_ADDRESS		    FILLER TERMINATED BY X'09', -- Not loaded
  PDP_DYNAMIC_ADDRESS		    FILLER TERMINATED BY X'09', -- Not loaded
  DIAGNOSTICS			    FILLER TERMINATED BY X'09', -- Not loaded
  CELL_ID			    FILLER TERMINATED BY X'09', -- Not loaded
  CHANGE_CONDITION	            FILLER TERMINATED BY X'09', -- Not loaded
  QOS_REQUESTED_PRECEDENCE	    FILLER TERMINATED BY X'09', -- Not loaded	
  QOS_REQUESTED_DELAY		    FILLER TERMINATED BY X'09', -- Not loaded
  QOS_REQUESTED_RELIABILITY	    FILLER TERMINATED BY X'09', -- Not loaded 
  QOS_REQUESTED_PEAK_THROUGHPU 	    FILLER TERMINATED BY X'09', -- Not loaded
  QOS_REQUESTED_MEAN_THROUGHPU 	    FILLER TERMINATED BY X'09', -- Not loaded
  QOS_USED_PRECEDENC 		    FILLER TERMINATED BY X'09', -- Not loaded
  QOS_USED_DELA 		    FILLER TERMINATED BY X'09', -- Not loaded
  QOS_USED_RELIABILIT 		    FILLER TERMINATED BY X'09', -- Not loaded
  QOS_USED_PEAK_THROUGHPU           FILLER TERMINATED BY X'09', -- Not loaded
  QOS_USED_MEAN_THROUGHPU 	    FILLER TERMINATED BY X'09', -- Not loaded
  NETWORK_CAPABILIT 		    FILLER TERMINATED BY X'09', -- Not loaded
  SGSN_CHANGE 			    FILLER -- Not loaded 
)

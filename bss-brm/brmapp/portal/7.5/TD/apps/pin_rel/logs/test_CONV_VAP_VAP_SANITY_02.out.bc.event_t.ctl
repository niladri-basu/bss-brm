UNRECOVERABLE

LOAD DATA
CHARACTERSET UTF8
APPEND
INTO TABLE EVENT_T
SINGLEROW
PARTITION (P_D_05012015)
FIELDS TERMINATED BY X'09'
TRAILING NULLCOLS
(
  -- From the Infranet Detail record
  RECORD_TYPE                       FILLER, -- Not loaded
  RECORD_NUMBER                     FILLER, -- Not loaded
  EVENT_NO			    CHAR, -- Event Id
  BATCH_ID			    CHAR, -- Batch Id
  ORIGINAL_BATCH_ID		    CHAR, -- Original Batch Id
  CHAIN_REFERENCE                   FILLER, -- Not loaded
  SOURCE_NETWORK                    FILLER, -- Not loaded
  DESTINATION_NETWORK               FILLER, -- Not loaded
  A_NUMBER                          FILLER, -- Not loaded
  B_MODIFICATION_INDICATOR          FILLER, -- Not loaded
  B_NUMBER                          FILLER, -- Not loaded
  DESCR                             CHAR, -- DESCRIPTION
  USAGE_DIRECTION                   FILLER, -- Not loaded
  CONNECT_TYPE                      FILLER, -- Not loaded
  CONNECT_SUB_TYPE                  FILLER, -- Not loaded
  BASIC_SERVICE                     FILLER, -- Not loaded
  QOS_REQUESTED                     FILLER, -- Not loaded
  QOS_USED                          FILLER, -- Not loaded
  CALL_COMPLETION_INDICATOR         FILLER, -- Not loaded
  LONG_DURATION_INDICATOR           FILLER, -- Not loaded
  TIMEZONE_ID                       CHAR, -- UTC_TIME_OFFSET
  VOLUME_SENT                       FILLER, -- Not loaded
  VOLUME_RECEIVED                   FILLER, -- Not loaded
  NUMBER_OF_UNITS                   FILLER, -- Not loaded
  USAGE_CLASS                       FILLER, -- Not loaded
  USAGE_TYPE                        FILLER, -- Not loaded
  PREPAID_INDICATOR                 FILLER, -- Not loaded
  INTERN_PROCESS_STATUS             FILLER, -- Not loaded
  START_T                           INTEGER EXTERNAL, -- CHARGING_START_TIMESTAMP
  END_T                             INTEGER EXTERNAL, -- CHARGING_END_TIMESTAMP
  NET_QUANTITY                      FLOAT EXTERNAL,
  POID_ID0                          INTEGER EXTERNAL, -- Populated by REL

  -- From the Infranet Associated Billing record
  RECORD_TYPE2                      FILLER, -- Not loaded
  RECORD_NUMBER2                    FILLER, -- Not loaded
  ACCOUNT_OBJ_DB                    INTEGER  EXTERNAL TERMINATED BY X'20', -- ACCOUNT_POID
  ACCOUNT_OBJ_TYPE                   CHAR TERMINATED BY X'20', -- ACCOUNT_POID
  ACCOUNT_OBJ_ID0                   INTEGER EXTERNAL TERMINATED BY X'20', -- ACCOUNT_POID
  ACCOUNT_OBJ_REV                   INTEGER EXTERNAL, -- ACCOUNT_POID
  SERVICE_OBJ_DB                    INTEGER  EXTERNAL TERMINATED BY X'20', -- SERVICE_POID
  SERVICE_OBJ_TYPE                   CHAR TERMINATED BY X'20', -- SERVICE_POID
  SERVICE_OBJ_ID0                   INTEGER  EXTERNAL TERMINATED BY X'20', -- SERVICE_POID
  SERVICE_OBJ_REV                   INTEGER  EXTERNAL, -- SERVICE_POID
  ITEM_OBJ_DB                       INTEGER  EXTERNAL TERMINATED BY X'20', -- ITEM_POID
  ITEM_OBJ_TYPE                      CHAR TERMINATED BY X'20', -- ITEM_POID
  ITEM_OBJ_ID0                      INTEGER  EXTERNAL TERMINATED BY X'20', -- ITEM_POID
  ITEM_OBJ_REV                      INTEGER  EXTERNAL, -- ITEM_POID
  RERATE_OBJ_DB                     INTEGER  EXTERNAL TERMINATED BY X'20', -- ORIGINAL_EVENT_POID
  RERATE_OBJ_TYPE                    CHAR TERMINATED BY X'20', -- ORIGINAL_EVENT_POID
  RERATE_OBJ_ID0                    INTEGER  EXTERNAL TERMINATED BY X'20', -- ORIGINAL_EVENT_POID
  RERATE_OBJ_REV                    INTEGER  EXTERNAL, -- ORIGINAL_EVENT_POID
  TAX_LOCALES                       CHAR(1024), -- PIN_TAX_LOCALES
  RUM_NAME                          CHAR, -- RUM_NAME
  NUMBER_OF_BALANCE_PACKETS         FILLER, -- Not loaded
  INVOICE_DATA			    CHAR(4000), -- PIN_INVOICE_DATA

  -- Constant fields
  POID_REV                          CONSTANT 0,
  READ_ACCESS                       CONSTANT 'L',
  WRITE_ACCESS                      CONSTANT 'L',
  NAME                              CONSTANT 'Pre-rated Event',
  EARNED_START_T                    CONSTANT 0,
  EARNED_END_T                      CONSTANT 0,
  EARNED_TYPE                       CONSTANT 0,
  ARCHIVE_STATUS                    CONSTANT 0,
  EFFECTIVE_T                       CONSTANT 0,

  -- Fields modified by REL at run-time
  PROGRAM_NAME CONSTANT 'IREL',
  CREATED_T CONSTANT '1429002953',
  MOD_T CONSTANT '1429002953',
  POID_DB CONSTANT '1',
  POID_TYPE CONSTANT '/event/delayed/session/telco/gsm/valuepack',
  SYS_DESCR CONSTANT '/event/delayed/session/telco/gsm/valuepack',
  SESSION_OBJ_DB CONSTANT '1',
  SESSION_OBJ_TYPE CONSTANT '/batch/rel',
  SESSION_OBJ_ID0 CONSTANT '290957164989288806',
  SESSION_OBJ_REV CONSTANT '0',
  USERID_DB CONSTANT '1',
  USERID_TYPE CONSTANT '/service/admin_client',
  USERID_ID0 CONSTANT '2',
  USERID_REV CONSTANT '5'
)

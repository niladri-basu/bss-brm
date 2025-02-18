UNRECOVERABLE

LOAD DATA
CHARACTERSET UTF8
APPEND
INTO TABLE EVENT_DLYD_SESSION_BAL_CUST_T
SINGLEROW
PARTITION (P_D_05012015)
FIELDS TERMINATED BY X'09'
(
  RECORD_TYPE                           FILLER, -- Not loaded
  RESOURCE_NAME                              CHAR,
  QUANTITY_APPLIED                              FLOAT EXTERNAL,
  BALANCE_QUANTITY                              FLOAT EXTERNAL,
  OBJ_ID0                               INTEGER EXTERNAL, -- Filled in by REL
  REC_ID                                INTEGER EXTERNAL  -- Filled in by REL
)

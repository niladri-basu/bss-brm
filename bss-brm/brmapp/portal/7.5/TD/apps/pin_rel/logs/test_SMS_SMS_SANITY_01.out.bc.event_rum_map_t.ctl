UNRECOVERABLE

LOAD DATA
CHARACTERSET UTF8
APPEND
INTO TABLE EVENT_RUM_MAP_T
SINGLEROW
PARTITION (P_D_05012015)
FIELDS TERMINATED BY X'09'
(
  RECORD_TYPE                           FILLER, -- Not loaded
  RECORD_NUMBER                         FILLER, -- Not loaded
  RUM_NAME                              CHAR,
  NET_QUANTITY                          FLOAT EXTERNAL,
  UNRATED_QUANTITY                      FLOAT EXTERNAL,
  OBJ_ID0                               INTEGER EXTERNAL, -- Filled in by REL
  REC_ID                                INTEGER EXTERNAL  -- Filled in by REL
)

UNRECOVERABLE

LOAD DATA
CHARACTERSET UTF8
APPEND
INTO TABLE EVENT_TAX_JURISDICTIONS_T
SINGLEROW
PARTITION (P_D_05012015)
FIELDS TERMINATED BY X'09'
(
  RECORD_TYPE                           FILLER, -- Not loaded
  RECORD_NUMBER                         FILLER, -- Not loaded
  TYPE                                  INTEGER EXTERNAL,
  AMOUNT                                FLOAT EXTERNAL,
  AMOUNT_TAXED                          FLOAT EXTERNAL,
  PERCENT                               FLOAT EXTERNAL,
  AMOUNT_GROSS                          FLOAT EXTERNAL,
  AMOUNT_EXEMPT                         CONSTANT 0,-- Set to zero as exemption isn't handled
  NAME                                  CONSTANT X'20',-- Set to space
  OBJ_ID0                               INTEGER EXTERNAL, -- Filled in by REL
  REC_ID                                INTEGER EXTERNAL, -- Filled in by REL
  ELEMENT_ID                            INTEGER EXTERNAL -- Filled ib by REL
)

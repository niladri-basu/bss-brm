UNRECOVERABLE

LOAD DATA
CHARACTERSET UTF8
APPEND 
INTO TABLE EVENT_BAL_IMPACTS_T
SINGLEROW 
PARTITION (P_D_05012015)
FIELDS TERMINATED BY X'09'
(
  -- From the Infranet Balance Impact record
  RECORD_TYPE2				FILLER, -- Not loaded
  RECORD_NUMBER2			FILLER, -- Not loaded
  ACCOUNT_OBJ_DB			INTEGER EXTERNAL TERMINATED BY X'20', -- ACCOUNT_POID
  ACCOUNT_OBJ_TYPE			 CHAR TERMINATED BY X'20', -- ACCOUNT_POID
  ACCOUNT_OBJ_ID0			INTEGER EXTERNAL TERMINATED BY X'20', -- ACCOUNT_POID
  ACCOUNT_OBJ_REV			INTEGER EXTERNAL, -- ACCOUNT_POID
  BAL_GRP_OBJ_DB			INTEGER EXTERNAL TERMINATED BY X'20', -- ACCOUNT_POID
  BAL_GRP_OBJ_TYPE			 CHAR TERMINATED BY X'20', -- ACCOUNT_POID
  BAL_GRP_OBJ_ID0			INTEGER EXTERNAL TERMINATED BY X'20', -- ACCOUNT_POID
  BAL_GRP_OBJ_REV			INTEGER EXTERNAL, -- ACCOUNT_POID
  ITEM_OBJ_DB				INTEGER EXTERNAL TERMINATED BY X'20', -- ITEM_POID
  ITEM_OBJ_TYPE				 CHAR TERMINATED BY X'20', -- ITEM_POID
  ITEM_OBJ_ID0				INTEGER EXTERNAL TERMINATED BY X'20', -- ITEM_POID
  ITEM_OBJ_REV				INTEGER EXTERNAL, -- ITEM_POID
  RESOURCE_ID				INTEGER EXTERNAL, -- PIN_RESOURCE_ID
  RESOURCE_ID_ORIG			INTEGER EXTERNAL, -- PIN_FLD_RESOURCE_ID_ORIG
  IMPACT_CATEGORY			CHAR, -- PIN_IMPACT_CATEGORY
  IMPACT_TYPE				INTEGER EXTERNAL, --PIN_IMPACT_TYPE 
  PRODUCT_OBJ_DB			INTEGER EXTERNAL TERMINATED BY X'20', -- PIN_PRODUCT_POID
  PRODUCT_OBJ_TYPE			 CHAR TERMINATED BY X'20', -- PIN_PRODUCT_POID
  PRODUCT_OBJ_ID0			INTEGER EXTERNAL TERMINATED BY X'20', -- PIN_PRODUCT_POID
  PRODUCT_OBJ_REV			INTEGER EXTERNAL, -- PIN_PRODUCT_POID
  GL_ID					INTEGER EXTERNAL, -- PIN_GL_ID
  RUM_ID				INTEGER EXTERNAL, -- RUM_ID
  TAX_CODE				CHAR, -- PIN_TAX_CODE
  RATE_TAG				CHAR, -- PIN_RATE_TAG
  LINEAGE				CHAR, -- PIN_LINEAGE
  OFFERING_OBJ_DB			INTEGER EXTERNAL TERMINATED BY X'20', -- PIN_OFFERING_POID
  OFFERING_OBJ_TYPE			 CHAR TERMINATED BY X'20', -- PIN_OFFERING_POID
  OFFERING_OBJ_ID0			INTEGER EXTERNAL TERMINATED BY X'20', -- PIN_OFFERING_POID
  OFFERING_OBJ_REV			INTEGER EXTERNAL, -- PIN_OFFERING_POID
  QUANTITY				FLOAT EXTERNAL, -- PIN_QUANTITY
  AMOUNT				FLOAT EXTERNAL, -- PIN_AMOUNT
  AMOUNT_ORIG				FLOAT EXTERNAL, -- PIN_FLD_AMOUNT_ORIG
  AMOUNT_DEFERRED			FLOAT EXTERNAL, -- PIN_AMOUNT_DEFERRED
  DISCOUNT				FLOAT EXTERNAL, -- PIN_DISCOUNT
  PERCENT				FLOAT EXTERNAL, -- PIN_FLD_PERCENT
  DISCOUNT_INFO				FILLER, -- PIN_INFO_STRING, not loaded
  OBJ_ID0				INTEGER EXTERNAL, -- Populated by REL
  REC_ID				INTEGER EXTERNAL -- Populated by REL

)

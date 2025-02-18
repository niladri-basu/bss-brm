--
-- @(#)item_t.ctl 3
--
-- Copyright (c) 2004, 2009, Oracle and/or its affiliates.
-- All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE ITEM_T TRAILING NULLCOLS
   (
        ACCOUNT_OBJ_DB                   INTEGER EXTERNAL TERMINATED BY ',',
        ACCOUNT_OBJ_ID0                  INTEGER EXTERNAL TERMINATED BY ',',
        BILLINFO_OBJ_DB                  INTEGER EXTERNAL TERMINATED BY ',',
        BILLINFO_OBJ_ID0                 INTEGER EXTERNAL TERMINATED BY ',',
        BILL_OBJ_DB                      INTEGER EXTERNAL TERMINATED BY ',',
        BILL_OBJ_ID0                     INTEGER EXTERNAL TERMINATED BY ',',
        AR_BILLINFO_OBJ_DB               INTEGER EXTERNAL TERMINATED BY ',',
        AR_BILLINFO_OBJ_ID0              INTEGER EXTERNAL TERMINATED BY ',',
        CREATE_T                         BOUNDFILLER TERMINATED BY ',',
        CURRENCY                         INTEGER EXTERNAL TERMINATED BY ',',
        POID_DB                          INTEGER EXTERNAL TERMINATED BY ',',
        POID_ID0                         INTEGER EXTERNAL TERMINATED BY ',',
        POID_TYPE                        CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        SERVICE_OBJ_DB                   INTEGER EXTERNAL TERMINATED BY ',',
        SERVICE_OBJ_ID0                  INTEGER EXTERNAL TERMINATED BY ',',
        SERVICE_OBJ_TYPE                 CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        BAL_GRP_OBJ_DB                   INTEGER EXTERNAL TERMINATED BY ',',
        BAL_GRP_OBJ_ID0                  INTEGER EXTERNAL TERMINATED BY ',',
        BAL_GRP_OBJ_TYPE                 CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        BAL_GRP_OBJ_REV                  INTEGER EXTERNAL TERMINATED BY ',',
        CREATED_T                        ":CREATE_T",
        MOD_T                            ":CREATE_T",

-- Constant Values
        ACCOUNT_OBJ_TYPE                 CONSTANT '/account',
        ACCOUNT_OBJ_REV                  CONSTANT '0',
        ADJUSTED                         CONSTANT '0',
        AR_BILLINFO_OBJ_TYPE             CONSTANT '/billinfo',
        AR_BILLINFO_OBJ_REV              CONSTANT '0',
        AR_BILL_OBJ_DB                   CONSTANT '0',
        AR_BILL_OBJ_ID0                  CONSTANT '0',
        AR_BILL_OBJ_REV                  CONSTANT '0',
        BILLINFO_OBJ_TYPE                CONSTANT '/billinfo',
        BILLINFO_OBJ_REV                 CONSTANT '0',
        BILL_OBJ_TYPE                    CONSTANT '/bill',
        BILL_OBJ_REV                     CONSTANT '0',
        CURRENCY_OPERATOR                CONSTANT '0',
        CURRENCY_RATE                    CONSTANT '0',
        CURRENCY_SECONDARY               CONSTANT '0',
        DISPUTED                         CONSTANT '0',
        DUE                              CONSTANT '0',
        DUE_T                            CONSTANT '0',
        EFFECTIVE_T                      CONSTANT '0',
        ITEM_TOTAL                       CONSTANT '0',
        NAME                             CONSTANT 'Usage',
        POID_REV                         CONSTANT '0',
        READ_ACCESS                      CONSTANT 'L',
        RECVD                            CONSTANT '0',
        SERVICE_OBJ_REV                  CONSTANT '0',
        STATUS                           CONSTANT '1',
        TRANSFERED                       CONSTANT '0',
        WRITEOFF                         CONSTANT '0',
        ARCHIVE_STATUS                   CONSTANT '0',
        CLOSED_T                         CONSTANT '0',
        OPENED_T                         CONSTANT '0',
        GL_SEGMENT                       CONSTANT '.',
        WRITE_ACCESS                     CONSTANT 'L'
-- These fields will be entered as NULL
--      AR_BILL_OBJ_TYPE                 NULL
--      EVENT_POID_LIST                  NULL
--      GL_SEGMENT                       NULL
--      MOD_T                            NULL
--      ITEM_NO                          NULL
   )

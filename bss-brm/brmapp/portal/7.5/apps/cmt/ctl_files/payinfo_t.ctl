--
-- @(#)payinfo_t.ctl 3
--
-- Copyright (c) 2004, 2012, Oracle and/or its affiliates.
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
   INTO TABLE PAYINFO_T TRAILING NULLCOLS
  (
        POID_DB                 INTEGER EXTERNAL TERMINATED BY ',',
        POID_ID0                INTEGER EXTERNAL TERMINATED BY ',',
        POID_TYPE               CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        CREATE_T                BOUNDFILLER TERMINATED BY ',',
        ACCOUNT_OBJ_DB          INTEGER EXTERNAL TERMINATED BY ',',
        ACCOUNT_OBJ_ID0         INTEGER EXTERNAL TERMINATED BY ',',
        INVOICE_OBJ_DB          INTEGER EXTERNAL TERMINATED BY ',',
        DUE_DOM                 INTEGER EXTERNAL TERMINATED BY ',',
        PAYMENT_TERM            INTEGER EXTERNAL TERMINATED BY ',',
        RELATIVE_DUE_T          INTEGER EXTERNAL TERMINATED BY ',',
        ACH                     INTEGER EXTERNAL TERMINATED BY ',',
        NAME                    CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' "nvl(:NAME,'PIN Payinfo Object')",
        CREATED_T               ":CREATE_T",
        MOD_T                   ":CREATE_T",

-- Constant vlaues
        POID_REV                CONSTANT '1',
        READ_ACCESS             CONSTANT 'L',
        WRITE_ACCESS            CONSTANT 'L',
        ACCOUNT_OBJ_TYPE        CONSTANT '/account',
        ACCOUNT_OBJ_REV         CONSTANT '0',
        INVOICE_OBJ_ID0         CONSTANT '-1',
        INVOICE_OBJ_TYPE        CONSTANT '/invoice',
        INVOICE_OBJ_REV         CONSTANT '0',
        PAYMENT_OFFSET          CONSTANT '-1',
        INV_TYPE                CONSTANT '0'
-- These fields will be entered as NULL
--      MOD_T                   NULL

)

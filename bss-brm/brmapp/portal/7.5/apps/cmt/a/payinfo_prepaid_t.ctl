--
-- @(#)payinfo_prepaid_t.ctl 2
--
--     Copyright (c) 2004-2006 Oracle. All rights reserved.
--
--     This material is the confidential property of Oracle Corporation
--     or its licensors and may be used, reproduced, stored or transmitted
--     only in accordance with a valid Oracle license or sublicense agreement.
--
--
--
LOAD DATA
APPEND
   INTO TABLE PAYINFO_PREPAID_T
   (
        OBJ_ID0                         INTEGER EXTERNAL TERMINATED BY ',',
        TEXT_COL                        FILLER TERMINATED BY ',',
        REC_ID                          INTEGER EXTERNAL TERMINATED BY ',',
        COMPANY_NAME                    CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        PREFERRED_CONTACT_EMAIL         CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        FIRST_NAME                      CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        SECOND_NAME                     CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        PREFERRED_CONTACT_PHONE         CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        SALUTATION                      CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        ADDRESS                         CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        CITY                            CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        COUNTRY                         CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        STATE                           CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        ZIP                             CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- These fields will be entered as NULL
--      NAME             NULL
)

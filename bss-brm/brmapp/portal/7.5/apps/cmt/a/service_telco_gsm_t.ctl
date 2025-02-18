--
-- @(#)service_telco_gsm_t.ctl 2
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
   INTO TABLE service_telco_gsm_t(
        OBJ_ID0                 INTEGER EXTERNAL TERMINATED BY ',',
        TEXT_COL                FILLER TERMINATED BY ',',
        IMEI                    CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
        BEARER_SERVICE          CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    )

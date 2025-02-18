--
-- @(#)service_telco_t.ctl 2
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
   INTO TABLE SERVICE_TELCO_T
   (
        OBJ_ID0                 INTEGER EXTERNAL TERMINATED BY ',',
        TEXT_COL                FILLER TERMINATED BY ',',
        PRIMARY_NUMBER          INTEGER EXTERNAL TERMINATED BY ','
    )

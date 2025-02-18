--
-- @(#)group_sharing_discounts_t.ctl 3
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
   INTO TABLE GROUP_SHARING_DISCOUNTS_T
   (
	OBJ_ID0                    INTEGER EXTERNAL TERMINATED BY ',',
	REC_ID                     INTEGER EXTERNAL TERMINATED BY ',',
	DISCOUNT_OBJ_DB            INTEGER EXTERNAL TERMINATED BY ',',
	DISCOUNT_OBJ_ID0           INTEGER EXTERNAL TERMINATED BY ',',
	OFFERING_OBJ_DB            INTEGER EXTERNAL TERMINATED BY ',',
	OFFERING_OBJ_ID0           INTEGER EXTERNAL TERMINATED BY ',',
-- Constant Values	
	DISCOUNT_OBJ_TYPE          CONSTANT '/discount',
	DISCOUNT_OBJ_REV           CONSTANT '0',
	OFFERING_OBJ_TYPE          CONSTANT '/purchased_discount',
	OFFERING_OBJ_REV           CONSTANT '0'
   )	

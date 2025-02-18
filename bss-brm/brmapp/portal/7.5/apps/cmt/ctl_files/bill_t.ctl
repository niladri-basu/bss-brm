--
-- @(#)bill_t.ctl 2
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
   INTO TABLE BILL_T
   (
	ACCOUNT_OBJ_DB            	INTEGER EXTERNAL TERMINATED BY ',',
	ACCOUNT_OBJ_ID0                 INTEGER EXTERNAL TERMINATED BY ',',
	BILLINFO_OBJ_DB           	INTEGER EXTERNAL TERMINATED BY ',',
	BILLINFO_OBJ_ID0                INTEGER EXTERNAL TERMINATED BY ',',
	AR_BILLINFO_OBJ_DB        	INTEGER EXTERNAL TERMINATED BY ',',
	AR_BILLINFO_OBJ_ID0             INTEGER EXTERNAL TERMINATED BY ',',
	PARENT_BILLINFO_OBJ_DB          INTEGER EXTERNAL TERMINATED BY ',',
	PARENT_BILLINFO_OBJ_ID0         INTEGER EXTERNAL TERMINATED BY ',',	
	PARENT_BILLINFO_OBJ_TYPE        CHAR TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"',
	CREATED_T                       INTEGER EXTERNAL TERMINATED BY ',',
	CURRENCY                        INTEGER EXTERNAL TERMINATED BY ',',
	POID_DB                   	INTEGER EXTERNAL TERMINATED BY ',',
	POID_ID0                        INTEGER EXTERNAL TERMINATED BY ',',	
	START_T                         INTEGER EXTERNAL TERMINATED BY ',',
	
-- Constant Values
	ACCOUNT_OBJ_TYPE          	CONSTANT '/account',
	ACCOUNT_OBJ_REV           	CONSTANT '0',
	BILLINFO_OBJ_TYPE         	CONSTANT '/billinfo',
	BILLINFO_OBJ_REV          	CONSTANT '0',
	AR_BILLINFO_OBJ_TYPE      	CONSTANT '/billinfo',
	AR_BILLINFO_OBJ_REV       	CONSTANT '0',
	PARENT_BILLINFO_OBJ_REV         CONSTANT '0',
	CURRENCY_OPER                   CONSTANT '0',
	CURRENCY_SECONDARY              CONSTANT '0',
	END_T                           CONSTANT '0',
	FLAGS                           CONSTANT '0',
	NAME                            CONSTANT 'PIN Bill',
	PARENT_DB                       CONSTANT '0',
	PARENT_ID0                      CONSTANT '0',	
	PARENT_REV                      CONSTANT '0',
	CURRENCY_RATE                   CONSTANT '0',
	CURRENT_TOTAL                   CONSTANT '0',
	DUE_T                           CONSTANT '0',
	POID_TYPE                 	CONSTANT '/bill',
	POID_REV                  	CONSTANT '1',
	PREVIOUS_TOTAL                  CONSTANT '0',
	READ_ACCESS               	CONSTANT 'L',
	WRITE_ACCESS              	CONSTANT 'L',
	SUBORDS_TOTAL                   CONSTANT '0',
	TOTAL_DUE                       CONSTANT '0',
	ADJUSTED                        CONSTANT '0',
	DISPUTED                        CONSTANT '0',
	DUE                             CONSTANT '0',
	RECVD                           CONSTANT '0',
	WRITEOFF                        CONSTANT '0',
	TRANSFERRED                     CONSTANT '0',
	INVOICE_OBJ_DB                  CONSTANT '0',
	INVOICE_OBJ_ID0                 CONSTANT '0',
	INVOICE_OBJ_REV                 CONSTANT '0'
-- These fields will entered as NULL	
--	INVOICE_OBJ_TYPE                NULL
--	MOD_T				NULL
--	PARENT_TYPE                     NULL
--	BILL_NO                         NULL
   )

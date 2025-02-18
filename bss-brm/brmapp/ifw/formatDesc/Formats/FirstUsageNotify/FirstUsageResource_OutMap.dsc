// @(#)% %
//==================================================================================
//
//       Copyright (c) 2006 Oracle. All rights reserved.
//
//       This material is the confidential property of Oracle Corporation
//       or its licensors and may be used, reproduced, stored or transmitted
//       only in accordance with a valid Oracle license or sublicense agreement.
//
//-----------------------------------------------------------------------------------
// Block: FMD
//-----------------------------------------------------------------------------------
// Module Description:
//   Output Mapping of a FirstUsageResource UEL output format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//
//
//-----------------------------------------------------------------------------------
// Responsible: Ramesh A
//
//===================================================================================

FIRST_USAGE_RESOURCE
{
  //---------------------------------------------------------------------------------
  // Detail record
  //---------------------------------------------------------------------------------
  UPDATE_BAL_ACCT
  {
    UPDATE_BAL_ACCT_MAPPING
    {
      ACCOUNT_POID_STR                    <- DETAIL.CUST_A.ACCOUNT_PARENT_ID;    

    }
  }


  //---------------------------------------------------------------------------------
  // Update Balance  record
  //---------------------------------------------------------------------------------
  UPDATE_BALANCE
  {
    UPDATE_BALANCE_MAPPING
    {
      BALANCE_GROUP_ID                    <- DETAIL.ASS_CBD.UBP.BALANCE_GROUP_ID;
      RESOURCE_ID                         <- DETAIL.ASS_CBD.UBP.RESOURCE_ID;
      RECORD_NUMBER                       <- DETAIL.ASS_CBD.UBP.RECORD_NUMBER;
      VALID_FROM                          <- DETAIL.ASS_CBD.UBP.VALID_FROM;
      VALID_TO                            <- DETAIL.ASS_CBD.UBP.VALID_TO;
      VALID_FROM_DETAILS                  <- DETAIL.ASS_CBD.UBP.VALID_FROM_DETAIL;
      VALID_TO_DETAILS                    <- DETAIL.ASS_CBD.UBP.VALID_TO_DETAIL;
      CONTRIBUTOR                         <- DETAIL.ASS_CBD.UBP.CONTRIBUTOR;
      GRANTOR                             <- DETAIL.ASS_CBD.UBP.GRANTOR;
      GRANT_VALID_FROM                    <- DETAIL.ASS_CBD.UBP.GRANT_VALID_FROM;
      GRANT_VALID_TO                      <- DETAIL.ASS_CBD.UBP.GRANT_VALID_TO;

    }
  }


  //--------------------------------------------------------------------------------- 
  // Discount Sub-Balances mapping for other fields
  //---------------------------------------------------------------------------------
  DISCOUNT_SUB_BAL
  {
    DISCOUNT_SUB_BAL_MAPPING
    {
      BALANCE_GROUP_ID                    <- DETAIL.ASS_CBD.DP.BALANCE_GROUP_ID;
      RESOURCE_ID                         <- DETAIL.ASS_CBD.DP.RESOURCE_ID;
      RECORD_NUMBER                       <- DETAIL.ASS_CBD.DP.SUB_BALANCE.REC_ID;
      VALID_FROM                          <- DETAIL.ASS_CBD.DP.SUB_BALANCE.VALID_FROM;
      VALID_TO                            <- DETAIL.ASS_CBD.DP.SUB_BALANCE.VALID_TO;
      VALID_FROM_DETAILS                  <- DETAIL.ASS_CBD.DP.SUB_BALANCE.VALID_FROM_DETAILS;
      VALID_TO_DETAILS                    <- DETAIL.ASS_CBD.DP.SUB_BALANCE.VALID_TO_DETAILS;
      CONTRIBUTOR                         <- DETAIL.ASS_CBD.DP.SUB_BALANCE.CONTRIBUTOR;
      GRANTOR                             <- DETAIL.ASS_CBD.DP.SUB_BALANCE.GRANTOR;
      GRANT_VALID_FROM                    <- DETAIL.ASS_CBD.DP.SUB_BALANCE.GRANT_VALID_FROM;
      GRANT_VALID_TO                      <- DETAIL.ASS_CBD.DP.SUB_BALANCE.GRANT_VALID_TO;

    }
  }

  END_BLOCK
  {
    END_BLOCK_MAPPING
    {
      EOL                                 <- "\n";

    }
  }


}

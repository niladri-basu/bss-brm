//=============================================================================
//
//       Copyright (c) 2004 - 2006 Oracle. All rights reserved.
//
//       This material is the confidential property of Oracle Corporation
//       or its licensors and may be used, reproduced, stored or transmitted
//       only in accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: FMD
//------------------------------------------------------------------------------
// Module Description:
//   Output mapping for the Solution42 V6.70 CDR format with Account_Poid and Billinfo 
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//------------------------------------------------------------------------------
// Responsible: Archana Elapavuluri
//
// $RCSfile: TriggerBilling_OutMap.dsc,v $
// $Revision: 1 $
// $Author: aelapavu $
// $Date: 2004/29/04 06:54:55 $
// $Locker:  $
//------------------------------------------------------------------------------
//==============================================================================

TRIGGER_BILL
{     

  ASSOCIATED_INFRANET
  {
    STD_MAPPING
    {
     RARRAY_PREFIX                      <- "0 PIN_FLD_RESULTS ARRAY [";
     RECORD_NUMBER                      <- DETAIL.TB_RECORD_NUMBER;
     ARRAY_SUFFIX                       <- "]\n";
     AARRAY_PREFIX                      <- "1 PIN_FLD_POID POID [0] 0.0.0.1 /billinfo "; 
     INTERN_SERVICE_BILL_INFO_ID        <- DETAIL.INTERN_SERVICE_BILL_INFO_ID;
     LINE_END                           <- "\n";
     BARRAY_PREFIX                      <- "1 PIN_FLD_ACCOUNT_OBJ POID [0] 0.0.0.1 ";
     ACCOUNT_POID                       <- DETAIL.ACCOUNT_ID;
   }
  }
 
}

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
//   Output Mapping of a FirstUsageNotify UEL output format
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

FIRST_USAGE_NOTIFY
{
  //---------------------------------------------------------------------------------
  // Detail record
  //---------------------------------------------------------------------------------
  DETAIL
  {
    DETAIL_MAPPING
    {
      ACCOUNT_POID_STR                    <- DETAIL.ASS_PIN.FIRST_USAGE.ACCOUNT_POID_STR;    
      SERVICE_POID_STR                    <- DETAIL.ASS_PIN.FIRST_USAGE.SERVICE_POID_STR;   
      OFFERING_POID_STR                   <- DETAIL.ASS_PIN.FIRST_USAGE.OFFERING_POID_STR;   
      START_T                             <- DETAIL.ASS_PIN.FIRST_USAGE.START_T;
      UTC_TIME_OFFSET                     <- DETAIL.ASS_PIN.FIRST_USAGE.UTC_TIME_OFFSET;
      DESCRIPTION                         <- DETAIL.ASS_PIN.FIRST_USAGE.DESCRIPTION;
      FLAGS                               <- DETAIL.ASS_PIN.FIRST_USAGE.FLAGS;    

    }
  }

}

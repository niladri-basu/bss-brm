//==============================================================================
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
//   Description of the TriggerBilling  CDR format 
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//------------------------------------------------------------------------------
// Responsible: Archana  Elapavuluri
//
// $RCSfile: TriggerBilling.dsc,v $
// $Revision: 1 $
// $Author: aelapavu $
// $Date: 2004/29/04 06:54:55 $
// $Locker:  $
//------------------------------------------------------------------------------
//==============================================================================

TRIGGER_BILL
{

ASSOCIATED_INFRANET (SEPARATED)
{
    Info
    {
      Pattern = "900.*\t";
      FieldSeparator = ' ';
      RecordSeparator = '\n';
    }
    RARRAY_PREFIX                AscString();
    RECORD_NUMBER                AscInteger();
    ARRAY_SUFFIX                 AscString();
    AARRAY_PREFIX                         AscString(); 
    INTERN_SERVICE_BILL_INFO_ID                        AscString();
    LINE_END                           AscString();
    BARRAY_PREFIX                         AscString();
    ACCOUNT_POID          AscString();
}


 
}

//==============================================================================
//
//       Copyright (c) 2004 - 2006 Oracle. All rights reserved.
//
//       This material is the confidential property of Oracle Corporation
//       or its licensors and may be used, reproduced, stored or transmitted
//       only in accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: LRP
//------------------------------------------------------------------------------
// Module Description:
//    I/O output grammar file for the Solution42 V6.70 CDR format 
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
// $RCSfile: TriggerBilling_OutGrammar.dsc,v $
// $Revision: 1.0 $
// $Author: aelapavu $
// $Date: 2004/04/29 08:13:06 $
// $Locker:  $
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Revision : 10001  6.7_FP2  25-Aug-2004 Patricia
// PRSF00128181  : Set recordNumber to the proper grammar definition edr_stream 
// section. Should not initialize at the initial iScript code.
//------------------------------------------------------------------------------
// Revision : 10000  6.7_FP2  25-Aug-2004 Patricia
// PRSF00127768  : Added checking empty stream file function to iScript code.                       
// As the empty output stream file is not deleted
//==============================================================================

//==============================================================================
// The initial iScript code
//==============================================================================
iScript
{

  Long recordNumber;
  Long results_recordNum;  
  Long records;
  Long i;
  String account_poid;


  //----------------------------------------------------------------------------
  // Check if the file contains only HEADER
  //----------------------------------------------------------------------------
  function Bool streamIsEmpty
  {
    if ( recordNumber <= 1 )
    {
      // Only HEADER
      return true;
    }
    else
    {
      // At least one DETAIL
      return false;
    }
  }
}

//==============================================================================
// The definition of the grammar
//==============================================================================
Grammar
{
  //----------------------------------------------------------------------------
  // The EDR stream
  //----------------------------------------------------------------------------
  edr_stream:
      HEADER
        { 
          recordNumber = 1;
          edrLong( HEADER.RECORD_NUMBER ) = recordNumber;
        }
      details
      TRAILER
        {
        }
    ;

  //----------------------------------------------------------------------------
  // A list of DETAIL records
  //----------------------------------------------------------------------------
  details: 
      details 
      DETAIL
       {
           edrLong( DETAIL.TB_RECORD_NUMBER) = results_recordNum;
           account_poid = "/account" + strReplace(edrString(DETAIL.INTERN_DISCOUNT_OWNER_ACCT_ID),0,2," ") + " 0";

           edrString(DETAIL.ACCOUNT_ID) = account_poid;

           edrOutputMap( "TRIGGER_BILL.ASSOCIATED_INFRANET.STD_MAPPING");
           recordNumber = recordNumber + 1;
           results_recordNum = results_recordNum + 1;
        }
          
    | /* EMPTY */
    ;
}

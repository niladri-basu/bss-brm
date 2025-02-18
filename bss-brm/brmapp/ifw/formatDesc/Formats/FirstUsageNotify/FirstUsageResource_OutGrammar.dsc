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
// Block: LRP
//-----------------------------------------------------------------------------------
// Module Description:
//   Generic I/O output grammar file for the FirstUsageResource UEL output format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//-----------------------------------------------------------------------------------
// Responsible: Ramesh A
//
//===================================================================================


//==============================================================================
// The initial iScript code
//==============================================================================
iScript
{
  Long    recordNumber;
  Long    i;
  Long    j;
  Long    k;
  Long    packets;
  Long    discPackets;
  Long    discSubBalPackets;
  Long    subPackets;
  String  list[];
  Long    numList;
  String  dbNumber;
  String  accountObj;

  //constants
  const String DUMMY_GRANTOR = "0.0.0.1 /dummy 0 0";
  const String DEFAULT_CONTRIBUTOR = "*";


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
      }
      details
      TRAILER
      ;

  //----------------------------------------------------------------------------
  // A list of DETAIL records
  //----------------------------------------------------------------------------
  details:
      details
      DETAIL
        {
          recordNumber = recordNumber + 1;
          //--------------------------------------------------------------------
          // Write the DETAIL
          //--------------------------------------------------------------------
          // Get the Account Obj Poid.    
          numList =  strSplit( list, edrString(DETAIL.CUST_A.ACCOUNT_PARENT_ID, 0), "_");  
          dbNumber = list[0];
          // Add an extra tab at the end of the poid string, so that UEL would use that as
          // placeholder to put a dummy value for service poid str
          accountObj = "0.0.0."+dbNumber+" "+"/account"+" "+list[1]+" 0\t";
          edrString(DETAIL.CUST_A.ACCOUNT_PARENT_ID, 0) = accountObj;

          packets = edrNumDatablocks(DETAIL.ASS_CBD);
          
          for ( i = 0; i < packets; i = i+1 )
          {
             edrOutputMap( "FIRST_USAGE_RESOURCE.UPDATE_BAL_ACCT.UPDATE_BAL_ACCT_MAPPING", 0 );

             discPackets=edrNumDatablocks(DETAIL.ASS_CBD.DP,i);
             for ( j = 0; j < discPackets; j = j+1 )
             {
               discSubBalPackets=edrNumDatablocks(DETAIL.ASS_CBD.DP.SUB_BALANCE,i,j);

               for ( k = 0; k< discSubBalPackets; k = k+1 )
               {

                 // These grantor and contributor may not be populated in non-pipeline grant scenarios 
                 // in which cases, these fields are not used by the change_validity_from_string opcode. 
                 // But still it could break the parsing. So just a filler.
                 if ( edrString(DETAIL.ASS_CBD.DP.SUB_BALANCE.CONTRIBUTOR, i, j, k) == "" )
                 {
                   edrString(DETAIL.ASS_CBD.DP.SUB_BALANCE.CONTRIBUTOR, i, j, k) = DEFAULT_CONTRIBUTOR;
                 }

                 if ( edrString(DETAIL.ASS_CBD.DP.SUB_BALANCE.GRANTOR, i, j, k) == "" )
                 {
                   edrString(DETAIL.ASS_CBD.DP.SUB_BALANCE.GRANTOR, i, j, k) = DUMMY_GRANTOR;
                 }

                 if ( edrLong(DETAIL.ASS_CBD.DP.SUB_BALANCE.VALID_FROM_DETAILS, i, j, k) == 0 and
                      edrLong(DETAIL.ASS_CBD.DP.SUB_BALANCE.VALID_TO_DETAILS, i, j, k) >  0 )
                 {
                   edrLong(DETAIL.ASS_CBD.DP.SUB_BALANCE.VALID_FROM_DETAILS, i, j, k) = 3;
                   edrOutputMap( "FIRST_USAGE_RESOURCE.DISCOUNT_SUB_BAL.DISCOUNT_SUB_BAL_MAPPING", i, j, k );
                 }
               }
             }

             subPackets= edrNumDatablocks(DETAIL.ASS_CBD.UBP,i);
             for ( j = 0; j < subPackets; j = j+1 )
             {
               // These grantor and contributor may not be populated in non-pipeline grant scenarios 
               // in which cases, these fields are not used by the change_validity_from_string opcode. 
               // But still it could break the parsing. So just a filler.
               if ( edrString(DETAIL.ASS_CBD.UBP.CONTRIBUTOR, i, j) == "" )
               {
                 edrString(DETAIL.ASS_CBD.UBP.CONTRIBUTOR, i, j) = DEFAULT_CONTRIBUTOR;
               }

               if ( edrString(DETAIL.ASS_CBD.UBP.GRANTOR, i, j) == "" )
               {
                 edrString(DETAIL.ASS_CBD.UBP.GRANTOR, i, j) = DUMMY_GRANTOR;
               }

               edrOutputMap( "FIRST_USAGE_RESOURCE.UPDATE_BALANCE.UPDATE_BALANCE_MAPPING", i, j );
             }
             edrOutputMap( "FIRST_USAGE_RESOURCE.END_BLOCK.END_BLOCK_MAPPING" );

          }

        }
    | /* EMPTY */
    ;
}

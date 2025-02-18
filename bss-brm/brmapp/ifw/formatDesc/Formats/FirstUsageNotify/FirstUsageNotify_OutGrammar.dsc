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
//   Generic I/O output grammar file for the FirstUsageNotify UEL output format
//   for Purchased Products and Purchased Discounts
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
  Long    j;
  Long    packets;

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
          packets = edrNumDatablocks(DETAIL.ASS_PIN.FIRST_USAGE,0);
          
          for ( j = 0; j < packets; j = j+1 )
          {
            edrOutputMap( "FIRST_USAGE_NOTIFY.DETAIL.DETAIL_MAPPING", 0, j );
          }

        }
    | /* EMPTY */
    ;
}

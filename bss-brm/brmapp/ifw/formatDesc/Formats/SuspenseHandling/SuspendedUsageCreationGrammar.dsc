//==============================================================================
//
//      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
//      
//      This material is the confidential property of Oracle Corporation or its
//      licensors and may be used, reproduced, stored or transmitted only in
//      accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: FMD
//------------------------------------------------------------------------------
// Module Description:
//   Generic I/O output grammar file for the suspended usage creation format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//------------------------------------------------------------------------------
// Responsible: ming-wen sung
//------------------------------------------------------------------------------

//==============================================================================
// The initial iScript code
//==============================================================================
iScript
{
  Long    recordNumber;

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
  edr_stream:
      HEADER
        {
          recordNumber = 1;
          edrLong( HEADER.RECORD_NUMBER ) = recordNumber;

          //--------------------------------------------------------------------
          // Get the creation process tag, and the event type for the output
          // file.  REL needs this information
          //--------------------------------------------------------------------
          edrString( HEADER.CREATION_PROCESS ) = "SUSPENSE_CREATE";
          edrString( HEADER.EVENT_TYPE ) =
            regString( registryNodeName() + "." + "EventType" );

          edrOutputMap( "SUSPENDED_USAGE_CREATION.HEADER.STD_MAPPING" );
        }
      details
      TRAILER
        {
        }

  ;
  
  details: 
      details 
      DETAIL
      {
        if ( edrNumDatablocks( DETAIL.ASS_SUSPENSE_EXT ) > 0 )
        {
          //--------------------------------------------------------------------
          // Write the DETAIL
          //--------------------------------------------------------------------
          recordNumber = recordNumber + 1;
          edrLong( DETAIL.RECORD_NUMBER ) = recordNumber;

          edrString( DETAIL.ASS_SUSPENSE_EXT.SERVICE_CODE, 0 ) =
            edrString( DETAIL.INTERN_SERVICE_CODE);
          edrString( DETAIL.ASS_SUSPENSE_EXT.EDR_RECORD_TYPE, 0 ) =
            edrString( DETAIL.RECORD_TYPE );

          edrOutputMap( "SUSPENDED_USAGE_CREATION.DETAIL.STD_MAPPING", 0 );

          //--------------------------------------------------------------------
          // Write the EDR record
          //--------------------------------------------------------------------
          edrOutputMap( "SUSPENDED_USAGE_CREATION.EDR.STD_MAPPING", 0 );

          //--------------------------------------------------------------------
          // Write the QUERYABLE_FIELDS record
          //--------------------------------------------------------------------
          edrOutputMap( "SUSPENDED_USAGE_CREATION.QUERYABLE_FIELDS.STD_MAPPING", 0 );
        }
      }
  | /* EMPTY */
  ;      
  

}

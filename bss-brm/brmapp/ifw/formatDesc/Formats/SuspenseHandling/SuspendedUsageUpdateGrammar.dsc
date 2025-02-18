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
//   Generic I/O output grammar file for the suspended usage update format
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
          edrString( HEADER.CREATION_PROCESS ) = "SUSPENSE_UPDATE";
          edrString( HEADER.EVENT_TYPE ) =
            regString( registryNodeName() + "." + "EventType" );

          edrOutputMap( "SUSPENDED_USAGE_UPDATE.HEADER.STD_MAPPING" );
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
        if ( edrNumDatablocks( DETAIL.ASS_SUSPENSE_EXT ) > 0 )
        {
          //--------------------------------------------------------------------
          // Write the DETAIL
          //--------------------------------------------------------------------
          recordNumber   = recordNumber + 1;
          edrLong( DETAIL.RECORD_NUMBER ) = recordNumber;

          edrOutputMap( "SUSPENDED_USAGE_UPDATE.DETAIL.STD_MAPPING", 0 );
        }
      }
  | /* EMPTY */
  ;      
  

}

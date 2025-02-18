//==============================================================================
//
//       Copyright (c) 1998 - 2006 Oracle. All rights reserved.
//
//       This material is the confidential property of Oracle Corporation
//       or its licensors and may be used, reproduced, stored or transmitted
//       only in accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: LRP
//------------------------------------------------------------------------------
// Module Description:
//   Generic I/O output grammar file for the Solution42 format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//------------------------------------------------------------------------------
// Responsible: Stefan Deigmueller
//
// $RCSfile: SOL42_V411_OutGrammar.dsc,v $
// $Revision: 1.6 $
// $Author: sd $
// $Date: 2001/09/26 08:13:06 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V411_OutGrammar.dsc,v $
// Revision 1.6  2001/09/26 08:13:06  sd
// PETS #38714 EXT_OutFileManager: empty outputfile not deleted
//
// Revision 1.5  2001/06/26 10:55:53  sd
// - iScript functions renamed
// - no return value check for mapping functions
//
// Revision 1.4  2001/06/19 13:52:52  pengelbr
// Fix error in header mapping.
//
// Revision 1.3  2001/05/17 14:17:43  pengelbr
// Fill RecordLength, RecordNumber and Counting fields.
// Update Trailer Statistics.
//
// Revision 1.2  2001/05/16 13:07:24  sd
// - Update version
//
// Revision 1.1  2001/05/16 12:24:25  sd
// - Backup Version
//
// Revision 1.1  2001/04/24 10:08:43  sd
// - Initial revision
//
//==============================================================================

//==============================================================================
// The initial iScript code
//==============================================================================
iScript
{
  Long i;
  Long j;

  Long    records;
  Long    packets;
  Long    subBlocks;

  Long    recordNumber;
  Long    detailRecords;
  Date    firstCall;
  Date    lastCall;
  Decimal totalRetailCharge;
  Decimal totalWholesaleCharge;

  //----------------------------------------------------------------------------
  // Check if the file contains only HEADER and TRAILER
  //----------------------------------------------------------------------------
  function Bool streamIsEmpty
  {
    if ( recordNumber <= 2 )
    {
      // Only HEADER and TRAILER
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
  // The entire EDR stream
  //----------------------------------------------------------------------------
  edr_stream:
      HEADER
        {
          recordNumber         = 1;
          detailRecords        = 0;
          firstCall            = MAX_DATE;
          lastCall             = MIN_DATE;
          totalWholesaleCharge = 0.0;
          totalRetailCharge    = 0.0;

          edrLong( HEADER.RECORD_NUMBER ) = recordNumber;
          edrOutputMap( "SOL42_V411.HEADER.STD_MAPPING" );
        }
      details
      TRAILER
        {
          recordNumber = recordNumber + 1;
          edrLong( TRAILER.RECORD_NUMBER )           = recordNumber;
          edrLong( TRAILER.TOTAL_NUMBER_OF_RECORDS ) = detailRecords;
          edrDate( TRAILER.FIRST_START_TIMESTAMP )   = firstCall;
          edrDate( TRAILER.LAST_START_TIMESTAMP )    = lastCall;
          edrDecimal( TRAILER.TOTAL_RETAIL_CHARGED_VALUE ) = 
            totalRetailCharge;
          edrDecimal( TRAILER.TOTAL_WHOLESALE_CHARGED_VALUE ) = 
            totalWholesaleCharge;

          edrOutputMap( "SOL42_V411.TRAILER.STD_MAPPING" );
        }
    ;

  //----------------------------------------------------------------------------
  // A list of DETAIL records
  //----------------------------------------------------------------------------
  details: 
      details 
      DETAIL
      {
        subBlocks = 0;
        subBlocks = subBlocks + edrNumDatablocks( DETAIL.ASS_CBD );
        subBlocks = subBlocks + edrNumDatablocks( DETAIL.ASS_ZBD );

        recordNumber = recordNumber + 1;
        detailRecords = detailRecords + 1;

        edrLong( DETAIL.RECORD_NUMBER ) = recordNumber;
        edrLong( DETAIL.NUMBER_ASSOCIATED_RECORDS ) = subBlocks;

        edrOutputMap( "SOL42_V411.DETAIL.STD_MAPPING" );

        //---------------------------------------------------------------------
        // Loop for all ASSOCIATED_CHARGE records
        //---------------------------------------------------------------------
        records = edrNumDatablocks( DETAIL.ASS_CBD );
        for ( i = 0; i < records; i = i+1 )
        {
          recordNumber = recordNumber + 1;
          detailRecords = detailRecords + 1;
          packets = edrNumDatablocks( DETAIL.ASS_CBD.CP, i );

          //---------------------------------------------------------------------
          // Set RecordNumber, -Length and NumberOfChargePackets
          //---------------------------------------------------------------------
          edrLong( DETAIL.ASS_CBD.RECORD_NUMBER, i ) = recordNumber;
          edrLong( DETAIL.ASS_CBD.RECORD_LENGTH, i ) = 119 + ( packets * 313 );
          edrLong( DETAIL.ASS_CBD.NUMBER_OF_CHARGE_PACKETS, i ) = packets;

          edrOutputMap( "SOL42_V411.ASSOCIATED_CHARGE.STD_MAPPING", i );

          //-------------------------------------------------------------------
          // Loop for all CHARGE_PACKETS
          //-------------------------------------------------------------------
          for ( j = 0; j < packets; j = j+1 )
          {
            edrOutputMap( "SOL42_V411.CHARGE_PACKET.STD_MAPPING", i , j );
          }

          edrOutputMap( "SOL42_V411.EOL.STD_MAPPING" );
        } 

        //---------------------------------------------------------------------
        // Loop for all ASSOCIATED_ZONE records
        //---------------------------------------------------------------------
        records = edrNumDatablocks( DETAIL.ASS_ZBD );
        for ( i = 0; i < records; i = i+1 )
        {
          recordNumber = recordNumber + 1;
          detailRecords = detailRecords + 1;
          packets = edrNumDatablocks( DETAIL.ASS_ZBD.ZP, i );

          //---------------------------------------------------------------------
          // Set RecordNumber, -Length and NumberOfChargePackets
          //---------------------------------------------------------------------
          edrLong( DETAIL.ASS_ZBD.RECORD_NUMBER, i ) = recordNumber;
          edrLong( DETAIL.ASS_ZBD.RECORD_LENGTH, i ) = 11 + ( packets * 11 );
          edrLong( DETAIL.ASS_ZBD.NUMBER_OF_ZONE_PACKETS, i ) = packets;

          edrOutputMap( "SOL42_V411.ASSOCIATED_ZONE.STD_MAPPING", i );

          //-------------------------------------------------------------------
          // Loop for all CHARGE_PACKETS
          //-------------------------------------------------------------------
          for ( j = 0; j < packets; j = j+1 )
          {
            edrOutputMap( "SOL42_V411.ZONE_PACKET.STD_MAPPING", i , j );
          }

          edrOutputMap( "SOL42_V411.EOL.STD_MAPPING" );
        } 

        //--------------------------------------------------------------------
        // Update the statistic
        //--------------------------------------------------------------------
        if ( edrDate( DETAIL.CHARGING_START_TIMESTAMP ) < firstCall )
        {
          firstCall = edrDate( DETAIL.CHARGING_START_TIMESTAMP );
        }

        if ( edrDate( DETAIL.CHARGING_START_TIMESTAMP ) > lastCall )
        {
          lastCall = edrDate( DETAIL.CHARGING_START_TIMESTAMP );
        }

        totalRetailCharge = totalRetailCharge + 
          edrDecimal( DETAIL.RETAIL_CHARGED_AMOUNT_VALUE );

        totalWholesaleCharge = totalWholesaleCharge + 
          edrDecimal( DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE );
      }
    | /* EMPTY */
    ;
}

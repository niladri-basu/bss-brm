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
//   Generic I/O output grammar file for the Solution42 V4-30 REL format with
//   Unix timestamps.
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
// $RCSfile: SOL42_V430_REL_OutGrammar.dsc,v $
// $Revision: 1.3 $
// $Author: sd $
// $Date: 2001/09/26 08:13:06 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V430_REL_OutGrammar.dsc,v $
// Revision 1.3  2001/09/26 08:13:06  sd
// PETS #38714 EXT_OutFileManager: empty outputfile not deleted
//
// Revision 1.2  2001/09/11 12:35:40  pengelbr
// PETS #39092 SOL42_V430_REL Output Grammar maps character values in
//             CALL_COMPLETION_INDICATOR into numeric values.
//
// Revision 1.1  2001/08/30 13:50:33  pengelbr
// PETS #38805 Provide timestamps in SOL42_V430 format in PIN format.
//
//==============================================================================

//==============================================================================
// The initial iScript code
//==============================================================================
iScript
{
  Long    i;
  Long    j;
  Long    records;
  Long    packets;
  Long    recordNumber;
  Long    totalNumBasics;
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
  // The EDR stream
  //----------------------------------------------------------------------------
  edr_stream:
      HEADER
        { 
          recordNumber         = 1;
          firstCall            = MAX_DATE;
          lastCall             = MIN_DATE;
          totalNumBasics       = 0;
          totalWholesaleCharge = 0.0;
          totalRetailCharge    = 0.0;

          edrLong( HEADER.RECORD_NUMBER ) = recordNumber;
          edrOutputMap( "SOL42_V430_REL.HEADER.STD_MAPPING" );
        }
      details
      TRAILER
        {
          recordNumber = recordNumber + 1;
          edrLong( TRAILER.RECORD_NUMBER )           = recordNumber;
          edrLong( TRAILER.TOTAL_NUMBER_OF_RECORDS ) = totalNumBasics;
          edrDate( TRAILER.FIRST_START_TIMESTAMP )   = firstCall;
          edrDate( TRAILER.LAST_START_TIMESTAMP )    = lastCall;
          edrDecimal( TRAILER.TOTAL_RETAIL_CHARGED_VALUE ) = 
            totalRetailCharge;
          edrDecimal( TRAILER.TOTAL_WHOLESALE_CHARGED_VALUE ) = 
            totalWholesaleCharge;

          edrOutputMap( "SOL42_V430_REL.TRAILER.STD_MAPPING" );
        }
    ;

  //----------------------------------------------------------------------------
  // A list of DETAIL records
  //----------------------------------------------------------------------------
  details: 
      details 
      DETAIL
        {
          //--------------------------------------------------------------------
          // Write the DETAIL
          //--------------------------------------------------------------------
          recordNumber   = recordNumber + 1;
          totalNumBasics = totalNumBasics + 1;
          edrLong( DETAIL.RECORD_NUMBER ) = recordNumber;
          edrLong( DETAIL.NUMBER_ASSOCIATED_RECORDS ) = 
            edrNumDatablocks( DETAIL.ASS_GPRS_EXT ) +
            edrNumDatablocks( DETAIL.ASS_GSMW_EXT ) +
            edrNumDatablocks( DETAIL.ASS_WAP_EXT ) +
            edrNumDatablocks( DETAIL.ASS_PIN ) +
            edrNumDatablocks( DETAIL.ASS_CBD ) +
            edrNumDatablocks( DETAIL.ASS_ZBD );

          switch ( edrString( DETAIL.CALL_COMPLETION_INDICATOR ) )
          {
          case "C":
          case "T":
            edrString( DETAIL.CALL_COMPLETION_INDICATOR ) = "00";
            break;

          case "D":
            edrString( DETAIL.CALL_COMPLETION_INDICATOR ) = "04";
            break;
          }

          edrOutputMap( "SOL42_V430_REL.DETAIL.STD_MAPPING" );

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_GRPS_EXTENSION record
          //--------------------------------------------------------------------
          if ( edrNumDatablocks( DETAIL.ASS_GPRS_EXT ) > 0 )
          {
            recordNumber = recordNumber + 1;
            edrLong( DETAIL.ASS_GPRS_EXT.RECORD_NUMBER, 0 ) = recordNumber;
            edrOutputMap( "SOL42_V430_REL.ASSOCIATED_GPRS.STD_MAPPING", 0 );
          }

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_WAP_EXTENSION record
          //--------------------------------------------------------------------
          if ( edrNumDatablocks( DETAIL.ASS_WAP_EXT ) > 0 )
          {
            recordNumber = recordNumber + 1;
            edrLong( DETAIL.ASS_WAP_EXT.RECORD_NUMBER, 0 ) = recordNumber;
            edrOutputMap( "SOL42_V430_REL.ASSOCIATED_WAP.STD_MAPPING", 0 );
          }

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_GSMW_EXTENSION record
          //--------------------------------------------------------------------
          if ( edrNumDatablocks( DETAIL.ASS_GSMW_EXT ) > 0 )
          {
            recordNumber = recordNumber + 1;
            packets      = edrNumDatablocks( DETAIL.ASS_GSMW_EXT.SS_PACKET, i );

            edrLong( DETAIL.ASS_GSMW_EXT.RECORD_NUMBER, 0 ) = recordNumber;
            edrLong( DETAIL.ASS_GSMW_EXT.NUMBER_OF_SS_PACKETS, 0 ) = packets;

            edrOutputMap( "SOL42_V430_REL.ASSOCIATED_GSMW.STD_MAPPING", 0 );

            for ( j = 0; j < packets; j = j+1 )
            {
              edrOutputMap( "SOL42_V430_REL.SS_EVENT_PACKET.STD_MAPPING", i, j );
            }
            edrOutputMap( "SOL42_V430_REL.EOL.STD_MAPPING" );
          }

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_INFRANET_BILLING records
          //--------------------------------------------------------------------
          records = edrNumDatablocks( DETAIL.ASS_PIN );
          for ( i = 0; i < records; i = i+1 )
          {
            recordNumber = recordNumber + 1;
            packets      = edrNumDatablocks( DETAIL.ASS_PIN.BP, i );

            edrLong( DETAIL.ASS_PIN.RECORD_NUMBER, i ) = recordNumber;
            edrLong( DETAIL.ASS_PIN.NUMBER_OF_BALANCE_PACKETS, i ) = packets;

            edrOutputMap( "SOL42_V430_REL.ASSOCIATED_INFRANET.STD_MAPPING", i );

            for ( j = 0; j < packets; j = j+1 )
            {
              edrOutputMap( "SOL42_V430_REL.BALANCE_PACKET.STD_MAPPING", i, j );
            }
            edrOutputMap( "SOL42_V430_REL.EOL.STD_MAPPING" );
          }

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_ZONE_BREAKDOWN records
          //--------------------------------------------------------------------
          records = edrNumDatablocks( DETAIL.ASS_ZBD );
          for ( i = 0; i < records; i = i+1 )
          {
            recordNumber = recordNumber + 1;
            packets      = edrNumDatablocks( DETAIL.ASS_ZBD.ZP, i );

            edrLong( DETAIL.ASS_ZBD.RECORD_NUMBER, i ) = recordNumber;
            edrLong( DETAIL.ASS_ZBD.NUMBER_OF_ZONE_PACKETS, i ) = packets;

            edrOutputMap( "SOL42_V430_REL.ASSOCIATED_ZONE.STD_MAPPING", i );

            for ( j = 0; j < packets; j = j+1 )
            {
              edrOutputMap( "SOL42_V430_REL.ZONE_PACKET.STD_MAPPING", i, j );
            }
            edrOutputMap( "SOL42_V430_REL.EOL.STD_MAPPING" );
          }

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_CHARGE_BREAKDOWN records
          //--------------------------------------------------------------------
          records = edrNumDatablocks( DETAIL.ASS_CBD );
          for ( i = 0; i < records; i = i+1 )
          {
            recordNumber = recordNumber + 1;
            packets = edrNumDatablocks( DETAIL.ASS_CBD.CP, i );

            edrLong( DETAIL.ASS_CBD.RECORD_NUMBER, i ) = recordNumber;
            edrLong( DETAIL.ASS_CBD.NUMBER_OF_CHARGE_PACKETS, i ) = packets;

            edrOutputMap( "SOL42_V430_REL.ASSOCIATED_CHARGE.STD_MAPPING", i );
            for ( j = 0; j < packets; j = j+1 )
            {
              edrOutputMap( "SOL42_V430_REL.CHARGE_PACKET.STD_MAPPING", i, j );
            }
            edrOutputMap( "SOL42_V430_REL.EOL.STD_MAPPING" );
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

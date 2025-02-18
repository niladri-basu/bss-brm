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
//   Generic I/O input grammar file for the Solution42 V4-30 REL format with
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
// $RCSfile: SOL42_V430_REL_InGrammar.dsc,v $
// $Revision: 1.2 $
// $Author: pengelbr $
// $Date: 2001/09/27 11:58:42 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V430_REL_InGrammar.dsc,v $
// Revision 1.2  2001/09/27 11:58:42  pengelbr
// PETS #39725 Add EXCHANGE_CURRENCY field to the CHARGE_PACKET block used to know
//             to wich currency the EXCHANGE_RATE converts.
// PETS #39724 Number Normalization for Roaming MTC call numbers
//             The number normalization implementation for Roaming-MTC needs to be
//             changed in order to work on the TERMINATING_SWITCH_IDENTIFICATION.
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
  use EXT_Converter;

  Long    totalNumBasics;
  Date    transferCutOff;
  Date    firstCall;
  Date    lastCall;
  Decimal totalRetailCharge;
  Decimal totalWholesaleCharge;

  String number;

  // function onParseStart
  // {
  //   lexState("SOL42_V430_REL");
  // }

  //============================================================================
  // Reset the statistic value
  //============================================================================
  function resetStatisticValues
  {
    firstCall            = MAX_DATE;
    lastCall             = MIN_DATE;
    totalNumBasics       = 0;
    totalWholesaleCharge = 0.0;
    totalRetailCharge    = 0.0;
    transferCutOff       = edrDate( HEADER.TRANSFER_CUTOFF_TIMESTAMP );
  }

  //============================================================================
  // Check the statistical values in the trailer
  //============================================================================
  function checkStatisticValues
  {
    // check the total number of basic records in the file
    if ( totalNumBasics != edrLong( TRAILER.TOTAL_NUMBER_OF_RECORDS ) )
    {
      edrAddError( "ERR_INVALID_RECORD_NUMBER", 3,
                   edrString( TRAILER.TOTAL_NUMBER_OF_RECORDS ),
                   longToStr( totalNumBasics ) );
    }
       
    // check first and last start timestamp (if any basic records)
    if ( totalNumBasics > 0 )
    {
      if ( firstCall != edrDate(TRAILER.FIRST_START_TIMESTAMP) )
      {
        edrAddError( "ERR_INVALID_FIRST_CALL_TIMESTAMP", 3,
                     edrString( TRAILER.FIRST_START_TIMESTAMP ),
                     dateToStr( firstCall ) );
      }
      
      if ( lastCall != edrDate(TRAILER.LAST_START_TIMESTAMP) )
      {
        edrAddError( "ERR_INVALID_LAST_CALL_TIMESTAMP", 3,
                     edrString( TRAILER.LAST_START_TIMESTAMP ),
                     dateToStr( lastCall ) );
      }
    }
  } 

  //============================================================================
  // normalize clis.
  //============================================================================
  function String normalizeNumber( String number,
                                   String modInd,
                                   Long typeOfNum )
  {
    Bool isV4;
    Bool isV6;

    isV4 = strSearch( number, "." ) >= 0;
    isV6 = strSearch( number, ":" ) >= 0;

    if ( ( isV4 == true ) and ( isV6 == false ) )
    {
      return convertIPv4( number );
    }

    if ( ( isV4 == true ) and ( isV6 == true ) )
    {
      return convertIPv4onv6( number );
    }

    if ( ( isV4 == false ) and ( isV6 == true ) )
    {
      return convertIPv6( number );
    }

    return convertCli( number, modInd, typeOfNum,
                       NORM_NAC,
                       NORM_IAC,
                       NORM_CC,
                       NORM_IAC_SIGN,
                       NORM_NDC );
  }
}

//==============================================================================
// The definition of the grammar
//==============================================================================
Grammar
{
  //----------------------------------------------------------------------------
  // The entire file in Solution42 format
  //----------------------------------------------------------------------------
  sol42file:
      SOL42_V430_REL.HEADER 
        {
          edrNew( HEADER, CONTAINER_HEADER );
          edrInputMap( "SOL42_V430_REL.HEADER.STD_MAPPING" );

          resetStatisticValues();
        }
      details 
      SOL42_V430_REL.TRAILER 
        {
          edrNew( TRAILER, CONTAINER_TRAILER );
          edrInputMap( "SOL42_V430_REL.TRAILER.STD_MAPPING" );

          checkStatisticValues();
        }
    ;

  //----------------------------------------------------------------------------
  // A list of DETAIL records 
  //----------------------------------------------------------------------------
  details: 
      details 
      SOL42_V430_REL.DETAIL
        {
          edrNew( DETAIL, CONTAINER_DETAIL );
          edrInputMap( "SOL42_V430_REL.DETAIL.STD_MAPPING" );

          // update statistic values
          totalNumBasics = totalNumBasics + 1;
          totalRetailCharge = totalRetailCharge + 
            edrDecimal( DETAIL.RETAIL_CHARGED_AMOUNT_VALUE );
          totalWholesaleCharge = totalWholesaleCharge + 
            edrDecimal( DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE );

          // check the transfer cutoff
          if ( transferCutOff < edrDate( DETAIL.CHARGING_START_TIMESTAMP ) )
          {
            edrAddError( "ERR_TRANSFER_CUTOFF_VIOLATED", 3,
                         dateToStr( transferCutOff ),
                         dateToStr( edrDate(DETAIL.CHARGING_START_TIMESTAMP) ) );
          }
          if ( firstCall > edrDate( DETAIL.CHARGING_START_TIMESTAMP ) )
          {
            firstCall = edrDate( DETAIL.CHARGING_START_TIMESTAMP );
          }
          if ( lastCall < edrDate( DETAIL.CHARGING_START_TIMESTAMP ) )
          {
            lastCall = edrDate( DETAIL.CHARGING_START_TIMESTAMP );
          }

          // -------------------------------------------------------------------
          // A-/B-/C-nmber normalization
          // -------------------------------------------------------------------
          number = normalizeNumber( edrString( DETAIL.A_NUMBER ),
                                    edrString( DETAIL.A_MODIFICATION_INDICATOR ),
                                    edrLong( DETAIL.A_TYPE_OF_NUMBER ) );

          edrString( DETAIL.A_NUMBER ) = number;

          number = normalizeNumber( edrString( DETAIL.B_NUMBER ),
                                    edrString( DETAIL.B_MODIFICATION_INDICATOR ),
                                    edrLong( DETAIL.B_TYPE_OF_NUMBER ) );

          edrString( DETAIL.B_NUMBER ) = number;

          if ( edrString( DETAIL.C_NUMBER ) != "" )
          {
            number = normalizeNumber( edrString( DETAIL.C_NUMBER ),
                                      edrString( DETAIL.C_MODIFICATION_INDICATOR ),
                                      edrLong( DETAIL.C_TYPE_OF_NUMBER ) );

            edrString( DETAIL.C_NUMBER ) = number;
            edrString( DETAIL.INTERN_C_NUMBER_ZONE ) = number;
          }

          // -------------------------------------------------------------------
          // Roaming normalization if applicable and zoning number definition.
          // -------------------------------------------------------------------
          switch ( edrString( DETAIL.RECORD_TYPE ) )
          {
          case "021": // TA_MOC
            {
              edrString( DETAIL.INTERN_A_NUMBER_ZONE ) = "0000" + edrString( DETAIL.ASS_GSMW_EXT.ORIGINATING_SWITCH_IDENTIFICATION, 0 );
              edrString( DETAIL.INTERN_B_NUMBER_ZONE ) = edrString( DETAIL.B_NUMBER );
            }
            break;

          case "023": // RCF/RFD
          case "031": // TA_MTC
            {
              edrString( DETAIL.INTERN_A_NUMBER_ZONE ) = edrString( DETAIL.A_NUMBER );
              edrString( DETAIL.INTERN_B_NUMBER_ZONE ) = "0000" + edrString( DETAIL.ASS_GSMW_EXT.TERMINATING_SWITCH_IDENTIFICATION, 0 );
            }
            break;

          default:
            {
              edrString( DETAIL.INTERN_A_NUMBER_ZONE ) = edrString( DETAIL.A_NUMBER );
              edrString( DETAIL.INTERN_B_NUMBER_ZONE ) = edrString( DETAIL.B_NUMBER );
            }
            break;
          }
        }
      associated_record_list
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A list of associated records
  //----------------------------------------------------------------------------
  associated_record_list:
      associated_record_list associated_record
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A choice of ASSOCIATED records
  //----------------------------------------------------------------------------
  associated_record:
      associated_charge
    | associated_zone
    | associated_infranet
    | associated_gprs
    | associated_wap
    | associated_gsmw
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_CHARGE record with its packets
  //----------------------------------------------------------------------------
  associated_charge:
      SOL42_V430_REL.ASSOCIATED_CHARGE 
        {
          edrAddDatablock( DETAIL.ASS_CBD );
          edrInputMap( "SOL42_V430_REL.ASSOCIATED_CHARGE.STD_MAPPING" );
        }
      charge_packet_list
      SOL42_V430_REL.EOL
    ;

  //----------------------------------------------------------------------------
  // A list of CHARGE_PACKETs
  //----------------------------------------------------------------------------
  charge_packet_list:
      charge_packet_list
      SOL42_V430_REL.CHARGE_PACKET 
        {
          edrAddDatablock( DETAIL.ASS_CBD.CP );
          edrInputMap( "SOL42_V430_REL.CHARGE_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_ZONE record with its packets
  //----------------------------------------------------------------------------
  associated_zone:
      SOL42_V430_REL.ASSOCIATED_ZONE 
        {
          edrAddDatablock( DETAIL.ASS_ZBD );
          edrInputMap( "SOL42_V430_REL.ASSOCIATED_ZONE.STD_MAPPING" );
        }
      zone_packet_list
      SOL42_V430_REL.EOL
    ;

  //----------------------------------------------------------------------------
  // A list of ZONE_PACKETs
  //----------------------------------------------------------------------------
  zone_packet_list:
      zone_packet_list
      SOL42_V430_REL.ZONE_PACKET 
        {
          edrAddDatablock( DETAIL.ASS_ZBD.ZP );
          edrInputMap( "SOL42_V430_REL.ZONE_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_GSMW record
  //----------------------------------------------------------------------------
  associated_gsmw:
      SOL42_V430_REL.ASSOCIATED_GSMW 
        {
          edrAddDatablock( DETAIL.ASS_GSMW_EXT );
          edrInputMap( "SOL42_V430_REL.ASSOCIATED_GSMW.STD_MAPPING" );
        }
      ss_event_packet_list
      SOL42_V430_REL.EOL
    ;

  //----------------------------------------------------------------------------
  // A list of SS_EVENT_PACKET records
  //----------------------------------------------------------------------------
  ss_event_packet_list:
      ss_event_packet_list
      SOL42_V430_REL.SS_EVENT_PACKET
        {
          edrAddDatablock( DETAIL.ASS_GSMW_EXT.SS_PACKET );
          edrInputMap( "SOL42_V430_REL.SS_EVENT_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_INFRANET record with its packets
  //----------------------------------------------------------------------------
  associated_infranet:
      SOL42_V430_REL.ASSOCIATED_INFRANET 
        {
          edrAddDatablock( DETAIL.ASS_PIN );
          edrInputMap( "SOL42_V430_REL.ASSOCIATED_INFRANET.STD_MAPPING" );
        }
      balance_packet_list
      SOL42_V430_REL.EOL
    ;

  //----------------------------------------------------------------------------
  // A list of BALANCE_PACKETs
  //----------------------------------------------------------------------------
  balance_packet_list:
      balance_packet_list
      SOL42_V430_REL.BALANCE_PACKET 
        {
          edrAddDatablock( DETAIL.ASS_PIN.BP );
          edrInputMap( "SOL42_V430_REL.BALANCE_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_GPRS record
  //----------------------------------------------------------------------------
  associated_gprs:
      SOL42_V430_REL.ASSOCIATED_GPRS 
        {
          edrAddDatablock( DETAIL.ASS_GPRS_EXT );
          edrInputMap( "SOL42_V430_REL.ASSOCIATED_GPRS.STD_MAPPING" );
        }
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_WAP record
  //----------------------------------------------------------------------------
  associated_wap:
      SOL42_V430_REL.ASSOCIATED_WAP 
        {
          edrAddDatablock( DETAIL.ASS_WAP_EXT );
          edrInputMap( "SOL42_V430_REL.ASSOCIATED_WAP.STD_MAPPING" );
        }
    ;

}

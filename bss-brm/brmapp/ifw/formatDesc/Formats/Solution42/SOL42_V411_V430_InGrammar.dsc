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
//   Generic I/O input grammar file for the Solution42 V4-30 format
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
// $RCSfile: SOL42_V411_V430_InGrammar.dsc,v $
// $Revision: 1.5 $
// $Author: pengelbr $
// $Date: 2001/07/18 10:04:32 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V411_V430_InGrammar.dsc,v $
// Revision 1.5  2001/07/18 10:04:32  pengelbr
// PETS #37117 Stream LOG: TRAILER: output of eroneous record numbers to be
// switched.
// The messages for invalid first and last call timestamp were set in incorrect
// order. The misordering of message arguments is caused by a bug in the iScript function edrAddError. See PETS #37177.
//
// Revision 1.4  2001/07/09 12:08:28  pengelbr
// PETS #36685 Add default number normalization to input mapping.
//
// Revision 1.3  2001/06/27 09:09:26  sd
// - onParseStart function removed
//
// Revision 1.2  2001/06/27 09:08:01  sd
// - Bugfix
//
// Revision 1.1  2001/05/16 12:24:25  sd
// - Backup Version
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
  // function normalize
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
       SOL42_V411.HEADER 
        {
          edrNew( HEADER, CONTAINER_HEADER );
          edrInputMap( "SOL42_V411.HEADER.V430_MAPPING" );

          resetStatisticValues();
        }
      details 
      SOL42_V411.TRAILER 
        {
          edrNew( TRAILER, CONTAINER_TRAILER );
          edrInputMap( "SOL42_V411.TRAILER.V430_MAPPING" );

          checkStatisticValues();
        }
    ;

  //----------------------------------------------------------------------------
  // A list of DETAIL records 
  //----------------------------------------------------------------------------
  details: 
      details 
      SOL42_V411.DETAIL  
        {
          edrNew( DETAIL, CONTAINER_DETAIL );
          edrInputMap("SOL42_V411.DETAIL.V430_MAPPING");

          //--------------------------------------------------------------------
          // Decision GPRS or GSM?
          //--------------------------------------------------------------------
          regExprSwitch( tokenString( "SOL42_V411.DETAIL.RECORD_TYPE" ) )
          {
            case "04[0-5]":
              {
                //--------------------------------------------------------------
                // GPRS record
                //--------------------------------------------------------------
                edrAddDatablock( DETAIL.ASS_GPRS_EXT );
                edrInputMap("SOL42_V411.DETAIL.V430_GPRS_MAPPING");
              }
              break;
            default:
              {
                regExprSwitch( tokenString("SOL42_V411.DETAIL.BASIC_SERVICE") )
                {
                  case "8..":
                  case "113":
                    {
                      //--------------------------------------------------------
                      // GPRS record
                      //--------------------------------------------------------
                      edrAddDatablock( DETAIL.ASS_GPRS_EXT );
                      edrInputMap("SOL42_V411.DETAIL.V430_GPRS_MAPPING");
                    }
                    break;
                    
                  default:
                    {
                      //--------------------------------------------------------
                      // GSM record
                      //--------------------------------------------------------
                      edrAddDatablock( DETAIL.ASS_GSMW_EXT );
                      edrInputMap("SOL42_V411.DETAIL.V430_GSMW_MAPPING");
                    }
                    break;
                }
              }
              break;
          }

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
              edrString( DETAIL.INTERN_B_NUMBER_ZONE ) = "0000" + edrString( DETAIL.ASS_GSMW_EXT.ORIGINATING_SWITCH_IDENTIFICATION, 0 );
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
      charge 
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_CHARGE record with its packets
  //----------------------------------------------------------------------------
  charge:
      SOL42_V411.ASSOCIATED_CHARGE 
      {
        edrAddDatablock( DETAIL.ASS_CBD );
        edrInputMap( "SOL42_V411.ASSOCIATED_CHARGE.V430_MAPPING" );
      }
      packets
      SOL42_V411.EOL
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A list of CHARGE_PACKETs
  //----------------------------------------------------------------------------
  packets:
      packets
      SOL42_V411.CHARGE_PACKET 
      {
        edrAddDatablock( DETAIL.ASS_CBD.CP );
        edrInputMap( "SOL42_V411.CHARGE_PACKET.V430_MAPPING" );
      }
    | /* EMPTY */
    ;
}

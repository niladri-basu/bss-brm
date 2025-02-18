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
//   Input Grammar of a Simple Sample CDR format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//------------------------------------------------------------------------------
// Responsible: bniederg
//
// $RCSfile: SIMPLESAMPLE_v1_InGrammar.dsc,v $
// $Revision: 1.1 $
// $Author: mf $
// $Date: 2001/11/20 15:31:48 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SIMPLESAMPLE_v1_InGrammar.dsc,v $
// Revision 1.1  2001/11/20 15:31:48  mf
// New  samples including the "Bernd N." stuff
//
// Revision 1.00  2001/11/14 06:54:55  bniederg
//==============================================================================

//==============================================================================
// The initial iScript code
//==============================================================================
iScript
{
  use EXT_Converter;

  Long    totalNumRecord;
  Long    totalNumBasic;
  Date    currentTime;
  Date    firstCall;
  Date    lastCall;
  Decimal totalRetailCharge;
  Decimal totalWholesaleCharge;
  Long    SeqNr;
  String  number;


function BEGIN
{
  SeqNr = 0;
}

  //============================================================================
  // Reset the statistic value
  //============================================================================
  function resetStatisticValues
  {
    firstCall            = MAX_DATE;
    lastCall             = MIN_DATE;
    totalNumRecord       = 1;
    totalNumBasic        = 0;
    currentTime          = sysdate();
  }

  //============================================================================
  // normalize CLIs.
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
  // The entire file
  //----------------------------------------------------------------------------
  Simple_Sample_Start:
        {
          resetStatisticValues();

          edrNew( HEADER, CONTAINER_HEADER );
          edrInputMap( "SIMPLESAMPLE_V1.DETAIL.HDR_MAPPING" );

          SeqNr = SeqNr + 1;
          edrLong(HEADER.SEQUENCE_NUMBER) = SeqNr;
          edrLong(HEADER.ORIGIN_SEQUENCE_NUMBER) = SeqNr;
          edrDate(HEADER.CREATION_TIMESTAMP) = currentTime;
          edrDate(HEADER.TRANSMISSION_DATE) = currentTime;
          edrDate(HEADER.TRANSFER_CUTOFF_TIMESTAMP) = currentTime;
        }
        details 
        {
          edrNew( TRAILER, CONTAINER_TRAILER );
          edrInputMap( "SIMPLESAMPLE_V1.DETAIL.TRL_MAPPING" );

          totalNumRecord = totalNumRecord + 1;
          edrLong(TRAILER.RECORD_NUMBER) = totalNumRecord;
          edrLong(TRAILER.SEQUENCE_NUMBER) = SeqNr;
          edrLong(TRAILER.ORIGIN_SEQUENCE_NUMBER) = SeqNr;
          edrLong(TRAILER.TOTAL_NUMBER_OF_RECORDS) = totalNumBasic;
          edrDate(TRAILER.FIRST_START_TIMESTAMP) = firstCall;
          edrDate(TRAILER.LAST_START_TIMESTAMP) = lastCall;
        }
    ;

  //----------------------------------------------------------------------------
  // A list of DETAIL records 
  //----------------------------------------------------------------------------
  details: 
      details 
      SIMPLESAMPLE_V1.DETAIL
        {
          edrNew( DETAIL, CONTAINER_DETAIL );
          edrInputMap( "SIMPLESAMPLE_V1.DETAIL.STD_MAPPING" );
          
          // update statistic values
          totalNumRecord = totalNumRecord + 1;
          totalNumBasic = totalNumBasic + 1;          

          // -------------------------------------------------------------------
          // Zero-Duration Calls
          // -------------------------------------------------------------------
          if ( edrDecimal( DETAIL.DURATION ) == 0.0 )
          {
            edrString( DETAIL.CALL_COMPLETION_INDICATOR ) = "03";
          }
          else
          {
            Date end_t = dateAdd( edrDate( DETAIL.CHARGING_START_TIMESTAMP ),0,0,0,0,0,
                                  decimalToLong ( edrDecimal( DETAIL.DURATION ) ) );
            edrDate( DETAIL.CHARGING_END_TIMESTAMP ) = end_t;
            edrDate( DETAIL.NE_CHARGING_END_TIMESTAMP ) = end_t;
          }

          // -------------------------------------------------------------------
          // A-/B-number normalization
          // -------------------------------------------------------------------
          number = normalizeNumber( edrString( DETAIL.A_NUMBER ), "00", 0 );
          edrString( DETAIL.A_NUMBER ) = number;

          number = normalizeNumber( edrString( DETAIL.B_NUMBER ), "00", 0 );
          edrString( DETAIL.B_NUMBER ) = number;
          
          // -------------------------------------------------------------------
          // Roaming normalization if applicable and zoning number definition.
          // -------------------------------------------------------------------
          switch ( edrString( DETAIL.USAGE_CLASS ) )
          {
          case "MOC": // Outgoing Roaming
            {
              edrString( DETAIL.INTERN_A_NUMBER_ZONE ) = "0000";
              edrString( DETAIL.INTERN_B_NUMBER_ZONE ) = edrString( DETAIL.B_NUMBER );
            }
            break;

          case "MTC": // Incomming Roaming
            {
              edrString( DETAIL.INTERN_A_NUMBER_ZONE ) = edrString( DETAIL.A_NUMBER );
              edrString( DETAIL.INTERN_B_NUMBER_ZONE ) = "0000";
            }
            break;

          default:
            {
              edrString( DETAIL.INTERN_A_NUMBER_ZONE ) = edrString( DETAIL.A_NUMBER );
              edrString( DETAIL.INTERN_B_NUMBER_ZONE ) = edrString( DETAIL.B_NUMBER );
            }
            break;
          }
          
          // -------------------------------------------------------------------
          // GSM/WIRELINE special
          // -------------------------------------------------------------------
          if ( ( edrString( DETAIL.BASIC_SERVICE ) == "TEL" ) or
	       ( edrString( DETAIL.BASIC_SERVICE ) == "SMS" ) or
	       ( edrString( DETAIL.BASIC_SERVICE ) == "FAX" ) or
	       ( edrString( DETAIL.BASIC_SERVICE ) == "DAT" ) )
	      
          {
            edrLong( DETAIL.NUMBER_ASSOCIATED_RECORDS ) = 1;
            edrAddDatablock( DETAIL.ASS_GSMW_EXT );
            edrInputMap( "SIMPLESAMPLE_V1.DETAIL.GSMW_MAPPING" );
            
            totalNumRecord = totalNumRecord + 1;
            edrLong(DETAIL.ASS_GSMW_EXT.RECORD_NUMBER, 0 ) = totalNumRecord;
          }
          
          // -------------------------------------------------------------------
          // GPRS special
          // -------------------------------------------------------------------
          if ( ( edrString( DETAIL.BASIC_SERVICE ) == "GPR" ) or
               ( edrString( DETAIL.BASIC_SERVICE ) == "GPRT") )
          {
            edrLong( DETAIL.NUMBER_ASSOCIATED_RECORDS ) = 1;
            edrAddDatablock( DETAIL.ASS_GPRS_EXT );
            edrInputMap( "SIMPLESAMPLE_V1.DETAIL.GPRS_MAPPING" );
            
            totalNumRecord = totalNumRecord + 1;
            edrLong(DETAIL.ASS_GPRS_EXT.RECORD_NUMBER, 0 ) = totalNumRecord;
          }

        }
    | /* EMPTY */
    ;
}

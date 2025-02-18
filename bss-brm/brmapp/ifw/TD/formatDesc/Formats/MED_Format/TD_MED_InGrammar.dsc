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
  String  numberA;
  String  numberB;

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
          // GSM/WIRELINE special
          // -------------------------------------------------------------------
          if ( ( edrString( DETAIL.BASIC_SERVICE ) == "TEL" ) or
	       ( edrString( DETAIL.BASIC_SERVICE ) == "SMS" ) or
	       ( edrString( DETAIL.BASIC_SERVICE ) == "BSMS" ) or
	       ( edrString( DETAIL.BASIC_SERVICE ) == "VAP" ) or
               ( edrString( DETAIL.BASIC_SERVICE ) == "MMS" ) or
               ( edrString( DETAIL.BASIC_SERVICE ) == "VOM" ) or
               ( edrString( DETAIL.BASIC_SERVICE ) == "VAS" ) or
	       ( edrString( DETAIL.BASIC_SERVICE ) == "DAT" ) )
	      
          {
            edrLong( DETAIL.NUMBER_ASSOCIATED_RECORDS ) = 1;
            edrAddDatablock( DETAIL.ASS_GSMW_EXT );
            edrInputMap( "SIMPLESAMPLE_V1.DETAIL.GSMW_MAPPING" );


	    //------------------------------------------------------------------          
	    // Custom code for 2degrees starts here ........
	    //------------------------------------------------------------------          
            edrAddDatablock( DETAIL.ASS_CI );
            edrInputMap( "SIMPLESAMPLE_V1.DETAIL.ASS_CI_MAPPING" );


            Long   indices[];
            Long   nIndices;
            Long i = 0;
		if ( strStartsWith( edrString( DETAIL.ASS_CI.SHARERS_MSISDN, 0 ), "64" ))
		{	
			String MS = strReplace(edrString(DETAIL.ASS_CI.SHARERS_MSISDN, 0),0,2,"");
			edrString(DETAIL.ASS_CI.SHARERS_MSISDN, 0) = MS;
		} 
	    indices[0] = 0; nIndices = 0;
	    edrConnectTokenEx("DETAIL.BALANCE_TYPE",indices, nIndices, "SIMPLESAMPLE_V1.DETAIL.BalanceType" + longToStr(i + 1) );

	    for ( i=0 ; edrString(DETAIL.BALANCE_TYPE) != "" and i <= 9 ; i = i + 1 )
	    {
		edrAddDatablock( DETAIL.ASS_CI.ASS_BRI);
		indices[1] = i; nIndices = 2;
		edrString(DETAIL.ASS_CI.ASS_BRI.RESOURCE_NAME, 0, i) =  edrString(DETAIL.BALANCE_TYPE);
	  	edrConnectTokenEx("DETAIL.ASS_CI.ASS_BRI.CONSUMED_QUANTITY", indices, nIndices, "SIMPLESAMPLE_V1.DETAIL.BalanceEventCost" + longToStr(i + 1) );
          	edrConnectTokenEx("DETAIL.ASS_CI.ASS_BRI.BALANCE_QUANTITY",  indices, nIndices, "SIMPLESAMPLE_V1.DETAIL.BalanceRemaining" + longToStr(i + 1) );
          	edrString(DETAIL.ASS_CI.ASS_BRI.RECORD_TYPE, 0, i) = "890";


            	indices[0] = 0; nIndices = 0;
		if(i < 9)
		{
            	  edrConnectTokenEx("DETAIL.BALANCE_TYPE",indices, nIndices,"SIMPLESAMPLE_V1.DETAIL.BalanceType" + longToStr(i + 2) );
		}
	    }
	

            totalNumRecord = totalNumRecord + 1;
            edrLong(DETAIL.ASS_GSMW_EXT.RECORD_NUMBER, 0 ) = totalNumRecord;
          }

          if ( edrString( DETAIL.BASIC_SERVICE ) == "TEL" ) 
          {
                edrAddDatablock( DETAIL.ASS_CI.ASS_TEL);
                edrInputMap( "SIMPLESAMPLE_V1.DETAIL.ASS_TEL_MAPPING" );
          }
          else if ( edrString( DETAIL.BASIC_SERVICE ) == "VOM" ) 
          {
                edrAddDatablock( DETAIL.ASS_CI.ASS_VOM);
                edrInputMap( "SIMPLESAMPLE_V1.DETAIL.ASS_VOM_MAPPING" );
          }

          else if ( edrString( DETAIL.BASIC_SERVICE ) == "SMS" )
          {
                edrAddDatablock( DETAIL.ASS_CI.ASS_SMS);
                edrInputMap( "SIMPLESAMPLE_V1.DETAIL.ASS_SMS_MAPPING" );
          }
	   else if ( edrString( DETAIL.BASIC_SERVICE ) == "BSMS" )
          {
                edrAddDatablock( DETAIL.ASS_CI.ASS_SMS);
                edrInputMap( "SIMPLESAMPLE_V1.DETAIL.ASS_SMS_MAPPING" );
                edrString( DETAIL.EVENT_TYPE ) = "/event/delayed/session/telco/gsm/sms";
                edrDecimal( DETAIL.NET_QUANTITY ) = edrDecimal( DETAIL.DURATION );
          }
          else if ( edrString( DETAIL.BASIC_SERVICE ) == "MMS" ) 
          {
                edrAddDatablock( DETAIL.ASS_CI.ASS_MMS);
                edrInputMap( "SIMPLESAMPLE_V1.DETAIL.ASS_MMS_MAPPING" );
          }
          else if  ( edrString( DETAIL.BASIC_SERVICE ) == "DAT" )
          {
                edrAddDatablock( DETAIL.ASS_CI.ASS_DAT);
                edrInputMap( "SIMPLESAMPLE_V1.DETAIL.ASS_DAT_MAPPING" );
          }
          else if ( edrString( DETAIL.BASIC_SERVICE ) == "VAP" )
          {
                edrAddDatablock( DETAIL.ASS_CI.ASS_VV);
                edrInputMap( "SIMPLESAMPLE_V1.DETAIL.ASS_VV_MAPPING" );
          }
          else if ( edrString( DETAIL.BASIC_SERVICE ) == "VAS" )
          {
                edrAddDatablock( DETAIL.ASS_CI.ASS_VAS);
                edrInputMap( "SIMPLESAMPLE_V1.DETAIL.ASS_VAS_MAPPING" );
          }
          
        }
    | /* EMPTY */
    ;
}

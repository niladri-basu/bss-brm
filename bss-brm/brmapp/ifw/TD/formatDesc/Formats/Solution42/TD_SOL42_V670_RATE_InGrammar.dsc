// @(#)% %
//==============================================================================
//
// Copyright (c) 1998, 2012, Oracle and/or its affiliates. 
// All rights reserved. 
//
//       This material is the confidential property of Oracle Corporation
//       or its licensors and may be used, reproduced, stored or transmitted
//       only in accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: LRP
//------------------------------------------------------------------------------
// Module Description:
//   Generic I/O input grammar file for the Solution42 V6.70 REL CDR format 
//   with Unix timestamps
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
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

  String normIacArray[];
  String normIacString;
  String normCCArray[];
  String normCCString;

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
    //==============================================================================
    //Commented by GSM on 4-Dec-15 related to support UnitsPerTransaction
    //==============================================================================
   // if ( totalNumBasics != edrLong( TRAILER.TOTAL_NUMBER_OF_RECORDS ) )
    //{
     // edrAddError( "ERR_INVALID_RECORD_NUMBER", 3,
     //              edrString( TRAILER.TOTAL_NUMBER_OF_RECORDS ),
     //              longToStr( totalNumBasics ) );
   // }
    //==============================================================================
       
    // check first and last start timestamp (if any basic records)
    if ( totalNumBasics > 0 )
    {
      if ( firstCall < edrDate(TRAILER.FIRST_START_TIMESTAMP) )
      {
        edrAddError( "ERR_INVALID_FIRST_CALL_TIMESTAMP", 3,
                     edrString( TRAILER.FIRST_START_TIMESTAMP ),
                     dateToStr( firstCall ) );
      }
      
      if ( lastCall > edrDate(TRAILER.LAST_START_TIMESTAMP) )
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
      SOL42_FORINPUT.HEADER 
        {
          edrNew( HEADER, CONTAINER_HEADER );
          edrInputMap( "SOL42_FORINPUT.HEADER.STD_MAPPING" );

          resetStatisticValues();
          normIacString = edrString( HEADER.IAC_LIST );
          normCCString = edrString( HEADER.CC_LIST );

          if ( normIacString != "" )
          {
            // normIacString is a comma sparated list
            Long tmpListLen = strLength(normIacString);
            Long tmpIdx     = 0;
            Long tmpIdxPrev = 0;
            Long arrayIndex = 0;
            
            while (tmpIdx < tmpListLen)
            {
              tmpIdxPrev  = tmpIdx;
              tmpIdx    = strSearch(normIacString, ",", tmpIdxPrev);
              
              if (tmpIdx < 0)
              {
                tmpIdx = tmpListLen ;
              }

              normIacArray[arrayIndex] = strSubstr(normIacString, 
                                                   tmpIdxPrev,
                                                   (tmpIdx - tmpIdxPrev));

              arrayIndex = arrayIndex + 1;
              tmpIdx = tmpIdx + 1; //skip this comma if there is one
            }
          }
          else
          {
            Long i = 0;
            while ( i < arraySize(NORM_IAC) ) {
              normIacArray[i] = NORM_IAC[i];
              i = i + 1;
            }
            edrString( HEADER.IAC_LIST ) = NORM_IAC_STRING;
          }

          if ( normCCString != "" )
          {
            // normCCString is a comma sparated list
            Long tmpListLen = strLength(normCCString);
            Long tmpIdx     = 0;
            Long tmpIdxPrev = 0;
            Long arrayIndex = 0;
            
            while (tmpIdx < tmpListLen)
            {
              tmpIdxPrev  = tmpIdx;
              tmpIdx    = strSearch(normCCString, ",", tmpIdxPrev);
              
              if (tmpIdx < 0)
              {
                tmpIdx = tmpListLen ;
              }

              normCCArray[arrayIndex] = strSubstr(normCCString, 
                                                  tmpIdxPrev,
                                                  (tmpIdx - tmpIdxPrev));

              arrayIndex = arrayIndex + 1;
              tmpIdx = tmpIdx + 1; //skip this comma if there is one
            }
          }
          else
          {
            Long i = 0;
            while ( i < arraySize(NORM_CC) ) {
              normCCArray[i] = NORM_CC[i];
              i = i + 1;
            }
            edrString( HEADER.CC_LIST ) = NORM_CC_STRING;
          }
        }
      details 
      SOL42_FORINPUT.TRAILER 
        {
          edrNew( TRAILER, CONTAINER_TRAILER );
          edrInputMap( "SOL42_FORINPUT.TRAILER.STD_MAPPING" );

          checkStatisticValues();
        }
    ;

  //----------------------------------------------------------------------------
  // A list of DETAIL records 
  //----------------------------------------------------------------------------
  details: 
      details 
      SOL42_FORINPUT.DETAIL
        {
          edrNew( DETAIL, CONTAINER_DETAIL );
          edrInputMap( "SOL42_FORINPUT.DETAIL.STD_MAPPING" );
	  
          // -------------------------------------------------------------------
          // calc END_TIMESTAMP based on (START_TIMESTAMP + DURATION)
          // -------------------------------------------------------------------
	  Date end_t = dateAdd( edrDate( DETAIL.CHARGING_START_TIMESTAMP ),0,0,0,0,0,
			  decimalToLong ( edrDecimal( DETAIL.DURATION ) ) );
	  edrDate( DETAIL.CHARGING_END_TIMESTAMP ) = end_t;
	  edrDate( DETAIL.NE_CHARGING_END_TIMESTAMP ) = end_t;

          // update statistic values
          totalNumBasics = totalNumBasics + 1;
          totalRetailCharge = totalRetailCharge + 
            edrDecimal( DETAIL.RETAIL_CHARGED_AMOUNT_VALUE );
          totalWholesaleCharge = totalWholesaleCharge + 
            edrDecimal( DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE );

          // check the transfer cutoff
          // if ( transferCutOff < edrDate( DETAIL.CHARGING_START_TIMESTAMP ) )
          // {
          //   edrAddError( "ERR_TRANSFER_CUTOFF_VIOLATED", 3,
          //                dateToStr( transferCutOff ),
          //                dateToStr( edrDate(DETAIL.CHARGING_START_TIMESTAMP) ) );
          // }
          if ( firstCall > edrDate( DETAIL.CHARGING_START_TIMESTAMP ) )
          {
            firstCall = edrDate( DETAIL.CHARGING_START_TIMESTAMP );
          }
          if ( lastCall < edrDate( DETAIL.CHARGING_START_TIMESTAMP ) )
          {
            lastCall = edrDate( DETAIL.CHARGING_START_TIMESTAMP );
          }

	  String numberB = "00" +edrString( DETAIL.INTERN_B_NUMBER_ZONE );
	  edrString( DETAIL.INTERN_B_NUMBER_ZONE ) = numberB;


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
    | associated_lte
    | associated_wap
    | associated_gsmw
    | associated_camel
    | associated_message
    | associated_sms
    | associated_mms
    | associated_suspense
    | associated_roaming
    | associated_ciber
    | custom_info
    | bundle_resource_info
    | tel_info
    | sms_info
    | data_info
    | vv_info
    | voicemail_info
    | mms_info
    | vas_info
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_CHARGE record with its packets
  //----------------------------------------------------------------------------
  associated_charge:
      SOL42_FORINPUT.ASSOCIATED_CHARGE 
        {
          edrAddDatablock( DETAIL.ASS_CBD );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_CHARGE.STD_MAPPING" );
        }
      rum_map_list
      charge_packet_list
      discount_packet_list
      tax_packet_list
    ;

  //----------------------------------------------------------------------------
  // A list of RUM_MAPs
  //----------------------------------------------------------------------------
  rum_map_list:
      rum_map_list
      SOL42_FORINPUT.RUM_MAP
        {
          edrAddDatablock( DETAIL.ASS_CBD.RM );
          edrInputMap( "SOL42_FORINPUT.RUM_MAP.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A list of CHARGE_PACKETs
  //----------------------------------------------------------------------------
  charge_packet_list:
      charge_packet_list
      SOL42_FORINPUT.CHARGE_PACKET 
        {
          edrAddDatablock( DETAIL.ASS_CBD.CP );
          edrInputMap( "SOL42_FORINPUT.CHARGE_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A list of DISCOUNT_PACKETs
  //----------------------------------------------------------------------------
  discount_packet_list:
      discount_packet_list
      SOL42_FORINPUT.DISCOUNT_PACKET 
        {
          edrAddDatablock( DETAIL.ASS_CBD.DP );
          edrInputMap( "SOL42_FORINPUT.DISCOUNT_PACKET.STD_MAPPING" );
        }
      subdiscbal_packet_list
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A list of DISCOUNT_SUBBALANCEs
  //----------------------------------------------------------------------------
  subdiscbal_packet_list:
      subdiscbal_packet_list
      SOL42_FORINPUT.DISCOUNT_SUBBALANCE 
        {
          edrAddDatablock( DETAIL.ASS_CBD.DP.SUB_BALANCE );
          edrInputMap( "SOL42_FORINPUT.DISCOUNT_SUBBALANCE.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A list of TAX_PACKETs
  //----------------------------------------------------------------------------
  tax_packet_list:
      tax_packet_list
      SOL42_FORINPUT.TAX_PACKET 
        {
          edrAddDatablock( DETAIL.ASS_CBD.TP );
          edrInputMap( "SOL42_FORINPUT.TAX_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_ZONE record with its packets
  //----------------------------------------------------------------------------
  associated_zone:
      SOL42_FORINPUT.ASSOCIATED_ZONE 
        {
          edrAddDatablock( DETAIL.ASS_ZBD );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_ZONE.STD_MAPPING" );
        }
      zone_packet_list
    ;

  //----------------------------------------------------------------------------
  // A list of ZONE_PACKETs
  //----------------------------------------------------------------------------
  zone_packet_list:
      zone_packet_list
      SOL42_FORINPUT.ZONE_PACKET 
        {
          edrAddDatablock( DETAIL.ASS_ZBD.ZP );
          edrInputMap( "SOL42_FORINPUT.ZONE_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_GSMW record
  //----------------------------------------------------------------------------
  associated_gsmw:
      SOL42_FORINPUT.ASSOCIATED_GSMW 
        {
          edrAddDatablock( DETAIL.ASS_GSMW_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_GSMW.STD_MAPPING" );
        }
      ss_event_packet_list
    ;

  //----------------------------------------------------------------------------
  // A list of SS_EVENT_PACKET records
  //----------------------------------------------------------------------------
  ss_event_packet_list:
      ss_event_packet_list
      SOL42_FORINPUT.SS_EVENT_PACKET
        {
          edrAddDatablock( DETAIL.ASS_GSMW_EXT.SS_PACKET );
          edrInputMap( "SOL42_FORINPUT.SS_EVENT_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_INFRANET record with its packets
  //----------------------------------------------------------------------------
  associated_infranet:
      SOL42_FORINPUT.ASSOCIATED_INFRANET 
        {
          edrAddDatablock( DETAIL.ASS_PIN );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_INFRANET.STD_MAPPING" );
        }
      balance_packet_list
      sub_bal_impact_list
      monitor_packet_list
      monitor_sub_bal_impact_list
    ;

  //----------------------------------------------------------------------------
  // A list of BALANCE_PACKETs
  //----------------------------------------------------------------------------
  balance_packet_list:
      balance_packet_list
      SOL42_FORINPUT.BALANCE_PACKET
        {
          edrAddDatablock( DETAIL.ASS_PIN.BP );
          edrInputMap( "SOL42_FORINPUT.BALANCE_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;
  //----------------------------------------------------------------------------
  // A list of SUB_BAL_IMPACT_PACKETs
  //----------------------------------------------------------------------------
  sub_bal_impact_list:
      sub_bal_impact_list
      SOL42_FORINPUT.SUB_BAL_IMPACT 
        {
          edrAddDatablock( DETAIL.ASS_PIN.SBI );
          edrInputMap( "SOL42_FORINPUT.SUB_BAL_IMPACT.STD_MAPPING" );
	  
        }
      subbal_packet_list
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A list of subbalances inside SUB_BAL_IMPACT_PACKET
  //----------------------------------------------------------------------------
  subbal_packet_list:
      subbal_packet_list
      SOL42_FORINPUT.SUB_BAL 
        {
	  edrAddDatablock( DETAIL.ASS_PIN.SBI.SB );
          edrInputMap( "SOL42_FORINPUT.SUB_BAL.STD_MAPPING" );
         }
    | /* EMPTY */
    ;    

  //----------------------------------------------------------------------------
  // A list of MONITOR_PACKETs
  //----------------------------------------------------------------------------
  monitor_packet_list:
      monitor_packet_list
      SOL42_FORINPUT.MONITOR_PACKET
        {
          edrAddDatablock( DETAIL.ASS_PIN.MP );
          edrInputMap( "SOL42_FORINPUT.MONITOR_PACKET.STD_MAPPING" );
        }
    | /* EMPTY */
    ;
  //----------------------------------------------------------------------------
  // A list of MONITOR_SUB_BAL_IMPACTs
  //----------------------------------------------------------------------------
  monitor_sub_bal_impact_list:
      monitor_sub_bal_impact_list
      SOL42_FORINPUT.MONITOR_SUB_BAL_IMPACT 
        {
          edrAddDatablock( DETAIL.ASS_PIN.MSBI );
          edrInputMap( "SOL42_FORINPUT.MONITOR_SUB_BAL_IMPACT.STD_MAPPING" );
	  
        }
      monitor_subbal_packet_list
    | /* EMPTY */
    ;

  //----------------------------------------------------------------------------
  // A list of subbalances inside MONITOR_SUB_BAL_IMPACT
  //----------------------------------------------------------------------------
  monitor_subbal_packet_list:
      monitor_subbal_packet_list
      SOL42_FORINPUT.MONITOR_SUB_BAL 
        {
	  edrAddDatablock( DETAIL.ASS_PIN.MSBI.MSB );
          edrInputMap( "SOL42_FORINPUT.MONITOR_SUB_BAL.STD_MAPPING" );
         }
    | /* EMPTY */
    ;
    
  //----------------------------------------------------------------------------
  // A ASSOCIATED_GPRS record
  //----------------------------------------------------------------------------
  associated_gprs:
      SOL42_FORINPUT.ASSOCIATED_GPRS 
        {
          edrAddDatablock( DETAIL.ASS_GPRS_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_GPRS.STD_MAPPING" );
        }
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_LTE record
  //----------------------------------------------------------------------------
  associated_lte:
      SOL42_FORINPUT.ASSOCIATED_LTE 
        {
          edrAddDatablock( DETAIL.ASS_LTE_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_LTE.STD_MAPPING" );
        }
    ;
	
  //----------------------------------------------------------------------------
  // A ASSOCIATED_WAP record
  //----------------------------------------------------------------------------
  associated_wap:
      SOL42_FORINPUT.ASSOCIATED_WAP 
        {
          edrAddDatablock( DETAIL.ASS_WAP_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_WAP.STD_MAPPING" );
        }
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_CAMEL record
  //----------------------------------------------------------------------------
  associated_camel:
      SOL42_FORINPUT.ASSOCIATED_CAMEL 
        {
          edrAddDatablock( DETAIL.ASS_CAMEL_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_CAMEL.STD_MAPPING" );
        }
    ;


  //----------------------------------------------------------------------------
  // A ASSOCIATED_MESSAGE record
  //----------------------------------------------------------------------------
  associated_message:
      SOL42_FORINPUT.ASSOCIATED_MESSAGE 
        {
          edrAddDatablock( DETAIL.ASS_MSG_DES );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_MESSAGE.STD_MAPPING" );
        }
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_SMS record
  //----------------------------------------------------------------------------
  associated_sms:
      SOL42_FORINPUT.ASSOCIATED_SMS
        {
          edrAddDatablock( DETAIL.ASS_SMS_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_SMS.STD_MAPPING" );
        }
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_MMS record
  //----------------------------------------------------------------------------
  associated_mms:
      SOL42_FORINPUT.ASSOCIATED_MMS
        {
          edrAddDatablock( DETAIL.ASS_MMS_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_MMS.STD_MAPPING" );
        }
    ;

 //----------------------------------------------------------------------------
  // A ASSOCIATED_SUSPENSE record
  //----------------------------------------------------------------------------
  associated_suspense:
      SOL42_FORINPUT.ASSOCIATED_SUSPENSE
        {
          edrAddDatablock( DETAIL.ASS_SUSPENSE_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_SUSPENSE.STD_MAPPING" );
        }
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_CIBER record
  //----------------------------------------------------------------------------
  associated_ciber:
      SOL42_FORINPUT.ASSOCIATED_CIBER
        {
          edrAddDatablock( DETAIL.ASS_CIBER_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_CIBER.STD_MAPPING" );
        }
    ;

  //----------------------------------------------------------------------------
  // A ASSOCIATED_ROAMING record
  //----------------------------------------------------------------------------
  associated_roaming:
      SOL42_FORINPUT.ASSOCIATED_ROAMING
        {
          edrAddDatablock( DETAIL.ASS_ROAMING_EXT );
          edrInputMap( "SOL42_FORINPUT.ASSOCIATED_ROAMING.STD_MAPPING" );
        }
    ;

//----------------------------------------------------------------------------
  // GSM - CUSTOM_INFO
  //----------------------------------------------------------------------------
  custom_info:
     SOL42_FORINPUT.ASS_CI_MAPPING
        {
          edrAddDatablock( DETAIL.ASS_CI );
          edrInputMap( "SOL42_FORINPUT.ASS_CI_MAPPING.STD_MAPPING" );
        }
    ;

   bundle_resource_info:
     SOL42_FORINPUT.ASS_BRI_MAPPING
        {
          edrAddDatablock( DETAIL.ASS_CI.ASS_BRI );
	  edrInputMap( "SOL42_FORINPUT.ASS_BRI_MAPPING.STD_MAPPING" );
        }
    ;

    tel_info:
     SOL42_FORINPUT.ASS_TEL_MAPPING
        {
          edrAddDatablock( DETAIL.ASS_CI.ASS_TEL );
          edrInputMap( "SOL42_FORINPUT.ASS_TEL_MAPPING.STD_MAPPING" );
        }
    ;

    sms_info:
     SOL42_FORINPUT.ASS_SMS_MAPPING
        {
          edrAddDatablock( DETAIL.ASS_CI.ASS_SMS );
          edrInputMap( "SOL42_FORINPUT.ASS_SMS_MAPPING.STD_MAPPING" );
        }
    ;

    data_info:
     SOL42_FORINPUT.ASS_DAT_MAPPING
        {
          edrAddDatablock( DETAIL.ASS_CI.ASS_DAT );
          edrInputMap( "SOL42_FORINPUT.ASS_DAT_MAPPING.STD_MAPPING" );
        }
    ;

    vv_info:
     SOL42_FORINPUT.ASS_VV_MAPPING
        {
          edrAddDatablock( DETAIL.ASS_CI.ASS_VV );
          edrInputMap( "SOL42_FORINPUT.ASS_VV_MAPPING.STD_MAPPING" );
        }
    ;

    voicemail_info:
     SOL42_FORINPUT.ASS_VOM_MAPPING
        {
          edrAddDatablock( DETAIL.ASS_CI.ASS_VOM );
          edrInputMap( "SOL42_FORINPUT.ASS_VOM_MAPPING.STD_MAPPING" );
        }
    ;

    mms_info:
     SOL42_FORINPUT.ASS_MMS_MAPPING
        {
          edrAddDatablock( DETAIL.ASS_CI.ASS_MMS );
          edrInputMap( "SOL42_FORINPUT.ASS_MMS_MAPPING.STD_MAPPING" );
        }
    ;

    vas_info:
     SOL42_FORINPUT.ASS_VAS_MAPPING
        {
          edrAddDatablock( DETAIL.ASS_CI.ASS_VAS );
          edrInputMap( "SOL42_FORINPUT.ASS_VAS_MAPPING.STD_MAPPING" );
        }
    ;

}

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
//   Generic I/O output grammar file for the Solution42 V6.30 REL CDR format 
//   with Unix timestamps
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//------------------------------------------------------------------------------
// Responsible: Peter Engelbrecht
//
// $RCSfile: SOL42_V650_REL_OutGrammar.dsc,v $
// $Revision: 1.3 $
// $Author: sd $
// $Date: 2001/09/26 08:13:06 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V650_REL_OutGrammar.dsc,v $
//==============================================================================

//==============================================================================
// The initial iScript code
//==============================================================================
iScript
{
  Long    i;
  Long    j;
  Long    k;
  Long    records;
  Long    packets;
  Long    subpackets;
  Long    recordNumber;
  Long    sbiRecordNumber;
  Long    totalNumBasics;
  Date    firstCall;
  String  firstUtcOffset;
  Date    lastCall;
  String  lastUtcOffset;
  Decimal totalRetailCharge;
  Decimal totalWholesaleCharge;
  String  nodeName;
  String  addInvoiceData;
  Bool    addInvoiceDataBool;

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

  //----------------------------------------------------------------------------
  // Only do this once per Integrate session per pipeline per output module,
  //   so neglectable overhead
  //----------------------------------------------------------------------------
  function BEGIN
  {
    nodeName = registryNodeName();
    // note that making ".Module.AddInvoiceData" a constant would be nicer but somehow it
    // does not work, it seems that you can only init a value inside a function, not at
    // the "declaration" area
    addInvoiceData = regString(nodeName + ".Module.AddInvoiceData");

    if (strToUpper(addInvoiceData) == "TRUE")
    {
      addInvoiceDataBool = true;
    }
    else
    {
      addInvoiceDataBool = false;
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
          firstUtcOffset       = "";
          lastCall             = MIN_DATE;
          lastUtcOffset        = "";
          totalNumBasics       = 0;
          totalWholesaleCharge = 0.0;
          totalRetailCharge    = 0.0;

          edrLong( HEADER.RECORD_NUMBER ) = recordNumber;

          //--------------------------------------------------------------------
          // Get the creation process tag, and the event type for the output
          // file.  REL needs this information
          //--------------------------------------------------------------------
          edrString( HEADER.CREATION_PROCESS ) =
            regString( registryNodeName() + "." + "ProcessType" );
          edrString( HEADER.EVENT_TYPE ) =
            regString( registryNodeName() + "." + "EventType" );

          edrOutputMap( "SOL42_V650_REL.HEADER.STD_MAPPING" );
        }
      details
      TRAILER
        {
          recordNumber = recordNumber + 1;
          edrLong( TRAILER.RECORD_NUMBER )           = recordNumber;
          edrLong( TRAILER.TOTAL_NUMBER_OF_RECORDS ) = totalNumBasics;
          edrDate( TRAILER.FIRST_START_TIMESTAMP )   = firstCall;
          edrString( TRAILER.FIRST_CHARGING_UTC_TIME_OFFSET ) = 
            firstUtcOffset;
          edrDate( TRAILER.LAST_START_TIMESTAMP )    = lastCall;
          edrString( TRAILER.LAST_CHARGING_UTC_TIME_OFFSET ) = 
            lastUtcOffset;
          edrDecimal( TRAILER.TOTAL_RETAIL_CHARGED_VALUE ) = 
            totalRetailCharge;
          edrDecimal( TRAILER.TOTAL_WHOLESALE_CHARGED_VALUE ) = 
            totalWholesaleCharge;

          edrOutputMap( "SOL42_V650_REL.TRAILER.STD_MAPPING" );
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
          sbiRecordNumber   = 0;
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

          edrOutputMap( "SOL42_V650_REL.DETAIL.STD_MAPPING" );

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_GRPS_EXTENSION record
          //--------------------------------------------------------------------
          if ( edrNumDatablocks( DETAIL.ASS_GPRS_EXT ) > 0 )
          {
            recordNumber = recordNumber + 1;
            edrLong( DETAIL.ASS_GPRS_EXT.RECORD_NUMBER, 0 ) = recordNumber;
            edrOutputMap( "SOL42_V650_REL.ASSOCIATED_GPRS.STD_MAPPING", 0 );
          }

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_WAP_EXTENSION record
          //--------------------------------------------------------------------
          if ( edrNumDatablocks( DETAIL.ASS_WAP_EXT ) > 0 )
          {
            recordNumber = recordNumber + 1;
            edrLong( DETAIL.ASS_WAP_EXT.RECORD_NUMBER, 0 ) = recordNumber;
            edrOutputMap( "SOL42_V650_REL.ASSOCIATED_WAP.STD_MAPPING", 0 );
          }

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_CAMEL_EXTENSION record
          //--------------------------------------------------------------------
          if ( edrNumDatablocks( DETAIL.ASS_CAMEL_EXT ) > 0 )
          {
            recordNumber = recordNumber + 1;
            edrLong( DETAIL.ASS_CAMEL_EXT.RECORD_NUMBER, 0 ) = recordNumber;
            edrOutputMap( "SOL42_V650_REL.ASSOCIATED_CAMEL.STD_MAPPING", 0 );
          }

          //--------------------------------------------------------------------
          // Write the ASSOCIATED_MESSAGE record
          //--------------------------------------------------------------------
          if ( edrNumDatablocks( DETAIL.ASS_MSG_DES ) > 0 )
          {
            recordNumber = recordNumber + 1;
            edrLong( DETAIL.ASS_MSG_DES.RECORD_NUMBER, 0 ) = recordNumber;
            edrOutputMap( "SOL42_V650_REL.ASSOCIATED_MESSAGE.STD_MAPPING", 0 );
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

            edrOutputMap( "SOL42_V650_REL.ASSOCIATED_GSMW.STD_MAPPING", 0 );

            for ( j = 0; j < packets; j = j+1 )
            {
              recordNumber = recordNumber + 1;
              
              edrLong( DETAIL.ASS_GSMW_EXT.SS_PACKET.RECORD_NUMBER, 0, j ) = recordNumber;
              
              edrOutputMap( "SOL42_V650_REL.SS_EVENT_PACKET.STD_MAPPING", 0, j );
            }
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

            // PRSF00012756 
            // Out of the box default value for the original event poid 
            // in the EDR file should be "0 0 0"
            // PRSF00014558 
            // IREL is expecting extra space in EDR 900 record type. 
            // Working Original event poid should be specified 0  0 0. 
            // (2 spaces between the first 0 and 2nd 0). The current EDR in ifw-Perseus_6.3. 
            if ( edrString( DETAIL.ASS_PIN.ORIGINAL_EVENT_POID, i ) == "" )
            {
              edrString( DETAIL.ASS_PIN.ORIGINAL_EVENT_POID, i ) = "0  0 0";
            }

            edrOutputMap( "SOL42_V650_REL.ASSOCIATED_INFRANET.STD_MAPPING", i );

            if (addInvoiceDataBool == true)
            {
              //--------------------------------------------------------------------
              // Write the ASSOCIATED_INVOICE_DATA records
              //--------------------------------------------------------------------
              edrAddDatablock(DETAIL.ASS_INVOICE_DATA);
              edrOutputMap("SOL42_V650_REL.ASSOCIATED_INVOICE_DATA.STD_MAPPING", i);

              //--------------------------------------------------------------------
              // Write the BALANCE_IMPACT packets
              //--------------------------------------------------------------------
              for ( j = 0; j < packets; j = j+1 )
              {
                edrAddDatablock(DETAIL.ASS_INVOICE_DATA.BAL_IMPACT);
                edrOutputMap("SOL42_V650_REL.BALANCE_IMPACT.STD_MAPPING", i, j);
              }

              //--------------------------------------------------------------------
              // Write the INVOICE_DATA_TERMINATOR
              //--------------------------------------------------------------------
              edrAddDatablock(DETAIL.ASS_INVOICE_DATA.INVOICE_DATA_TERMINATOR);
              edrString(DETAIL.ASS_INVOICE_DATA.INVOICE_DATA_TERMINATOR.TERMINATOR, i, 0) = ">";
              edrOutputMap("SOL42_V650_REL.INVOICE_DATA_TERMINATOR.STD_MAPPING", i, 0);
            }
            else
            {
              outputWrite("\n");
            }

            //---------------------------------------------------------------------
            // Write the BALANCE_PACKET packets
            //---------------------------------------------------------------------
            for ( j = 0; j < packets; j = j+1 )
            {
              recordNumber = recordNumber + 1;
              
              edrLong( DETAIL.ASS_PIN.BP.RECORD_NUMBER, i, j ) = recordNumber;
              
              edrOutputMap( "SOL42_V650_REL.BALANCE_PACKET.STD_MAPPING", i, j );
            }

			// deal with the SUB_BAL_IMPACT
            packets      = edrNumDatablocks( DETAIL.ASS_PIN.SBI, i );
            for ( j = 0; j < packets; j = j+1 )
            {
              	edrLong( DETAIL.ASS_PIN.SBI.RECORD_NUMBER, i, j ) = sbiRecordNumber;
				sbiRecordNumber = sbiRecordNumber + 1;
              	edrOutputMap( "SOL42_V650_REL.SUB_BAL_IMPACT.STD_MAPPING", i, j );
            	subpackets      = edrNumDatablocks( DETAIL.ASS_PIN.SBI.SB, i,j );
            	for ( k = 0; k < subpackets; k = k+1 )
            	{
              		edrOutputMap( "SOL42_V650_REL.SUB_BAL.STD_MAPPING", i, j, k );
            	}
            }
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

            edrOutputMap( "SOL42_V650_REL.ASSOCIATED_ZONE.STD_MAPPING", i );

            for ( j = 0; j < packets; j = j+1 )
            {
              recordNumber = recordNumber + 1;
          
              edrLong( DETAIL.ASS_ZBD.ZP.RECORD_NUMBER, i, j ) = recordNumber;
          
              edrOutputMap( "SOL42_V650_REL.ZONE_PACKET.STD_MAPPING", i, j );
            }
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

            edrOutputMap( "SOL42_V650_REL.ASSOCIATED_CHARGE.STD_MAPPING", i );

            for ( j = 0; j < packets; j = j+1 )
            {
              recordNumber = recordNumber + 1;
              edrLong( DETAIL.ASS_CBD.CP.RECORD_NUMBER, i, j ) = recordNumber;
              edrOutputMap( "SOL42_V650_REL.CHARGE_PACKET.STD_MAPPING", i, j );
            }

			// process new DISCOUNT_PACKET
            packets = edrNumDatablocks( DETAIL.ASS_CBD.DP, i );
            for ( j = 0; j < packets; j = j+1 )
            {
              edrOutputMap( "SOL42_V650_REL.DISCOUNT_PACKET.STD_MAPPING", i, j );
            }
          }

          //--------------------------------------------------------------------
          // Update the statistic
          //--------------------------------------------------------------------
          if ( edrDate( DETAIL.CHARGING_START_TIMESTAMP ) < firstCall )
          {
            firstCall = edrDate( DETAIL.CHARGING_START_TIMESTAMP );
            firstUtcOffset = edrString( DETAIL.UTC_TIME_OFFSET );
          }
          if ( edrDate( DETAIL.CHARGING_START_TIMESTAMP ) > lastCall )
          {
            lastCall = edrDate( DETAIL.CHARGING_START_TIMESTAMP );
            lastUtcOffset = edrString( DETAIL.UTC_TIME_OFFSET );
          }
          totalRetailCharge = totalRetailCharge + 
            edrDecimal( DETAIL.RETAIL_CHARGED_AMOUNT_VALUE );
          totalWholesaleCharge = totalWholesaleCharge + 
            edrDecimal( DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE );
        }
    | /* EMPTY */
    ;
}

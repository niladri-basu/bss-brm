//==============================================================================
//
//       Copyright (c) 1998 - 2006 Oracle. All rights reserved.
//
//       This material is the confidential property of Oracle Corporation
//       or its licensors and may be used, reproduced, stored or transmitted
//       only in accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: FMD
//------------------------------------------------------------------------------
// Module Description:
//   Description of the Sol42 V4.1.1 CDR format
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
// $RCSfile: SOL42_V411.dsc,v $
// $Revision: 1.5 $
// $Author: sd $
// $Date: 2001/06/20 10:02:23 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V411.dsc,v $
// Revision 1.5  2001/06/20 10:02:23  sd
// - Date format corrected
//
// Revision 1.4  2001/05/17 14:33:02  pengelbr
// Change formatting of "Long" fields...
//
// Revision 1.3  2001/05/16 14:23:56  pengelbr
// ChargeableQuantityValue shall be a Decimal.
//
// Revision 1.2  2001/05/16 13:01:25  sd
// - Backup version
//
// Revision 1.1  2001/05/16 12:24:25  sd
// - Backup Version
//
//==============================================================================

SOL42_V411
{
  //----------------------------------------------------------------------------
  // Header records
  //----------------------------------------------------------------------------
  HEADER(FIX)
  {
    Info
    {
      Pattern = "[0-9]{5}010";
    }

    RECORD_LENGTH                       AscInteger(5);
    RECORD_TYPE                         AscString(3);
    RECORD_NUMBER                       AscInteger(9);
    SENDER                              AscString(10);
    RECIPIENT                           AscString(10);
    FILE_SEQUENCE_NUMBER                AscInteger(6);
    ORIGIN_FILE_SEQUENCE_NUMBER         AscInteger(6);
    FILE_CREATION_TIMESTAMP             AscDate();
    FILE_TRANSMISSION_DATE              AscDate("%Y%m%d");
    TRANSFER_CUTOFF_TIMESTAMP           AscDate();
    UTC_TIME_OFFSET                     AscString(5);
    SPECIFICATION_VERSION_NUMBER        AscInteger(2);
    RELEASE_VERSION                     AscInteger(2);
    ORIGIN_COUNTRY_CODE                 AscString(8);
    SENDER_COUNTRY_CODE                 AscString(8);
    FILE_TYPE_INDICATOR                 AscString(1);
    EOL                                 AscString(1);
  }
    
  //----------------------------------------------------------------------------
  // Detail records
  //----------------------------------------------------------------------------
  DETAIL(FIX)
  {
    Info
    {
      Pattern = "[0-9]{5}(02[0-8]|03[0-1]|04[0-9]|050|060|12[0-8]|13[0-1]|220)";
    }

    RECORD_LENGTH                       AscInteger(5);
    RECORD_TYPE                         AscString(3);
    RECORD_NUMBER                       AscInteger(9);
    DISCARDING                          AscInteger(1);
    CHAIN_REFERENCE                     AscString(10);
    SOURCE_NETWORK_TYPE                 AscString(1);
    SOURCE_NETWORK                      AscString(14);
    DESTINATION_NETWORK_TYPE            AscString(1);
    DESTINATION_NETWORK                 AscString(14);
    TYPE_OF_A_IDENTIFICATION            AscString(1);
    PORT_NUMBER                         AscString(24);
    DEVICE_NUMBER                       AscString(24);
    A_MODIFICATION_INDICATOR            AscString(2);
    A_TYPE_OF_NUMBER                    AscInteger(1);
    A_NUMBERING_PLAN                    AscString(1);
    A_NUMBER                            AscString(40);
    A_NUMBER_USER                       AscString(40);
    B_MODIFICATION_INDICATOR            AscString(2);
    B_TYPE_OF_NUMBER                    AscInteger(1);
    DIALED_DIGITS                       AscString(40);
    B_NUMBER                            AscString(40);
    B_NUMBER_DESTINATION_DECRIPTION     AscString(30);
    C_MODIFICATION_INDICATOR            AscString(2);
    C_TYPE_OF_NUMBER                    AscInteger(1);
    C_NUMBERING_PLAN                    AscString(1);
    C_NUMBER                            AscString(40);
    CONNECT_TYPE                        AscString(2);
    CONNECT_SUB_TYPE                    AscString(2);
    BASIC_SERVICE                       AscString(3);
    BASIC_DUAL_SERVICE                  AscString(3);
    QOS_REQUESTED                       AscString(5);
    QOS_USED                            AscString(5);
    APPLICATION                         AscString(80);
    CALL_COMPLETION_INDICATOR           AscString(1);
    LONG_DURATION_INDICATOR             AscString(1);
    SWITCH_IDENTIFICATION               AscString(15);
    TRUNC_INPUT                         AscString(10);
    TRUNC_OUTPUT                        AscString(10);
    LOCATION_AREA_INDICATOR             AscString(10);
    CELL_ID                             AscString(5);
    MS_CLASS_MARK                       AscInteger(1);
    CHARGING_START_TIMESTAMP            AscDate();
    UTC_TIME_OFFSET                     AscString(5);
    CHARGEABLE_QUANTITY_VALUE           AscDecimal(15,false,0);
    CHARGEABLE_QUANTITY_UOM             AscString(3);
    VOLUME_SENT                         AscDecimal(15,false,0);
    VOLUME_SENT_UOM                     AscString(3);
    VOLUME_RECEIVED                     AscDecimal(15,false,0);
    VOLUME_RECEIVED_UOM                 AscString(3);
    ROUNDED_CHARGED_VOLUME              AscDecimal(15,false,0);
    ROUNDED_CHARGED_VOLUME_UOM          AscString(3);
    CHARGED_ZONE                        AscString(5);
    CHARGED_AMOUNT_VALUE                AscDecimal(11,true,5);
    CHARGED_AMOUNT_CURRENCY             AscString(3);
    CHARGED_ITEM                        AscString(1);
    CHARGED_TAX_TREATMENT               AscString(1);
    CHARGED_TAX_RATE                    AscInteger(4);
    AOC_ZONE                            AscString(5);
    AOC_AMOUNT_VALUE                    AscDecimal(11,true,5);
    AOC_AMOUNT_CURRENCY                 AscString(3);
    AOC_CHARGED_ITEM                    AscString(1);
    AOC_CHARGED_TAX_TREATMENT           AscString(1);
    AOC_TAX_RATE                        AscInteger(4);
    ALTERNATIVE_ZONE                    AscString(5);
    ALTERNATIVE_AMOUNT_VALUE            AscDecimal(11,true,5);
    ALTERNATIVE_AMOUNT_CURRENCY         AscString(3);
    ALTERNATIVE_CHARGED_ITEM            AscString(1);
    ALTERNATIVE_CHARGED_TAX_TREATMENT   AscString(1);
    ALTERNATIVE_TAX_RATE                AscInteger(4);
    BALANCE_AMOUNT_VALUE                AscDecimal(11,true,5);
    BALANCE_AMOUNT_CURRENCY             AscString(3);
    BALANCE_CHARGED_ITEM                AscString(1);
    BALANCE_CHARGED_TAX_TREATMENT       AscString(1);
    BALANCE_TAX_RATE                    AscInteger(4);
    TARIFF_CLASS                        AscString(10);
    TARIFF_SUB_CLASS                    AscString(10);
    CALL_CLASS                          AscString(5);
    CALL_TYPE                           AscString(5);
    BILLCYCLE_PERIOD                    AscString(8);
    NUMBER_ASSOCIATED_RECORDS           AscInteger(2);
    EOL                                 AscString(1);
  }

  //----------------------------------------------------------------------------
  // Associated zone record
  //----------------------------------------------------------------------------
  ASSOCIATED_ZONE(FIX)
  {
    Info
    {
      Pattern = "[0-9]{5}96[0-1]";
      SuccState = SOL42_V411_ZONE_PACKET;
    }
     
    RECORD_LENGTH                       AscInteger(5);
    RECORD_TYPE                         AscString(3);
    RECORD_NUMBER                       AscInteger(9);
    CONTRACT_CODE                       AscString(20);
    SEGMENT_CODE                        AscString(5);
    CUSTOMER_CODE                       AscString(20);
    ACCOUNT_CODE                        AscString(20);
    SYSTEM_BRAND_CODE                   AscString(5);
    SERVICE_CODE_USED                   AscString(5);
    RATEPLAN_CODE                       AscString(10);
    SLA_CODE                            AscString(5);
    CUSTOMER_BILLCYCLE                  AscString(2);
    CUSTOMER_CURRENCY                   AscString(3);
    CUSTOMER_TAXGROUP                   AscString(5);
    NUMBER_OF_ZONE_PACKETS              AscInteger(2);
  }
    
  //----------------------------------------------------------------------------
  // Zone packet record
  //----------------------------------------------------------------------------
  ZONE_PACKET(FIX)
  {
    Info
    {
      Pattern = ".";
      States = (SOL42_V411_ZONE_PACKET);
    }
    ZONEMODEL_CODE                      AscString(10);
    ZONE_RESULT_VALUE_WHOLESALE         AscString(5);
    ZONE_RESULT_VALUE_RETAIL            AscString(5);
    DISTANCE                            AscInteger(5);
  }
    
  //----------------------------------------------------------------------------
  // Associated charge record
  //----------------------------------------------------------------------------
  ASSOCIATED_CHARGE(FIX)
  {
    Info
    {
      Pattern = "[0-9]{5}(98[0-4]|99[0-1])";
      SuccState = SOL42_V411_CHARGE_PACKET;
    }
    
    RECORD_LENGTH                       AscInteger(5);
    RECORD_TYPE                         AscString(3);
    RECORD_NUMBER                       AscInteger(9);
    CONTRACT_CODE                       AscString(20);
    SEGMENT_CODE                        AscString(5);
    CUSTOMER_CODE                       AscString(20);
    ACCOUNT_CODE                        AscString(20);
    SYSTEM_BRAND_CODE                   AscString(5);
    SERVICE_CODE_USED                   AscString(5);
    RATEPLAN_CODE                       AscString(10);
    SLA_CODE                            AscString(5);
    CUSTOMER_BILLCYCLE                  AscString(2);
    CUSTOMER_CURRENCY                   AscString(3);
    CUSTOMER_TAXGROUP                   AscString(5);
    NUMBER_OF_CHARGE_PACKETS            AscInteger(2);
  }    

  //----------------------------------------------------------------------------
  // Charge packet record
  //----------------------------------------------------------------------------
  CHARGE_PACKET(FIX)
  {
    Info
    {
      Pattern = ".";
      States = (SOL42_V411_CHARGE_PACKET);
    }

    ZONEMODEL_CODE                      AscString(10);
    ZONE_RESULT_VALUE                   AscString(5);
    DISTANCE                            AscInteger(5);
    TARIFFMODEL_CODE                    AscString(10);
    TARIFFMODEL_TYPE                    AscString(1);
    TIMEMODEL_CODE                      AscString(10);
    TIMEZONE_CODE                       AscString(10);
    DAYCODE                             AscString(10);
    TIME_INTERVAL                       AscString(10);
    PRICEMODEL_TYPE                     AscString(1);
    PRICEMODEL_CODE                     AscString(10);
    PRICEMODEL_ITEM                     AscString(1);
    TARIFF_SERVICE_CODE_USED            AscString(5);
    TARIFF_SERVICE_CLASS_USED           AscString(5);
    NETWORK_OPERATOR                    AscString(10);
    NETWORK_OPERATOR_BILLINGTYPE        AscString(1);
    CHARGE_TYPE                         AscString(1);
    CHARGE_ITEM                         AscString(1);
    TRUNK_USED                          AscString(15);
    PRODUCTCODE_USED                    AscString(10);
    CHARGING_START_TIMESTAMP            AscDate();
    ROUNDED_CHARGED_QUANTITY_VALUE      AscDecimal(15,false,0);
    CHARGEABLE_QUANTITY_UOM             AscString(3);
    ROUNDED_VOLUME_SENT                 AscDecimal(15,false,0);
    VOLUME_SENT_UOM                     AscString(3);
    ROUNDED_VOLUME_RECEIVED             AscDecimal(15,false,0);
    VOLUME_RECEIVED_UOM                 AscString(3);
    CHARGED_AMOUNT_VALUE                AscDecimal(11,true,5);
    CHARGED_AMOUNT_CURRENCY             AscString(3);
    CHARGED_TAX_TREATMENT               AscString(1);
    CHARGED_TAX_RATE                    AscInteger(4);
    CHARGED_TAX_CODE                    AscString(5);
    USAGE_GL_ACCOUNT_CODE               AscString(10);
    REVENUE_GROUP_CODE                  AscString(5);
    DISCOUNTMODEL_CODE                  AscString(10);
    GRANTED_DISCOUNT_AMOUNT_VALUE       AscDecimal(11,true,5);
    GRANTED_DISCOUNT_QUANTITY_VALUE     AscDecimal(15,false,0);
    GRANTED_DISCOUNT_QUANTITY_VALUE_UOM AscString(3);
    GRANTED_DISCOUNT_VOLUME_SENT        AscDecimal(15,false,0);
    GRANTED_DISCOUNT_VOLUME_SENT_UOM    AscString(3);
    GRANTED_DISCOUNT_VOLUME_RECEIVED    AscDecimal(15,false,0);
    GRANTED_DISCOUNT_VOLUME_RECEIVED_UOM AscString(3);
  }

  //----------------------------------------------------------------------------
  // End-of-line record
  //----------------------------------------------------------------------------
  EOL(FIX)
  {
    Info
    {
      Pattern = "\n";
      States = (SOL42_V411_CHARGE_PACKET,SOL42_V411_ZONE_PACKET);
      SuccState = INITIAL;
    }

    EOL                                 AscString(1);
  }

  //----------------------------------------------------------------------------
  // Trailer record
  //----------------------------------------------------------------------------
  TRAILER(FIX)
  {
    Info
    {
      Pattern = "[0-9]{5}090";
    } 

    RECORD_LENGTH                       AscInteger(5);
    RECORD_TYPE                         AscString(3);
    RECORD_NUMBER                       AscInteger(9);
    SENDER                              AscString(10);
    RECIPIENT                           AscString(10);
    FILE_SEQUENCE_NUMBER                AscInteger(6);
    ORIGIN_FILE_SEQUENCE_NUMBER         AscInteger(6);
    TOTAL_NUMBER_OF_RECORDS             AscInteger(9);
    FIRST_CALL_TIMESTAMP                AscDate();
    LAST_CALL_TIMESTAMP                 AscDate();
    TOTAL_CHARGED_VALUE                 AscDecimal(15,true,5);
    TOTAL_AOC_AMOUNT_VALUE              AscDecimal(15,true,5);
    TOTAL_ALTERNATIVE_AMOUNT_VALUE      AscDecimal(15,true,5);
    EOL                                 AscString(1);
  }
}

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
//   Output mapping for the Sol42 V4.1.1 CDR format
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
// $RCSfile: SOL42_V411_OutMap.dsc,v $
// $Revision: 1.4 $
// $Author: pengelbr $
// $Date: 2001/05/17 14:16:28 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V411_OutMap.dsc,v $
// Revision 1.4  2001/05/17 14:16:28  pengelbr
// DETAIL.CHARGEABLE_QUANTITY_VALUE <- DETAIL.DURATION;
// DETAIL.CHARGEABLE_QUANTITY_UOM   <- DETAIL.DURATION_UOM;
// ASSOCIATED_ZONE.RECORD_LENGTH    <- DETAIL.ASS_ZBD.RECORD_LENGTH;
// ASSOCIATED_CHARGE.RECORD_LENGTH  <- DETAIL.ASS_CBD.RECORD_LENGTH;
//
// Revision 1.3  2001/05/17 08:50:52  sd
// - Backup version
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
  // Header record
  //----------------------------------------------------------------------------
  HEADER 
  {
    STD_MAPPING
    {
      RECORD_TYPE                  <- HEADER.RECORD_TYPE;
      RECORD_LENGTH                <- 111;
      RECORD_NUMBER                <- HEADER.RECORD_NUMBER;
      SENDER                       <- HEADER.SENDER;
      RECIPIENT                    <- HEADER.RECIPIENT;
      FILE_SEQUENCE_NUMBER         <- HEADER.SEQUENCE_NUMBER;
      ORIGIN_FILE_SEQUENCE_NUMBER  <- HEADER.ORIGIN_SEQUENCE_NUMBER;
      FILE_CREATION_TIMESTAMP      <- HEADER.CREATION_TIMESTAMP;
      FILE_TRANSMISSION_DATE       <- HEADER.TRANSMISSION_DATE;
      TRANSFER_CUTOFF_TIMESTAMP    <- HEADER.TRANSFER_CUTOFF_TIMESTAMP;
      UTC_TIME_OFFSET              <- HEADER.UTC_TIME_OFFSET;
      SPECIFICATION_VERSION_NUMBER <- HEADER.SPECIFICATION_VERSION_NUMBER;
      RELEASE_VERSION              <- HEADER.RELEASE_VERSION;
      ORIGIN_COUNTRY_CODE          <- HEADER.ORIGIN_COUNTRY_CODE;
      SENDER_COUNTRY_CODE          <- HEADER.SENDER_COUNTRY_CODE;
      FILE_TYPE_INDICATOR          <- HEADER.DATA_TYPE_INDICATOR;
      EOL                          <- "\n";
    }
  }
    
  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL
  {
    STD_MAPPING
    {
      RECORD_TYPE                     <- DETAIL.RECORD_TYPE;
      RECORD_LENGTH                   <- 727;
      RECORD_NUMBER                   <- DETAIL.RECORD_NUMBER;
      DISCARDING                      <- DETAIL.DISCARDING;
      CHAIN_REFERENCE                 <- DETAIL.CHAIN_REFERENCE;
      SOURCE_NETWORK_TYPE             <- DETAIL.SOURCE_NETWORK_TYPE;
      SOURCE_NETWORK                  <- DETAIL.SOURCE_NETWORK;
      DESTINATION_NETWORK_TYPE        <- DETAIL.DESTINATION_NETWORK_TYPE;
      DESTINATION_NETWORK             <- DETAIL.DESTINATION_NETWORK;
      TYPE_OF_A_IDENTIFICATION        <- DETAIL.TYPE_OF_A_IDENTIFICATION;
      PORT_NUMBER                     <- "";
      DEVICE_NUMBER                   <- "";
      A_MODIFICATION_INDICATOR        <- DETAIL.A_MODIFICATION_INDICATOR;
      A_TYPE_OF_NUMBER                <- DETAIL.A_TYPE_OF_NUMBER;
      A_NUMBERING_PLAN                <- DETAIL.A_NUMBERING_PLAN;
      A_NUMBER                        <- DETAIL.A_NUMBER;
      A_NUMBER_USER                   <- "";
      B_MODIFICATION_INDICATOR        <- DETAIL.B_MODIFICATION_INDICATOR;
      B_TYPE_OF_NUMBER                <- DETAIL.B_TYPE_OF_NUMBER;
      DIALED_DIGITS                   <- "";
      B_NUMBER                        <- DETAIL.B_NUMBER;
      B_NUMBER_DESTINATION_DECRIPTION <- DETAIL.DESCRIPTION;
      C_MODIFICATION_INDICATOR        <- DETAIL.C_MODIFICATION_INDICATOR;
      C_TYPE_OF_NUMBER                <- DETAIL.C_TYPE_OF_NUMBER;
      C_NUMBERING_PLAN                <- DETAIL.C_NUMBERING_PLAN;
      C_NUMBER                        <- DETAIL.C_NUMBER;
      CONNECT_TYPE                    <- DETAIL.CONNECT_TYPE;
      CONNECT_SUB_TYPE                <- DETAIL.CONNECT_SUB_TYPE;
      BASIC_SERVICE                   <- DETAIL.BASIC_SERVICE;
      BASIC_DUAL_SERVICE              <- "";
      QOS_REQUESTED                   <- "";
      QOS_USED                        <- "";
      APPLICATION                     <- "";
      CALL_COMPLETION_INDICATOR       <- DETAIL.CALL_COMPLETION_INDICATOR;
      LONG_DURATION_INDICATOR         <- DETAIL.LONG_DURATION_INDICATOR;
      SWITCH_IDENTIFICATION           <- "";
      TRUNC_INPUT                     <- "";
      TRUNC_OUTPUT                    <- "";
      LOCATION_AREA_INDICATOR         <- "";
      CELL_ID                         <- "";
      MS_CLASS_MARK                   <- 0;
      CHARGING_START_TIMESTAMP        <- DETAIL.CHARGING_START_TIMESTAMP;
      UTC_TIME_OFFSET                 <- DETAIL.UTC_TIME_OFFSET;
      CHARGEABLE_QUANTITY_VALUE       <- DETAIL.DURATION;
      CHARGEABLE_QUANTITY_UOM         <- DETAIL.DURATION_UOM;
      VOLUME_SENT                     <- DETAIL.VOLUME_SENT;
      VOLUME_SENT_UOM                 <- DETAIL.VOLUME_SENT_UOM;
      VOLUME_RECEIVED                 <- DETAIL.VOLUME_RECEIVED;
      VOLUME_RECEIVED_UOM             <- DETAIL.VOLUME_RECEIVED_UOM;
      ROUNDED_CHARGED_VOLUME          <- 0.0;
      ROUNDED_CHARGED_VOLUME_UOM      <- "";
      CHARGED_ZONE                    <- DETAIL.RETAIL_IMPACT_CATEGORY;
      CHARGED_AMOUNT_VALUE            <- DETAIL.RETAIL_CHARGED_AMOUNT_VALUE;
      CHARGED_AMOUNT_CURRENCY         <- DETAIL.RETAIL_CHARGED_AMOUNT_CURRENCY;
      CHARGED_TAX_TREATMENT           <- DETAIL.RETAIL_CHARGED_TAX_TREATMENT;
      CHARGED_TAX_RATE                <- DETAIL.RETAIL_CHARGED_TAX_RATE;
      CHARGED_ITEM                    <- "";
      AOC_ZONE                        <- DETAIL.WHOLESALE_IMPACT_CATEGORY;
      AOC_AMOUNT_VALUE                <- DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE;
      AOC_AMOUNT_CURRENCY             <- DETAIL.WHOLESALE_CHARGED_AMOUNT_CURRENCY;
      AOC_CHARGED_ITEM                <- "";
      AOC_CHARGED_TAX_TREATMENT       <- DETAIL.WHOLESALE_CHARGED_TAX_TREATMENT;
      AOC_TAX_RATE                    <- DETAIL.WHOLESALE_CHARGED_TAX_RATE;
      ALTERNATIVE_ZONE                <- "";
      ALTERNATIVE_AMOUNT_VALUE        <- 0.0;
      ALTERNATIVE_AMOUNT_CURRENCY       <- "";
      ALTERNATIVE_CHARGED_ITEM          <- "";
      ALTERNATIVE_CHARGED_TAX_TREATMENT <- "";
      ALTERNATIVE_TAX_RATE              <- 0;
      BALANCE_AMOUNT_VALUE              <- 0.0;
      BALANCE_AMOUNT_CURRENCY           <- "";
      BALANCE_CHARGED_ITEM              <- "";
      BALANCE_CHARGED_TAX_TREATMENT     <- "";
      BALANCE_TAX_RATE                  <- 0;
      TARIFF_CLASS                      <- DETAIL.TARIFF_CLASS;
      TARIFF_SUB_CLASS                  <- DETAIL.TARIFF_SUB_CLASS;
      CALL_CLASS                        <- DETAIL.USAGE_CLASS;
      CALL_TYPE                         <- DETAIL.USAGE_TYPE;
      BILLCYCLE_PERIOD                  <- DETAIL.BILLCYCLE_PERIOD;
      NUMBER_ASSOCIATED_RECORDS         <- DETAIL.NUMBER_ASSOCIATED_RECORDS;
      EOL                               <- "\n";
    }
  }

  //----------------------------------------------------------------------------
  // Associated zone record
  //----------------------------------------------------------------------------
  ASSOCIATED_ZONE
  {
    STD_MAPPING
    {
      RECORD_TYPE                        <- DETAIL.ASS_ZBD.RECORD_TYPE;
      RECORD_LENGTH                      <- DETAIL.ASS_ZBD.RECORD_LENGTH;
      RECORD_NUMBER                      <- DETAIL.ASS_ZBD.RECORD_NUMBER;
      CONTRACT_CODE                      <- DETAIL.ASS_ZBD.CONTRACT_CODE;
      SEGMENT_CODE                       <- DETAIL.ASS_ZBD.SEGMENT_CODE;
      CUSTOMER_CODE                      <- DETAIL.ASS_ZBD.CUSTOMER_CODE;
      ACCOUNT_CODE                       <- DETAIL.ASS_ZBD.ACCOUNT_CODE;
      SYSTEM_BRAND_CODE                  <- DETAIL.ASS_ZBD.SYSTEM_BRAND_CODE;
      SERVICE_CODE_USED                  <- DETAIL.ASS_ZBD.SERVICE_CODE;
      RATEPLAN_CODE                      <- DETAIL.ASS_ZBD.CUSTOMER_RATEPLAN_CODE;
      SLA_CODE                           <- DETAIL.ASS_ZBD.SLA_CODE;
      CUSTOMER_BILLCYCLE                 <- DETAIL.ASS_ZBD.CUSTOMER_BILLCYCLE;
      CUSTOMER_CURRENCY                  <- DETAIL.ASS_ZBD.CUSTOMER_CURRENCY;
      CUSTOMER_TAXGROUP                  <- DETAIL.ASS_ZBD.CUSTOMER_TAXGROUP;
      NUMBER_OF_ZONE_PACKETS             <- DETAIL.ASS_ZBD.NUMBER_OF_ZONE_PACKETS;
    }
  }
   
  //----------------------------------------------------------------------------
  // Zone packet record
  //----------------------------------------------------------------------------
  ZONE_PACKET
  {
    STD_MAPPING
    {
      ZONEMODEL_CODE                     <- DETAIL.ASS_ZBD.ZP.ZONEMODEL_CODE;
      ZONE_RESULT_VALUE_WHOLESALE        <- DETAIL.ASS_ZBD.ZP.ZONE_RESULT_VALUE_WS;
      ZONE_RESULT_VALUE_RETAIL           <- DETAIL.ASS_ZBD.ZP.ZONE_RESULT_VALUE_RT;
      DISTANCE                           <- DETAIL.ASS_ZBD.ZP.DISTANCE;
    }
  }
    
  //----------------------------------------------------------------------------
  // Associated charge record
  //----------------------------------------------------------------------------
  ASSOCIATED_CHARGE
  {
    STD_MAPPING
    {
      RECORD_TYPE                        <- DETAIL.ASS_CBD.RECORD_TYPE;
      RECORD_LENGTH                      <- DETAIL.ASS_CBD.RECORD_LENGTH;
      RECORD_NUMBER                      <- DETAIL.ASS_CBD.RECORD_NUMBER;
      CONTRACT_CODE                      <- DETAIL.ASS_CBD.CONTRACT_CODE;
      SEGMENT_CODE                       <- DETAIL.ASS_CBD.SEGMENT_CODE;
      CUSTOMER_CODE                      <- DETAIL.ASS_CBD.CUSTOMER_CODE;
      ACCOUNT_CODE                       <- DETAIL.ASS_CBD.ACCOUNT_CODE;
      SYSTEM_BRAND_CODE                  <- DETAIL.ASS_CBD.SYSTEM_BRAND_CODE;
      SERVICE_CODE_USED                  <- DETAIL.ASS_CBD.SERVICE_CODE;
      RATEPLAN_CODE                      <- DETAIL.ASS_CBD.CUSTOMER_RATEPLAN_CODE;
      SLA_CODE                           <- DETAIL.ASS_CBD.SLA_CODE;
      CUSTOMER_BILLCYCLE                 <- DETAIL.ASS_CBD.CUSTOMER_BILLCYCLE;
      CUSTOMER_CURRENCY                  <- DETAIL.ASS_CBD.CUSTOMER_CURRENCY;
      CUSTOMER_TAXGROUP                  <- DETAIL.ASS_CBD.CUSTOMER_TAXGROUP;
      NUMBER_OF_CHARGE_PACKETS           <- DETAIL.ASS_CBD.NUMBER_OF_CHARGE_PACKETS;
    }
  }

  //----------------------------------------------------------------------------
  // Charge packet record
  //----------------------------------------------------------------------------
  CHARGE_PACKET
  {
    STD_MAPPING
    {
      ZONEMODEL_CODE                     <- DETAIL.ASS_CBD.CP.ZONEMODEL_CODE;
      ZONE_RESULT_VALUE                  <- DETAIL.ASS_CBD.CP.IMPACT_CATEGORY;
      DISTANCE                           <- DETAIL.ASS_CBD.CP.DISTANCE;
      TARIFFMODEL_CODE                   <- DETAIL.ASS_CBD.CP.RATEPLAN_CODE;
      TARIFFMODEL_TYPE                   <- DETAIL.ASS_CBD.CP.RATEPLAN_TYPE;
      TIMEMODEL_CODE                     <- DETAIL.ASS_CBD.CP.TIMEMODEL_CODE;
      TIMEZONE_CODE                      <- DETAIL.ASS_CBD.CP.TIMEZONE_CODE;
      DAYCODE                            <- DETAIL.ASS_CBD.CP.DAY_CODE;
      TIME_INTERVAL                      <- DETAIL.ASS_CBD.CP.TIME_INTERVAL_CODE;
      PRICEMODEL_TYPE                    <- DETAIL.ASS_CBD.CP.PRICEMODEL_TYPE;
      PRICEMODEL_CODE                    <- DETAIL.ASS_CBD.CP.PRICEMODEL_CODE;
      PRICEMODEL_ITEM                    <- "";
      TARIFF_SERVICE_CODE_USED           <- DETAIL.ASS_CBD.CP.SERVICE_CODE_USED;
      TARIFF_SERVICE_CLASS_USED          <- DETAIL.ASS_CBD.CP.SERVICE_CLASS_USED;
      NETWORK_OPERATOR                   <- DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_CODE;
      NETWORK_OPERATOR_BILLINGTYPE       <- DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_BILLINGTYPE;
      CHARGE_TYPE                        <- DETAIL.ASS_CBD.CP.CHARGE_TYPE;
      CHARGE_ITEM                        <- "";
      TRUNK_USED                         <- DETAIL.ASS_CBD.CP.TRUNK_USED;
      PRODUCTCODE_USED                   <- DETAIL.ASS_CBD.CP.PRODUCTCODE_USED;
      CHARGING_START_TIMESTAMP           <- DETAIL.ASS_CBD.CP.CHARGING_START_TIMESTAMP;
      ROUNDED_CHARGED_QUANTITY_VALUE     <- DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_VALUE;
      CHARGEABLE_QUANTITY_UOM            <- DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_UOM;
      ROUNDED_VOLUME_SENT                <- 0.0;
      VOLUME_SENT_UOM                    <- "";
      ROUNDED_VOLUME_RECEIVED            <- 0.0;
      VOLUME_RECEIVED_UOM                <- "";
      CHARGED_AMOUNT_VALUE               <- DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_VALUE;
      CHARGED_AMOUNT_CURRENCY            <- DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_CURRENCY;
      CHARGED_TAX_TREATMENT              <- DETAIL.ASS_CBD.CP.CHARGED_TAX_TREATMENT;
      CHARGED_TAX_RATE                   <- DETAIL.ASS_CBD.CP.CHARGED_TAX_RATE;
      CHARGED_TAX_CODE                   <- DETAIL.ASS_CBD.CP.CHARGED_TAX_CODE;
      USAGE_GL_ACCOUNT_CODE               <- DETAIL.ASS_CBD.CP.USAGE_GL_ACCOUNT_CODE;
      REVENUE_GROUP_CODE                 <- DETAIL.ASS_CBD.CP.REVENUE_GROUP_CODE;
      DISCOUNTMODEL_CODE                 <- DETAIL.ASS_CBD.CP.DISCOUNTMODEL_CODE;
      GRANTED_DISCOUNT_AMOUNT_VALUE      <- DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_AMOUNT_VALUE;
      GRANTED_DISCOUNT_QUANTITY_VALUE    <- DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_VALUE;
      GRANTED_DISCOUNT_QUANTITY_VALUE_UOM<- DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_UOM;
      GRANTED_DISCOUNT_VOLUME_SENT       <- 0.0;
      GRANTED_DISCOUNT_VOLUME_SENT_UOM   <- ""; 
      GRANTED_DISCOUNT_VOLUME_RECEIVED   <- 0.0;
      GRANTED_DISCOUNT_VOLUME_RECEIVED_UOM <- "";
    }
  }

  //----------------------------------------------------------------------------
  // End-Of-Line record
  //----------------------------------------------------------------------------
  EOL
  {
    STD_MAPPING
    {
      EOL <- "\n";
    }
  }


  //----------------------------------------------------------------------------
  // Trailer record
  //----------------------------------------------------------------------------
  TRAILER
  {
    STD_MAPPING
    {
      RECORD_TYPE                      <- TRAILER.RECORD_TYPE;
      RECORD_LENGTH                    <- 131;
      RECORD_NUMBER                    <- TRAILER.RECORD_NUMBER;
      SENDER                           <- TRAILER.SENDER;
      RECIPIENT                        <- TRAILER.RECIPIENT;
      FILE_SEQUENCE_NUMBER             <- TRAILER.SEQUENCE_NUMBER;
      ORIGIN_FILE_SEQUENCE_NUMBER      <- TRAILER.ORIGIN_SEQUENCE_NUMBER;
      TOTAL_NUMBER_OF_RECORDS          <- TRAILER.TOTAL_NUMBER_OF_RECORDS;
      FIRST_CALL_TIMESTAMP             <- TRAILER.FIRST_START_TIMESTAMP;
      LAST_CALL_TIMESTAMP              <- TRAILER.LAST_START_TIMESTAMP;
      TOTAL_CHARGED_VALUE              <- TRAILER.TOTAL_RETAIL_CHARGED_VALUE;
      TOTAL_AOC_AMOUNT_VALUE           <- TRAILER.TOTAL_WHOLESALE_CHARGED_VALUE;
      TOTAL_ALTERNATIVE_AMOUNT_VALUE   <- 0.0;
      EOL                              <- "\n";
    }
  }
}

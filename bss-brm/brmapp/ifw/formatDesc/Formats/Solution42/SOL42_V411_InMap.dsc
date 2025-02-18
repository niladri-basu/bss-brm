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
//   Input mapping for the Sol42 V4.1.1 CDR format
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
// $RCSfile: SOL42_V411_InMap.dsc,v $
// $Revision: 1.8 $
// $Author: sd $
// $Date: 2001/06/27 09:08:01 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V411_InMap.dsc,v $
// Revision 1.8  2001/06/27 09:08:01  sd
// - Bugfix
//
// Revision 1.7  2001/06/26 10:55:53  sd
// - iScript functions renamed
// - no return value check for mapping functions
//
// Revision 1.6  2001/06/14 07:38:45  pengelbr
// Set '*' as default for INTERN_SERVICE_CLASS.
//
// Revision 1.5  2001/06/11 09:31:30  pengelbr
// Put quantity into duration...
//
// Revision 1.4  2001/05/21 14:39:06  pengelbr
// Fill Assoc. GSM Wireline record with values.
//
// Revision 1.3  2001/05/16 14:23:16  pengelbr
// CHARGEABLE_QUANTITY maps to DURATION
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
      RECORD_TYPE                  -> HEADER.RECORD_TYPE;
      RECORD_NUMBER                -> HEADER.RECORD_NUMBER;
      SENDER                       -> HEADER.SENDER;
      RECIPIENT                    -> HEADER.RECIPIENT;
      FILE_SEQUENCE_NUMBER         -> HEADER.SEQUENCE_NUMBER;
      ORIGIN_FILE_SEQUENCE_NUMBER  -> HEADER.ORIGIN_SEQUENCE_NUMBER;
      FILE_CREATION_TIMESTAMP      -> HEADER.CREATION_TIMESTAMP;
      FILE_TRANSMISSION_DATE       -> HEADER.TRANSMISSION_DATE;
      TRANSFER_CUTOFF_TIMESTAMP    -> HEADER.TRANSFER_CUTOFF_TIMESTAMP;
      UTC_TIME_OFFSET              -> HEADER.UTC_TIME_OFFSET;
      SPECIFICATION_VERSION_NUMBER -> HEADER.SPECIFICATION_VERSION_NUMBER;
      RELEASE_VERSION              -> HEADER.RELEASE_VERSION;
      ORIGIN_COUNTRY_CODE          -> HEADER.ORIGIN_COUNTRY_CODE;
      SENDER_COUNTRY_CODE          -> HEADER.SENDER_COUNTRY_CODE;
      FILE_TYPE_INDICATOR          -> HEADER.DATA_TYPE_INDICATOR;
    }

    V430_MAPPING
    {
      RECORD_TYPE                  -> HEADER.RECORD_TYPE;
      RECORD_NUMBER                -> HEADER.RECORD_NUMBER;
      SENDER                       -> HEADER.SENDER;
      RECIPIENT                    -> HEADER.RECIPIENT;
      FILE_SEQUENCE_NUMBER         -> HEADER.SEQUENCE_NUMBER;
      ORIGIN_FILE_SEQUENCE_NUMBER  -> HEADER.ORIGIN_SEQUENCE_NUMBER;
      FILE_CREATION_TIMESTAMP      -> HEADER.CREATION_TIMESTAMP;
      FILE_TRANSMISSION_DATE       -> HEADER.TRANSMISSION_DATE;
      TRANSFER_CUTOFF_TIMESTAMP    -> HEADER.TRANSFER_CUTOFF_TIMESTAMP;
      UTC_TIME_OFFSET              -> HEADER.UTC_TIME_OFFSET;
      SPECIFICATION_VERSION_NUMBER -> HEADER.SPECIFICATION_VERSION_NUMBER;
      RELEASE_VERSION              -> HEADER.RELEASE_VERSION;
      ORIGIN_COUNTRY_CODE          -> HEADER.ORIGIN_COUNTRY_CODE;
      SENDER_COUNTRY_CODE          -> HEADER.SENDER_COUNTRY_CODE;
      FILE_TYPE_INDICATOR          -> HEADER.DATA_TYPE_INDICATOR;
    }
  }
    
  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL
  {
    STD_MAPPING
    {
      RECORD_TYPE                     -> DETAIL.RECORD_TYPE;
      RECORD_NUMBER                   -> DETAIL.RECORD_NUMBER;
      DISCARDING                      -> DETAIL.DISCARDING;
      CHAIN_REFERENCE                 -> DETAIL.CHAIN_REFERENCE;
      SOURCE_NETWORK_TYPE             -> DETAIL.SOURCE_NETWORK_TYPE;
      SOURCE_NETWORK                  -> DETAIL.SOURCE_NETWORK;
      DESTINATION_NETWORK_TYPE        -> DETAIL.DESTINATION_NETWORK_TYPE;
      DESTINATION_NETWORK             -> DETAIL.DESTINATION_NETWORK;
      TYPE_OF_A_IDENTIFICATION        -> DETAIL.TYPE_OF_A_IDENTIFICATION;
//     PORT_NUMBER                     -> DETAIL.PORT_NUMBER;
//      DEVICE_NUMBER                   -> DETAIL.DEVICE_NUMBER;
      A_MODIFICATION_INDICATOR        -> DETAIL.A_MODIFICATION_INDICATOR;
      A_TYPE_OF_NUMBER                -> DETAIL.A_TYPE_OF_NUMBER;
      A_NUMBERING_PLAN                -> DETAIL.A_NUMBERING_PLAN;
      A_NUMBER                        -> DETAIL.A_NUMBER;
      A_NUMBER                        -> DETAIL.INTERN_A_NUMBER_ZONE;
//      A_NUMBER_USER                   -> DETAIL.A_NUMBER_USER;
      B_MODIFICATION_INDICATOR        -> DETAIL.B_MODIFICATION_INDICATOR;
      B_TYPE_OF_NUMBER                -> DETAIL.B_TYPE_OF_NUMBER;
//      DIALED_DIGITS                   -> DETAIL.DIALED_DIGITS;
      B_NUMBER                        -> DETAIL.B_NUMBER;
      B_NUMBER                        -> DETAIL.INTERN_B_NUMBER_ZONE;
      B_NUMBER_DESTINATION_DECRIPTION -> DETAIL.DESCRIPTION;
      C_MODIFICATION_INDICATOR        -> DETAIL.C_MODIFICATION_INDICATOR;
      C_TYPE_OF_NUMBER                -> DETAIL.C_TYPE_OF_NUMBER;
      C_NUMBERING_PLAN                -> DETAIL.C_NUMBERING_PLAN;
      C_NUMBER                        -> DETAIL.C_NUMBER;
      C_NUMBER                        -> DETAIL.INTERN_C_NUMBER_ZONE;
      CONNECT_TYPE                    -> DETAIL.CONNECT_TYPE;
      CONNECT_SUB_TYPE                -> DETAIL.CONNECT_SUB_TYPE;
      BASIC_SERVICE                   -> DETAIL.BASIC_SERVICE;
      BASIC_SERVICE                   -> DETAIL.INTERN_SERVICE_CODE;
//      BASIC_DUAL_SERVICE              -> DETAIL.BASIC_DUAL_SERVICE;
//      QOS_REQUESTED                   -> DETAIL.QOS_REQUESTED;
//      QOS_USED                        -> DETAIL.QOS_USED;
//      APPLICATION                     -> DETAIL.APPLICATION;
      CALL_COMPLETION_INDICATOR       -> DETAIL.CALL_COMPLETION_INDICATOR;
      LONG_DURATION_INDICATOR         -> DETAIL.LONG_DURATION_INDICATOR;
//      SWITCH_IDENTIFICATION           -> DETAIL.ORIGINATING_SWITCH_IDENTIFICATION;
//      SWITCH_IDENTIFICATION           -> DETAIL.TERMINATING_SWITCH_IDENTIFICATION;
//      TRUNC_INPUT                     -> DETAIL.TRUNC_INPUT;
//      TRUNC_OUTPUT                    -> DETAIL.TRUNC_OUTPUT;
//      LOCATION_AREA_INDICATOR         -> DETAIL.LOCATION_AREA_INDICATOR;
//      CELL_ID                         -> DETAIL.CELL_ID;
//      MS_CLASS_MARK                   -> DETAIL.MS_CLASS_MARK;
      CHARGING_START_TIMESTAMP        -> DETAIL.CHARGING_START_TIMESTAMP;
      UTC_TIME_OFFSET                 -> DETAIL.UTC_TIME_OFFSET;
      CHARGEABLE_QUANTITY_VALUE       -> DETAIL.DURATION;
//      CHARGEABLE_QUANTITY_VALUE       -> DETAIL.INTERN_QUANTITY_VALUE;
      CHARGEABLE_QUANTITY_UOM         -> DETAIL.DURATION_UOM;
      VOLUME_SENT                     -> DETAIL.VOLUME_SENT;
      VOLUME_SENT_UOM                 -> DETAIL.VOLUME_SENT_UOM;
      VOLUME_RECEIVED                 -> DETAIL.VOLUME_RECEIVED;
      VOLUME_RECEIVED_UOM             -> DETAIL.VOLUME_RECEIVED_UOM;
//      ROUNDED_CHARGED_VOLUME          -> DETAIL.ROUNDED_CHARGED_VOLUME;
//      ROUNDED_CHARGED_VOLUME_UOM      -> DETAIL.ROUNDED_CHARGED_VOLUME_UOM;
      CHARGED_ZONE                    -> DETAIL.RETAIL_IMPACT_CATEGORY;
      CHARGED_AMOUNT_VALUE            -> DETAIL.RETAIL_CHARGED_AMOUNT_VALUE;
      CHARGED_AMOUNT_CURRENCY         -> DETAIL.RETAIL_CHARGED_AMOUNT_CURRENCY;
      CHARGED_TAX_TREATMENT           -> DETAIL.RETAIL_CHARGED_TAX_TREATMENT;
      CHARGED_TAX_RATE                  -> DETAIL.RETAIL_CHARGED_TAX_RATE;
      AOC_ZONE                          -> DETAIL.WHOLESALE_IMPACT_CATEGORY;
      AOC_AMOUNT_VALUE                  -> DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE;
      AOC_AMOUNT_CURRENCY               -> DETAIL.WHOLESALE_CHARGED_AMOUNT_CURRENCY;
//      AOC_CHARGED_ITEM                -> 
      AOC_CHARGED_TAX_TREATMENT         -> DETAIL.WHOLESALE_CHARGED_TAX_TREATMENT;
      AOC_TAX_RATE                      -> DETAIL.WHOLESALE_CHARGED_TAX_RATE;
//      ALTERNATIVE_ZONE                -> 
//      ALTERNATIVE_AMOUNT_VALUE        -> 
//      ALTERNATIVE_AMOUNT_CURRENCY       -> 
//      ALTERNATIVE_CHARGED_ITEM          -> 
//      ALTERNATIVE_CHARGED_TAX_TREATMENT -> 
//      ALTERNATIVE_TAX_RATE              -> 
//      BALANCE_AMOUNT_VALUE              -> 
//      BALANCE_AMOUNT_CURRENCY           -> 
//      BALANCE_CHARGED_ITEM              -> 
//      BALANCE_CHARGED_TAX_TREATMENT     -> 
//      BALANCE_TAX_RATE                  -> 
      TARIFF_CLASS                      -> DETAIL.TARIFF_CLASS;
      TARIFF_SUB_CLASS                  -> DETAIL.TARIFF_SUB_CLASS;
      CALL_CLASS                        -> DETAIL.USAGE_CLASS;
      CALL_CLASS                        -> DETAIL.INTERN_USAGE_CLASS;
      CALL_TYPE                         -> DETAIL.USAGE_TYPE;
      BILLCYCLE_PERIOD                  -> DETAIL.BILLCYCLE_PERIOD;
      NUMBER_ASSOCIATED_RECORDS         -> DETAIL.NUMBER_ASSOCIATED_RECORDS;
      "*"                               -> DETAIL.INTERN_SERVICE_CLASS;
    }

    //--------------------------------------------------------------------------
    // Mapping for the conversion from V4.11 -> V4.30
    //--------------------------------------------------------------------------
    V430_MAPPING
    {
      RECORD_TYPE                     -> DETAIL.RECORD_TYPE;
      RECORD_NUMBER                   -> DETAIL.RECORD_NUMBER;
      DISCARDING                      -> DETAIL.DISCARDING;
      CHAIN_REFERENCE                 -> DETAIL.CHAIN_REFERENCE;
      SOURCE_NETWORK_TYPE             -> DETAIL.SOURCE_NETWORK_TYPE;
      SOURCE_NETWORK                  -> DETAIL.SOURCE_NETWORK;
      DESTINATION_NETWORK_TYPE        -> DETAIL.DESTINATION_NETWORK_TYPE;
      DESTINATION_NETWORK             -> DETAIL.DESTINATION_NETWORK;
      TYPE_OF_A_IDENTIFICATION        -> DETAIL.TYPE_OF_A_IDENTIFICATION;
//     PORT_NUMBER                     -> DETAIL.PORT_NUMBER;
//      DEVICE_NUMBER                   -> DETAIL.DEVICE_NUMBER;
      A_MODIFICATION_INDICATOR        -> DETAIL.A_MODIFICATION_INDICATOR;
      A_TYPE_OF_NUMBER                -> DETAIL.A_TYPE_OF_NUMBER;
      A_NUMBERING_PLAN                -> DETAIL.A_NUMBERING_PLAN;
      A_NUMBER                        -> DETAIL.A_NUMBER;
      A_NUMBER                        -> DETAIL.INTERN_A_NUMBER_ZONE;
//      A_NUMBER_USER                   -> DETAIL.A_NUMBER_USER;
      B_MODIFICATION_INDICATOR        -> DETAIL.B_MODIFICATION_INDICATOR;
      B_TYPE_OF_NUMBER                -> DETAIL.B_TYPE_OF_NUMBER;
//      DIALED_DIGITS                   -> DETAIL.DIALED_DIGITS;
      B_NUMBER                        -> DETAIL.B_NUMBER;
      B_NUMBER                        -> DETAIL.INTERN_B_NUMBER_ZONE;
      B_NUMBER_DESTINATION_DECRIPTION -> DETAIL.DESCRIPTION;
      C_MODIFICATION_INDICATOR        -> DETAIL.C_MODIFICATION_INDICATOR;
      C_TYPE_OF_NUMBER                -> DETAIL.C_TYPE_OF_NUMBER;
      C_NUMBERING_PLAN                -> DETAIL.C_NUMBERING_PLAN;
      C_NUMBER                        -> DETAIL.C_NUMBER;
      C_NUMBER                        -> DETAIL.INTERN_C_NUMBER_ZONE;
      CONNECT_TYPE                    -> DETAIL.CONNECT_TYPE;
      CONNECT_SUB_TYPE                -> DETAIL.CONNECT_SUB_TYPE;
      BASIC_SERVICE                   -> DETAIL.BASIC_SERVICE;
      BASIC_SERVICE                   -> DETAIL.INTERN_SERVICE_CODE;
//      BASIC_DUAL_SERVICE              -> DETAIL.BASIC_DUAL_SERVICE;
//      QOS_REQUESTED                   -> DETAIL.QOS_REQUESTED;
//      QOS_USED                        -> DETAIL.QOS_USED;
//      APPLICATION                     -> DETAIL.APPLICATION;
      CALL_COMPLETION_INDICATOR       -> DETAIL.CALL_COMPLETION_INDICATOR;
      LONG_DURATION_INDICATOR         -> DETAIL.LONG_DURATION_INDICATOR;
//      SWITCH_IDENTIFICATION           -> DETAIL.ORIGINATING_SWITCH_IDENTIFICATION;
//      SWITCH_IDENTIFICATION           -> DETAIL.TERMINATING_SWITCH_IDENTIFICATION;
//      TRUNC_INPUT                     -> DETAIL.TRUNC_INPUT;
//      TRUNC_OUTPUT                    -> DETAIL.TRUNC_OUTPUT;
//      LOCATION_AREA_INDICATOR         -> DETAIL.LOCATION_AREA_INDICATOR;
//      CELL_ID                         -> DETAIL.CELL_ID;
//      MS_CLASS_MARK                   -> DETAIL.MS_CLASS_MARK;
      CHARGING_START_TIMESTAMP        -> DETAIL.CHARGING_START_TIMESTAMP;
      CHARGING_START_TIMESTAMP        -> DETAIL.CHARGING_END_TIMESTAMP;
      UTC_TIME_OFFSET                 -> DETAIL.UTC_TIME_OFFSET;
      CHARGEABLE_QUANTITY_VALUE       -> DETAIL.DURATION;
//      CHARGEABLE_QUANTITY_VALUE       -> DETAIL.INTERN_QUANTITY_VALUE;
      CHARGEABLE_QUANTITY_UOM         -> DETAIL.DURATION_UOM;
      VOLUME_SENT                     -> DETAIL.VOLUME_SENT;
      VOLUME_SENT_UOM                 -> DETAIL.VOLUME_SENT_UOM;
      VOLUME_RECEIVED                 -> DETAIL.VOLUME_RECEIVED;
      VOLUME_RECEIVED_UOM             -> DETAIL.VOLUME_RECEIVED_UOM;
//      ROUNDED_CHARGED_VOLUME          -> DETAIL.ROUNDED_CHARGED_VOLUME;
//      ROUNDED_CHARGED_VOLUME_UOM      -> DETAIL.ROUNDED_CHARGED_VOLUME_UOM;
      CHARGED_ZONE                    -> DETAIL.RETAIL_IMPACT_CATEGORY;
      CHARGED_AMOUNT_VALUE            -> DETAIL.RETAIL_CHARGED_AMOUNT_VALUE;
      CHARGED_AMOUNT_CURRENCY         -> DETAIL.RETAIL_CHARGED_AMOUNT_CURRENCY;
      CHARGED_TAX_TREATMENT           -> DETAIL.RETAIL_CHARGED_TAX_TREATMENT;
      CHARGED_TAX_RATE                  -> DETAIL.RETAIL_CHARGED_TAX_RATE;
      AOC_ZONE                          -> DETAIL.WHOLESALE_IMPACT_CATEGORY;
      AOC_AMOUNT_VALUE                  -> DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE;
      AOC_AMOUNT_CURRENCY               -> DETAIL.WHOLESALE_CHARGED_AMOUNT_CURRENCY;
//      AOC_CHARGED_ITEM                -> 
      AOC_CHARGED_TAX_TREATMENT         -> DETAIL.WHOLESALE_CHARGED_TAX_TREATMENT;
      AOC_TAX_RATE                      -> DETAIL.WHOLESALE_CHARGED_TAX_RATE;
//      ALTERNATIVE_ZONE                -> 
//      ALTERNATIVE_AMOUNT_VALUE        -> 
//      ALTERNATIVE_AMOUNT_CURRENCY       -> 
//      ALTERNATIVE_CHARGED_ITEM          -> 
//      ALTERNATIVE_CHARGED_TAX_TREATMENT -> 
//      ALTERNATIVE_TAX_RATE              -> 
//      BALANCE_AMOUNT_VALUE              -> 
//      BALANCE_AMOUNT_CURRENCY           -> 
//      BALANCE_CHARGED_ITEM              -> 
//      BALANCE_CHARGED_TAX_TREATMENT     -> 
//      BALANCE_TAX_RATE                  -> 
      TARIFF_CLASS                      -> DETAIL.TARIFF_CLASS;
      TARIFF_SUB_CLASS                  -> DETAIL.TARIFF_SUB_CLASS;
      CALL_CLASS                        -> DETAIL.USAGE_CLASS;
      CALL_CLASS                        -> DETAIL.INTERN_USAGE_CLASS;
      CALL_TYPE                         -> DETAIL.USAGE_TYPE;
      BILLCYCLE_PERIOD                  -> DETAIL.BILLCYCLE_PERIOD;
      NUMBER_ASSOCIATED_RECORDS         -> DETAIL.NUMBER_ASSOCIATED_RECORDS;
      "*"                               -> DETAIL.INTERN_SERVICE_CLASS;
    }

    V430_GSMW_MAPPING
    {
      "520"                            -> DETAIL.ASS_GSMW_EXT.RECORD_TYPE;
      //                               -> DETAIL.ASS_GSMW_EXT.RECORD_NUMBER;
      PORT_NUMBER                      -> DETAIL.ASS_GSMW_EXT.PORT_NUMBER;
      DEVICE_NUMBER                    -> DETAIL.ASS_GSMW_EXT.DEVICE_NUMBER;
      //                               -> DETAIL.ASS_GSMW_EXT.A_NUMBER_USER;
      //                               -> DETAIL.ASS_GSMW_EXT.DIALED_DIGITS;
      //                               -> DETAIL.ASS_GSMW_EXT.BASIC_DUAL_SERVICE;
      //                               -> DETAIL.ASS_GSMW_EXT.VAS_PRODUCT_CODE;
      SWITCH_IDENTIFICATION            -> DETAIL.ASS_GSMW_EXT.ORIGINATING_SWITCH_IDENTIFICATION;
      SWITCH_IDENTIFICATION            -> DETAIL.ASS_GSMW_EXT.TERMINATING_SWITCH_IDENTIFICATION;
      TRUNC_INPUT                      -> DETAIL.ASS_GSMW_EXT.TRUNK_INPUT;
      TRUNC_OUTPUT                     -> DETAIL.ASS_GSMW_EXT.TRUNK_OUTPUT;
      LOCATION_AREA_INDICATOR          -> DETAIL.ASS_GSMW_EXT.LOCATION_AREA_INDICATOR;
      CELL_ID                          -> DETAIL.ASS_GSMW_EXT.CELL_ID;
      MS_CLASS_MARK                    -> DETAIL.ASS_GSMW_EXT.MS_CLASS_MARK;
      //                               -> DETAIL.ASS_GSMW_EXT.TIME_BEFORE_ANSWER;
      //                               -> DETAIL.ASS_GSMW_EXT.BASIC_AOC_AMOUNT_VALUE;
      //                               -> DETAIL.ASS_GSMW_EXT.BASIC_AOC_AMOUNT_CURRENCY;
      //                               -> DETAIL.ASS_GSMW_EXT.ROAMER_AOC_AMOUNT_VALUE;
      //                               -> DETAIL.ASS_GSMW_EXT.ROAMER_AOC_AMOUNT_CURRENCY;
      //                               -> DETAIL.ASS_GSMW_EXT.NUMBER_OF_SS_PACKETS;
    }

    //--------------------------------------------------------------------------
    // Mapping for V4.11 GPRS records to V4.30
    //--------------------------------------------------------------------------
    V430_GPRS_MAPPING
    {
       "540"                            -> DETAIL.ASS_GPRS_EXT.RECORD_TYPE;
       PORT_NUMBER                      -> DETAIL.ASS_GPRS_EXT.PORT_NUMBER;
       DEVICE_NUMBER                    -> DETAIL.ASS_GPRS_EXT.DEVICE_NUMBER;
       //                                  DETAIL.ASS_GPRS_EXT.VAS_PRODUCT_CODE
       SWITCH_IDENTIFICATION            -> DETAIL.ASS_GPRS_EXT.ORIGINATING_SWITCH_IDENTIFICATION;
       SWITCH_IDENTIFICATION            -> DETAIL.ASS_GPRS_EXT.TERMINATING_SWITCH_IDENTIFICATION;
       MS_CLASS_MARK                    -> DETAIL.ASS_GPRS_EXT.MS_CLASS_MARK;
       //                               -> DETAIL.ASS_GPRS_EXT.ROUTING_AREA;
       //                               -> DETAIL.ASS.GPRS_EXT.LOCATION_AREA_INDICATOR;
       //                               -> DETAIL.ASS.GPRS_EXT.CHARGING_ID;
       //                               -> DETAIL.ASS.GPRS_EXT.SGSN_ADDRESS;
       //                               -> DETAIL.ASS.GPRS_EXT.GGSN_ADDRESS;
       //                               -> DETAIL.ASS.GPRS_EXT.APN_ADDRESS;
       //                               -> DETAIL.ASS.GPRS_EXT.NODE_ID;
       //                               -> DETAIL.ASS.GPRS_EXT.TRANS_ID;
       //                               -> DETAIL.ASS.GPRS_EXT.SUB_TRANS_ID;
       //                               -> DETAIL.ASS.GPRS_EXT.NETWORK_INITIATED_PDP;
       //                               -> DETAIL.ASS.GPRS_EXT.PDP_TYPE;
       //                               -> DETAIL.ASS.GPRS_EXT.PDP_ADDRESS;
       //                               -> DETAIL.ASS.GPRS_EXT.PDP_REMOTE_ADDRESS;
       //                               -> DETAIL.ASS.GPRS_EXT.PDP_DYNAMIC_ADDRESS;
       //                               -> DETAIL.ASS.GPRS_EXT.DIAGNOSTICS;
       //                               -> DETAIL.ASS.GPRS_EXT.CELL_ID;
       //                               -> DETAIL.ASS.GPRS_EXT.CHANGE_CONDITION;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_REQUESTED_PRECEDENCE;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_REQUESTED_DELAY;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_REQUESTED_RELIABILITY;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_REQUESTED_PEAK_THROUGHPUT;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_REQUESTED_MEAN_THROUGHPUT;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_USED_PRECEDENCE;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_USED_DELAY;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_USED_RELIABILITY;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_USED_PEAK_THROUGHPUT;
       //                               -> DETAIL.ASS.GPRS_EXT.QOS_USED_MEAN_THROUGHPUT;
    }
  }

  //----------------------------------------------------------------------------
  // Associated zone record
  //----------------------------------------------------------------------------
  ASSOCIATED_ZONE
  {
    STD_MAPPING
    {
      RECORD_TYPE                        -> DETAIL.ASS_ZBD.RECORD_TYPE;
      RECORD_NUMBER                      -> DETAIL.ASS_ZBD.RECORD_NUMBER;
      CONTRACT_CODE                      -> DETAIL.ASS_ZBD.CONTRACT_CODE;
      SEGMENT_CODE                       -> DETAIL.ASS_ZBD.SEGMENT_CODE;
      CUSTOMER_CODE                      -> DETAIL.ASS_ZBD.CUSTOMER_CODE;
      ACCOUNT_CODE                       -> DETAIL.ASS_ZBD.ACCOUNT_CODE;
      SYSTEM_BRAND_CODE                  -> DETAIL.ASS_ZBD.SYSTEM_BRAND_CODE;
      SERVICE_CODE_USED                  -> DETAIL.ASS_ZBD.SERVICE_CODE;
      RATEPLAN_CODE                      -> DETAIL.ASS_ZBD.CUSTOMER_RATEPLAN_CODE;
      SLA_CODE                           -> DETAIL.ASS_ZBD.SLA_CODE;
      CUSTOMER_BILLCYCLE                 -> DETAIL.ASS_ZBD.CUSTOMER_BILLCYCLE;
      CUSTOMER_CURRENCY                  -> DETAIL.ASS_ZBD.CUSTOMER_CURRENCY;
      CUSTOMER_TAXGROUP                  -> DETAIL.ASS_ZBD.CUSTOMER_TAXGROUP;
      NUMBER_OF_ZONE_PACKETS             -> DETAIL.ASS_ZBD.NUMBER_OF_ZONE_PACKETS;
    }
  }
   
  //----------------------------------------------------------------------------
  // Zone packet record
  //----------------------------------------------------------------------------
  ZONE_PACKET
  {
    STD_MAPPING
    {
      ZONEMODEL_CODE                     -> DETAIL.ASS_ZBD.ZP.ZONEMODEL_CODE;
      ZONE_RESULT_VALUE_WHOLESALE        -> DETAIL.ASS_ZBD.ZP.ZONE_RESULT_VALUE_WS;
      ZONE_RESULT_VALUE_RETAIL           -> DETAIL.ASS_ZBD.ZP.ZONE_RESULT_VALUE_RT;
      DISTANCE                           -> DETAIL.ASS_ZBD.ZP.DISTANCE;
    }
  }
    
  //----------------------------------------------------------------------------
  // Associated charge record
  //----------------------------------------------------------------------------
  ASSOCIATED_CHARGE
  {
    STD_MAPPING
    {
      RECORD_TYPE                        -> DETAIL.ASS_CBD.RECORD_TYPE;
      RECORD_NUMBER                      -> DETAIL.ASS_CBD.RECORD_NUMBER;
      CONTRACT_CODE                      -> DETAIL.ASS_CBD.CONTRACT_CODE;
      SEGMENT_CODE                       -> DETAIL.ASS_CBD.SEGMENT_CODE;
      CUSTOMER_CODE                      -> DETAIL.ASS_CBD.CUSTOMER_CODE;
      ACCOUNT_CODE                       -> DETAIL.ASS_CBD.ACCOUNT_CODE;
      SYSTEM_BRAND_CODE                  -> DETAIL.ASS_CBD.SYSTEM_BRAND_CODE;
      SERVICE_CODE_USED                  -> DETAIL.ASS_CBD.SERVICE_CODE;
      RATEPLAN_CODE                      -> DETAIL.ASS_CBD.CUSTOMER_RATEPLAN_CODE;
      SLA_CODE                           -> DETAIL.ASS_CBD.SLA_CODE;
      CUSTOMER_BILLCYCLE                 -> DETAIL.ASS_CBD.CUSTOMER_BILLCYCLE;
      CUSTOMER_CURRENCY                  -> DETAIL.ASS_CBD.CUSTOMER_CURRENCY;
      CUSTOMER_TAXGROUP                  -> DETAIL.ASS_CBD.CUSTOMER_TAXGROUP;
      NUMBER_OF_CHARGE_PACKETS           -> DETAIL.ASS_CBD.NUMBER_OF_CHARGE_PACKETS;
    }

    V430_MAPPING
    {
      RECORD_TYPE                        -> DETAIL.ASS_CBD.RECORD_TYPE;
      RECORD_NUMBER                      -> DETAIL.ASS_CBD.RECORD_NUMBER;
      CONTRACT_CODE                      -> DETAIL.ASS_CBD.CONTRACT_CODE;
      SEGMENT_CODE                       -> DETAIL.ASS_CBD.SEGMENT_CODE;
      CUSTOMER_CODE                      -> DETAIL.ASS_CBD.CUSTOMER_CODE;
      ACCOUNT_CODE                       -> DETAIL.ASS_CBD.ACCOUNT_CODE;
      SYSTEM_BRAND_CODE                  -> DETAIL.ASS_CBD.SYSTEM_BRAND_CODE;
      SERVICE_CODE_USED                  -> DETAIL.ASS_CBD.SERVICE_CODE;
      RATEPLAN_CODE                      -> DETAIL.ASS_CBD.CUSTOMER_RATEPLAN_CODE;
      SLA_CODE                           -> DETAIL.ASS_CBD.SLA_CODE;
      CUSTOMER_BILLCYCLE                 -> DETAIL.ASS_CBD.CUSTOMER_BILLCYCLE;
      CUSTOMER_CURRENCY                  -> DETAIL.ASS_CBD.CUSTOMER_CURRENCY;
      CUSTOMER_TAXGROUP                  -> DETAIL.ASS_CBD.CUSTOMER_TAXGROUP;
      NUMBER_OF_CHARGE_PACKETS           -> DETAIL.ASS_CBD.NUMBER_OF_CHARGE_PACKETS;
    }
  }

  //----------------------------------------------------------------------------
  // Charge packet record
  //----------------------------------------------------------------------------
  CHARGE_PACKET
  {
    STD_MAPPING
    {
      ZONEMODEL_CODE                     -> DETAIL.ASS_CBD.CP.ZONEMODEL_CODE;
      ZONE_RESULT_VALUE                  -> DETAIL.ASS_CBD.CP.IMPACT_CATEGORY;
      DISTANCE                           -> DETAIL.ASS_CBD.CP.DISTANCE;
      TARIFFMODEL_CODE                   -> DETAIL.ASS_CBD.CP.RATEPLAN_CODE;
      TARIFFMODEL_TYPE                   -> DETAIL.ASS_CBD.CP.RATEPLAN_TYPE;
      TIMEMODEL_CODE                     -> DETAIL.ASS_CBD.CP.TIMEMODEL_CODE;
      TIMEZONE_CODE                      -> DETAIL.ASS_CBD.CP.TIMEZONE_CODE;
      DAYCODE                            -> DETAIL.ASS_CBD.CP.DAY_CODE;
      TIME_INTERVAL                      -> DETAIL.ASS_CBD.CP.TIME_INTERVAL_CODE;
      PRICEMODEL_TYPE                    -> DETAIL.ASS_CBD.CP.PRICEMODEL_TYPE;
      PRICEMODEL_CODE                    -> DETAIL.ASS_CBD.CP.PRICEMODEL_CODE;
//      PRICEMODEL_ITEM                    -> 
      TARIFF_SERVICE_CODE_USED           -> DETAIL.ASS_CBD.CP.SERVICE_CODE_USED;
      TARIFF_SERVICE_CLASS_USED          -> DETAIL.ASS_CBD.CP.SERVICE_CLASS_USED;
      NETWORK_OPERATOR                   -> DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_CODE;
      NETWORK_OPERATOR_BILLINGTYPE       -> DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_BILLINGTYPE;
      CHARGE_TYPE                        -> DETAIL.ASS_CBD.CP.CHARGE_TYPE;
//      CHARGE_ITEM                        -> 
      TRUNK_USED                         -> DETAIL.ASS_CBD.CP.TRUNK_USED;
      PRODUCTCODE_USED                   -> DETAIL.ASS_CBD.CP.PRODUCTCODE_USED;
      CHARGING_START_TIMESTAMP           -> DETAIL.ASS_CBD.CP.CHARGING_START_TIMESTAMP;
      ROUNDED_CHARGED_QUANTITY_VALUE     -> DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_VALUE;
      CHARGEABLE_QUANTITY_UOM            -> DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_UOM;
//      ROUNDED_VOLUME_SENT                -> 
//      VOLUME_SENT_UOM                    -> 
//      ROUNDED_VOLUME_RECEIVED            -> 
//      VOLUME_RECEIVED_UOM                -> 
      CHARGED_AMOUNT_VALUE               -> DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_VALUE;
      CHARGED_AMOUNT_CURRENCY            -> DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_CURRENCY;
      CHARGED_TAX_TREATMENT              -> DETAIL.ASS_CBD.CP.CHARGED_TAX_TREATMENT;
      CHARGED_TAX_RATE                   -> DETAIL.ASS_CBD.CP.CHARGED_TAX_RATE;
      CHARGED_TAX_CODE                   -> DETAIL.ASS_CBD.CP.CHARGED_TAX_CODE;
      USAGE_GL_ACCOUNT_CODE               -> DETAIL.ASS_CBD.CP.USAGE_GL_ACCOUNT_CODE;
      REVENUE_GROUP_CODE                 -> DETAIL.ASS_CBD.CP.REVENUE_GROUP_CODE;
      DISCOUNTMODEL_CODE                 -> DETAIL.ASS_CBD.CP.DISCOUNTMODEL_CODE;
      GRANTED_DISCOUNT_AMOUNT_VALUE      -> DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_AMOUNT_VALUE;
      GRANTED_DISCOUNT_QUANTITY_VALUE    -> DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_VALUE;
      GRANTED_DISCOUNT_QUANTITY_VALUE_UOM-> DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_UOM;
//      GRANTED_DISCOUNT_VOLUME_SENT       -> 
//      GRANTED_DISCOUNT_VOLUME_SENT_UOM   -> 
//      GRANTED_DISCOUNT_VOLUME_RECEIVED   -> 
//      GRANTED_DISCOUNT_VOLUME_RECEIVED_UOM -> 
    }

    V430_MAPPING
    {
      ZONEMODEL_CODE                     -> DETAIL.ASS_CBD.CP.ZONEMODEL_CODE;
      ZONE_RESULT_VALUE                  -> DETAIL.ASS_CBD.CP.IMPACT_CATEGORY;
      DISTANCE                           -> DETAIL.ASS_CBD.CP.DISTANCE;
      TARIFFMODEL_CODE                   -> DETAIL.ASS_CBD.CP.RATEPLAN_CODE;
      TARIFFMODEL_TYPE                   -> DETAIL.ASS_CBD.CP.RATEPLAN_TYPE;
      TIMEMODEL_CODE                     -> DETAIL.ASS_CBD.CP.TIMEMODEL_CODE;
      TIMEZONE_CODE                      -> DETAIL.ASS_CBD.CP.TIMEZONE_CODE;
      DAYCODE                            -> DETAIL.ASS_CBD.CP.DAY_CODE;
      TIME_INTERVAL                      -> DETAIL.ASS_CBD.CP.TIME_INTERVAL_CODE;
      PRICEMODEL_TYPE                    -> DETAIL.ASS_CBD.CP.PRICEMODEL_TYPE;
      PRICEMODEL_CODE                    -> DETAIL.ASS_CBD.CP.PRICEMODEL_CODE;
//      PRICEMODEL_ITEM                    -> 
      TARIFF_SERVICE_CODE_USED           -> DETAIL.ASS_CBD.CP.SERVICE_CODE_USED;
      TARIFF_SERVICE_CLASS_USED          -> DETAIL.ASS_CBD.CP.SERVICE_CLASS_USED;
      NETWORK_OPERATOR                   -> DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_CODE;
      NETWORK_OPERATOR_BILLINGTYPE       -> DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_BILLINGTYPE;
      CHARGE_TYPE                        -> DETAIL.ASS_CBD.CP.CHARGE_TYPE;
//      CHARGE_ITEM                        -> 
      TRUNK_USED                         -> DETAIL.ASS_CBD.CP.TRUNK_USED;
      PRODUCTCODE_USED                   -> DETAIL.ASS_CBD.CP.PRODUCTCODE_USED;
      CHARGING_START_TIMESTAMP           -> DETAIL.ASS_CBD.CP.CHARGING_START_TIMESTAMP;
      ROUNDED_CHARGED_QUANTITY_VALUE     -> DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_VALUE;
      CHARGEABLE_QUANTITY_UOM            -> DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_UOM;
//      ROUNDED_VOLUME_SENT                -> 
//      VOLUME_SENT_UOM                    -> 
//      ROUNDED_VOLUME_RECEIVED            -> 
//      VOLUME_RECEIVED_UOM                -> 
      CHARGED_AMOUNT_VALUE               -> DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_VALUE;
      CHARGED_AMOUNT_CURRENCY            -> DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_CURRENCY;
      CHARGED_TAX_TREATMENT              -> DETAIL.ASS_CBD.CP.CHARGED_TAX_TREATMENT;
      CHARGED_TAX_RATE                   -> DETAIL.ASS_CBD.CP.CHARGED_TAX_RATE;
      CHARGED_TAX_CODE                   -> DETAIL.ASS_CBD.CP.CHARGED_TAX_CODE;
      USAGE_GL_ACCOUNT_CODE              -> DETAIL.ASS_CBD.CP.USAGE_GL_ACCOUNT_CODE;
      REVENUE_GROUP_CODE                 -> DETAIL.ASS_CBD.CP.REVENUE_GROUP_CODE;
      DISCOUNTMODEL_CODE                 -> DETAIL.ASS_CBD.CP.DISCOUNTMODEL_CODE;
      GRANTED_DISCOUNT_AMOUNT_VALUE      -> DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_AMOUNT_VALUE;
      GRANTED_DISCOUNT_QUANTITY_VALUE    -> DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_VALUE;
      GRANTED_DISCOUNT_QUANTITY_VALUE_UOM-> DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_UOM;
//      GRANTED_DISCOUNT_VOLUME_SENT       -> 
//      GRANTED_DISCOUNT_VOLUME_SENT_UOM   -> 
//      GRANTED_DISCOUNT_VOLUME_RECEIVED   -> 
//      GRANTED_DISCOUNT_VOLUME_RECEIVED_UOM -> 
    }
  }

  //----------------------------------------------------------------------------
  // Trailer record
  //----------------------------------------------------------------------------
  TRAILER
  {
    STD_MAPPING
    {
      RECORD_TYPE                      -> TRAILER.RECORD_TYPE;
      RECORD_NUMBER                    -> TRAILER.RECORD_NUMBER;
      SENDER                           -> TRAILER.SENDER;
      RECIPIENT                        -> TRAILER.RECIPIENT;
      FILE_SEQUENCE_NUMBER             -> TRAILER.SEQUENCE_NUMBER;
      ORIGIN_FILE_SEQUENCE_NUMBER      -> TRAILER.ORIGIN_SEQUENCE_NUMBER;
      TOTAL_NUMBER_OF_RECORDS          -> TRAILER.TOTAL_NUMBER_OF_RECORDS;
      FIRST_CALL_TIMESTAMP             -> TRAILER.FIRST_START_TIMESTAMP;
      LAST_CALL_TIMESTAMP              -> TRAILER.LAST_START_TIMESTAMP;
      TOTAL_CHARGED_VALUE              -> TRAILER.TOTAL_RETAIL_CHARGED_VALUE;
      TOTAL_AOC_AMOUNT_VALUE           -> TRAILER.TOTAL_WHOLESALE_CHARGED_VALUE;
//     TOTAL_ALTERNATIVE_AMOUNT_VALUE   -> 
    }

    V430_MAPPING
    {
      RECORD_TYPE                      -> TRAILER.RECORD_TYPE;
      RECORD_NUMBER                    -> TRAILER.RECORD_NUMBER;
      SENDER                           -> TRAILER.SENDER;
      RECIPIENT                        -> TRAILER.RECIPIENT;
      FILE_SEQUENCE_NUMBER             -> TRAILER.SEQUENCE_NUMBER;
      ORIGIN_FILE_SEQUENCE_NUMBER      -> TRAILER.ORIGIN_SEQUENCE_NUMBER;
      TOTAL_NUMBER_OF_RECORDS          -> TRAILER.TOTAL_NUMBER_OF_RECORDS;
      FIRST_CALL_TIMESTAMP             -> TRAILER.FIRST_START_TIMESTAMP;
      LAST_CALL_TIMESTAMP              -> TRAILER.LAST_START_TIMESTAMP;
      TOTAL_CHARGED_VALUE              -> TRAILER.TOTAL_RETAIL_CHARGED_VALUE;
      TOTAL_AOC_AMOUNT_VALUE           -> TRAILER.TOTAL_WHOLESALE_CHARGED_VALUE;
//     TOTAL_ALTERNATIVE_AMOUNT_VALUE   -> 
    }
  }
}

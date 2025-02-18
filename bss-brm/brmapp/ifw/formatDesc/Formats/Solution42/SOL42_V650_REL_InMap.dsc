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
//   Input mapping for the Solution42 V6.30 REL CDR format with Unix timestamps
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
// $RCSfile: SOL42_V430_REL_InMap.dsc,v $
// $Revision: 1.3 $
// $Author: pengelbr $
// $Date: 2001/10/01 06:54:55 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V430_REL_InMap.dsc,v $
//==============================================================================

SOL42_V650_REL_FORINPUT
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

// RA Changes - Start

      BATCH_ID                     -> HEADER.BATCH_ID;

// RA Changes - End

      SENDER                       -> HEADER.SENDER;
      RECIPIENT                    -> HEADER.RECIPIENT;
      SEQUENCE_NUMBER              -> HEADER.SEQUENCE_NUMBER;
      ORIGIN_SEQUENCE_NUMBER       -> HEADER.ORIGIN_SEQUENCE_NUMBER;
      CREATION_TIMESTAMP           -> HEADER.CREATION_TIMESTAMP;
      TRANSMISSION_DATE            -> HEADER.TRANSMISSION_DATE;
      TRANSFER_CUTOFF_TIMESTAMP    -> HEADER.TRANSFER_CUTOFF_TIMESTAMP;
      UTC_TIME_OFFSET              -> HEADER.UTC_TIME_OFFSET;
      SPECIFICATION_VERSION_NUMBER -> HEADER.SPECIFICATION_VERSION_NUMBER;
      RELEASE_VERSION              -> HEADER.RELEASE_VERSION;
      ORIGIN_COUNTRY_CODE          -> HEADER.ORIGIN_COUNTRY_CODE;   
      SENDER_COUNTRY_CODE          -> HEADER.SENDER_COUNTRY_CODE;
      DATA_TYPE_INDICATOR          -> HEADER.DATA_TYPE_INDICATOR;
      IAC_LIST                     -> HEADER.IAC_LIST;
      CC_LIST                      -> HEADER.CC_LIST;
    }
  }
    
  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL
  {
    STD_MAPPING
    {
      RECORD_TYPE                 -> DETAIL.RECORD_TYPE;        
      RECORD_NUMBER               -> DETAIL.RECORD_NUMBER;        

// RA Changes - Start

      EVENT_ID                    -> DETAIL.EVENT_ID;
      BATCH_ID                    -> DETAIL.BATCH_ID;
      ORIGINAL_BATCH_ID           -> DETAIL.ORIGINAL_BATCH_ID;

// RA Changes - End

      DISCARDING                  -> DETAIL.DISCARDING;        
      CHAIN_REFERENCE             -> DETAIL.CHAIN_REFERENCE;        
      SOURCE_NETWORK_TYPE         -> DETAIL.SOURCE_NETWORK_TYPE;        
      SOURCE_NETWORK              -> DETAIL.SOURCE_NETWORK;        
      DESTINATION_NETWORK_TYPE    -> DETAIL.DESTINATION_NETWORK_TYPE;        
      DESTINATION_NETWORK         -> DETAIL.DESTINATION_NETWORK;        
      TYPE_OF_A_IDENTIFICATION    -> DETAIL.TYPE_OF_A_IDENTIFICATION;        
      A_MODIFICATION_INDICATOR    -> DETAIL.A_MODIFICATION_INDICATOR;
      A_TYPE_OF_NUMBER            -> DETAIL.A_TYPE_OF_NUMBER;
      A_NUMBERING_PLAN            -> DETAIL.A_NUMBERING_PLAN;
      A_NUMBER                    -> DETAIL.A_NUMBER;
      A_NUMBER                    -> DETAIL.INTERN_A_NUMBER_ZONE;
      B_MODIFICATION_INDICATOR    -> DETAIL.B_MODIFICATION_INDICATOR;        
      B_TYPE_OF_NUMBER            -> DETAIL.B_TYPE_OF_NUMBER;        
      B_NUMBERING_PLAN            -> DETAIL.B_NUMBERING_PLAN;        
      B_NUMBER                    -> DETAIL.B_NUMBER;
      B_NUMBER                    -> DETAIL.INTERN_B_NUMBER_ZONE;
      DESCRIPTION                 -> DETAIL.DESCRIPTION;        
      C_MODIFICATION_INDICATOR    -> DETAIL.C_MODIFICATION_INDICATOR;        
      C_TYPE_OF_NUMBER            -> DETAIL.C_TYPE_OF_NUMBER;        
      C_NUMBERING_PLAN            -> DETAIL.C_NUMBERING_PLAN;        
      C_NUMBER                    -> DETAIL.C_NUMBER;        
      C_NUMBER                    -> DETAIL.INTERN_C_NUMBER_ZONE;
      USAGE_DIRECTION             -> DETAIL.USAGE_DIRECTION;        
      CONNECT_TYPE                -> DETAIL.CONNECT_TYPE;        
      CONNECT_SUB_TYPE            -> DETAIL.CONNECT_SUB_TYPE;        
      BASIC_SERVICE               -> DETAIL.BASIC_SERVICE;        
      BASIC_SERVICE               -> DETAIL.INTERN_SERVICE_CODE;
      QOS_REQUESTED               -> DETAIL.QOS_REQUESTED;        
      QOS_USED                    -> DETAIL.QOS_USED;        
      CALL_COMPLETION_INDICATOR   -> DETAIL.CALL_COMPLETION_INDICATOR;        
      LONG_DURATION_INDICATOR     -> DETAIL.LONG_DURATION_INDICATOR;        
      CHARGING_START_TIMESTAMP    -> DETAIL.CHARGING_START_TIMESTAMP;        
      CHARGING_END_TIMESTAMP      -> DETAIL.CHARGING_END_TIMESTAMP;        
      UTC_TIME_OFFSET             -> DETAIL.UTC_TIME_OFFSET;        
      DURATION                    -> DETAIL.DURATION;        
      DURATION_UOM                -> DETAIL.DURATION_UOM;        
      VOLUME_SENT                 -> DETAIL.VOLUME_SENT;        
      VOLUME_SENT_UOM             -> DETAIL.VOLUME_SENT_UOM;        
      VOLUME_RECEIVED             -> DETAIL.VOLUME_RECEIVED;        
      VOLUME_RECEIVED_UOM         -> DETAIL.VOLUME_RECEIVED_UOM;        
      NUMBER_OF_UNITS             -> DETAIL.NUMBER_OF_UNITS;        
      NUMBER_OF_UNITS_UOM         -> DETAIL.NUMBER_OF_UNITS_UOM;        
      RETAIL_IMPACT_CATEGORY      -> DETAIL.RETAIL_IMPACT_CATEGORY;        
      RETAIL_CHARGED_AMOUNT_VALUE -> DETAIL.RETAIL_CHARGED_AMOUNT_VALUE;        
      RETAIL_CHARGED_AMOUNT_CURRENCY -> DETAIL.RETAIL_CHARGED_AMOUNT_CURRENCY;
      RETAIL_CHARGED_TAX_TREATMENT-> DETAIL.RETAIL_CHARGED_TAX_TREATMENT;
      RETAIL_CHARGED_TAX_RATE     -> DETAIL.RETAIL_CHARGED_TAX_RATE;        
      WHOLESALE_IMPACT_CATEGORY   -> DETAIL.WHOLESALE_IMPACT_CATEGORY;        
      WHOLESALE_CHARGED_AMOUNT_VALUE-> DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE; 
      WHOLESALE_CHARGED_AMOUNT_CURRENCY -> DETAIL.WHOLESALE_CHARGED_AMOUNT_CURRENCY;
      WHOLESALE_CHARGED_TAX_TREATMENT -> DETAIL.WHOLESALE_CHARGED_TAX_TREATMENT;
      WHOLESALE_CHARGED_TAX_RATE  -> DETAIL.WHOLESALE_CHARGED_TAX_RATE;        
      TARIFF_CLASS                -> DETAIL.TARIFF_CLASS;        
      TARIFF_SUB_CLASS            -> DETAIL.TARIFF_SUB_CLASS;        
      USAGE_CLASS                 -> DETAIL.USAGE_CLASS;        
      USAGE_TYPE                  -> DETAIL.USAGE_TYPE;        
      BILLCYCLE_PERIOD            -> DETAIL.BILLCYCLE_PERIOD;
      PREPAID_INDICATOR           -> DETAIL.PREPAID_INDICATOR;
      NUMBER_ASSOCIATED_RECORDS   -> DETAIL.NUMBER_ASSOCIATED_RECORDS;
      "*"                         -> DETAIL.INTERN_SERVICE_CLASS;
    }
  }

  //----------------------------------------------------------------------------
  // Associated GPRS records
  //----------------------------------------------------------------------------
  ASSOCIATED_GPRS
  {
    STD_MAPPING
    {
      RECORD_TYPE                 -> DETAIL.ASS_GPRS_EXT.RECORD_TYPE;
      RECORD_NUMBER               -> DETAIL.ASS_GPRS_EXT.RECORD_NUMBER;
      PORT_NUMBER                 -> DETAIL.ASS_GPRS_EXT.PORT_NUMBER;
      DEVICE_NUMBER               -> DETAIL.ASS_GPRS_EXT.DEVICE_NUMBER;
      A_NUMBER_USER               -> DETAIL.ASS_GPRS_EXT.A_NUMBER_USER;
      DIALED_DIGITS               -> DETAIL.ASS_GPRS_EXT.DIALED_DIGITS;
      PRODUCT_CODE                -> DETAIL.ASS_GPRS_EXT.VAS_PRODUCT_CODE;
      ORIGINATING_SWITCH_IDENTIFICATION -> DETAIL.ASS_GPRS_EXT.ORIGINATING_SWITCH_IDENTIFICATION;
      TERMINATING_SWITCH_IDENTIFICATION -> DETAIL.ASS_GPRS_EXT.TERMINATING_SWITCH_IDENTIFICATION;
      MS_CLASS_MARK               -> DETAIL.ASS_GPRS_EXT.MS_CLASS_MARK;
      ROUTING_AREA                -> DETAIL.ASS_GPRS_EXT.ROUTING_AREA;
      LOCATION_AREA_INDICATOR     -> DETAIL.ASS_GPRS_EXT.LOCATION_AREA_INDICATOR;
      CHARGING_ID                 -> DETAIL.ASS_GPRS_EXT.CHARGING_ID;
      SGSN_ADDRESS                -> DETAIL.ASS_GPRS_EXT.SGSN_ADDRESS;
      GGSN_ADDRESS                -> DETAIL.ASS_GPRS_EXT.GGSN_ADDRESS;
      APN_ADDRESS                 -> DETAIL.ASS_GPRS_EXT.APN_ADDRESS;
      NODE_ID                     -> DETAIL.ASS_GPRS_EXT.NODE_ID;
      TRANS_ID                    -> DETAIL.ASS_GPRS_EXT.TRANS_ID;
      SUB_TRANS_ID                -> DETAIL.ASS_GPRS_EXT.SUB_TRANS_ID;
      NETWORK_INITIATED_PDP       -> DETAIL.ASS_GPRS_EXT.NETWORK_INITIATED_PDP;
      PDP_TYPE                    -> DETAIL.ASS_GPRS_EXT.PDP_TYPE;
      PDP_ADDRESS                 -> DETAIL.ASS_GPRS_EXT.PDP_ADDRESS;
      PDP_REMOTE_ADDRESS          -> DETAIL.ASS_GPRS_EXT.PDP_REMOTE_ADDRESS;
      PDP_DYNAMIC_ADDRESS         -> DETAIL.ASS_GPRS_EXT.PDP_DYNAMIC_ADDRESS;
      DIAGNOSTICS                 -> DETAIL.ASS_GPRS_EXT.DIAGNOSTICS;
      CELL_ID                     -> DETAIL.ASS_GPRS_EXT.CELL_ID;
      CHANGE_CONDITION            -> DETAIL.ASS_GPRS_EXT.CHANGE_CONDITION;
      QOS_REQUESTED_PRECEDENCE    -> DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_PRECEDENCE;
      QOS_REQUESTED_DELAY         -> DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_DELAY;
      QOS_REQUESTED_RELIABILITY   -> DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_RELIABILITY;
      QOS_REQUESTED_PEAK_THROUGHPUT -> DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_PEAK_THROUGHPUT;
      QOS_REQUESTED_MEAN_THROUGHPUT -> DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_MEAN_THROUGHPUT;
      QOS_USED_PRECEDENCE         -> DETAIL.ASS_GPRS_EXT.QOS_USED_PRECEDENCE;
      QOS_USED_DELAY              -> DETAIL.ASS_GPRS_EXT.QOS_USED_DELAY;
      QOS_USED_RELIABILITY        -> DETAIL.ASS_GPRS_EXT.QOS_USED_RELIABILITY;
      QOS_USED_PEAK_THROUGHPUT    -> DETAIL.ASS_GPRS_EXT.QOS_USED_PEAK_THROUGHPUT;
      QOS_USED_MEAN_THROUGHPUT    -> DETAIL.ASS_GPRS_EXT.QOS_USED_MEAN_THROUGHPUT;
      NETWORK_CAPABILITY          -> DETAIL.ASS_GPRS_EXT.NETWORK_CAPABILITY;
      SGSN_CHANGE                 -> DETAIL.ASS_GPRS_EXT.SGSN_CHANGE;
    }
  }

  //----------------------------------------------------------------------------
  // Associated GSMW record
  //----------------------------------------------------------------------------
  ASSOCIATED_GSMW
  {
    STD_MAPPING
    {
      RECORD_TYPE                 -> DETAIL.ASS_GSMW_EXT.RECORD_TYPE;
      RECORD_NUMBER               -> DETAIL.ASS_GSMW_EXT.RECORD_NUMBER;
      PORT_NUMBER                 -> DETAIL.ASS_GSMW_EXT.PORT_NUMBER;
      DEVICE_NUMBER               -> DETAIL.ASS_GSMW_EXT.DEVICE_NUMBER;
      A_NUMBER_USER               -> DETAIL.ASS_GSMW_EXT.A_NUMBER_USER;
      DIALED_DIGITS               -> DETAIL.ASS_GSMW_EXT.DIALED_DIGITS;
      BASIC_DUAL_SERVICE          -> DETAIL.ASS_GSMW_EXT.BASIC_DUAL_SERVICE;
      PRODUCT_CODE                -> DETAIL.ASS_GSMW_EXT.VAS_PRODUCT_CODE;
      ORIGINATING_SWITCH_IDENTIFICATION -> DETAIL.ASS_GSMW_EXT.ORIGINATING_SWITCH_IDENTIFICATION;
      TERMINATING_SWITCH_IDENTIFICATION -> DETAIL.ASS_GSMW_EXT.TERMINATING_SWITCH_IDENTIFICATION;
      TRUNK_INPUT                 -> DETAIL.ASS_GSMW_EXT.TRUNK_INPUT;
      TRUNK_OUTPUT                -> DETAIL.ASS_GSMW_EXT.TRUNK_OUTPUT;
      LOCATION_AREA_INDICATOR     -> DETAIL.ASS_GSMW_EXT.LOCATION_AREA_INDICATOR;
      CELL_ID                     -> DETAIL.ASS_GSMW_EXT.CELL_ID;
      MS_CLASS_MARK               -> DETAIL.ASS_GSMW_EXT.MS_CLASS_MARK;
      TIME_BEFORE_ANSWER          -> DETAIL.ASS_GSMW_EXT.TIME_BEFORE_ANSWER;
      BASIC_AOC_AMOUNT_VALUE      -> DETAIL.ASS_GSMW_EXT.BASIC_AOC_AMOUNT_VALUE;
      BASIC_AOC_AMOUNT_CURRENCY   -> DETAIL.ASS_GSMW_EXT.BASIC_AOC_AMOUNT_CURRENCY;
      ROAMER_AOC_AMOUNT_VALUE     -> DETAIL.ASS_GSMW_EXT.ROAMER_AOC_AMOUNT_VALUE;
      ROAMER_AOC_AMOUNT_CURRENCY  -> DETAIL.ASS_GSMW_EXT.ROAMER_AOC_AMOUNT_CURRENCY;
      NUMBER_OF_SS_EVENT_PACKETS  -> DETAIL.ASS_GSMW_EXT.NUMBER_OF_SS_PACKETS;
    }
  }

  //----------------------------------------------------------------------------
  // Supplementary Service Event record
  //----------------------------------------------------------------------------
  SS_EVENT_PACKET
  {
    STD_MAPPING
    {
      RECORD_TYPE                -> DETAIL.ASS_GSMW_EXT.SS_PACKET.RECORD_TYPE;
      RECORD_NUMBER              -> DETAIL.ASS_GSMW_EXT.SS_PACKET.RECORD_NUMBER;
      ACTION_CODE                -> DETAIL.ASS_GSMW_EXT.SS_PACKET.ACTION_CODE;
      SS_CODE                    -> DETAIL.ASS_GSMW_EXT.SS_PACKET.SS_EVENT;
    }
  }

  //----------------------------------------------------------------------------
  // Associated WAP record
  //----------------------------------------------------------------------------
  ASSOCIATED_WAP
  {
    STD_MAPPING
    {
      RECORD_TYPE                -> DETAIL.ASS_WAP_EXT.RECORD_TYPE;
      RECORD_NUMBER              -> DETAIL.ASS_WAP_EXT.RECORD_NUMBER;
      PORT_NUMBER                -> DETAIL.ASS_WAP_EXT.PORT_NUMBER;
      DEVICE_NUMBER              -> DETAIL.ASS_WAP_EXT.DEVICE_NUMBER;
      SESSION_ID                 -> DETAIL.ASS_WAP_EXT.SESSION_ID;
      RECORDING_ENTITY           -> DETAIL.ASS_WAP_EXT.RECORDING_ENTITY;
      TERMINAL_CLIENT_ID         -> DETAIL.ASS_WAP_EXT.TERMINAL_CLIENT_ID;
      TERMINAL_IP_ADDRESS        -> DETAIL.ASS_WAP_EXT.TERMINAL_IP_ADDRESS;
      DOMAIN_URL                 -> DETAIL.ASS_WAP_EXT.DOMAIN_URL;
      BEARER_SERVICE             -> DETAIL.ASS_WAP_EXT.BEARER_SERVICE;
      HTTP_STATUS                -> DETAIL.ASS_WAP_EXT.HTTP_STATUS;
      WAP_STATUS                 -> DETAIL.ASS_WAP_EXT.WAP_STATUS;
      ACKNOWLEDGE_STATUS         -> DETAIL.ASS_WAP_EXT.ACKNOWLEDGE_STATUS;
      ACKNOWLEDGE_TIME           -> DETAIL.ASS_WAP_EXT.ACKNOWLEDGE_TIME;
      EVENT_NUMBER               -> DETAIL.ASS_WAP_EXT.EVENT_NUMBER;
      GGSN_ADDRESS               -> DETAIL.ASS_WAP_EXT.GGSN_ADDRESS;
      SERVER_TYPE                -> DETAIL.ASS_WAP_EXT.SERVER_TYPE;
      CHARGING_ID                -> DETAIL.ASS_WAP_EXT.CHARGING_ID;
      WAP_LOGIN                  -> DETAIL.ASS_WAP_EXT.WAP_LOGIN;
    }
  }

  //----------------------------------------------------------------------------
  // Associated CAMEL record
  //----------------------------------------------------------------------------
  ASSOCIATED_CAMEL
  {
    STD_MAPPING
    {
      RECORD_TYPE                     -> DETAIL.ASS_CAMEL_EXT.RECORD_TYPE;
      RECORD_NUMBER                   -> DETAIL.ASS_CAMEL_EXT.RECORD_NUMBER;
      SERVER_TYPE_OF_NUMBER           -> DETAIL.ASS_CAMEL_EXT.SERVER_TYPE_OF_NUMBER;
      SERVER_NUMBERING_PLAN           -> DETAIL.ASS_CAMEL_EXT.SERVER_NUMBERING_PLAN;
      SERVER_ADDRESS                  -> DETAIL.ASS_CAMEL_EXT.SERVER_ADDRESS;
      SERVICE_LEVEL                   -> DETAIL.ASS_CAMEL_EXT.SERVICE_LEVEL;
      SERVICE_KEY                     -> DETAIL.ASS_CAMEL_EXT.SERVICE_KEY;
      DEFAULT_CALL_HANDLING_INDICATOR -> DETAIL.ASS_CAMEL_EXT.DEFAULT_CALL_HANDLING_INDICATOR;
      MSC_TYPE_OF_NUMBER              -> DETAIL.ASS_CAMEL_EXT.MSC_TYPE_OF_NUMBER;
      MSC_NUMBERING_PLAN              -> DETAIL.ASS_CAMEL_EXT.MSC_NUMBERING_PLAN;
      MSC_ADDRESS                     -> DETAIL.ASS_CAMEL_EXT.MSC_ADDRESS;
      CAMEL_REFERENCE_NUMBER          -> DETAIL.ASS_CAMEL_EXT.CAMEL_REFERENCE_NUMBER;
      CAMEL_INITIATED_CF_INDICATOR    -> DETAIL.ASS_CAMEL_EXT.CAMEL_INITIATED_CF_INDICATOR;
      CAMEL_MODIFICATION_LIST         -> DETAIL.ASS_CAMEL_EXT.CAMEL_MODIFICATION_LIST;
      DEST_GSMW_TYPE_OF_NUMBER        -> DETAIL.ASS_CAMEL_EXT.DEST_GSMW_TYPE_OF_NUMBER;
      DEST_GSMW_NUMBERING_PLAN        -> DETAIL.ASS_CAMEL_EXT.DEST_GSMW_NUMBERING_PLAN;
      DEST_GSMW_NUMBER                -> DETAIL.ASS_CAMEL_EXT.DEST_GSMW_NUMBER;
      DEST_GSMW_NUMBER_ORIGINAL       -> DETAIL.ASS_CAMEL_EXT.DEST_GSMW_NUMBER_ORIGINAL;
      DEST_GPRS_APN_ADDRESS           -> DETAIL.ASS_CAMEL_EXT.DEST_GPRS_APN_ADDRESS;
      DEST_GPRS_PDP_REMOTE_ADDRESS    -> DETAIL.ASS_CAMEL_EXT.DEST_GPRS_PDP_REMOTE_ADDRESS;
      CSE_INFORMATION                 -> DETAIL.ASS_CAMEL_EXT.CSE_INFORMATION;
    }
  }

  //----------------------------------------------------------------------------
  // Associated zone record
  //----------------------------------------------------------------------------
  ASSOCIATED_ZONE
  {
    STD_MAPPING
    {
      RECORD_TYPE                  -> DETAIL.ASS_ZBD.RECORD_TYPE;
      RECORD_NUMBER                -> DETAIL.ASS_ZBD.RECORD_NUMBER;
      CONTRACT_CODE                -> DETAIL.ASS_ZBD.CONTRACT_CODE;
      SEGMENT_CODE                 -> DETAIL.ASS_ZBD.SEGMENT_CODE;
      CUSTOMER_CODE                -> DETAIL.ASS_ZBD.CUSTOMER_CODE;
      ACCOUNT_CODE                 -> DETAIL.ASS_ZBD.ACCOUNT_CODE;
      SYSTEM_BRAND_CODE            -> DETAIL.ASS_ZBD.SYSTEM_BRAND_CODE;
      SERVICE_CODE                 -> DETAIL.ASS_ZBD.SERVICE_CODE;
      CUSTOMER_RATEPLAN_CODE       -> DETAIL.ASS_ZBD.CUSTOMER_RATEPLAN_CODE;
      SERVICE_LEVEL_AGREEMENT_CODE -> DETAIL.ASS_ZBD.SLA_CODE;
      CUSTOMER_BILLCYCLE           -> DETAIL.ASS_ZBD.CUSTOMER_BILLCYCLE;
      CUSTOMER_CURRENCY            -> DETAIL.ASS_ZBD.CUSTOMER_CURRENCY;
      CUSTOMER_TAXGROUP            -> DETAIL.ASS_ZBD.CUSTOMER_TAXGROUP;
      NUMBER_OF_ZONE_PACKETS       -> DETAIL.ASS_ZBD.NUMBER_OF_ZONE_PACKETS;
    }
  }
   
  //----------------------------------------------------------------------------
  // Zone packet record
  //----------------------------------------------------------------------------
  ZONE_PACKET
  {
    STD_MAPPING
    {
      RECORD_TYPE                  -> DETAIL.ASS_ZBD.ZP.RECORD_TYPE;
      RECORD_NUMBER                -> DETAIL.ASS_ZBD.ZP.RECORD_NUMBER;
      ZONEMODEL_CODE               -> DETAIL.ASS_ZBD.ZP.ZONEMODEL_CODE;
      ZONE_RESULT_VALUE_WHOLESALE  -> DETAIL.ASS_ZBD.ZP.ZONE_RESULT_VALUE_WS;
      ZONE_RESULT_VALUE_RETAIL     -> DETAIL.ASS_ZBD.ZP.ZONE_RESULT_VALUE_RT;
      DISTANCE                     -> DETAIL.ASS_ZBD.ZP.DISTANCE;
    }
  }
    
  //----------------------------------------------------------------------------
  // Associated charge record
  //----------------------------------------------------------------------------
  ASSOCIATED_CHARGE
  {
    STD_MAPPING
    {
      RECORD_TYPE                  -> DETAIL.ASS_CBD.RECORD_TYPE;
      RECORD_NUMBER                -> DETAIL.ASS_CBD.RECORD_NUMBER;
      CONTRACT_CODE                -> DETAIL.ASS_CBD.CONTRACT_CODE;
      SEGMENT_CODE                 -> DETAIL.ASS_CBD.SEGMENT_CODE;
      CUSTOMER_CODE                -> DETAIL.ASS_CBD.CUSTOMER_CODE;
      ACCOUNT_CODE                 -> DETAIL.ASS_CBD.ACCOUNT_CODE;
      SYSTEM_BRAND_CODE            -> DETAIL.ASS_CBD.SYSTEM_BRAND_CODE;
      SERVICE_CODE                 -> DETAIL.ASS_CBD.SERVICE_CODE;
      CUSTOMER_RATEPLAN_CODE       -> DETAIL.ASS_CBD.CUSTOMER_RATEPLAN_CODE;
      SERVICE_LEVEL_AGRREEMENT_CODE -> DETAIL.ASS_CBD.SLA_CODE;
      CUSTOMER_BILLCYCLE           -> DETAIL.ASS_CBD.CUSTOMER_BILLCYCLE;
      CUSTOMER_CURRENCY            -> DETAIL.ASS_CBD.CUSTOMER_CURRENCY;
      CUSTOMER_TAXGROUP            -> DETAIL.ASS_CBD.CUSTOMER_TAXGROUP;
      NUMBER_OF_CHARGE_PACKETS     -> DETAIL.ASS_CBD.NUMBER_OF_CHARGE_PACKETS;
    }
  }

  //----------------------------------------------------------------------------
  // Charge packet record
  //----------------------------------------------------------------------------
  CHARGE_PACKET
  {
    STD_MAPPING
    {
      RECORD_TYPE                      -> DETAIL.ASS_CBD.CP.RECORD_TYPE;
      RECORD_NUMBER                    -> DETAIL.ASS_CBD.CP.RECORD_NUMBER;
      RATEPLAN_CODE                    -> DETAIL.ASS_CBD.CP.RATEPLAN_CODE;   
      RATEPLAN_TYPE                    -> DETAIL.ASS_CBD.CP.RATEPLAN_TYPE;   
      ZONEMODEL_CODE                   -> DETAIL.ASS_CBD.CP.ZONEMODEL_CODE;   
      SERVICE_CODE_USED                -> DETAIL.ASS_CBD.CP.SERVICE_CODE_USED;   
      SERVICE_CLASS_USED               -> DETAIL.ASS_CBD.CP.SERVICE_CLASS_USED;   
      IMPACT_CATEGORY                  -> DETAIL.ASS_CBD.CP.IMPACT_CATEGORY;   
      DISTANCE                         -> DETAIL.ASS_CBD.CP.DISTANCE;   
      TIMEMODEL_CODE                   -> DETAIL.ASS_CBD.CP.TIMEMODEL_CODE;   
      TIMEZONE_CODE                    -> DETAIL.ASS_CBD.CP.TIMEZONE_CODE;   
      DAY_CODE                         -> DETAIL.ASS_CBD.CP.DAY_CODE;   
      TIME_INTERVAL_CODE               -> DETAIL.ASS_CBD.CP.TIME_INTERVAL_CODE;   
      PRICEMODEL_CODE                  -> DETAIL.ASS_CBD.CP.PRICEMODEL_CODE;   
      PRICEMODEL_TYPE                  -> DETAIL.ASS_CBD.CP.PRICEMODEL_TYPE;   
      RESOURCE                         -> DETAIL.ASS_CBD.CP.RESOURCE;   
      RUMGROUP                         -> DETAIL.ASS_CBD.CP.RUMGROUP;   
      RUM                              -> DETAIL.ASS_CBD.CP.RUM;   
      NETWORK_OPERATOR_CODE            -> DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_CODE;   
      NETWORK_OPERATOR_BILLINGTYPE     -> DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_BILLINGTYPE;   
      CHARGE_TYPE                      -> DETAIL.ASS_CBD.CP.CHARGE_TYPE;   
      TRUNK_USED                       -> DETAIL.ASS_CBD.CP.TRUNK_USED;   
      POI_USED                         -> DETAIL.ASS_CBD.CP.POI_USED;   
      PRODUCTCODE_USED                 -> DETAIL.ASS_CBD.CP.PRODUCTCODE_USED;   
      CHARGING_START_TIMESTAMP         -> DETAIL.ASS_CBD.CP.CHARGING_START_TIMESTAMP;   
      CHARGEABLE_QUANTITY_VALUE        -> DETAIL.ASS_CBD.CP.CHARGEABLE_QUANTITY_VALUE;   
      ROUNDED_QUANTITY_VALUE           -> DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_VALUE;   
      ROUNDED_QUANTITY_UOM             -> DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_UOM;   
      EXCHANGE_RATE                    -> DETAIL.ASS_CBD.CP.EXCHANGE_RATE;
      EXCHANGE_CURRENCY                -> DETAIL.ASS_CBD.CP.EXCHANGE_CURRENCY;
      CHARGED_CURRENCY_TYPE            -> DETAIL.ASS_CBD.CP.CHARGED_CURRENCY_TYPE;   
      CHARGED_AMOUNT_VALUE             -> DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_VALUE;   
      CHARGED_AMOUNT_CURRENCY          -> DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_CURRENCY;   
      CHARGED_TAX_TREATMENT            -> DETAIL.ASS_CBD.CP.CHARGED_TAX_TREATMENT;   
      CHARGED_TAX_RATE                 -> DETAIL.ASS_CBD.CP.CHARGED_TAX_RATE;   
      CHARGED_TAX_CODE                 -> DETAIL.ASS_CBD.CP.CHARGED_TAX_CODE;   
      GL_ACCOUNT                       -> DETAIL.ASS_CBD.CP.USAGE_GL_ACCOUNT_CODE;   
      REVENUE_GROUP_CODE               -> DETAIL.ASS_CBD.CP.REVENUE_GROUP_CODE;   
      DISCOUNTMODEL_CODE               -> DETAIL.ASS_CBD.CP.DISCOUNTMODEL_CODE;   
      GRANTED_DISCOUNT_AMOUNT_VALUE    -> DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_AMOUNT_VALUE;   
      GRANTED_DISCOUNT_QUANTITY_VALUE  -> DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_VALUE;   
      GRANTED_DISCOUNT_QUANTITY_UOM    -> DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_UOM;   
    }
  }

  //----------------------------------------------------------------------------
  // Discount packet record
  //----------------------------------------------------------------------------
  DISCOUNT_PACKET
  {
    STD_MAPPING
    {
      RECORD_TYPE                       -> DETAIL.ASS_CBD.DP.RECORD_TYPE;
      CREATED                           -> DETAIL.ASS_CBD.DP.CREATED;
      OBJECT_ID                         -> DETAIL.ASS_CBD.DP.OBJECT_ID;
      OBJECT_TYPE                       -> DETAIL.ASS_CBD.DP.OBJECT_TYPE;
      OBJECT_ACCOUNT                    -> DETAIL.ASS_CBD.DP.OBJECT_ACCOUNT;
      OBJECT_OWNER_ID                   -> DETAIL.ASS_CBD.DP.OBJECT_OWNER_ID;
      OBJECT_OWNER_TYPE                 -> DETAIL.ASS_CBD.DP.OBJECT_OWNER_TYPE;
      DISCOUNTMODEL                     -> DETAIL.ASS_CBD.DP.DISCOUNTMODEL;
      DISCOUNTRULE                      -> DETAIL.ASS_CBD.DP.DISCOUNTRULE;
      DISCOUNTSTEPID                    -> DETAIL.ASS_CBD.DP.DISCOUNTSTEPID;
      DISCOUNTBALIMPACTID               -> DETAIL.ASS_CBD.DP.DISCOUNTBALIMPACTID;
      TAX_CODE                          -> DETAIL.ASS_CBD.DP.TAX_CODE;
      AMOUNT                            -> DETAIL.ASS_CBD.DP.AMOUNT;
      QUANTITY                          -> DETAIL.ASS_CBD.DP.QUANTITY;
      GRANTED_AMOUNT                    -> DETAIL.ASS_CBD.DP.GRANTED_AMOUNT;
      GRANTED_QUANTITY                  -> DETAIL.ASS_CBD.DP.GRANTED_QUANTITY;
      QUANTITY_FROM                     -> DETAIL.ASS_CBD.DP.QUANTITY_FROM;
      QUANTITY_TO                       -> DETAIL.ASS_CBD.DP.QUANTITY_TO;
      VALID_FROM                        -> DETAIL.ASS_CBD.DP.VALID_FROM;
      VALID_TO                          -> DETAIL.ASS_CBD.DP.VALID_TO;
      BALANCE_GROUP_ID                  -> DETAIL.ASS_CBD.DP.BALANCE_GROUP_ID;
      RESOURCE_ID                       -> DETAIL.ASS_CBD.DP.RESOURCE_ID;
      ZONEMODEL_CODE                    -> DETAIL.ASS_CBD.DP.ZONEMODEL_CODE;
      IMPACT_CATEGORY                   -> DETAIL.ASS_CBD.DP.IMPACT_CATEGORY;
      SERVICE_CODE                      -> DETAIL.ASS_CBD.DP.SERVICE_CODE;
      TIMEZONE_CODE                     -> DETAIL.ASS_CBD.DP.TIMEZONE_CODE;
      TIMEMODEL_CODE                    -> DETAIL.ASS_CBD.DP.TIMEMODEL_CODE;
      SERVICE_CLASS                     -> DETAIL.ASS_CBD.DP.SERVICE_CLASS;
      PRICEMODEL_CODE                   -> DETAIL.ASS_CBD.DP.PRICEMODEL_CODE;
      RUM                               -> DETAIL.ASS_CBD.DP.RUM;
      RATETAG                           -> DETAIL.ASS_CBD.DP.RATETAG;
      RATEPLAN                          -> DETAIL.ASS_CBD.DP.RATEPLAN;
      GLID                              -> DETAIL.ASS_CBD.DP.GLID;
    }
  }

  //----------------------------------------------------------------------------
  // Discount packet record
  //----------------------------------------------------------------------------
  DISCOUNT_SUBBALANCE
  { 
    STD_MAPPING
    {
      RECORD_NUMBER                     -> DETAIL.ASS_CBD.DP.SUB_BALANCE.REC_ID;
      VALID_FROM                        -> DETAIL.ASS_CBD.DP.SUB_BALANCE.VALID_FROM;
      VALID_TO                          -> DETAIL.ASS_CBD.DP.SUB_BALANCE.VALID_TO;
      PIN_AMOUNT                        -> DETAIL.ASS_CBD.DP.SUB_BALANCE.AMOUNT;
      CONTRIBUTOR                       -> DETAIL.ASS_CBD.DP.SUB_BALANCE.CONTRIBUTOR;
    }
  }

  //----------------------------------------------------------------------------
  // Associated Infranet Billing record
  //----------------------------------------------------------------------------
  ASSOCIATED_INFRANET
  {     
    STD_MAPPING
    {
      RECORD_TYPE               -> DETAIL.ASS_PIN.RECORD_TYPE;
      RECORD_NUMBER             -> DETAIL.ASS_PIN.RECORD_NUMBER;
      ACCOUNT_POID              -> DETAIL.ASS_PIN.ACCOUNT_POID;
      SERVICE_POID              -> DETAIL.ASS_PIN.SERVICE_POID;
      ITEM_POID                 -> DETAIL.ASS_PIN.ITEM_POID;
      ORIGINAL_EVENT_POID       -> DETAIL.ASS_PIN.ORIGINAL_EVENT_POID;
      PIN_TAX_LOCALES           -> DETAIL.ASS_PIN.PIN_TAX_LOCALES;
      PIN_TAX_SUPPLIER_ID       -> DETAIL.ASS_PIN.PIN_TAX_SUPPLIER_ID;
      PIN_PROVIDER_ID           -> DETAIL.ASS_PIN.PIN_PROVIDER_ID;
      NUMBER_OF_BALANCE_PACKETS -> DETAIL.ASS_PIN.NUMBER_OF_BALANCE_PACKETS;
    }
  }

  BALANCE_PACKET
  {
    STD_MAPPING
    {
      RECORD_TYPE               -> DETAIL.ASS_PIN.BP.RECORD_TYPE;
      RECORD_NUMBER             -> DETAIL.ASS_PIN.BP.RECORD_NUMBER;
      ACCOUNT_POID              -> DETAIL.ASS_PIN.BP.ACCOUNT_POID;
      BAL_GRP_POID              -> DETAIL.ASS_PIN.BP.BAL_GRP_POID;
      ITEM_POID                	-> DETAIL.ASS_PIN.BP.ITEM_POID;
      PIN_RESOURCE_ID           -> DETAIL.ASS_PIN.BP.PIN_RESOURCE_ID;
      PIN_IMPACT_CATEGORY       -> DETAIL.ASS_PIN.BP.PIN_IMPACT_CATEGORY;
      PIN_IMPACT_TYPE         	-> DETAIL.ASS_PIN.BP.PIN_IMPACT_TYPE;
      PIN_PRODUCT_POID          -> DETAIL.ASS_PIN.BP.PIN_PRODUCT_POID;
      PIN_GL_ID                 -> DETAIL.ASS_PIN.BP.PIN_GL_ID;
      PIN_TAX_CODE              -> DETAIL.ASS_PIN.BP.PIN_TAX_CODE;
      PIN_RATE_TAG              -> DETAIL.ASS_PIN.BP.PIN_RATE_TAG;
      PIN_LINEAGE               -> DETAIL.ASS_PIN.BP.PIN_LINEAGE;
      PIN_NODE_LOCATION         -> DETAIL.ASS_PIN.BP.PIN_NODE_LOCATION;
      PIN_QUANTITY              -> DETAIL.ASS_PIN.BP.PIN_QUANTITY;
      PIN_AMOUNT                -> DETAIL.ASS_PIN.BP.PIN_AMOUNT;
      PIN_DISCOUNT              -> DETAIL.ASS_PIN.BP.PIN_DISCOUNT;
      PIN_INFO_STRING           -> DETAIL.ASS_PIN.BP.PIN_INFO_STRING;
    }
  }

  //----------------------------------------------------------------------------
  // Associated Message Description record
  //----------------------------------------------------------------------------
  ASSOCIATED_MESSAGE
  {     
    STD_MAPPING
    {
      RECORD_TYPE               -> DETAIL.ASS_MSG_DES.RECORD_TYPE;
      RECORD_NUMBER             -> DETAIL.ASS_MSG_DES.RECORD_NUMBER;
      SYSTEM                    -> DETAIL.ASS_MSG_DES.SYSTEM;
      MESSAGE_SEVERITY          -> DETAIL.ASS_MSG_DES.MESSAGE_SEVERITY;
      MESSAGE_ID                -> DETAIL.ASS_MSG_DES.MESSAGE_ID;
      MESSAGE_DESCRIPTION       -> DETAIL.ASS_MSG_DES.MESSAGE_DESCRIPTION;
    }
  }

  //----------------------------------------------------------------------------
  // Trailer record
  //----------------------------------------------------------------------------
  TRAILER
  {
    STD_MAPPING
    {
      RECORD_TYPE                    -> TRAILER.RECORD_TYPE;
      RECORD_NUMBER                  -> TRAILER.RECORD_NUMBER;
      SENDER                         -> TRAILER.SENDER;
      RECIPIENT                      -> TRAILER.RECIPIENT;
      SEQUENCE_NUMBER                -> TRAILER.SEQUENCE_NUMBER;
      ORIGIN_SEQUENCE_NUMBER         -> TRAILER.ORIGIN_SEQUENCE_NUMBER;
      TOTAL_NUMBER_OF_RECORDS        -> TRAILER.TOTAL_NUMBER_OF_RECORDS;
      FIRST_CHARGING_START_TIMESTAMP -> TRAILER.FIRST_START_TIMESTAMP;
      FIRST_CHARGING_UTC_TIME_OFFSET -> TRAILER.FIRST_CHARGING_UTC_TIME_OFFSET;
      LAST_CHARGING_START_TIMESTAMP  -> TRAILER.LAST_START_TIMESTAMP;
      LAST_CHARGING_UTC_TIME_OFFSET  -> TRAILER.LAST_CHARGING_UTC_TIME_OFFSET;
      TOTAL_RETAIL_CHARGED_VALUE     -> TRAILER.TOTAL_RETAIL_CHARGED_VALUE;
      TOTAL_WHOLESALE_CHARGED_VALUE  -> TRAILER.TOTAL_WHOLESALE_CHARGED_VALUE;
    }
  }
}

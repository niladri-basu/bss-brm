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
//   Description of the Solution42 V6.50 REL CDR format with Unix timestamps
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
// $RCSfile: SOL42_V650_REL_FORINPUT.dsc,v $
// $Revision: 1.3 $
// $Author: pengelbr $
// $Date: 2001/10/01 06:54:55 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V650_REL_FORINPUT.dsc,v $
//==============================================================================

SOL42_V650_REL_FORINPUT
{
  //----------------------------------------------------------------------------
  // Header record
  //----------------------------------------------------------------------------
  HEADER(SEPARATED)
  {
    Info
    {
      Pattern = "010.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    
    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    SENDER                              AscString();
    RECIPIENT                           AscString();
    SEQUENCE_NUMBER                     AscInteger();
    ORIGIN_SEQUENCE_NUMBER              AscInteger();
    CREATION_TIMESTAMP                  AscDateUnix();
    TRANSMISSION_DATE                   AscDateUnix();
    TRANSFER_CUTOFF_TIMESTAMP           AscDateUnix();
    UTC_TIME_OFFSET                     AscString();
    SPECIFICATION_VERSION_NUMBER        AscInteger();
    RELEASE_VERSION                     AscInteger();
    ORIGIN_COUNTRY_CODE                 AscString();   
    SENDER_COUNTRY_CODE                 AscString();
    DATA_TYPE_INDICATOR                 AscString();
    IAC_LIST                            AscString();
    CC_LIST                             AscString();
    CREATION_PROCESS                    AscString();
    SCHEMA_VERSION                      AscString();
    EVENT_TYPE                          AscString();
    BATCH_ID				AscString();


  }

  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL(SEPARATED)
  {
    Info
    {
      Pattern = "(02[0-8]|03[0-1]|04[0-9]|050|060|070|12[0-8]|13[0-1]|220).*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    EVENT_ID				AscString();
    BATCH_ID				AscString();
    ORIGINAL_BATCH_ID			AscString();
    DISCARDING                          AscInteger();
    CHAIN_REFERENCE                     AscString();
    SOURCE_NETWORK_TYPE                 AscString();
    SOURCE_NETWORK                      AscString();
    DESTINATION_NETWORK_TYPE            AscString();
    DESTINATION_NETWORK                 AscString();
    TYPE_OF_A_IDENTIFICATION            AscString();
    A_MODIFICATION_INDICATOR            AscString();
    A_TYPE_OF_NUMBER                    AscInteger();
    A_NUMBERING_PLAN                    AscString();
    A_NUMBER                            AscString();
    B_MODIFICATION_INDICATOR            AscString();
    B_TYPE_OF_NUMBER                    AscInteger();
    B_NUMBERING_PLAN                    AscString();
    B_NUMBER                            AscString();
    DESCRIPTION                         AscString();
    C_MODIFICATION_INDICATOR            AscString();
    C_TYPE_OF_NUMBER                    AscInteger();
    C_NUMBERING_PLAN                    AscString();
    C_NUMBER                            AscString();
    USAGE_DIRECTION                     AscString();
    CONNECT_TYPE                        AscString();
    CONNECT_SUB_TYPE                    AscString();
    BASIC_SERVICE                       AscString();
    QOS_REQUESTED                       AscString();
    QOS_USED                            AscString();
    CALL_COMPLETION_INDICATOR           AscString();
    LONG_DURATION_INDICATOR             AscString();
    CHARGING_START_TIMESTAMP            AscDateUnix();
    CHARGING_END_TIMESTAMP              AscDateUnix();
    UTC_TIME_OFFSET                     AscString();
    DURATION                            AscDecimal();
    DURATION_UOM                        AscString();
    VOLUME_SENT                         AscDecimal();
    VOLUME_SENT_UOM                     AscString();
    VOLUME_RECEIVED                     AscDecimal();
    VOLUME_RECEIVED_UOM                 AscString();
    NUMBER_OF_UNITS                     AscDecimal();
    NUMBER_OF_UNITS_UOM                 AscString();
    RETAIL_IMPACT_CATEGORY              AscString();
    RETAIL_CHARGED_AMOUNT_VALUE         AscDecimal();
    RETAIL_CHARGED_AMOUNT_CURRENCY      AscString();
    RETAIL_CHARGED_TAX_TREATMENT        AscString();
    RETAIL_CHARGED_TAX_RATE             AscInteger();
    WHOLESALE_IMPACT_CATEGORY           AscString();
    WHOLESALE_CHARGED_AMOUNT_VALUE      AscDecimal();
    WHOLESALE_CHARGED_AMOUNT_CURRENCY   AscString();
    WHOLESALE_CHARGED_TAX_TREATMENT     AscString();
    WHOLESALE_CHARGED_TAX_RATE          AscInteger();
    ZONE_DESCRIPTION                    AscString();
    IC_DESCRIPTION                      AscString();
    ZONE_ENTRY_NAME                     AscString();
    TARIFF_CLASS                        AscString();
    TARIFF_SUB_CLASS                    AscString();
    USAGE_CLASS                         AscString();
    USAGE_TYPE                          AscString();
    BILLCYCLE_PERIOD                    AscString();
    PREPAID_INDICATOR                   AscInteger();
    NUMBER_ASSOCIATED_RECORDS           AscInteger();

  }

  //----------------------------------------------------------------------------
  // Associated GSMW record
  //----------------------------------------------------------------------------
  ASSOCIATED_GSMW(SEPARATED)
  {
    Info
    {
      Pattern = "520.*\n";
      RecordSeparator = '\n';
      FieldSeparator = '\t';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    PORT_NUMBER                         AscString();
    DEVICE_NUMBER                       AscString();
    A_NUMBER_USER                       AscString();
    DIALED_DIGITS                       AscString();
    BASIC_DUAL_SERVICE                  AscString();
    PRODUCT_CODE                        AscString();
    ORIGINATING_SWITCH_IDENTIFICATION   AscString();
    TERMINATING_SWITCH_IDENTIFICATION   AscString();
    TRUNK_INPUT                         AscString();
    TRUNK_OUTPUT                        AscString();
    LOCATION_AREA_INDICATOR             AscString();
    CELL_ID                             AscString();
    MS_CLASS_MARK                       AscInteger();
    TIME_BEFORE_ANSWER                  AscInteger();
    BASIC_AOC_AMOUNT_VALUE              AscDecimal();
    BASIC_AOC_AMOUNT_CURRENCY           AscString();
    ROAMER_AOC_AMOUNT_VALUE             AscDecimal();
    ROAMER_AOC_AMOUNT_CURRENCY          AscString();
    NUMBER_OF_SS_EVENT_PACKETS          AscInteger();
  }

  //----------------------------------------------------------------------------
  // Supplementary Service Event record
  //----------------------------------------------------------------------------
  SS_EVENT_PACKET(SEPARATED)
  {
    Info
    {
      Pattern = "620.*\n";
      RecordSeparator = '\n';
      FieldSeparator = '\t';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    ACTION_CODE                         AscString();
    SS_CODE                             AscString();
  }

  //----------------------------------------------------------------------------
  // Associated GPRS record
  //----------------------------------------------------------------------------
  ASSOCIATED_GPRS(SEPARATED)
  {
    Info
    {
      Pattern = "540.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    PORT_NUMBER                         AscString();
    DEVICE_NUMBER                       AscString();
    A_NUMBER_USER                       AscString();
    DIALED_DIGITS                       AscString();
    PRODUCT_CODE                        AscString();
    ORIGINATING_SWITCH_IDENTIFICATION   AscString();
    TERMINATING_SWITCH_IDENTIFICATION   AscString();
    MS_CLASS_MARK                       AscInteger();
    ROUTING_AREA                        AscString();
    LOCATION_AREA_INDICATOR             AscString();
    CHARGING_ID                         AscDecimal();
    SGSN_ADDRESS                        AscString();
    GGSN_ADDRESS                        AscString();
    APN_ADDRESS                         AscString();
    NODE_ID                             AscString();
    TRANS_ID                            AscInteger();
    SUB_TRANS_ID                        AscInteger();
    NETWORK_INITIATED_PDP               AscInteger();
    PDP_TYPE                            AscString();
    PDP_ADDRESS                         AscString();
    PDP_REMOTE_ADDRESS                  AscString();
    PDP_DYNAMIC_ADDRESS                 AscInteger();
    DIAGNOSTICS                         AscString();
    CELL_ID                             AscString();
    CHANGE_CONDITION                    AscInteger();
    QOS_REQUESTED_PRECEDENCE            AscString();
    QOS_REQUESTED_DELAY                 AscString();
    QOS_REQUESTED_RELIABILITY           AscString();
    QOS_REQUESTED_PEAK_THROUGHPUT       AscString();
    QOS_REQUESTED_MEAN_THROUGHPUT       AscString();
    QOS_USED_PRECEDENCE                 AscString();
    QOS_USED_DELAY                      AscString();
    QOS_USED_RELIABILITY                AscString();
    QOS_USED_PEAK_THROUGHPUT            AscString();
    QOS_USED_MEAN_THROUGHPUT            AscString();
    NETWORK_CAPABILITY                  AscString();
    SGSN_CHANGE                         AscInteger();
  }

  //----------------------------------------------------------------------------
  // Associated WAP record
  //----------------------------------------------------------------------------
  ASSOCIATED_WAP(SEPARATED)
  {
    Info
    {
      Pattern = "570.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    PORT_NUMBER                         AscString();
    DEVICE_NUMBER                       AscString();
    SESSION_ID                          AscString();
    RECORDING_ENTITY                    AscString();
    TERMINAL_CLIENT_ID                  AscString();
    TERMINAL_IP_ADDRESS                 AscString();
    DOMAIN_URL                          AscString();
    BEARER_SERVICE                      AscString();
    HTTP_STATUS                         AscInteger();
    WAP_STATUS                          AscInteger();
    ACKNOWLEDGE_STATUS                  AscInteger();
    ACKNOWLEDGE_TIME                    AscDateUnix();
    EVENT_NUMBER                        AscString();
    GGSN_ADDRESS                        AscString();
    SERVER_TYPE                         AscString();
    CHARGING_ID                         AscDecimal();
    WAP_LOGIN                           AscString();
  }

  //----------------------------------------------------------------------------
  // Associated CAMEL record
  //----------------------------------------------------------------------------
  ASSOCIATED_CAMEL(SEPARATED)
  {
    Info
    {
      Pattern = "700.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    SERVER_TYPE_OF_NUMBER               AscInteger;
    SERVER_NUMBERING_PLAN               AscString;
    SERVER_ADDRESS                      AscString;
    SERVICE_LEVEL                       AscInteger;
    SERVICE_KEY                         AscInteger;
    DEFAULT_CALL_HANDLING_INDICATOR     AscInteger;
    MSC_TYPE_OF_NUMBER                  AscInteger;
    MSC_NUMBERING_PLAN                  AscString;
    MSC_ADDRESS                         AscString;
    CAMEL_REFERENCE_NUMBER              AscString;
    CAMEL_INITIATED_CF_INDICATOR        AscInteger;
    CAMEL_MODIFICATION_LIST             AscString;
    DEST_GSMW_TYPE_OF_NUMBER            AscInteger;
    DEST_GSMW_NUMBERING_PLAN            AscString;
    DEST_GSMW_NUMBER                    AscString;
    DEST_GSMW_NUMBER_ORIGINAL           AscString;
    DEST_GPRS_APN_ADDRESS               AscString;
    DEST_GPRS_PDP_REMOTE_ADDRESS        AscString;
    CSE_INFORMATION                     AscString;
  }

  //----------------------------------------------------------------------------
  // Associated Infranet Billing record
  //----------------------------------------------------------------------------
  ASSOCIATED_INFRANET(SEPARATED)
  {
    Info
    {
      Pattern = "900.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    ACCOUNT_POID                        AscString();
    SERVICE_POID                        AscString();
    ITEM_POID                           AscString();
    ORIGINAL_EVENT_POID                 AscString();
    PIN_TAX_LOCALES                     AscString();
    PIN_TAX_SUPPLIER_ID                 AscString();
    PIN_PROVIDER_ID                     AscString();
    NUMBER_OF_BALANCE_PACKETS           AscInteger();
    INVOICE_DATA                        AscString();
  }

  //----------------------------------------------------------------------------
  // Infranet Balance Impact packet
  //----------------------------------------------------------------------------
  BALANCE_PACKET(SEPARATED)
  {
    Info
    {
      Pattern = "600.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    
    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    ACCOUNT_POID                        AscString();
    BAL_GRP_POID                        AscString();
    ITEM_POID                        	AscString();
    PIN_RESOURCE_ID                     AscInteger();
    PIN_IMPACT_CATEGORY                 AscString();
    PIN_IMPACT_TYPE                 	AscInteger();
    PIN_PRODUCT_POID                    AscString();
    PIN_GL_ID                           AscInteger();
    PIN_TAX_CODE                        AscString();
    PIN_RATE_TAG                        AscString();
    PIN_LINEAGE                         AscString();
    PIN_NODE_LOCATION                   AscString();
    PIN_QUANTITY                        AscDecimal();
    PIN_AMOUNT                          AscDecimal();
    PIN_AMOUNT_DEFERRED                 AscDecimal();
    PIN_DISCOUNT                        AscDecimal();
    PIN_INFO_STRING                     AscString();
  }

  //----------------------------------------------------------------------------
  //  Associated Zone Breakdown record
  //----------------------------------------------------------------------------
  ASSOCIATED_ZONE(SEPARATED)
  {
    Info
    {
      Pattern = "96[0-1].*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    CONTRACT_CODE                       AscString();
    SEGMENT_CODE                        AscString();
    CUSTOMER_CODE                       AscString();
    ACCOUNT_CODE                        AscString();
    SYSTEM_BRAND_CODE                   AscString();
    SERVICE_CODE                        AscString();
    CUSTOMER_RATEPLAN_CODE              AscString();
    SERVICE_LEVEL_AGREEMENT_CODE        AscString();
    CUSTOMER_BILLCYCLE                  AscString();
    CUSTOMER_CURRENCY                   AscString();
    CUSTOMER_TAXGROUP                   AscString();
    NUMBER_OF_ZONE_PACKETS              AscInteger();
  }

  //----------------------------------------------------------------------------
  // Zone packet record
  //----------------------------------------------------------------------------
  ZONE_PACKET(SEPARATED)
  {
    Info
    {
      Pattern = "660.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    
    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    ZONEMODEL_CODE                      AscString();
    ZONE_RESULT_VALUE_WHOLESALE         AscString();
    ZONE_RESULT_VALUE_RETAIL            AscString();
    ZONE_DESCRIPTION                    AscString();
    ZONE_ENTRY_NAME                     AscString();
    DISTANCE                            AscInteger();
  }

  //----------------------------------------------------------------------------
  // Associated charge record
  //----------------------------------------------------------------------------
  ASSOCIATED_CHARGE(SEPARATED)
  {
    Info
    {
      Pattern = "(98[0-4]|99[0-1]).*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    
    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    CONTRACT_CODE                       AscString();
    SEGMENT_CODE                        AscString();
    CUSTOMER_CODE                       AscString();
    ACCOUNT_CODE                        AscString();
    SYSTEM_BRAND_CODE                   AscString();
    SERVICE_CODE                        AscString();
    CUSTOMER_RATEPLAN_CODE              AscString();
    SERVICE_LEVEL_AGRREEMENT_CODE       AscString();
    CUSTOMER_BILLCYCLE                  AscString();
    CUSTOMER_CURRENCY                   AscString();
    CUSTOMER_TAXGROUP                   AscString();
    NUMBER_OF_CHARGE_PACKETS            AscInteger();
  }

  //----------------------------------------------------------------------------
  // Charge packet
  //----------------------------------------------------------------------------
  CHARGE_PACKET(SEPARATED)
  { 
    Info
    {
      Pattern = "680.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    
    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    RATEPLAN_CODE                       AscString();
    RATEPLAN_TYPE                       AscString();
    ZONEMODEL_CODE                      AscString();
    SERVICE_CODE_USED                   AscString();
    SERVICE_CLASS_USED                  AscString();
    IMPACT_CATEGORY                     AscString();
    ZONE_DESCRIPTION                    AscString();
    IC_DESCRIPTION                      AscString();
    ZONE_ENTRY_NAME                     AscString();
    DISTANCE                            AscInteger();
    TIMEMODEL_CODE                      AscString();
    TIMEZONE_CODE                       AscString();
    DAY_CODE                            AscString();
    TIME_INTERVAL_CODE                  AscString();
    PRICEMODEL_CODE                     AscString();
    PRICEMODEL_TYPE                     AscString();
    RESOURCE                            AscString();
    RUMGROUP                            AscString();
    RUM                                 AscString();
    NETWORK_OPERATOR_CODE               AscString();
    NETWORK_OPERATOR_BILLINGTYPE        AscString();
    CHARGE_TYPE                         AscString();
    TRUNK_USED                          AscString();
    POI_USED                            AscString();
    PRODUCTCODE_USED                    AscString();
    CHARGING_START_TIMESTAMP            AscDateUnix();
    CHARGEABLE_QUANTITY_VALUE           AscDecimal();
    ROUNDED_QUANTITY_VALUE              AscDecimal();
    ROUNDED_QUANTITY_UOM                AscString();
    EXCHANGE_RATE                       AscDecimal();
    EXCHANGE_CURRENCY                   AscString();
    CHARGED_CURRENCY_TYPE               AscString();
    CHARGED_AMOUNT_VALUE                AscDecimal();
    CHARGED_AMOUNT_CURRENCY             AscString();
    CHARGED_TAX_TREATMENT               AscString();
    CHARGED_TAX_RATE                    AscInteger();
    CHARGED_TAX_CODE                    AscString();
    GL_ACCOUNT                          AscString();
    REVENUE_GROUP_CODE                  AscString();
    DISCOUNTMODEL_CODE                  AscString();
    GRANTED_DISCOUNT_AMOUNT_VALUE       AscDecimal();
    GRANTED_DISCOUNT_QUANTITY_VALUE     AscDecimal();
    GRANTED_DISCOUNT_QUANTITY_UOM       AscString();
    NUMBER_OF_DISCOUNT_PACKETS          AscInteger();
  }

  //----------------------------------------------------------------------------
  // Discount Packet
  //----------------------------------------------------------------------------
  DISCOUNT_PACKET(SEPARATED)
  { 
    Info
    {
      Pattern = "690.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                     AscString();
    CREATED                         AscString();
    OBJECT_ID                       AscString();
    OBJECT_TYPE                     AscString();
    OBJECT_ACCOUNT                  AscInteger();
    OBJECT_OWNER_ID                 AscInteger();
    OBJECT_OWNER_TYPE               AscString();
    DISCOUNTMODEL                   AscString();
    DISCOUNTRULE                    AscString();
    DISCOUNTSTEPID                  AscInteger();
    DISCOUNTBALIMPACTID             AscInteger();
    TAX_CODE                        AscString();
    AMOUNT                          AscDecimal();
    QUANTITY                        AscDecimal();
    GRANTED_AMOUNT                  AscDecimal();
    GRANTED_QUANTITY                AscDecimal();
    QUANTITY_FROM                   AscDecimal();
    QUANTITY_TO                     AscDecimal();
    VALID_FROM                      AscDateUnix();
    VALID_TO                        AscDateUnix();
    BALANCE_GROUP_ID                AscInteger();
    RESOURCE_ID                     AscInteger();
    ZONEMODEL_CODE                  AscString();
    IMPACT_CATEGORY                 AscString();
    SERVICE_CODE                    AscString();
    TIMEZONE_CODE                   AscString();
    TIMEMODEL_CODE                  AscString();
    SERVICE_CLASS                   AscString();
    PRICEMODEL_CODE                 AscString();
    RUM                             AscString();
    RATETAG                         AscString();
    RATEPLAN                        AscString();
    GLID                            AscString();
  }

  //----------------------------------------------------------------------------
  // Associated Message Description Record
  //----------------------------------------------------------------------------
  DISCOUNT_SUBBALANCE(SEPARATED)
  {
    Info
    {
      Pattern = "609.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE         AscString();
    RECORD_NUMBER       AscInteger();
    PIN_AMOUNT          AscDecimal();
    VALID_FROM          AscDateUnix();
    VALID_TO            AscDateUnix();
    CONTRIBUTOR         AscString();

  }

  //----------------------------------------------------------------------------
  // Associated Message Description Record
  //----------------------------------------------------------------------------
  ASSOCIATED_MESSAGE(SEPARATED)
  {
    Info
    {
      Pattern = "999.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    SYSTEM                              AscString();
    MESSAGE_SEVERITY                    AscString();
    MESSAGE_ID                          AscString();
    MESSAGE_DESCRIPTION                 AscString();
  }


  //----------------------------------------------------------------------------
  // Trailer Record
  //----------------------------------------------------------------------------
  TRAILER(SEPARATED)
  {
    Info
    {
      Pattern = "090.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    SENDER                              AscString();
    RECIPIENT                           AscString();
    SEQUENCE_NUMBER                     AscInteger();
    ORIGIN_SEQUENCE_NUMBER              AscInteger();
    TOTAL_NUMBER_OF_RECORDS             AscInteger();
    FIRST_CHARGING_START_TIMESTAMP      AscDateUnix();
    FIRST_CHARGING_UTC_TIME_OFFSET      AscString();
    LAST_CHARGING_START_TIMESTAMP       AscDateUnix();
    LAST_CHARGING_UTC_TIME_OFFSET       AscString();
    TOTAL_RETAIL_CHARGED_VALUE          AscDecimal();
    TOTAL_WHOLESALE_CHARGED_VALUE       AscDecimal();
  }
}

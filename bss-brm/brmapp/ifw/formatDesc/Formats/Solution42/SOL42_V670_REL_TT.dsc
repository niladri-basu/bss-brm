//==============================================================================
//
// Copyright (c) 1998, 2014, Oracle and/or its affiliates. All rights reserved.
//
//       This material is the confidential property of Oracle Corporation
//       or its licensors and may be used, reproduced, stored or transmitted
//       only in accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: FMD
//------------------------------------------------------------------------------
// Module Description:
//   Description of the Solution42 V6.70 REL CDR format with Unix timestamps
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
// $RCSfile: SOL42_V670_REL_TT.dsc $
// $Revision: /cgbubrm_7.5.0.pipeline/1 $
// $Author: vinodrao $
// $Date: 2014/11/30 21:55:54 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SOL42_V670_REL.dsc,v $
//==============================================================================

SOL42_V670_REL
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
    UTC_END_TIME_OFFSET	                AscString();
    BATCH_ID				AscString();
    OBJECT_CACHE_TYPE                   AscInteger();
  }

  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL(SEPARATED)
  {
    Info
    {
      Pattern = "(02[0-9]|03[0-1]|04[0-9]|050|060|070|080|12[0-8]|13[0-1]|220|701).*\n";
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
    CREATED_TIMESTAMP                   AscDateUnix();
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
    UTC_END_TIME_OFFSET                 AscString();
    NE_CHARGING_START_TIMESTAMP         AscDateUnix();
    UTC_NE_START_TIME_OFFSET            AscString();
    NE_CHARGING_END_TIMESTAMP           AscDateUnix();
    UTC_NE_END_TIME_OFFSET              AscString();
    INCOMING_ROUTE                      AscString(); 
    ROUTING_CATEGORY                    AscString(); 
    INTERN_PROCESS_STATUS               AscInteger();
    DROPPED_CALL_QUANTITY               AscDecimal();
    DROPPED_CALL_STATUS                 AscInteger();
    LOGICAL_PARTITION_ID		AscInteger(); 
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
    B_CELL_ID                           AscString();
    A_TERM_CELL_ID                      AscString();
    SMSC_ADDRESS                        AscString();
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
    CLIR_INDICATOR                      AscInteger();
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
    START_SEQUENCE_NO                   AscString();
    END_SEQUENCE_NO                     AscString();
    B_CELL_ID                           AscString();
    A_TERM_CELL_ID                      AscString();

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
    GSM_CALL_REFERENCE_NUMBER           AscString();

  }

  //----------------------------------------------------------------------------
  // Associated Infranet Billing record
  //----------------------------------------------------------------------------
  ASSOCIATED_INFRANET(SEPARATED)
  {
    Info
    {
      Pattern = "900.*\t";
      FieldSeparator = '\t';
      RecordSeparator = '\t';
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
    NUMBER_OF_MONITOR_PACKETS           AscInteger();
  }

  //----------------------------------------------------------------------------
  // Associated Infranet Billing record
  // will look like a big field in ASSOCIATED_INFRANET
  //----------------------------------------------------------------------------
  ASSOCIATED_INVOICE_DATA(SEPARATED)
  {
    Info
    {
      Pattern = "@INTEGRATE*<";
      FieldSeparator = '\#';
      RecordSeparator = '<';
    }

    RECORD_TYPE                         AscString();
    A_NUMBER                            AscString();
    B_NUMBER                            AscString();
    BASIC_SERVICE                       AscString();
    NUMBER_OF_UNITS                     AscDecimal();
    USAGE_CLASS                         AscString();
    TERMINATING_SWITCH_IDENTIFICATION   AscString();
    DELIMITATION                        AscString();
  }

  //----------------------------------------------------------------------------
  // Infranet Balance Impact packet inside the Invoice record
  //----------------------------------------------------------------------------
  BALANCE_IMPACT(SEPARATED)
  {
    Info
    {
      Pattern = "\t*\|";
      FieldSeparator = '\#';
      RecordSeparator = '\|';
    }
    ITEM_POID                          AscString();
    PIN_RESOURCE_ID                    AscInteger();
    PIN_QUANTITY                       AscDecimal();
    PIN_RATE_TAG                       AscString();
    PIN_AMOUNT                         AscDecimal();
  }

  //----------------------------------------------------------------------------
  // Infranet Invoice record terminator
  //----------------------------------------------------------------------------
  INVOICE_DATA_TERMINATOR(SEPARATED)
  {
    Info
    {
      Pattern = ">\n";
      FieldSeparator = '\0';
      RecordSeparator = '\n';
    }
    TERMINATOR                        AscString();
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
    PIN_RESOURCE_ID_ORIG                AscInteger();
    PIN_IMPACT_CATEGORY                 AscString();
    PIN_IMPACT_TYPE                 	AscInteger();
    PIN_PRODUCT_POID                    AscString();
    PIN_GL_ID                           AscInteger();
    RUM_ID                              AscInteger();
    PIN_TAX_CODE                        AscString();
    PIN_RATE_TAG                        AscString();
    PIN_LINEAGE                         AscString();
    PIN_OFFERING_POID                   AscString();
    PIN_QUANTITY                        AscDecimal();
    PIN_AMOUNT                          AscDecimal();
    PIN_AMOUNT_ORIG                     AscDecimal();
    PIN_AMOUNT_DEFERRED                 AscDecimal();
    PIN_DISCOUNT                        AscDecimal();
    PIN_PERCENT                         AscDecimal();
    PIN_INFO_STRING                     AscString();
  }
	SUB_BAL_IMPACT(SEPARATED)
	{
    	Info
    	{
      		Pattern = "605.*\n";
      		FieldSeparator = '\t';
      		RecordSeparator = '\n';
    	}
    	RECORD_TYPE                         AscString();
    	RECORD_NUMBER                       AscInteger();
    	BAL_GRP_POID                        AscString();
    	PIN_RESOURCE_ID                     AscInteger();
	}	
	SUB_BAL(SEPARATED)
	{
    	Info
    	{
      		Pattern = "607.*\n";
      		FieldSeparator = '\t';
      		RecordSeparator = '\n';
    	}
    	RECORD_TYPE                         AscString();
    	RECORD_NUMBER                       AscInteger();
    	PIN_AMOUNT                        AscDecimal();
		VALID_FROM        					AscDateUnix();
		VALID_TO        				AscDateUnix();
		CONTRIBUTOR        				AscString();
	}	
	TAX_JURISDICTION(SEPARATED)
	{
    	Info
    	{
      		Pattern = "615.*\n";
      		FieldSeparator = '\t';
      		RecordSeparator = '\n';
    	}
    	RECORD_TYPE                         AscString();
    	RECORD_NUMBER                       AscInteger();
    	PIN_TAX_TYPE                        AscString();
    	PIN_TAX_VALUE                        AscDecimal();
    	PIN_AMOUNT                        AscDecimal();
    	PIN_TAX_RATE                        AscString();
	PIN_AMOUNT_GROSS		  AscDecimal();
	}	

  //----------------------------------------------------------------------------
  // Infranet Monitor Impact packet
  //----------------------------------------------------------------------------
  MONITOR_PACKET(SEPARATED)
  {
    Info
    {
      Pattern = "800.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    ACCOUNT_POID                        AscString();
    BAL_GRP_POID                        AscString();
    PIN_RESOURCE_ID                     AscInteger();
    PIN_AMOUNT                          AscDecimal();
  }
  MONITOR_SUB_BAL_IMPACT(SEPARATED)
  {
    Info
    {
      Pattern = "805.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    BAL_GRP_POID                        AscString();
    PIN_RESOURCE_ID                     AscInteger();
  }
    MONITOR_SUB_BAL(SEPARATED)
    {
      Info
      {
        Pattern = "807.*\n";
        FieldSeparator = '\t';
        RecordSeparator = '\n';
      }
      RECORD_TYPE                         AscString();
      RECORD_NUMBER                       AscInteger();
      PIN_AMOUNT                          AscDecimal();
      VALID_FROM                          AscDateUnix();
      VALID_TO                            AscDateUnix();
      CONTRIBUTOR                         AscString();
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
    OPENING_BALANCE                     AscDecimal();
    CLOSING_BALANCE                     AscDecimal();
  }

  //----------------------------------------------------------------------------
  // RUM Map
  //----------------------------------------------------------------------------
  RUM_MAP(SEPARATED)
  {
    Info
    {
      Pattern = "400.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    RUM_NAME                            AscString();
    NET_QUANTITY                        AscDecimal();
    UNRATED_QUANTITY                    AscDecimal();
  }

  //----------------------------------------------------------------------------
  // Profile event ordering (OOD)
  //----------------------------------------------------------------------------
  PROFILE_EVENT_ORDERING(SEPARATED)
  {
    Info
    {
      Pattern = "850.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    BALANCE_GROUP_POID                  AscString();
    CRITERIA_NAME                       AscString();
    LAST_EVENT_PROCESS_TIMESTAMP        AscDateUnix();
    BILL_CYCLE_TIMESTAMP                AscDateUnix();
    PROFILE_POID                        AscString();
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
    RESOURCE_ID     			AscInteger();
    RESOURCE_ID_ORIG  			AscInteger();
    RUMGROUP                            AscString();
    RUM                                 AscString();
    RUM_ID                              AscInteger();
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
    CHARGED_AMOUNT_VALUE_ORIG           AscDecimal();
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
    PIN_PERCENT			        AscDecimal();
    NUMBER_OF_DISCOUNT_PACKETS          AscInteger();
  }

  DISCOUNT_PACKET(SEPARATED)
  {
    Info
    {
      Pattern = "690.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    RECORD_TYPE   	   		AscString();
    CREATED      			AscString();
    OBJECT_ID      			AscString();
    OBJECT_TYPE      			AscString();
    OBJECT_ACCOUNT     			AscInteger();
    OBJECT_OWNER_ID			AscInteger();
    OBJECT_OWNER_TYPE  			AscString();
    DISCOUNTMODEL      			AscString();
    DISCOUNTRULE      			AscString();
    DISCOUNTSTEPID     			AscInteger();
    DISCOUNTBALIMPACTID     		AscInteger();
    TAX_CODE      			AscString();
    AMOUNT     				AscDecimal();
    PIN_PERCENT  			AscDecimal();
    QUANTITY     			AscDecimal();
    GRANTED_AMOUNT     			AscDecimal();
    GRANTED_AMOUNT_ORIG			AscDecimal();
    GRANTED_QUANTITY     		AscDecimal();
    QUANTITY_FROM     			AscDecimal();
    QUANTITY_TO     			AscDecimal();
    VALID_FROM        			AscDateUnix();
    VALID_TO        			AscDateUnix();
    BALANCE_GROUP_ID      		AscInteger();
    RESOURCE_ID     			AscInteger();
    RESOURCE_ID_ORIG  			AscInteger();
    ZONEMODEL_CODE      		AscString();
    IMPACT_CATEGORY      		AscString();
    SERVICE_CODE      			AscString();
    TIMEZONE_CODE      			AscString();
    TIMEMODEL_CODE      		AscString();
    SERVICE_CLASS      			AscString();
    PRICEMODEL_CODE      		AscString();
    RUM      				AscString();
    RATETAG      			AscString();
    RATEPLAN      			AscString();
    GLID      				AscString();
  }

  TAX_PACKET(SEPARATED)
  {
    Info
    {
      Pattern = "695.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    RECORD_TYPE   	   		AscString();
    RECORD_NUMBER   	   		AscInteger();
    TAX_CODE				AscString();
    TAX_RATE				AscString();
    TAX_VALUE		                AscDecimal();
    TAX_PERCENT		                AscDecimal();
    TAX_VALUE_ORIG	                AscDecimal();
    TAX_TYPE		                AscString();
    CHARGE_TYPE		                AscString();
    TAXABLE_AMOUNT		        AscDecimal();
    TAX_QUANTITY		        AscDecimal();
    RELATED_RECORD_NUMBER	        AscInteger();
    RELATED_CHARGE_INFO_ID	        AscInteger();

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
  // Associated SMS record
  //----------------------------------------------------------------------------
  ASSOCIATED_SMS(SEPARATED)
  {
    Info
    {
      Pattern = "580.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    CONTENT_INDICATOR                   AscString();
    ORIGINATING_SWITCH_IDENTIFICATION   AscString();
    DESTINATION_SWITCH_IDENTIFICATION   AscString();
    PROVIDER_ID                         AscString();
    SERVICE_ID                          AscString();
    DEVICE_NUMBER                       AscString();
    PORT_NUMBER                         AscString();
    DIALED_DIGITS                       AscString();  
  }
  //----------------------------------------------------------------------------
  // Associated MMS record
  //----------------------------------------------------------------------------
  ASSOCIATED_MMS(SEPARATED)  
  {
    Info
    {
      Pattern = "590.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                     AscString();
    RECORD_NUMBER                   AscInteger();
    ACCOUNT_STATUS_TYPE             AscString();
    PRIORITY                        AscString();
    MESSAGE_CONTENT                 AscString();
    MESSAGE_ID                      AscString();
    STATION_IDENTIFIER              AscString();
    FC_INDICATOR                    AscString();
    CORRELATION_ID                  AscString();
    DEVICE_NUMBER                   AscString();
    PORT_NUMBER                     AscString();
    DIALED_DIGITS                   AscString();
    CELL_ID                         AscString();
    B_CELL_ID                       AscString();
    A_TERM_CELL_ID                  AscString();
  }

  //----------------------------------------------------------------------------
  // Associated Suspense Record
  //----------------------------------------------------------------------------
  ASSOCIATED_SUSPENSE(SEPARATED)
  {
    Info
    {
      Pattern = "720.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                   AscInteger();
    SUSPENSE_ID                         AscInteger();
    PIPELINE_NAME                      AscString();
    SOURCE_FILENAME                AscString();
    SERVICE_CODE                      AscString();
    EDR_RECORD_TYPE               AscString();
    ACCOUNT_POID                      AscString();
    OVERRIDE_REASONS             AscString();
    SUSPENDED_FROM_BATCH_ID           AscString();
    RECYCLE_KEY                      AscString();
  }

  //----------------------------------------------------------------------------
  // Associated Roaming Record
  //----------------------------------------------------------------------------
  ASSOCIATED_ROAMING(SEPARATED)
  {
    Info
    {
      Pattern = "721.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();
    RECORD_NUMBER                       AscInteger();
    TAP_FILE_SEQ_NO                     AscInteger();
    RAP_FILE_SEQ_NO                     AscInteger();
    SENDER                              AscString();
    RECIPIENT                           AscString();
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

  //----------------------------------------------------------------------------
  // Associated CIBER record
  //----------------------------------------------------------------------------
  ASSOCIATED_CIBER(SEPARATED)
  {
    Info
    {
      Pattern = "702.*\n";
      RecordSeparator = '\n';
      FieldSeparator = '\t';
    }

    RECORD_TYPE                            AscString;
    RECORD_NUMBER                          AscInteger;
    NO_OCC                                 AscInteger;
    INTERN_MOBILE_ID_NO                    AscString;
    INTERN_CALLED_NO                       AscString;
    INTERN_MSISDN_MDN                      AscString;
    INTERN_CALLER_ID                       AscString;
    INTERN_ROUTING_NO                      AscString;
    INTERN_TLDN_NO                         AscString;
    CIBER_RECORD_TYPE                      AscString;
    RETURN_CODE                            AscString;
    RETURN_REASON_CODE                     AscString;
    INVALID_FIELD_ID                       AscString;
    HOME_CARRIER_SID                       AscString;
    MOBILE_ID_NO_LENGTH                    AscInteger;
    MOBILE_ID_NO                           AscString;
    MOBILE_ID_NO_OVERFLOW                  AscString;
    ELECTRONIC_SERIAL_NO                   AscString;
    CALL_DATE                              AscDateUnix;
    SERVING_CARRIER_SID                    AscString;
    TOTAL_CHARGE_AND_TAX                   AscDecimal;
    TOTAL_STATE_TAX                        AscDecimal;
    TOTAL_LOCAL_TAX                        AscDecimal;
    CALL_DIRECTION                         AscString;
    CALL_COMPLETION_INDICATOR              AscString;
    CALL_TERMINATION_INDICATOR             AscString;
    CALLED_NO_LENGTH                       AscInteger;
    CALLED_NO                              AscString;
    CALLED_NO_OVERFLOW                     AscString;
    TEMP_LOCAL_DIRECTORY_NO                AscString;
    CURRENCY_TYPE                          AscString;
    ORIG_BATCH_SEQ_NO                      AscString;
    INITIAL_CELL_SITE                      AscString;
    TIME_ZONE_INDICATOR                    AscString;
    DAYLIGHT_SAVINGS_INDICATOR             AscString;
    MSG_ACCOUNTING_DIGITS                  AscString;
    SSU_CONNECT_TIME                       AscDateUnix;
    SSU_CHARGEABLE_TIME                    AscString;
    SSU_ELAPSED_TIME                       AscString;
    SSU_RATE_PERIOD                        AscString;
    SSU_MULTIRATE_PERIOD                   AscString;
    SSU_CHARGE                             AscDecimal;
    MISC_SURCHARGE                         AscDecimal;
    MISC_SURCHARGE_DESC                    AscString;
    PRINTED_CALL                           AscString;
    FRAUD_INDICATOR                        AscString;
    FRAUD_SUB_INDICATOR                    AscString;
    LOCAL_CARRIER_RESERVED                 AscString;
    SPECIAL_FEATURES_USED                  AscString;
    CALLED_PLACE                           AscString;
    CALLED_STATE                           AscString;
    SERVING_PLACE                          AscString;
    SERVING_STATE                          AscString;
    RECV_CARRIER_SID                       AscString;
    TRANS_CODE1                            AscString;
    TRANS_CODE2                            AscString;
    SENDING_CARRIER_SID                    AscString;
    CHARGE_NO_1_IND                        AscString;
    CHARGE_NO_1_CONNECT_TIME               AscDateUnix;
    CHARGE_NO_1_CHARGEABLE_TIME            AscString;
    CHARGE_NO_1_ELAPSED_TIME               AscString;
    CHARGE_NO_1_RATE_PERIOD                AscString;
    CHARGE_NO_1_MULTIRATE_PERIOD           AscString;
    CHARGE_NO_1                            AscDecimal;
    CHARGE_NO_2_IND                        AscString;
    CHARGE_NO_2_CONNECT_TIME               AscDateUnix;
    CHARGE_NO_2_CHARGEABLE_TIME            AscString;
    CHARGE_NO_2_ELAPSED_TIME               AscString;
    CHARGE_NO_2_RATE_PERIOD                AscString;
    CHARGE_NO_2_MULTIRATE_PERIOD           AscString;
    CHARGE_NO_2                            AscDecimal;
    CHARGE_NO_3_IND                        AscString;
    CHARGE_NO_3_CONNECT_TIME               AscDateUnix;
    CHARGE_NO_3_CHARGEABLE_TIME            AscString;
    CHARGE_NO_3_ELAPSED_TIME               AscString;
    CHARGE_NO_3_RATE_PERIOD                AscString;
    CHARGE_NO_3_MULTIRATE_PERIOD           AscString;
    CHARGE_NO_3                            AscDecimal;
    CHARGE_NO_4_IND                        AscString;
    CHARGE_NO_4_CONNECT_TIME               AscDateUnix;
    CHARGE_NO_4_CHARGEABLE_TIME            AscString;
    CHARGE_NO_4_ELAPSED_TIME               AscString;
    CHARGE_NO_4_RATE_PERIOD                AscString;
    CHARGE_NO_4_MULTIRATE_PERIOD           AscString;
    CHARGE_NO_4                            AscDecimal;
    CHARGE_NO_1_SURCHARGE_IND              AscString;
    CHARGE_NO_2_SURCHARGE_IND              AscString;
    CHARGE_NO_3_SURCHARGE_IND              AscString;
    CHARGE_NO_4_SURCHARGE_IND              AscString;
    TOLL_CONNECT_TIME                      AscDateUnix;
    TOLL_CHARGEABLE_TIME                   AscString;
    TOLL_ELAPSED_TIME                      AscString;
    TOLL_TARIFF_DESC                       AscString;
    TOLL_RATE_PERIOD                       AscString;
    TOLL_MULTIRATE_PERIOD                  AscString;
    TOLL_RATE_CLASS                        AscString;
    TOLL_FROM_RATING_NPA_NXX               AscString;
    TOLL_CHARGE                            AscDecimal;
    TOLL_STATE_TAX                         AscDecimal;
    TOLL_LOCAL_TAX                         AscDecimal;
    TOLL_NETWORK_CARRIER_ID                AscString;
    MSID_INDICATOR                         AscString;
    MSID                                   AscString;
    MSISDN_MDN_LENGTH                      AscInteger;
    MSISDN_MDN                             AscString;
    ESN_IMEI_INDICATOR                     AscString;
    ESN_IMEI                               AscString;
    CALLER_ID_LENGTH                       AscInteger;
    CALLER_ID                              AscString;
    ROUTING_NO_LENGTH                      AscInteger;
    ROUTING_NO                             AscString;
    TLDN_NO_LENGTH                         AscInteger;
    TLDN_NO                                AscString;
    AIR_CONNECT_TIME                       AscDateUnix;
    AIR_CHARGEABLE_TIME                    AscString;
    AIR_ELAPSED_TIME                       AscString;
    AIR_RATE_PERIOD                        AscString;
    AIR_MULTIRATE_PERIOD                   AscString;
    AIR_CHARGE                             AscDecimal;
    OTHER_CHARGE_1_INDICATOR               AscString;
    OTHER_CHARGE_1                         AscDecimal;
    CALLED_COUNTRY                         AscString;
    SERVING_COUNTRY                        AscString;
    TOLL_RATING_POINT_LENGTH               AscInteger;
    TOLL_RATING_POINT                      AscString;
    FEATURE_USED_AFTER_HO_IND              AscString;
    OCC_START_DATE                         AscDateUnix;
    OCC_CHARGE                             AscDecimal;
    FET_EXEMPT_INDICATOR                   AscString;
    PASS_THROUGH_CHARGE_IND                AscString;
    CONNECT_TIME                           AscDateUnix;
    RECORD_USE_INDICATOR                   AscString;
    OCC_DESCRIPTION                        AscString;
    OCC_END_DATE                           AscDateUnix;
    RECORD_CREATE_DATE                     AscDateUnix;
    SEQ_INDICATOR                          AscString;
    OCC_INTERVAL_INDICATOR                 AscString;
    EVENT_DATE                             AscDateUnix;
    MIN_ESN_APP_INDICATOR                  AscString;
    R70_RECORD_USE_INDICATOR               AscString;
    EVENT_TIME                             AscDateUnix;
  }
}

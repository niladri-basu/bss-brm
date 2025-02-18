//=================================================================================================================================
//
//      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
//      
//      This material is the confidential property of Oracle Corporation or its
//      licensors and may be used, reproduced, stored or transmitted only in
//      accordance with a valid Oracle license or sublicense agreement.
//
//---------------------------------------------------------------------------------------------------------------------------------
// Alias field list according to sol42-CDR/EDR/IDR-Format v4-30-xx
// for container fields see also "containerDesc.dsc"
//---------------------------------------------------------------------------------------------------------------------------------
// Notes:
// The 1st colomn contains the internal container field in "."-notation (e.g. DETAIL.A_NUMBER).
// The "->" means, that the internal container field references to the given alias name. The alias name
// is given on the right hand side of "->"
//    
//---------------------------------------------------------------------------------------------------------------------------------
// Responsible: Jochen Bischoff
//
// $RCSfile: AliasFieldList.dsc,v $
// $Revision: 1.14 $
// $Author: cdiab $
// $Date: 2002/03/12 18:04:55 $
// $Locker:  $
//---------------------------------------------------------------------------------------------------------------------------------


// ===========================================
// HEADER
// ===========================================

HEADER.RECORD_LENGTH                                          ->          HDR_RECORD_LENGTH
HEADER.RECORD_TYPE                                            ->          HDR_RECORD_TYPE
HEADER.RECORD_NUMBER                                          ->          HDR_RECORD_NUMBER
HEADER.SENDER                                                 ->          HDR_SENDER
HEADER.RECIPIENT                                              ->          HDR_RECIPIENT
HEADER.SEQUENCE_NUMBER                                        ->          HDR_SEQUENCE_NUMBER
HEADER.ORIGIN_SEQUENCE_NUMBER                                 ->          HDR_ORIGIN_SEQUENCE_NUMBER
HEADER.CREATION_TIMESTAMP                                     ->          CREATION_TIMESTAMP
HEADER.TRANSMISSION_DATE                                      ->          TRANSMISSION_DATE
HEADER.TRANSFER_CUTOFF_TIMESTAMP                              ->          TRANSFER_CUTOFF_TIMESTAMP
HEADER.UTC_TIME_OFFSET                                        ->          HDR_UTC_TIME_OFFSET
HEADER.SPECIFICATION_VERSION_NUMBER                           ->          SPECIFICATION_VERSION_NUMBER
HEADER.RELEASE_VERSION                                        ->          RELEASE_VERSION
HEADER.ORIGIN_COUNTRY_CODE                                    ->          ORIGIN_COUNTRY_CODE
HEADER.SENDER_COUNTRY_CODE                                    ->          SENDER_COUNTRY_CODE
HEADER.DATA_TYPE_INDICATOR                                    ->          DATA_TYPE_INDICATOR
HEADER.IAC_LIST                                               ->          HDR_IAC_LIST
HEADER.CC_LIST                                                ->          HDR_CC_LIST
HEADER.TAP_DECIMAL_PLACES                                     ->          HDR_TAP_DECIMAL_PLACES
HEADER.OPERATOR_SPECIFIC_INFO                                 ->          HDR_OPERATOR_SPECIFIC_INFO
HEADER.UTC_END_TIME_OFFSET                                    ->          HDR_UTC_END_TIME_OFFSET

// ===========================================
// BASIC DETAIL RECORD
// ===========================================

DETAIL.RECORD_LENGTH                                          ->          BDR_RECORD_LENGTH
DETAIL.RECORD_TYPE                                            ->          BDR_RECORD_TYPE
DETAIL.RECORD_NUMBER                                          ->          BDR_RECORD_NUMBER
DETAIL.DISCARDING                                             ->          DISCARDING
DETAIL.CHAIN_REFERENCE                                        ->          CHAIN_REFERENCE
DETAIL.SOURCE_NETWORK_TYPE                                    ->          SOURCE_NETWORK_TYPE
DETAIL.SOURCE_NETWORK                                         ->          SOURCE_NETWORK
DETAIL.DESTINATION_NETWORK_TYPE                               ->          DESTINATION_NETWORK_TYPE
DETAIL.DESTINATION_NETWORK                                    ->          DESTINATION_NETWORK
DETAIL.TYPE_OF_A_IDENTIFICATION                               ->          TYPE_OF_A_IDENTIFICATION
DETAIL.A_MODIFICATION_INDICATOR                               ->          A_MODIFICATION_INDICATOR
DETAIL.A_TYPE_OF_NUMBER                                       ->          A_TYPE_OF_NUMBER
DETAIL.A_NUMBERING_PLAN                                       ->          A_NUMBERING_PLAN
DETAIL.A_NUMBER                                               ->          A_NUMBER
DETAIL.B_MODIFICATION_INDICATOR                               ->          B_MODIFICATION_INDICATOR
DETAIL.B_TYPE_OF_NUMBER                                       ->          B_TYPE_OF_NUMBER
DETAIL.B_NUMBERING_PLAN                                       ->          B_NUMBERING_PLAN
DETAIL.B_NUMBER                                               ->          B_NUMBER
DETAIL.DESCRIPTION                                            ->          DESCRIPTION
DETAIL.C_MODIFICATION_INDICATOR                               ->          C_MODIFICATION_INDICATOR
DETAIL.C_TYPE_OF_NUMBER                                       ->          C_TYPE_OF_NUMBER
DETAIL.C_NUMBERING_PLAN                                       ->          C_NUMBERING_PLAN
DETAIL.C_NUMBER                                               ->          C_NUMBER
DETAIL.USAGE_DIRECTION                                        ->          USAGE_DIRECTION
DETAIL.CONNECT_TYPE                                           ->          CONNECT_TYPE
DETAIL.CONNECT_SUB_TYPE                                       ->          CONNECT_SUB_TYPE
DETAIL.CALLED_COUNTRY_CODE                                    ->          CALLED_COUNTRY_CODE
DETAIL.BASIC_SERVICE                                          ->          BASIC_SERVICE
DETAIL.QOS_REQUESTED                                          ->          QOS_REQUESTED
DETAIL.QOS_USED                                               ->          QOS_USED
DETAIL.CALL_COMPLETION_INDICATOR                              ->          CALL_COMPLETION_INDICATOR
DETAIL.LONG_DURATION_INDICATOR                                ->          LONG_DURATION_INDICATOR
DETAIL.CHARGING_START_TIMESTAMP                               ->          BDR_CHARGING_START_TIMESTAMP
DETAIL.CHARGING_END_TIMESTAMP                                 ->          CHARGING_END_TIMESTAMP
DETAIL.UTC_TIME_OFFSET                                        ->          BDR_UTC_TIME_OFFSET
DETAIL.DURATION                                               ->          DURATION
DETAIL.DURATION_UOM                                           ->          DURATION_UOM
DETAIL.VOLUME_SENT                                            ->          VOLUME_SENT
DETAIL.VOLUME_SENT_UOM                                        ->          VOLUME_SENT_UOM
DETAIL.VOLUME_RECEIVED                                        ->          VOLUME_RECEIVED
DETAIL.VOLUME_RECEIVED_UOM                                    ->          VOLUME_RECEIVED_UOM
DETAIL.NUMBER_OF_UNITS                                        ->          NUMBER_OF_UNITS
DETAIL.NUMBER_OF_UNITS_UOM                                    ->          NUMBER_OF_UNITS_UOM
DETAIL.RETAIL_IMPACT_CATEGORY                                 ->          RETAIL_IMPACT_CATEGORY
DETAIL.RETAIL_CHARGED_AMOUNT_VALUE                            ->          RETAIL_CHARGED_AMOUNT_VALUE
DETAIL.RETAIL_CHARGED_AMOUNT_CURRENCY                         ->          RETAIL_CHARGED_AMOUNT_CURRENCY
DETAIL.RETAIL_CHARGED_TAX_TREATMENT                           ->          RETAIL_CHARGED_TAX_TREATMENT
DETAIL.RETAIL_CHARGED_TAX_RATE                                ->          RETAIL_CHARGED_TAX_RATE
DETAIL.RETAIL_CHARGED_TAX_VALUE                               ->          RETAIL_CHARGED_TAX_VALUE
DETAIL.WHOLESALE_IMPACT_CATEGORY                              ->          WHOLESALE_IMPACT_CATEGORY
DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE                         ->          WHOLESALE_CHARGED_AMOUNT_VALUE
DETAIL.WHOLESALE_CHARGED_AMOUNT_CURRENCY                      ->          WHOLESALE_CHARGED_AMOUNT_CURRENCY
DETAIL.WHOLESALE_CHARGED_TAX_TREATMENT                        ->          WHOLESALE_CHARGED_TAX_TREATMENT
DETAIL.WHOLESALE_CHARGED_TAX_RATE                             ->          WHOLESALE_CHARGED_TAX_RATE
DETAIL.WHOLESALE_CHARGED_TAX_VALUE                            ->          WHOLESALE_CHARGED_TAX_VALUE
DETAIL.TARIFF_CLASS                                           ->          TARIFF_CLASS
DETAIL.TARIFF_SUB_CLASS                                       ->          TARIFF_SUB_CLASS
DETAIL.USAGE_CLASS                                            ->          USAGE_CLASS
DETAIL.USAGE_TYPE                                             ->          USAGE_TYPE
DETAIL.BILLCYCLE_PERIOD                                       ->          BILLCYCLE_PERIOD
DETAIL.PREPAID_INDICATOR                                      ->          PREPAID_INDICATOR
DETAIL.NUMBER_ASSOCIATED_RECORDS                              ->          NUMBER_ASSOCIATED_RECORDS
DETAIL.ERROR_REJECT_TYPE                                      ->          ERROR_REJECT_TYPE
DETAIL.OPERATOR_SPECIFIC_INFO                                 ->          BDR_OPERATOR_SPECIFIC_INFO
DETAIL.NE_CHARGING_START_TIMESTAMP                            ->          BDR_NE_CHARGING_START_TIMESTAMP
DETAIL.NE_CHARGING_END_TIMESTAMP                                          BDR_NE_CHARGING_END_TIMESTAMP
DETAIL.UTC_NE_START_TIME_OFFSET                               ->          BDR_UTC_NE_START_TIME_OFFSET 
DETAIL.UTC_NE_END_TIME_OFFSET                                 ->          BDR_UTC_NE_END_TIME_OFFSET   
DETAIL.UTC_END_TIME_OFFSET                                    ->          BDR_UTC_END_TIME_OFFSET      
DETAIL.INCOMING_ROUTE                                         ->          BDR_INCOMING_ROUTE           
DETAIL.ROUTING_CATEGORY                                       ->          BDR_ROUTING_CATEGORY         
DETAIL.SERVICE_TYPE                                           ->          BDR_SERVICE_TYPE         
DETAIL.EVENT_TYPE                                             ->          BDR_EVENT_TYPE         

DETAIL.INTERN_A_NUMBER_ZONE                                   ->          INTERN_A_NUMBER_ZONE
DETAIL.INTERN_B_NUMBER_ZONE                                   ->          INTERN_B_NUMBER_ZONE
DETAIL.INTERN_C_NUMBER_ZONE                                   ->          INTERN_C_NUMBER_ZONE
DETAIL.INTERN_SERVICE_CODE                                    ->          INTERN_SERVICE_CODE
DETAIL.INTERN_SERVICE_CLASS                                   ->          INTERN_SERVICE_CLASS
DETAIL.INTERN_USAGE_CLASS                                     ->          INTERN_USAGE_CLASS
DETAIL.INTERN_ZONE_MODEL                                      ->          BDR_INTERN_ZONE_MODEL
DETAIL.INTERN_NETWORK_MODEL                                   ->          INTERN_NETWORK_MODEL
DETAIL.INTERN_NETWORK_OPERATOR                                ->          INTERN_NETWORK_OPERATOR
DETAIL.INTERN_APN_GROUP                                       ->          BDR_INTERN_APN_GROUP
DETAIL.INTERN_BILLING_CURRENCY                                ->          INTERN_BILLING_CURRENCY
DETAIL.INTERN_HOME_CURRENCY                                   ->          INTERN_HOME_CURRENCY
DETAIL.INTERN_SLA_USC_GROUP                                   ->          INTERN_SLA_USC_GROUP
DETAIL.INTERN_SLA_RSC_GROUP                                   ->          INTERN_SLA_RSC_GROUP
DETAIL.INTERN_SLA_IRULE_SET                                   ->          INTERN_SLA_IRULE_SET
DETAIL.INTERN_PROCESS_STATUS                                  ->          INTERN_PROCESS_STATUS
DETAIL.INTERN_BALANCE_GROUP_ID                                ->          INTERN_BALANCE_GROUP_ID 
DETAIL.INTERN_DISCOUNT_OWNER_ACCT_ID                          ->          INTERN_DISCOUNT_OWNER_ACCT_ID 
DETAIL.INTERN_SERVICE_BILL_INFO_ID                            ->          INTERN_SERVICE_BILL_INFO_ID 



// ===========================================
// ASSOCIATED GSM / WIRELINE EXTENSION RECORD
// ===========================================

DETAIL.ASS_GSMW_EXT                                           ->          ASS_GSMW
DETAIL.ASS_GSMW_EXT.RECORD_TYPE                               ->          ASS_GSMW_RECORD_TYPE
DETAIL.ASS_GSMW_EXT.RECORD_NUMBER                             ->          ASS_GSMW_RECORD_NUMBER
DETAIL.ASS_GSMW_EXT.PORT_NUMBER                               ->          ASS_GSMW_PORT_NUMBER
DETAIL.ASS_GSMW_EXT.DEVICE_NUMBER                             ->          ASS_GSMW_DEVICE_NUMBER
DETAIL.ASS_GSMW_EXT.A_NUMBER_USER                             ->          A_NUMBER_USER
DETAIL.ASS_GSMW_EXT.DIALED_DIGITS                             ->          DIALED_DIGITS
DETAIL.ASS_GSMW_EXT.BASIC_DUAL_SERVICE                        ->          BASIC_DUAL_SERVICE
DETAIL.ASS_GSMW_EXT.VAS_PRODUCT_CODE                          ->          ASS_GSMW_VAS_PRODUCT_CODE
DETAIL.ASS_GSMW_EXT.ORIGINATING_SWITCH_IDENTIFICATION         ->          ASS_GSMW_ORIGINATING_SWITCH_IDENTIFICATION
DETAIL.ASS_GSMW_EXT.TERMINATING_SWITCH_IDENTIFICATION         ->          ASS_GSMW_TERMINATING_SWITCH_IDENTIFICATION
DETAIL.ASS_GSMW_EXT.TRUNK_INPUT                               ->          TRUNK_INPUT
DETAIL.ASS_GSMW_EXT.TRUNK_OUTPUT	                      ->          TRUNK_OUTPUT
DETAIL.ASS_GSMW_EXT.LOCATION_AREA_INDICATOR	              ->          ASS_GSMW_LOCATION_AREA_INDICATOR
DETAIL.ASS_GSMW_EXT.CELL_ID                                   ->          ASS_GSMW_CELL_ID
DETAIL.ASS_GSMW_EXT.MS_CLASS_MARK                             ->          ASS_GSMW_MS_CLASS_MARK
DETAIL.ASS_GSMW_EXT.TIME_BEFORE_ANSWER                        ->          TIME_BEFORE_ANSWER
DETAIL.ASS_GSMW_EXT.BASIC_AOC_AMOUNT_VALUE                    ->          BASIC_AOC_AMOUNT_VALUE
DETAIL.ASS_GSMW_EXT.BASIC_AOC_AMOUNT_CURRENCY                 ->          BASIC_AOC_AMOUNT_CURRENCY
DETAIL.ASS_GSMW_EXT.ROAMER_AOC_AMOUNT_VALUE                   ->          ROAMER_AOC_AMOUNT_VALUE
DETAIL.ASS_GSMW_EXT.ROAMER_AOC_AMOUNT_CURRENCY                ->          ROAMER_AOC_AMOUNT_CURRENCY
DETAIL.ASS_GSMW_EXT.NUMBER_OF_SS_PACKETS                      ->          NUMBER_OF_SS_PACKETS
DETAIL.ASS_GSMW_EXT.SS_PACKET                                 ->          ASS_GSMW_SS_PACKET 
DETAIL.ASS_GSMW_EXT.SS_PACKET.ACTION_CODE                     ->          ACTION_CODE
DETAIL.ASS_GSMW_EXT.SS_PACKET.SS_EVENT                        ->          SS_EVENT
DETAIL.ASS_GSMW_EXT.B_CELL_ID                                 ->          ASS_GSMW_B_CELL_ID
DETAIL.ASS_GSMW_EXT.A_TERM_CELL_ID                            ->          ASS_GSMW_A_TERM_CELL_ID

// ===========================================
// ASSOCIATED GPRS EXTENSION RECORD
// ===========================================

DETAIL.ASS_GPRS_EXT                                           ->          ASS_GPRS
DETAIL.ASS_GPRS_EXT.RECORD_TYPE                               ->          ASS_GPRS_RECORD_TYPE
DETAIL.ASS_GPRS_EXT.RECORD_NUMBER                             ->          ASS_GPRS_RECORD_TYPE
DETAIL.ASS_GPRS_EXT.PORT_NUMBER                               ->          ASS_GPRS_PORT_NUMBER
DETAIL.ASS_GPRS_EXT.DEVICE_NUMBER                             ->          ASS_GPRS_DEVICE_NUMBER
DETAIL.ASS_GPRS_EXT.VAS_PRODUCT_CODE                          ->          ASS_GPRS_VAS_PRODUCT_CODE
DETAIL.ASS_GPRS_EXT.ORIGINATING_SWITCH_IDENTIFICATION         ->          ASS_GPRS_ORIGINATING_SWITCH_IDENTIFICATION
DETAIL.ASS_GPRS_EXT.TERMINATING_SWITCH_IDENTIFICATION         ->          ASS_GPRS_TERMINATING_SWITCH_IDENTIFICATION
DETAIL.ASS_GPRS_EXT.MS_CLASS_MARK                             ->          ASS_GPRS_MS_CLASS_MARK
DETAIL.ASS_GPRS_EXT.ROUTING_AREA                              ->          ROUTING_AREA
DETAIL.ASS_GPRS_EXT.LOCATION_AREA_INDICATOR                   ->          ASS_GPRS_LOCATION_AREA_INDICATOR
DETAIL.ASS_GPRS_EXT.CHARGING_ID                               ->          ASS_GPRS_CHARGING_ID
DETAIL.ASS_GPRS_EXT.SGSN_ADDRESS                              ->          SGSN_ADDRESS
DETAIL.ASS_GPRS_EXT.GGSN_ADDRESS                              ->          ASS_GPRS_GGSN_ADDRESS
DETAIL.ASS_GPRS_EXT.APN_ADDRESS                               ->          APN_ADDRESS
DETAIL.ASS_GPRS_EXT.NODE_ID                                   ->          NODE_ID
DETAIL.ASS_GPRS_EXT.TRANS_ID                                  ->          TRANS_ID
DETAIL.ASS_GPRS_EXT.SUB_TRANS_ID                              ->          SUB_TRANS_ID
DETAIL.ASS_GPRS_EXT.NETWORK_INITIATED_PDP                     ->          NETWORK_INITIATED_PDP
DETAIL.ASS_GPRS_EXT.PDP_TYPE                                  ->          PDP_TYPE
DETAIL.ASS_GPRS_EXT.PDP_ADDRESS                               ->          PDP_ADDRESS
DETAIL.ASS_GPRS_EXT.PDP_REMOTE_ADDRESS                        ->          PDP_REMOTE_ADDRESS
DETAIL.ASS_GPRS_EXT.PDP_DYNAMIC_ADDRESS                       ->          PDP_DYNAMIC_ADDRESS
DETAIL.ASS_GPRS_EXT.DIAGNOSTICS                               ->          DIAGNOSTICS
DETAIL.ASS_GPRS_EXT.CELL_ID                                   ->          ASS_GPRS_CELL_ID
DETAIL.ASS_GPRS_EXT.CHANGE_CONDITION                          ->          CHANGE_CONDITION
DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_PRECEDENCE                  ->          QOS_REQUESTED_PRECEDENCE
DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_DELAY                       ->          QOS_REQUESTED_DELAY
DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_RELIABILITY                 ->          QOS_REQUESTED_RELIABILITY
DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_PEAK_THROUGHPUT             ->          QOS_REQUESTED_PEAK_THROUGHPUT
DETAIL.ASS_GPRS_EXT.QOS_REQUESTED_MEAN_THROUGHPUT             ->          QOS_REQUESTED_MEAN_THROUGHPUT
DETAIL.ASS_GPRS_EXT.QOS_USED_PRECEDENCE                       ->          QOS_USED_PRECEDENCE
DETAIL.ASS_GPRS_EXT.QOS_USED_DELAY                            ->          QOS_USED_DELAY
DETAIL.ASS_GPRS_EXT.QOS_USED_RELIABILITY                      ->          QOS_USED_RELIABILITY
DETAIL.ASS_GPRS_EXT.QOS_USED_PEAK_THROUGHPUT                  ->          QOS_USED_PEAK_THROUGHPUT
DETAIL.ASS_GPRS_EXT.QOS_USED_MEAN_THROUGHPUT                  ->          QOS_USED_MEAN_THROUGHPUT
DETAIL.ASS_GPRS_EXT.NETWORK_CAPABILITY                        ->          NETWORK_CAPABILITY
DETAIL.ASS_GPRS_EXT.SGSN_CHANGE                               ->          SGSN_CHANGE
DETAIL.ASS_GPRS_EXT.START_SEQUENCE_NO                         ->          ASS_GPRS_START_SEQUENCE_NO
DETAIL.ASS_GPRS_EXT.END_SEQUENCE_NO                           ->          ASS_GPRS_END_SEQUENCE_NO
DETAIL.ASS_GPRS_EXT.B_CELL_ID                                 ->          ASS_GPRS_B_CELL_ID
DETAIL.ASS_GPRS_EXT.A_TERM_CELL_ID                            ->          ASS_GPRS_A_TERM_CELL_ID

// ===========================================
// ASSOCIATED WAP EXTENSION RECORD
// ===========================================

DETAIL.ASS_WAP_EXT                                            ->          ASS_WAP
DETAIL.ASS_WAP_EXT.RECORD_TYPE                                ->          ASS_WAP_RECORD_TYPE
DETAIL.ASS_WAP_EXT.RECORD_NUMBER                              ->          ASS_WAP_RECORD_NUMBER
DETAIL.ASS_WAP_EXT.PORT_NUMBER                                ->          ASS_WAP_PORT_NUMBER
DETAIL.ASS_WAP_EXT.DEVICE_NUMBER                              ->          ASS_WAP_DEVICE_NUMBER
DETAIL.ASS_WAP_EXT.SESSION_ID                                 ->          SESSION_ID
DETAIL.ASS_WAP_EXT.RECORDING_ENTITY                           ->          RECORDING_ENTITY
DETAIL.ASS_WAP_EXT.TERMINAL_CLIENT_ID                         ->          TERMINAL_CLIENT_ID
DETAIL.ASS_WAP_EXT.TERMINAL_IP_ADDRESS                        ->          TERMINAL_IP_ADDRESS
DETAIL.ASS_WAP_EXT.DOMAIN_URL                                 ->          DOMAIN_URL
DETAIL.ASS_WAP_EXT.BEARER_SERVICE                             ->          BEARER_SERVICE
DETAIL.ASS_WAP_EXT.HTTP_STATUS                                ->          HTTP_STATUS
DETAIL.ASS_WAP_EXT.WAP_STATUS                                 ->          WAP_STATUS
DETAIL.ASS_WAP_EXT.ACKNOWLEDGE_STATUS                         ->          ACKNOWLEDGE_STATUS
DETAIL.ASS_WAP_EXT.ACKNOWLEDGE_TIME                           ->          ACKNOWLEDGE_TIME
DETAIL.ASS_WAP_EXT.EVENT_NUMBER                               ->          EVENT_NUMBER
DETAIL.ASS_WAP_EXT.GGSN_ADDRESS                               ->          ASS_WAP_GGSN_ADDRESS
DETAIL.ASS_WAP_EXT.SERVER_TYPE                                ->          SERVER_TYPE
DETAIL.ASS_WAP_EXT.CHARGING_ID                                ->          ASS_WAP_CHARGING_ID
DETAIL.ASS_WAP_EXT.WAP_LOGIN                                  ->          WAP_LOGIN


// ===========================================
// ASSOCIATED CAMEL EXTENSION RECORD
// ===========================================

DETAIL.ASS_CAMEL_EXT                                          ->          ASS_CAMEL
DETAIL.ASS_CAMEL_EXT.RECORD_TYPE                              ->          ASS_CAMEL_RECORD_TYPE
DETAIL.ASS_CAMEL_EXT.RECORD_NUMBER                            ->          ASS_CAMEL_RECORD_NUMBER
DETAIL.ASS_CAMEL_EXT.SERVER_TYPE_OF_NUMBER                    ->          ASS_CAMEL_SERVER_TYPE_OF_NUMBER
DETAIL.ASS_CAMEL_EXT.SERVER_NUMBERING_PLAN                    ->          ASS_CAMEL_SERVER_NUMBERING_PLAN
DETAIL.ASS_CAMEL_EXT.SERVER_ADDRESS                           ->          ASS_CAMEL_SERVER_ADDRESS
DETAIL.ASS_CAMEL_EXT.SERVICE_LEVEL                            ->          ASS_CAMEL_SERVICE_LEVEL
DETAIL.ASS_CAMEL_EXT.SERVICE_KEY                              ->          ASS_CAMEL_SERVICE_KEY
DETAIL.ASS_CAMEL_EXT.DEFAULT_CALL_HANDLING_INDICATOR          ->          ASS_CAMEL_DEFAULT_CALL_HANDLING_INDICATOR
DETAIL.ASS_CAMEL_EXT.MSC_TYPE_OF_NUMBER                       ->          ASS_CAMEL_MSC_TYPE_OF_NUMBER
DETAIL.ASS_CAMEL_EXT.MSC_NUMBERING_PLAN                       ->          ASS_CAMEL_MSC_NUMBERING_PLAN
DETAIL.ASS_CAMEL_EXT.MSC_ADDRESS                              ->          ASS_CAMEL_MSC_ADDRESS
DETAIL.ASS_CAMEL_EXT.CAMEL_REFERENCE_NUMBER                   ->          ASS_CAMEL_REFERENCE_NUMBER
DETAIL.ASS_CAMEL_EXT.CAMEL_INITIATED_CF_INDICATOR             ->          ASS_CAMEL_INITIATED_CF_INDICATOR
DETAIL.ASS_CAMEL_EXT.CAMEL_MODIFICATION_LIST                  ->          ASS_CAMEL_MODIFICATION_LIST
DETAIL.ASS_CAMEL_EXT.DEST_GSMW_TYPE_OF_NUMBER                 ->          ASS_CAMEL_DEST_GSMW_TYPE_OF_NUMBER
DETAIL.ASS_CAMEL_EXT.DEST_GSMW_NUMBERING_PLAN                 ->          ASS_CAMEL_DEST_GSMW_NUMBERING_PLAN
DETAIL.ASS_CAMEL_EXT.DEST_GSMW_NUMBER                         ->          ASS_CAMEL_DEST_GSMW_NUMBER
DETAIL.ASS_CAMEL_EXT.DEST_GSMW_NUMBER_ORIGINAL                ->          ASS_CAMEL_DEST_GSMW_NUMBER_ORIGINAL
DETAIL.ASS_CAMEL_EXT.DEST_GPRS_APN_ADDRESS                    ->          ASS_CAMEL_DEST_GPRS_APN_ADDRESS
DETAIL.ASS_CAMEL_EXT.DEST_GPRS_PDP_REMOTE_ADDRESS             ->          ASS_CAMEL_DEST_GPRS_PDP_REMOTE_ADDRESS
DETAIL.ASS_CAMEL_EXT.CSE_INFORMATION                          ->          ASS_CAMEL_CSE_INFORMATION
DETAIL.ASS_CAMEL_EXT.GSM_CALL_REFERENCE_NUMBER                ->          ASS_CAMEL_GSM_CALL_REFERENCE_NUMBER


// ===========================================
// ASSOCIATED INFRANET BILLING RECORD
// ===========================================

DETAIL.ASS_PIN                                                ->          ASS_PIN
DETAIL.ASS_PIN.RECORD_TYPE                                    ->          ASS_PIN_RECORD_TYPE
DETAIL.ASS_PIN.RECORD_NUMBER                                  ->          ASS_PIN_RECORD_NUMBER
DETAIL.ASS_PIN.ACCOUNT_POID                                   ->          ACCOUNT_POID
DETAIL.ASS_PIN.SERVICE_POID                                   ->          SERVICE_POID
DETAIL.ASS_PIN.ITEM_POID                                      ->          ITEM_POID
DETAIL.ASS_PIN.PIN_TAX_LOCALES                                ->          TAX_LOCALES
DETAIL.ASS_PIN.PIN_TAX_SUPPLIER_ID                            ->          TAX_SUPPLIER_ID
DETAIL.ASS_PIN.PROVIDER_ID                                    ->          PROVIDER_ID
DETAIL.ASS_PIN.NUMBER_OF_BALANCE_PACKETS                      ->          NUMBER_OF_BALANCE_PACKETS
DETAIL.ASS_PIN.BP                                             ->          ASS_PIN_BALANCE_PACKET
DETAIL.ASS_PIN.BP.PIN_RESOURCE_ID                             ->          PIN_RESOURCE_ID
DETAIL.ASS_PIN.BP.PIN_IMPACT_CATEGORY                         ->          PIN_IMPACT_CATEGORY
DETAIL.ASS_PIN.BP.PIN_PRODUCT_POID                            ->          PIN_PRODUCT_POID
DETAIL.ASS_PIN.BP.PIN_GL_ID                                   ->          PIN_GL_ID
DETAIL.ASS_PIN.BP.PIN_TAX_CODE                                ->          PIN_TAX_CODE
DETAIL.ASS_PIN.BP.PIN_RATE_TAG                                ->          PIN_RATE_TAG
DETAIL.ASS_PIN.BP.PIN_LINEAGE                                 ->          PIN_LINEAGE
DETAIL.ASS_PIN.BP.PIN_NODE_LOCATION                           ->          PIN_NODE_LOCATION
DETAIL.ASS_PIN.BP.PIN_QUANTITY                                ->          PIN_QUANTITY
DETAIL.ASS_PIN.BP.PIN_AMOUNT                                  ->          PIN_AMOUNT
DETAIL.ASS_PIN.BP.PIN_DISCOUNT                                ->          PIN_DISCOUNT


// ===========================================
// ASSOCIATED ZONE BREAKDOWN RECORD
// ===========================================

DETAIL.ASS_ZBD                                                ->          ASS_ZBD
DETAIL.ASS_ZBD.RECORD_LENGTH                                  ->          ASS_ZBD_RECORD_LENGTH
DETAIL.ASS_ZBD.RECORD_TYPE                                    ->          ASS_ZBD_RECORD_TYPE
DETAIL.ASS_ZBD.RECORD_NUMBER                                  ->          ASS_ZBD_RECORD_NUMBER
DETAIL.ASS_ZBD.CONTRACT_CODE                                  ->          ASS_ZBD_CONTRACT_CODE
DETAIL.ASS_ZBD.SEGMENT_CODE                                   ->          ASS_ZBD_SEGMENT_CODE
DETAIL.ASS_ZBD.CUSTOMER_CODE                                  ->          ASS_ZBD_CUSTOMER_CODE
DETAIL.ASS_ZBD.ACCOUNT_CODE                                   ->          ASS_ZBD_ACCOUNT_CODE
DETAIL.ASS_ZBD.SYSTEM_BRAND_CODE                              ->          ASS_ZBD_SYSTEM_BRAND_CODE
DETAIL.ASS_ZBD.SERVICE_CODE                                   ->          ASS_ZBD_SERVICE_CODE
DETAIL.ASS_ZBD.CUSTOMER_RATEPLAN_CODE                         ->          ASS_ZBD_CUSTOMER_RATEPLAN_CODE
DETAIL.ASS_ZBD.SLA_CODE                                       ->          ASS_ZBD_SLA_CODE
DETAIL.ASS_ZBD.CUSTOMER_BILLCYCLE                             ->          ASS_ZBD_CUSTOMER_BILLCYCLE
DETAIL.ASS_ZBD.CUSTOMER_CURRENCY                              ->          ASS_ZBD_CUSTOMER_CURRENCY
DETAIL.ASS_ZBD.CUSTOMER_TAXGROUP                              ->          ASS_ZBD_CUSTOMER_TAXGROUP
DETAIL.ASS_ZBD.NUMBER_OF_ZONE_PACKETS                         ->          NUMBER_OF_ZONE_PACKETS
DETAIL.ASS_ZBD.ZP                                             ->          ASS_ZBD_ZONE_PACKET    
DETAIL.ASS_ZBD.ZP.ZONEMODEL_CODE                              ->          ASS_ZBD_ZONEMODEL_CODE
DETAIL.ASS_ZBD.ZP.ZONE_RESULT_VALUE_WS                        ->          ASS_ZBD_ZONE_RESULT_VALUE_WS
DETAIL.ASS_ZBD.ZP.ZONE_RESULT_VALUE_RT                        ->          ASS_ZBD_ZONE_RESULT_VALUE_RT
DETAIL.ASS_ZBD.ZP.DISTANCE                                    ->          ASS_ZBD_DISTANCE
DETAIL.ASS_ZBD.ZP.INTERN_ZONE_MODEL                           ->          ASS_ZBD_INTERN_ZONE_MODEL
DETAIL.ASS_ZBD.ZP.INTERN_APN_GROUP                            ->          ASS_ZBD_INTERN_APN_GROUP


// ===========================================
// ASSOCIATED CHARGE BREAKDOWN RECORD
// ===========================================

DETAIL.ASS_CBD                                                ->          ASS_CBD
DETAIL.ASS_CBD.RECORD_LENGTH                                  ->          ASS_CBD_RECORD_LENGTH
DETAIL.ASS_CBD.RECORD_TYPE                                    ->          ASS_CBD_RECORD_TYPE
DETAIL.ASS_CBD.RECORD_NUMBER                                  ->          ASS_CBD_RECORD_NUMBER
DETAIL.ASS_CBD.CONTRACT_CODE                                  ->          ASS_CBD_CONTRACT_CODE
DETAIL.ASS_CBD.SEGMENT_CODE                                   ->          ASS_CBD_SEGMENT_CODE
DETAIL.ASS_CBD.CUSTOMER_CODE                                  ->          ASS_CBD_CUSTOMER_CODE
DETAIL.ASS_CBD.ACCOUNT_CODE                                   ->          ASS_CBD_ACCOUNT_CODE
DETAIL.ASS_CBD.SYSTEM_BRAND_CODE                              ->          ASS_CBD_SYSTEM_BRAND_CODE
DETAIL.ASS_CBD.SERVICE_CODE                                   ->          ASS_CBD_SERVICE_CODE
DETAIL.ASS_CBD.CUSTOMER_RATEPLAN_CODE                         ->          ASS_CBD_CUSTOMER_RATEPLAN_CODE
DETAIL.ASS_CBD.SLA_CODE                                       ->          ASS_CBD_SLA_CODE
DETAIL.ASS_CBD.CUSTOMER_BILLCYCLE                             ->          ASS_CBD_CUSTOMER_BILLCYCLE
DETAIL.ASS_CBD.CUSTOMER_CURRENCY                              ->          ASS_CBD_CUSTOMER_CURRENCY
DETAIL.ASS_CBD.CUSTOMER_TAXGROUP                              ->          ASS_CBD_CUSTOMER_TAXGROUP
DETAIL.ASS_CBD.NUMBER_OF_CHARGE_PACKETS                       ->          NUMBER_OF_CHARGE_PACKETS
DETAIL.ASS_CBD.INTERN_CALC_MODE                               ->          INTERN_CALC_MODE
DETAIL.ASS_CBD.CUSTOMER_OPENING_BALANCE                       ->          ASS_CBD_CUSTOMER_OPENING_BALANCE
DETAIL.ASS_CBD.CUSTOMER_CLOSING_BALANCE                       ->          ASS_CBD_CUSTOMER_CLOSING_BALANCE
DETAIL.ASS_CBD.CP                                             ->          ASS_CBD_CHARGE_PACKET
DETAIL.ASS_CBD.CP.RATEPLAN_CODE                               ->          RATEPLAN_CODE
DETAIL.ASS_CBD.CP.RATEPLAN_TYPE                               ->          RATEPLAN_TYPE
DETAIL.ASS_CBD.CP.ZONEMODEL_CODE                              ->          ASS_CBD_ZONEMODEL_CODE
DETAIL.ASS_CBD.CP.SERVICE_CODE_USED                           ->          SERVICE_CODE_USED
DETAIL.ASS_CBD.CP.SERVICE_CLASS_USED                          ->          SERVICE_CLASS_USED
DETAIL.ASS_CBD.CP.IMPACT_CATEGORY                             ->          ASS_CBD_IMPACT_CATEGORY
DETAIL.ASS_CBD.CP.DISTANCE                                    ->          ASS_CBD_DISTANCE
DETAIL.ASS_CBD.CP.TIMEMODEL_CODE                              ->          TIMEMODEL_CODE
DETAIL.ASS_CBD.CP.TIMEZONE_CODE                               ->          TIMEZONE_CODE
DETAIL.ASS_CBD.CP.DAY_CODE                                    ->          DAY_CODE
DETAIL.ASS_CBD.CP.TIME_INTERVAL_CODE                          ->          TIME_INTERVAL_CODE
DETAIL.ASS_CBD.CP.PRICEMODEL_CODE                             ->          PRICEMODEL_CODE
DETAIL.ASS_CBD.CP.PRICEMODEL_TYPE                             ->          PRICEMODEL_TYPE
DETAIL.ASS_CBD.CP.RESOURCE                                    ->          RESOURCE
DETAIL.ASS_CBD.CP.RUMGROUP                                    ->          RUMGROUP
DETAIL.ASS_CBD.CP.RUM                                         ->          RUM
DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_CODE                       ->          NETWORK_OPERATOR_CODE
DETAIL.ASS_CBD.CP.NETWORK_OPERATOR_BILLINGTYPE                ->          NETWORK_OPERATOR_BILLINGTYPE
DETAIL.ASS_CBD.CP.CHARGE_TYPE                                 ->          CHARGE_TYPE
DETAIL.ASS_CBD.CP.TRUNK_USED                                  ->          TRUNK_USED
DETAIL.ASS_CBD.CP.POI_USED                                    ->          POI_USED
DETAIL.ASS_CBD.CP.PRODUCTCODE_USED                            ->          PRODUCTCODE_USED
DETAIL.ASS_CBD.CP.CHARGING_START_TIMESTAMP                    ->          ASS_CBD_CHARGING_START_TIMESTAMP
DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_VALUE                      ->          ROUNDED_QUANTITY_VALUE
DETAIL.ASS_CBD.CP.ROUNDED_QUANTITY_UOM                        ->          ROUNDED_QUANTITY_UOM
DETAIL.ASS_CBD.CP.EXCHANGE_RATE                               ->          EXCHANGE_RATE
DETAIL.ASS_CBD.CP.EXCHANGE_CURRENCY                           ->          EXCHANGE_CURRENCY
DETAIL.ASS_CBD.CP.CHARGED_CURRENCY_TYPE                       ->          CHARGED_CURRENCY_TYPE
DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_VALUE                        ->          CHARGED_AMOUNT_VALUE
DETAIL.ASS_CBD.CP.CHARGED_AMOUNT_CURRENCY                     ->          CHARGED_AMOUNT_CURRENCY
DETAIL.ASS_CBD.CP.CHARGED_TAX_TREATMENT                       ->          CHARGED_TAX_TREATMENT
DETAIL.ASS_CBD.CP.CHARGED_TAX_RATE                            ->          CHARGED_TAX_RATE
DETAIL.ASS_CBD.CP.CHARGED_TAX_CODE                            ->          CHARGED_TAX_CODE
DETAIL.ASS_CBD.CP.USAGE_GL_ACCOUNT_CODE                       ->          USAGE_GL_ACCOUNT_CODE
DETAIL.ASS_CBD.CP.REVENUE_GROUP_CODE                          ->          REVENUE_GROUP_CODE
DETAIL.ASS_CBD.CP.DISCOUNTMODEL_CODE                          ->          DISCOUNTMODEL_CODE
DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_AMOUNT_VALUE               ->          GRANTED_DISCOUNT_AMOUNT_VALUE
DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_VALUE             ->          GRANTED_DISCOUNT_QUANTITY_VALUE
DETAIL.ASS_CBD.CP.GRANTED_DISCOUNT_QUANTITY_UOM               ->          GRANTED_DISCOUNT_QUANTITY_UOM
DETAIL.ASS_CBD.CP.INTERN_RATEPLAN                             ->          INTERN_RATEPLAN
DETAIL.ASS_CBD.CP.INTERN_RATEPLAN_VERSION                     ->          INTERN_RATEPLAN_VERSION
DETAIL.ASS_CBD.CP.INTERN_ZONE_MODEL                           ->          ASS_CBD_INTERN_ZONE_MODEL
DETAIL.ASS_CBD.CP.INTERN_APN_GROUP                            ->          ASS_CBD_INTERN_APN_GROUP
DETAIL.ASS_CBD.CP.INTERN_ORIGIN_NUM_ZONE                      ->          INTERN_ORIGIN_NUM_ZONE
DETAIL.ASS_CBD.CP.INTERN_DESTIN_NUM_ZONE                      ->          INTERN_DESTIN_NUM_ZONE
DETAIL.ASS_CBD.CP.INTERN_FIX_COST                             ->          INTERN_FIX_COST
DETAIL.ASS_CBD.CP.INTERN_DISCOUNT_MODEL                       ->          INTERN_DISCOUNT_MODEL
DETAIL.ASS_CBD.CP.INTERN_DISCOUNT_ACCOUNT                     ->          INTERN_DISCOUNT_ACCOUNT
DETAIL.ASS_CBD.CP.INTERN_HOME_CURRENCY                        ->          INTERN_HOME_CURRENCY
DETAIL.ASS_CBD.CP.INTERN_BILLING_CURRENCY                     ->          INTERN_BILLING_CURRENCY

// ===========================================
// ASSOCIATED SMS EXTENSION RECORD
// ===========================================

DETAIL.ASS_SMS_EXT					      ->      ASS_SMS
DETAIL.ASS_SMS_EXT.RECORD_TYPE       			      ->      ASS_SMS_RECORD_TYPE
DETAIL.ASS_SMS_EXT.RECORD_NUMBER      			      ->      ASS_SMS_RECORD_NUMBER
DETAIL.ASS_SMS_EXT.CONTENT_INDICATOR       		      ->      ASS_SMS_CONTENT_INDICATOR
DETAIL.ASS_SMS_EXT.ORIGINATING_SWITCH_IDENTIFICATION          ->      ASS_SMS_ORIGINATING_SWITCH_IDENTIFICATION
DETAIL.ASS_SMS_EXT.DESTINATION_SWITCH_IDENTIFICATION          ->      ASS_SMS_DESTINATION_SWITCH_IDENTIFICATION
DETAIL.ASS_SMS_EXT.PROVIDER_ID                                ->      ASS_SMS_PROVIDER_ID
DETAIL.ASS_SMS_EXT.SERVICE_ID                                 ->      ASS_SMS_SERVICE_ID
DETAIL.ASS_SMS_EXT.DEVICE_NUMBER			      ->      ASS_SMS_DEVICE_NUMBER
DETAIL.ASS_SMS_EXT.PORT_NUMBER        		              ->      ASS_SMS_PORT_NUMBER 
DETAIL.ASS_SMS_EXT.DIALED_DIGITS      			      ->      ASS_SMS_DIALED_DIGITS


// ===========================================
// ASSOCIATED MMS EXTENSION RECORD
// ===========================================
DETAIL.ASS_MMS_EXT                                            ->       ASS_MMS
DETAIL.ASS_MMS_EXT.RECORD_TYPE                                ->       ASS_MMS_RECORD_TYPE
DETAIL.ASS_MMS_EXT.RECORD_NUMBER                              ->       ASS_MMS_RECORD_NUMBER
DETAIL.ASS_MMS_EXT.ACCOUNT_STATUS_TYPE                        ->       ASS_MMS_ACCOUNT_STATUS_TYPE
DETAIL.ASS_MMS_EXT.PRIORITY                                   ->       ASS_MMS_PRIORITY
DETAIL.ASS_MMS_EXT.MESSAGE_CONTENT                            ->       ASS_MMS_MESSAGE_CONTENT
DETAIL.ASS_MMS_EXT.MESSAGE_ID                                 ->       ASS_MMS_MESSAGE_ID
DETAIL.ASS_MMS_EXT.STATION_IDENTIFIER                         ->       ASS_MMS_STATION_IDENTIFIER
DETAIL.ASS_MMS_EXT.FC_INDICATOR                               ->       ASS_MMS_FC_INDICATOR
DETAIL.ASS_MMS_EXT.CORRELATION_ID                             ->       ASS_MMS_CORRELATION_ID
DETAIL.ASS_MMS_EXT.CELL_ID                                    ->       ASS_MMS_CELL_ID    
DETAIL.ASS_MMS_EXT.B_CELL_ID                                  ->       ASS_MMS_B_CELL_ID
DETAIL.ASS_MMS_EXT.A_TERM_CELL_ID                             ->       ASS_MMS_A_TERM_CELL_ID
DETAIL.ASS_MMS_EXT.DEVICE_NUMBER                              ->       ASS_MMS_DEVICE_NUMBER
DETAIL.ASS_MMS_EXT.PORT_NUMBER                                ->       ASS_MMS_PORT_NUMBER
DETAIL.ASS_MMS_EXT.DIALED_DIGITS                              ->       ASS_MMS_DIALED_DIGITS

// ===========================================
// TRAILER RECORD
// ===========================================

TRAILER.RECORD_LENGTH                                         ->          TRR_RECORD_LENGTH
TRAILER.RECORD_TYPE                                           ->          TRR_RECORD_TYPE
TRAILER.RECORD_NUMBER                                         ->          TRR_RECORD_NUMBER
TRAILER.SENDER                                                ->          TRR_SENDER
TRAILER.RECIPIENT                                             ->          TRR_RECIPIENT
TRAILER.SEQUENCE_NUMBER                                       ->          TRR_SEQUENCE_NUMBER
TRAILER.ORIGIN_SEQUENCE_NUMBER                                ->          TRR_ORIGIN_SEQUENCE_NUMBER
TRAILER.TOTAL_NUMBER_OF_RECORDS                               ->          TOTAL_NUMBER_OF_RECORDS
TRAILER.FIRST_START_TIMESTAMP                                 ->          FIRST_START_TIMESTAMP
TRAILER.LAST_START_TIMESTAMP                                  ->          LAST_START_TIMESTAMP
TRAILER.TOTAL_RETAIL_CHARGED_VALUE                            ->          TOTAL_RETAIL_CHARGED_VALUE
TRAILER.TOTAL_WHOLESALE_CHARGED_VALUE                         ->          TOTAL_WHOLESALE_CHARGED_VALUE
TRAILER.OPERATOR_SPECIFIC_INFO                                ->          TRR_OPERATOR_SPECIFIC_INFO


// ===========================================
// INTERNAL
// ===========================================

INTERNAL.STREAM_NAME                                          ->          STREAM_NAME
INTERNAL.OFFSET_GENERATION                                    ->          OFFSET_GENERATION
INTERNAL.SEQ_CHECK                                            ->          SEQ_CHECK
INTERNAL.SEQ_GENERATION                                       ->          SEQ_GENERATION
INTERNAL.TRANSACTION_ID                                       ->          TRANSACTION_ID
INTERNAL.PROCESS_STATUS                                       ->          PROCESS_STATUS

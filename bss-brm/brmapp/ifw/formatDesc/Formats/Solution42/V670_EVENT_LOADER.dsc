//==============================================================================
//
// Copyright (c) 2004, 2014, Oracle and/or its affiliates. All rights reserved.
//
//       This material is the confidential property of Oracle Corporation
//       or its licensors and may be used, reproduced, stored or transmitted
//       only in accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: FMD
//------------------------------------------------------------------------------
// Module Description:
//   Description of the Portal EventLoader V6.70 format with Unix timestamps
//   
//   Following are the instructions to add an end of line comment used by IREL:
//   - EDR field is not getting loaded into Infranet DB, use comment like 
//   // IREL  Not loaded
//   - EDR field type array/substruct getting loaded into Infranet DB, use comment 
//   // IREL  storable-class.<array/substruct field>.field
//   - All other EDR fields getting loaded into Infranet DB, use comment like
//   // IREL  storable-class.field 
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//------------------------------------------------------------------------------
//
// $Log: V670_EVENT_LOADER.dsc,v $
//==============================================================================

V670_EVENT_LOADER
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
    BATCH_ID                            AscString();
    OBJECT_CACHE_TYPE                   AscInteger();
  }

  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL(SEPARATED)
  {
    Info
    {
      Pattern = "(02[0-9]|03[0-1]|04[0-9]|050|060|070|08[1-2]|12[0-8]|13[0-1]|220|701).*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();   // IREL Not loaded      
    RECORD_NUMBER                       AscInteger();  // IREL Not loaded
    EVENT_ID                            AscString();   // IREL /event.pin_fld_event_no ;
    BATCH_ID                            AscString();   // IREL /event.pin_fld_batch_id ;
    ORIGINAL_BATCH_ID                   AscString();   // IREL /event.pin_fld_original_batch_id ;
    CHAIN_REFERENCE                     AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_network_session_id ;
    SOURCE_NETWORK                      AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_origin_network ;
    DESTINATION_NETWORK                 AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_destination_network ;
    A_NUMBER                            AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_primary_msid, /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_msisdn, /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_msisdn ;
    B_MODIFICATION_INDICATOR            AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_gsm_info[].pin_fld_called_num_modif_mark ;
    B_NUMBER                            AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_called_to ;
    DESCRIPTION                         AscString();   // IREL /event.pin_fld_descr ;
    USAGE_DIRECTION                     AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_gsm_info[].pin_fld_direction ;
    CONNECT_TYPE                        AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_conn_type, /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_anonymous_login ; 
    CONNECT_SUB_TYPE                    AscString();   // IREL Not loaded
    BASIC_SERVICE                       AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_svc_type(1), /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_svc_code ;
    QOS_REQUESTED                       AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_gsm_info[].pin_fld_qos_requested ;
    QOS_USED                            AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_gsm_info[].pin_fld_qos_negotiated ;
    CALL_COMPLETION_INDICATOR           AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_terminate_cause, /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_close_cause ;
    LONG_DURATION_INDICATOR             AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_gsm_info[].pin_fld_sub_trans_id ;
    UTC_TIME_OFFSET                     AscString();   // IREL /event.pin_fld_timezone_id ;
    VOLUME_SENT                         AscDecimal();  // IREL /event/delayed/session/gprs.pin_fld_gprs_info.pin_fld_bytes_out, /event/delayed/session/telco/gsm.pin_fld_gsm_info[].pin_fld_bytes_out ;
    VOLUME_RECEIVED                     AscDecimal();  // IREL /event/delayed/session/gprs.pin_fld_gprs_info.pin_fld_bytes_in, /event/delayed/session/telco/gsm.pin_fld_gsm_info[].pin_fld_bytes_in, /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_bytes_in ;
    NUMBER_OF_UNITS                     AscDecimal();  // IREL /event/delayed/session/telco/gsm.pin_fld_gsm_info[].pin_fld_number_of_units, /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_number_of_units, /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_number_of_units ;
    USAGE_CLASS                         AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_usage_class, /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_usage_class, /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_usage_class ; 
    USAGE_TYPE                          AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_usage_type, /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_usage_type, /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_usage_type ; 
    PREPAID_INDICATOR                   AscInteger();  // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_prepaid_indicator ; 
    INTERN_PROCESS_STATUS               AscInteger();  // IREL Not loaded
    CHARGING_START_TIMESTAMP            AscDateUnix(); // IREL /event.pin_fld_start_t ;
    CHARGING_END_TIMESTAMP              AscDateUnix(); // IREL /event.pin_fld_end_t ;
    NET_QUANTITY                        AscDecimal();  // IREL /event.pin_fld_net_quantity ;
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

    RECORD_TYPE                         AscString();   // IREL Not loaded
    RECORD_NUMBER                       AscInteger();  // IREL Not loaded
    PORT_NUMBER                         AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_secondary_msid ; 
    A_NUMBER_USER                       AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_telco_info[].pin_fld_calling_from ;
    NUMBER_OF_SS_EVENT_PACKETS          AscInteger();  // IREL Not loaded
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

    RECORD_TYPE                         AscString();   // IREL Not loaded
    RECORD_NUMBER                       AscInteger();  // IREL Not loaded
    ACTION_CODE                         AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_service_codes.pin_fld_ss_action_code ;
    SS_CODE                             AscString();   // IREL /event/delayed/session/telco/gsm.pin_fld_service_codes.pin_fld_ss_code ;
    CLIR_INDICATOR                      AscInteger();  // IREL Not loaded
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

    RECORD_TYPE                         AscString();    // IREL Not loaded
    RECORD_NUMBER                       AscInteger();   // IREL Not loaded
    PORT_NUMBER                         AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_imsi ;
    DEVICE_NUMBER                       AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_imei ;
    ROUTING_AREA                        AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_routing_area ;
    LOCATION_AREA_INDICATOR             AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_loc_area_code ;
    CHARGING_ID                         AscDecimal();   // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_session_id ;
    SGSN_ADDRESS                        AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_sgsn_address ;
    GGSN_ADDRESS                        AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_ggsn_address ;
    APN_ADDRESS                         AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_apn ;
    NODE_ID                             AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_node_id ;
    TRANS_ID                            AscInteger();   // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_trans_id ;
    SUB_TRANS_ID                        AscInteger();   // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_sub_trans_id ;
    NETWORK_INITIATED_PDP               AscInteger();   // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_ni_pdp ;
    PDP_TYPE                            AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_pdp_type ;
    PDP_ADDRESS                         AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_pdp_address ;
    PDP_REMOTE_ADDRESS                  AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_pdp_raddress ;
    PDP_DYNAMIC_ADDRESS                 AscInteger();   // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_pdp_dynaddr ;
    DIAGNOSTICS                         AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_diagnostics ;
    CELL_ID                             AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_cell_id ;
    CHANGE_CONDITION                    AscInteger();   // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_change_condition ;
    QOS_REQUESTED_PRECEDENCE            AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_req_precedence ;
    QOS_REQUESTED_DELAY                 AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_req_delay ;
    QOS_REQUESTED_RELIABILITY           AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_req_reliability ;
    QOS_REQUESTED_PEAK_THROUGHPUT       AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_req_peak_through ;
    QOS_REQUESTED_MEAN_THROUGHPUT       AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_req_mean_through ;
    QOS_USED_PRECEDENCE                 AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_nego_precedence ;
    QOS_USED_DELAY                      AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_nego_delay ;
    QOS_USED_RELIABILITY                AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_nego_reliability ;
    QOS_USED_PEAK_THROUGHPUT            AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_nego_peak_through ;
    QOS_USED_MEAN_THROUGHPUT            AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_qos_nego_mean_through ;
    NETWORK_CAPABILITY                  AscString();    // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_network_capability ;
    SGSN_CHANGE                         AscInteger();   // IREL /event/delayed/session/gprs.pin_fld_gprs_info[].pin_fld_sgsn_change ;
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

    RECORD_TYPE                         AscString();   // IREL Not loaded
    RECORD_NUMBER                       AscInteger();  // IREL Not loaded
    PORT_NUMBER                         AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_imsi ;
    DEVICE_NUMBER                       AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_imei ;
    SESSION_ID                          AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_session_id ;
    RECORDING_ENTITY                    AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_recording_entity ;
    TERMINAL_IP_ADDRESS                 AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_terminal_ip_address ;
    DOMAIN_URL                          AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_url(1024) ;
    BEARER_SERVICE                      AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_bearer_type ;
    HTTP_STATUS                         AscInteger();  // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_http_status ;
    WAP_STATUS                          AscInteger();  // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_wap_status ;
    ACKNOWLEDGE_STATUS                  AscInteger();  // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_wap_ack_status ;
    ACKNOWLEDGE_TIME                    AscDateUnix(); // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_ack_time ;
    GGSN_ADDRESS                        AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_ggsn_address ;
    SERVER_TYPE                         AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_server_type ;
    CHARGING_ID                         AscDecimal();  // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_charging_id ;
    WAP_LOGIN                           AscString();   // IREL /event/delayed/activity/wap/interactive.pin_fld_wap_info[].pin_fld_login ;
  }

  //----------------------------------------------------------------------------
  // Associated LTE record
  //----------------------------------------------------------------------------
  ASSOCIATED_LTE(SEPARATED)
  {
    Info
    {
      Pattern = "530.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    RECORD_TYPE                         AscString();   // IREL Not loaded
    RECORD_NUMBER                       AscInteger();  // IREL Not loaded
    PORT_NUMBER                         AscString();   // IREL Not loaded
    DEVICE_NUMBER                       AscString();   // IREL Not loaded
    LOCATION_AREA_INDICATOR             AscString();   // IREL Not loaded
    PCSCF_ADDRESS                       AscString();   // IREL Not loaded
    SERVING_GATEWAY_ADDRESS             AscString();   // IREL Not loaded	
    PDN_GATEWAY_ADDRESS                 AscString();   // IREL Not loaded
    CELL_ID                             AscString();   // IREL Not loaded
    EVENT_REFERENCE                     AscString();   // IREL Not loaded
    MESSAGING_EVENT_SERVICE             AscInteger();  // IREL Not loaded	
    MOBILE_SESSION_SERVICE              AscInteger();  // IREL Not loaded	
    PUBLIC_USER_ID                      AscString();   // IREL Not loaded 
    NON_CHARGED_PUBLIC_USERID           AscString();   // IREL Not loaded 
    NON_CHARGED_PARTY_NUMBER            AscString();   // IREL Not loaded
    REQUESTED_NUMBER                    AscString();   // IREL Not loaded
    REQUESTED_PUBLIC_USERID             AscString();   // IREL Not loaded
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

    RECORD_TYPE                         AscString();   // IREL Not loaded
    RECORD_NUMBER                       AscInteger();  // IREL Not loaded
    ACCOUNT_POID                        AscString();   // IREL /event.pin_fld_account_obj ;
    SERVICE_POID                        AscString();   // IREL /event.pin_fld_service_obj ;
    ITEM_POID                           AscString();   // IREL /event.pin_fld_item_obj ;
    ORIGINAL_EVENT_POID                 AscString();   // IREL /event.pin_fld_rerate_obj ;
    PIN_TAX_LOCALES                     AscString();   // IREL /event.pin_fld_tax_locales(1024) ;
    RUM_NAME                            AscString();   // IREL /event.pin_fld_rum_name ;
    NUMBER_OF_BALANCE_PACKETS           AscInteger();  // IREL Not loaded - But probably useful!
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

    RECORD_TYPE                         AscString();  // IREL /event.pin_fld_invoice_data(4000) ;
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
    PIN_IMPACT_TYPE                    AscInteger();
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
    
    RECORD_TYPE                         AscString();   // IREL Not loaded
    RECORD_NUMBER                       AscInteger();  // IREL Not loaded
    ACCOUNT_POID                        AscString();   // IREL /event.pin_fld_bal_impacts[].pin_fld_account_obj ;
    BAL_GRP_POID                        AscString();   // IREL /event.pin_fld_bal_impacts[].pin_fld_bal_grp_obj ;
    ITEM_POID                           AscString();   // IREL /event.pin_fld_bal_impacts[].pin_fld_item_obj ;
    PIN_RESOURCE_ID                     AscInteger();  // IREL /event.pin_fld_bal_impacts[].pin_fld_resource_id ;
    PIN_RESOURCE_ID_ORIG                AscInteger();  // IREL /event.pin_fld_bal_impacts[].pin_fld_resource_id_orig ;
    PIN_IMPACT_CATEGORY                 AscString();   // IREL /event.pin_fld_bal_impacts[].pin_fld_impact_category ;
    PIN_IMPACT_TYPE                     AscInteger();  // IREL /event.pin_fld_bal_impacts[].pin_fld_impact_type ;
    PIN_PRODUCT_POID                    AscString();   // IREL /event.pin_fld_bal_impacts[].pin_fld_product_obj ;
    PIN_GL_ID                           AscInteger();  // IREL /event.pin_fld_bal_impacts[].pin_fld_gl_id ;
    RUM_ID                              AscInteger();  // IREL /event.pin_fld_bal_impacts[].pin_fld_rum_id ;
    PIN_TAX_CODE                        AscString();   // IREL /event.pin_fld_bal_impacts[].pin_fld_tax_code ;
    PIN_RATE_TAG                        AscString();   // IREL /event.pin_fld_bal_impacts[].pin_fld_rate_tag ;
    PIN_LINEAGE                         AscString();   // IREL /event.pin_fld_bal_impacts[].pin_fld_lineage ;
    PIN_OFFERING_POID                   AscString();   // IREL /event.pin_fld_bal_impacts[].pin_fld_offering_obj ;
    PIN_QUANTITY                        AscDecimal();  // IREL /event.pin_fld_bal_impacts[].pin_fld_quantity ;
    PIN_AMOUNT                          AscDecimal();  // IREL /event.pin_fld_bal_impacts[].pin_fld_amount ;
    PIN_AMOUNT_ORIG                     AscDecimal();  // IREL /event.pin_fld_bal_impacts[].pin_fld_amount_orig ;
    PIN_AMOUNT_DEFERRED                 AscDecimal();  // IREL /event.pin_fld_bal_impacts[].pin_fld_amount_deferred ;
    PIN_DISCOUNT                        AscDecimal();  // IREL /event.pin_fld_bal_impacts[].pin_fld_discount ;
    PIN_PERCENT                         AscDecimal();  // IREL /event.pin_fld_bal_impacts[].pin_fld_percent ;
    PIN_INFO_STRING                     AscString();   // IREL Not loaded
  }

  SUB_BAL_IMPACT(SEPARATED)
  {
     Info
     {
       Pattern = "605.*\n";
       FieldSeparator = '\t';
       RecordSeparator = '\n';
     }
     RECORD_TYPE                         AscString();   // IREL  not loaded
     RECORD_NUMBER                       AscInteger();  // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_sub_balances[].pin_fld_rec_id2 , /event.pin_fld_sub_bal_impacts[].pin_fld_rec_id ; 
     BAL_GRP_POID                        AscString();   // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_bal_grp_obj ;
     PIN_RESOURCE_ID                     AscInteger();  // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_resource_id ;
  }

  SUB_BAL(SEPARATED)
  {
     Info
     {
       Pattern = "607.*\n";
       FieldSeparator = '\t';
       RecordSeparator = '\n';
     }
     RECORD_TYPE                         AscString();    // IREL  not loaded
     RECORD_NUMBER                       AscInteger();   // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_rec_id ; 
     PIN_AMOUNT                          AscDecimal();   // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_sub_balances[].pin_fld_amount ;
     VALID_FROM                          AscDateUnix();  // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_sub_balances[].pin_fld_valid_from ;
     VALID_TO                            AscDateUnix();  // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_sub_balances[].pin_fld_valid_to ;
     CONTRIBUTOR                         AscString();    // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_sub_balances[].pin_fld_contributor_st ;
     GRANTOR                             AscString();    // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_sub_balances[].pin_fld_grantor_st ;
     VALID_FROM_DETAILS                  AscInteger();  // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_sub_balances[].pin_fld_valid_from_details ;
     VALID_TO_DETAILS                    AscInteger();  // IREL /event.pin_fld_sub_bal_impacts[].pin_fld_sub_balances[].pin_fld_valid_to_details ;
  }

  TAX_JURISDICTION(SEPARATED)
  {
    Info
    {
      Pattern = "615.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    RECORD_TYPE                         AscString();   // IREL Not loaded
    RECORD_NUMBER                       AscInteger();  // IREL Not loaded
    PIN_TAX_TYPE                        AscString();   // IREL /event.pin_fld_tax_jurisdictions[].pin_fld_type ;
    PIN_TAX_VALUE                       AscDecimal();  // IREL /event.pin_fld_tax_jurisdictions[].pin_fld_amount ;
    PIN_AMOUNT                          AscDecimal();  // IREL /event.pin_fld_tax_jurisdictions[].pin_fld_amount_taxed ;
    PIN_TAX_RATE                        AscString();   // IREL /event.pin_fld_tax_jurisdictions[].pin_fld_percent ;
    PIN_AMOUNT_GROSS                    AscDecimal();  // IREL /event.pin_fld_tax_jurisdictions[].pin_fld_amount_gross ;
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
    RECORD_TYPE                         AscString();    // IREL Not loaded
    RECORD_NUMBER                       AscInteger();   // IREL Not loaded
    RUM_NAME                            AscString();    // IREL /event.pin_fld_rum_map[].pin_fld_rum_name ;
    NET_QUANTITY                        AscDecimal();   // IREL /event.pin_fld_rum_map[].pin_fld_net_quantity ;
    UNRATED_QUANTITY                    AscDecimal();   // IREL /event.pin_fld_rum_map[].pin_fld_unrated_quantity ;
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
    RECORD_TYPE                		AscString();
    RECORD_NUMBER              	 	AscInteger();
    BALANCE_GROUP_POID         	 	AscString();
    CRITERIA_NAME              	 	AscString();
    LAST_EVENT_PROCESS_TIMESTAMP       	AscDateUnix();
    BILL_CYCLE_TIMESTAMP		AscDateUnix();			
    PROFILE_POID               		AscString();
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

    RECORD_TYPE                         AscString();   // IREL Not loaded
    RECORD_NUMBER                       AscInteger();  // IREL Not loaded
    SENDER                              AscString();   // IREL Not loaded
    RECIPIENT                           AscString();   // IREL Not loaded
    SEQUENCE_NUMBER                     AscInteger();  // IREL Not loaded
    ORIGIN_SEQUENCE_NUMBER              AscInteger();  // IREL Not loaded
    TOTAL_NUMBER_OF_RECORDS             AscInteger();  // IREL Not loaded
    FIRST_CHARGING_START_TIMESTAMP      AscDateUnix(); // IREL Not loaded 
    FIRST_CHARGING_UTC_TIME_OFFSET      AscString();   // IREL Not loaded
    LAST_CHARGING_START_TIMESTAMP       AscDateUnix(); // IREL Not loaded
    LAST_CHARGING_UTC_TIME_OFFSET       AscString();   // IREL Not loaded
    TOTAL_RETAIL_CHARGED_VALUE          AscDecimal();  // IREL Not loaded
    TOTAL_WHOLESALE_CHARGED_VALUE       AscDecimal();  // IREL Not loaded
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

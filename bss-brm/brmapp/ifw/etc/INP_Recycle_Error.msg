#=================================================================
# Portal Pipeline Server INP::Recycle Messages
#
# Number Range: 10501-10600
#----------------------------------------------------------------
# Note: Add only numbers inside the allocated range.
#       Do not change existing numbers.
#=================================================================
# 03-Oct-2003: Initial version
#=================================================================

ERR_REG_TRAILER_NOT_SUPPORTED       | Trailer record is not supported by INP_Recycle. | 10501
ERR_RECYCLING_DATA_MODULE_NOT_FOUND | Cannot find recycling data module.              | 10502
ERR_PROCESS_RECORD_ERROR            | Error in processing record : %s.                | 10503
ERR_PARSE_HEADER_ERROR              | Error in parsing header record.                 | 10504
ERR_ADD_HEADER_REOCRD_ERROR         | Error while adding header record.               | 10505
ERR_ADD_TRAILER_REOCRD_ERROR        | Error while adding trailer record.              | 10506
ERR_INP_RECYCLE_CANNOT_FIND_EDR_VERSION         | INP::EdrVersionConverter::getEdrVersion(..) is unable to find the EDR version attribute in the inputed xml.  | 10507
ERR_INP_RECYCLE_SAX2_PARSE_ERRORS               | SAX2XMLReader errors encounted during parse operation in function %s        | 10508
ERR_INP_RECYCLE_UNEXPECTED_EXCEPTION            | Unexpected Exception in function %s                  | 10509
ERR_INP_RECYCLE_NO_DB_CONNECTION                | Unable to get DB Connection in function: %s - %s     | 10510 
ERR_INP_RECYCLE_NO_DB_SELECTOR                  | Unable to get DB Selector in function: %s - %s       | 10511
ERR_INP_RECYCLE_NO_DB_TABLES                    | Unable to get DB Tables edr_field_mapping_t and edr_fld_map_buf_t in function: %s     | 10512
ERR_INP_RECYCLE_INVALID_READER                  | Invalid reader in function: %s - %s                  | 10513
ERR_INP_RECYCLE_EMPTY_QUERY_RESULT              | Query for edr_fld_map_buf_t buffer returned empty data in function: %s                | 10514
ERR_INP_RECYCLE_DOM_PARSE_ERRORS                | DOMParser errors encounted during parse operation in function %s        | 10515
ERR_INP_RECYCLE_ROOT_ELEMENT_MISSING            | EDR root XML element not found in function %s        | 10516
ERR_INP_RECYCLE_EDR_MISSING_FM                  | EDR xml missing FM_ELEMENT in function %s            | 10517
ERR_INP_RECYCLE_CANNOT_CONVERT_EDR              | Cannot convert EDR to new container desc, field is either missing or type has changed: %s            | 10518
ERR_PUSH_EDR_ERROR                              | Error in pushing record to pipeline,record number: %s. | 10519

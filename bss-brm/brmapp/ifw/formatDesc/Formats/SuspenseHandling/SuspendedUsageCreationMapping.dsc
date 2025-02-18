//==============================================================================
//
//      Copyright (c) 1996 - 2007 Oracle. All rights reserved.
//      
//      This material is the confidential property of Oracle Corporation or its
//      licensors and may be used, reproduced, stored or transmitted only in
//      accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: FMD
//------------------------------------------------------------------------------
// Module Description:
//   Output mapping for the suspended usage creation format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//------------------------------------------------------------------------------
// Responsible: ming-wen sung
//
//==============================================================================

SUSPENDED_USAGE_CREATION
{
  //----------------------------------------------------------------------------
  // Header record
  //----------------------------------------------------------------------------
  HEADER 
  {
    STD_MAPPING
    {
      RECORD_TYPE                  <- "010";
      RECORD_NUMBER                <- HEADER.RECORD_NUMBER;
      SENDER                       <- HEADER.SENDER;
      RECIPIENT                    <- HEADER.RECIPIENT;
      SEQUENCE_NUMBER              <- HEADER.SEQUENCE_NUMBER;
      ORIGIN_SEQUENCE_NUMBER       <- HEADER.ORIGIN_SEQUENCE_NUMBER;
      CREATION_TIMESTAMP           <- HEADER.CREATION_TIMESTAMP;
      TRANSMISSION_DATE            <- HEADER.TRANSMISSION_DATE;
      TRANSFER_CUTOFF_TIMESTAMP    <- HEADER.TRANSFER_CUTOFF_TIMESTAMP;
      UTC_TIME_OFFSET              <- HEADER.UTC_TIME_OFFSET;
      SPECIFICATION_VERSION_NUMBER <- HEADER.SPECIFICATION_VERSION_NUMBER;
      RELEASE_VERSION              <- HEADER.RELEASE_VERSION;
      ORIGIN_COUNTRY_CODE          <- HEADER.ORIGIN_COUNTRY_CODE;   
      SENDER_COUNTRY_CODE          <- HEADER.SENDER_COUNTRY_CODE;
      DATA_TYPE_INDICATOR          <- HEADER.DATA_TYPE_INDICATOR;
      IAC_LIST                     <- HEADER.IAC_LIST;
      CC_LIST                      <- HEADER.CC_LIST;
      CREATION_PROCESS             <- HEADER.CREATION_PROCESS;
      SCHEMA_VERSION               <- "10000";
      EVENT_TYPE                   <- HEADER.EVENT_TYPE;
      QUERYABLE_FIELDS_MAPPING     <- HEADER.QUERYABLE_FIELDS_MAPPING;
    }
  }

  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL
  {
    STD_MAPPING
    {
      RECORD_TYPE                  <- "020";
      SUSPENSE_REASON              <- DETAIL.ASS_SUSPENSE_EXT.SUSPENSE_REASON;
      SUSPENSE_SUBREASON           <- DETAIL.ASS_SUSPENSE_EXT.SUSPENSE_SUBREASON;
      RECYCLE_KEY		   <- DETAIL.ASS_SUSPENSE_EXT.RECYCLE_KEY;
      ERROR_CODE                   <- DETAIL.ASS_SUSPENSE_EXT.ERROR_CODE;
      PIPELINE_NAME                <- DETAIL.ASS_SUSPENSE_EXT.PIPELINE_NAME;
      SOURCE_FILENAME              <- DETAIL.ASS_SUSPENSE_EXT.SOURCE_FILENAME;
      SERVICE_CODE                 <- DETAIL.ASS_SUSPENSE_EXT.SERVICE_CODE;
      EDR_RECORD_TYPE              <- DETAIL.ASS_SUSPENSE_EXT.EDR_RECORD_TYPE;
      EDR_SIZE                     <- DETAIL.ASS_SUSPENSE_EXT.EDR_SIZE;
      ACCOUNT_POID                 <- DETAIL.ASS_SUSPENSE_EXT.ACCOUNT_POID;
      BATCH_ID                     <- DETAIL.ORIGINAL_BATCH_ID;  
      SUSPENDED_FROM_BATCH_ID      <- DETAIL.ASS_SUSPENSE_EXT.SUSPENDED_FROM_BATCH_ID; 
      UTC_OFFSET_SECONDS           <- DETAIL.ASS_SUSPENSE_EXT.UTC_OFFSET_SECONDS;
      PIPELINE_CATEGORY            <- DETAIL.ASS_SUSPENSE_EXT.PIPELINE_CATEGORY;
    }
  }

  //----------------------------------------------------------------------------
  // EDR record
  //----------------------------------------------------------------------------
  EDR
  {
    STD_MAPPING
    {
      RECORD_TYPE                  <- "030";
      EDR_BUF                      <- DETAIL.ASS_SUSPENSE_EXT.EDR_BUF;
    }
  }

  //----------------------------------------------------------------------------
  // Queryable Fields record
  //----------------------------------------------------------------------------
  QUERYABLE_FIELDS
  {
    STD_MAPPING
    {
      RECORD_TYPE                   <- "040";
      QUERYABLE_FIELDS              <- DETAIL.ASS_SUSPENSE_EXT.QUERYABLE_FIELDS;
    }
  }
}

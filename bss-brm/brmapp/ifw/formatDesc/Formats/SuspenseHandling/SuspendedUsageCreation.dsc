//==============================================================================
//
//      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
//      
//      This material is the confidential property of Oracle Corporation or its
//      licensors and may be used, reproduced, stored or transmitted only in
//      accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: FMD
//------------------------------------------------------------------------------
// Module Description:
//   Description of a suspended usage creation format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
// 
//------------------------------------------------------------------------------
// Responsible: ming-wen sung
//==============================================================================

SUSPENDED_USAGE_CREATION
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
    QUERYABLE_FIELDS_MAPPING            AscString();
  }

  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL(SEPARATED)
  {
    Info
    {
      Pattern = "020.*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    
    RECORD_TYPE                         AscString();
    SUSPENSE_REASON                     AscInteger();
    SUSPENSE_SUBREASON                  AscInteger();
    RECYCLE_KEY				AscString();
    ERROR_CODE                          AscInteger();
    PIPELINE_NAME                       AscString();
    SOURCE_FILENAME                     AscString();
    SERVICE_CODE                        AscString();
    EDR_RECORD_TYPE                     AscString();
    EDR_SIZE                            AscInteger();
    ACCOUNT_POID                        AscString();
    BATCH_ID                            AscString();
    SUSPENDED_FROM_BATCH_ID             AscString();
    UTC_OFFSET_SECONDS                  AscInteger();
    PIPELINE_CATEGORY                   AscString();
  }

  //----------------------------------------------------------------------------
  // EDR record
  //----------------------------------------------------------------------------
  EDR(SEPARATED)
  {
    Info
    {
      Pattern = "030.*\n";
      RecordSeparator = '\n';
      FieldSeparator = '\t';
    }

    RECORD_TYPE                         AscString();
    EDR_BUF                             AscString();
  }

  //----------------------------------------------------------------------------
  // Queryable Fields record
  //----------------------------------------------------------------------------
  QUERYABLE_FIELDS(SEPARATED)
  {
    Info
    {
      Pattern = "040.*\n";
      RecordSeparator = '\n';
      FieldSeparator = '\t';
    }

    RECORD_TYPE                         AscString();
    QUERYABLE_FIELDS                    AscString();
  }

  //----------------------------------------------------------------------------
  // Trailer Record
  //----------------------------------------------------------------------------
  // no trailer defined in suspense_create format

}

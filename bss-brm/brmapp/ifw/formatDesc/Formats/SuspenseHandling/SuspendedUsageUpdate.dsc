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
//   Description of a suspended usage update format
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

SUSPENDED_USAGE_UPDATE
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
  }

  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL(SEPARATED)
  {
    Info
    {
      Pattern = "(020).*\n";
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }
    
    RECORD_TYPE           AscString();
    SUSPENSE_ID           AscInteger();
    STATUS                AscInteger();
    SUSPENSE_REASON       AscInteger();
    SUSPENSE_SUBREASON    AscInteger();
    ERROR_CODE            AscInteger();
    RECYCLE_MODE          AscInteger();
    RECYCLE_KEY           AscString();
  }

  //----------------------------------------------------------------------------
  // Trailer Record
  //----------------------------------------------------------------------------
  // no trailer defined in suspense_update format

}

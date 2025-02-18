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
//   Output mapping for the suspended usage update format
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

SUSPENDED_USAGE_UPDATE
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
    }
  }

  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL
  {
    STD_MAPPING
    {
      RECORD_TYPE         <- "020";
      SUSPENSE_ID         <- DETAIL.ASS_SUSPENSE_EXT.SUSPENSE_ID;
      STATUS              <- DETAIL.ASS_SUSPENSE_EXT.SUSPENSE_STATUS;
      SUSPENSE_REASON     <- DETAIL.ASS_SUSPENSE_EXT.SUSPENSE_REASON;
      SUSPENSE_SUBREASON  <- DETAIL.ASS_SUSPENSE_EXT.SUSPENSE_SUBREASON;
      ERROR_CODE          <- DETAIL.ASS_SUSPENSE_EXT.ERROR_CODE;
      RECYCLE_MODE        <- DETAIL.ASS_SUSPENSE_EXT.RECYCLING_MODE;
      RECYCLE_KEY         <- DETAIL.ASS_SUSPENSE_EXT.RECYCLE_KEY;
    }
  }
}

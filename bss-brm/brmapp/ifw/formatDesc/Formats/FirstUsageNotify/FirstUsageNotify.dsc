// @(#)% %
//==================================================================================
//
//       Copyright (c) 2006 Oracle. All rights reserved.
//
//       This material is the confidential property of Oracle Corporation
//       or its licensors and may be used, reproduced, stored or transmitted
//       only in accordance with a valid Oracle license or sublicense agreement.
//
//-----------------------------------------------------------------------------------
// Block: FMD
//-----------------------------------------------------------------------------------
// Module Description:
//   Description of a FirstUsageNotify UEL output format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//
//  FirstUsageNotify Format:
// --------------------------
// plain ASCII, tab seperated format, one record per line
// Note: Last record must also contain a NL (new line).
//
//
//-----------------------------------------------------------------------------------
// Responsible: Ramesh A
//
//===================================================================================

FIRST_USAGE_NOTIFY
{
  //---------------------------------------------------------------------------------
  // Header record
  //---------------------------------------------------------------------------------
  // no header defined in FirstUsageNotify format

  //---------------------------------------------------------------------------------
  // Detail record
  //---------------------------------------------------------------------------------
  DETAIL(SEPARATED)
  {
    Info
    {
      Pattern = ".*\n";                 // FirstUsageNotify format will only contain detail lines
      FieldSeparator = '\t';
      RecordSeparator = '\n';
    }

    ACCOUNT_POID_STR                    AscString();
    SERVICE_POID_STR                    AscString();
    OFFERING_POID_STR                   AscString();
    START_T                             AscDate("%Y%m%d%H%M%S,GMT");
    UTC_TIME_OFFSET                     AscString();
    DESCRIPTION                         AscString();
    FLAGS                               AscInteger();

  }

  //---------------------------------------------------------------------------------
  // Trailer Record
  //---------------------------------------------------------------------------------
  // no trailer defined in FirstUsageNotify format

}

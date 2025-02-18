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
//   Description of a FirstUsageResource UEL output format
//   -- This generates an output file, which is read by UEL as containing three fields 
//   -- delimted by tab.The additional tab is added by the poid constructed in 
//   -- OutGrammar.
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//
//
//-----------------------------------------------------------------------------------
// Responsible: Ramesh A
//
//===================================================================================

FIRST_USAGE_RESOURCE
{
  //---------------------------------------------------------------------------------
  // Header record
  //---------------------------------------------------------------------------------
  // no header defined in FirstUsageResource format

  //---------------------------------------------------------------------------------
  // Record containing the Account ID
  // Dont add any more elements to this block
  // create a new block to avoid the default field seperator ","
  //---------------------------------------------------------------------------------
  UPDATE_BAL_ACCT(SEPARATED)
  {
    Info
    {
      Pattern = "0111.*\n";
      RecordSeparator = '\t';
    }

    ACCOUNT_POID_STR                      AscString();

  }

  //---------------------------------------------------------------------------------
  // Update Balance  record
  //---------------------------------------------------------------------------------
  UPDATE_BALANCE(SEPARATED)
  {
    Info
    {
      Pattern = "0222.*\n";
      FieldSeparator = ';';
      RecordSeparator = ':';
    }

    BALANCE_GROUP_ID                      AscInteger();
    RESOURCE_ID                           AscInteger();
    RECORD_NUMBER                         AscInteger();
    VALID_FROM                            AscDateUnix();
    VALID_TO                              AscDateUnix();
    VALID_FROM_DETAILS                    AscInteger();
    VALID_TO_DETAILS                      AscInteger();
    CONTRIBUTOR                           AscString();
    GRANTOR                               AscString();
    GRANT_VALID_FROM                      AscDateUnix();
    GRANT_VALID_TO                        AscDateUnix();

  }

  //---------------------------------------------------------------------------------
  // Discount Sub-Balances mapping for other fields
  //---------------------------------------------------------------------------------
  DISCOUNT_SUB_BAL(SEPARATED)
  {
    Info
    {
      Pattern = "0333*\n";
      FieldSeparator = ';';
      RecordSeparator = ':';
    }

    BALANCE_GROUP_ID                      AscInteger();
    RESOURCE_ID                           AscInteger();
    RECORD_NUMBER                         AscInteger();
    VALID_FROM                            AscDateUnix();
    VALID_TO                              AscDateUnix();
    VALID_FROM_DETAILS                    AscInteger();
    VALID_TO_DETAILS                      AscInteger();
    CONTRIBUTOR                           AscString();
    GRANTOR                               AscString();
    GRANT_VALID_FROM                      AscDateUnix();
    GRANT_VALID_TO                        AscDateUnix();

  }



  //---------------------------------------------------------------------------------
  // Add New line
  //---------------------------------------------------------------------------------
  END_BLOCK(SEPARATED)
  {
    Info
    {
     Pattern = "\n";
    }
    EOL                    AscString();
  }

  //---------------------------------------------------------------------------------
  // Trailer Record
  //---------------------------------------------------------------------------------
  // no trailer defined in FirstUsageNotify format

}

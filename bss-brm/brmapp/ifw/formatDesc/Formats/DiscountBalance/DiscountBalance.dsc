//==============================================================================
//
//      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
//      
//      This material is the confidential property of Oracle Corporation or its
//      licensors and may be used, reproduced, stored or transmitted only in
//      accordance with a valid Oracle license or sublicense agreement.
//
//------------------------------------------------------------------------------
// Block: FMD/Formats/DiscountBalance
//------------------------------------------------------------------------------
// Module Description:
//   Block description file for use with the FCT_Balance plugin
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
//------------------------------------------------------------------------------
// Log:
//==============================================================================


//==============================================================================
// formatting of the data received from the DAT_Discount plugin:
//
// DiscountBalance(#10#)
//    |--data
//    |--AggregationPeriod(#20#)
//    |     |--data
//    |--DiscountPacket(#50#)
//    |     |--data
//    |--EndKey(#90#)
//==============================================================================

DiscountBalance
{
  //----------------------------------------------------------------------------
  // DiscountBalance record
  //----------------------------------------------------------------------------
  DiscountBalance(SEPARATED)
  {
    Info
    {
      Pattern = "#10#.*\n";
      FieldSeparator = ';';
      RecordSeparator = '\n';
    }
    RECORD_IDENTIFIER         AscString();  // will eat the "#10#"
    DISCOUNT_KEY              AscString();
    RESOURCE_ID               AscInteger(); 
    ACCOUNT_ID                AscInteger();
    DISCOUNT_STEP             AscInteger();
    DISCOUNT_MASTER           AscInteger();
    UPDATE_LEVEL           	  AscString(); // added to support V3 file format
    SERVICE_ID           	  AscInteger(); // added to support V3 file format
  }
  
  //----------------------------------------------------------------------------
  // AggregationPeriod record
  //----------------------------------------------------------------------------
  AggregationPeriod(SEPARATED)
  {
    Info
    {
      Pattern = "#20#.*\n";
      FieldSeparator = ';';
      RecordSeparator = '\n';
    }
    RECORD_IDENTIFIER           AscString();  // will eat the "#20#"
    PERIOD                      AscString();
    ITEM_POID                   AscString();
    CREATED                     AscString();
    TOTAL_CHARGE                AscDecimal();
    TOTAL_QUANTITY              AscDecimal();
    TOTAL_EVENT                 AscDecimal();
    GRANTED_CHARGE              AscDecimal();
    GRANTED_QUANTITY            AscDecimal();
    FRAME_CHARGE                AscDecimal();
    FRAME_QUANTITY              AscDecimal();
    FRAME_EVENT                 AscDecimal();
  }

  //----------------------------------------------------------------------------
  // DiscountPacket record
  //----------------------------------------------------------------------------
  DiscountPacket(SEPARATED)
  {
    Info
    {
      Pattern = "#50#.*\n";
      FieldSeparator = ';';
      RecordSeparator = '\n';
    }
    RECORD_IDENTIFIER           AscString();  // will eat the "#50#"
    PERIOD                      AscString();
    ITEM_POID                   AscString();
    CREATED                     AscString();
    EXPIRATION                  AscString();
    EXPIRED                     AscInteger();
    INITIAL_UNITS               AscDecimal();
    USED_UNITS                  AscDecimal();
    UNUSED_UNITS                AscDecimal();
    EXPIRED_UNITS               AscDecimal();
    BUNDLE_TOTAL_THIS_PERIOD    AscDecimal();
    BUNDLE_TOTAL_REMAINING      AscDecimal();
  }

  //----------------------------------------------------------------------------
  // EndKey record
  //----------------------------------------------------------------------------
  EndKey(SEPARATED)
  {
    Info
    {
      Pattern = "#90#.*\n";
      FieldSeparator = ';';
      RecordSeparator = '\n';
    }
    RECORD_IDENTIFIER         AscString();  // will eat the "#90#"
  }
}

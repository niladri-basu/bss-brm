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
//   Mapping file for use with the FCT_Balace plugin
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

DiscountBalance
{     
  //----------------------------------------------------------------------------
  // DiscountBalance record
  //----------------------------------------------------------------------------
  DiscountBalance
  {
    STD_MAPPING
    {
      DISCOUNT_KEY      -> DETAIL.DI.DB.DISCOUNT_KEY;
      RESOURCE_ID       -> DETAIL.DI.DB.RESOURCE_ID;
      ACCOUNT_ID        -> DETAIL.DI.DB.ACCOUNT_ID;
      DISCOUNT_STEP     -> DETAIL.DI.DB.DISCOUNT_STEP;
      DISCOUNT_MASTER   -> DETAIL.DI.DB.DISCOUNT_MASTER;
      UPDATE_LEVEL      -> DETAIL.DI.DB.UPDATE_LEVEL;
      SERVICE_ID        -> DETAIL.DI.DB.SERVICE_ID;
    }
  }

  //----------------------------------------------------------------------------
  // AggregationPeriod record
  //----------------------------------------------------------------------------
  AggregationPeriod
  {
    STD_MAPPING
    {
      PERIOD            -> DETAIL.DI.DB.AGGREGATIONS.PERIOD;
      ITEM_POID         -> DETAIL.DI.DB.AGGREGATIONS.ITEM_POID;
      CREATED           -> DETAIL.DI.DB.AGGREGATIONS.CREATED;
      TOTAL_CHARGE      -> DETAIL.DI.DB.AGGREGATIONS.TOTAL_CHARGE;
      TOTAL_QUANTITY    -> DETAIL.DI.DB.AGGREGATIONS.TOTAL_QUANTITY;
      TOTAL_EVENT       -> DETAIL.DI.DB.AGGREGATIONS.TOTAL_EVENT;
      GRANTED_CHARGE    -> DETAIL.DI.DB.AGGREGATIONS.GRANTED_CHARGE;
      GRANTED_QUANTITY  -> DETAIL.DI.DB.AGGREGATIONS.GRANTED_QUANTITY;
      FRAME_CHARGE      -> DETAIL.DI.DB.AGGREGATIONS.FRAME_CHARGE;
      FRAME_QUANTITY    -> DETAIL.DI.DB.AGGREGATIONS.FRAME_QUANTITY;
      FRAME_EVENT       -> DETAIL.DI.DB.AGGREGATIONS.FRAME_EVENT;
    }
  }
  
  //----------------------------------------------------------------------------
  // DiscountPacket record
  //----------------------------------------------------------------------------
  DiscountPacket
  {
    STD_MAPPING
    {
      PERIOD                    -> DETAIL.DI.DB.DETAILS.PERIOD;
      ITEM_POID                 -> DETAIL.DI.DB.DETAILS.ITEM_POID;
      CREATED                   -> DETAIL.DI.DB.DETAILS.CREATED;
      EXPIRATION                -> DETAIL.DI.DB.DETAILS.EXPIRATION;
      EXPIRED                   -> DETAIL.DI.DB.DETAILS.EXPIRED;
      INITIAL_UNITS             -> DETAIL.DI.DB.DETAILS.INITIAL_UNITS;
      USED_UNITS                -> DETAIL.DI.DB.DETAILS.USED_UNITS;
      UNUSED_UNITS              -> DETAIL.DI.DB.DETAILS.UNUSED_UNITS;
      EXPIRED_UNITS             -> DETAIL.DI.DB.DETAILS.EXPIRED_UNITS;
      BUNDLE_TOTAL_THIS_PERIOD  -> DETAIL.DI.DB.DETAILS.BUNDLE_TOTAL_THIS_PERIOD;
      BUNDLE_TOTAL_REMAINING    -> DETAIL.DI.DB.DETAILS.BUNDLE_TOTAL_REMAINING;
    }
  }
}

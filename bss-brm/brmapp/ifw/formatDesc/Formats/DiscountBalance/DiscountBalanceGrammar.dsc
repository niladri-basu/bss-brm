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
//   Input grammar file for use with the FCT_Balance plugin
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
//==============================================================================

//==============================================================================
// The definition of the grammar
//==============================================================================
Grammar
{
  Start:
        {
          edrAddDatablock( DETAIL.DI );
        }
      discountBalance
    ;

  discountBalance:
      discountBalance
      DiscountBalance.DiscountBalance
        {
          edrAddDatablock( DETAIL.DI.DB );
          edrInputMap( "DiscountBalance.DiscountBalance.STD_MAPPING" );
        }
      subblocks
      DiscountBalance.EndKey
    | /* EMPTY */
    ;

  subblocks:
      subblocks subblock
    | /* EMPTY */
    ;

  subblock:
      aggregationPeriod
    | discountPacket
    ;

  aggregationPeriod:
      DiscountBalance.AggregationPeriod
        {
          edrAddDatablock( DETAIL.DI.DB.AGGREGATIONS );
          edrInputMap( "DiscountBalance.AggregationPeriod.STD_MAPPING" );
        }
    ;

  discountPacket:
      DiscountBalance.DiscountPacket
        {
          edrAddDatablock( DETAIL.DI.DB.DETAILS );
          edrInputMap( "DiscountBalance.DiscountPacket.STD_MAPPING" );
        }
    ;
}

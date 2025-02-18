// @(#)% %
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
//   Input Mapping of a Simple Sample CDR format
//
// Open Points:
//   <open points>
//
// Review Status:
//   in-work
//
//------------------------------------------------------------------------------
// Responsible: bniederg
//
// $RCSfile: SIMPLESAMPLE_v1_InMap.dsc,v $
// $Revision: 1.4 $
// $Author: ralwarap $
// $Date: 2004/04/07 16:58:57 $
// $Locker:  $
//------------------------------------------------------------------------------
// $Log: SIMPLESAMPLE_v1_InMap.dsc,v $
// Revision 1.4  2004/04/07 16:58:57 ralwarap
// Mapped "NE CHARGING START TIMESTAMP" and  "NE CHARGING END TIMESTAMP" to START_TIMESTAMP
//
// Revision 1.3  2001/12/05 12:25:57  mf
// pets:#42270 - topic 1: added new field "CHARGING END TIMESTAMP"
//
// Revision 1.2  2001/11/30 21:09:43  pengelbr
// Update input mapping. REL could not recognize the DETAIL...
//
// Revision 1.1  2001/11/20 15:31:48  mf
// New  samples including the "Bernd N." stuff
//
// Revision 1.00  2001/11/14 06:54:55  bniederg
//==============================================================================

SIMPLESAMPLE_V1
{
  //----------------------------------------------------------------------------
  // Detail record
  //----------------------------------------------------------------------------
  DETAIL
  {
    HDR_MAPPING
    {
      "010"                       -> HEADER.RECORD_TYPE;
      1                           -> HEADER.RECORD_NUMBER;
      ""                          -> HEADER.SENDER;
      ""                          -> HEADER.RECIPIENT;
      "+0100"                     -> HEADER.UTC_TIME_OFFSET;
      1                           -> HEADER.SPECIFICATION_VERSION_NUMBER;
      0                           -> HEADER.RELEASE_VERSION;
      "0049"                      -> HEADER.ORIGIN_COUNTRY_CODE;
      "0049"                      -> HEADER.SENDER_COUNTRY_CODE;
      " "                         -> HEADER.DATA_TYPE_INDICATOR;
      "00"                        -> HEADER.IAC_LIST;
      "49"                        -> HEADER.CC_LIST;
    }

    TRL_MAPPING
    {
      "090"                       -> TRAILER.RECORD_TYPE;
      ""                          -> TRAILER.SENDER;
      ""                          -> TRAILER.RECIPIENT;
    }

    STD_MAPPING
    {
      "020"                       -> DETAIL.RECORD_TYPE;                       // default GSM-MOC
      0                           -> DETAIL.DISCARDING;
      "S"                         -> DETAIL.TYPE_OF_A_IDENTIFICATION;
      "00"                        -> DETAIL.A_MODIFICATION_INDICATOR;
      0                           -> DETAIL.A_TYPE_OF_NUMBER;
      "0"                         -> DETAIL.A_NUMBERING_PLAN;
      A_NUMBER                    -> DETAIL.A_NUMBER;
      A_NUMBER                    -> DETAIL.INTERN_A_NUMBER_ZONE;
      "00"                        -> DETAIL.B_MODIFICATION_INDICATOR;
      0                           -> DETAIL.B_TYPE_OF_NUMBER;
      "0"                         -> DETAIL.B_NUMBERING_PLAN;
      B_NUMBER                    -> DETAIL.B_NUMBER;
      B_NUMBER                    -> DETAIL.INTERN_B_NUMBER_ZONE;
      "0"                         -> DETAIL.USAGE_DIRECTION;                   // MOC
      "17"                        -> DETAIL.CONNECT_TYPE;
      "01"                        -> DETAIL.CONNECT_SUB_TYPE;
      SERVICE                     -> DETAIL.BASIC_SERVICE;
      SERVICE                     -> DETAIL.INTERN_SERVICE_CODE;
      "DEF"                       -> DETAIL.INTERN_SERVICE_CLASS;
      "00"                        -> DETAIL.CALL_COMPLETION_INDICATOR;         // no-error
      "S"                         -> DETAIL.LONG_DURATION_INDICATOR;           // single
      START_TIMESTAMP             -> DETAIL.CHARGING_START_TIMESTAMP;
      START_TIMESTAMP             -> DETAIL.CHARGING_END_TIMESTAMP;
      START_TIMESTAMP             -> DETAIL.NE_CHARGING_START_TIMESTAMP;
      START_TIMESTAMP             -> DETAIL.NE_CHARGING_END_TIMESTAMP;
      START_TIMESTAMP             -> DETAIL.CREATED_TIMESTAMP;
      "+0100"                     -> DETAIL.UTC_TIME_OFFSET;
      DURATION                    -> DETAIL.DURATION;
      "SEC"                       -> DETAIL.DURATION_UOM;
      VOL_SENT                    -> DETAIL.VOLUME_SENT;
      "BYT"                       -> DETAIL.VOLUME_SENT_UOM;
      VOL_RECEIVED                -> DETAIL.VOLUME_RECEIVED;
      "BYT"                       -> DETAIL.VOLUME_RECEIVED_UOM;
      1.0                           -> DETAIL.NUMBER_OF_UNITS;
      "CLK"                       -> DETAIL.NUMBER_OF_UNITS_UOM;
      CALLCLASS                   -> DETAIL.USAGE_CLASS;
      0                           -> DETAIL.PREPAID_INDICATOR;
    }

    GSMW_MAPPING
    {
      "520"                       -> DETAIL.ASS_GSMW_EXT.RECORD_TYPE;                       // default Ass.GSM
      A_NUMBER                    -> DETAIL.ASS_GSMW_EXT.A_NUMBER_USER;
      B_NUMBER                    -> DETAIL.ASS_GSMW_EXT.DIALED_DIGITS;
      CELL_ID                     -> DETAIL.ASS_GSMW_EXT.CELL_ID;
      0                           -> DETAIL.ASS_GSMW_EXT.TIME_BEFORE_ANSWER;
      0                           -> DETAIL.ASS_GSMW_EXT.NUMBER_OF_SS_PACKETS;
    }

    GPRS_MAPPING
    {
      "540"                       -> DETAIL.ASS_GPRS_EXT.RECORD_TYPE;                       // default Ass.GPRS
      APN                         -> DETAIL.ASS_GPRS_EXT.APN_ADDRESS;
    }
  }

}

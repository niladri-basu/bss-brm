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
      UTCTimeOffset               -> HEADER.UTC_TIME_OFFSET;
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
      ANumber                    -> DETAIL.A_NUMBER;
      ANumber                    -> DETAIL.INTERN_A_NUMBER_ZONE;
      "00"                        -> DETAIL.B_MODIFICATION_INDICATOR;
      0                           -> DETAIL.B_TYPE_OF_NUMBER;
      "0"                         -> DETAIL.B_NUMBERING_PLAN;
      BNumber                    -> DETAIL.B_NUMBER;
      BNumber                    -> DETAIL.INTERN_B_NUMBER_ZONE;
      UsageDirection                         -> DETAIL.USAGE_DIRECTION;                   // MOC
      "17"                        -> DETAIL.CONNECT_TYPE;
      "01"                        -> DETAIL.CONNECT_SUB_TYPE;
      RecordType                     -> DETAIL.BASIC_SERVICE;
      RecordType                     -> DETAIL.INTERN_SERVICE_CODE;
      "DEF"                       -> DETAIL.INTERN_SERVICE_CLASS;
      "00"                        -> DETAIL.CALL_COMPLETION_INDICATOR;         // no-error
      "S"                         -> DETAIL.LONG_DURATION_INDICATOR;           // single
      EventStartTime             -> DETAIL.CHARGING_START_TIMESTAMP;
      EventEndTime             -> DETAIL.CHARGING_END_TIMESTAMP;
      EventStartTime             -> DETAIL.NE_CHARGING_START_TIMESTAMP;
      EventEndTime             -> DETAIL.NE_CHARGING_END_TIMESTAMP;
      EventEndTime             -> DETAIL.CREATED_TIMESTAMP;
      UTCTimeOffset              -> DETAIL.UTC_TIME_OFFSET;
      ActualQuantity                    -> DETAIL.DURATION;
      "SEC"                       -> DETAIL.DURATION_UOM;
      //"AMT"                       -> DETAIL.DURATION_UOM;
      0.0                    -> DETAIL.VOLUME_SENT;
      "BYT"                       -> DETAIL.VOLUME_SENT_UOM;
      0.0                -> DETAIL.VOLUME_RECEIVED;
      "BYT"                       -> DETAIL.VOLUME_RECEIVED_UOM;
      1.0                           -> DETAIL.NUMBER_OF_UNITS;
      "CLK"                       -> DETAIL.NUMBER_OF_UNITS_UOM;
      ChargeableUnits                           -> DETAIL.NUMBER_OF_UNITS;
      "AMT"                       -> DETAIL.NUMBER_OF_UNITS_UOM;
      "NORM"                   -> DETAIL.USAGE_CLASS;
      0                           -> DETAIL.PREPAID_INDICATOR;
      //AMOUNT			  -> DETAIL.RETAIL_CHARGED_AMOUNT_VALUE;
      Amount			  -> DETAIL.WHOLESALE_CHARGED_AMOUNT_VALUE;
      "NZD"			  -> DETAIL.WHOLESALE_CHARGED_AMOUNT_CURRENCY;
      //RecordNumber			  -> DETAIL.EVENT_ID;
      Description			  -> DETAIL.DESCRIPTION;
      ChargedQuantity		  -> DETAIL.ACTUAL_QUANTITY;
      CallType			  -> DETAIL.USAGE_TYPE;
      SourceNetwork			  -> DETAIL.SOURCE_NETWORK;
      DestinationNetwork			  -> DETAIL.DESTINATION_NETWORK;
    }

    GSMW_MAPPING
    {
      "520"                       -> DETAIL.ASS_GSMW_EXT.RECORD_TYPE;                       // default Ass.GSM
      ANumber                    -> DETAIL.ASS_GSMW_EXT.A_NUMBER_USER;
      BNumber                    -> DETAIL.ASS_GSMW_EXT.DIALED_DIGITS;
      CellId                     -> DETAIL.ASS_GSMW_EXT.CELL_ID;
      SourceNetwork			  -> DETAIL.ASS_GSMW_EXT.ORIGINATING_SWITCH_IDENTIFICATION;
      DestinationNetwork			  -> DETAIL.ASS_GSMW_EXT.TERMINATING_SWITCH_IDENTIFICATION;
      0                           -> DETAIL.ASS_GSMW_EXT.TIME_BEFORE_ANSWER;
      0                           -> DETAIL.ASS_GSMW_EXT.NUMBER_OF_SS_PACKETS;
    }

    GPRS_MAPPING
    {
      "540"                       -> DETAIL.ASS_GPRS_EXT.RECORD_TYPE;                       // default Ass.GPRS
      //APN                         -> DETAIL.ASS_GPRS_EXT.APN_ADDRESS;
    }
//--------------------------------------------------------------------------------
// CUSTOM_INFO - Added by GSM
//--------------------------------------------------------------------------------
 
    ASS_CI_MAPPING
    {
       "888"                       -> DETAIL.ASS_CI.RECORD_TYPE;                       // default CI
	GLId                        -> DETAIL.ASS_CI.GL_ID;
	GSTflag					 -> DETAIL.ASS_CI.GST;
	CDRType					 -> DETAIL.ASS_CI.CDR_TYPE;
	Sequence_Number				 -> DETAIL.ASS_CI.SEQUENCE_NUMBER;
	AccountType				 -> DETAIL.ASS_CI.ACCOUNT_TYPE;
	CashAmountQuantity			 -> DETAIL.ASS_CI.CASH_AMOUNT_QUANTITY;
	BundleAmountQuantity			 -> DETAIL.ASS_CI.BUNDLE_AMOUNT_QUANTITY;
        OriginatingCountry                       -> DETAIL.ASS_CI.ORIGINATING_COUNTRY;
        OriginatingZone                          -> DETAIL.ASS_CI.ORIGINATING_ZONE;
	DestinationCountry			 -> DETAIL.ASS_CI.DESTINATION_COUNTRY;
	DestinationZone				 -> DETAIL.ASS_CI.DESTINATION_ZONE;
	CascadeId				 -> DETAIL.ASS_CI.CASCADE_ID;
	EndCallReason				 -> DETAIL.ASS_CI.END_CALL_REASON;
	RatingGroupCode				 -> DETAIL.ASS_CI.RATING_GROUP_CODE;
	RatingGroupType				 -> DETAIL.ASS_CI.RATING_GROUP_TYPE;
	Rates					 -> DETAIL.ASS_CI.RATES;
	Mfile					 -> DETAIL.ASS_CI.MFILE;
	InPackageCode					 -> DETAIL.ASS_CI.IN_PACKAGE_CODE;
	Product					 -> DETAIL.ASS_CI.PRODUCT;
	SharersMSISDN					 -> DETAIL.ASS_CI.SHARERS_MSISDN;
	SharersProduct					 -> DETAIL.ASS_CI.SHARERS_PRODUCT;
	SHRD					 -> DETAIL.ASS_CI.SHRD;
	SCPId					 -> DETAIL.ASS_CI.SCP_ID;
	RecordDate					 -> DETAIL.ASS_CI.RECORD_DATE;
	AcctId					 -> DETAIL.ASS_CI.ACCT_ID;
	AcctRefId					 -> DETAIL.ASS_CI.ACCT_REF_ID;
	CLI					 -> DETAIL.ASS_CI.CLI;
	OGEOId					 -> DETAIL.ASS_CI.OGEO_ID;
	TGEOId					 -> DETAIL.ASS_CI.TGEO_ID;
	OverriddenTariffPlan					 -> DETAIL.ASS_CI.OVERRIDDEN_TARIFF_PLAN;
        OriginatingCountry                       -> DETAIL.ASS_CI.ORIGINATING_COUNTRY;
        OriginatingZone                          -> DETAIL.ASS_CI.ORIGINATING_ZONE;

    }

    ASS_TEL_MAPPING
    {
       "891"          -> DETAIL.ASS_CI.ASS_TEL.RECORD_TYPE;                       // default TEL
        CellId        -> DETAIL.ASS_CI.ASS_TEL.CELL_ID;
        SK            -> DETAIL.ASS_CI.ASS_TEL.SK;
        IMSI          -> DETAIL.ASS_CI.ASS_TEL.IMSI;
        LocNum        -> DETAIL.ASS_CI.ASS_TEL.LOC_NUM;
        CallId        -> DETAIL.ASS_CI.ASS_TEL.CALL_ID;
        RDPN          -> DETAIL.ASS_CI.ASS_TEL.RDPN;
        TN            -> DETAIL.ASS_CI.ASS_TEL.TN;
    }

    ASS_SMS_MAPPING
    {
       "892"          -> DETAIL.ASS_CI.ASS_SMS.RECORD_TYPE;                       // default SMS
       EventClass	     -> DETAIL.ASS_CI.ASS_SMS.EVENT_CLASS;
       EventName	     -> DETAIL.ASS_CI.ASS_SMS.EVENT_NAME;
       EventCost	     -> DETAIL.ASS_CI.ASS_SMS.EVENT_COST;
       EventTimeCost	     -> DETAIL.ASS_CI.ASS_SMS.EVENT_TIME_COST;
       EventDataCost	     -> DETAIL.ASS_CI.ASS_SMS.EVENT_DATA_COST;
       EventUnitCost	     -> DETAIL.ASS_CI.ASS_SMS.EVENT_UNIT_COST;
       Cascade	     -> DETAIL.ASS_CI.ASS_SMS.CASCADE;
       ProdCatID	     -> DETAIL.ASS_CI.ASS_SMS.PROD_CAT_ID;
    }


    ASS_DAT_MAPPING
    {
       "893"          -> DETAIL.ASS_CI.ASS_DAT.RECORD_TYPE;                       // default DAT
       CS	     -> DETAIL.ASS_CI.ASS_DAT.CS;
       DiscountType	     -> DETAIL.ASS_CI.ASS_DAT.DISCOUNT_TYPE;
       Multiplier	     -> DETAIL.ASS_CI.ASS_DAT.MULTIPLIER;
       Oprod	     -> DETAIL.ASS_CI.ASS_DAT.OPROD;
       UMS	     -> DETAIL.ASS_CI.ASS_DAT.UMS;
       UProd	     -> DETAIL.ASS_CI.ASS_DAT.UPROD;
    }

    ASS_VV_MAPPING
    {
       "894"          -> DETAIL.ASS_CI.ASS_VV.RECORD_TYPE;                       // default VV
       EXT1	     -> DETAIL.ASS_CI.ASS_VV.EXT1;
       EXT2	     -> DETAIL.ASS_CI.ASS_VV.EXT2;
       EXT4	     -> DETAIL.ASS_CI.ASS_VV.EXT4;
       ChargeExpiry	     -> DETAIL.ASS_CI.ASS_VV.CHARGE_EXPIRY;
       ChargeName	     -> DETAIL.ASS_CI.ASS_VV.CHARGE_NAME;
       NewAcctExpiry	     -> DETAIL.ASS_CI.ASS_VV.NEW_ACCT_EXPIRY;
       NewBalanceExpires	     -> DETAIL.ASS_CI.ASS_VV.NEW_BALANCE_EXPIRIES;
       NewChargeState	     -> DETAIL.ASS_CI.ASS_VV.NEW_CHARGE_STATE;
       OldAcctExpiry	     -> DETAIL.ASS_CI.ASS_VV.OLD_ACCT_EXPIRY;
       OldBalanceExpires	     -> DETAIL.ASS_CI.ASS_VV.OLD_BALANCE_EXPIRIES;
       OldChargeExpiry	     -> DETAIL.ASS_CI.ASS_VV.OLD_CHARGE_EXPIRY;
       OldChargeState	     -> DETAIL.ASS_CI.ASS_VV.OLD_CHARGE_STATE;
       Partner	     -> DETAIL.ASS_CI.ASS_VV.PARTNER;
       Payment	     -> DETAIL.ASS_CI.ASS_VV.PAYMENT;
       Reference	     -> DETAIL.ASS_CI.ASS_VV.REFERENCE;
       Result	     -> DETAIL.ASS_CI.ASS_VV.RESULT;
       TxID	     -> DETAIL.ASS_CI.ASS_VV.TX_ID;
       VoucherType	     -> DETAIL.ASS_CI.ASS_VV.VOUCHER_TYPE;
       ValuepackType	     -> DETAIL.ASS_CI.ASS_VV.VP_TYPE;
	   EXT3				-> DETAIL.ASS_CI.ASS_VV.EXT3;
	   Description2		-> DETAIL.ASS_CI.ASS_VV.DESCRIPTION2;
	   Description3		-> DETAIL.ASS_CI.ASS_VV.DESCRIPTION3;
	   Volume			-> DETAIL.ASS_CI.ASS_VV.VOLUME;
	   Unit				-> DETAIL.ASS_CI.ASS_VV.UNIT;
	   PackGroupDisplay		-> DETAIL.ASS_CI.ASS_VV.PK_GROUP_DISPLAY;
    }

    ASS_VOM_MAPPING
    {
       "895"          -> DETAIL.ASS_CI.ASS_VOM.RECORD_TYPE;                       // default VOM
        CellId        -> DETAIL.ASS_CI.ASS_VOM.CELL_ID;
        SK            -> DETAIL.ASS_CI.ASS_VOM.SK;
        IMSI          -> DETAIL.ASS_CI.ASS_VOM.IMSI;
        LocNum        -> DETAIL.ASS_CI.ASS_VOM.LOC_NUM;
        CallId        -> DETAIL.ASS_CI.ASS_VOM.CALL_ID;
        RDPN          -> DETAIL.ASS_CI.ASS_VOM.RDPN;
        TN            -> DETAIL.ASS_CI.ASS_VOM.TN;
    }

    ASS_MMS_MAPPING
    {
       "896"          -> DETAIL.ASS_CI.ASS_MMS.RECORD_TYPE;                       // default MMS
       EventClass            -> DETAIL.ASS_CI.ASS_MMS.EVENT_CLASS;
       EventName             -> DETAIL.ASS_CI.ASS_MMS.EVENT_NAME;
       EventCost             -> DETAIL.ASS_CI.ASS_MMS.EVENT_COST;
       EventTimeCost         -> DETAIL.ASS_CI.ASS_MMS.EVENT_TIME_COST;
       EventDataCost         -> DETAIL.ASS_CI.ASS_MMS.EVENT_DATA_COST;
       EventUnitCost         -> DETAIL.ASS_CI.ASS_MMS.EVENT_UNIT_COST;
       Cascade       -> DETAIL.ASS_CI.ASS_MMS.CASCADE;
       ProdCatID             -> DETAIL.ASS_CI.ASS_MMS.PROD_CAT_ID;
    }

    ASS_VAS_MAPPING
    {
       "897"          			-> DETAIL.ASS_CI.ASS_VAS.RECORD_TYPE;                       // default VAS
       EXT1          			-> DETAIL.ASS_CI.ASS_VAS.EXT1;
       EXT2          			-> DETAIL.ASS_CI.ASS_VAS.EXT2;
       EXT4          			-> DETAIL.ASS_CI.ASS_VAS.EXT4;
       ChargeExpiry          		-> DETAIL.ASS_CI.ASS_VAS.CHARGE_EXPIRY;
       ChargeName            		-> DETAIL.ASS_CI.ASS_VAS.CHARGE_NAME;
       NewAcctExpiry         		-> DETAIL.ASS_CI.ASS_VAS.NEW_ACCT_EXPIRY;
       NewBalanceExpires             	-> DETAIL.ASS_CI.ASS_VAS.NEW_BALANCE_EXPIRIES;
       NewChargeState        		-> DETAIL.ASS_CI.ASS_VAS.NEW_CHARGE_STATE;
       OldAcctExpiry         		-> DETAIL.ASS_CI.ASS_VAS.OLD_ACCT_EXPIRY;
       OldBalanceExpires             	-> DETAIL.ASS_CI.ASS_VAS.OLD_BALANCE_EXPIRIES;
       OldChargeExpiry       		-> DETAIL.ASS_CI.ASS_VAS.OLD_CHARGE_EXPIRY;
       OldChargeState        		-> DETAIL.ASS_CI.ASS_VAS.OLD_CHARGE_STATE;
       Partner      			-> DETAIL.ASS_CI.ASS_VAS.PARTNER;
       Payment    			-> DETAIL.ASS_CI.ASS_VAS.PAYMENT;
       Reference  		        -> DETAIL.ASS_CI.ASS_VAS.REFERENCE;
       Result        			-> DETAIL.ASS_CI.ASS_VAS.RESULT;
       TxID          			-> DETAIL.ASS_CI.ASS_VAS.TX_ID;
       VoucherType          		-> DETAIL.ASS_CI.ASS_VAS.VOUCHER_TYPE;
       ValuepackType        		-> DETAIL.ASS_CI.ASS_VAS.VP_TYPE;
       EXT3				-> DETAIL.ASS_CI.ASS_VAS.EXT3;
       Description2			-> DETAIL.ASS_CI.ASS_VAS.DESCRIPTION2;
       Description3			-> DETAIL.ASS_CI.ASS_VAS.DESCRIPTION3;
       Volume				-> DETAIL.ASS_CI.ASS_VAS.VOLUME;
       Unit				-> DETAIL.ASS_CI.ASS_VAS.UNIT;
       PackGroupDisplay			-> DETAIL.ASS_CI.ASS_VAS.PK_GROUP_DISPLAY;
    }

  }
}

#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# @(#)$Id: pin_rel_preprocess_cdr.pl /cgbubrm_7.5.0.portalbase/6 2014/07/18 10:32:30 vivilin Exp $
#
# Copyright (c) 2001, 2014, Oracle and/or its affiliates. All rights reserved.
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license
#       or sublicense agreement.
#
#
require "classid_values.txt";
use Math::BigInt;
use File::Basename;

$USAGE = 
"Usage: inFile interimDir tablesStr startPoid endPoid incrPoid sortLimit flags single_row_event_enabled virtual_col\n";


#
# Define debug flag
#
$debug = 1;

#
# Define all the constants required for CDR file
#
$deli = "\t";
$dtlRec = "020";
$balRec = "900";  		# event_t
$balImpRec = "600"; 		# event_bal_impacts_t
$subBalImpRec = "605"; 		# event_essentials_t
$subBalRec = "607"; 		# event_essentials_t
$gsmRec = "520";
$gprsRec = "540";
$wapRec = "570";
$suplServEvtRecType = "620";
$taxJurisRec = "615";
$monitor_balImpRec = "800"; 	# event_essentials_t
$monitor_subBalImpRec = "805"; 	# event_essentials_t
$monitor_subBalRec = "807";  	# event_essentials_t
$rumMapRec = "400";             # event_rum_map_t
$profileEventOrderingRec = "850";

# gsmCust and ncrCust are added to identify custom records for 2degrees
$gsmCust = "888";               # event_dlyd_session_custom_t
$ncrRec = "890";                  # event_dlyd_session_bal_cust_t
$gsmVoice = "891";              # event_dlyd_session_voice_t
$gsmSMS = "892";              # event_dlyd_session_sms_t
$gsmMMS = "896";              # event_dlyd_session_mms_t
$gsmData = "893";              # event_dlyd_session_data_t
$gsmVP = "894";              # event_dlyd_session_vp_t
$gsmVOM = "895";              # event_dlyd_session_vom_t
$gsmVAS = "897";              # event_dlyd_session_vas_t


$trailRec = "090";               # Trailer Record
$pDeli    = " ";                 # Poid delimiter
$recEnd   = "\n";                # Record End
#
# Script return values
# 0-99:    Portal reserved range
# 100-255: Customer reserved range
#
$PREPROCESS_SUCCESS = 0;
$USAGE_ERR = 1;
$CANT_OPEN_FILE = 2;
$MISSING_BAL_REC = 3;
$MISSING_DTL_REC = 4;
$UNSUPPORTED_TABLE = 5;
$END_POID_NOT_MATCHED = 7;
$SERIALIZED_DATA_EXCEEDS_LIMIT = 11;
$INVALID_CONST_STR = 12;
$INVALID_EVENT_POID_IN_CONST_STR = 13;
$UNSUPPORTED_GRANTOR_OBJECT_TYPE = 15;
$UNSUPPORTED_RECORD_FORMAT = 16;

#
# Define constants for serializing sub balance impact data
#
$SER_RECORD_DELIMITER = "\n";
$SER_VERSION = "C1,3.0" . $SER_RECORD_DELIMITER;
$SER_DELIMITER = ":";
$SER_DB_NO_DELIMITER = ";";
$SER_FIELD_VALUE_DELIMITER = ",";
$SUB_BAL_IMPACTS_PREFIX = "1:7754";
$SUB_BALANCES_PREFIX = "2:7753";
$MON_SUB_BAL_IMPACTS_PREFIX = "1:9232";
$MON_SUB_BALANCES_PREFIX = "1:9233";

$VARCHAR2_SIZE_LIMIT = 4000;
$CLOB_SIZE_LIMIT = 4294967296;
%balGrpPoids = ();
$BAL_GRP_OBJ_POSITION = 3;	       # from bal impact record
$BILLING_ACCOUNT_OBJ_POS = 2;          # from billing record
$SUB_BAL_IMP_REC_ID_POS = 1;           # from sub bal impacts record
$SUB_BAL_IMP_BAL_GRP_OBJ_POS = 2;      # from sub bal impacts record
$SUB_BAL_IMP_RESOURCE_ID_POS = 3;      # from sub bal impacts record
$SUB_BALANCES_REC_ID_POS = 1;          # from sub balances record
$SUB_BALANCES_AMOUNT_POS = 2;          # from sub balances record
$SUB_BALANCES_VALID_FROM_POS = 3;      # from sub balances record
$SUB_BALANCES_VALID_TO_POS = 4;        # from sub balances record
$SUB_BALANCES_CONTRIBUTOR_POS = 5;     # from sub balances record
$SUB_BALANCES_GRANTOR_OBJ_POS = 6;             # from sub balances record
$SUB_BALANCES_VALID_FROM_DETAILS_POS = 7;      # from sub balances record
$SUB_BALANCES_VALID_TO_DETAILS_POS = 8;        # from sub balances record
$OBJ_DB_POS = 0;                       # from POID value
$OBJ_TYPE_POS = 1;                     # from POID value
$OBJ_ID0_POS = 2;                      # from POID value
$END_T_POS = 29;
$DEFAULT_ROLLOVER_DATA = 0;
$MON_BAL_REC_ID_POS = 1;               #monitor bal impact record
$MON_BAL_ACCOUNT_OBJ_POS = 2;
$MON_BAL_GRP_OBJ_POS = 3;
$MON_BAL_RESOURCE_ID_POS = 4;
$MON_BAL_AMOUNT_POS  = 5;

#
#Define constants as Sql Server'BCP is not supporting constants in FMT files.
#
$AMOUNT_EXMT    = 0;    # Set to zero as exemption isn't handled for d_event_tax_jurisdictions_t
$NAME_SPC       = ' ';  # Set to space for d_event_tax_jurisdictions_t
$PROG_NAME      = "REL"; 		# for d_event_t
$POID_REV       = 0;			# for d_event_t
$READ_ACCESS    = "L";			# for d_event_t
$WRITE_ACCESS   = "L";			# for d_event_t
$NAME           = "Pre-rated Event";	# for d_event_t
$EARNED_START_T = 0;			# for d_event_t
$EARNED_END_T   = 0;			# for d_event_t
$EARNED_TYPE    = 0;			# for d_event_t
$ARCHIVE_STATUS = 0;			# for d_event_t


#
# DEFINE SORT RELATED VARIABLES
#
$headersRef, $cdrsRef, $trailersRef;
$G_cdrsRef, $G_hdrsRef, $G_trlsRef;
$G_cdrsIndex, $G_cdrsIndexMax;
$G_hdrsIndex, $G_hdrsIndexMax;
$G_trlsIndex, $G_trlsIndexMax;
$G_recordsIndex, $G_recordsIndexMax;
$nextLine;
@G_records;
$nbrEdrs,$i,$count;
@line;
$sortEnabled = 0;

# Define other constants
#
$constFlg = 0;           # SqlServer constant Flag

#
# Parse command line flags.
#
($#ARGV < 9) && exit_err($USAGE_ERR, $USAGE);

#
# BigInt is used for the 64-bit poid_id0 since this
# Perl may not be the 64-bit version.
# Using BigInt for all arithmetic is too slow.
# So, given a starting poid_id0, it is split into two 
# ranges where there will be a rollover at the 7th place.
#

$inFile         = $ARGV[0];                  # input file (rated out file)
$interimDir     = $ARGV[1];                  # interim directory
$tablesStr      = $ARGV[2];                  # tables string separated by semicolons
$startPoid      = new Math::BigInt $ARGV[3]; # starting poid value, created by REL
$expEndPoid     = new Math::BigInt $ARGV[4]; # expected ending poid value, created by REL
$incrPoid       = $ARGV[5];                  # POID increment value has been validated in REL driver
$sortLimit      = $ARGV[6];                  # Limit upto which sorting is done
$flags          = $ARGV[7];                  # preprocess flags from Infranet.properties
$use_compact_event       = $ARGV[8];         # single_row_event is enabled or not
$virtual_col    = $ARGV[9];                  # virtual column 0 is disabled, 1, is enabled

# sql server flag is obsolete
$constStr       = "";

print "Interim directory : $interimDir\n" if $debug;
print "Tables string : $tablesStr\n" if $debug;
print "Start poid value : $startPoid\n" if $debug;
print "Expected end poid value : $expEndPoid\n" if $debug;
print "Poid increment value : $incrPoid\n" if $debug;
print "Sort Limit : $sortLimit\n" if $debug;
print "Flags : $flags\n" if $debug;
print "use_compact_event : $use_compact_event\n" if $debug;
print "Virtual Column  : $virtual_col\n" if $debug;


# Data Dictionary For /event/delayed/session/telco/gsm  would have 
#
#	0 PIN_FLD_MONITOR_IMPACTS  ARRAY [0] allocated 20, used 4
#	1     PIN_FLD_ACCOUNT_OBJ    POID [0] NULL poid pointer
#	1     PIN_FLD_AMOUNT       DECIMAL [0] NULL pin_decimal_t ptr
#	1     PIN_FLD_BAL_GRP_OBJ    POID [0] NULL poid pointer
#	1     PIN_FLD_RESOURCE_ID     INT [0] 0
#	0 PIN_FLD_MONITOR_SUB_BAL_IMPACTS  ARRAY [0] allocated 20, used 3
#	1     PIN_FLD_BAL_GRP_OBJ    POID [0] NULL poid pointer
#	1     PIN_FLD_RESOURCE_ID     INT [0] 0
#	1     PIN_FLD_SUB_BALANCES  ARRAY [0] allocated 20, used 7
#	2         PIN_FLD_AMOUNT       DECIMAL [0] NULL pin_decimal_t ptr
#	2         PIN_FLD_CONTRIBUTOR_STR    STR [0] NULL str ptr
#	2         PIN_FLD_GRANTOR_OBJ    POID [0] NULL poid pointer
#	2         PIN_FLD_VALID_FROM   TSTAMP [0] (0) <null>
#	2         PIN_FLD_VALID_FROM_DETAILS    INT [0] 0
#	2         PIN_FLD_VALID_TO     TSTAMP [0] (0) <null>
#	2         PIN_FLD_VALID_TO_DETAILS    INT [0] 0
#	0 PIN_FLD_RUM_MAP       ARRAY [0] allocated 20, used 3
#	1     PIN_FLD_NET_QUANTITY DECIMAL [0] NULL pin_decimal_t ptr
#	1     PIN_FLD_RUM_NAME        STR [0] NULL str ptr
#	1     PIN_FLD_UNRATED_QUANTITY DECIMAL [0] NULL pin_decimal_t ptr
#	0 PIN_FLD_SUB_BAL_IMPACTS  ARRAY [0] allocated 20, used 3
#	1     PIN_FLD_BAL_GRP_OBJ    POID [0] NULL poid pointer
#	1     PIN_FLD_RESOURCE_ID     INT [0] 0
#	1     PIN_FLD_SUB_BALANCES  ARRAY [0] allocated 20, used 8
#	2         PIN_FLD_AMOUNT       DECIMAL [0] NULL pin_decimal_t ptr
#	2         PIN_FLD_CONTRIBUTOR_STR    STR [0] NULL str ptr
#	2         PIN_FLD_GRANTOR_OBJ    POID [0] NULL poid pointer
#	2         PIN_FLD_ROLLOVER_DATA    INT [0] 0
#	2         PIN_FLD_VALID_FROM   TSTAMP [0] (0) <null>
#	2         PIN_FLD_VALID_FROM_DETAILS    INT [0] 0
#	2         PIN_FLD_VALID_TO     TSTAMP [0] (0) <null>
#	2         PIN_FLD_VALID_TO_DETAILS    INT [0] 0
#	0 PIN_FLD_TAX_JURISDICTIONS  ARRAY [0] allocated 20, used 8
#	1     PIN_FLD_AMOUNT       DECIMAL [0] NULL pin_decimal_t ptr
#	1     PIN_FLD_AMOUNT_EXEMPT DECIMAL [0] NULL pin_decimal_t ptr
#	1     PIN_FLD_AMOUNT_GROSS DECIMAL [0] NULL pin_decimal_t ptr
#	1     PIN_FLD_AMOUNT_TAXED DECIMAL [0] NULL pin_decimal_t ptr
#	1     PIN_FLD_ELEMENT_ID      INT [0] 0
#	1     PIN_FLD_NAME            STR [0] NULL str ptr
#	1     PIN_FLD_PERCENT      DECIMAL [0] NULL pin_decimal_t ptr
#	1     PIN_FLD_TYPE           ENUM [0] 0
#	0 PIN_FLD_SERVICE_CODES  ARRAY [0] allocated 20, used 2
#	1     PIN_FLD_SS_ACTION_CODE    STR [0] NULL str ptr
#	1     PIN_FLD_SS_CODE         STR [0] NULL str ptr
#	0 PIN_FLD_TELCO_INFO   SUBSTRUCT [0] allocated 20, used 14
#	1     PIN_FLD_BYTES_DOWNLINK DECIMAL [0] NULL pin_decimal_t ptr
#	1     PIN_FLD_BYTES_UPLINK DECIMAL [0] NULL pin_decimal_t ptr
#	1     PIN_FLD_CALLED_TO       STR [0] NULL str ptr
#	1     PIN_FLD_CALLING_FROM    STR [0] NULL str ptr
#	1     PIN_FLD_DESTINATION_NETWORK    STR [0] NULL str ptr
#	1     PIN_FLD_NETWORK_SESSION_CORRELATION_ID    STR [0] NULL str ptr
#	1     PIN_FLD_NETWORK_SESSION_ID    STR [0] NULL str ptr
#	1     PIN_FLD_ORIGIN_NETWORK    STR [0] NULL str ptr
#	1     PIN_FLD_PRIMARY_MSID    STR [0] NULL str ptr
#	1     PIN_FLD_SECONDARY_MSID    STR [0] NULL str ptr
#	1     PIN_FLD_SVC_CODE        STR [0] NULL str ptr
#	1     PIN_FLD_SVC_TYPE        STR [0] NULL str ptr
#	1     PIN_FLD_TERMINATE_CAUSE   ENUM [0] 0
#	1     PIN_FLD_USAGE_CLASS     STR [0] NULL str ptr
#	0 PIN_FLD_GSM_INFO     SUBSTRUCT [0] allocated 20, used 14
#	1     PIN_FLD_BYTES_IN        INT [0] 0
#	1     PIN_FLD_BYTES_OUT       INT [0] 0
#	1     PIN_FLD_CALLED_NUM_MODIF_MARK   ENUM [0] 0
#	1     PIN_FLD_CELL_ID         STR [0] NULL str ptr
#	1     PIN_FLD_DESTINATION_SID    STR [0] NULL str ptr
#	1     PIN_FLD_DIALED_NUMBER    STR [0] NULL str ptr
#	1     PIN_FLD_DIRECTION      ENUM [0] 0
#	1     PIN_FLD_IMEI            STR [0] NULL str ptr
#	1     PIN_FLD_LOC_AREA_CODE    STR [0] NULL str ptr
#	1     PIN_FLD_NUMBER_OF_UNITS    INT [0] 0
#	1     PIN_FLD_ORIGIN_SID      STR [0] NULL str ptr
#	1     PIN_FLD_QOS_NEGOTIATED   ENUM [0] 0
#	1     PIN_FLD_QOS_REQUESTED   ENUM [0] 0
#	1     PIN_FLD_SUB_TRANS_ID    STR [0] NULL str ptr
#
# for gprs , instead of GSM_INFO , we will have GPRS_INFO
#
#	0 PIN_FLD_GPRS_INFO    SUBSTRUCT [0] allocated 39, used 39
#	1     PIN_FLD_ANONYMOUS_LOGIN    INT [0] 0
#	1     PIN_FLD_APN             STR [0] NULL str ptr
#	1     PIN_FLD_CELL_ID         STR [0] NULL str ptr
#	1     PIN_FLD_CHANGE_CONDITION   ENUM [0] 0
#	1     PIN_FLD_DIAGNOSTICS     STR [0] NULL str ptr
#	1     PIN_FLD_EXTENSIONS      STR [0] NULL str ptr
#	1     PIN_FLD_EXT_CHARGING_ID    INT [0] 0
#	1     PIN_FLD_GGSN_ADDRESS    STR [0] NULL str ptr
#	1     PIN_FLD_LOC_AREA_CODE    STR [0] NULL str ptr
#	1     PIN_FLD_MM_STATE       ENUM [0] 0
#	1     PIN_FLD_NETWORK_CAPABILITY    STR [0] NULL str ptr
#	1     PIN_FLD_NI_PDP          INT [0] 0
#	1     PIN_FLD_NODE_ID         STR [0] NULL str ptr
#	1     PIN_FLD_NUMBER_OF_UNITS    INT [0] 0
#	1     PIN_FLD_PDP_ADDRESS     STR [0] NULL str ptr
#	1     PIN_FLD_PDP_DYNADDR     INT [0] 0
#	1     PIN_FLD_PDP_RADDRESS    STR [0] NULL str ptr
#	1     PIN_FLD_PDP_TYPE        STR [0] NULL str ptr
#	1     PIN_FLD_PTMSI           STR [0] NULL str ptr
#	1     PIN_FLD_PTMSI_SIGNATURE    STR [0] NULL str ptr
#	1     PIN_FLD_QOS_NEGO_DELAY   ENUM [0] 0
#	1     PIN_FLD_QOS_NEGO_MEAN_THROUGH   ENUM [0] 0
#	1     PIN_FLD_QOS_NEGO_PEAK_THROUGH   ENUM [0] 0
#	1     PIN_FLD_QOS_NEGO_PRECEDENCE   ENUM [0] 0
#	1     PIN_FLD_QOS_NEGO_RELIABILITY   ENUM [0] 0
#	1     PIN_FLD_QOS_REQ_DELAY   ENUM [0] 0
#	1     PIN_FLD_QOS_REQ_MEAN_THROUGH   ENUM [0] 0
#	1     PIN_FLD_QOS_REQ_PEAK_THROUGH   ENUM [0] 0
#	1     PIN_FLD_QOS_REQ_PRECEDENCE   ENUM [0] 0
#	1     PIN_FLD_QOS_REQ_RELIABILITY   ENUM [0] 0
#	1     PIN_FLD_ROUTING_AREA    STR [0] NULL str ptr
#	1     PIN_FLD_SERVICE_AREA_CODE    STR [0] NULL str ptr
#	1     PIN_FLD_SESSION_ID      INT [0] 0
#	1     PIN_FLD_SGSN_ADDRESS    STR [0] NULL str ptr
#	1     PIN_FLD_SGSN_CHANGE    ENUM [0] 0
#	1     PIN_FLD_SGSN_PLMN_ID    STR [0] NULL str ptr
#	1     PIN_FLD_STATUS         ENUM [0] 0
#	1     PIN_FLD_SUB_TRANS_ID    STR [0] NULL str ptr
#	1     PIN_FLD_TRANS_ID        STR [0] NULL str ptr
#	
# So in order to encode compact_event_sub column in event_t we have to encode this set of array and substructs
# as per compact event spec.
# 
# if type is /event/delayed/session/telco/gsm will have gsm_info
# if type is /event/delayed/session/telco/gprs we will have gprs_info
# if type is /event/delayed/session/telco/wap we will have wap_info
# When we print compact data, we will check the type and add in the appropriate order 

$compactData = "";
$monitor_bal_impacts = "";
$monitor_sub_bal_impacts = "";
$rum_map_array = "";
$sub_bal_impacts = "";
$tax_juris_array = "";
$svc_codes_array = "";
$telco_info_subst="";
$gsm_info_subst = "";
$gprs_info_subst = "";
$wap_info = "";
$tmptelco_info_subst = "";
$fullTelcoRec="";
$savedetailRec="";
$svcinfo = "";
$svctype = "";
$svccode = "";

#
# Define constants for serializing sub balance impact data
#
$SER_RECORD_DELIMITER = "\n";
$SER_VERSION = "C1,3.0" . $SER_RECORD_DELIMITER;
$SER_DELIMITER = ":";
$SER_DB_NO_DELIMITER = ";";
$SER_FIELD_VALUE_DELIMITER = ",";
$SUB_BAL_IMPACTS_PREFIX = "1:7754";
$SUB_BALANCES_PREFIX = "2:7753";
$MON_SUB_BAL_IMPACTS_PREFIX = "1:9232";
$MON_SUB_BALANCES_PREFIX = "1:9233";

# For compact event encoding

$COMPACT_ARRAY_SUBST_PREFIX = "<";
$COMPACT_ARRAY_SUBST_SUFFIX = ">";
$COMPACT_ARRAY_REC_SEPARATOR = "|";
$COMPACT_FIELD_VALUE_DELIMITER = "#";
$EMPTY_COMPACT_ARRAY = "<||>";
$EMPTY_COMPACT_SUBST = "<>";


# cdr format for tax jurisdictions is rec_type=615\trec_no\ttax_type\tvalue\tamt\trate\gross
$TAX_JURIS_REC_ID_POS = 1;               #tax juris rec id pos
$TAX_JURIS_TAX_TYPE=2;
$TAX_JURIS_TAX_VALUE=3;
$TAX_JURIS_TAX_AMOUNT=4;
$TAX_JURIS_TAX_RATE=5;
$TAX_JURIS_TAX_AMOUNT_GROSS=6;

# cdr format for rum_map is rec_type=400\trec_no\rumname\tnetqty\tunratedqty
$RUM_MAP_REC_ID_POS = 1;           
$RUM_MAP_RUM_NAME=2;
$RUM_MAP_NET_QUANTITY=3;
$RUM_MAP_UNRATED_QUANTITY=4;


# cdr format is rec_type=620\trec_no\taction_code\tss_code\tclir_indic
$SVC_CODES_REC_ID = 1;              
$SVC_CODES_ACTION_CODE=2;
$SVC_CODES_SS_CODE=3;
$SVC_CODES_CLIR_INDICATOR=4;

# positions in cdr for telco/gsm record with the preceding detailrecincluded
$TELCO_REC_ID = 1;              
$TELCO_EVENT_NO = 2;              
$TELCO_BATCH_ID = 3;
$TELCO_ORIG_BATCH_ID = 4;
$TELCO_NET_SESS_ID = 5;
$GSM_CHAIN_REFERENCE = 5;
$TELCO_ORIGIN_NETWORK=6;
$GSM_SOURCE_NETWORK=6;
$TELCO_DESTINATION_NETWORK=7;
$TELCO_PRIMARY_MSID=8;
$GSM_A_NUMBER=8;
$TELCO_B_MD_INDICATOR=9;
$GSM_CALLED_NUM_MODIF_MARK=9;
$TECLO_CALLED_TO_NUMBER=10;
$GSM_B_NUMBER=10;
$TELCO_DESCRIPTION=11;
$TELCO_USGAE_DIRECTION=12;
$TELCO_CONNECT_TYPE=13;
$TELCO_CONNECT_SUBTYPE=14;
$TELCO_SVCINFO=15;
$TELCO_QOS_RQST=16;
$TELCO_QOS_USED=17;
$GSM_QOS_NEGOTIATED=17;
$TELCO_TERMINATE_CAUSE=18;
$GSM_CALLCOMPLETION_INDICATOR=18;
$TELCO_LONG_DURATION_INDICATOR=19;
$GSM_SUBTRANS_ID=19;
$TELCO_UTC_TIME_OFFSET=20;
$TELCO_VOLUME_SENT=21;
$GSM_BYTES_OUT=21;
$TELCO_BYTES_OUT=21;
$TELCO_BYTES_IN=22;
$TELCO_NUMBER_UNITS=23;
$TELCO_USAGE_CLASS=24;
$TELCO_USAGE_TYPE=25;
$TELCO_PREPAID_INDICATOR=26;
$TELCO_INTERN_PROC_STATUS=27;
$TELCO_START_T=28;
$TELCO_END_T=29;
$TELCO_NET_QUANTITY=30;
$TELCO_OBJ_ID0=31;
# followed by rectype2, recid2
#gsm
$GSM_SECONDARY_MSID=34;
$GSM_CALLING_FROM=35;
$GSM_SS_EVENT_PACKETS=36;
#gprs_specific
$GPRS_ANONYMOUS_LOGIN=13;
$GPRS_PORT_NUMBER=34;
$GPRS_DEVICE_NUMBER=35;
$GPRS_ROUTING_AREA=36;
$GPRS_LOC_AREA=37;
$GPRS_CHARGING_ID=38;
$GPRS_SGSN_ADDRESS=39;
$GPRS_GGSN_ADDRESS=40;
$GPRS_APN_ADDRESS=41;
$GPRS_NODE_ID=42;
$GPRS_TRANS_ID=43;
$GPRS_SUB_TRANS_ID=44;
$GPRS_NI_PDP=45;
$GPRS_PDP_TYPE=46;
$GPRS_PDP_ADDRESS=47;
$GPRS_PDP_RADDRESS=48;
$GPRS_PDP_DYNADDRESS=49;
$GPRS_DIAGNOSTICS=50;
$GPRS_CELL_ID=51;
$GPRS_CHANGE_CONDITION=52;
$GPRS_QOS_REQ_PRECEDENCE=53;
$GPRS_QOS_REQ_DELAY=54;
$GPRS_QOS_REQ_RELIABILITY=55;
$GPRS_QOS_REQ_PEAK_THROUGH=56;
$GPRS_QOS_REQ_MEAN_THROUGH=57;
$GPRS_QOS_NEGO_PRECEDENCE=58;
$GPRS_QOS_NEGO_DELAY=59;
$GPRS_QOS_NEGO_RELIABILITY=60;
$GPRS_QOS_NEGO_PEAK_THROUGH=61;
$GPRS_QOS_NEGO_MEAN_THROUGH=62;
$GPRS_NETWORK_CAPABILITY=63;
$GPRS_SGSN_CHANGE=64;


#
# Find the no of records in the input file
#
$nbrEdrs=(($expEndPoid-$startPoid)/$incrPoid)+1;


#
# Construct const values : processDate,eventPoid,sessionPoid,userPoid
#
if (length($constStr) > 0)
 {
   $constFlg       = 1;
   @constVal    = split(/;/,$constStr);
   if (@constVal != 4)
    {
       exit_err($INVALID_CONST_STR,"Invalid Constant String Passed", $constStr);
    }
   $processDate = $constVal[0];
   $eventPoid   = $constVal[1];
   $sessionPoid = $constVal[2];
   $userPoid    = $constVal[3];
   @eventStr    = split(/ /,$eventPoid);

   if (@eventStr != 4)
    {
      exit_err($INVALID_EVENT_POID_IN_CONST_STR,"Invalid eventPoid Passed in the Constant String", $eventPoid);
    }
   $eventDb     = $eventStr[0];
   $eventType   = $eventStr[1];
   $eventConst  = "$POID_REV$deli$READ_ACCESS$deli$WRITE_ACCESS$deli$NAME$deli$EARNED_START_T$deli$EARNED_END_T$deli$EARNED_TYPE$deli$ARCHIVE_STATUS";
   $eventConst  = "$eventConst$deli$PROG_NAME$deli$processDate$deli$processDate$deli$eventDb$deli$eventType$deli$eventType$deli$sessionPoid$deli$userPoid";
 }

#
# construct output file names
#
$file = basename($inFile);
@table = split(/;/, $tablesStr);
$interimDir =~ s/\/$//;   # trim last char if it's '/'
for ($i = 0; $i < @table; $i++) 
 {
   $outFile = $interimDir . "/" . $file . "." . $table[$i] . ".blk";
   if ($table[$i] =~ /^event_t$/i || $table[$i] =~ /^d_event_t$/i) 
    {
       $outFile1 = $outFile;
       print "Output file 1 : $outFile1\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_bal_impacts_t$/i || $table[$i] =~ /^d_event_bal_impacts_t$/i) 
    {
       $outFile2 = $outFile;
       print "Output file 2 : $outFile2\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_essentials_t$/i || $table[$i] =~ /^d_event_essentials_t$/i)
    {
       $outFile3 = $outFile;
       print "Output file 3 : $outFile3\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_delayed_session_gprs_t$/i ||
          $table[$i] =~ /^event_dlay_sess_tlcs_t$/i       ||
          $table[$i] =~ /^event_delayed_act_wap_inter_t$/i  ) 
    {
       $outFile4 = $outFile;
       print "Output file 4 : $outFile4\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlay_sess_tlcs_svc_cds_t$/i) 
    {
       $outFile5 = $outFile;
       print "Output file 5 : $outFile4\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_tlco_gsm_t$/i ||
          $table[$i] =~ /^event_dlyd_session_tlco_gprs_t$/i)
    {
       $outFile6 = $outFile;
       print "Output file 6 : $outFile6\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_tax_jurisdictions_t$/i || $table[$i] =~ /^d_event_tax_jurisdictions_t$/i) 
    {
       $outFile7 = $outFile;
       print "Output file 7 : $outFile7\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_rum_map_t$/i || $table[$i] =~ /^d_event_rum_map_t$/i )
    {
       $outFile8 = $outFile;
       print "Output file 8 : $outFile8\n" if $debug;
    }
   elsif ($table[$i] =~ /^tmp_prof/i)  
    {
       $outFile9 = $outFile;
       print "Output file 9 : $outFile9\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_custom_t$/i || $table[$i] =~ /^d_event_dlyd_session_custom_t$/i )
    {
       $outFile10 = $outFile;
       print "Output file 10 : $outFile10\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_bal_cust_t$/i || $table[$i] =~ /^d_event_dlyd_session_bal_cust_t$/i )
    {
       $outFile11 = $outFile;
       print "Output file 11 : $outFile11\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_voice_t$/i || $table[$i] =~ /^d_event_dlyd_session_voice_t$/i )
    {
       $outFile12 = $outFile;
       print "Output file 12 : $outFile12\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_data_t$/i || $table[$i] =~ /^d_event_dlyd_sms_cust_t$/i )
    {
       $outFile13 = $outFile;
       print "Output file 13 : $outFile13\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_sms_t$/i || $table[$i] =~ /^d_event_dlyd_session_sms_t$/i )
    {
       $outFile14 = $outFile;
       print "Output file 14 : $outFile14\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_vp_t$/i || $table[$i] =~ /^d_event_dlyd_session_vp_t$/i )
    {
       $outFile15 = $outFile;
       print "Output file 15 : $outFile15\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_mms_t$/i || $table[$i] =~ /^d_event_dlyd_session_mms_t$/i )
    {
       $outFile16 = $outFile;
       print "Output file 16 : $outFile16\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_vom_t$/i || $table[$i] =~ /^d_event_dlyd_session_vom_t$/i )
    {
       $outFile17 = $outFile;
       print "Output file 17 : $outFile17\n" if $debug;
    }
   elsif ($table[$i] =~ /^event_dlyd_session_vas_t$/i || $table[$i] =~ /^d_event_dlyd_session_vas_t$/i )
    {
       $outFile18 = $outFile;
       print "Output file 18 : $outFile18\n" if $debug;
    }
   else 
    {
       exit_err( $UNSUPPORTED_TABLE, "Unsupported table",$table[$i]);
    }    
 }
$outTrelFile = $interimDir . "/" . $file . ".poids";

#
# Initialize some constants
#
$rec_id = 0;
$foundRecForFile1 = 0;
$foundRecForFile2 = 0;
$maxBalancesLargeLength = 0;
$elemId = -1;
$serializedData = $SER_VERSION;
init();   # initialize poid increment algorithm

#
# Open the input file
#

open(OUT1_FILE, ">$outFile1") || exit_err( $CANT_OPEN_FILE, $outFile1, $!);
open(OUT2_FILE, ">$outFile2") || exit_err( $CANT_OPEN_FILE, $outFile2, $!);
open(OUT3_FILE, ">$outFile3") || exit_err( $CANT_OPEN_FILE, $outFile3, $!);

# Set the file handle to binary mode for event_essentials blk file to resolve 
# End-Of-Line hassle in various operating systems.
#
if ($use_compact_event == 0) {
binmode(OUT3_FILE);
} else {
binmode(OUT1_FILE);
}

# for some cases, $outFile4 and $outFile5 may not be defined
# For example, discount file does not have $outFile4 and $outFile5 files
# and GPRS/WAP event file does not have $outFile5 file
if (defined $outFile4) 
 {
   open(OUT4_FILE, ">$outFile4") || exit_err( $CANT_OPEN_FILE, $outFile4, $!);
 }
if (defined $outFile5)
 {
   open(OUT5_FILE, ">$outFile5") || exit_err( $CANT_OPEN_FILE, $outFile5, $!);
 }
if (defined $outFile6) 
 {
   open(OUT6_FILE, ">$outFile6") || exit_err( $CANT_OPEN_FILE, $outFile6, $!);
 }

# This is the file for event_tax_jurisdictions_t table
if (defined $outFile7) 
 {
   open(OUT7_FILE, ">$outFile7") || exit_err( $CANT_OPEN_FILE, $outFile7, $!);
 }
# This is the file for event_rum_map_t table or d_event_rum_map_t table
if (defined $outFile8) 
 {
   open(OUT8_FILE, ">$outFile8") || exit_err( $CANT_OPEN_FILE, $outFile8, $!);
 }
# This is the file for tmp_profile_event_ordering_t table 
if (defined $outFile9) 
 {
   open(OUT9_FILE, ">$outFile9") || exit_err( $CANT_OPEN_FILE, $outFile9, $!);
 }


# 2degrees changes
# This is the file for event_dlyd_session_custom_t table
if (defined $outFile10)
 {
   open(OUT10_FILE, ">$outFile10") || exit_err( $CANT_OPEN_FILE, $outFile10, $!);
 }

# This is the file for event_dlyd_session_bal_cust_t table
if (defined $outFile11)
 {
   open(OUT11_FILE, ">$outFile11") || exit_err( $CANT_OPEN_FILE, $outFile11, $!);
 }
# This is the file for event_dlyd_session_voice_t table
if (defined $outFile12)
 {
   open(OUT12_FILE, ">$outFile12") || exit_err( $CANT_OPEN_FILE, $outFile12, $!);
 }
# This is the file for event_dlyd_session_data_t table
if (defined $outFile13)
 {
   open(OUT13_FILE, ">$outFile13") || exit_err( $CANT_OPEN_FILE, $outFile13, $!);
 }
# This is the file for event_dlyd_session_sms_t table
if (defined $outFile14)
 {
   open(OUT14_FILE, ">$outFile14") || exit_err( $CANT_OPEN_FILE, $outFile14, $!);
 }
# This is the file for event_dlyd_session_vp_t table
if (defined $outFile15)
 {
   open(OUT15_FILE, ">$outFile15") || exit_err( $CANT_OPEN_FILE, $outFile15, $!);
 }
# This is the file for event_dlyd_session_mms_t table
if (defined $outFile16)
 {
   open(OUT16_FILE, ">$outFile16") || exit_err( $CANT_OPEN_FILE, $outFile16, $!);
 }
# This is the file for event_dlyd_session_vom_t table
if (defined $outFile17)
 {
   open(OUT17_FILE, ">$outFile17") || exit_err( $CANT_OPEN_FILE, $outFile17, $!);
 }
# This is the file for event_dlyd_session_vas_t table
if (defined $outFile18)
 {
   open(OUT18_FILE, ">$outFile18") || exit_err( $CANT_OPEN_FILE, $outFile18, $!);
 }





#Don't sort if no of lines in the input file exceeds sortLimit
if ( $nbrEdrs <= $sortLimit )
 {
   $sortEnabled = 1;
 }


open(IN_FILE, $inFile) || exit_err( $CANT_OPEN_FILE, $inFile, $!);
 
if ( $sortEnabled )
 {
   ($headersRef, $cdrsRef, $trailersRef) = readCdrs(\*IN_FILE);
 
   my @sorted_cdrs =    # Real work (read back from end )
			# Sort the cdrs, the key is located as the second element of $a, $b arrays
			sort {
			 		     # the @ is important below, to get the $a in an array context
    			  @$a[1] <=> @$b[1]; # compare numerically
		        }

			# Compose an anonymous array with elements of pair (block, account)
			# Also, avoid pattern recompilation by using the "o" modifier.
			map {
				#       \n     900    \t   X  \t   DB \s/account\s(OBJ)\s
				[ \$_, m|$recEnd$balRec$deli\w+$deli\d+$pDeli/\w+$pDeli(\d+)$pDeli|o ] 
			}
			@$cdrsRef;
			$cdrsRef = \@sorted_cdrs;
 }

#
# Process each record in the file.
#
resetGetNextRecord() if ($sortEnabled);
initGetNextRecord($headersRef, $cdrsRef, $trailersRef);
$line = getNextRecord();


while ( $line ) 
 {

   if ($line =~ m/^$dtlRec/o)
    {
      print_serialize_sub_bal();
      #
      # When the rollover happens, increment high-order digits
      # and reset low-order digits.
      #
      $i += $incrPoid;
      if ($i >= $maxrecs) 
       { # need to rollover
         $i -= $maxrecs;
         $high++;
       }
      $poid_id = sprintf("$high%07u",$i);
      $rec_id = 0;
      $sb_rec_id = 0;
      $mon_sb_rec_id = 0;
      $rum_rec_id = 0;
      $profile_event_ordering_rec_id = 0;

      #
      # Get END_T for event_essentials_t table
      #
      $end_t = (split /$deli/, $line)[$END_T_POS];

      if( $foundRecForFile1 == 1 && $balRecLine =~ m/^$balRec/o) 
       {
         if( $constFlg == 1)
         {
           $end_t = (split /$deli/, $line)[$END_T_POS]; 
           if ($virtual_col == 1) 
           {
             my $virtualBalRecLine = replace_virtual_cols($balRecLine);
             print OUT1_FILE "$virtualBalRecLine$deli$eventConst\n";
           } 
           else
           {
             print OUT1_FILE "$balRecLine$deli$eventConst\n";
           } 
         }
         else
         {
           if ($use_compact_event == 0)
           {
             if ($virtual_col == 1) 
             {
               my $virtualBalRecLine = replace_virtual_cols($balRecLine);
               print OUT1_FILE "$virtualBalRecLine$deli\n";
             } 
             else 
             {
               print OUT1_FILE "$balRecLine$deli\n";
             }
           }
         }
         $foundRecForFile1 = 0;
         $balRecLine = "";
       }
       
      #
      # Found another detail record without finding a bal rec for previous dtl rec.
      #
      if( $foundRecForFile1 == 1 ) 
       {
         exit_err( $MISSING_BAL_REC );
       }

      $foundRecForFile1 = 1;

      #
      # Found another detail record without finding a service record for the previous detail rec
      # This is OK since 0 or 1 service record is expected for each detail rec.
      #
      if( $foundRecForFile2 == 1) 
       {
         if ($use_compact_event == 0) 
          {
            print OUT4_FILE "\n";
            print OUT6_FILE "\n";
          }
# this just means compactdata is null ? 
       }
      $foundRecForFile2 = 1;

      #
      # Print the high and low order bits. Note: Right-justify
      # the low-order bits and pad with zeros.
      #
      if ($virtual_col == 1)
      {
         my $virtualColLine = replace_virtual_cols($line);
         print OUT1_FILE "$virtualColLine$deli$poid_id$deli";
      }
      else
      {
        print(OUT1_FILE "$line$deli$poid_id$deli");
      }
      if ($use_compact_event == 1) 
      {
# save detail rec to consilidate with gsm/gprs/wap record later.
      $savedetailRec = "$line$deli$poid_id$deli";
      }
      else 
      {
      print(OUT4_FILE "$line$deli$poid_id$deli");
      print(OUT6_FILE "$line$deli$poid_id$deli");
      }
      $line=getNextRecord();
    }
   elsif ($line =~ m/^$rumMapRec/o) 
    {
      # cdr format is rec_type=400\trec_no\rumname\tnetqty\tunratedqty
      if ($use_compact_event == 1) 
      {
           $templine = $line;
	   $rum_rec_id = 0;

           while ($templine =~ m/^$rumMapRec/o) 
           {
               if ($rum_rec_id == 0) 
                 {
                 $rum_map_array = $COMPACT_ARRAY_SUBST_PREFIX;
                 $rum_map_array .= $COMPACT_ARRAY_REC_SEPARATOR;
                 }
                 @rumcdrdata = split(/$deli/, $templine);
                 $rum_map_array .= $rumcdrdata[$RUM_MAP_REC_ID_POS];
                 $rum_map_array .= $COMPACT_FIELD_VALUE_DELIMITER;
                 $rum_map_array .= $rumcdrdata[$RUM_MAP_NET_QUANTITY];
                 $rum_map_array .= $COMPACT_FIELD_VALUE_DELIMITER . $rumcdrdata[$RUM_MAP_RUM_NAME]; 
                 $rum_map_array .= $COMPACT_FIELD_VALUE_DELIMITER . $rumcdrdata[$RUM_MAP_UNRATED_QUANTITY];
                 $rum_map_array .= $COMPACT_FIELD_VALUE_DELIMITER;
                 $rum_map_array .= $COMPACT_ARRAY_REC_SEPARATOR;
                 $rum_rec_id = $rum_rec_id + 1;
                 $templine=getNextRecord();
           }
	   $rum_map_array .= $COMPACT_ARRAY_SUBST_SUFFIX;
	 $line = $templine;

      } else {
        print(OUT8_FILE "$line$deli$poid_id$deli$rum_rec_id$deli\n");
        $rum_rec_id = $rum_rec_id + 1;
        $line=getNextRecord();
      }
    }
   elsif($line =~ m/^$profileEventOrderingRec/o) 
    {
      print OUT9_FILE "$line$deli$poid_id$deli$profile_event_ordering_rec_id$deli\n";
      $profile_event_ordering_rec_id = $profile_event_ordering_rec_id + 1;
      $line=getNextRecord();
    }
   elsif($line =~ m/^$balRec/o) 
    {
      $elemId = -1;
      $tempLine=getNextRecord();

      #
      # Concatenate the Infranet Billing Record (record type 900 usually)
      # and the balance impact record (record type 600) if present.
      # There could be multiple of the record type 600.
      #
 
      $balRecLine = $line;
      #
      # Get account_obj_id0 for later use to create serialized data 
      # for event_essentials_t
      # 
      @billingRec = split(/$deli/, $balRecLine);
      @accountObj = split(/ /, $billingRec[$BILLING_ACCOUNT_OBJ_POS]);
      $accountObjId0 = $accountObj[$OBJ_ID0_POS];

      # Tax jurisdiction rec_id to be generated as unique for 
 
      my $tax_juris_rec_id = 0;
      while( $tempLine =~ m/^$balImpRec/o )
      {
         $elemId =  $elemId + 1;
         if ($virtual_col == 1) 
          {
            my $virtualtempLine = replace_virtual_cols($tempLine);
            print(OUT2_FILE "$virtualtempLine$deli$poid_id$deli$rec_id$deli\n");
          } 
          else
           {
             print(OUT2_FILE "$tempLine$deli$poid_id$deli$rec_id$deli\n");
           } 
         $rec_id = $rec_id + 1;
	 $tempLine = getNextRecord();

      # cdr format is rec_type=615\trec_no\ttax_type\tvalue\tamt\trate\gross

         while ($tempLine =~ m/^$taxJurisRec/o) 
         {
             if ($use_compact_event == 1) 
             {
               if ($tax_juris_rec_id == 0) 
                 {
                 $tax_juris_array = $COMPACT_ARRAY_SUBST_PREFIX;
                 $tax_juris_array .= $COMPACT_ARRAY_REC_SEPARATOR;
                }
                 @juriscdrdata = split(/$deli/, $tempLine);
                 $tax_juris_array .= $juriscdrdata[$TAX_JURIS_REC_ID_POS];
                 $tax_juris_array .= $COMPACT_FIELD_VALUE_DELIMITER;
                 $tax_juris_array .= $juriscdrdata[$TAX_JURIS_TAX_VALUE]; #PIN_FLD_AMOUNT
                 $tax_juris_array .= $COMPACT_FIELD_VALUE_DELIMITER . $AMOUNT_EXMT;
                 $tax_juris_array .= $COMPACT_FIELD_VALUE_DELIMITER . $juriscdrdata[$TAX_JURIS_TAX_AMOUNT_GROSS];
                 $tax_juris_array .= $COMPACT_FIELD_VALUE_DELIMITER . $juriscdrdata[$TAX_JURIS_TAX_AMOUNT]; # this is PIN_FLD_AMOUNT_TAXED
                 $tax_juris_array .= $COMPACT_FIELD_VALUE_DELIMITER . $elemId;
                 $tax_juris_array .= $COMPACT_FIELD_VALUE_DELIMITER . $NAME_SPC;
                 $tax_juris_array .= $COMPACT_FIELD_VALUE_DELIMITER . $juriscdrdata[$TAX_JURIS_TAX_RATE]; # PIN_FLD_PERCENT
                 $tax_juris_array .= $COMPACT_FIELD_VALUE_DELIMITER . $juriscdrdata[$TAX_JURIS_TAX_TYPE]; # PIN_FLD_TYPE
                 $tax_juris_array .= $COMPACT_FIELD_VALUE_DELIMITER;
                 $tax_juris_array .= $COMPACT_ARRAY_REC_SEPARATOR;

             } 
             else
             {
   	       if( $constFlg == 1) 
               {
   	         print (OUT7_FILE "$tempLine$deli$AMOUNT_EXMT$deli$NAME_SPC$deli$poid_id$deli$tax_juris_rec_id$deli$elemId$deli\n");
	       }		 
	       else 
	       {
	         print (OUT7_FILE "$tempLine$deli$poid_id$deli$tax_juris_rec_id$deli$elemId$deli\n");
	       }
              }
	     $tempLine = getNextRecord();
	     $tax_juris_rec_id = $tax_juris_rec_id + 1;
         }
      }
      $line = $tempLine;
      serialize_sub_bal();
    }
   elsif(($line =~ m/^$gprsRec/o) || ($line =~ m/^$gsmRec/o) || ($line =~ m/^$wapRec/o)) 
    {
      if( $foundRecForFile2 == 1) 
       {
         $foundRecForFile2 = 0;
         if ($use_compact_event == 1) 
         {
# handle gsmrec or gprsrec or waprec , fill up telco_info_array and one of  gsm/grs/wap arrays
           $fullTelcoRec = $savedetailRec . $line;
	   @cdrdata = split(/$deli/, $fullTelcoRec);

        # fill telco info first.
           $telco_info_subst = $COMPACT_ARRAY_SUBST_PREFIX;
           $telco_info_subst .= $cdrdata[$TELCO_BYTES_IN];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER ;
           $telco_info_subst .= $cdrdata[$TELCO_BYTES_OUT];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TECLO_CALLED_TO_NUMBER];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GSM_CALLING_FROM];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_DESTINATION_NETWORK];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_NET_SESS_ID];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_ORIGIN_NETWORK];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_PRIMARY_MSID];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GSM_SECONDARY_MSID];
           $svcinfo = $cdrdata[$TELCO_SVCINFO];
           $svctype = substr($svcinfo, 0, 1);
           $svccode = substr($svcinfo, 1);
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $svccode;
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $svctype;
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_TERMINATE_CAUSE];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_USAGE_CLASS];
           $telco_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER;
           $telco_info_subst .= $COMPACT_ARRAY_SUBST_SUFFIX;
           if($line =~ m/^$gsmRec/o) 
           {
# add gsm_info substruct to telcoinfo
           $gsm_info_subst = $COMPACT_ARRAY_SUBST_PREFIX;
           $gsm_info_subst .= $cdrdata[$TELCO_BYTES_IN];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_BYTES_OUT];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GSM_CALLED_NUM_MODIF_MARK];

           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER; # cell id empty
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_DESTINATION_NETWORK];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GSM_B_NUMBER];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_USGAE_DIRECTION];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER ; # imei
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER ; # localareacode
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_NUMBER_UNITS];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_ORIGIN_NETWORK];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GSM_QOS_NEGOTIATED];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_QOS_RQST];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GSM_SUBTRANS_ID];
           $gsm_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER;
           $gsm_info_subst .= $COMPACT_ARRAY_SUBST_SUFFIX;
           $telco_info_subst .= $gsm_info_subst;
           $gsm_info_subst="";
           }
           elsif ($line =~ m/^$gprsRec/o)
           {
           $gprs_info_subst = $COMPACT_ARRAY_SUBST_PREFIX;
           $gprs_info_subst .= $cdrdata[$GPRS_ANONYMOUS_LOGIN];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_APN_ADDRESS];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_CELL_ID];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_CHANGE_CONDITION];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_DIAGNOSTICS];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER; # PIN_FLD_EXTENSIONS
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_CHARGING_ID];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_GGSN_ADDRESS];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_LOC_AREA];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER; # PIN_FLD_MM_STATE
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_NETWORK_CAPABILITY];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_NI_PDP];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$TELCO_NUMBER_UNITS];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_PDP_ADDRESS];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_PDP_DYNADDRESS];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_PDP_RADDRESS];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_PDP_TYPE];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER; # PTMSI
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER; # PTMSI_SIGNATURE
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_NEGO_DELAY];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_NEGO_MEAN_THROUGH];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_NEGO_PEAK_THROUGH];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_NEGO_PRECEDENCE];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_NEGO_RELIABILITY];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_REQ_DELAY];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_REQ_MEAN_THROUGH];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_REQ_PEAK_THROUGH];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_REQ_PRECEDENCE];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_QOS_REQ_RELIABILITY];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_ROUTING_AREA];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER; # SERVICE_AREA_CODE
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER; # SESSION_ID
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_SGSN_ADDRESS];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_SGSN_CHANGE];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER; # SGSN_PLMN_ID
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER; # STATUS
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_SUB_TRANS_ID];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER . $cdrdata[$GPRS_TRANS_ID];
           $gprs_info_subst .= $COMPACT_FIELD_VALUE_DELIMITER;
           $gprs_info_subst .= $COMPACT_ARRAY_SUBST_SUFFIX;
           $telco_info_subst .= $gprs_info_subst;
           $tmptelco_info_subst = $EMPTY_COMPACT_ARRAY . $telco_info_subst;
           $telco_info_subst = $tmptelco_info_subst;
           $tmptelco_info_subst = "";
           $gprs_info_subst="";

           } elsif ($line =~ m/^$wapRec/o)
           {

              exit_err( $UNSUPPORTED_RECORD_FORMAT, "Unsupported RECORD type/Format ",$line);
           }
          } else 
         {
           print OUT4_FILE "$line$deli\n";
           print OUT6_FILE "$line$deli\n";
         }
       }
      else 
       {

         #
         # Found a service rec without first finding a detail record
         #

         exit_err( $MISSING_DTL_REC);
       }

      #
      # Handle GSM Supplementary Service Event records
      #

      if($line =~ m/^$gsmRec/o) 
       {
     	 $gsm_rec_id = 0;
         $line = getNextRecord();
      # cdr format is rec_type=620\trec_no\taction_code\tss_code\tclir_indic
  	 while( $line =~ m/^$suplServEvtRecType/o )
	  {
            if ($use_compact_event == 1) 
             {
               if ($gsm_rec_id == 0) 
                 {
                 $svc_codes_array = $COMPACT_ARRAY_SUBST_PREFIX;
                 $svc_codes_array .= $COMPACT_ARRAY_REC_SEPARATOR;
                }
                 @svcdata = split(/$deli/, $line);
                 $svc_codes_array .= $gsm_rec_id;  # we should just use trec_no position rather on generating ourself
                 $svc_codes_array .= $COMPACT_FIELD_VALUE_DELIMITER;
                 $svc_codes_array .= $svcdata[$SVC_CODES_ACTION_CODE]; 
                 $svc_codes_array .= $COMPACT_FIELD_VALUE_DELIMITER . $svcdata[$SVC_CODES_SS_CODE];
                 $svc_codes_array .= $COMPACT_FIELD_VALUE_DELIMITER;
                 $svc_codes_array .= $COMPACT_ARRAY_REC_SEPARATOR;

             } else 
             {
	       print(OUT5_FILE "$line$deli$poid_id$deli$gsm_rec_id\n");
             }
	    $gsm_rec_id++;
	    $line = getNextRecord();
	  }
            if ($use_compact_event == 1) 
             {
		if ($gsm_rec_id > 0 ) {
                 $svc_codes_array .= $COMPACT_ARRAY_SUBST_SUFFIX;
                 }
		if ($svc_codes_array == "")
                {
                 $svc_codes_array .= $EMPTY_COMPACT_ARRAY;
		}
                 $tmptelco_info_subst = $svc_codes_array . $telco_info_subst;
                 $telco_info_subst = $tmptelco_info_subst;
                 $svc_codes_array = "";    
		$tmptelco_info_subst = "";
             }
       } 
      else 
       {
 	 $line = getNextRecord();
       }
    }
    elsif(($line =~ m/^$gsmCust/o) || ($line =~ m/^$ncrRec/o))
    {
         if(($line =~ m/^$gsmCust/o))
         {
            print OUT10_FILE "$line$deli$poid_id$deli\n";
            $line = getNextRecord();
         }
        if($line =~ m/^$ncrRec/o)
       {
         $bal_rec_id = 0;
         print(OUT11_FILE "$line$deli$poid_id$deli$bal_rec_id\n");
         $line = getNextRecord();

         while( $line =~ m/^$ncrRec/o )
         {
	    $bal_rec_id++;
            print(OUT11_FILE "$line$deli$poid_id$deli$bal_rec_id\n");
            $line = getNextRecord();
         }
       }
    }
    elsif($line =~ m/^$gsmVoice/o)
    {
        print OUT12_FILE "$line$deli$poid_id$deli\n";
        $line = getNextRecord();
    }
    elsif($line =~ m/^$gsmData/o)
    {
        print OUT13_FILE "$line$deli$poid_id$deli\n";
        $line = getNextRecord();
    }
    elsif($line =~ m/^$gsmSMS/o)
    {
        print OUT14_FILE "$line$deli$poid_id$deli\n";
        $line = getNextRecord();
    }
    elsif($line =~ m/^$gsmVP/o)
    {
        print OUT15_FILE "$line$deli$poid_id$deli\n";
        $line = getNextRecord();
    }
    elsif($line =~ m/^$gsmMMS/o)
    {
        print OUT16_FILE "$line$deli$poid_id$deli\n";
        $line = getNextRecord();
    }
    elsif($line =~ m/^$gsmVOM/o)
    {
        print OUT17_FILE "$line$deli$poid_id$deli\n";
        $line = getNextRecord();
    }
    elsif($line =~ m/^$gsmVAS/o)
    {
        print OUT18_FILE "$line$deli$poid_id$deli\n";
        $line = getNextRecord();
    }
   else
    {
      $line = getNextRecord();
    } 
 }

#
# Print out any serialize sub-balances data if not yet printed
#
print_serialize_sub_bal();

if( $foundRecForFile1 == 1 && $balRecLine =~ m/^$balRec/o)  
 {
   if( $constFlg == 1)
    {
      if ($virtual_col == 1)
      {
         my $virtualBalRecLine = replace_virtual_cols($balRecLine);
         print OUT1_FILE "$virtualBalRecLine$deli$eventConst\n";
      }
      else
      {
        print OUT1_FILE "$balRecLine$deli$eventConst\n";
      }
    }
   else
    {
      if ($use_compact_event == 0 )
      {  
        if ($virtual_col == 1)
        {
          my $virtualBalRecLine = replace_virtual_cols($balRecLine);
          print OUT1_FILE "$virtualBalRecLine$deli";
        }
        else
        {
          print OUT1_FILE "$balRecLine$deli\n";
        }
      }
    } 
   $foundRecForFile1 = 0;
   $balRecLine = "";
 }

#
# If we are at end of file, without finding a balance rec for
# previously found detail rec.
#

if( $foundRecForFile1 == 1) 
 {
   exit_err( $MISSING_BAL_REC);
 }

close(IN_FILE);
close(OUT1_FILE);
close(OUT2_FILE);
close(OUT3_FILE);
if (defined $OUT4_FILE) 
 {
   close( OUT4_FILE);
 }
if (defined $OUT5_FILE)
 {
   close( OUT5_FILE);
 }
if (defined $OUT6_FILE) 
 {
   close( OUT6_FILE);
 }
if (defined $OUT7_FILE) 
 {
   close( OUT7_FILE);
 }
if (defined $OUT8_FILE) 
 {
   close( OUT8_FILE);
 }
if (defined $OUT9_FILE) 
 {
   close( OUT9_FILE);
 }
if (defined $OUT10_FILE)
 {
   close( OUT10_FILE);
 }
if (defined $OUT11_FILE)
 {
   close( OUT11_FILE);
 }
if (defined $OUT12_FILE)
 {
   close( OUT12_FILE);
 }
if (defined $OUT13_FILE)
 {
   close( OUT13_FILE);
 }
if (defined $OUT14_FILE)
 {
   close( OUT14_FILE);
 }
if (defined $OUT15_FILE)
 {
   close( OUT15_FILE);
 }
if (defined $OUT16_FILE)
 {
   close( OUT16_FILE);
 }
if (defined $OUT17_FILE)
 {
   close( OUT17_FILE);
 }
if (defined $OUT18_FILE)
 {
   close( OUT18_FILE);
 }



#
# Before exiting the program, verify if end poid calculated at the end 
# matches the expected end poid value passed from command line argument
#
$endPoid = new Math::BigInt $poid_id;
print "End poid is $endPoid and expected end poid is $expEndPoid\n" if $debug;
if ($endPoid != $expEndPoid)
 {
   exit_err($END_POID_NOT_MATCHED, "End poid after pre-processing does not match expected end poid", $poid_id);
 }
updateControlFileForClobSize($maxBalancesLargeLength);
exit($PREPROCESS_SUCCESS);


# Initialize algorithm for poid increment in order to improve efficiency.
#
sub init {
   # Using BigInt for all arithmetic is too slow.
   # So, given a starting poid_id0, it is split into two 
   # ranges where there will be a rollover at the 7th place.
   $maxrecs = 10000000; # use 10 million as rollover point

   #
   # Use the modulo off $maxrecs to compute the rollover
   # point and the high-order digits needed before and after
   # the rollover. Copy into non-BigInt
   # vars to improve printing performance.
   #
   $high = 0;
   my $rem = 0;
   my $tmp = 0;
   my $high_tmp = 0 ;

   ($high_tmp, $tmp) =  ($startPoid->bdiv($maxrecs));
   my $tmp1 =  Math::BigInt->bstr($tmp);
   $rem = $tmp1 ;
   $tmp1 =  Math::BigInt->bstr($high_tmp);
   $high = $tmp1 ;
   $i =   ($rem - $incrPoid);
 }

#
# Function to exit program with error code and error messages.
#
sub exit_err {
   $errCode = shift;
   $msg1 = shift;
   $msg2 = shift;

   print "$errCode : $msg1 : $msg2";
    
   #
   # close all files before exiting.
   #
   close(IN_FILE);
   close(OUT1_FILE);
   close(OUT2_FILE);
   close(OUT3_FILE);
   if (defined $OUT4_FILE) 
    {
      close(OUT4_FILE);
    }
   if (defined $OUT5_FILE) 
    {
      close(OUT5_FILE);
    }
   if (defined $OUT6_FILE) 
    {
      close( OUT6_FILE);
    }
   if (defined $OUT7_FILE) 
    {
      close( OUT7_FILE);
    }
   if (defined $OUT8_FILE) 
    {
      close( OUT8_FILE);
    }
   if (defined $OUT9_FILE) 
    {
      close( OUT9_FILE);
    }
   if (defined $OUT10_FILE)
    {
      close( OUT10_FILE);
    }
   if (defined $OUT11_FILE)
    {
      close( OUT11_FILE);
    }
if (defined $OUT12_FILE)
 {
   close( OUT12_FILE);
 }
if (defined $OUT13_FILE)
 {
   close( OUT13_FILE);
 }
if (defined $OUT14_FILE)
 {
   close( OUT14_FILE);
 }
if (defined $OUT15_FILE)
 {
   close( OUT15_FILE);
 }
if (defined $OUT16_FILE)
 {
   close( OUT16_FILE);
 }
if (defined $OUT17_FILE)
 {
   close( OUT17_FILE);
 }
if (defined $OUT18_FILE)
 {
   close( OUT18_FILE);
 }




   close(CTL_FILE);
   close(TMP_FILE);
   exit( $errCode);
 }

#
# Function to serialize sub bal impacts and sub balances data
#
# The serialized format looks like the following:
# C1,<Version>
# <N>:<Level1Array>:<recid1>:<dbNo>:<FldValueList>
# <N>:<Level2Array>:<recid1>:<recid2>:<FldValueList>
#
# Where 
# Version ::= 2.0
# LevelNArray ::= field-id piece of the encoded field number
# N ::= Level N
# FldValueList ::= alphasort{fieldname}(FldValue,)*
# FldValue ::= PoidValue | string-rep of other fields
# PoidValue ::= <poid-id> with the assumption that db,type are implied and rev is not important
# dbNo ::= Infranet database number
#
sub serialize_sub_bal {
   if ($use_compact_event == 1) 
   {
     compact_sub_bal();
     return;
   }
   while ($line =~ m/^$subBalImpRec/o || $line =~ m/^$monitor_subBalImpRec/o) 
    {
      #
      # Record type 605, 805 has the following format:
      # RECORD_TYPE<tab>REC_ID<tab>BAL_GRP_OBJ<tab>RESOURCE_ID
      #
      @subBalImp = split(/$deli/, $line);
      @balGrpObj = split(/ /, $subBalImp[$SUB_BAL_IMP_BAL_GRP_OBJ_POS]);
      $tmp_var_1 = "";
      if ($line =~ m/^$subBalImpRec/o)
       {
         $serializedData .= $SUB_BAL_IMPACTS_PREFIX;
         $serializedData .= $SER_DELIMITER . $sb_rec_id;
         $sb_rec_id++;
	 $tmp_var_1 = $SER_DB_NO_DELIMITER . @classIds{"/balance_group"};
       }
      if ($line =~ m/^$monitor_subBalImpRec/o)
       {
         $serializedData .= $MON_SUB_BALANCES_PREFIX;
         $serializedData .= $SER_DELIMITER . $mon_sb_rec_id;
         $mon_sb_rec_id++;
         $tmp_var_1 = $SER_DB_NO_DELIMITER . @classIds{"/balance_group/monitor"};
       }
      $serializedData .= $SER_DELIMITER . $balGrpObj[$OBJ_DB_POS];
      $serializedData .= $SER_DB_NO_DELIMITER . $balGrpObj[$OBJ_ID0_POS];
      $serializedData .= $tmp_var_1;
      $serializedData .= $SER_FIELD_VALUE_DELIMITER . $subBalImp[$SUB_BAL_IMP_RESOURCE_ID_POS];
      $serializedData .= $SER_RECORD_DELIMITER;
      $tempLine = getNextRecord();
      while ($tempLine =~ m/^$subBalRec/o || $tempLine =~ m/^$monitor_subBalRec/o) 
       {
         #
         # Record type 607, 807 has the following format:
         # RECORD_TYPE<tab>REC_ID<tab>AMOUNT<tab>VALID_FROM<tab>VALID_TO<tab>CONTRIBUTOR
         # <tab>GRANTOR_OBJ<tab>VALID_FROM_DETAILS<tab>VALID_TO_DETAILS
         #
         @subBalances = split(/$deli/, $tempLine);
         $serializedData .= $SUB_BALANCES_PREFIX;
         $serializedData .= $SER_DELIMITER . $subBalances[$SUB_BALANCES_REC_ID_POS];
         $serializedData .= $SER_DELIMITER . $subBalImp[$SUB_BAL_IMP_REC_ID_POS];
         $serializedData .= $SER_DELIMITER . $subBalances[$SUB_BALANCES_AMOUNT_POS];
         $serializedData .= $SER_FIELD_VALUE_DELIMITER . "\"" . $subBalances[$SUB_BALANCES_CONTRIBUTOR_POS] . "\"";
	 if ($subBalances[$SUB_BALANCES_GRANTOR_OBJ_POS] == "") 
          {
	    $grantorPoid = $SER_FIELD_VALUE_DELIMITER . "0" . $SER_DB_NO_DELIMITER . "0" . $SER_DB_NO_DELIMITER . "-1";
	  }
	 else 
          {
            @grantorObj = split(/ /, $subBalances[$SUB_BALANCES_GRANTOR_OBJ_POS]);
            $grantorPoid = $SER_FIELD_VALUE_DELIMITER . $grantorObj[$OBJ_DB_POS] . $SER_DB_NO_DELIMITER;
            $grantorObjType = $grantorObj[$OBJ_TYPE_POS];
            $classIdValue = @classIds{$grantorObjType};
	    if ($classIdValue == "") 
             {
	       exit_err( $UNSUPPORTED_GRANTOR_OBJECT_TYPE, "unsupported grantor object type", $grantorObjType);
	     }
            $grantorPoid .= $grantorObj[$OBJ_ID0_POS] . $SER_DB_NO_DELIMITER . $classIdValue;
          }
         $serializedData .= $grantorPoid;
         if ($tempLine =~ m/^$subBalRec/o) 
          { 
            $serializedData .= $SER_FIELD_VALUE_DELIMITER . $DEFAULT_ROLLOVER_DATA;
	  }
         $serializedData .= $SER_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_FROM_POS];
         $serializedData .= $SER_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_FROM_DETAILS_POS]; 
         $serializedData .= $SER_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_TO_POS];
         $serializedData .= $SER_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_TO_DETAILS_POS];
         $serializedData .= $SER_RECORD_DELIMITER;
	 $tempLine = getNextRecord();
         }
         while ( $tempLine =~ m/^$monitor_balImpRec/o ) 
          {
            #
            # Record type 800 has the following format:
            # RECORD_TYPE<tab>REC_ID<tab>ACCOUNT_OBJ<tab>BAL_GRP_OBJ<tab>RESOURCE_ID<tab>AMOUNT
            #
            @subBalImp = split(/$deli/, $tempLine);
            $serializedData .= $MON_SUB_BAL_IMPACTS_PREFIX;                                 
            $serializedData .= $SER_DELIMITER . $subBalImp[$MON_BAL_REC_ID_POS];    
            @monAccountObj = split(/ /, $subBalImp[$MON_BAL_ACCOUNT_OBJ_POS]);
            $serializedData .= $SER_DELIMITER . $monAccountObj[$OBJ_DB_POS];
            $serializedData .= $SER_DB_NO_DELIMITER . $monAccountObj[$OBJ_ID0_POS];
            $serializedData .= $SER_DB_NO_DELIMITER . @classIds{"/account"};
            $serializedData .= $SER_FIELD_VALUE_DELIMITER . $subBalImp[$MON_BAL_AMOUNT_POS];
            @monBalGrpObj = split(/ /, $subBalImp[$MON_BAL_GRP_OBJ_POS]);
            $serializedData .= $SER_FIELD_VALUE_DELIMITER . $monBalGrpObj[$OBJ_DB_POS];
            $serializedData .= $SER_DB_NO_DELIMITER . $monBalGrpObj[$OBJ_ID0_POS];
            $serializedData .= $SER_DB_NO_DELIMITER . @classIds{"/balance_group/monitor"};
            $serializedData .= $SER_FIELD_VALUE_DELIMITER . $subBalImp[$MON_BAL_RESOURCE_ID_POS];     
            $serializedData .= $SER_RECORD_DELIMITER;
	    $tempLine = getNextRecord();
	  }
         $line = $tempLine;
       }
 }

#
# Print out serialized data if needed
#
sub print_serialize_sub_bal {

    if ($use_compact_event == 1) 
    {
         if ($savedetailRec eq "")
           {
           return;
           }
      # build compact data from constituents 
      # this should be based on the format for the particular type
      # Get top level fields in first. Then add type based 
      #$compactDataFormat = "<$monitor_bal_impacts><$monitor_sub_bal_impacts><$rum_map_array><$sub_bal_impacts><$tax_juris><$svc_codes><$telco_info>"
          if ($monitor_bal_impacts eq "")
          {
              $monitor_bal_impacts=$EMPTY_COMPACT_ARRAY;
          }
          if ($monitor_sub_bal_impacts eq "")
          {
              $monitor_sub_bal_impacts=$EMPTY_COMPACT_ARRAY;
          }
          if ($rum_map_array eq "")
          {
              $rum_map_array=$EMPTY_COMPACT_ARRAY;
          }
          if ($sub_bal_impacts eq "")
          {
              $sub_bal_impacts=$EMPTY_COMPACT_ARRAY;
          }
          if ($tax_juris_array eq "")
          {
              $tax_juris_array=$EMPTY_COMPACT_ARRAY;
          } else {

              $tax_juris_array .= $COMPACT_ARRAY_SUBST_SUFFIX;
          }
      $compactData = $monitor_bal_impacts . $monitor_sub_bal_impacts . $rum_map_array . $sub_bal_impacts . $tax_juris_array . $telco_info_subst;
	$monitor_bal_impacts = "";
	$monitor_sub_bal_impacts = "";
	$rum_map_array = "";
	$sub_bal_impacts = "";
	$tax_juris_array = "";
	$telco_info_subst = "";
   my $dataLength = length($compactData);
         if ($dataLength > $maxBalancesLargeLength) 
          {
            $maxBalancesLargeLength = $dataLength;
          }

# We would have written base detailRec earlier. Now add the balRecLine
          if ($virtual_col == 1)
          {
            my $virtualBalRecLine = replace_virtual_cols($balRecLine);
            print OUT1_FILE "$virtualBalRecLine$deli";
          }
          else
          {
            print OUT1_FILE "$balRecLine$deli";
          }

# Now follow with compctData
           if ($compactData eq "" )
             {
               print "compact_data is null : $compactData\n" if $debug;
               print OUT1_FILE "\n";
             }
             else {
               print " compact_data is not null: $compactData\n" if $debug;
               print OUT1_FILE "$compactData$deli\n";
               $compactData = "";
             }
      return;
    }
   my $dataLength = length($serializedData);
   if ($serializedData ne $SER_VERSION) 
    {
      if ($dataLength < $VARCHAR2_SIZE_LIMIT) 
       {
         $tempLine = sprintf("$poid_id$deli$serializedData$deli$deli$accountObjId0$deli$end_t");
       }
      elsif ($dataLength < $CLOB_SIZE_LIMIT) 
       {
         $tempLine = sprintf("$poid_id$deli$deli$serializedData$deli$accountObjId0$deli$end_t");
         if ($dataLength > $maxBalancesLargeLength) 
          {
            $maxBalancesLargeLength = $dataLength;
          }
       }
      else
       {
         exit_err($SERIALIZED_DATA_EXCEEDS_LIMIT, 
                  "Serialized data exceeds CLOB size limitation", $dataLength);
       }
      #
      # This condition is for SQL server, has BCP Loader do not support variable length format. 
      #
      if (length($constStr) > 0)
       {
      	print OUT3_FILE "$tempLine\n";
       }
      else 
       {
         my $length = length($tempLine);
      	 $tempLine = sprintf("%010u$tempLine", $length);
      	 print OUT3_FILE "$tempLine";
       }  
      print "sub_bal_impact serialization  aft lenght\n $tempLine\n" if $debug;
      #
      # Reset serialized string
      #
      $serializedData = $SER_VERSION;
    }
 }


# compacts monitor_bal_impacts, monitor_sub_bal_impacts and sub_bal_impacts arrays
#
sub compact_sub_bal {
   $tempData = "";
   $use_monitor_sub_bal_impacts = 0;

   while ($line =~ m/^$subBalImpRec/o || $line =~ m/^$monitor_subBalImpRec/o || $line =~ m/^monitor_balImpRec/o )  
    {
      if ($line =~ m/^$subBalImpRec/o)
       {
   # fill up $sub_bal_impacts
      #
      # Record type 605 monit_sub_bal_impacts, has the following format:
      # RECORD_TYPE<tab>REC_ID<tab>BAL_GRP_OBJ<tab>RESOURCE_ID
      #
	 $tempLine = $line;
         $sub_bal_impacts = $COMPACT_ARRAY_SUBST_PREFIX;
         $sub_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;
         while ($tempLine =~ m/^$subBalImpRec/o ) 
          {

            @subBalImp = split(/$deli/, $tempLine);
            @balGrpObj = split(/ /, $subBalImp[$SUB_BAL_IMP_BAL_GRP_OBJ_POS]);
            $sub_bal_impacts .= $subBalImp[$SUB_BAL_IMP_REC_ID_POS];
            $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER;
            $sub_bal_impacts .= $subBalImp[$SUB_BAL_IMP_BAL_GRP_OBJ_POS];
            $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalImp[$SUB_BAL_IMP_RESOURCE_ID_POS];
            $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER;
            $tempLine = getNextRecord();
            $sub_bal_impacts .= $COMPACT_ARRAY_SUBST_PREFIX;
            $sub_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;
             while ($tempLine =~ m/^$subBalRec/o) 
              {
                #
                # Record type 607 has the following format:
                # RECORD_TYPE<tab>REC_ID<tab>AMOUNT<tab>VALID_FROM<tab>VALID_TO<tab>CONTRIBUTOR
                # <tab>GRANTOR_OBJ<tab>VALID_FROM_DETAILS<tab>VALID_TO_DETAILS
                #
                @subBalances = split(/$deli/, $tempLine);
                $sub_bal_impacts .= $subBalances[$SUB_BALANCES_REC_ID_POS];
                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER ;
                $sub_bal_impacts .= $subBalances[$SUB_BALANCES_AMOUNT_POS];
                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_CONTRIBUTOR_POS];
	 if ($subBalances[$SUB_BALANCES_GRANTOR_OBJ_POS] == "") 
          {
                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . "0 0 0 0";
          } else {
                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_GRANTOR_OBJ_POS];
          }
                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $DEFAULT_ROLLOVER_DATA;

                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_FROM_POS];
                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_FROM_DETAILS_POS]; 
                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_TO_POS];
                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_TO_DETAILS_POS];
                $sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER;
                $sub_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;



                $tempLine = getNextRecord();
              }
              $sub_bal_impacts .= $COMPACT_ARRAY_SUBST_SUFFIX;
               $sub_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;

          }
         $line = $tempLine;
         $sub_bal_impacts .= $COMPACT_ARRAY_SUBST_SUFFIX;

       }
      elsif ($line =~ m/^$monitor_subBalImpRec/o) 
       {
   # fill up $monitror_sub_bal_impacts
      #
      # Record type 805 monit_sub_bal_impacts, has the following format:
      # RECORD_TYPE<tab>REC_ID<tab>BAL_GRP_OBJ<tab>RESOURCE_ID
      #
	 $tempLine = $line;
         $monitor_sub_bal_impacts = $COMPACT_ARRAY_SUBST_PREFIX;
         $monitor_sub_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;
         while ($tempLine =~ m/^$monitor_subBalImpRec/o ) 
          {
            @monsubBalImp = split(/$deli/, $tempLine);
            @balGrpObj = split(/ /, $monsubBalImp[$SUB_BAL_IMP_BAL_GRP_OBJ_POS]);
            $monitor_sub_bal_impacts .= $monsubBalImp[$SUB_BAL_IMP_REC_ID_POS];
            $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER;
            $monitor_sub_bal_impacts .= $monsubBalImp[$SUB_BAL_IMP_BAL_GRP_OBJ_POS];
            $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $monsubBalImp[$SUB_BAL_IMP_RESOURCE_ID_POS];
            $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER;
            $tempLine = getNextRecord();
            $monitor_sub_bal_impacts .= $COMPACT_ARRAY_SUBST_PREFIX;
            $monitor_sub_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;
             while ($tempLine =~ m/^$monitor_subBalRec/o) 
              {
                #
                # Record type 807 has the following format:
                # RECORD_TYPE<tab>REC_ID<tab>AMOUNT<tab>VALID_FROM<tab>VALID_TO<tab>CONTRIBUTOR
                # <tab>GRANTOR_OBJ<tab>VALID_FROM_DETAILS<tab>VALID_TO_DETAILS
                #
                @subBalances = split(/$deli/, $tempLine);
                $monitor_sub_bal_impacts .= $subBalances[$SUB_BALANCES_REC_ID_POS];
                $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER ;
                $monitor_sub_bal_impacts .= $subBalances[$SUB_BALANCES_AMOUNT_POS];
                $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_CONTRIBUTOR_POS];
	 if ($subBalances[$SUB_BALANCES_GRANTOR_OBJ_POS] == "") 
          {
                $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . "0 0 0 0";
          } else {
                $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_GRANTOR_OBJ_POS];
          }
                $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_FROM_POS];
                $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_FROM_DETAILS_POS]; 
                $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_TO_POS];
                $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $subBalances[$SUB_BALANCES_VALID_TO_DETAILS_POS];
                $monitor_sub_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER;
                $monitor_sub_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;



                $tempLine = getNextRecord();
              }
              $monitor_sub_bal_impacts .= $COMPACT_ARRAY_SUBST_SUFFIX;
               $monitor_sub_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;

          }
         $monitor_sub_bal_impacts .= $COMPACT_ARRAY_SUBST_SUFFIX;
         $line = $tempLine;


       } elsif ( $line =~ m/^monitor_balImpRec/o ) 
       {
            # fill up $monitror_bal_impacts
            #
            # Record type 800 has the following format:
            # RECORD_TYPE<tab>REC_ID<tab>ACCOUNT_OBJ<tab>BAL_GRP_OBJ<tab>RESOURCE_ID<tab>AMOUNT
            #
	 $tempLine = $line;
         $monitor_bal_impacts = $COMPACT_ARRAY_SUBST_PREFIX;
         $monitor_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;
         while ( $tempLine =~ m/^$monitor_balImpRec/o ) 
          {

            @monBalImpValues = split(/$deli/, $tempLine);
            $monitor_bal_impacts .= $monBalImpValues[$MON_BAL_REC_ID_POS];    
            $monitor_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER;

            @monAccountObj = split(/ /, $monBalImpValues[$MON_BAL_ACCOUNT_OBJ_POS]);
            $monitor_bal_impacts .= $monBalImpValues[$MON_BAL_ACCOUNT_OBJ_POS];
            $monitor_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $monBalImpValues[$MON_BAL_AMOUNT_POS];
            $monitor_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $monBalImpValues[$MON_BAL_GRP_OBJ_POS];
            @monBalGrpObj = split(/ /, $monBalImpValues[$MON_BAL_GRP_OBJ_POS]);
            $monitor_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER . $monBalImpValues[$MON_BAL_RESOURCE_ID_POS];     
            $monitor_bal_impacts .= $COMPACT_FIELD_VALUE_DELIMITER; 

            $monitor_bal_impacts .= $COMPACT_ARRAY_REC_SEPARATOR;
	    $tempLine = getNextRecord();
          }
         $monitor_bal_impacts .= $COMPACT_ARRAY_SUBST_SUFFIX;
         $line = $tempLine;

      }
    }
 }

#
# Update data size for balances_large column in template control file only if required
# data size is greater than the one currently specified in the template control file
#
sub updateControlFileForClobSize {
   my $size = $_[0];
   if ($size == 0) 
    {
      #
      # No balances_large record was generated so no need to continue
      #
      return;
    }
    my $needToUpdate = 0;
    my $controlFile = "event_t.ctl";
    my $column_name = "COMPACT_SUB_EVENT";
    if ($use_compact_event == 0) {
    $controlFile = "event_essentials_t.ctl";
    $column_name = "BALANCES_LARGE";
    } 

    my $tmpFile = $interimDir . "/" . $file . "." . $controlFile . ".tmp";
    open(CTL_FILE, "$controlFile") || exit_err($CANT_OPEN_FILE, $controlFile, $!);
    open(TMP_FILE, ">$tmpFile") || exit_err($CANT_OPEN_FILE, $tmpFile, $!);
    while ($line = <CTL_FILE>) 
     {
       if ($line =~ /$column_name/i && $line =~ /CHAR\((\d+)\)/i) 
        {
          #
          # update data size only if required size is greater than 
          # current size that is specified in template control file
          #
          if ($size > $1) 
           {
             $line =~ s/CHAR\((\d+)\)/CHAR($size)/i;
             $needToUpdate = 1;
           }
        }
        print TMP_FILE $line;
      }
     close(CTL_FILE);
     close(TMP_FILE);

     if ($needToUpdate == 1) 
      {
        #
        # rename temporary file to template control file
        #
        if ($^O =~ /win/i) 
         {	# Windows
           system("copy $tmpFile $controlFile; del $tmpFile");
         }
        else 
         {	# UNIX
           system("cp $tmpFile $controlFile; rm $tmpFile");
         }
        print "Update balances_large size to $size for template control file $controlFile.\n" if $debug;
      }
     else 
      {
        # 
        # No need to update template control file - delete temporary file
        #
        if ($^O =~ /win/i) 
         {	# Windows
           system("del $tmpFile");
         }
        else 
         {	# UNIX
           system("rm $tmpFile");
         }
      }
 }

# Function to read the cdrs from the rated out file
# and then store them in arrays for header record,
# trailer record and edrs
sub readCdrs
 {
   my $infile = shift;
   my $line, $cdr;
   my @headers, @trailers, @cdrs;
   # Consume all the header stuff
   while ($line = <$infile>) 
    {
      chomp($line);
      # Assumption: First 020 marks the beg of detail records
      last if ($line =~ m/^$dtlRec/o);     # using "o" modifier - no recompile
      push @headers, $line;
    }

   # Start getting one ENTIRE detail record at a time
   # this must be local (I think).
   local $oldRS = $/;                     # Save old record separator
   local $/ = "$recEnd$dtlRec$deli";      # change record separator
 
   # We already read the first line of detail record; but
   # in the subsequent iterations, we will read the next detail
   # record's record type as well; so adjust this line that has
   # been read to match the loop below.
   # To be precise, now our line is 020\t...
   # In the future cdr will be      ...\n020\t
   # Or the last record will be     ...EOF
   # line is now 020\txyz...
   $line =~ s/^$dtlRec$deli//;            # remove rectype from beg of line
   # line is now xyz...
   $cdr  = <$infile>;                     # read remaining block
   # cdr is now abc...\n020\t
   $cdr  = $line . "\n" . $cdr;           # compose the block
   # cdr is now xyz...\nabc...\n020\t
   do 
    {
      # since we have read the record (block) separator as well,
      # remove it
      $cdr =~ s/$recEnd$dtlRec$deli//o;
      # cdr is now xyz......
      # put the block separator back at the beginning sans the recseparator
      $cdr =  "$dtlRec$deli" . $cdr;
      # cdr is now 020\txyz......
      push @cdrs, $cdr;                    # collect all cdrs into an array
    }while ($cdr = <$infile>);               # read next block

   # We over-consumed the last 020 record; this has the trailers, which
   # need to be split out. The start of the trailer is \n090.
   $cdr = pop @cdrs;
   ($cdr, $junk, $trailer) = $cdr =~ m/((.|\n)+)$recEnd($trailRec$deli.+)/;

   # Put the last data record back and trailer into trailers
   push @cdrs, $cdr;
   push @trailers, $trailer;
 
   $/ = $oldRS;                           # restore the REC SEPARATOR
   return (\@headers, \@cdrs, \@trailers);
 }


# Function which will reset the current pointer
# to start reading the record from the edr array
# from the begining

sub resetGetNextRecord {
   $G_hdrsIndex       = 0;
   $G_hdrsIndexMax    = -1;
   $G_cdrsIndex       = 0;
   $G_cdrsIndexMax    = -1;
   $G_recordsIndex    = 0;
   $G_recordsIndexMax = -1;
   $G_trlsIndex       = 0;
   $G_trlsIndexMax    = -1;
  }
  
# Initialize different parameters before
# reading the records from the edrs array
sub initGetNextRecord {
   $G_hdrsRef = shift;
   $G_cdrsRef = shift;
   $G_trlsRef = shift;
   $G_hdrsIndexMax = $#$G_hdrsRef;
   $G_cdrsIndexMax = $#$G_cdrsRef;
   $G_trlsIndexMax = $#$G_trlsRef;
   $nextLine = "";
  }


# Returns next record from the edrs array

sub getNextRecord {
   # Return records from the headers; If done, then 
   # return records from the cdrs; If done, then
   # return records from the trailers.

   if ($sortEnabled) 
    {
      if ($G_hdrsIndex <= $G_hdrsIndexMax) 
       {
         # headers were read as one line at a time...
 	 return @$G_hdrsRef[$G_hdrsIndex++];
       }      
      if ($G_recordsIndex <= $G_recordsIndexMax) 
       {
         return $G_records[$G_recordsIndex++];
       } 
      if ($G_cdrsIndex <= $G_cdrsIndexMax)
       {
         $cdrRef = @$G_cdrsRef[$G_cdrsIndex++];
  	 $cdrRef = ${$cdrRef->[0]};
	 @G_records = split($recEnd, $cdrRef);
	 $G_recordsIndex = 0;
	 $G_recordsIndexMax = $#G_records;
         if ($G_recordsIndex <= $G_recordsIndexMax) 
          {
	    return $G_records[$G_recordsIndex++];
	  }
	}
  
       if ($G_trlsIndex <= $G_trlsIndexMax) 
        {
  	  my $trailer = @$G_trlsRef[$G_trlsIndex++];
	  @G_records = split($recEnd, $trailer);
	  $G_recordsIndex = 0;
	  $G_recordsIndexMax = $#G_records;
  	  return $G_records[$G_recordsIndex++];
	}      

       return "";
     }
    else
     {
       $nextLine = <IN_FILE>;
       chomp($nextLine);
       return $nextLine;
     }
 } #end getNextRecord


#
# Function to replace virtual columns data in the CDR
# with the coresponding number from the classId_values.txt entry.
# Replace poid type field in the poid columns, ensure no trailing fields are swallowed
# Handle null poid types that show up as a space or "/" as in "0  0 0" or "0 / 0 0"

sub replace_virtual_cols {
	my $originalLine = $_[0];
	my $newLine = $originalLine;

	my  @originalcols = split(/$deli/, $originalLine, -1);
	if ($originalLine =~ m/^$balRec/o) {

#		In record 900, $2, $3, $4, $5 require virtual column substitution

		foreach $n  (2, 3, 4, 5) {
			if ($originalcols[$n] =~ m|^(\S*\s)(\S*)(.*)$|) {
				if (defined $classIds{$2}) {
					$originalcols[$n] = "${1}$classIds{$2}$3";
				} elsif (${2} eq "/" || ${2} eq "") {
					$originalcols[$n] = "${1}$3";
				} else {
				  warn "${2} not a valid virtual_type";
				}
			} else {
				warn " $n : $originalcols[$n] has no classid match ..";
			}
		}

		$newLine = join ($deli, @originalcols);

	} elsif ($originalLine =~ m/^$balImpRec/o) {

# 		In record  600, $2,$3,$4, $9, $15 require virtual column substitution

		foreach $n  (2, 3, 4, 9, 15) {
			if ($originalcols[$n] =~ m|^(\S*\s)(\S*)(.*)$|) {
				if (defined $classIds{$2}) {
					$originalcols[$n] = "${1}$classIds{$2}$3";
				} elsif (${2} eq "/" || ${2} eq "") {
					$originalcols[$n] = "${1}$3";
				} else {
					warn "${2} not a valid virtual_type";
				}
			} else {
				warn " $n : $originalcols[$n] has no classid match ..";
			}
		}
		$newLine = join ( $deli, @originalcols);

	}
# Reassemble the cols and return the new line
	print "Result after replacing virtual column types=:$newLine:\n" if $debug;
	return $newLine;
 }


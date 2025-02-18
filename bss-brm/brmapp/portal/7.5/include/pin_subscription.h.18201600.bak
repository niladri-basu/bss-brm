/*******************************************************************
 *	
* Copyright (c) 2000, 2011, Oracle and/or its affiliates. All rights reserved. 
 *
 *	This material is the confidential property of Oracle Corporation
 *	or its licensors and may be used, reproduced, stored or transmitted
 *	only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

/* 
 * NOTE: 
 *	If defining a new event type, also define it's corresponding
 *      event description.
 */


#ifndef _PIN_SUBSCRIPTION_H
#define	_PIN_SUBSCRIPTION_H

/*******************************************************************
 * Subscription FM Definitions.
 *
 * For the old data, refer pin_bill.h for other subscription mgmt
 * settings.
 *******************************************************************/

/*******************************************************************
 * PIN_FLD_FLAGS for PCM_OP_SUBSCRIPTION_TRANSITION_PLAN  
 *******************************************************************/
#define PIN_SUBS_TRANSITION_CONTROL_ROLLOVER	0x01
#define PIN_SUBS_TRANSITION_GEN_CHANGE		0x02

/*=================================================================*
 * Discount and discount instance related definitions.
 *=================================================================*/

/*******************************************************************
 * Object Type Strings (for discount action events)
 *******************************************************************/
#define	PIN_OBJ_TYPE_EVENT_DISCOUNT 		\
			"/event/billing/discount"
#define	PIN_OBJ_TYPE_EVENT_DISCOUNT_ACTION	\
			"/event/billing/discount/action"
#define	PIN_OBJ_TYPE_EVENT_DISCOUNT_ACTION_PURCHASE \
			"/event/billing/discount/action/purchase"
#define	PIN_OBJ_TYPE_EVENT_DISCOUNT_ACTION_CANCEL \
			"/event/billing/discount/action/cancel"
#define	PIN_OBJ_TYPE_EVENT_DISCOUNT_ACTION_MODIFY \
			"/event/billing/discount/action/modify"
#define	PIN_OBJ_TYPE_EVENT_DISCOUNT_ACTION_MODIFY_STATUS \
			"/event/billing/discount/action/modify/status"
/*******************************************************************
 * First usage Product/discount set validity events
 *******************************************************************/
#define PIN_OBJ_TYPE_EVENT_PRODUCT_SET_VALIDITY "/event/billing/product/action/set_validity"
#define PIN_OBJ_TYPE_EVENT_DISCOUNT_SET_VALIDITY "/event/billing/discount/action/set_validity"
#define PIN_EVENT_DESCR_SET_VALIDITY_SHADOW_EVENT     "set validity shadow event"
#define PIN_OBJ_TYPE_EVENT_SUB_BAL_SET_VALIDITY "/event/billing/sub_bal_validity"

/*******************************************************************
 * Events related to Promotion Name on Invoice 
 *******************************************************************/
#define PIN_OBJ_TYPE_EVENT_BUNDLE_CREATE "/event/billing/bundle/create"
#define PIN_OBJ_TYPE_EVENT_BUNDLE_MODIFY "/event/billing/bundle/modify"
#define PIN_EVENT_DESCR_SET_BUNDLE_INFO "Set Bundle Info"

/*******************************************************************
 * Discount event description strings.
 *******************************************************************/
#define PIN_EVENT_DESCR_PURCHASE_DISCOUNT	"Purchase Discount"
#define PIN_EVENT_DESCR_CANCEL_DISCOUNT		"Cancel Discount"
#define PIN_EVENT_DESCR_SET_DISCINFO		"Modified Discount"
#define PIN_EVENT_DESCR_SET_DISCOUNT_STATUS	"Modified Discount Status"

/***************************************************************************
 * First Usage product/Discount set validity Event descriptions
 ************************************************************************/
#define PIN_EVENT_DESCR_SET_FU_PRODUCT_VALIDITY	 	" First Usage Product Validity"
#define PIN_EVENT_DESCR_SET_FU_DISCOUNT_VALIDITY	" First Usage Discount Validity"

/*******************************************************************
 * Settings for billing time cycle discount and rollover events.
 *******************************************************************/
#define	PIN_OBJ_TYPE_EVENT_CYCLE_DISCOUNT	\
			"/event/billing/cycle/discount"
#define	PIN_OBJ_TYPE_EVENT_CYCLE_DISC_MOSTCALLED	\
			"/event/billing/cycle/discount/mostcalled"
#define	PIN_OBJ_TYPE_EVENT_CYCLE_ROLLOVER	\
			"/event/billing/cycle/rollover"
#define	PIN_OBJ_TYPE_EVENT_CYCLE_ROLLOVER_TRANSFER	\
			"/event/billing/cycle/rollover_transfer"


#define PIN_EVENT_DESCR_CYCLE_DISCOUNT		"Cycle Discounts"
#define PIN_EVENT_DESCR_CYCLE_DISC_MOSTCALLED	"Most Called  Discounts"
#define PIN_EVENT_DESCR_CYCLE_ROLLOVER		"Cycle Rollover"
#define PIN_EVENT_DESCR_CYCLE_ROLLOVER_TRANSFER		"Rollover Transfer"


/*******************************************************************
 * Discount Validity Indices
 *******************************************************************/
#define PIN_DISCOUNT_INDEX_FROM_MIDDLE          0
#define PIN_DISCOUNT_INDEX_TO_MIDDLE            1
#define PIN_DISCOUNT_INDEX_ONLY_MIDDLE          2

/*******************************************************************
 * Discount Flags for Variable DiscountAction
 *******************************************************************/
#define PIN_DISCOUNT_PURCHASE_FLAG      1
#define PIN_DISCOUNT_CANCEL_FLAG        2
#define PIN_DISCOUNT_SET_INFO_FLAG      3


/*******************************************************************
 * PIN_FLD_TYPE - Type of discount
 *******************************************************************/
typedef enum pin_disc_type {
	PIN_DISC_TYPE_ITEM =	601,
	PIN_DISC_TYPE_ONGOING = 602,
	PIN_DISC_TYPE_SYSTEM =	603
} pin_disc_type_t;

/*******************************************************************
 * PIN_FLD_STATUS - Status of a discount
 *******************************************************************/
typedef enum pin_discount_status {
	PIN_DISCOUNT_STATUS_NOT_SET =	0,
	PIN_DISCOUNT_STATUS_ACTIVE =	1,
	PIN_DISCOUNT_STATUS_INACTIVE =	2,
	PIN_DISCOUNT_STATUS_CANCELLED =	3
} pin_discount_status_t;

/*******************************************************************
 * Flags for purchased bundle
 *******************************************************************/
typedef enum pin_bundle_status {
	PIN_BUNDLE_STATUS_NOT_SET =	0,
	PIN_BUNDLE_STATUS_ACTIVE =	1,
	PIN_BUNDLE_STATUS_INACTIVE =	2,
	PIN_BUNDLE_STATUS_CANCELLED =	3
} pin_bundle_status_t;

#define PIN_SUBS_DELINK_BUNDLE_OFFERINGS	0x1

/*******************************************************************
 * PIN_FLD_MODE - Mode of discount
 *******************************************************************/
typedef enum pin_disc_mode {
	PIN_DISC_MODE_PARALLEL	=	801,
	PIN_DISC_MODE_CASCADING	=	802,
	PIN_DISC_MODE_SEQUENTIAL =	803
} pin_disc_mode_t;

/*******************************************************************
 * PIN_FLD_APPLY_MODE - Operation on a resource 
 *******************************************************************/
typedef enum pin_apply_mode {
	PIN_APPLY_MODE_UNDEFINED =	0,
	PIN_APPLY_MODE_FOLD =		1
} pin_apply_mode_t;

/*******************************************************************
 * PIN_DISCOUNT_FLAGS - FLags of a discount rules 
 *******************************************************************/
typedef enum pin_discount_flags {
        PIN_DISCOUNT_FLAG_NA =         0,
        PIN_DISCOUNT_FLAG_FULL =       1,
        PIN_DISCOUNT_FLAG_PRORATE =    2,
        PIN_DISCOUNT_FLAG_NONE =       3
} pin_discount_flags_t;

/*******************************************************************
 * PCM_OP_BILL_CANCEL_DISCOUNT. ACTIONS for Cancel discount.
 *******************************************************************/
#define PIN_BILL_CANCEL_DISCOUNT_ACTION_CANCEL_ONLY     "cancel_only"
#define PIN_BILL_CANCEL_DISCOUNT_ACTION_CANCEL_DELETE   "cancel_delete"
#define PIN_BILL_CANCEL_DISCOUNT_ACTION_DONOT_CANCEL    "donot_cancel"

/*-----------------------------------------------------------------*
 * End Discount and Discount instance related definitions.
 *-----------------------------------------------------------------*/

/*******************************************************************
 * PIN_FLD_FLAGS - Indicates the validations to be performed by the  
 * PCM_OP_SUBSCRIPTION_VALIDATE_DISCOUNT_DEPENDENCY opcode. 
 *******************************************************************/
#define PIN_SUBS_FLG_DISC_DISC_DEP              0x1                                
#define PIN_SUBS_FLG_PLAN_DISC_DEP              0x2               
#define PIN_SUBS_FLG_DISABLE_PURCH_TIME         0x4                        
#define PIN_SUBS_FLG_RETURN_ON_FIRST_ERR        0x8


/*=================================================================*
 * Group Sharing, Ordered Balance group and Mapping Table related 
 * definitions.
 *=================================================================*/

/*******************************************************************
 * Mapping Table definitions.
 *******************************************************************/
/*        CALC_ONLY event types. not recorded */
#define	PIN_OBJ_TYPE_MAPPING_TABLE_CREATE	\
			"/event/billing/balgrp_map/create"
#define	PIN_OBJ_TYPE_MAPPING_TABLE_MODIFY	\
			"/event/billing/balgrp_map/modify"
#define	PIN_OBJ_TYPE_MAPPING_TABLE_DELETE	\
			"/event/billing/balgrp_map/delete"

#define MAPPING_TABLE_POID_TYPE		"/balgrp_map"
#define MAPPING_TABLE_PROGRAM_STR	"Mapping Table"
#define MAPPING_TABLE_TYPE_STR		"Mapping Table"

#define PIN_SUBS_MAPPING_TABLE_ACTION_CREATE   "Create"
#define PIN_SUBS_MAPPING_TABLE_ACTION_MODIFY   "Modify"
#define PIN_SUBS_MAPPING_TABLE_ACTION_DELETE   "Delete"

/*******************************************************************
 * Ordered Balance Group definitions.
 *******************************************************************/
#define	PIN_OBJ_TYPE_ORDERED_BALGRP_CREATE	\
			"/event/billing/ordered_balgrp/create"
#define	PIN_OBJ_TYPE_ORDERED_BALGRP_MODIFY	\
			"/event/billing/ordered_balgrp/modify"
#define	PIN_OBJ_TYPE_ORDERED_BALGRP_DELETE	\
			"/event/billing/ordered_balgrp/delete"

#define ORDERED_BALGROUP_POID_TYPE		"/ordered_balgrp"
#define ORDERED_BALGROUP_PROGRAM_STR		"Ordered Balance Group"
#define ORDERED_BALGROUP_TYPE_STR		"Ordered Balance Group"

#define PIN_SUBS_ORDERED_BALGRP_ACTION_CREATE   "Create"
#define PIN_SUBS_ORDERED_BALGRP_ACTION_MODIFY   "Modify"
#define PIN_SUBS_ORDERED_BALGRP_ACTION_DELETE   "Delete"
#define PIN_SUBS_ORDERED_BALGRP_ACTION_LIST     "List"

/*******************************************************************
 * Event Description Strings
 *******************************************************************/
#define PIN_EVENT_DESCR_ORDERED_BALGRP_CREATE	"Create Ordered Balance Group"
#define PIN_EVENT_DESCR_ORDERED_BALGRP_MODIFY	"Modify Ordered Balance Group"
#define PIN_EVENT_DESCR_ORDERED_BALGRP_DELETE	"Delete Ordered Balance Group"

/*******************************************************************
 * Group Sharing definitions.
 *******************************************************************/
#define PIN_OBJ_TYPE_DISCOUNTS_GROUP_CREATE	\
			"/event/group/sharing/discounts/create"
#define PIN_OBJ_TYPE_DISCOUNTS_GROUP_MODIFY	\
			"/event/group/sharing/discounts/modify"
#define PIN_OBJ_TYPE_DISCOUNTS_GROUP_DELETE	\
			"/event/group/sharing/discounts/delete"
#define PIN_OBJ_TYPE_CHARGES_GROUP_CREATE	\
			"/event/group/sharing/charges/create"
#define PIN_OBJ_TYPE_CHARGES_GROUP_MODIFY	\
			"/event/group/sharing/charges/modify"
#define PIN_OBJ_TYPE_CHARGES_GROUP_DELETE	\
			"/event/group/sharing/charges/delete"
#define PIN_OBJ_TYPE_PROFILES_GROUP_CREATE	\
			"/event/group/sharing/profiles/create"
#define PIN_OBJ_TYPE_PROFILES_GROUP_MODIFY	\
			"/event/group/sharing/profiles/modify"
#define PIN_OBJ_TYPE_PROFILES_GROUP_DELETE	\
			"/event/group/sharing/profiles/delete"

#define PIN_EVENT_DESCR_DISCOUNTS_GROUP_CREATE	\
			"Create Discount Sharing Group"
#define PIN_EVENT_DESCR_DISCOUNTS_GROUP_MODIFY	\
			"Modify Discount Sharing Group"
#define PIN_EVENT_DESCR_DISCOUNTS_GROUP_DELETE	\
			"Delete Discount Sharing Group"
#define PIN_EVENT_DESCR_CHARGES_GROUP_CREATE	\
			"Create Charge Sharing Group"
#define PIN_EVENT_DESCR_CHARGES_GROUP_MODIFY	\
			"Modify Charge Sharing Group"
#define PIN_EVENT_DESCR_CHARGES_GROUP_DELETE	\
			"Delete Charge Sharing Group"
#define PIN_EVENT_DESCR_PROFILES_GROUP_CREATE	\
			"Create Profile Sharing Group"
#define PIN_EVENT_DESCR_PROFILES_GROUP_MODIFY	\
			"Modify Profile Sharing Group"
#define PIN_EVENT_DESCR_PROFILES_GROUP_DELETE	\
			"Delete Profile Sharing Group"

#define SHARING_GROUP_CHARGES_TYPE_STR          "Sharing Charges Group"
#define SHARING_GROUP_DISCOUNTS_TYPE_STR        "Sharing Discounts Group"
#define SHARING_GROUP_PROFILES_TYPE_STR         "Sharing Profiles Group"

#define SHARING_GROUP_CHARGES_PROGRAM_STR       "Sharing Charges"
#define SHARING_GROUP_DISCOUNTS_PROGRAM_STR     "Sharing Discounts"
#define SHARING_GROUP_PROFILES_PROGRAM_STR      "Sharing Profiles"

#define GROUP_SHARING_POID_TYPE			"/group/sharing"
#define GROUP_SHARING_CHARGES_POID_TYPE		"/group/sharing/charges"
#define GROUP_SHARING_DISCOUNTS_POID_TYPE	"/group/sharing/discounts"
#define GROUP_SHARING_PROFILES_POID_TYPE	"/group/sharing/profiles"

#define ORDERED_BALGRP_POSITION_TOP 	1	
#define ORDERED_BALGRP_POSITION_BOTTOM 	0	

/*-----------------------------------------------------------------*
 * End Group Sharing, Ordered Balance group and Mapping Table related 
 * definitions.
 *-----------------------------------------------------------------*/

/*******************************************************************
 * Line management definitions.
 *******************************************************************/
#define PIN_OBJ_TYPE_EVENT_AUDIT_TRANSFER_SUBSCRIPTION	\
			"/event/audit/subscription/transfer"
#define PIN_OBJ_TYPE_EVENT_AUDIT_CANCEL_SUBSCRIPTION	\
			"/event/audit/subscription/cancel"
#define PIN_OBJ_NAME_EVENT_AUDIT 	"Audit event"

#define PIN_TRANSFER_NAME_TRANSFER               "transfer"

/*******************************************************************
 * Balance Monitoring definitions
 *******************************************************************/
#define PIN_FLD_MONITOR_TYPE_PAYMNT_RESP        "PR_CE"
#define PIN_FLD_MONITOR_TYPE_HIERARCHY          "H_CE"
#define PIN_FLD_MONITOR_TYPE_SUBSCRIPTION          "SUB_CE"

#define GROUP_SHARING_MONITOR_POID_TYPE         "/group/sharing/monitor"
#define SHARING_GROUP_MONITOR_PROGRAM_STR       "Sharing Monitor"
#define SHARING_GROUP_MONITOR_TYPE_STR          "Sharing Monitor Group"

#define PIN_OBJ_TYPE_MONITOR_GROUP_CREATE       \
                        "/event/group/sharing/monitor/create"
#define PIN_OBJ_TYPE_MONITOR_GROUP_MODIFY       \
                        "/event/group/sharing/monitor/modify"
#define PIN_OBJ_TYPE_MONITOR_GROUP_DELETE       \
                        "/event/group/sharing/monitor/delete"
#define PIN_OBJ_TYPE_MONITOR_UPDATE \
                        "/event/billing/monitor/update"

#define PIN_EVENT_DESCR_MONITOR_GROUP_CREATE       \
			"Create Monitor Sharing Group"
#define PIN_EVENT_DESCR_MONITOR_GROUP_MODIFY       \
			"Modify Monitor Sharing Group"                       
#define PIN_EVENT_DESCR_MONITOR_GROUP_DELETE       \
			"Delete Monitor Sharing Group"

/*******************************************************************
 * CR61, 1033, 1016 and 1035/36 definitions
 *******************************************************************/

#define PIN_OBJ_TYPE_EVENT_LC_UPDATE "/event/billing/lcupdate"
#define PIN_EVENT_DESCR_LC_UPDATE   "Line Counter Update"

#define PIN_OBJ_TYPE_EVENT_CDC_UPDATE "/event/billing/cdc_update"
#define PIN_EVENT_DESCR_CDC_UPDATE   "CDC Counter Update"

#define PIN_OBJ_TYPE_EVENT_CDCD_UPDATE "/event/billing/cdcd_update"
#define PIN_EVENT_DESCR_CDCD_UPDATE   "CDCD Counter Update"

#define PIN_OBJ_TYPE_EVENT_MFUC_UPDATE "/event/billing/mfuc_update"
#define PIN_EVENT_DESCR_MFUC_UPDATE   "MFUC Counter Update"

/*******************************************************************
* Best Pricing definitions
*******************************************************************/
#define PIN_OBJ_TYPE_EVENT_BEST_PRICING "/event/billing/best_pricing"
#define PIN_EVENT_DESCR_BEST_PRICING "Best Pricing Event"
#define PIN_EVENT_BEST_PRICING_PROGRAM_STR "Best Pricing"
#define PIN_EVENT_DESCR_BEST_PRICING_ADJUSTMENT "Best Pricing Adjustment Event"

/*******************************************************************
 * PIN_RERATE_FU_PRODUCTS - Transaction flist for first usage
 * products.
 *******************************************************************/
#define PIN_RERATE_FU_PRODUCTS "PIN_RERATE_FU_PRODUCTS"

/*******************************************************************
 * PIN_FLD_OFFERING_FLAGS - Used by the GET_OFFERINGS OPCODE
 *******************************************************************/
#define PIN_SUBS_FLG_OFFERING_STATUS_ACTIVE             0x1
#define PIN_SUBS_FLG_OFFERING_STATUS_INACTIVE           0x2
#define PIN_SUBS_FLG_OFFERING_STATUS_CLOSED             0x4

/**********************************************************************
* NOTE: These flags will be deprecated after the new Caching
* Mechanism is implemented
 *******************************************************************/

#define PIN_SUBS_FLG_OFFERING_VALID_CYCLE               0x8
#define PIN_SUBS_FLG_OFFERING_VALID_PURCHASE            0x10
#define PIN_SUBS_FLG_OFFERING_VALID_USAGE               0x20
#define PIN_SUBS_FLG_OFFERING_INCLUDE_ACCT              0x40
#define PIN_SUBS_FLG_OFFERING_INCLUDE_SUBS              0x80
#define PIN_SUBS_FLG_BASE_PRODUCTS_ONLY                 0x100
#define PIN_SUBS_FLG_OVERRIDE_PRODUCTS_ONLY		0x200

/**********************************************************************
 * These are the new flags used by GET_PURCHASED_OFFERINGS
 * Opcode.
 **********************************************************************/
#define PIN_SUBS_FLG_OFFERING_VALIDITY_CYCLE		0x1
#define PIN_SUBS_FLG_OFFERING_VALIDITY_PURCHASE		0x2
#define PIN_SUBS_FLG_OFFERING_VALIDITY_USAGE		0x4

#define PIN_SUBS_FLG_ACCT_LEVEL_ONLY			0x1
#define PIN_SUBS_FLG_OVERRIDE_PRODS_ONLY		0x2

#define PIN_SUBS_FLG_INCLUDE_ALL_ELIGIBLE_PRODS		0x1
#define PIN_SUBS_FLG_INCLUDE_ALL_ELIGIBLE_DISCS		0x2


/*******************************************************************
 *Product/Discount  Flags for First usage cases, till 16 th bit of 
 * pin_fld_flags are defined, so iam using 18 th bit for this.
 * The other product related flags defined pin_bill.h 
 *******************************************************************/

#define PIN_SUBS_FLG_FIRST_USAGE             0x020000

/*******************************************************************
 * Validity Periods First usage defination
 *******************************************************************/

#define FIRST_USAGE_SET	-1

#define PIN_SUBS_VAL_OFFSET_ONE_CYCLE 1
#define PIN_SUBS_VAL_OFFSET_TWO_CYCLES 2

/*******************************************************************
 * Best Pricing Flag
 *******************************************************************/
#define PIN_SUBS_FLG_BEST_PRICING	0x1000000

/*******************************************************************
 * PIN_FLD_RERATE_REASON Definitions.
 * Portal Reserved Values: 100-120
 *******************************************************************/
/* Portal Reserved Values */
#define PIN_RERATE_REASON_MIN_RESERVED_VALUE            100
#define PIN_RERATE_REASON_MAX_RESERVED_VALUE            120

#define PIN_RERATE_REASON_BACKDATE_RESOURCE_GRANT       100
#define PIN_RERATE_REASON_BACKDATE_ERA_CREATE           101
#define PIN_RERATE_REASON_BACKDATE_ERA_MODIFY           102
#define PIN_RERATE_REASON_BACKDATE_DISC_CANCEL          103
#define PIN_RERATE_REASON_BACKDATE_PROD_CANCEL          104
#define PIN_RERATE_REASON_BACKDATE_DISC_PURCHASE        105
#define PIN_RERATE_REASON_BACKDATE_PROD_PURCHASE        106
#define PIN_RERATE_REASON_BACKDATE_DISC_STATUS_SET      107
#define PIN_RERATE_REASON_BACKDATE_PROD_STATUS_SET      108
#define PIN_RERATE_REASON_RATE_CHANGE                   109
#define PIN_RERATE_REASON_ROLLOVER_CORRECTION           110
#define PIN_RERATE_REASON_MONITOR_UPDATE                111
/* End PIN_FLD_RERATE_REASON Definitions */

/****************************************************************
* Error Message String Definition for Backdated Validation Failures
* These messages are used by Customer Center to display the 
* error messages that are being sent by server instead of a generic error 
* message.
*******************************************************************/
#define PIN_ERR_BACKDATE_BEFORE_ACCOUNT_EFFECTIVE_DATE    85
#define PIN_ERR_BACKDATE_BEFORE_GL_POSTING_DATE           86
#define PIN_ERR_BACKDATE_BEFORE_SERVICE_EFFECTIVE_DATE    87
#define PIN_ERR_BACKDATE_BEFORE_OFFERING_EFFECTIVE_DATE   88
#define PIN_ERR_BACKDATE_FEES_ALREADY_APPLIED             89
#define PIN_ERR_BACKDATE_BEFORE_STATUS_CHANGE             90 
#define PIN_ERR_BACKDATE_BEFORE_PURCHASE_START            91 
#define PIN_ERR_DISC_AMT_AND_PERCENT			  123 

/****************************************************************
* Definitions for PCM_OP_SUBSCRIPTION_SERVICE_BALGRP_TANSFER
*******************************************************************/
#define PIN_OBJ_TYPE_EVENT_SERVICE_BALGRP_TRANSFER_START \
	"/event/notification/service_balgrp_transfer/start"
#define PIN_OBJ_TYPE_EVENT_SERVICE_BALGRP_TRANSFER_DATA \
	"/event/notification/service_balgrp_transfer/data"
#define PIN_OBJ_TYPE_EVENT_SERVICE_BALGRP_TRANSFER_END \
	"/event/notification/service_balgrp_transfer/end"
#define PIN_OBJ_TYPE_EVENT_AUDIT_SERVICE_BALGRP_TRANSFER  \
	"/event/audit/service_balgrp_transfer"

#endif	/*_PIN_SUBSCRIPTION_H*/

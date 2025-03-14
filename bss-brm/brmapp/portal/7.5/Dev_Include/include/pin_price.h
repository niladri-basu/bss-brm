/*******************************************************************
 *
 *  @(#)$Id: pin_price.h /cgbubrm_7.5.0.rwsmod/2 2014/06/04 03:11:53 tthippes Exp $
 *
 *	
* Copyright (c) 1996, 2014, Oracle and/or its affiliates. All rights reserved.
 *	
 *	This material is the confidential property of Oracle Corporation or its
 *	licensors and may be used, reproduced, stored or transmitted only in
 *	accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef _PIN_PRICE_H
#define	_PIN_PRICE_H

/*******************************************************************
 * Pricelist FM Definitions.
 *******************************************************************/

/*******************************************************************
 * Object Name Strings
 *******************************************************************/
#define	PIN_OBJ_NAME_EVENT_PRICE		"Pricelist Event Log"
#define	PIN_OBJ_NAME_PRODUCT			"PIN Product Object"
#define	PIN_OBJ_NAME_DEAL			"PIN Deal Object"
#define	PIN_OBJ_NAME_BEST_PRICING		"PIN Best Pricing Object"
#define	PIN_OBJ_NAME_RATE			"PIN Rate Object"
#define	PIN_OBJ_NAME_PLAN			"PIN Plan Object"
#define	PIN_OBJ_NAME_RATE_PLAN			"PIN Rate_plan Object"
#define	PIN_OBJ_NAME_RATE_PLAN_SELECTOR		"PIN Rate_plan_selector Object"
#define	PIN_OBJ_NAME_DISCOUNT			"PIN Discount Object"
#define	PIN_OBJ_NAME_SPONSORSHIP		"PIN Sponsorship Object"
#define	PIN_OBJ_NAME_ROLLOVER			"PIN Rollver Object"

#define PIN_OBJ_NAME_PRODUCT_CREATE                     "PIN Product Object Create"
#define PIN_OBJ_NAME_PRODUCT_DELETE                     "PIN Product Object Delete"
#define PIN_OBJ_NAME_PRODUCT_UPDATE                     "PIN Product Object Update"

#define PIN_OBJ_NAME_PRODUCT_COMPLETE                   "PIN Product Object Complete"
#define PIN_OBJ_NAME_PRODUCT_COMPLETE_ABORT             "PIN Product Object Complete Aborted"

/*******************************************************************
 * Object Type Strings
 *******************************************************************/
#define	PIN_OBJ_AUDIT_PRICE			"/event/audit/price"

/*******************************************************************
 * Object Type Strings
 *******************************************************************/
#define	PIN_OBJ_TYPE_DEAL			"/deal"
#define	PIN_OBJ_TYPE_BEST_PRICING		"/best_pricing"
#define	PIN_OBJ_TYPE_PRODUCT			"/product"
#define	PIN_OBJ_TYPE_RATE			"/rate"
#define	PIN_OBJ_TYPE_RATE_PLAN			"/rate_plan"
#define	PIN_OBJ_TYPE_RATE_PLAN_SELECTOR		"/rate_plan_selector"
#define	PIN_OBJ_TYPE_ACCOUNT			"/account"
#define	PIN_OBJ_TYPE_PLAN			"/plan"
#define	PIN_OBJ_TYPE_PLAN_LIST			"/group/plan_list"
#define	PIN_OBJ_TYPE_DISCOUNT			"/discount"
#define	PIN_OBJ_TYPE_SPONSORSHIP		"/sponsorship"
#define	PIN_OBJ_TYPE_ROLLOVER			"/rollover"
#define PIN_OBJ_TYPE_DEPENDENCY		"/dependency"
#define PIN_OBJ_TYPE_TRANSITION		"/transition"

#define	PIN_OBJ_TYPE_EVENT_PRICE_DEAL		"/event/price/deal"
#define	PIN_OBJ_TYPE_EVENT_PRICE_BEST_PRICING	"/event/price/best_pricing"
#define	PIN_OBJ_TYPE_EVENT_PRICE_PRODUCT	"/event/price/product"
#define	PIN_OBJ_TYPE_EVENT_PRICE_RATE		"/event/price/rate"
#define	PIN_OBJ_TYPE_EVENT_PRICE_FOLD		"/event/price/fold"
#define	PIN_OBJ_TYPE_EVENT_PRICE_DISCOUNT	"/event/price/discount"
#define	PIN_OBJ_TYPE_EVENT_PRICE_ROLLOVER	"/event/price/rollover"
#define	PIN_OBJ_TYPE_EVENT_PRICE_SPONSORSHIP	"/event/price/sponsorship"

#define PIN_OBJ_TYPE_PRODUCT_CREATE                     "/product_create"
#define PIN_OBJ_TYPE_PRODUCT_DELETE                     "/product_delete"
#define PIN_OBJ_TYPE_PRODUCT_UPDATE                     "/product_update"

#define PIN_OBJ_TYPE_PRODUCT_COMPLETE                   "/product_complete"
#define PIN_OBJ_TYPE_PRODUCT_COMPLETE_ABORT             "/product_complete_abort"

#define PIN_OBJ_TYPE_DISCOUNT_CREATE                     "/discount_create"
#define PIN_OBJ_TYPE_DISCOUNT_UPDATE                     "/discount_update"
#define PIN_OBJ_TYPE_DISCOUNT_DELETE                     "/discount_delete"

#define PIN_OBJ_TYPE_DISCOUNT_COMPLETE                   "/discount_complete"
#define PIN_OBJ_TYPE_DISCOUNT_COMPLETE_ABORT             "/discount_complete_abort"

/*******************************************************************
 * Price Event Type Strings
 *******************************************************************/

#define PIN_PRICE_EVENT_BATCH_DISCOUNT          "/event/delayed"

/*******************************************************************
 * Recid's for Old and New Data in an Event Log 
 *******************************************************************/
#define	PIN_ELEMID_OLD				0
#define	PIN_ELEMID_NEW				1

/*******************************************************************
 * Net result of a field validation operation.
 *******************************************************************/
#define	PIN_PRICE_VERIFY_PASSED			PIN_BOOLEAN_TRUE
#define	PIN_PRICE_VERIFY_FAILED			PIN_BOOLEAN_FALSE

/*******************************************************************
 * Returning code for validation error.
 *******************************************************************/
#define	PIN_PRICE_VALIDATION_ERROR		-1

 /*******************************************************************
 * Plan customization flags used by the client tools to force on
 * demand billing.
 *******************************************************************/
#define PIN_PLAN_FLG_BILL_ON_DEMAND		0x0100000

/*******************************************************************
 * Deal customization flags used by the client tools to allow or
 * prohibit customization.
 *******************************************************************/
#define PIN_DEAL_FLG_FORCE_CUSTOMIZATION	0x0100000
#define PIN_DEAL_FLG_PROHIBIT_CUSTOMIZATION	0x0200000       
#define PIN_DEAL_FLG_BILL_ON_DEMAND		0x0400000       
#define PIN_DEAL_FLG_GRANT_RESOURCES_AS_GROUP 	0x0800000

/*******************************************************************
 * Event Description Strings
 *******************************************************************/
#define PIN_EVENT_DESCR_PRICE_CREATE_DEAL	"Creating: Deal"
#define PIN_EVENT_DESCR_PRICE_CREATE_BEST_PRICING	"Creating: Best Pricing"
#define PIN_EVENT_DESCR_PRICE_CREATE_PRODUCT	"Creating: Product"
#define PIN_EVENT_DESCR_PRICE_CREATE_RATE	"Creating: Rate"
#define PIN_EVENT_DESCR_PRICE_CREATE_FOLD	"Creating: Fold"
#define PIN_EVENT_DESCR_PRICE_CREATE_PLAN	"Creating: Plan"
#define PIN_EVENT_DESCR_PRICE_CREATE_RATE_PLAN	"Creating: Rate_plan"
#define PIN_EVENT_DESCR_PRICE_CREATE_RATE_PLAN_SELECTOR	"Creating: Rate_plan_selector"
#define PIN_EVENT_DESCR_PRICE_CREATE_DISCOUNT	"Creating: Discount"
#define PIN_EVENT_DESCR_PRICE_CREATE_SPONSORSHIP	"Creating: Sponsorship"
#define PIN_EVENT_DESCR_PRICE_CREATE_ROLLOVER	"Creating: Rollover"

#define PIN_EVENT_DESCR_PRICE_DELETE_DEAL	"Deleting: Deal"
#define PIN_EVENT_DESCR_PRICE_DELETE_BEST_PRICING	"Deleting: Best Pricing"
#define PIN_EVENT_DESCR_PRICE_DELETE_PRODUCT	"Deleting: Product"
#define PIN_EVENT_DESCR_PRICE_DELETE_RATE	"Deleting: Rate"
#define PIN_EVENT_DESCR_PRICE_DELETE_FOLD	"Deleting: Fold"
#define PIN_EVENT_DESCR_PRICE_DELETE_PLAN	"Deleting: Plan"
#define PIN_EVENT_DESCR_PRICE_DELETE_RATE_PLAN	"Deleting: Rate_plan"
#define PIN_EVENT_DESCR_PRICE_DELETE_RATE_PLAN_SELECTOR	"Deleting: Rate_plan_selector"
#define PIN_EVENT_DESCR_PRICE_DELETE_DISCOUNT	"Deleting: Discount"
#define PIN_EVENT_DESCR_PRICE_DELETE_SPONSORSHIP	"Deleting: Sponsorship"
#define PIN_EVENT_DESCR_PRICE_DELETE_ROLLOVER	"Deleting: Rollover"

#define PIN_EVENT_DESCR_PRICE_UPDATE_DEAL	"Updating: Deal"
#define PIN_EVENT_DESCR_PRICE_UPDATE_BEST_PRICING	"Updating: Best Pricing"
#define PIN_EVENT_DESCR_PRICE_UPDATE_PRODUCT	"Updating: Product"
#define PIN_EVENT_DESCR_PRICE_UPDATE_RATE	"Updating: Rate"
#define PIN_EVENT_DESCR_PRICE_UPDATE_FOLD	"Updating: Fold"
#define PIN_EVENT_DESCR_PRICE_UPDATE_PLAN	"Updating: Plan"
#define PIN_EVENT_DESCR_PRICE_UPDATE_RATE_PLAN	"Updating: Rate_plan"
#define PIN_EVENT_DESCR_PRICE_UPDATE_RATE_PLAN_SELECTOR	"Updating: Rate_plan_selector"
#define PIN_EVENT_DESCR_PRICE_UPDATE_DISCOUNT	"Updating: Discount"
#define PIN_EVENT_DESCR_PRICE_UPDATE_SPONSORSHIP	"Updating: Sponsorship"
#define PIN_EVENT_DESCR_PRICE_UPDATE_ROLLOVER	"Updating: Rollover"

#define PIN_EVENT_DESCR_PRICE_CREATE_PRODUCT_COMPLETE	"Creating: Product Completed"
#define PIN_EVENT_DESCR_PRICE_DELETE_PRODUCT_COMPLETE   "Deleting: Product Completed"
#define PIN_EVENT_DESCR_PRICE_UPDATE_PRODUCT_COMPLETE	"Updating: Product Completed"

#define PIN_EVENT_DESCR_PRICE_CREATE_PRODUCT_COMPLETE_ABORT	"Creating: Product Complete Aborted"
#define PIN_EVENT_DESCR_PRICE_DELETE_PRODUCT_COMPLETE_ABORT  	"Deleting: Product Complete Aborted"
#define PIN_EVENT_DESCR_PRICE_UPDATE_PRODUCT_COMPLETE_ABORT	"Updating: Product Complete Aborted"

/*******************************************************************
 * Status flag for product event usage map 
 * These flags are for events other than cycle_forward and cycle_arrear
 * The default behaviour(when flag is null or set to 0) is to rate product 
 * with status cancelled, not to rate product with status inactive
 *******************************************************************/
#define PIN_PRICE_RATE_INACTIVE			0x01
#define PIN_PRICE_NOT_RATE_CANCELLED	0x02

/*******************************************************************
 * Enum to hold various price fm failure codes
 *******************************************************************/

typedef enum pin_price_err {
	PIN_PRICE_ERR_NONE				= 0,
	PIN_PRICE_ERR_DEAL_UNKNOWN_PRODNAME		= 101,
	PIN_PRICE_ERR_PLAN_UNKNOWN_ACCTDEALNAME		= 102,
	PIN_PRICE_ERR_PLAN_UNKNOWN_SRVCDEALNAME		= 103,
	PIN_PRICE_ERR_NULL_DEALNAME			= 104,
	PIN_PRICE_ERR_INVALID_DEAL_START_END_T		= 105,
	PIN_PRICE_ERR_DEAL_NO_PRODUCTS			= 106,
	PIN_PRICE_ERR_NULL_DEALPRODNAME			= 107,
	PIN_PRICE_ERR_INVALID_PURCHASE_DISCOUNT		= 108,
	PIN_PRICE_ERR_INVALID_CYCLE_DISCOUNT		= 109,
	PIN_PRICE_ERR_INVALID_USAGE_DISCOUNT		= 110,
	PIN_PRICE_ERR_INVALID_PURCH_START_END_T		= 111,
	PIN_PRICE_ERR_INVALID_PURCH_CYCLES		= 112,
	PIN_PRICE_ERR_INVALID_CYCLE_START_END_T		= 113,
	PIN_PRICE_ERR_INVALID_CYCLE_PURCH_START_END_T	= 114,
	PIN_PRICE_ERR_INVALID_CYCLE_CYCLES		= 115,
	PIN_PRICE_ERR_INVALID_USAGE_START_END_T		= 116,
	PIN_PRICE_ERR_INVALID_USAGE_PURCH_START_END_T	= 117,
	PIN_PRICE_ERR_INVALID_USAGE_CYCLES		= 118,
	PIN_PRICE_ERR_INVALID_DEAL_QUANTITY_RANGE	= 119,
	PIN_PRICE_ERR_INVALID_DEAL_QUANTITY_PARTIAL	= 120,
	PIN_PRICE_ERR_INVALID_DEAL_PROD_START_END_T	= 121,
	PIN_PRICE_ERR_INVALID_DEALPERM			= 122,
	PIN_PRICE_ERR_DEAL_INCOMPAT_PRODPERM		= 123,
	PIN_PRICE_ERR_DEAL_INCOMPAT_PLANPERM		= 124,
	PIN_PRICE_ERR_DEAL_INCOMPAT_PLANSRVCPERM	= 125,
	PIN_PRICE_ERR_DEAL_DEPENDS_PLAN			= 126,
	PIN_PRICE_ERR_DEAL_DEPENDS_PLANSRVC		= 127,
	PIN_PRICE_ERR_PROD_DEPENDS_DEAL			= 128,
	PIN_PRICE_ERR_PROD_OWNED_BY_ACCT		= 129,
	PIN_PRICE_ERR_NULL_PRODNAME			= 130,
	PIN_PRICE_ERR_INVALID_PROD_START_END_T		= 131,
	PIN_PRICE_ERR_INVALID_PROD_MINMAX		= 132,
	PIN_PRICE_ERR_PROD_PERM_PROV_DISALLOWED		= 133,
	PIN_PRICE_ERR_PROV_INCOMPAT_PERM		= 134,
	PIN_PRICE_ERR_INVALID_PROV_TAG			= 135,
	PIN_PRICE_ERR_INVALID_PROD_PARTIAL		= 136,
	PIN_PRICE_ERR_INVALID_PROD_QUANTITY_PARTIAL	= 137,
	PIN_PRICE_ERR_INVALID_PROD_QUANTITY_RANGE	= 138,
	PIN_PRICE_ERR_INVALID_PRODPERM			= 139,
	PIN_PRICE_ERR_PROD_INCOMPAT_DEALPERM		= 140,
	PIN_PRICE_ERR_INVALID_PROD_DEAL_START_END_T	= 141,
	PIN_PRICE_ERR_NULL_RATENAME			= 142,
	PIN_PRICE_ERR_EXPECTED_ITEM_PURCHASE		= 143,
	PIN_PRICE_ERR_INVALID_RATE_START_END_T		= 144,
	PIN_PRICE_ERR_INVALID_RATE_REL_START_END_T	= 145,
	PIN_PRICE_ERR_INVALID_RATE_MINMAX		= 146,
	PIN_PRICE_ERR_NULL_FOLDNAME			= 147,
	PIN_PRICE_ERR_INVALID_FOLD_START_END_T		= 148,
	PIN_PRICE_ERR_INVALID_FOLD_REL_START_END_T	= 149,
	PIN_PRICE_ERR_INVALID_FOLD_MINMAX		= 150,
	PIN_PRICE_ERR_INVALID_TAXCODE			= 151,
	PIN_PRICE_ERR_NULL_TAXCODE			= 152,
	PIN_PRICE_ERR_INVALID_ITEM_PROD_RATE		= 153,
	PIN_PRICE_ERR_CYCLE_TOD_NOT_ALLOWED		= 154,
	PIN_PRICE_ERR_INVALID_TOD_START_END_T		= 155,
	PIN_PRICE_ERR_INVALID_RATE_IMPACT_RESOURCE	= 156,
	PIN_PRICE_ERR_RATE_MISMATCHED_CURRENCY		= 157,
	PIN_PRICE_ERR_INVALID_RATE_IMPACT_GLID		= 158,
	PIN_PRICE_ERR_INVALID_FREE_QUANTITY		= 159,
	PIN_PRICE_ERR_INVALID_FOLD_ELEMENT_ID		= 160,
	PIN_PRICE_ERR_INVALID_FOLD_IMPACTS_COUNT	= 161,
	PIN_PRICE_ERR_MULTI_FOLD_FROMS			= 162,
	PIN_PRICE_ERR_MULTI_FOLD_TOS			= 163,
	PIN_PRICE_ERR_INVALID_FOLD_IMPACT_RESOURCE	= 164,
	PIN_PRICE_ERR_INVALID_FOLD_IMPACT_GLID		= 165,
	PIN_PRICE_ERR_INVALID_FOLD_IMPACT_QUANTITY	= 166,
	PIN_PRICE_ERR_MISSING_FOLD_TO_IMPACT		= 167,
	PIN_PRICE_ERR_MISSING_FOLD_CURR_FROM_IMPACT	= 168,
	PIN_PRICE_ERR_MISMATCHED_FOLD_ELEMENT_ID	= 169,
	PIN_PRICE_ERR_NULL_PLANNAME			= 170,
	PIN_PRICE_ERR_PLAN_INCOMPAT_ACCTDEALPERM	= 171,
	PIN_PRICE_ERR_INVALID_LIMIT_BEID		= 172,
	PIN_PRICE_ERR_INVALID_CREDIT_LIMIT		= 173,
	PIN_PRICE_ERR_INVALID_CREDIT_FLOOR		= 174,
	PIN_PRICE_ERR_INVALID_SERVICE			= 175,
	PIN_PRICE_ERR_PLAN_INCOMPAT_SRVCDEALPERM	= 176,
	PIN_PRICE_ERR_INVALID_RATE_CURRENCY		= 177,
	PIN_PRICE_ERR_INVALID_FOLD_CURRENCY		= 178,
	PIN_PRICE_ERR_INVALID_RATE_IMPACTS_COUNT	= 179,
	PIN_PRICE_ERR_RATE_MISMATCHED_CURRENCY_IMPACT	= 180,
	PIN_PRICE_ERR_FOLD_MISMATCHED_CURRENCY_IMPACT	= 181,
	PIN_PRICE_ERR_FOLD_MISMATCHED_CURRENCY		= 182,
	PIN_PRICE_ERR_PLAN_LIST_UNKNOWN_PLANNAME	= 183,
	PIN_PRICE_ERR_INVALID_RATE_IMPACT_IMPCATEGORY   = 184,
	PIN_PRICE_ERR_PLAN_DEPENDS_PLAN_LIST		= 185,
	PIN_PRICE_ERR_INVALID_ZONEMAP			= 186,
	PIN_PRICE_ERR_INVALID_PRIORITY			= 187,
	PIN_PRICE_ERR_INVALID_EVENT_TYPE		= 188,
	PIN_PRICE_ERR_EVENT_TYPE_DUPLICATED		= 189,
	PIN_PRICE_ERR_EVENT_TYPE_NOT_FOUND		= 190,
	PIN_PRICE_ERR_INVALID_EVENT_TO_RUM_MATCH	= 191,
	PIN_PRICE_ERR_RUM_UNIT_MISMATCH			= 192,
	PIN_PRICE_ERR_RATE_PLAN_NAME_NOT_FOUND		= 193,
	PIN_PRICE_ERR_NULL_RATE_PLAN_NAME		= 194,
	PIN_PRICE_ERR_DUPLICATE_RATE_TIER_NAME		= 195,
	PIN_PRICE_ERR_DUPLICATE_DATE_RANGE_NAME		= 196,
	PIN_PRICE_ERR_DUPLICATE_DAY_RANGE_NAME		= 197,
	PIN_PRICE_ERR_DUPLICATE_TOD_RANGE_NAME		= 198,
	PIN_PRICE_ERR_INVALID_RATE_TIER			= 199,
	PIN_PRICE_ERR_INVALID_DATE_RANGE		= 200,
	PIN_PRICE_ERR_INVALID_DAY_RANGE			= 201,
	PIN_PRICE_ERR_INVALID_TOD_RANGE			= 202,
	PIN_PRICE_ERR_INVALID_RATE_TYPE			= 203,
	PIN_PRICE_ERR_INVALID_QUANTITY_TIER		= 204,
	PIN_PRICE_ERR_INVALID_RATE_QUANTITY_TIER_COUNT	= 205,
	PIN_PRICE_ERR_OVERLAPPING_TOD_RANGE		= 206,
	PIN_PRICE_ERR_RATE_PLAN_AND_SELECTOR_DEFINED	= 207,
	PIN_PRICE_ERR_INVALID_RATE_PLAN_SELECTOR	= 208,
	PIN_PRICE_ERR_INVALID_PRORATION_BIT		= 209,
	PIN_PRICE_ERR_INVALID_USAGEMAP			= 210,
	PIN_PRICE_ERR_UNDEFINED_ERROR			= 211,
	PIN_PRICE_ERR_DUPLICATE_PRODNAME		= 212,
	PIN_PRICE_ERR_DUPLICATE_DEALNAME		= 213,
	PIN_PRICE_ERR_DUPLICATE_PLANNAME		= 214,
	PIN_PRICE_ERR_DUPLICATE_PLANLISTNAME		= 215,
	PIN_PRICE_ERR_DUPLICATE_RATE_PLAN		= 216,
	PIN_PRICE_ERR_DUPLICATE_RATE_PLAN_SELECTOR	= 217,
	PIN_PRICE_ERR_INVALID_USAGEMAP_FLAG		= 218,
	PIN_PRICE_ERR_INVALID_THRESHOLD			= 219,
	PIN_PRICE_ERR_NULL_RATE_PLAN_SELECTOR_NAME	= 220,
	PIN_PRICE_ERR_NULL_PLANLISTNAME			= 221,
	PIN_PRICE_ERR_RATE_UNDEFINED			= 222,
	PIN_PRICE_ERR_NULL_DISCNAME			= 223,
	PIN_PRICE_ERR_DUPLICATE_DISCNAME		= 224,
	PIN_PRICE_ERR_DEAL_UNKNOWN_DISCNAME		= 225,
	PIN_PRICE_ERR_DISC_DEPENDS_DEAL			= 226,
	PIN_PRICE_ERR_DISC_OWNED_BY_ACCT		= 227,
	PIN_PRICE_ERR_INVALID_DISC_START_END_T		= 228,
	PIN_PRICE_ERR_INVALID_DISC_MINMAX		= 229,
	PIN_PRICE_ERR_INVALID_DISCPERM			= 230,
	PIN_PRICE_ERR_DISC_INCOMPAT_DEALPERM		= 231,
	PIN_PRICE_ERR_INVALID_DEAL_DISC_START_END_T	= 232,
	PIN_PRICE_ERR_INVALID_DISC_PURCH_CYCLES		= 233,
	PIN_PRICE_ERR_INVALID_DISC_CYCLE_CYCLES		= 234,
	PIN_PRICE_ERR_INVALID_DISC_CYCLE_PURCH_START_END_T	= 235,
	PIN_PRICE_ERR_INVALID_DISC_USAGE_CYCLES		= 236,
	PIN_PRICE_ERR_INVALID_DISC_USAGE_PURCH_START_END_T	= 237,
	PIN_PRICE_ERR_DEAL_INCOMPAT_DISCPERM		= 238,
	PIN_PRICE_ERR_NULL_DEALDISCNAME			= 239,
	PIN_PRICE_ERR_INVALID_DISC_DEAL_START_END_T	= 240,
	PIN_PRICE_ERR_INVALID_BALINFO_LIMIT_BEID	= 241,
	PIN_PRICE_ERR_PLAN_INVALID_BAL_INDEX		= 242,
	PIN_PRICE_ERR_PLAN_MISMATCHED_BAL_INDEX		= 243,
	PIN_PRICE_ERR_PLAN_INVALID_BAL_INFO_ELEM	= 244,
	PIN_PRICE_ERR_NULL_SPONSNAME			= 245,
	PIN_PRICE_ERR_DUPLICATE_SPONSNAME		= 246,
	PIN_PRICE_ERR_INVALID_SPONS_NODE		= 247,
	PIN_PRICE_ERR_SPONS_MISSING_EVENT		= 248,
	PIN_PRICE_ERR_SPONS_MISSING_MODEL		= 249,
	PIN_PRICE_ERR_NULL_RUM_NAME                  = 250,
	PIN_PRICE_ERR_DUPLICATE_RUM_NAME             = 251,
	PIN_PRICE_ERR_DUPLICATE_RATEPLAN_NAME        = 252,
	PIN_PRICE_ERR_NULL_RUM_LIST                  = 253,
	PIN_PRICE_ERR_NULL_ROLLOVER_NAME		= 254,
	PIN_PRICE_ERR_DUPLICATE_ROLLOVER		= 255,
	PIN_PRICE_ERR_INVALID_ROLLOVER_DATERANGETYPE	= 256,
	PIN_PRICE_ERR_INVALID_ROLLOVER_RELSTARTUNIT	= 257,
	PIN_PRICE_ERR_INVALID_ROLLOVER_RELENDUNIT	= 258,
	PIN_PRICE_ERR_INVALID_ROLLOVER_RESOURCEID	= 259,
	PIN_PRICE_ERR_MISSING_ROLLOVER_RESOURCEID	= 260,
	PIN_PRICE_ERR_INVALID_ROLLOVER_PRORATEFIRST	= 261,
	PIN_PRICE_ERR_INVALID_ROLLOVER_PRORATELAST	= 262,
	PIN_PRICE_ERR_INVALID_ROLLOVER_STARTEND		= 263,
	PIN_PRICE_ERR_INVALID_ROLLOVER_OFFSET		= 264,
	PIN_PRICE_ERR_INVALID_ROLLOVER_MAXUNITS		= 265,
	PIN_PRICE_ERR_INVALID_ROLLOVER_UNITS		= 266,
	PIN_PRICE_ERR_INVALID_ROLLOVER_COUNT		= 267,
	PIN_PRICE_ERR_INVALID_ROLLOVER_UOM		= 268,
	PIN_PRICE_ERR_ROLLOVER_NOT_FOUND		= 269,
	PIN_PRICE_ERR_INVALID_RATE_IMPACT_STARTEND	= 270,
	PIN_PRICE_ERR_INVALID_RATE_IMPACT_OFFSET	= 271,
	PIN_PRICE_ERR_INVALID_SUBSCRIPTION_INDEX	= 272,
	PIN_PRICE_ERR_INVALID_BAL_INFO_INDEX		= 273,
	PIN_PRICE_ERR_INVALID_DEPENDENCY		= 274,
	PIN_PRICE_ERR_INVALID_TRANSITION		= 275,
	PIN_PRICE_ERR_INVALID_PLAN			= 276,
	PIN_PRICE_ERR_INVALID_DISCOUNT_MODE		= 277,
	PIN_PRICE_ERR_INVALID_DISCOUNT_VALIDITY_INDEX	= 278,
	PIN_PRICE_ERR_INVALID_DISCOUNT_VALIDITY_FLAG	= 279,
	PIN_PRICE_ERR_INVALID_ROLLOVER_IMPACT_GLID	= 280,
	PIN_PRICE_ERR_INVALID_SUBSCRIPTION_GROUP	= 281,
	PIN_PRICE_ERR_MODEL_NAME_AND_SELECTOR_DEFINED	= 282,
	PIN_PRICE_ERR_MODEL_NAME_AND_SELECTOR_NOT_DEFINED = 283,
	PIN_PRICE_ERR_INVALID_PLAN_TYPE			= 284,
	PIN_PRICE_ERR_BEST_PRICING_INVALID_DEAL		= 285,
	PIN_PRICE_ERR_BEST_PRICING_MISSING_ALT_DEAL	= 286,
	PIN_PRICE_ERR_BEST_PRICING_INVALID_ALT_DEAL	= 287,
	PIN_PRICE_ERR_BEST_PRICING_DUP_ALT_DEAL		= 288,
	PIN_PRICE_ERR_BEST_PRICING_INVALID_APPLY_MODE	= 289,
	PIN_PRICE_ERR_BEST_PRICING_MISSING_RESOURCE_ID	= 290,
	PIN_PRICE_ERR_BEST_PRICING_INVALID_RESOURCE_ID	= 291,
	PIN_PRICE_ERR_BEST_PRICING_INVALID_OPERATOR	= 292,
	PIN_PRICE_ERR_PLAN_INVALID_CON_RULES_BEID	= 293,
	PIN_PRICE_ERR_INVALID_CON_RULES			= 294,
	PIN_PRICE_ERR_BEST_PRICING_DUPLICATED		= 295,
	PIN_PRICE_ERR_BEST_PRICING_DEAL_UNEXIST		= 296,
	PIN_PRICE_ERR_BEST_PRICING_MISMATCH_PERMITTED	= 297,
	PIN_PRICE_ERR_DEAL_DEPENDS_BEST_PRICING		= 298,
	PIN_PRICE_ERR_BEST_PRICING_MISSING_COND_AMOUNT	= 299,
	PIN_PRICE_ERR_BEST_PRICING_MISSING_OPERATOR	= 300,
	PIN_PRICE_ERR_INVALID_OFFSET			= 301,
	PIN_PRICE_ERR_INVALID_FIRST_USAGE		= 302,
	PIN_PRICE_ERR_INVALID_UNIT			= 303,
	PIN_PRICE_ERR_INVALID_SEQUENCE_NUM		= 304,
	PIN_PRICE_ERR_INVALID_SYSTEM_PRODUCT		= 305,
	PIN_PRICE_ERR_NULL_PRODCODE			= 306,
	PIN_PRICE_ERR_NULL_DISCCODE			= 307,
	PIN_PRICE_ERR_NULL_DEALDISCCODE			= 308,
	PIN_PRICE_ERR_NULL_DEALPRODCODE			= 309,
	PIN_PRICE_ERR_DEAL_UNKNOWN_PRODCODE		= 310,
	PIN_PRICE_ERR_DEAL_UNKNOWN_DISCCODE		= 311,
	PIN_PRICE_ERR_INVALID_PRORATION_VALUES		= 312,	
	PIN_PRICE_ERR_INVALID_MULTI_RUM_EVENT		= 313,
	PIN_PRICE_ERR_INVALID_PROD_TYPE			= 314,	
	PIN_PRICE_ERR_INVALID_DISC_TYPE			= 315,
	PIN_PRICE_ERR_NULL_RATE_PLAN_SELECTOR_CODE	= 316,
	PIN_PRICE_ERR_NULL_RATE_PLAN_CODE		= 317,
	PIN_PRICE_ERR_NULL_ROLLOVER_CODE		= 318,
	PIN_PRICE_ERR_DUPLICATE_RATEPLAN_CODE           = 319
} pin_price_err_t;

/* Constants for transition rules */
typedef enum dependency_type {
        PIN_RULE_NOT_DEFINED = 0,
        PIN_RULE_PRE_REQUISITE = 1,
        PIN_RULE_MUTUALLY_EXCLUSIVE = 2,
        PIN_RULE_HIERARCHY = 3
} pin_dependency_type_t;

/* Constants for transition types */
typedef enum transition_type {
	PIN_TRANSITION_TYPE_NOT_DEFINED	= 	0,
	PIN_TRANSITION_TYPE_UPGRADE	=	1,
	PIN_TRANSITION_TYPE_DOWNGRADE	=	2,
	PIN_TRANSITION_TYPE_GENERATION_CHANGE = 3
} pin_transition_type_t;

/* Constants for required/optional deals*/
typedef enum deal_option {
	PIN_PRICE_DEAL_REQUIRED	= 	1,
	PIN_PRICE_DEAL_OPTIONAL	= 	0
} pin_deal_option_t;

/* Constants for Apply mode of best pricing */
typedef enum best_pricing_apply_mode {
	PIN_PRICE_BEST_PRICING_MODE_RERATE = 0,
	PIN_PRICE_BEST_PRICING_MODE_ADJUSTMENT = 1
} pin_best_pricing_apply_mode_t;

/* Constants for operator of best pricing */
typedef enum best_pricing_operator {
	PIN_PRICE_BEST_PRICING_OPERATOR_EQ = 0,
	PIN_PRICE_BEST_PRICING_OPERATOR_NE = 1,
	PIN_PRICE_BEST_PRICING_OPERATOR_LT = 2,
	PIN_PRICE_BEST_PRICING_OPERATOR_GT = 3,
	PIN_PRICE_BEST_PRICING_OPERATOR_LTET = 4,
	PIN_PRICE_BEST_PRICING_OPERATOR_GTET = 5
} pin_best_pricing_operator_t;

#endif	/*_PIN_PRICE_H*/

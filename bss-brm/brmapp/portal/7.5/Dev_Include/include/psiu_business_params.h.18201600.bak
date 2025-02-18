/*
* Copyright (c) 1997, 2011, Oracle and/or its affiliates. All rights reserved. 
 * 
 * This material is the confidential property of Oracle Corporation or its 
 * licensors and may be used, reproduced, stored or transmitted only in 
 * accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _PSIU_BUSINESS_PARAMS_H
#define _PSIU_BUSINESS_PARAMS_H

#include <pcm.h>

/* Setup the external declaration stuff correctly */
/* For a static library just use extern!          */

#if defined(__cplusplus)
extern "C" {
#endif

/*******************************************************************
 * Item Object Type Strings
 *******************************************************************/

#define PIN_OBJ_TYPE_BUS_PARAMS   "/config/business_params"


/************************************************************************
 * Names of Parameter Groups
 ***********************************************************************/

#define PSIU_BPARAMS_BILLING_PARAMS  "billing"
#define PSIU_BPARAMS_BILLING_FLOW    "billing_flow"
#define PSIU_BPARAMS_FEATURE_CONTROL "feature_control_information"
#define PSIU_BPARAMS_INVOICING_PARAMS  "Invoicing"
#define PSIU_BPARAMS_SUBSCRIPTION_PARAMS  "subscription"
#define PSIU_BPARAMS_MULTI_BAL		"multi-bal"
#define PSIU_BPARAMS_RATING_PARAMS  	 "rating"

/************************************************************************
* AR Group Name 
************************************************************************/
#define PSIU_BPARAMS_AR_PARAMS  "ar"

/************************************************************************
* Activity Group Name 
************************************************************************/
#define PSIU_BPARAMS_ACT_PARAMS  "activity"

#define PSIU_BPARAMS_ACT_PREPAID_TRAFFIC_LIGHT_ENABLE  	"prepaid_traffic_light_enable"

#define PSIU_BPARAMS_ACT_PREPAID_TRAFFIC_LIGHT_DISABLED   0
#define PSIU_BPARAMS_ACT_PREPAID_TRAFFIC_LIGHT_ENABLED    1

#define PSIU_BPARAMS_ACT_MAX_LOGIN_ATTEMPTS	"max_login_attempts"
/************************************************************************
* Name of parameter for the Invoicing 
************************************************************************/
#define PSIU_BPARAMS_ADST_TAX_HANDLE			"ADST_Tax_Handle"
#define PSIU_BPARAMS_THR_SUB_SUMMARY			"threshold_subords_summary"
#define PSIU_BPARAMS_THR_SUB_DETAIL			"threshold_subords_detail"
#define PSIU_BPARAMS_SUB_AR_ITEM_INCLUDED		"sub_ar_items_included"
#define PSIU_BPARAMS_PROMOTION_DETAIL_DISPLAY   	"promotion_detail_display"
#define PSIU_BPARAMS_ENABLE_INVOICING_INTEGRATION   	"enable_invoicing_integration"
#define PSIU_BPARAMS_INVOICE_STORAGE_TYPE   		"invoice_storage_type"
#define PSIU_BPARAMS_IN_OPERATOR_SIZE			"in_operator_size"
/************************************************************************
 * Names of parameters for the Business Parameter Group 'billing'
 ***********************************************************************/

#define PSIU_BPARAMS_MULTI_BAL_BALANCE_MONITOR	"balance_monitoring"
#define PSIU_BPARAMS_BILLING_GL_REPORTING	"general_ledger_reporting"
#define PSIU_BPARAMS_BILLING_CYCLE_OFFSET       "billing_cycle_offset"
#define PSIU_BPARAMS_BILLING_BILLNOW_APPLY_FEES		"apply_cycle_fees_for_bill_now"
#define PSIU_BPARAMS_BILLING_AUTO_TRIGGERING_LIMIT	"auto_triggering_limit"
#define PSIU_BPARAMS_BILLING_ENABLE_ARA         	"enable_ara"
#define PSIU_BPARAMS_BDOM_BILLING_DIR         		"move_day_forward"
#define PSIU_BPARAMS_REMOVE_SPONSOREE         		"remove_sponsoree"
#define PSIU_BPARAMS_BILLING_FLOW_DISCOUNT    		"billing_flow_discount"
#define PSIU_BPARAMS_BILLING_FLOW_SPONSORSHIP 		"billing_flow_sponsorship"
#define PSIU_BPARAMS_PROD_END_OFFSET_PLAN_TRANSITION    "prod_end_offset_plan_transition"
#define PSIU_BPARAMS_BILLING_GEN_EPSILON 		"generate_journal_epsilon"
#define PSIU_BPARAMS_AR_INCENTIVE_ENABLE  		"payment_incentive_enable"
#define PSIU_BPARAMS_AR_BILL_SEARCH_ENABLE      	"search_bill_amount_enable"
#define PSIU_BPARAMS_AR_PYMT_SUSPENSE_ENABLE    	"payment_suspense_enable"
#define PSIU_BPARAMS_AR_NON_REFUNDABLE_CREDIT_ITEMS    	"nonrefundable_credit_items"
#define PSIU_BPARAMS_VALIDATE_DISC_DEP			"validate_discount_dependency"
#define PSIU_BPARAMS_BILLING_RERATE_ENABLE  		"rerate_during_billing"
#define PSIU_BPARAMS_BILLING_ROLLOVER_CORRECTION_ENABLE "rollover_correction_during_billing"
#define PSIU_BPARAMS_BILLING_SUB_BAL_VALIDITY   	"sub_bal_validity"
#define PSIU_BPARAMS_BILLING_CREATE_TWO_BILLNOW_BILLS   "create_two_bill_now_bills_in_delay"
#define PSIU_BPARAMS_BILLING_SEQUENTIAL_CYCLE_DISCOUNTING	"sequential_cycle_discounting"
#define PSIU_BPARAMS_SORT_VALIDITY_BY				"sort_validity_by"
#define PSIU_BPARAMS_BILLING_CACHE_RESIDENCY_DISTINCTION	"cache_residency_distinction"
#define PSIU_BPARAMS_BILLING_DEFAULT_BUSINESS_PROFILE		"default_business_profile"
#define PSIU_BPARAMS_GET_OFFERINGS_FROM_CACHE_THRESHOLD 	"get_offerings_from_cache_threshold"
#define PSIU_BPARAMS_LOCK_CONCURRENCY 		"lock_concurrency"
#define PSIU_BPARAMS_BILLING_CUSTOM_JOURNAL_UPDATE	"custom_journal_update"
#define PSIU_BPARAMS_BILLING_PERF_ADVANCED_TUNING_SETTINGS	"perf_advanced_tuning_settings"
#define PSIU_BPARAMS_BACKDATING_PAST_GL_POSTED_DATE	"backdating_past_gl_posted_date"

#define PSIU_BPARAMS_BILLING_GEN_CORR_BILL_NO		"generate_corrective_bill_no"
#define PSIU_BPARAMS_BILLING_ENABLE_CORR_INV		"enable_corrective_invoices"
#define PSIU_BPARAMS_BILLING_GEN_CORR_PAID_BILLS	"allow_corrective_paid_bills"
#define PSIU_BPARAMS_BILLING_PYMT_REJECT_DUE_TO_BILL_NO	"reject_payments_for_previous_bill"
#define PSIU_BPARAMS_BILLING_CORR_BILL_THRESHOLD        "corrective_bill_threshold"

#define PSIU_BPARAMS_RATING_ALLOC_DURING_RERATING       "allocate_rerating_adjustments"
#define PSIU_BPARAMS_REFRESH_EXCHANGE_RATE               "refresh_exchange_rate"
/************************************************************************
* Subscription
************************************************************************/
#define PSIU_BPARAMS_BEST_PRICING				"best_pricing"
#define PSIU_BPARAMS_DISCOUNT_BASED_ON_CONTRACT_DAYS_FEATURE	"discount_based_on_contract_days_feature"
#define PSIU_BPARAMS_SUBS_AUTOMATED_MONITOR_SETUP		"automated_monitor_setup"
#define PSIU_BPARAMS_BILL_TIME_DISCOUNT_WHEN			"bill_time_discount_when"
#define PSIU_BPARAMS_ROLLOVER_TRANSFER				"rollover_transfer"
#define PSIU_BPARAMS_ENABLE_PRODUCT_VALIDATION                  "enable_product_validation"
#define PSIU_BPARAMS_MAX_SERVICES_TO_SEARCH                     "max_services_to_search"
#define PSIU_BPARAMS_CANCEL_FULL_DISCOUNT_IMMEDIATE             "cancel_full_discount_immediate"
#define PSIU_BPARAMS_TAILORMADE_PRODUCTS_SEARCH                 "tailormade_products_search"
#define PSIU_BPARAMS_CANCELLED_OFFERINGS_SEARCH                 "cancelled_offerings_search"
#define PSIU_BPARAMS_BACKDATE_NO_RERATE			        "allow_backdate_with_no_rerate"
#define PSIU_BPARAMS_SUBS_DIS_74_BD_VALIDATIONS                 "subs_disable_74_backdated_validations"
/*********************************************************
 * Bus param introduced for Telecom Argentina to associate
 * the refund event to the original purchase event via the
 * SESSION_OBJ of the event.  For more details please refer
 * to bug 10252556.
 *********************************************************/
#define PSIU_BPARAMS_SUBS_ASSOC_REFUND_TO_PURCHASE              "subs_assoc_refund_to_purchase"

/************************************************************************
* Writeoff reversal 
************************************************************************/
#define PSIU_BPARAMS_AR_AUTO_WO_REV_ENABLE  "auto_writeoff_reversal_enable"
#define PSIU_BPARAMS_AR_WRITEOFF_LEVEL  "writeoff_level"
/************************************************************************
 * Names of parameter values for the Business Parameter Group 'billing'
 ***********************************************************************/

#define PSIU_BPARAMS_BILLING_GL_REPORTING_ENABLED 1
#define PSIU_BPARAMS_BILLING_GL_REPORTING_DISABLED 0
#define PSIU_BPARAMS_MULTI_BAL_BALANCE_MONITOR_ENABLED 1
#define PSIU_BPARAMS_MULTI_BAL_BALANCE_MONITOR_DISABLED 0
#define PSIU_BPARAMS_DISCOUNT_FLOW_UNDEFINED 0
#define PSIU_BPARAMS_BILL_PARENT_DISCOUNT    1
#define PSIU_BPARAMS_BILL_MEMBER_DISCOUNT    2
#define PSIU_BPARAMS_SPONSOR_FLOW_UNDEFINED  0
#define PSIU_BPARAMS_BILL_SPONSOR            1
#define PSIU_BPARAMS_BILL_SPONSOREE          2
#define PSIU_BPARAMS_GENERATE_JOURNAL_EPSILON  1
#define PSIU_BPARAMS_AR_INCENTIVE_DISABLED   0
#define PSIU_BPARAMS_AR_INCENTIVE_ENABLED    1
#define PSIU_BPARAMS_AR_BILL_SEARCH_DISABLED	0
#define PSIU_BPARAMS_AR_BILL_SEARCH_ENABLED	1
#define PSIU_BPARAMS_AR_PYMT_SUSPENSE_ENABLED  1
#define PSIU_BPARAMS_AR_PYMT_SUSPENSE_DISABLED 0
#define PSIU_BPARAMS_BILL_RERATE_DISABLED    0
#define PSIU_BPARAMS_BILL_RERATE_ENABLED    1
#define PSIU_BPARAMS_BILL_ROLLOVER_CORRECTION_DISABLED     0
#define PSIU_BPARAMS_BILL_ROLLOVER_CORRECTION_ENABLED     1
#define PSIU_BPARAMS_BILLING_CUSTOM_JOURNAL_UPDATE_ENABLED 1
#define PSIU_BPARAMS_BILLING_CUSTOM_JOURNAL_UPDATE_DISABLED 0

/************************************************************************
* Rerating  Group Name 
************************************************************************/
#define PSIU_BPARAMS_RERATE_PARAMS  "rerate"

#define PSIU_BPARAMS_BILLING_TIME_DISCOUNT_BASED_ON_PERIOD "billing_time_discount_based_on_period"

#define PSIU_BPARAMS_RERATE_BATCH_PIPELINE		"batch_rating_pipeline"
#define PSIU_BPARAMS_RERATE_LINE_MANAGEMENT		"line_management"

#define PSIU_BPARAMS_RERATE_BATCH_PIPELINE_DISABLED    	 0
#define PSIU_BPARAMS_RERATE_BATCH_PIPELINE_ENABLED    	 1

/************************************************************************
* Error Control Messages 
************************************************************************/
#define PSIU_BPARAMS_PARAMETER_OPTIONAL  0
#define PSIU_BPARAMS_PARAMETER_MANDATORY 1

/***********************************************************************
 * API uses to retrieve Business Logic Parameters
 ***********************************************************************/

/*
 *  This function is obsolete.  Please use its "_ex" version instead for 
 *  future purposes. 
 */
extern int32 psiu_bparams_get_int(
        pcm_context_t*  contextp,
        const char*     group_namep,
        const char*     param_namep,
        pin_errbuf_t*   ebufp);

/*
 * Get the specified parameter as an integer value from a "global"
 * configuration object using the specified Infranet connection.
 *
 * Parameters:
 *   contextp    - A connection to Infranet.
 *   group_namep - The name of the group ("billing", "rating", "vse_ipt", etc.)
 *                 to retrieve
 *                 the parameter from.
 *   param_namep - The name of the configuration parameter to retrieve the
 *                 value for.
 *   param_must_exist - A flag to check whether to turn on displaying errors
 *                      or NOT.
 *   ebufp       - If the parameter does not exist or there was a problem with
 *                 the connection then ebufp will contain an error.
 *
 * Returns:
 *   The integer representation of the value associated with the specified
 *   parameter.  If the parameter does not exist or the cannot be converted
 *   to an integer then a value of zero will be returned.
 */
extern int32 psiu_bparams_get_int_ex(
        pcm_context_t*  contextp,
        const char*     group_namep,
        const char*     param_namep,
	int32		param_must_exist,
        pin_errbuf_t*   ebufp);

/*
 *  This function is obsolete.  Please use its "_ex" version instead for 
 *  future purposes. 
 */
extern pin_decimal_t* psiu_bparams_get_decimal(
        pcm_context_t*  contextp,
        const char*     group_namep,
        const char*     param_namep,
        pin_errbuf_t*   ebufp);

/*
 * Get the specified parameter as a decimal value from a "global"
 * configuration object using the specified Infranet connection.
 *
 * Parameters:
 *   contextp    - A connection to Infranet.
 *   group_namep - The name of the group ("billing", "rating", "vse_ipt", etc.)
 *                 to retrieve
 *                 the parameter from.
 *   param_namep - The name of the configuration parameter to retrieve the
 *                 value for.
 *   param_must_exist - A flag to check whether to turn on displaying errors
 *                      or NOT.
 *   ebufp       - If the parameter does not exist or there was a problem with
 *                 the connection then ebufp will contain an error.
 *
 * Returns:
 *   The decimal representation of the value associated with the specified
 *   parameter.  If the parameter does not exist or the cannot be converted
 *   to an decimal value then a null pointer will be returned.
 *
 *  It will be the responsibility of the caller to free the decimal value.
 */
extern pin_decimal_t* psiu_bparams_get_decimal_ex(
        pcm_context_t*  contextp,
        const char*     group_namep,
        const char*     param_namep,
	int32		param_must_exist,
        pin_errbuf_t*   ebufp);

/*
 *  This function is obsolete.  Please use its "_ex" version instead for 
 *  future purposes. 
 */
extern char* psiu_bparams_get_str(
        pcm_context_t*  contextp,
        const char*     group_namep,
        const char*     param_namep,
        char*           bufp,
        int32           buf_size,
        pin_errbuf_t*   ebufp);

/*
 * Get the specified parameter as a character array from a "global"
 * configuration object using the specified Infranet connection.
 *
 * Parameters:
 *   contextp    - A connection to Infranet.
 *   group_namep - The name of the group ("billing", "rating", "vse_ipt", etc.)
 *                 to retrieve
 *                 the parameter from.
 *   param_namep - The name of the configuration parameter to retrieve the
 *                 value for.
 *   bufp        - Pointer to the buffer array to contain the string.
 *   buf_size    - The size of the buffer array (bufp) to contain the string
 *                 representation of the parameter.  The size is in characters
 *                 and includes the null terminator.  If buf_size is 10 then
 *                 bufp points to a buffer that contain a string with a
 *                 maximum of 9 characters.
 *   param_must_exist - A flag to check whether to turn on displaying errors
 *                      or NOT.
 *   ebufp       - If the parameter does not exist or there was a problem with
 *                 the connection then ebufp will contain an error.
 *
 *
 * Returns:
 *   Pointer to the character buffer passed in to contain the string
 *   representation of the value associated with the specified parameter.  If
 *   the parameter does not exist or cannot be converted to a string then an
 *   "empty string" will be returned.
 */
extern char* psiu_bparams_get_str_ex(
        pcm_context_t*  contextp,
        const char*     group_namep,
        const char*     param_namep,
        char*           bufp,
        int32           buf_size,
	int32		param_must_exist,
        pin_errbuf_t*   ebufp);

/*
 * Does the specified parameter exist in the specified billing parameter
 * group?
 *
 * Parameters:
 *   contextp    - A connection to Infranet.
 *   group_namep - The name of the group ("billing", "rating", "vse_ipt", etc.)
 *                 to retrieve
 *                 the parameter from.
 *   param_namep - The name of the configuration parameter to retrieve the
 *                 value for.
 *   ebufp       - If the parameter does not exist or there was a problem with
 *                 the connection then ebufp will contain an error.
 *
 * Returns:
 *   Return true if the parameter exists and return false if it doesn't exist
 *   or an error was encountered.
 */
extern int32 psiu_bparams_does_param_exist(
        pcm_context_t*  contextp,
        const char*     group_namep,
        const char*     param_namep,
        pin_errbuf_t*   ebufp);

extern int32 psiu_bparams_get_sec_from_days_hours(
	char*		str_days_hours,
	pin_errbuf_t*	ebufp);

#if defined(__cplusplus)
}
#endif

#endif /* _PSIU_BUSINESS_PARAMS_H */


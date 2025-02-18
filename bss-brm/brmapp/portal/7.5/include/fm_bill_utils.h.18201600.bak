/*
 *
* Copyright (c) 2003, 2011, Oracle and/or its affiliates. All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef _FM_BILL_UTILS_H
#define _FM_BILL_UTILS_H

/*******************************************************************
"@(#)$Id: fm_bill_utils.h /cgbubrm_main.rwsmod/2 2011/10/04 12:07:13 srewanwa Exp $";
*******************************************************************/

#if defined(__STDC__) || defined(PIN_USE_ANSI_HDRS)
#define PROTO_LIST(list) list
#else
#define PROTO_LIST(list) ()
#endif

#include "pcm.h"
#include "cm_fm.h"		/* for cm_op_info_t   */
#include "cm_cache.h"
#include "fm_utils.h"
#include "pin_cust.h"

#ifdef __cplusplus
#include "Pin.h"
#include "PinContext.h"
#include "PinFlist.h"
#endif /* __cplusplus */

#ifdef __hpux
#include <regex.h>
#endif 

#ifdef WIN32
#include "pin_os_regex.h"
#else
#include <regex.h>
#endif

#ifdef WIN32
#define snprintf _snprintf
#ifdef FM_BILL_UTILS_DLL 
#ifdef __cplusplus
#define VAR_EXTERN extern
#endif
#define EXTERN __declspec(dllexport)
#else
#define EXTERN __declspec(dllimport)
#endif
#else
#define EXTERN extern
#endif


#if !defined(VAR_EXTERN)
#define VAR_EXTERN EXTERN
#endif

/*******************************************************************
 * Define the maximum value of timestamp
 *******************************************************************/
#define PIN_TIMESTAMP_MAXIMUM   2147483647
/*******************************************************************
 * Define the hash key for the exchange rate refresh time, to be used
 * to store in cm hash.
 *******************************************************************/
#define PIN_EXCHANGE_RATE_HASH_KEY "refresh_time"

/*******************************************************************
 * Define the maximum and minumum value for GLID  to skip journal creation 
 * Journal objects are not created for GLIDs, that are in range of 
 * PIN_MIN_GLID_SKIP_JOURNAL <= GLID < PIN_MAX_GLID_SKIP_JOURNAL
 *******************************************************************/
#define PIN_MIN_GLID_SKIP_JOURNAL   1
#define PIN_MAX_GLID_SKIP_JOURNAL   100

/*******************************************************************
 * Define the POID ID0 and config payment object
*******************************************************************/
#define PIN_OBJ_TYPE_PAYMENT_CONFIG             "/config/payment"
#define PIN_OBJ_ID0_PAYMENT_CONFIG              200

#define PIN_APPLY_BAL_BACKOUT_ONLY 	1
#define PIN_APPLY_BAL_ITEM_UPDATE 	2
#define PIN_APPLY_BAL_APPLY_BAL 	4
#define PIN_APPLY_BAL_MONITOR_IMPACTS 	8

#define PIN_OBJ_TYPE_EVENT_RERATE_START "/event/notification/rerating/start"
#define PIN_OBJ_TYPE_EVENT_RERATE_END "/event/notification/rerating/end"

#define PIN_ERR_PURCHASE_FUTURE_DEAL 300
#define  PIN_ERR_PURCHASE_EXPIRED_DEAL 301

/*******************************************************************
 * Entries for Revenue Assurance in bill now ,bill on demand and close bill
 *******************************************************************/
#define PIN_ARA_BILL_NOW 			"Bill-Now"
#define PIN_ARA_BILL_ON_DEMAND			"Bill-ON-DEMAND"
#define PIN_ARA_AUTO_TRIGGER_BILL		"Auto-Trigger"
#define PIN_ARA_VERSION				3 

/*******************************************************************
 * Entries for default credit profile
 *******************************************************************/
#define PIN_CURRENCY_CREDIT_PROFILE             0
#define PIN_LIMIT_CREDIT_PROFILE                1
#define PIN_NONCURRENCY_CREDIT_PROFILE          2

/*******************************************************************
 * Public functions exported from fm_bill_utils.
 *******************************************************************/

/*
 * fm_bill_utils_beid.c
 */

EXTERN void
fm_utils_taxcode_to_glid PROTO_LIST((
                pcm_context_t   *ctxp,
                char            *taxcode,
                u_int           *tax_glip,
                pin_errbuf_t    *ebufp));

/*
 * fm_bill_utils_bill.c
 */

EXTERN void
fm_bill_mb_apply_cycle PROTO_LIST((
	pcm_context_t	*ctxp,
	int32			opcode,
	pin_flist_t		*c_flistp,
	pin_flist_t		**b_flistpp,
	pin_errbuf_t	*ebufp));

EXTERN void
fm_bill_mb_apply_cycle_fees PROTO_LIST((
	pcm_context_t	*ctxp,
	int32			opcode,
	int32			rate_flags,
	pin_flist_t		*c_flistp,
	pin_flist_t		**b_flistpp,
	pin_errbuf_t	*ebufp));

EXTERN void
fm_bill_mb_apply_purchase_fees PROTO_LIST((
	pcm_context_t   *ctxp,
	pin_flist_t     *c_flistp,
	pin_flist_t     **b_flistpp,
	pin_errbuf_t    *ebufp));

EXTERN void
fm_bill_mb_get_ts PROTO_LIST((
	pcm_context_t	*ctxp,
	poid_t			*a_pdp,
	poid_t			*b_pdp,
	time_t			ts_start_t,
	time_t			ts_end_t,
	pin_flist_t		**ts_flistpp,
	pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_create_bill_obj PROTO_LIST((
		pcm_context_t	*ctxp,
		u_int		flags,
		pin_flist_t	*i_flistp,
		pin_flist_t	**nb_flistpp,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_create_item_obj PROTO_LIST((
		pcm_context_t	*ctxp,
		u_int		flags,
		pin_flist_t	*i_flistp,
		pin_flist_t	**ni_flistpp,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_prep_create_service_item PROTO_LIST((
		pcm_context_t	*ctxp,
		pin_flist_t	*item_flistp,
		poid_t		*a_pdp,
		poid_t		*s_pdp,
		poid_t		*bi_pdp,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_bill_create_items PROTO_LIST((
		pcm_context_t	*ctxp,
		int32		flags,
		pin_flist_t	*i_flistp,
		pin_flist_t	**r_flistpp,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_bill_get_sponsorees PROTO_LIST((
		pcm_context_t	*ctxp,
		int32		flags,
		pin_flist_t	*i_flistp,
		pin_flist_t	**r_flistpp,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_bill_get_discount_members PROTO_LIST((
		pcm_context_t	*ctxp,
		int32		flags,
		pin_flist_t	*i_flistp,
		pin_flist_t	**r_flistpp,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_bill_get_group_parents PROTO_LIST((
		pcm_context_t	*ctxp,
		int32		flags,
		char            *group_type,
		pin_flist_t	*i_flistp,
		pin_flist_t	**r_flistpp,
		pin_errbuf_t	*ebufp));


EXTERN void
fm_utils_bill_get_service_billinfo PROTO_LIST((
        pcm_context_t	*ctxp,
        poid_t		*service_obj,
        poid_t		**billinfo_obj,
        pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_bill_get_service_group PROTO_LIST((
        pcm_context_t	*ctxp,
        poid_t		*srv_pdp,
	poid_t		*acc_pdp,
        pin_flist_t	**o_flistpp,
        pin_errbuf_t    *ebufp));

EXTERN void
fm_bill_utils_negate_event_balances PROTO_LIST((
    pin_flist_t *e_flistp,
    pin_errbuf_t *ebufp));

EXTERN void
fm_bill_utils_get_rerated_event_from_list PROTO_LIST((
	poid_t			*re_pdp,
	pin_flist_t		*ae_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp));

EXTERN void
fm_utils_bill_search_in_tt_nodes PROTO_LIST((
		pcm_context_t   *ctxp,
        	int32           flags,
        	pin_flist_t     *i_flistp,
        	pin_flist_t     **o_flistpp,
        	pin_errbuf_t    *ebufp));

EXTERN void
fm_utils_bill_sum_from_tt_nodes PROTO_LIST((
		pcm_context_t   *ctxp,
        	int32           flags,
        	pin_flist_t     *i_flistp,
        	pin_flist_t     **o_flistpp,
        	pin_errbuf_t    *ebufp));

EXTERN int
fm_utils_bill_get_count_log_partitions PROTO_LIST((
		pcm_context_t   *ctxp,
		pin_errbuf_t    *ebufp));

/********************??????????????????
EXTERN void
fm_utils_add_rates_used_array PROTO_LIST((
	pin_flist_t		*a_flistp,
	double			*amount,
	u_int			resource_id,
	pin_errbuf_t		*ebufp));
*********************************************************/
/********************??????????????????
EXTERN pin_flist_t *
fm_utils_get_subtotal_elem PROTO_LIST((
	pin_flist_t		*ru_flistp,
	u_int			resource_id,
	pin_errbuf_t		*ebufp));
*********************************************************/
/********************??????????????????
EXTERN void
fm_utils_init_bill_obj PROTO_LIST((
		pin_flist_t	*c_flistp,
		pin_flist_t	**nb_flistpp,
		pin_errbuf_t	*ebufp));
*********************************************************/
/********************??????????????????
EXTERN void
fm_utils_init_actg_obj PROTO_LIST((
		pin_flist_t	*c_flistp,
		pin_flist_t	**na_flistpp,
		pin_errbuf_t	*ebufp));
*********************************************************/
/********************??????????????????
EXTERN void
fm_utils_init_item_obj PROTO_LIST((
		pin_flist_t	*c_flistp,
		pin_flist_t	**ni_flistpp,
		pin_errbuf_t	*ebufp));
*********************************************************/

/********************??????????????????
EXTERN void
fm_utils_round PROTO_LIST((
		double	  	*amountp,
		int		precision));
*********************************************************/
/*
 * fm_bill_utils_cycle.c
 */
EXTERN time_t
fm_utils_cycle_next_by_nunits(
	time_t          a_time,
	int32           unit,
	int32           freq,
	pin_errbuf_t    *ebufp);

EXTERN void
fm_utils_cycle_apply_offset PROTO_LIST((
	int32		bill_offset,
	int32		offset_unit,
	pin_flist_t	*p_flistp,
	int		dom,
	time_t		*cycle_begp,
	time_t		*cycle_endp,
	pin_errbuf_t	*ebufp));

EXTERN time_t
fm_utils_time_round_to_midnight PROTO_LIST(( 
		time_t  a_time));

EXTERN void
fm_bill_utils_call_disc_dep PROTO_LIST((
	pcm_context_t   *ctxp,
	poid_t          *a_pdp,
	pin_flist_t     *i_flistp,
	pin_flist_t     *dis_flistp,
	pin_flist_t     *plan_flistp,
	pin_flist_t     **ddr_flistpp,
	int32		flags,
	pin_errbuf_t    *ebufp));	

EXTERN int32
fm_bill_utils_perform_disc_dep_validation PROTO_LIST ((
	pcm_context_t   *ctxp,
	poid_t          *a_pdp,
	poid_t          *p_pdp,
	pin_flist_t     *i_flistp,
	pin_flist_t     *di_flistp,
	pin_flist_t     **r_flistpp,
	time_t		eend_t,
	pin_errbuf_t    *ebufp));	

/*
 * fm_bill_utils_init.c
 */

VAR_EXTERN pin_flist_t *fm_utils_init_cfg_beid;
VAR_EXTERN pin_flist_t *fm_utils_init_cfg_glid;
VAR_EXTERN int update_cache4_incflds;
VAR_EXTERN int32 pin_conf_rate_change;

/*----- Global variables to store some of stanzas from CM pin.conf ----*/
VAR_EXTERN int pin_conf_billing_delay;
VAR_EXTERN int pin_conf_apply_folds;
VAR_EXTERN int pin_conf_apply_rollover;
VAR_EXTERN int pin_conf_allow_move_close_acct;
VAR_EXTERN int pin_conf_config_billing_cycle;
VAR_EXTERN int pin_conf_valid_forward_interval;
VAR_EXTERN int pin_conf_valid_backward_interval;
VAR_EXTERN int pin_conf_enforce_scoping;
VAR_EXTERN int pin_conf_bill_sponsorees;
VAR_EXTERN int pin_conf_item_fetch_size;
VAR_EXTERN int pin_conf_subord_fetch_size;
VAR_EXTERN int pin_conf_timestamp_rounding;
VAR_EXTERN int pin_conf_use_number_of_days_in_month;
VAR_EXTERN int pin_conf_has_netflow;
VAR_EXTERN int pin_conf_extended_month_proration;
VAR_EXTERN int pin_conf_cycle_delay_align;
VAR_EXTERN int pin_conf_cycle_delay_use_special_days;
VAR_EXTERN int pin_conf_delay_cycle_fees;
VAR_EXTERN int pin_conf_custom_bill_no;
VAR_EXTERN int pin_conf_purchase_fees_backcharge;
VAR_EXTERN int pin_conf_midnight;
VAR_EXTERN int pin_conf_billnow_apply_fees;
VAR_EXTERN int pin_conf_validate_disc_dependency; 
VAR_EXTERN char *pin_conf_cycle_tax_interval;
VAR_EXTERN int pin_conf_move_bill_day_forward;
VAR_EXTERN int pin_conf_advance_bill_cycle;
VAR_EXTERN char fm_rate_evt_str_for_start_t[];
VAR_EXTERN long pin_conf_max_duration;
VAR_EXTERN int pin_conf_set_status_non_subord;
VAR_EXTERN int pin_conf_reserve_extend_incremental;
VAR_EXTERN int pin_conf_taxation_switch;
VAR_EXTERN int32 pin_conf_to_include_zero_tax;
VAR_EXTERN int32 pin_conf_stop_bill_closed_accounts;
VAR_EXTERN int32 pin_conf_calc_from_cycle_start_t;
VAR_EXTERN int pin_conf_enable_30_day_proration;
VAR_EXTERN pin_flist_t *fm_utils_init_tax_supplier_objects_flistp;
VAR_EXTERN int32 fm_utils_init_tax_supplier_objects_ncount;
VAR_EXTERN int32 fm_utils_default_ts_elemid;
VAR_EXTERN int32 pin_conf_backdated_rate;
VAR_EXTERN int32 pin_conf_attach_item_to_event;
VAR_EXTERN int32 pin_conf_group_children_fetch;
VAR_EXTERN int	 business_param_flow_sponsorship;
VAR_EXTERN int	 business_param_flow_discount;
VAR_EXTERN int	 business_param_auto_triggering_limit;
VAR_EXTERN int32 business_param_enable_ara;
VAR_EXTERN int32 pin_conf_validate_dependencies;
VAR_EXTERN int32 pin_conf_keep_cancelled_products_or_discounts;
VAR_EXTERN int business_param_generate_journal_epsilon;
VAR_EXTERN int business_param_billing_rerate;
VAR_EXTERN int business_param_billing_rollover_correction;
VAR_EXTERN int business_param_billing_create_two_billnow_bills;
VAR_EXTERN int32 bparam_subs_dis_74_bd_validations;
/*********************************************************
 * Bus param introduced for Telecom Argentina to associate
 * the refund event to the original purchase event via the
 * SESSION_OBJ of the event.  For more details please refer
 * to bug 10252556.
 *********************************************************/
VAR_EXTERN int32 bparam_subs_assoc_refund_to_purchase;

VAR_EXTERN int32 pin_conf_group_members_fetch;
VAR_EXTERN int32 pin_conf_event_fetch_size;
VAR_EXTERN int32 pin_conf_open_item_actg_include_prev_total;
VAR_EXTERN int32 general_ledger_flag;
VAR_EXTERN int32 enable_product_level_dependency_validation;
VAR_EXTERN int   is_timesten_used;
VAR_EXTERN int   is_single_row_event;
VAR_EXTERN int32 business_param_tailormade_products_search;
VAR_EXTERN int32 business_param_cancelled_offerings_search;
VAR_EXTERN int32 allow_backdate_with_no_rerate;
VAR_EXTERN int32 bparam_backdating_past_gl_posted_date;

EXTERN void
fm_utils_init_config_glid PROTO_LIST((
		pcm_context_t	*ctxp,
		int64		database,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_init_config_beid PROTO_LIST((
		pcm_context_t	*ctxp,
		int64		database,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_init_config_sequence PROTO_LIST((
		pcm_context_t	*ctxp,
		pin_errbuf_t	*ebufp));

/*
 * fm_bill_utils_balance.c
 */

EXTERN void
fm_utils_apply2_total PROTO_LIST((
        pin_flist_t             *a_flistp,
        pin_flist_t             *i_flistp,
        pin_errbuf_t            *ebufp));


EXTERN void
fm_utils_read_bals PROTO_LIST((
		pcm_context_t   *ctxp,
		poid_t	      	*a_pdp,
		int32		flags,
		pin_flist_t     **b_flistpp,
		pin_errbuf_t    *ebufp));

EXTERN void
fm_utils_apply_multi_bal_impact PROTO_LIST((
		cm_nap_connection_t     *connp,
		u_int32			flags,
		pin_flist_t             *a_flistp,
		pin_errbuf_t            *ebufp));

EXTERN void
fm_utils_add_event_bal_impacts PROTO_LIST((
        pcm_context_t           *ctxp,
        pin_flist_t             *a_flistp,
        pin_decimal_t           *amount,
        int32                   resource_id,
	pin_decimal_t		*amount_original,
	int32			*resource_id_original,
	int32			*impact_typep,
        pin_errbuf_t            *ebufp));

EXTERN void 
fm_utils_update_acct_pending_recv PROTO_LIST((
	pcm_context_t		*ctxp,
	pin_flist_t		*a_flistp,
	pin_errbuf_t		*ebufp));

/*
 * fm_bill_utils_beid.c
 */

EXTERN pin_decimal_t *
fm_utils_round_balance PROTO_LIST((
		pin_decimal_t	*amountp,
		u_int		bal_id));

EXTERN int
fm_utils_get_precision PROTO_LIST((
		u_int		bal_id,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_round_list PROTO_LIST(( 
		u_int		currency,
		double		sum_amount,
		u_int		n_list,
		double		*d_listp,
		pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_beid_name PROTO_LIST((
		int32 		bal_id,
		char		*name_buf,
		int		name_len));

EXTERN void
fm_utils_beid_get_beid_flist PROTO_LIST((
		pin_errbuf_t *	ebufp));
		
EXTERN int32
fm_utils_beid_get_rounding PROTO_LIST((
		u_int32 	bal_id));

EXTERN int32
fm_utils_beid_get_rounding_mode PROTO_LIST((
		u_int32 	bal_id));

EXTERN pin_decimal_t *
fm_utils_beid_get_tolerance_amt_min PROTO_LIST((
		u_int32 	bal_id));

EXTERN pin_decimal_t *
fm_utils_beid_get_tolerance_amt_max PROTO_LIST((
		u_int32 	bal_id));

EXTERN pin_decimal_t *
fm_utils_beid_get_tolerance_percent PROTO_LIST((
		u_int32 	bal_id));

EXTERN char *
fm_utils_beid_get_beid_str_code PROTO_LIST((
		u_int32 	bal_id,
		pin_errbuf_t *	ebufp));

EXTERN pin_decimal_t *
fm_utils_get_tolerance_amount PROTO_LIST((
		pin_decimal_t	*amount,
		u_int32		bal_id,
		pin_errbuf_t	*ebufp));
EXTERN pin_decimal_t *
fm_utils_round_amount PROTO_LIST((
                pin_decimal_t   *amountp,
                u_int           bal_id,
                char            *event_type,
                u_int           processing_stage));

EXTERN int
fm_utils_get_evt_precision PROTO_LIST((
		u_int		bal_id,
                char            *event_type,
                u_int           processing_stage,
		pin_errbuf_t	*ebufp));

EXTERN int32
fm_utils_beid_get_evt_rounding_mode PROTO_LIST((
		u_int32 	bal_id,
		char            *event_type,
                u_int           processing_stage));

EXTERN int32
fm_utils_beid_get_evt_rounding PROTO_LIST((
		u_int32 	bal_id,
		char            *event_type,
                u_int           processing_stage));

EXTERN void
fm_utils_evt_round_list PROTO_LIST(( 
		u_int		currency,
		double		sum_amount,
		u_int		n_list,
		double		*d_listp,
		char            *event_type,
                u_int           processing_stage,
		pin_errbuf_t	*ebufp));
EXTERN int
match_expression  PROTO_LIST ((
        config_beid_rules_t     **rulesentryp,
        u_int                   bal_id,
        char                    *event_type,
        u_int                   processing_stage,
        pin_errbuf_t            *ebufp));

EXTERN int32
fm_bill_utils_get_modes PROTO_LIST((
	int32         resource_id,
	pin_errbuf_t  *ebufp));

EXTERN int32
fm_bill_utils_get_consumption_rule PROTO_LIST((
	int32         resource_id));
/*
 * fm_bill_utils_billing.c
 */

EXTERN void
fm_utils_billing_get_product_rates PROTO_LIST((
	pcm_context_t		*ctxp,
	pin_flist_t		*i_flistp,
	char			*event_type,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp));

EXTERN void
fm_utils_payment_get_config_items PROTO_LIST((
	pcm_context_t	*ctxp,		
	pin_flist_t		*i_flistp,		
	int32			op_type,		
	pin_errbuf_t	*ebufp));

EXTERN pin_flist_t* 
fm_bill_utils_get_payment_cfg_objp PROTO_LIST((
	pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_read_acct PROTO_LIST((
	pcm_context_t	*ctxp,
	int32		flags,
	pin_flist_t	*i_flistp,
	pin_errbuf_t	*ebufp));

EXTERN void
fm_utils_get_account_product PROTO_LIST((
	pcm_context_t	*ctxp,
	poid_t		*p_pdp,
	pin_flist_t	**p_flistpp,
	pin_errbuf_t	*ebufp));

EXTERN u_int32
fm_utils_is_backdating_allowed PROTO_LIST((
	pcm_context_t       *ctxp,
	poid_t              *a_pdp,
	time_t              end_t,
	pin_errbuf_t        *ebufp));

/*
 * Account_Product.Node-location related function definitions.
 */


/*******************************************************************
 * Define the node_location seperator for the account products array
 *******************************************************************/
#define PIN_BILL_NODE_LOCATION_SEPARATOR        ':'
#define PIN_BILL_NODE_LOCATION_HOSTSIZE			64

VAR_EXTERN char 
fm_utils_ap_nodeloc_hostname[PIN_BILL_NODE_LOCATION_HOSTSIZE];

VAR_EXTERN int32 
fm_utils_ap_nodeloc_pid;

EXTERN void
fm_utils_bill_get_unique_id PROTO_LIST((
	char		*tmp_str,
	int32		size));

EXTERN void
fm_utils_cc_get_poid PROTO_LIST((
        poid_t          **o_pdpp,
        pin_errbuf_t    *ebufp));

EXTERN void
fm_utils_dd_get_poid PROTO_LIST((
        poid_t          **o_pdpp,
        pin_errbuf_t    *ebufp));

/********************??????????????????
EXTERN void
fm_utils_fillin_cc_specifics PROTO_LIST((
        pcm_context_t   *ctxp,
        pin_flist_t     *i_flistp,
        int32          op_type,
        pin_errbuf_t    *ebufp));
*********************************************************/
 
EXTERN void
fm_utils_trans_ids PROTO_LIST((
        pcm_context_t   *ctxp,
        pin_flist_t     *i_flistp,
        pin_errbuf_t    *ebufp));
 
EXTERN void
fm_utils_get_tids PROTO_LIST((
        pcm_context_t           *ctxp,
        int64                   db_no,
        int32                   count,
        int32                   seq_type,
        int32                   *seqp,
        char                    *seq_idp,
        char                    *separator,
        pin_errbuf_t            *ebufp));

EXTERN void
fm_utils_read_cfg_sequence PROTO_LIST((
        pcm_context_t           *ctxp,
        int64                   db_no,
        int32                   seq_type,
        char                    *seq_idp,
        char                    *separator,
        pin_errbuf_t            *ebufp));

EXTERN pin_flist_t *
fm_utils_get_orig_charge PROTO_LIST((
        pin_flist_t           *i_flistp,
        pin_flist_t           *r_flistp,
        int32                 element_id,
        pin_errbuf_t          *ebufp));

EXTERN void
fm_utils_fillin_charge_specifics PROTO_LIST((
        pcm_context_t           *ctxp,
        pin_flist_t             *i_flistp,
        pin_errbuf_t            *ebufp));

EXTERN void 
fm_utils_get_rate_plan_name PROTO_LIST((
	pcm_context_t		*ctxp,
	char			*event_type,
	poid_t			*p_pdp,
	char			*rate_plan_name,
        pin_errbuf_t            *ebufp));

EXTERN int
fm_utils_is_normal_item(
        poid_t          *b_pdp);

/*  New utilities for Deal/Product dependency validation routines
*
*/

EXTERN int32
fm_utils_check_pre_req PROTO_LIST((
        pcm_context_t   *ctxp,          /* Connection context   */
        poid_t          *src_dealp,     /* source deal to be checked*/
        poid_t          *pre_req_dealp,  /* pre_req deal of src_deal? */
        pin_flist_t     **pre_req_flistpp,  /* All pre_req rules object */
        pin_errbuf_t    *ebufp));         /* Error buffer         */

EXTERN int32
fm_utils_has_pre_req PROTO_LIST((
        pcm_context_t   *ctxp,          /* Connection context   */
        poid_t          *src_dealp,     /* Does this deal have any pre_reqs? */
        pin_flist_t     **pre_req_flistpp,  /* All pre_req rules object */
        pin_errbuf_t    *ebufp));         /* Error buffer         */

EXTERN int32
fm_utils_check_mutually_exclusive PROTO_LIST((
        pcm_context_t   *ctxp,          /* Connection context   */
        poid_t          *a_dealp,       /* Check a_dealp and b_dealp are
                                         mutually exclusive */
        poid_t          *b_dealp,
        pin_flist_t     **mutex_flistpp,  /* All mut-ex rules object */
        pin_errbuf_t    *ebufp));         /* Error buffer         */

EXTERN int32
fm_utils_is_required_deal PROTO_LIST((
        pcm_context_t   *ctxp,          /* Connection context   */
        poid_t          *deal_pdp,
        poid_t          *plan_pdp,
        pin_errbuf_t    *ebufp));         /* Error buffer         */

EXTERN	pin_flist_t *
fm_utils_get_valid_transitions PROTO_LIST((
        pcm_context_t   *ctxp,          /* Connection context   */
        poid_t          *from_pdp,
        poid_t          *to_pdp,
        int             transition_type,/*Transition type upgrade, downgrade */
        time_t          end_t,         /* Current Time */
        pin_errbuf_t    *ebufp));         /* Error buffer         */

EXTERN int32
fm_utils_deal_validation PROTO_LIST((
        pcm_context_t   *ctxp,          /* Connection context   */
        pin_flist_t     *deals_flistp,  /* A set of deals to validate */
        pin_flist_t     **err_flistpp,
        pin_errbuf_t    *ebufp));         /* Error buffer */

EXTERN int32
fm_utils_deal_validation_for_account PROTO_LIST((
        pcm_context_t   *ctxp,          /* Connection context   */
        poid_t          *a_pdp,         /* Account to be validated */
        pin_flist_t     *di_flistp,     /* A set of deals to be added */
        pin_errbuf_t    *ebufp));         /* Error buffer */


EXTERN void
fm_utils_get_deals_from_account PROTO_LIST((
        pcm_context_t   *ctxp,          /* Connection context   */
        poid_t          *acct_pdp,
	poid_t          *plan_pdp,
        pin_flist_t     *acct_flistp,   /* optional account flist */
        pin_flist_t     *di_flistp,     /* deals to be included(added) */
        pin_flist_t     **deals_flistpp,        /* optional account flist */
        pin_errbuf_t    *ebufp));         /* Error buffer         */

EXTERN void
fm_utils_get_plans_from_account PROTO_LIST((
        pcm_context_t   *ctxp,          /* Connection context   */
        poid_t          *acct_pdp,
        pin_flist_t     *acct_flistp,   /* optional account flist */
        pin_flist_t     **plans_flistpp,        /* optional account flist */
	time_t		eend_t,
	poid_t		*plan_pdp,
        pin_errbuf_t    *ebufp));         /* Error buffer         */


/*
 * fm_bill_utils_bill.c
 */
EXTERN time_t
fm_utils_bill_timet_from_cycle PROTO_LIST((
	time_t          start_t,
	double          cycles));

EXTERN void
fm_utils_bill_validate_product_timespan(
	pin_flist_t	*product_flistp,
	pin_errbuf_t	*ebufp);

EXTERN void
fm_utils_create_bracket_event(
        pcm_context_t *ctxp,
        pin_flist_t *in_flistp,
        char    *event_type,
        pin_errbuf_t *ebufp );

EXTERN void
fm_utils_create_flag_bracket_event(
        pcm_context_t *ctxp,
        pin_flist_t *in_flistp,
        char    *event_type,
        int32   flag,
        pin_errbuf_t *ebufp );

/*
 * fm_bill_utils_cfg_cache.c
 */

EXTERN u_int
fm_utils_get_glid PROTO_LIST((
        pcm_context_t   *ctxp,
	pin_flist_t             *i_flistp,
        pin_errbuf_t    *ebufp ));

EXTERN void
fm_utils_get_dialup_rate PROTO_LIST((
        pcm_context_t   *ctxp,
        char            *tsrv_id_ev,
        char            *tsrv_port_ev,
        char            **rate,
        pin_decimal_t   **min_gty,
        pin_decimal_t	**increment,
        pin_errbuf_t    *ebufp ));

EXTERN char *
fm_utils_get_fld_validate_name PROTO_LIST((
        pcm_context_t   *ctxp,
        char            *country,
        char            *name,
        pin_errbuf_t    *ebufp ));

EXTERN void
fm_utils_cfg_fld_validate_set_cache PROTO_LIST((
        pin_flist_t     *i_flistp,
        pin_errbuf_t    *ebufp ));

EXTERN void
fm_utils_cfg_fld_validate_stack_search PROTO_LIST((
	pcm_context_t   *ctxp,
        char            *cfg_name,
        pin_flist_t     **o_flistp,
        pin_errbuf_t    *ebufp));

/*
 * fm_bill_utils_cycle.c
 */
EXTERN int32
fm_utils_cycle_get_offset PROTO_LIST((
	int32		bill_offset,
	int32		offset_unit,
        int             dom,
        time_t          cycle_end,
        pin_errbuf_t    *ebufp));

EXTERN void
fm_utils_cycle_set_offset PROTO_LIST((
        pcm_context_t   *ctxp,
        pin_flist_t     *e_flistp,
        pin_flist_t     *r_flistp,
        poid_t          *p_pdp,
        char            *event_type,
        pin_errbuf_t    *ebufp));

EXTERN pin_decimal_t *
fm_utils_mmc_scale PROTO_LIST((
                int32           ncycles,
                int32           unit,
                time_t          next_t,
                time_t          a_time,
                time_t          bill_t,
                int             dom,
                pin_flist_t     *scale_flistp,
                pin_errbuf_t    *ebufp));

EXTERN void
fm_utils_add_n_days PROTO_LIST((
                int             n_days,
                time_t          *a_time));

EXTERN void
fm_utils_cycle_this PROTO_LIST((
                u_int          when,
                time_t         a_time,
                time_t         cycle[],
                pin_errbuf_t    *ebufp));

EXTERN void
fm_utils_cycle_last PROTO_LIST((
                u_int          when,
                time_t         a_time,
                time_t         cycle[],
                pin_errbuf_t    *ebufp));

EXTERN u_int
fm_utils_cycle_is_valid_dom PROTO_LIST((
                u_int           dom,
                pin_errbuf_t    *ebufp));

EXTERN int
fm_utils_cycle_get_dom PROTO_LIST((
                time_t          a_time,
                pin_errbuf_t    *ebufp));
/*
EXTERN time_t
fm_utils_cycle_actgfuturet PROTO_LIST((
                u_int           dom,
                pin_actg_len_t  cycle_len,
                time_t          actg_next_t,
                pin_errbuf_t    *ebufp));
*/
EXTERN time_t
fm_utils_cycle_actgnextt_by_ncycles PROTO_LIST((
                int             ncycles,
                int             dom,
                time_t          curr_actg_t,
                pin_errbuf_t    *ebufp));

EXTERN time_t
fm_utils_cycle_actgnextt PROTO_LIST((
                time_t          curr_actg_t,
                int             dom,
                pin_errbuf_t    *ebufp));

EXTERN time_t
fm_utils_cycle_billnextt PROTO_LIST((
                int             dom,
                int             bill_cycles_left,
                time_t          actg_next_t,
                time_t          actg_future_t,
                pin_errbuf_t   *ebufp));

EXTERN u_int
fm_utils_cycle_matching_nextbillt PROTO_LIST((
                int             m_dom,
                time_t          m_actgnextt,
                time_t          m_actgfuturet,
                int             p_dom,
                time_t          p_actgnextt,
                time_t          p_actgfuturet,
                int             p_billwhen,
                int             p_cyclesleft,
                pin_errbuf_t    *ebufp));

EXTERN void
fm_utils_cycle_last_by_ncycles_ex PROTO_LIST((
		int             ncycles,
		time_t          a_time,
		int		dom,
		time_t          cycle[],
		pin_errbuf_t    *ebufp));
/*
 * fm_bill_utils_ts_map.c
 */
EXTERN int
fm_utils_is_ts_map PROTO_LIST(());

EXTERN int
fm_utils_get_ts_map PROTO_LIST((
	char		*prod_name,
	char		*ship_to,
	char		**company_id,
	char		**business_location,
	char		**ship_from,
	int 		*reg_flag));

EXTERN void
fm_utils_tax_load_taxcodes PROTO_LIST((
	pin_errbuf_t	*ebufp));


EXTERN void
fm_utils_tax_parse_fld PROTO_LIST((
        char            **buf,
        char            *fld,
        char            delim));

EXTERN void
fm_utils_tax_get_taxcode PROTO_LIST((
	char		*tax_code,
	char		*table_entry,
	char		*tax_pkg));

EXTERN void
fm_utils_tax_get_taxcodes PROTO_LIST((
	pin_flist_t	*o_flistp,
	pin_errbuf_t	*ebufp));

EXTERN pin_flist_t *
fm_utils_get_tax_supplier_elem(
	int32		ts_id,
	pin_errbuf_t	*ebufp);

/*
 * fm_bill_utils.c
 */
EXTERN void 
fm_bill_utils_pre_create_notify PROTO_LIST((
	pcm_context_t   *ctxp,
	pin_flist_t     *c_flistp,
	poid_t          *a_pdp,
	char            *event_type,
	char            *program,
	pin_flist_t     *svc_flistp,
	pin_bill_billing_state_t bill_state,
	pin_errbuf_t    *ebufp));


/*
 * fm_bill_utils_close.c
 */
EXTERN void
fm_utils_close_bill PROTO_LIST((
		pcm_context_t   *ctxp,
		pin_flist_t     *i_flistp,
		pin_errbuf_t    *ebufp));
        
/*
 * set the optional balance group into the event flistp; if not exists, get and
 * set the account level balance group
 * also set the passed sub-balances into it if passed.
 */
EXTERN void 
fm_bill_utils_set_bal_grp(
    pcm_context_t       *ctxp,
    int32                   flags,
    pin_flist_t             *in_flistp,
    pin_flist_t             *evt_flistp,
    pin_errbuf_t            *ebufp);

/*
 * put the balance group into the bal impact flist
 * also put the passed sub-balances into it if passed.
 */
EXTERN void 
fm_bill_utils_put_bal_grp(
    pin_flist_t             	*evt_flistp,
    pin_flist_t             	*bal_imp_flistp,
    pin_errbuf_t            	*ebufp);

/* new API written in C++ for Apollo */
EXTERN void
fm_bill_utils_apply_multi_bal_impact(
	pcm_context_t     	*ctxp,
	u_int32			flags,
	pin_flist_t		*a_flistp,
	int32			flag,
	pin_errbuf_t		*ebufp);

/* fill the item's balance group object */
EXTERN void fm_bill_utils_fill_items_bal_grp(
	pcm_context_t 		*ctxp,
    	u_int32 		flags,
	pin_flist_t 		*item_flistp,
	pin_errbuf_t 		*ebufp);

/* get balances from associated balance group,
   this is for resource reservation */
EXTERN void fm_bill_utils_get_bals_for_reserve(
	pcm_context_t 		*ctxp,
    	u_int32 		flags,
	pin_flist_t 		*in_flistp,
	pin_flist_t 		**out_flistpp,
	pin_errbuf_t 		*ebufp);

EXTERN void
fm_utils_generate_notify_event(
	pcm_context_t		*ctxp,
	pin_flist_t		*a_flistp,
	pin_flist_t		*b_flistp,
	char			*event_type,
	char			*event_name,
	char			*event_descr,
	pin_errbuf_t		*ebufp);

EXTERN void fm_bill_utils_init_cfg_sub_bal_contributor(
	pcm_context_t	*ctxp,
	int64 			database,
	pin_errbuf_t	*ebufp);

/*
 * fm_bill_utils_bal_utils.cpp
 */

EXTERN int32 fm_bill_utils_get_todays_rec_id(void);


/*
 * fm_utils_remit.c
 */

/* remittance fields */
VAR_EXTERN pin_flist_t	*fm_remit_flds_flistp;
/* remittance spec */
VAR_EXTERN cm_cache_t	*fm_remit_spec_cache_p;
/* list of fields that will be read from /account object. */
VAR_EXTERN pin_flist_t	*fm_remit_acct_search_flds_flistp;
/* list of fields that will be read from /profile object. */
VAR_EXTERN pin_flist_t	*fm_remit_profile_search_flds_flistp;

EXTERN void fm_utils_remit_config_remittance_flds(
	pcm_context_t	*ctxp,
	int64		database,
	pin_errbuf_t	*ebufp);

EXTERN void fm_utils_remit_config_remittance_spec(
	pcm_context_t	*ctxp,
	int64		database,
	pin_errbuf_t	*ebufp);

EXTERN void fm_utils_remit_organize_remit_criteria(
        pcm_context_t           *ctxp,
        int64                    database,
        pin_flist_t             *remit_acct_flistp,
        pin_errbuf_t            *ebufp);

EXTERN void fm_utils_remit_get_remit_flds_info(
        pin_flist_t             *criteria_flistp,
        int                     *reserved_type,
        int                     *base_type,
        pin_fld_num_t           *substruct,
        pin_fld_num_t           *remit_field,
        int                     *op,
        pin_errbuf_t            *ebufp);

EXTERN void fm_utils_remit_get_remit_criteria_product_poids(
        pcm_context_t           *ctxp,
        int64                    database,
        pin_flist_t             *criteria_flistp,
        pin_errbuf_t            *ebufp);

EXTERN void fm_bill_utils_set_def_billinfo(
        pcm_context_t           *ctxp,
		u_int32					flags,
        pin_flist_t             *in_flistp,
		pin_fld_num_t			acct_pd_fld,
		pin_fld_num_t			billinfo_pd_fld,
        pin_errbuf_t            *ebufp);

/*
 * fm_bill_utils_tax_utils.c
 */
EXTERN void
fm_bill_utils_tax_apply2_impact(
	int32		fld_flags,
	pin_flist_t	*a_flistp,
	pin_flist_t	*b_flistp,
	pin_flist_t	*tax_flistp,
	pin_flist_t	*res_flistp,
	pin_errbuf_t	*ebufp);

EXTERN void
fm_bill_utils_tax_negate_tax_jurisdiction_element PROTO_LIST((
	pin_flist_t		*tj_flistp,
	pin_errbuf_t	*ebufp));

/*
 * fm_utils_channel.c
 */
EXTERN void
fm_utils_channel_push PROTO_LIST((
	pcm_context_t		*ctxp,
	u_int			flags,
	pin_flist_t		*i_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp));

EXTERN void
fm_utils_channel_precommit PROTO_LIST((
	pcm_context_t		*ctxp,
	u_int			flags,
	pin_flist_t		*i_flistp,
	pin_errbuf_t		*ebufp));

EXTERN void
fm_utils_channel_postabort PROTO_LIST((
	pcm_context_t		*ctxp,
	u_int			flags,
	pin_flist_t		*i_flistp,
	pin_errbuf_t		*ebufp));
	

EXTERN int
fm_utils_channel_is_enabled PROTO_LIST(());

/*
 * fm_bill_utils_feature_control.c
 */


EXTERN void
fm_utils_check_feature_status PROTO_LIST((
        pcm_context_t    *ctxp,
        char             *feature_namep,
        pin_errbuf_t     *ebufp));

EXTERN void
fm_utils_log_feature_disabled PROTO_LIST((
        char             *feature_namep,
        pin_errbuf_t     *ebufp));

EXTERN void fm_bal_utils_set_bal_cache(
        pcm_context_t    *ctxp,
        pin_flist_t      *in_flistp,
        pin_flist_t      **out_flistp,
        pin_errbuf_t     *ebufp);

/*
 * fm_bill_utils_iscript_utils.c
 */
EXTERN void
fm_bill_utils_iscript_load_templates(
        pcm_context_t   *ctxp,
        pin_flist_t     *i_flistp,
        pin_errbuf_t    *ebufp );

EXTERN void
fm_bill_utils_iscript_validate_object(
        pcm_context_t   *ctxp,
        poid_t          *b_pdp,
        pin_flist_t     *in_flistp,
        pin_flist_t     **out_flistpp,
        pin_errbuf_t    *ebufp );

EXTERN pin_flist_t *
fm_bill_utils_get_bus_pro_obj(
        poid_t          *k_pdp,
        pin_errbuf_t    *ebufp);

EXTERN pin_flist_t *
fm_bill_utils_get_template_obj(
        poid_t          *k_pdp,
        pin_errbuf_t    *ebufp);

EXTERN void
fm_bill_utils_update_object_cache_residency_value(
        pcm_context_t   *ctxp,
        pin_flist_t     *in_flistp,
        pin_flist_t     *t_flistp,
        pin_errbuf_t    *ebufp );

EXTERN void
fm_bill_utils_iscript_validation(
        pcm_context_t   *ctxp,
        pin_flist_t     *in_flistp,
        pin_flist_t     **out_flistpp,
        pin_errbuf_t    *ebufp );

EXTERN poid_t *
fm_bill_utils_search_bus_pro (
        pcm_context_t   *ctxp,
        poid_t          *k_pdp,
        pin_errbuf_t    *ebufp);


EXTERN void
fm_bill_utils_prep_lock_obj (
		pcm_context_t	*ctxp,
		int32		in_flags,
		pin_flist_t	*in_flistp,
		pin_flist_t	**out_flistpp,
		pin_errbuf_t	*ebufp);

#undef EXTERN
#undef VAR_EXTERN

#endif /* !_FM_BILL_UTILS_H */

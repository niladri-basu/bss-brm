/*******************************************************************************
 *
* Copyright (c) 1998, 2010, Oracle and/or its affiliates. All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 ******************************************************************************/

#ifndef lint
static char Sccs_id[] = "@(#)$Id: fm_act_pol_event_notify.c /cgbubrm_7.3.2.rwsmod/1 2010/02/12 04:14:28 agangwar Exp $";
#endif

/*******************************************************************
 * Contains the PCM_OP_ACT_POL_EVENT_NOTIFY operation. 
 *******************************************************************/

#include <stdio.h> 
#include <string.h> 
 
#include "pcm.h"
#include "ops/delivery.h"
#include "ops/cust.h"
#include "ops/act.h"
#include "ops/pymt.h"
#include "pin_act.h"
#include "pin_cust.h"
#include "pin_mail.h"
#include "pin_bill.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pinlog.h"
#include "pin_channel.h"
#include "fm_utils.h"
#include "fm_bill_utils.h"
#define FILE_SOURCE_ID  "fm_act_pol_event_notify.c(2)"

/*******************************************************************
 * Routines contained within.
 *******************************************************************/
EXPORT_OP void
op_act_pol_event_notify(
	cm_nap_connection_t	*connp,
	int32			opcode,
	int32			flags,
	pin_flist_t		*i_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp);

static void
fm_act_pol_event_notify_ldap(
	pcm_context_t		*ctxp,
	int32			flags,
	pin_flist_t		*i_flistp,
	pin_errbuf_t		*ebufp);

static void
fm_act_pol_event_notify(
	pcm_context_t		*ctxp,
	int32			flags,
	pin_flist_t		*i_flistp,
	pin_errbuf_t		*ebufp);

static void
fm_act_pol_call_topup(
	pcm_context_t		*ctxp, 
	int32			flags,
	pin_flist_t		*i_flistp, 
	pin_errbuf_t		*ebufp);

/*******************************************************************
 * Routines needed from elsewhere.
 *******************************************************************/

/*******************************************************************
 * Main routine for the PCM_OP_ACT_POL_EVENT_NOTIFY operation.
 *******************************************************************/
void
op_act_pol_event_notify(
	cm_nap_connection_t	*connp,
	int32			opcode,
	int32			flags,
	pin_flist_t		*i_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp)
{
	pcm_context_t		*ctxp = connp->dm_ctx;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Null out results
	 ***********************************************************/
	*r_flistpp = NULL;

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_ACT_POL_EVENT_NOTIFY) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_act_pol_event_notify opcode error", ebufp);

		return;
	}
	
	/***********************************************************
	 * Debut what we got.
         ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_act_pol_event_notify input flist", i_flistp);

	/***********************************************************
	 * Process events for ldap integration
	 ***********************************************************/
	fm_act_pol_event_notify_ldap(ctxp, flags, i_flistp, ebufp);

	/***********************************************************
	 * Process events for email notification
	 ***********************************************************/
	fm_act_pol_event_notify(ctxp, flags, i_flistp, ebufp);
	
	/***********************************************************
	 * Prepare return flist
	 ***********************************************************/
	if (!PIN_ERR_IS_ERR(ebufp)) {
		void			*vp = NULL;

		*r_flistpp = PIN_FLIST_CREATE(ebufp);
		vp = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_POID, 0, ebufp);
		PIN_FLIST_FLD_SET(*r_flistpp, PIN_FLD_POID, vp, ebufp);
	}
	
	/***********************************************************
	 * Error?
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_act_pol_event_notify error", ebufp);
	}

	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_act_pol_event_notify output flist", *r_flistpp);
	return;
}

/*******************************************************************
 * fm_act_pol_event_notify:
 *
 *******************************************************************/
static void
fm_act_pol_event_notify(
	pcm_context_t           *ctxp,
	int32                   flags,
	pin_flist_t             *i_flistp,
	pin_errbuf_t            *ebufp)
{
	poid_t			*e_pdp = NULL;
	const char		*poid_type = NULL;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	
	/***********************************************************
         * Action depends on the type of event.  List events here
         * and then branch to appropriate handler.
         ***********************************************************/
	e_pdp = (poid_t *)PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_POID, 0, ebufp);
	poid_type = PIN_POID_GET_TYPE(e_pdp);

	if (poid_type == NULL) {
		return;
	}
	
       if (strcmp(poid_type, PIN_OBJ_TYPE_EVENT_CREDIT_THRESHOLD) == 0) {
		fm_act_pol_call_topup(ctxp, flags, i_flistp, ebufp);
        }
}

/*******************************************************************
 * fm_act_pol_event_notify_ldap:
 *
 * Handle the events for ldap integration.
 *******************************************************************/
static void
fm_act_pol_event_notify_ldap(
	pcm_context_t		*ctxp,
	int32			flags,
	pin_flist_t		*i_flistp,
	pin_errbuf_t		*ebufp)
{	
	poid_t			*e_pdp = NULL;
	poid_t			*event_pdp = NULL;
	poid_t			*ch_pdp = NULL;
	poid_t			*svc_pdp = NULL;
	poid_t			*obj_pdp = NULL;
	pin_flist_t		*flistp = NULL;
	pin_flist_t		*r_flistp = NULL;
	int64			db_id = 0;
	char			*type = NULL;
	int			id = 0;
	int32			push_service_modify = 0;
	int32			push_account_modify = 0;

	/*
	 * Our action will depend on the type of event
	 * If the event indicate a change of an account object,
	 * we do a push on the predefined account channel
	 * If the event indicate a change of an service object,
	 * we do a push on the predefined service channel
	 */
	e_pdp = (poid_t *)PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_POID, 0, ebufp);
	db_id = pin_poid_get_db(e_pdp);

	PIN_ERR_LOG_POID(PIN_ERR_LEVEL_DEBUG, "Event poid:", e_pdp);
	
	if (fm_utils_is_subtype(e_pdp, 
			PIN_OBJ_TYPE_EVENT_CREATE_BILLINFO) == 1){ 
			type = PIN_OBJ_TYPE_EVENT_CREATE_BILLINFO;
			push_account_modify = 1;
	}
	if(fm_utils_is_subtype(e_pdp, 
			PIN_OBJ_TYPE_EVENT_MODIFY_BILLINFO) == 1) { 
			type = PIN_OBJ_TYPE_EVENT_MODIFY_BILLINFO;
			push_account_modify = 1;
	}
	if(fm_utils_is_subtype(e_pdp, 
			PIN_OBJ_TYPE_EVENT_DELETE_BILLINFO) == 1) { 
			type = PIN_OBJ_TYPE_EVENT_DELETE_BILLINFO;
			push_account_modify = 1;
	}
	if(fm_utils_is_subtype(e_pdp, PIN_OBJ_TYPE_EVENT_NAMEINFO) == 1) { 
			type = PIN_OBJ_TYPE_EVENT_NAMEINFO;
			push_account_modify = 1;
	}
	if(fm_utils_is_subtype(e_pdp, PIN_OBJ_TYPE_EVENT_PRODUCT_STATUS)
		== 1) {

		type = PIN_OBJ_TYPE_EVENT_PRODUCT_STATUS;
			push_account_modify = 1;
	}
	if ( fm_utils_is_subtype(e_pdp, PIN_OBJ_TYPE_EVENT_LOGIN) == 1) { 
			type = PIN_OBJ_TYPE_EVENT_LOGIN;
			push_service_modify = 1;
	}
	if(fm_utils_is_subtype(e_pdp, PIN_OBJ_TYPE_EVENT_PASSWORD) == 1) {
			type = PIN_OBJ_TYPE_EVENT_PASSWORD;
			push_service_modify = 1;
	}  
	if(fm_utils_is_subtype(e_pdp, PIN_OBJ_TYPE_EVENT_SERVICE) == 1) { 
			type = PIN_OBJ_TYPE_EVENT_SERVICE;
		push_service_modify = 1;
	}
	else if (fm_utils_is_subtype(e_pdp, PIN_OBJ_TYPE_EVENT_STATUS) == 1) {
			type = PIN_OBJ_TYPE_EVENT_STATUS;
		svc_pdp = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_SERVICE_OBJ, 1,
					    ebufp);

		if (PIN_POID_IS_NULL(svc_pdp)) {
			push_account_modify = 1;
		} else {
			push_service_modify = 1;
		}
	}

	if (push_account_modify) {
		obj_pdp = (poid_t *)PIN_FLIST_FLD_GET(i_flistp, 
					PIN_FLD_ACCOUNT_OBJ, 0, ebufp);
		ch_pdp = PIN_POID_CREATE(db_id, "/channel",
					 PIN_CHANNEL_ACCOUNT_MODIFY, ebufp);
	} else if (push_service_modify) {
		obj_pdp = (poid_t *)PIN_FLIST_FLD_GET(i_flistp, 
					PIN_FLD_SERVICE_OBJ, 0, ebufp);
		ch_pdp = PIN_POID_CREATE(db_id, "/channel",
					 PIN_CHANNEL_SERVICE_MODIFY, ebufp);
	}

	if (push_account_modify  || push_service_modify) {
		flistp = PIN_FLIST_CREATE(ebufp);
		PIN_FLIST_FLD_PUT(flistp, PIN_FLD_POID, (void *)ch_pdp, ebufp);
		db_id = PIN_POID_GET_DB(e_pdp);
		id = PIN_POID_GET_ID(e_pdp);
		event_pdp = PIN_POID_CREATE(db_id, type, id, ebufp);
		PIN_FLIST_FLD_PUT(flistp, PIN_FLD_SUPPLIER_OBJ,
					(void*)event_pdp, ebufp);

		PIN_FLIST_FLD_SET(flistp, PIN_FLD_SOURCE_OBJ, (void *)obj_pdp, 
				ebufp);
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
				  "fm_utils_channel_push input flist:",
				  flistp);

		fm_utils_channel_push(ctxp, flags, flistp, &r_flistp, ebufp);

		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
				  "fm_utils_channel_push output flist:",
				  r_flistp);
	}

	PIN_FLIST_DESTROY_EX(&flistp, NULL);
	PIN_FLIST_DESTROY_EX(&r_flistp, NULL);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_DEBUG,
				 "fm_act_pol_event_notify_ldap error:", ebufp);
	}
}

static void
fm_act_pol_call_topup(
	pcm_context_t		*ctxp, 
	int32			flags,
	pin_flist_t		*in_flistp, 
	pin_errbuf_t		*ebufp)
{
	void		*vp		= NULL;
	pin_flist_t	*i_flistp	= NULL;
	pin_flist_t	*r_i_flistp	= NULL;
	pin_flist_t	*b_flistp	= NULL;
	pin_flist_t	*r_b_flistp	= NULL;
	pin_flist_t	*t_flistp	= NULL;
	pin_flist_t	*r_t_flistp	= NULL;
	pin_flist_t	*flistp		= NULL;
	pin_flist_t	*inh_flistp	= NULL;
	poid_t		*s_pdp		= NULL;
	int32		srchFlags 	= SRCH_DISTINCT;
	int32		local_flag 	= 0;
	

	if (PIN_ERR_IS_ERR(ebufp)) return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/** read the item to get the billinfo poid and then find the 
	 ** topup object for this billinfo.
	 **/

	vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_ITEM_OBJ, 1, ebufp);
	if (vp == NULL) {
		return;
	}
	i_flistp = PIN_FLIST_CREATE(ebufp);
	PIN_FLIST_FLD_SET(i_flistp, PIN_FLD_POID, vp, ebufp);
	PIN_FLIST_FLD_SET(i_flistp, PIN_FLD_BILLINFO_OBJ, NULL, ebufp);	
	PIN_FLIST_FLD_SET(i_flistp, PIN_FLD_BAL_GRP_OBJ, NULL, ebufp);	

	PCM_OP(ctxp, PCM_OP_READ_FLDS, flags, i_flistp, &r_i_flistp, ebufp);

	vp = PIN_FLIST_FLD_GET(r_i_flistp, PIN_FLD_BILLINFO_OBJ, 0, ebufp);

	b_flistp = PIN_FLIST_CREATE(ebufp);
	s_pdp = PIN_POID_CREATE(PIN_POID_GET_DB((poid_t *)vp), "/search", -1, ebufp);
	PIN_FLIST_FLD_PUT(b_flistp, PIN_FLD_POID, s_pdp, ebufp);

	PIN_FLIST_FLD_SET(b_flistp, PIN_FLD_FLAGS, &srchFlags, ebufp);
	PIN_FLIST_FLD_SET(b_flistp, PIN_FLD_TEMPLATE, 
		(void *)" select X from /topup where F1 = V1 ", ebufp);

	flistp = PIN_FLIST_ELEM_ADD(b_flistp, PIN_FLD_ARGS, 1, ebufp);
	PIN_FLIST_FLD_SET(flistp, PIN_FLD_BILLINFO_OBJ, vp, ebufp);

	PIN_FLIST_ELEM_SET(b_flistp, NULL, PIN_FLD_RESULTS, PIN_ELEMID_ANY, ebufp);

	PCM_OP(ctxp, PCM_OP_SEARCH, 0, b_flistp, &r_b_flistp, ebufp);

	flistp = PIN_FLIST_ELEM_GET(r_b_flistp, PIN_FLD_RESULTS, 0, 1, ebufp);

	/** Ok found a topup object Now call the topup API **/

	if (flistp != (pin_flist_t *)NULL) {

		t_flistp = PIN_FLIST_CREATE(ebufp);
		vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_ACCOUNT_OBJ,
								0, ebufp);
		PIN_FLIST_FLD_SET(t_flistp, PIN_FLD_POID, vp, ebufp);
	
		vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_PROGRAM_NAME,
								0, ebufp);
		PIN_FLIST_FLD_SET(t_flistp, PIN_FLD_PROGRAM_NAME, vp, ebufp);

		vp = PIN_FLIST_FLD_GET(r_i_flistp, PIN_FLD_BAL_GRP_OBJ, 
								0, ebufp);
		PIN_FLIST_FLD_SET(flistp, PIN_FLD_BAL_GRP_OBJ, vp, ebufp);

		inh_flistp = PIN_FLIST_SUBSTR_ADD(t_flistp,
						PIN_FLD_INHERITED_INFO,ebufp);

		PIN_FLIST_ELEM_SET(inh_flistp, flistp, PIN_FLD_TOPUP_INFO, 0, ebufp);

		/************************************************
		 * If PCM_OPFLG_CALC_ONLY flag is set in the flags
		 * then unset the PCM_OPFLG_CALC_ONLY in the local
		 * flag passed to opcode.
		 ************************************************/
		if (flags & PCM_OPFLG_CALC_ONLY) {
			local_flag = local_flag & (~PCM_OPFLG_CALC_ONLY);
		} else {
			local_flag = flags;
		}

		PCM_OP(ctxp, PCM_OP_PYMT_TOPUP, local_flag, t_flistp, &r_t_flistp, ebufp);	
	}

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_act_pol_call_topup error", ebufp);
	}

	/** cleanup
	 **/
	PIN_FLIST_DESTROY_EX(&i_flistp, NULL);
	PIN_FLIST_DESTROY_EX(&r_i_flistp, NULL);
	PIN_FLIST_DESTROY_EX(&b_flistp, NULL);
	PIN_FLIST_DESTROY_EX(&r_b_flistp, NULL);
	PIN_FLIST_DESTROY_EX(&t_flistp, NULL);
	PIN_FLIST_DESTROY_EX(&r_t_flistp, NULL);

	return;
}

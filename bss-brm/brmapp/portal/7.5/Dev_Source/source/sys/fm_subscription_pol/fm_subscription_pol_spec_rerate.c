/*
 *
 * Copyright (c) 2003, 2009, Oracle and/or its affiliates. 
All rights reserved. 
 *      
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *
 */

#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: fm_subscription_pol_spec_rerate.c /cgbubrm_7.3.2.rwsmod/1 2009/03/24 07:02:27 amamidi Exp $";
#endif

/*******************************************************************
 * Contains the PCM_OP_SUBSCRIPTION_POL_SPEC_RERATE operation. 
 *
 * Also included are subroutines specific to the operation.
 *
 * These routines are generic and work for all account types.
 *******************************************************************/

#include <stdio.h> 
#include <string.h> 
 
#include "pcm.h"
#include "ops/bill.h"
#include "ops/subscription.h"
#include "pin_act.h"
#include "pin_bill.h"
#include "pin_cust.h"
#include "pin_currency.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pinlog.h"

#define FILE_SOURCE_ID  "fm_subscription_pol_spec_rerate.c(1)"


/*******************************************************************
 * Routines contained within.
 *******************************************************************/
EXPORT_OP void
op_subscription_pol_spec_rerate(
        cm_nap_connection_t	*connp,
	u_int			opcode,
        u_int			flags,
        pin_flist_t		*in_flistp,
        pin_flist_t		**ret_flistpp,
        pin_errbuf_t		*ebufp);

void fm_subs_pol_spec_rerate();

/*******************************************************************
 * Main routine for the PCM_OP_SUBSCRIPTION_POL_SPEC_RERATE operation.
 *******************************************************************/
void
op_subscription_pol_spec_rerate(
        cm_nap_connection_t	*connp,
	u_int			opcode,
        u_int			flags,
        pin_flist_t		*in_flistp,
        pin_flist_t		**ret_flistpp,
        pin_errbuf_t		*ebufp)
{
	pcm_context_t		*ctxp = connp->dm_ctx;

	pin_cookie_t		cookie = NULL;

	pin_flist_t		*r_flistp = NULL;
	pin_flist_t		*flistp = NULL;

	poid_t			*a_pdp = NULL;

	char			*action;
	char			*cp;

	u_int			rec_id;
	u_int			done = 0;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_SUBSCRIPTION_POL_SPEC_RERATE) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
		       "op_subscription_pol_spec_rerate opcode error",
			ebufp);
		return;
	}

	/***********************************************************
	 * Debug: What we got.
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_subscription_pol_spec_rerate input flist", 
			in_flistp);

	/***********************************************************
	 * Get the policy return flist.
	 ***********************************************************/
	fm_subs_pol_spec_rerate(ctxp, in_flistp, &r_flistp, ebufp);

	/***********************************************************
	 * Errors?
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {

		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_subscription_pol_spec_rerate error", 
			ebufp);
		PIN_FLIST_DESTROY(r_flistp, NULL);
		*ret_flistpp = NULL;

	} else {

		/***************************************************
		 * Point the real return flist to the right thing.
		 ***************************************************/
		PIN_ERR_CLEAR_ERR(ebufp);
		*ret_flistpp = r_flistp;
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		       "op_subscription_pol_spec_rerate return flist",
			*ret_flistpp);
	}

	return;
}


/*******************************************************************
 * fm_subs_pol_spec_rerate():
 *
 *	This function allows to change the search template for the
 *	event search for re-rating. This op-code is invoked if 
 *	Re-rating is run in Selective mode, in which case the input 
 *	flist is already passed for selective events based on the 
 *	criteria specified. You would change the flist only if you
 *	want your additional criteria to filter the events. The
 *	modified search template could have some performance impact
 *	if it is going to do a join with other tables.
 *******************************************************************/
void
fm_subs_pol_spec_rerate(
	pcm_context_t	*ctxp,
	pin_flist_t	*i_flistp,
	pin_flist_t	**out_flistp,
	pin_errbuf_t	*ebufp)
{
        pin_flist_t     *s_flistp = NULL;
        pin_flist_t     *d_flistp = NULL;
        pin_cookie_t    cookie = NULL;
        int             elem_id = 0;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Make a copy of the input flist and return. 
	 * No default implementation yet.
	 ***********************************************************/
	*out_flistp = PIN_FLIST_COPY(i_flistp, ebufp);

	/***********************************************************
	 * Errors?
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_subs_pol_spec_rerate error", ebufp);

	}

	return;
}

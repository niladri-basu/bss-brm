/*
 *
 * Copyright (c) 2005, 2009, Oracle and/or its affiliates. 
All rights reserved. 
 *      
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: fm_subscription_pol_update_cdc.c /cgbubrm_7.3.2.rwsmod/1 2009/03/24 07:02:27 amamidi Exp $";
#endif

/*******************************************************************
 * Contains the PCM_OP_SUBSCRIPTION_POL_UPDATE_CDC operation. 
 *******************************************************************/

#include <stdio.h> 
#include <string.h> 
#include "pcm.h"
#include "ops/pymt.h"
#include "ops/bal.h"
#include "ops/cust.h"
#include "ops/bill.h"
#include "ops/subscription.h"
#include "pin_bill.h"
#include "pin_cust.h"
#include "cm_fm.h"

#define FILE_SOURCE_ID  "fm_subscription_pol_update_cdc.c(1)"


/*******************************************************************
 * Routines contained within.
 *******************************************************************/
EXPORT_OP void
op_subscription_pol_update_cdc(
        cm_nap_connection_t	*connp,
	int32			opcode,
        int32			flags,
        pin_flist_t		*i_flistp,
        pin_flist_t		**o_flistpp,
        pin_errbuf_t		*ebufp);

/*******************************************************************
 * Routines needed from elsewhere.
 *******************************************************************/

/****************************************************************************
 * Main routine for the PCM_OP_SUBSCRIPTION_POL_UPDATE_CDC operation.
 ***************************************************************************/
void
op_subscription_pol_update_cdc(
        cm_nap_connection_t	*connp,
	int32			opcode,
        int32			flags,
        pin_flist_t		*i_flistp,
        pin_flist_t		**o_flistpp,
        pin_errbuf_t		*ebufp)
{
	pcm_context_t		*ctxp = connp->dm_ctx;
	pin_flist_t		*r_flistp = NULL;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_SUBSCRIPTION_POL_UPDATE_CDC) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
		 "op_subscription_pol_update_cdc opcode error", ebufp);
		return;
	}

	/***********************************************************
	 * Debug: What we got.
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
	       "op_subscription_pol_update_cdc input flist", i_flistp);

	/***********************************************************
	 * Prep the return flist.
	 ***********************************************************/
	r_flistp = PIN_FLIST_COPY(i_flistp, ebufp);


	/***********************************************************
	 * Results.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {

		/***************************************************
		 * Log something and return nothing.
		 ***************************************************/
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_subscription_pol_update_cdc error", ebufp);
		PIN_FLIST_DESTROY_EX(&r_flistp, NULL);
		*o_flistpp = NULL;

	} else {

		/***************************************************
		 * Point the real return flist to the right thing.
		 ***************************************************/
		PIN_ERR_CLEAR_ERR(ebufp);
		*o_flistpp = r_flistp;

		/***************************************************
		 * Debug: What we're sending back.
		 ***************************************************/
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_subscription_pol_update_cdc return flist", 
		r_flistp);

	}

	return;
}

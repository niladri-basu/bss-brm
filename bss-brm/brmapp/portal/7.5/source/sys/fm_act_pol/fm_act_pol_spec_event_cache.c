/*******************************************************************
 *
 * Copyright (c) 1999, 2009, Oracle and/or its affiliates.All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: fm_act_pol_spec_event_cache.c /cgbubrm_7.3.2.rwsmod/2 2009/02/26 03:53:42 ambhatt Exp $";
#endif

/*******************************************************************
 * Contains the PCM_OP_ACT_POL_SPEC_EVENT_CACHE operation. 
 *******************************************************************/

/*******************************************************************
 * The event cache is mainly used to improve the invoicing 
 * performance, i.e., the efficiency in the event search during
 * invoicing.  By default, fields from the BAL_IMPACTS array are
 * cached in a base table field PIN_FLD_INVOICE_DATA, so that 
 * the event search will only need to look into the base event table,
 * which saves time for not doing a table join.  
 * Note the PIN_FLD_INVOICE_DATA field has a database length limit
 * of 4000 bytes, if the cache size is greater than 4000 bytes, it 
 * will be ignored.
 * If you don't want to use the event cache for some reason, simply
 * return a NULL pointer to the caller of this opcode. 
 *******************************************************************/

#include <stdio.h> 
#include <string.h> 
#include <time.h> 

#include "pcm.h"
#include "ops/act.h"
#include "pin_act.h"
#include "pin_cust.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pinlog.h"
#include "psiu_business_params.h"


/*******************************************************************
 * Routines contained within.
 *******************************************************************/
EXPORT_OP void
op_act_pol_spec_event_cache(
	cm_nap_connection_t	*connp,
	int32			opcode,
	int32			flags,
	pin_flist_t		*i_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp);

void
fm_act_pol_spec_event_cache(
	pcm_context_t	*ctxp,
	int32		flags,
	pin_flist_t	*i_flistp,
	pin_flist_t	**r_flistpp,
	pin_errbuf_t	*ebufp);

/*******************************************************************
 * Routines needed from elsewhere.
 *******************************************************************/

/*******************************************************************
 * Main routine for the PCM_OP_ACT_POL_SPEC_EVENT_CACHE operation.
 *******************************************************************/
void
op_act_pol_spec_event_cache(
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
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_ACT_POL_SPEC_EVENT_CACHE) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_act_pol_spec_event_cache opcode error", ebufp);
		return;
	}
	/***********************************************************
	 * Debut what we got.
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_act_pol_spec_event_cache input flist", i_flistp);

	/***********************************************************
	 * Do the actual op in a sub.
	 ***********************************************************/
	fm_act_pol_spec_event_cache(ctxp, flags, i_flistp, r_flistpp, 
		ebufp);

	/***********************************************************
	 * Error?
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		*r_flistpp = (pin_flist_t *)NULL;
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_act_pol_spec_event_cache error", ebufp);

	} else {

	/***********************************************************
	 * Output flist.
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_act_pol_spec_event_cache output flist", 
			*r_flistpp);

	}
	return;
}

void
fm_act_pol_spec_event_cache(
	pcm_context_t		*ctxp,
	int32			flags,
	pin_flist_t		*i_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp)
{
	pin_flist_t		*bal_flistp = NULL;
	pin_flist_t		*r_flistp = NULL;
	pin_flist_t		*flistp = NULL;
	pin_cookie_t		cookie = NULL;
	int32			rec_id = 0;
	void			*vp = NULL;

	/**********************************************************
	 * By default, the following fields in the BAL_IMPACTS
	 * array will be cached:
	 *    PIN_FLD_RESOURCE_ID
	 *	  PIN_FLD_QUANTITY
	 *	  PIN_FLD_RATE_TAG
	 *	  PIN_FLD_ITEM_OBJ
	 *	  PIN_FLD_AMOUNT 
	 * 
	 * If customers would like to put more fields from 
	 * the BAL_IMPACTS array to the cache, they need to keep 
	 * the rec_id unchanged in the output flist.
	 * Other fields from other objects or other arrays can be
	 * put in the output flist and will be cached later too.
	 **********************************************************/

	/***********************************************************
	 * Check if the required fields are on the input flist
	 * If not, just add them to the return flist.
	 * By default, these fields should be added here.
	 ***********************************************************/
	while ((flistp = PIN_FLIST_ELEM_GET_NEXT(i_flistp,
		PIN_FLD_BAL_IMPACTS, &rec_id, 1, &cookie,
		ebufp)) != (pin_flist_t *)NULL) {

		if (r_flistp == NULL) {
			r_flistp = PIN_FLIST_CREATE(ebufp);
		}

		bal_flistp = PIN_FLIST_ELEM_ADD(r_flistp,
				PIN_FLD_BAL_IMPACTS, rec_id, 
				ebufp);

		vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_RESOURCE_ID, 
				0, ebufp);
		PIN_FLIST_FLD_SET(bal_flistp, PIN_FLD_RESOURCE_ID,
				vp, ebufp);

		vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_QUANTITY, 
				1, ebufp);
		if (vp != NULL) {
			PIN_FLIST_FLD_SET(bal_flistp, PIN_FLD_QUANTITY,
				vp, ebufp);
		}

		vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_RATE_TAG, 1, ebufp);
		if (vp != NULL) {
			PIN_FLIST_FLD_SET(bal_flistp, PIN_FLD_RATE_TAG,
				vp, ebufp);
		}

		vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_ITEM_OBJ, 0, ebufp);
		PIN_FLIST_FLD_SET(bal_flistp, PIN_FLD_ITEM_OBJ,
			vp, ebufp);

		vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_AMOUNT, 1, ebufp);
		if (vp != NULL) {
			PIN_FLIST_FLD_SET(bal_flistp, PIN_FLD_AMOUNT,
				vp, ebufp);
		}
		vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_IMPACT_TYPE, 1, ebufp);
		if (vp != NULL) {
			PIN_FLIST_FLD_SET(bal_flistp, PIN_FLD_IMPACT_TYPE,
				vp, ebufp);
		}
		vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_DISCOUNT, 1, ebufp);
		if (vp != NULL) {
			PIN_FLIST_FLD_SET(bal_flistp, PIN_FLD_DISCOUNT,
				vp, ebufp);
		}

		vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_TAX_CODE, 1, ebufp);
		if (vp != NULL) {
			PIN_FLIST_FLD_SET(bal_flistp, PIN_FLD_TAX_CODE,
				vp, ebufp);
		}
	}

	*r_flistpp = r_flistp;

	return;
}


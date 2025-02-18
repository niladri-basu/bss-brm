/* file information --- @(#)%% */
/*
 *      Copyright (c) 2001 - 2006 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef lint
static const char Sccs_id[] = "@(#) %full_filespec: fm_reserve_pol_prep_extend.c~3:csrc:1 %";
#endif

#include <stdio.h>
#include <string.h>

#include "pcm.h"
#include "pinlog.h"
#include "ops/reserve.h"
#include "pin_reserve.h"
#include "cm_fm.h"

#define FILE_LOGNAME "fm_reserve_pol_prep_extend.c(1)"


/*******************************************************************
 * Routines contained within.
 *******************************************************************/
EXPORT_OP void op_reserve_pol_prep_extend();


/*******************************************************************
 * Main routine for the PCM_OP_MS_POL_PREP_EXTEND operation.
 *******************************************************************/
void
op_reserve_pol_prep_extend(connp, opcode, flags, in_flistp, ret_flistpp, ebufp)
	cm_nap_connection_t     *connp;
	u_int                   opcode;
	u_int                   flags;
	pin_flist_t             *in_flistp;
	pin_flist_t             **ret_flistpp;
	pin_errbuf_t            *ebufp;
{
	pcm_context_t           *ctxp = connp->dm_ctx;
	int			action = PIN_RESERVATION_SUCCESS;
	void			*vp = NULL;
	time_t			expiration_t = 0;
	time_t			e_time = 0;
	pin_errbuf_t        tempbuf;


	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	*ret_flistpp = NULL;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_RESERVE_POL_PREP_EXTEND) {
		pinlog(FILE_LOGNAME, __LINE__, LOG_FLAG_ERROR,
			"bad opcode (%d) in op_reserve_pol_prep_extend",
			opcode);
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		return;
	}

	/***********************************************************
	 * Debug: What did we get?
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_reserve_pol_prep_extend input flist", in_flistp);

	*ret_flistpp = PIN_FLIST_COPY(in_flistp, ebufp);

	/* Check the EXPIRATION_T to see if it is expired.  If so, do not
	 * allow extension.
	 */
        vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_EXPIRATION_T, 1, ebufp);
        if (vp) {
                expiration_t = *(time_t *)vp;
        } 
	if (expiration_t) {
		vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_END_T, 1, ebufp);
		if (vp) {
			e_time = *(time_t *)vp;
		} else {
			e_time = pin_virtual_time((time_t *)NULL);
		}
		if (expiration_t <= e_time) {
			action = PIN_RESERVATION_FAIL;
			PIN_FLIST_FLD_SET(*ret_flistpp, PIN_FLD_RESERVATION_ACTION, 
				(void*)&action, ebufp);
			pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_APPLICATION,
			PIN_ERR_BAD_VALUE, PIN_FLD_EXPIRATION_T, 0, 0);
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_WARNING,
				"Reservation expired!  Cannot extend.");
			goto cleanup;
			/***********/
		}
	}


cleanup:

	/*****************************************************
	 * Clean up.
	 *****************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_reserve_pol_prep_extend error", ebufp);
                PIN_ERR_CLEAR_ERR(&tempbuf);
                PIN_FLIST_FLD_SET(*ret_flistpp, PIN_FLD_RESERVATION_ACTION,
                        (void*)&action, &tempbuf);
        }

	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_reserve_pol_prep_extend return flist",
		*ret_flistpp);
	return;

}

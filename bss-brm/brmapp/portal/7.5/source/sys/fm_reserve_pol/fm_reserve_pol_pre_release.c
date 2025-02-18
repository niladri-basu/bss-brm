/* Continuus file information --- %full_filespec: fm_reserve_pol_pre_release.c~1:csrc:1 % */
/*
 * @(#) %full_filespec: fm_reserve_pol_pre_release.c~1:csrc:1 %
 *
 *      Copyright (c) 2003 - 2006 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef lint
static const char Sccs_id[] = "@(#) %full_filespec: fm_reserve_pol_pre_release.c~1:csrc:1 %";
#endif

#include <stdio.h>
#include <string.h>

#include "pcm.h"
#include "pinlog.h"
#include "ops/reserve.h"
#include "pin_reserve.h"
#include "cm_fm.h"

#define FILE_LOGNAME "fm_reserve_pol_pre_release.c(1)"


/*******************************************************************
 * Routines contained within.
 *******************************************************************/
EXPORT_OP void op_reserve_pol_pre_release();


/*******************************************************************
 * Main routine for the PCM_OP_MS_POL_PRE_RELEASE operation.
 *******************************************************************/
void
op_reserve_pol_pre_release(connp, opcode, flags, in_flistp, ret_flistpp, ebufp)
	cm_nap_connection_t     *connp;
	u_int                   opcode;
	u_int                   flags;
	pin_flist_t             *in_flistp;
	pin_flist_t             **ret_flistpp;
	pin_errbuf_t            *ebufp;
{
	pcm_context_t           *ctxp = connp->dm_ctx;

	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	*ret_flistpp = NULL;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_RESERVE_POL_PRE_RELEASE) {
		pinlog(FILE_LOGNAME, __LINE__, LOG_FLAG_ERROR,
			"bad opcode (%d) in op_reserve_pol_pre_release",
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
		"op_reserve_pol_pre_release input flist", in_flistp);

	*ret_flistpp = PIN_FLIST_COPY(in_flistp, ebufp);

	/*****************************************************
	 * Clean up.
	 *****************************************************/

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_reserve_pol_pre_release error", ebufp);
	} else {
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_reserve_pol_pre_release return flist",
			*ret_flistpp);
	}

	return;

}



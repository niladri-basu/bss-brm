/*
 *
 *      Copyright (c) 2007 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef lint
static  char    Sccs_id[] = "@(#)%Portal Version: fm_gl_pol_export_gl_custom.c:RWSmod7.3.1Int:1:2007-Sep-07 17:56:38 %";
#endif

#include <stdio.h>
#include "pcm.h"
#include "ops/bill.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pin_bill.h"
#include "pinlog.h"
#include "fm_utils.h"

EXPORT_OP void
op_gl_pol_export_gl(
	cm_nap_connection_t	*connp,
	u_int			opcode,
	u_int			flags,
	pin_flist_t		*in_flistp,
	pin_flist_t		**ret_flistpp,
	pin_errbuf_t		*ebufp);

/*******************************************************************
 * Main routine for the PCM_OP_GL_POL_EXPORT_GL  command
 *******************************************************************/
void
op_gl_pol_export_gl(
	cm_nap_connection_t	*connp,
	u_int			opcode,
	u_int			flags,
	pin_flist_t		*in_flistp,
	pin_flist_t		**ret_flistpp,
	pin_errbuf_t		*ebufp)
{
	pcm_context_t		*ctxp = connp->dm_ctx;
	u_int32			result = 0;
	void			*vp = NULL;
	pin_flist_t		*out_flistp = NULL;
	

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_GL_POL_EXPORT_GL) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"bad opcode in op_gl_pol_export_gl", ebufp);
		return;
	}


	/***********************************************************
	 * Debug: What did we get?
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_gl_pol_export_gl input flist", in_flistp);

	/***********************************************************
	 *  Prepare the output flist
	 ***********************************************************/
	out_flistp = PIN_FLIST_CREATE(ebufp);  
        vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_POID, 0, ebufp);
	PIN_FLIST_FLD_SET(out_flistp, PIN_FLD_POID, vp, ebufp);

	/***********************************************************
	 * Section to customize report
	 ***********************************************************/

	/***********************************************************
	 * Set PIN_FLD_RESULT to 0 if no customization
	 * Set PIN_FLD_RESULT to 1 if report is customized
	 ***********************************************************/
	result = 0;
	PIN_FLIST_FLD_SET(out_flistp, PIN_FLD_RESULT, (void *)&result, ebufp);

	/***********************************************************
	 * Results.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_gl_pol_export_gl error", ebufp);
		PIN_FLIST_DESTROY_EX(&out_flistp, NULL);
		*ret_flistpp = NULL;
	} else {
		/***************************************************
		 * Point the real return flist to the right thing.
		 ***************************************************/
		*ret_flistpp = out_flistp;

		/***************************************************
		 * Debug: What we're sending back.
		 ***************************************************/
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_gl_pol_export_gl return flist", 
			*ret_flistpp);
	}

	return;
}

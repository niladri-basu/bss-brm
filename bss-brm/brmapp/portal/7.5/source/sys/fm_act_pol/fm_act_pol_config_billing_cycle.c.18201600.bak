/*
 * @(#) %full_filespec: fm_act_pol_config_billing_cycle.c~1:csrc:2 %
 *
 *      Copyright (c) 2002 - 2006 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef lint
static const char Sccs_id[] = "@(#) %full_filespec: fm_act_pol_config_billing_cycle.c~1:csrc:2 %";
#endif

#include <stdio.h>
#include <string.h>
#include <time.h>
#include "pcm.h"
#include "ops/act.h"
#include "pin_bill.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pinlog.h"
#include "fm_utils.h"

#define FILE_LOGNAME "fm_act_pol_config_billing_cycle.c(1)"

/*******************************************************************
 * PCM_OP_ACT_POL_CONFIG_BILLING_CYCLE 
 *
 * This policy provides a hook to the OP_ACT_USAGE opcode for pointing 
 * the events coming between the billing time and config_billing_cycle
 * to the items belonging to the current bill or previous bill. The 
 * default implementation will point the events to the current bill.  
 *******************************************************************/

EXPORT_OP void
op_act_pol_config_billing_cycle(
	cm_nap_connection_t	*connp,
	int32			opcode,
	int32			flags,
	pin_flist_t		*i_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp);

static void
fm_act_pol_config_billing_cycle();

/*******************************************************************
 * PCM_OP_ACT_POL_CONFIG_BILLING_CYCLE  
 *******************************************************************/
void 
op_act_pol_config_billing_cycle(
	cm_nap_connection_t	*connp,
	int32			opcode,
	int32			flags,
	pin_flist_t		*i_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp)
{
	pin_flist_t		*r_flistp;


	*r_flistpp = NULL;
	
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERR_CLEAR_ERR(ebufp);

	/*******************************************************************
	 * Insanity Check 
	 *******************************************************************/
	if (opcode != PCM_OP_ACT_POL_CONFIG_BILLING_CYCLE) {
		pin_set_err(ebufp, PIN_ERRLOC_FM, 
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_act_pol_config_billing_cycle error",
			ebufp);
		return;
	}

	/*******************************************************************
	 * Debug: Input flist 
	 *******************************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, 
		"op_act_pol_config_billing_cycle input flist", i_flistp);
	
	/*******************************************************************
	 * Call the default implementation in order to include point the  
	 * event to Items in the current cycle or previous cycle 
	 *******************************************************************/
	fm_act_pol_config_billing_cycle(i_flistp, &r_flistp, ebufp);

	*r_flistpp = r_flistp;

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, 
			"op_act_pol_config_billing_cycle error", ebufp);
	}
	else {
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, 
			"op_act_pol_config_billing_cycle output flist", 
			*r_flistpp);
	}
	return;
}

/*******************************************************************
 * This is the default implementation for this policy which points
 * the events to items in the current cycle or previous cycle.
 *******************************************************************/
static void 
fm_act_pol_config_billing_cycle(
	pin_flist_t		*i_flistp, 
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp)
{
	poid_t          *e_pdp = NULL;
	time_t		*end_tp = NULL;
	time_t		*actg_tp = NULL;
	int32		which_cycle = 0;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	*r_flistpp = PIN_FLIST_CREATE(ebufp);

	e_pdp = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_POID, 0, ebufp);
	PIN_FLIST_FLD_SET(*r_flistpp, PIN_FLD_POID, e_pdp, ebufp); 		

	end_tp = (time_t *)PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_END_T, 0, ebufp);
	actg_tp = (time_t *)PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_ACTG_NEXT_T, 0,
		ebufp);

	if (actg_tp && end_tp && (*end_tp > *actg_tp)) {
		which_cycle = BILL_IN_CURRENT_CYCLE; 
	}	
	else {
		which_cycle = BILL_IN_PREVIOUS_CYCLE; 
	}	
	
	PIN_FLIST_FLD_SET(*r_flistpp, PIN_FLD_FLAGS,  
			(void *)&which_cycle, ebufp);

	/********************************************************* 
	 * Errors..?
	 *********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_act_pol_config_billing_cycle error",ebufp);
	}
	
	return;
}

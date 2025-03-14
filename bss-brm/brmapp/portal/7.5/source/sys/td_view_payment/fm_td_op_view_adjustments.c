/*************************************************************************************
 *  fm_td_op_view_adjustments.c
 *  This custom opcode is to view adjustments of an account for 2d
 *  Calls PCM_OP_AR_GET_ACCT_ACTION_ITEMS opcode internally.
 * Author: Dev /Nigamananda Sahoo
 * Date :02-08-17
 *------------------------------------------------------------------------------------
 * Input flist for the opcode
 *------------------------------------------------------------------------------------
  0 PIN_FLD_POID           POID [0] 0.0.0.1 /account  287464  0
  0 PIN_FLD_BILLINFO           POID [0] 0.0.0.1 /billinfo 287208 0
  0 PIN_FLD_INCLUDE_CHILDREN  INT [0] 0

 *------------------------------------------------------------------------------------
 ************************************************************************************/

#ifndef lint
static char Sccs_id[] = "@(#)$Id: fm_td_op_view_adjustments.c 6922 2013-08-11 %";
#endif

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "pcm.h"
#include "pcm_ops.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pin_os_random.h"
#include "pin_pymt.h"
#include "pin_bill.h"
#include "pin_cust.h"
#include  "ops/pymt.h"
#include "ops/ar.h"
#include "ops/cust.h"

//#include "custom_flds.h"
//#include "custom_consts.h"
#include "custom_opcodes.h"


EXPORT_OP
void op_td_view_adjustments (
    cm_nap_connection_t *connp,
    int32               opcode,
    int32               flags,
    pin_flist_t         *i_flistp,
    pin_flist_t         **r_flistpp,
    pin_errbuf_t        *ebufp);

static void
fm_td_op_view_adjustments (
    pcm_context_t       *ctxp,
    pin_flist_t         *i_flistp,
    pin_flist_t         **r_flistpp,
    pin_errbuf_t        *ebufp);

/*******************************************************************
 * Main routine for the TD_OP_AR_VIEW_ADJUSTMENTS  opcode
 *******************************************************************/

void
op_td_view_adjustments(
    cm_nap_connection_t     *connp,
    int32               opcode,
    int32               flags,
    pin_flist_t         *i_flistp,
    pin_flist_t         **r_flistpp,
    pin_errbuf_t        *ebufp)
{
 	pcm_context_t   *ctxp = connp->dm_ctx;
 	pin_flist_t	*r_flistp = NULL;

 	if (PIN_ERR_IS_ERR(ebufp))
                return;

 	/***********************************************************
      	* Insanity check.
 	***********************************************************/
        if (opcode != TD_OP_AR_VIEW_ADJUSTMENTS ) {
                pin_set_err(ebufp, PIN_ERRLOC_FM, PIN_ERRCLASS_SYSTEM_DETERMINATE,
                        PIN_ERR_BAD_OPCODE, 0, 0, opcode);
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "op_2d_view_adjustments opcode error", ebufp);

                return;
        }
 	/***********************************************************
         * Debug what we got.
 	***********************************************************/
   	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
          	"op_td_view_adjustments input flist", i_flistp);

  	/***********************************************************
         * Main routine for this opcode
   	***********************************************************/
        fm_td_op_view_adjustments(ctxp,i_flistp, &r_flistp, ebufp);

	/***********************************************************
         * Error?
    	***********************************************************/
        if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_FLIST_DESTROY_EX(r_flistpp, ebufp);
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "op_td_view_adjustments error", ebufp);
        }

	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,"op_td_view_adjustments output flist", r_flistp);

	*r_flistpp = r_flistp;

    return;
}

/*******************************************************************
 * fm_td_op_view_adjustments()
 *******************************************************************/
static void
fm_td_op_view_adjustments(
    pcm_context_t       *ctxp,
    pin_flist_t         *i_flistp,
    pin_flist_t         **r_flistpp,
    pin_errbuf_t        *ebufp )
{
	u_int64        	    db = 0;

	pin_flist_t         *get_act_rflistp = NULL;
	pin_flist_t         *res_flistp = NULL;
	pin_flist_t         *misc_flistp = NULL;
	pin_flist_t         *search_inp_flistp = NULL;
	pin_flist_t         *search_output_flistp = NULL;
	pin_flist_t         *arg_flistp = NULL;
	pin_flist_t         *result_search1 = NULL;
	pin_flist_t         *result_search = NULL;
	pin_cookie_t        cookie = NULL;
	int32               elem_id = 0;

	poid_t              *create_poid = NULL;
	poid_t              *acc_poid = NULL;
	poid_t              *it_poid = NULL;


	char                *it_adj = NULL;
	int32               flag1 = SRCH_EXACT;
	char                *template = " select X from /event where F1 = V1 and F2 = V2 and event_t.poid_type like '/event/billing/adjustment%' ";




	if (PIN_ERR_IS_ERR(ebufp)){
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,"fm_td_op_view_adjustments error", ebufp);
		return;
	}
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "fm_td_op_view_adjustments: input flist", i_flistp);

	/*
	 * Call the OOB opcode PCM_OP_AR_GET_ACCT_ACTION_ITEMS 
	*/
	PCM_OP(ctxp,PCM_OP_AR_GET_ACCT_ACTION_ITEMS, 0, i_flistp, &get_act_rflistp, ebufp);


	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "Error on calling PCM_OP_AR_GET_ACCT_ACTION_ITEMS", ebufp);
		return;
	}

	it_poid = (poid_t *)PIN_FLIST_FLD_GET(get_act_rflistp, PIN_FLD_POID, 0, ebufp);
	db = PIN_POID_GET_DB(it_poid);
	it_poid = NULL;
	
	//Loop to traverse all the indexes of the results array.
	elem_id = 0;
	cookie = NULL;
	while ((res_flistp = PIN_FLIST_ELEM_GET_NEXT(get_act_rflistp, PIN_FLD_RESULTS,
						&elem_id, 1, &cookie, ebufp)) != (pin_flist_t *) NULL)
	{
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
							"fm_td_op_view_adjustments: inside while loop",res_flistp);

		it_poid = PIN_FLIST_FLD_GET(res_flistp, PIN_FLD_POID, 0, ebufp);
		it_adj = (char *)PIN_POID_GET_TYPE(it_poid);
	
		if(strcmp(it_adj, "/item/adjustment") == 0)
		{
			
			//Search the EVENT_T table for the item POID value
			search_inp_flistp = PIN_FLIST_CREATE(ebufp);
			create_poid = PIN_POID_CREATE(db, "/search", -1, ebufp);
			PIN_FLIST_FLD_PUT(search_inp_flistp, PIN_FLD_POID, create_poid, ebufp);
			PIN_FLIST_FLD_SET(search_inp_flistp, PIN_FLD_FLAGS, (void *)&flag1, ebufp);
			PIN_FLIST_FLD_SET(search_inp_flistp, PIN_FLD_TEMPLATE,(void *)template, ebufp);
					
			arg_flistp = PIN_FLIST_ELEM_ADD(search_inp_flistp, PIN_FLD_ARGS, 1, ebufp);
			PIN_FLIST_FLD_SET(arg_flistp, PIN_FLD_ITEM_OBJ, it_poid, ebufp);
			
			arg_flistp = PIN_FLIST_ELEM_ADD(search_inp_flistp, PIN_FLD_ARGS, 2, ebufp);
			PIN_FLIST_FLD_COPY(res_flistp,PIN_FLD_ACCOUNT_OBJ,arg_flistp, PIN_FLD_ACCOUNT_OBJ, ebufp);
			//Setting Results
			result_search = PIN_FLIST_ELEM_ADD(search_inp_flistp, PIN_FLD_RESULTS, PIN_ELEMID_ANY, ebufp);

			PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "fm_td_op_view_adjustments: PCM_OP_SEARCH input flist", search_inp_flistp);
			PCM_OP(ctxp, PCM_OP_SEARCH, 0, search_inp_flistp, &search_output_flistp, ebufp);
			PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "fm_td_op_view_adjustments: PCM_OP_SEARCH output flist", search_output_flistp);

			result_search1 = PIN_FLIST_ELEM_GET(search_output_flistp, PIN_FLD_RESULTS, PIN_ELEMID_ANY, 1, ebufp);
			if(result_search1 != NULL)
			{
				PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "fm_td_op_view_adjustments: res_flistp before adding fields", res_flistp);
				misc_flistp = (pin_flist_t*) PIN_FLIST_ELEM_GET(result_search1, PIN_FLD_EVENT_MISC_DETAILS, PIN_ELEMID_ANY, 1, ebufp);
				if(misc_flistp != NULL)
				{
					PIN_FLIST_FLD_COPY(misc_flistp, PIN_FLD_REASON_ID , res_flistp, PIN_FLD_REASON_ID , ebufp);
					PIN_FLIST_FLD_COPY(misc_flistp, PIN_FLD_REASON_DOMAIN_ID , res_flistp, PIN_FLD_REASON_DOMAIN_ID , ebufp);
					PIN_FLIST_FLD_COPY(result_search1, PIN_FLD_DESCR , res_flistp, PIN_FLD_EVENT_DESCR , ebufp);
				}
				PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "fm_td_op_view_adjustments: res_flistp after adding fields", res_flistp);
			}
			
			//Clear memory
			PIN_FLIST_DESTROY_EX(&search_inp_flistp,NULL);
			PIN_FLIST_DESTROY_EX(&search_output_flistp,NULL);
			
		}
		
	}


	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, " modified output of PCM_OP_AR_GET_ACCT_ACTION_ITEMS",get_act_rflistp);

	*r_flistpp = get_act_rflistp;

}




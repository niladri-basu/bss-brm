/*******************************************************************
 *
 *      Copyright (c) 1999-2006 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static  char Sccs_Id[] = "@(#)%Portal Version: fm_cust_pol_valid_limit.c:BillingVelocityInt:2:2006-Sep-05 04:32:29 %";
#endif

#include <stdio.h>
#include "pcm.h"
#include "ops/cust.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pin_cust.h"
#include "pinlog.h"
#include "ops/subscription.h"
#define	STRLEN 256

EXPORT_OP void
op_cust_pol_valid_limit(
        cm_nap_connection_t	*connp,
	u_int			opcode,
        u_int			flags,
        pin_flist_t		*in_flistp,
        pin_flist_t		**ret_flistpp,
        pin_errbuf_t		*ebufp);
 
static void
fm_cust_pol_valid_limit(
	cm_nap_connection_t     *connp,
	//pcm_context_t		*ctxp,
	pin_flist_t		*in_flistp,
	pin_flist_t		**out_flistpp,
        pin_errbuf_t		*ebufp);

/*******************************************************************
 * Main routine for the PCM_OP_CUST_POL_VALID_LIMIT operation.
 *******************************************************************/
void
op_cust_pol_valid_limit(
        cm_nap_connection_t	*connp,
	u_int			opcode,
        u_int			flags,
        pin_flist_t		*in_flistp,
        pin_flist_t		**ret_flistpp,
        pin_errbuf_t		*ebufp)
{
	pcm_context_t		*ctxp = connp->dm_ctx;
	pin_flist_t		*r_flistp = NULL;


	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	*ret_flistpp = NULL;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_CUST_POL_VALID_LIMIT) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"bad opcode in op_cust_pol_valid_limit", ebufp);
		return; 
	}

	/***********************************************************
	 * Debug: what did we get?
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_cust_pol_valid_limit input flist", in_flistp);

	/***********************************************************
	 * Call main function to do it
	 ***********************************************************/
	//fm_cust_pol_valid_limit(ctxp, in_flistp, &r_flistp, ebufp);
	fm_cust_pol_valid_limit(connp, in_flistp, &r_flistp, ebufp);
	/***********************************************************
	 * Results.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		*ret_flistpp = (pin_flist_t *)NULL;
		PIN_FLIST_DESTROY(r_flistp, NULL);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_cust_pol_valid_limit error", ebufp);
	} else {
		*ret_flistpp = r_flistp;
		PIN_ERR_CLEAR_ERR(ebufp);
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_cust_pol_valid_limit return flist", r_flistp);
	}

	return;
}

/*******************************************************************
 * fm_cust_pol_valid_limit()
 *
 *	Validate the aac info for an account/service.
 *
 *	XXX NOOP - STUBBED ONLY - ALWAYS RETURN PASS XXX
 *
 *******************************************************************/
static void
fm_cust_pol_valid_limit(
	cm_nap_connection_t     *connp,
//	pcm_context_t		*ctxp,
	pin_flist_t		*in_flistp,
	pin_flist_t		**out_flistpp,
        pin_errbuf_t		*ebufp)
{
	
        pcm_context_t           *ctxp = connp->dm_ctx;
        void                                    *vp = NULL;
        u_int                                   result = PIN_CUST_VERIFY_PASSED;
        int32                                   elem_id = 0;
        pin_flist_t                             *limit_flistp = NULL;
        poid_t                                  *bal_grp_pdp = NULL;
        poid_t                                  *acct_pdp = NULL;
        char                                    *type = "H_CE";

        int64                                   db = 1;
        pin_cookie_t                    cookie = NULL;
        char                                    *poid_type = NULL;
        int64                                   id = 0;

        pin_flist_t             *res_flistp = NULL;
        pin_flist_t             *search_flistp = NULL;
        pin_flist_t             *search_res_flistp = NULL;
        poid_t                                  *s_pdp = NULL;
        pin_flist_t             *args_flistp = NULL;
        pin_flist_t             *temp_flist = NULL;
        pin_flist_t             *balmon_in_flistp = NULL;
	    void                    *vptr = NULL;


	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Create outgoing flist
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                "in fm_cust_pol_valid_limit input flist", in_flistp);

        if (fm_utils_op_is_ancestor(connp->coip, PCM_OP_CUST_UPDATE_CUSTOMER))
        {
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"Input flist creation with bal monitor object");
        
		while ((limit_flistp = PIN_FLIST_ELEM_GET_NEXT
                (in_flistp,PIN_FLD_LIMIT,&elem_id, 1,&cookie, ebufp)) != NULL ){

			bal_grp_pdp = (poid_t *)PIN_FLIST_FLD_GET(limit_flistp,PIN_FLD_BAL_GRP_OBJ,1,ebufp);
			poid_type =(char *) PIN_POID_GET_TYPE(bal_grp_pdp);

			if(strcmp(poid_type,"/balance_group/monitor")) {
			
				acct_pdp = (poid_t *)PIN_FLIST_FLD_GET(in_flistp,PIN_FLD_POID,0,ebufp);
				/*********************************************************************************
				* Search for the balance monitor object
				* - if found pass the obj id else null   ---added by Dev
				**********************************************************************************/
				search_flistp  = PIN_FLIST_CREATE(ebufp);
				s_pdp = PIN_POID_CREATE(PIN_POID_GET_DB((poid_t *)vp), "/search", -1, ebufp);
				PIN_FLIST_FLD_PUT(search_flistp, PIN_FLD_POID, s_pdp, ebufp);
				PIN_FLIST_FLD_SET(search_flistp, PIN_FLD_FLAGS, 0, ebufp);
				PIN_FLIST_FLD_SET(search_flistp, PIN_FLD_TEMPLATE,
							(void *)" select X from /balance_group where F1 = V1 ", ebufp);

				args_flistp = PIN_FLIST_ELEM_ADD(search_flistp, PIN_FLD_ARGS, 1, ebufp);
				PIN_FLIST_FLD_SET(args_flistp, PIN_FLD_ACCOUNT_OBJ, acct_pdp, ebufp);
				
				args_flistp = PIN_FLIST_ELEM_ADD(search_flistp, PIN_FLD_ARGS, 2, ebufp);
                                PIN_FLIST_FLD_SET(args_flistp, PIN_FLD_POID, "/balance_group/monitor", ebufp);
   
				res_flistp = PIN_FLIST_ELEM_ADD(search_flistp, PIN_FLD_RESULTS,PIN_ELEMID_ANY, ebufp);
				PIN_FLIST_FLD_SET(res_flistp, PIN_FLD_POID, (void *)NULL, ebufp);
					
				PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
									"fm_cust_pol_valid_limit search input flist", search_flistp);

				PCM_OP(ctxp, PCM_OP_SEARCH, 0, search_flistp, &search_res_flistp, ebufp);


				PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
								"fm_cust_pol_valid_limit search result flist", search_res_flistp);

				temp_flist = PIN_FLIST_ELEM_GET(search_res_flistp, PIN_FLD_RESULTS, 0, 0, ebufp);
						
				vptr = PIN_FLIST_FLD_GET(temp_flist, PIN_FLD_POID, 1, ebufp);
				
					/*Release Memory*/
				PIN_FLIST_DESTROY_EX( &search_flistp, NULL );
				PIN_FLIST_DESTROY_EX( &search_res_flistp, NULL );
				
				/*Now make a copy of the input flist*/
				balmon_in_flistp = PIN_FLIST_COPY(in_flistp,ebufp);
				temp_flist = PIN_FLIST_ELEM_GET(balmon_in_flistp, PIN_FLD_LIMIT, 0, 0, ebufp);
				PIN_FLIST_FLD_SET(temp_flist, PIN_FLD_BAL_GRP_OBJ, vptr, ebufp);
				
				res_flistp = NULL;
				PCM_OP(ctxp, PCM_OP_CUST_UPDATE_CUSTOMER, 0, balmon_in_flistp, &res_flistp, ebufp);
		
				if (PIN_ERR_IS_ERR(ebufp)) {
					PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
										"fm_cust_pol_valid_limit error", ebufp);
					PIN_FLIST_DESTROY_EX( &balmon_in_flistp,ebufp);

				}
				
				PIN_FLIST_DESTROY_EX( &balmon_in_flistp,ebufp);

				/*Return the result as Verification Failed*/
				*out_flistpp = PIN_FLIST_CREATE(ebufp);
				PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_POID, vp, ebufp);
				
				result = PIN_CUST_VERIFY_FAILED;
				vp = (void *)&result;
				PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_RESULT, vp, ebufp);
				
				return;
		}
		
	  }
	}
	*out_flistpp = PIN_FLIST_CREATE(ebufp);
	PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_POID, vp, ebufp);

	vp = (void *)&result;
	PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_RESULT, vp, ebufp);

	/***********************************************************
	 * Error?
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_valid_limit error", ebufp);
	}

	
	return;
}

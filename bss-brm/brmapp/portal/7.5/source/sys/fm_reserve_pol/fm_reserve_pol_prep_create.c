/*******************************************************************
 *
 * Copyright (c) 2001, 2009, Oracle and/or its affiliates. All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static const char Sccs_id[] = "@(#)$Id: fm_reserve_pol_prep_create.c st_cgbubrm_lnandi_bug-8362448/1 2009/03/26 01:16:58 lnandi Exp $";
#endif

#include <stdio.h>
#include <string.h>

#include <pcm.h>
#include <pinlog.h>
#include "ops/reserve.h"
#include "pin_reserve.h"
#include "cm_fm.h"
#include "fm_utils.h"
#include "fm_bill_utils.h"

#define FILE_SOURCE_ID "fm_reserve_pol_prep_create.c(11)"
#define MAX_STR_LEN 256

/*******************************************************************
 * Routines contained within.
 *******************************************************************/
EXPORT_OP void op_reserve_pol_prep_create();

/*******************************************************************
 * Assume to enforce PIN_FLD_RESERVATION_NO unique accross all
 * the (both active and release) reservation objects of the account.
 *******************************************************************/
#define NEED_ENFORCE_RESERVATION_NO_UNIQUE (1)

char *fm_reserve_pol_prep_create_reservation_no( );
int32 fm_reserve_pol_res_no_is_unique();

/*******************************************************************
 * Main routine for the PCM_OP_MS_POL_SPEC_RESERVATIONS operation.
 *******************************************************************/
void
op_reserve_pol_prep_create(connp, opcode, flags, in_flistp, ret_flistpp, ebufp)
	cm_nap_connection_t     *connp;
	u_int		   opcode;
	u_int		   flags;
	pin_flist_t	     *in_flistp;
	pin_flist_t	     **ret_flistpp;
	pin_errbuf_t	    *ebufp;
{
	pcm_context_t	   *ctxp = connp->dm_ctx;
	int32			ret_status = PIN_RESERVATION_SUCCESS;
	void			*vp = NULL;
	char			*rp = NULL;
	u_int32			n =0;
	pin_errbuf_t	    tempbuf;

	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	*ret_flistpp = NULL;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_RESERVE_POL_PREP_CREATE) {
		pinlog(FILE_SOURCE_ID, __LINE__, LOG_FLAG_ERROR,
			"bad opcode (%d) in op_reserve_pol_prep_create",
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
		"op_reserve_pol_prep_create input flist", in_flistp);

	*ret_flistpp = PIN_FLIST_COPY(in_flistp, ebufp);

	/***********************************************************
	 * Play with PIN_FLD_RESERVATION_NO.
	 * 1. If it is not in input flist, create one.
	 * 2. If it is in input flist, make sure it is unique.
	 ***********************************************************/
	vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_RESERVATION_NO, 1, ebufp);
        if (!vp) {
                /* since we are creating the number, we should be unique. */
                rp = fm_reserve_pol_prep_create_reservation_no();
                while ((ret_status = fm_reserve_pol_res_no_is_unique(ctxp, in_flistp, rp, ebufp))
                        != PIN_RESERVATION_SUCCESS) {
                        n = (n+1) % 10;
                        /* Sleep for n milliseconds before trying to get the number again */
                        pin_msec_sleep(n);
			if(rp){
				pin_free(rp);
				rp = NULL;
			}
			if (PIN_ERR_IS_ERR(ebufp) && 
				(ret_status != PIN_RESERVATION_DUPLICATE)){
				goto Cleanup;
			}
                        rp = fm_reserve_pol_prep_create_reservation_no();

                }
		PIN_ERR_CLEAR_ERR(ebufp);
                PIN_FLIST_FLD_PUT(*ret_flistpp, PIN_FLD_RESERVATION_NO,
                        rp, ebufp);
        } else {
                if ((ret_status = fm_reserve_pol_res_no_is_unique(ctxp, in_flistp, vp, ebufp))
			!= PIN_RESERVATION_SUCCESS) {
                        /*********************************
                         * Reservation not unique, return.
                         *********************************/
                        goto Cleanup;
                }

	}
	/*****************************************************
	 * Clean up.
	 *****************************************************/
Cleanup:
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_reserve_pol_prep_create error", ebufp);
		PIN_ERR_CLEAR_ERR(&tempbuf);
		PIN_FLIST_FLD_SET(*ret_flistpp, PIN_FLD_RESERVATION_ACTION, 
			(void*)&ret_status, &tempbuf);
	} else {
		PIN_FLIST_FLD_SET(*ret_flistpp, PIN_FLD_RESERVATION_ACTION, 
			(void*)&ret_status, ebufp);
	}
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_reserve_pol_prep_create return flist", *ret_flistpp);
	return;
}


/**************************************************************************
 * This function is to generate a reservation number if it is not in
 * the input flist.
 **************************************************************************/
char *fm_reserve_pol_prep_create_reservation_no( )
{
	char    *reservation_no = NULL;
	reservation_no = (char *)pin_malloc(MAX_STR_LEN);
        if (!reservation_no) {
          return NULL;
        }
	memset(reservation_no, 0, MAX_STR_LEN);
	fm_utils_bill_get_unique_id(reservation_no, MAX_STR_LEN);

	return reservation_no;
}

/**************************************************************************
 * This function is to check if this reservation number is unique or not.
 * If enforcing unique is not needed, simply return 1.
 **************************************************************************/
int32 fm_reserve_pol_res_no_is_unique(
	pcm_context_t   *ctxp,
	pin_flist_t	*i_flistp,
	char		*rp,
	pin_errbuf_t	*ebufp)
{
	pin_flist_t	*s_flistp = NULL;
	pin_flist_t	*tmp_flistp = NULL;
	pin_flist_t	*sr_flistp = NULL;
	void		*vp = NULL;
	poid_t		*s_pdp = NULL;
	poid_t		*a_pdp = NULL;
	poid_t		*b_pdp = NULL;
	poid_t		*bal_grp_poid = NULL;
	int32		res = 0;
	int32		flag = 0;
	int32		found = 0;
	int32		rec_id = 0;
	int32		status = 1;
	int32           is_unique = PIN_RESERVATION_SUCCESS;
	 pin_cookie_t    cookie = NULL;
	char		*template =
		"select X from /reservation where F1 = V1 ";
	char		*template1 =
		"select X from /reservation/active where F1 = V1 ";
	char            *reserve_type  = NULL;

	if (!NEED_ENFORCE_RESERVATION_NO_UNIQUE) {
		return is_unique;
	}

	s_flistp = PIN_FLIST_CREATE(ebufp);
	a_pdp = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_POID, 0, ebufp);
	s_pdp = PIN_POID_CREATE(
			pin_poid_get_db(a_pdp), "/search", -1, ebufp);
	PIN_FLIST_FLD_PUT(s_flistp, PIN_FLD_POID, s_pdp, ebufp);

	/* Create the template . Read the PIN_FLD_RESERVAITON_OBJ to 
	 * get the class type , if not passed use reservation as the
	 * default class to search.
	 */
        vp =  PIN_FLIST_FLD_GET(i_flistp,PIN_FLD_RESERVATION_OBJ, 1, ebufp);
        if (vp) {
                reserve_type = (char*) PIN_POID_GET_TYPE(vp);

		/* The object type has been set, validate it . The valid classes 
		 * are /reservation and /reservation/active.
		 */
		if (!((strcmp(reserve_type, PIN_OBJ_TYPE_RESERVATION) == 0) ||
                        (strcmp(reserve_type,  PIN_OBJ_TYPE_RESERVATION_ACTIVE) == 0))) {
                        pin_set_err(ebufp, PIN_ERRLOC_FM,
                        PIN_ERRCLASS_APPLICATION, PIN_ERR_BAD_TYPE,
                        PIN_FLD_RESERVATION_OBJ, 0, 0);

                        PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        " Invalid reservation type", ebufp);
                        free(reserve_type);
			goto CleanUp;
		}
		/* Now set the template based on object type */

		if (strcmp(reserve_type, PIN_OBJ_TYPE_RESERVATION) == 0) {
			PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_TEMPLATE, template, ebufp);
		} else {
			PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_TEMPLATE, template1, ebufp);
		}
        } else { /* Object type not passed, set the default template */
		PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_TEMPLATE, template, ebufp);
        }

	PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_FLAGS, &flag, ebufp);

	PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_INDEX_NAME,
			(void*) "reservation_reserve_no_i", ebufp);

	tmp_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS, 1, ebufp);
	PIN_FLIST_FLD_SET(tmp_flistp, PIN_FLD_RESERVATION_NO, rp, ebufp);

	b_pdp = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_BAL_GRP_OBJ, 0, ebufp);
	PIN_FLIST_ELEM_SET(s_flistp, NULL,
			PIN_FLD_RESULTS, PIN_ELEMID_ANY, ebufp);

	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"The search flist for RESERVATION_NO", s_flistp);

	PCM_OP(ctxp, PCM_OP_SEARCH, PCM_OPFLG_SEARCH_SDS | PCM_OPFLG_CACHEABLE, 
		s_flistp, &sr_flistp, ebufp);

	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"The search result for RESERVATION_NO", sr_flistp);

	/* Check if opcode call was successful */
	if (PIN_ERR_IS_ERR(ebufp)) {
		is_unique = PIN_RESERVATION_FAIL;
		goto CleanUp;
	}

	/* The search might have returned more than one objects. 
	 * Now filter them to find the object we want. The status of this 
 	 * object should not be RESERVED and the balnce group poid should
	 * not match our input balance grouppoid. 
	 */
	found = 0;
	while ( tmp_flistp = PIN_FLIST_ELEM_GET_NEXT(sr_flistp, PIN_FLD_RESULTS,
			&rec_id, 1, &cookie, ebufp))  {
		vp = PIN_FLIST_FLD_GET(tmp_flistp, PIN_FLD_RESERVATION_STATUS, 1, ebufp);
		if (vp) {
			status = *(int*) vp;
			if ( status != PIN_RESERVATION_RESERVED) {
				continue;
			}
		}
		bal_grp_poid = PIN_FLIST_FLD_GET(tmp_flistp, PIN_FLD_BAL_GRP_OBJ, 0, ebufp);
		if (0 == PIN_POID_COMPARE(bal_grp_poid, b_pdp,0, ebufp)){
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
				"We found atleast one more reservation object");
			found ++ ;
		}
	}
	/* Now validate we dont have any object already */
	if (found > 0) {
		is_unique = PIN_RESERVATION_DUPLICATE;

		pin_set_err(ebufp, PIN_ERRLOC_FM,
		PIN_ERRCLASS_APPLICATION, PIN_ERR_DUPLICATE,
		PIN_FLD_RESERVATION_NO, 0, 0);
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_ERROR,
			"The RESERVATION_NO is duplicate", sr_flistp);
		goto CleanUp;
	}

CleanUp :
	PIN_FLIST_DESTROY_EX(&s_flistp, NULL);
	PIN_FLIST_DESTROY_EX(&sr_flistp, NULL);

	return is_unique;
}

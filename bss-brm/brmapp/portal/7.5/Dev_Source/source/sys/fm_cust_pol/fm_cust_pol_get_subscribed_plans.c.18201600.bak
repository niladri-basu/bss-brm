/*******************************************************************
 *
* Copyright (c) 2006, 2011, Oracle and/or its affiliates. All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static  char Sccs_Id[] = "@(#)$Id: fm_cust_pol_get_subscribed_plans.c /cgbubrm_main.rwsmod/2 2011/10/17 04:04:55 srewanwa Exp $";
#endif

/*******************************************************************
 * Contains the PCM_OP_CUST_POL_GET_SUBSCRIBED_PLANS policy operation.
 *
 * Retrieves the list of plans and deals owned by the given account 
 * and list of deals in the plan(s) that can be bought.  
 *
 *******************************************************************/

#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <ctype.h>

#include "pcm.h"
#include "ops/cust.h"
#include "ops/subscription.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pin_bill.h"
#include "pin_cust.h"
#include "pinlog.h"
#include "fm_utils.h"


#define FILE_SOURCE_ID	"fm_cust_pol_get_subscribed_plans.c(8)"

void
EXPORT_OP  op_cust_pol_get_subscribed_plans(
        cm_nap_connection_t	*connp,
	u_int			opcode,
        u_int			flags,
        pin_flist_t		*i_flistp,
        pin_flist_t		**o_flistpp,
        pin_errbuf_t		*ebufp);


void
fm_cust_pol_get_subscribed_plans(
	pcm_context_t		*ctxp,
	pin_flist_t		*i_flistp,
	pin_flist_t		**o_flistpp,
        pin_errbuf_t		*ebufp);

void
fm_cust_pol_get_unique_plans_from_acct(
        pcm_context_t   *ctxp,
        poid_t          *a_pdp,
        pin_flist_t     **plan_flistp,
        pin_flist_t     **ap_flistp,
        pin_errbuf_t    *ebufp);

void
fm_cust_pol_mark_plan(
        pcm_context_t   *ctxp,
        pin_flist_t     *ap_flistp,
        pin_flist_t     *r_flistp,
        pin_errbuf_t    *ebufp);

void
fm_cust_pol_prepare_return_flist(
        pcm_context_t   *ctxp,
        poid_t     	*p_obj,
        pin_flist_t     *r_flistp,
        pin_errbuf_t    *ebufp);

void
fm_cust_pol_mark_service_and_deal(
        pcm_context_t   *ctxp,
        poid_t          *plan_obj,
        poid_t		*s_obj,
        poid_t          *deal_obj,
	int32           package_id,
        pin_flist_t     *r_flistp,
        pin_errbuf_t    *ebufp);

void
fm_cust_pol_set_subscription_obj(
         pcm_context_t   *ctxp,
         pin_flist_t     *i_flistp,
         pin_errbuf_t    *ebufp);

/*******************************************************************
 * Main routine for the PCM_OP_CUST_POL_GET_SUBSCRIBED_PLANS operation. 
 *******************************************************************/
void
op_cust_pol_get_subscribed_plans(
        cm_nap_connection_t	*connp,
	u_int			opcode,
        u_int			flags,
        pin_flist_t		*i_flistp,
        pin_flist_t		**o_flistpp,
        pin_errbuf_t		*ebufp)
{
	pcm_context_t		*ctxp = connp->dm_ctx;
	pin_flist_t		*r_flistp = NULL;

	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	*o_flistpp = NULL;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_CUST_POL_GET_SUBSCRIBED_PLANS) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"bad opcode in op_cust_pol_get_subscribed_plans", ebufp);
		return;
	}

	/***********************************************************
	 * Debug: What did we get?
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_cust_pol_get_subscribed_plans input flist", i_flistp);

	/***********************************************************
	 * Call main function to do it
	 ***********************************************************/
	fm_cust_pol_get_subscribed_plans(ctxp, i_flistp, &r_flistp, ebufp);

	/***********************************************************
	 * Set the results.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		*o_flistpp = (pin_flist_t *)NULL;
		PIN_FLIST_DESTROY(r_flistp, NULL);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_cust_pol_get_subscribed_plans error", ebufp);
	} else {
		*o_flistpp = r_flistp;
		PIN_ERR_CLEAR_ERR(ebufp);
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_cust_pol_get_subscribed_plans return flist", r_flistp);
	}

	return;
}

/*******************************************************************
 * fm_cust_pol_get_subscribed_plans()
 *
 *	Retrieves the unique plans from the account. 
 * 	Prepare the return flist.
 *	Mark the services/deals owned by the account. 
 * 	  
 *******************************************************************/
void
fm_cust_pol_get_subscribed_plans(
	pcm_context_t	*ctxp,
	pin_flist_t	*i_flistp,
	pin_flist_t	**o_flistpp,
        pin_errbuf_t	*ebufp)
{
	pin_flist_t	*pl_flistp = NULL;
	pin_flist_t	*ap_flistp = NULL;
	pin_flist_t	*r_flistp = NULL;
	poid_t		*a_pdp = NULL;
	pin_cookie_t	cookie = NULL;
	int32		rec_id = 0;
	void		*vp = NULL;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/*
	 * Use the incoming poid for db number
	 */
	a_pdp = (poid_t *)PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_POID, 0, ebufp);

	fm_cust_pol_get_unique_plans_from_acct(ctxp, a_pdp, &pl_flistp, 
		&ap_flistp, ebufp);

	r_flistp = PIN_FLIST_CREATE(ebufp);
	/* Copy the poid from the input flist */
	PIN_FLIST_FLD_SET(r_flistp, PIN_FLD_POID, (void *)a_pdp, ebufp);	

	while ((vp = PIN_FLIST_ELEM_GET_NEXT(pl_flistp, PIN_FLD_PLAN_OBJ, 
		&rec_id, 1, &cookie, ebufp)) != (pin_flist_t *)NULL) {

		fm_cust_pol_prepare_return_flist(ctxp, (poid_t *)vp, 
			r_flistp, ebufp);  
	}

	fm_cust_pol_mark_plan(ctxp, ap_flistp, r_flistp, ebufp);
	fm_cust_pol_set_subscription_obj(ctxp, r_flistp, ebufp);
	*o_flistpp = r_flistp; 

	PIN_FLIST_DESTROY_EX(&pl_flistp, NULL);
	PIN_FLIST_DESTROY_EX(&ap_flistp, NULL);

	/*
	 * Error?
	 */
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_get_subscribed_plans error", ebufp);
	}

	return;
}

/*******************************************************************
 * fm_cust_pol_get_unique_plans_from_acct()
 *
 *******************************************************************/
void 
fm_cust_pol_get_unique_plans_from_acct(
	pcm_context_t	*ctxp,
	poid_t		*a_pdp,
	pin_flist_t	**plan_flistpp,
	pin_flist_t	**ap_flistpp,
	pin_errbuf_t	*ebufp)
{
	pin_flist_t	*a_flistp = NULL;
	pin_flist_t	*r_flistp = NULL;
	pin_flist_t	*t_flistp = NULL;
	void 		*vp = NULL;
	poid_t		*ap_plan_obj = NULL; 
	pin_cookie_t	cookie = NULL;
	pin_cookie_t	d_cookie = NULL;
	int32		rec_id = 0;
	int32		rec_id1 = 0;
	int		found = 0;
	int		cnt = 0;
	int32		*status_flagp = NULL;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	a_flistp = PIN_FLIST_CREATE(ebufp);
	PIN_FLIST_FLD_SET(a_flistp, PIN_FLD_POID, (void *)a_pdp, ebufp);
	PIN_FLIST_FLD_SET(a_flistp, PIN_FLD_SCOPE_OBJ, (void *)a_pdp, ebufp);
	PIN_FLIST_ELEM_SET(a_flistp, NULL, PIN_FLD_PRODUCTS, PIN_ELEMID_ANY,
		 ebufp);
	PCM_OP(ctxp, PCM_OP_SUBSCRIPTION_GET_PURCHASED_OFFERINGS, 0, a_flistp, 
		ap_flistpp, ebufp);

	r_flistp = PIN_FLIST_CREATE(ebufp);
	while ((t_flistp = PIN_FLIST_ELEM_GET_NEXT(*ap_flistpp,PIN_FLD_PRODUCTS,
		&rec_id, 1, &cookie, ebufp)) != (pin_flist_t *)NULL) {
		
		ap_plan_obj = (poid_t *)PIN_FLIST_FLD_GET(t_flistp, 
			PIN_FLD_PLAN_OBJ, 0, ebufp);	
		if (ap_plan_obj == NULL || PIN_POID_IS_NULL(ap_plan_obj)) {
			continue;
		}

		/**************************************************************
		 * If the product's status_flag = "DUE_TO_TRANSITION" then
		 * skip adding the plan to the return flist. Products may
		 * exist in the account_products array in the cancelled 
		 * status and the corresponding plan might have been 
		 * already transitioned to another Plan. So, the old plans
		 * are not shown.  
 		 *************************************************************/
		status_flagp = (int32 *)PIN_FLIST_FLD_GET(t_flistp, 
			PIN_FLD_STATUS_FLAGS, 0,ebufp);
	
		if (status_flagp && 
			(*status_flagp & PIN_STATUS_FLAG_DUE_TO_TRANSITION)) { 
			continue;
		}

		/* Drop duplicate Plans */
		d_cookie = NULL;
		rec_id1 = 0;
		found =0;
		while ((vp = PIN_FLIST_ELEM_GET_NEXT(r_flistp, 
			PIN_FLD_PLAN_OBJ, &rec_id1, 1, &d_cookie, ebufp)) != 
			(pin_flist_t *)NULL) {
			if (PIN_POID_COMPARE((poid_t *)vp, ap_plan_obj,0,
				 ebufp) == 0) {
				found = 1;
				break; 	
			}
		}
		/* If Plan not already added to the list, add it */
		if (!found) {
			PIN_FLIST_ELEM_SET(r_flistp, (void *)ap_plan_obj, 
				PIN_FLD_PLAN_OBJ, cnt, ebufp);
			cnt++;
		}
	} 	

	*plan_flistpp = r_flistp;
	PIN_FLIST_DESTROY_EX(&a_flistp, NULL);
	
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_get_unique_plans_from_acct error", ebufp);
	}
}

/*******************************************************************
 * fm_cust_pol_prepare_return_flist()
 * 	Prepare the return flist with the Plans in the account. 
 *******************************************************************/
void 
fm_cust_pol_prepare_return_flist(
	pcm_context_t 	*ctxp, 
	poid_t		*p_obj,
	pin_flist_t	*r_flistp, 
	pin_errbuf_t	*ebufp)
{
	int		cnt = 0;
	int		rec_id = 0;
	int             b_rec_id = 0;
	int             l_rec_id = 0;
	int		d_rec_id = 0;
	pin_flist_t	*t_flistp = NULL;
	pin_flist_t	*s_flistp = NULL;
	pin_flist_t	*pl_flistp = NULL;
	pin_flist_t	*v_flistp = NULL;
	pin_flist_t 	*d_flistp = NULL;
	pin_flist_t 	*deal_flistp = NULL;
	pin_flist_t     *b_flistp = NULL;
	pin_flist_t     *l_flistp = NULL;
	pin_cookie_t	s_cookie = NULL;
	pin_cookie_t	d_cookie = NULL;
	void		*vp = NULL;
	int		bought = PIN_BOOLEAN_FALSE;

	if (PIN_ERR_IS_ERR(ebufp)) 
		return;
	PIN_ERR_CLEAR_ERR(ebufp); 
	
	/* Read the Plan object */
	t_flistp = PIN_FLIST_CREATE(ebufp);
	PIN_FLIST_FLD_SET(t_flistp, PIN_FLD_POID, (void *)p_obj, ebufp);
	PCM_OP(ctxp, PCM_OP_READ_OBJ, 0, t_flistp, &pl_flistp, ebufp);
	PIN_FLIST_DESTROY_EX(&t_flistp, NULL);	

	cnt = PIN_FLIST_ELEM_COUNT(r_flistp, PIN_FLD_PLAN, ebufp);
	v_flistp = PIN_FLIST_ELEM_ADD(r_flistp, PIN_FLD_PLAN, cnt, ebufp);
	PIN_FLIST_FLD_SET(v_flistp, PIN_FLD_PLAN_OBJ, (void *)p_obj, ebufp); 	

        s_cookie = NULL;
        while ((l_flistp = PIN_FLIST_ELEM_TAKE_NEXT(pl_flistp,
                PIN_FLD_LIMIT, &l_rec_id, 1, &s_cookie, ebufp)) !=
                (pin_flist_t *)NULL) {
        	PIN_FLIST_ELEM_PUT(v_flistp, l_flistp,
                        PIN_FLD_LIMIT, l_rec_id, ebufp);

        }

        s_cookie = NULL;
        while ((b_flistp = PIN_FLIST_ELEM_TAKE_NEXT(pl_flistp,
                PIN_FLD_BAL_INFO, &b_rec_id, 1, &s_cookie, ebufp)) !=
                (pin_flist_t *)NULL) {
        	PIN_FLIST_ELEM_PUT(v_flistp, b_flistp,
                        PIN_FLD_BAL_INFO, b_rec_id, ebufp);

        }

	s_cookie = NULL;
	/* Get all the services and deals for this plan */
	while ((s_flistp = PIN_FLIST_ELEM_GET_NEXT(pl_flistp, 
		PIN_FLD_SERVICES, &rec_id, 1, &s_cookie, ebufp)) != 
		(pin_flist_t *)NULL) {
	
		/**************************************************************
	 	 * Check deal_obj inside services array or in
		 * deals array inside services.	This is to handle
		 * existing services having deal_obj at the services
		 * array level 
		 **************************************************************/
		t_flistp = PIN_FLIST_COPY(s_flistp, ebufp);
		PIN_FLIST_FLD_SET(t_flistp, PIN_FLD_BOOLEAN, (void *)&bought,
			 ebufp);
		vp = PIN_FLIST_FLD_GET(t_flistp, PIN_FLD_DEAL_OBJ, 1, ebufp);
		if (vp && !PIN_POID_IS_NULL((poid_t *)vp)) {
			d_flistp = PIN_FLIST_ELEM_ADD(t_flistp, PIN_FLD_DEALS,
				 0, ebufp);
			PIN_FLIST_FLD_SET(d_flistp, PIN_FLD_DEAL_OBJ, vp, 
				ebufp); 
			PIN_FLIST_FLD_DROP(t_flistp, PIN_FLD_DEAL_OBJ, ebufp);	
			PIN_FLIST_FLD_SET(d_flistp, PIN_FLD_BOOLEAN, 
				(void *)&bought, ebufp);
		}	
		else {
			/* deal_obj in PIN_FLD_DEALS array */
			d_cookie = NULL;
			while ((deal_flistp = PIN_FLIST_ELEM_GET_NEXT(t_flistp,
				PIN_FLD_DEALS, &d_rec_id, 1,&d_cookie, ebufp)) 
				!= (pin_flist_t *)NULL) {
				PIN_FLIST_FLD_SET(deal_flistp, PIN_FLD_BOOLEAN, 
					(void *)&bought, ebufp);
			} 
		}
		PIN_FLIST_ELEM_PUT(v_flistp, t_flistp, 
			PIN_FLD_SERVICES, rec_id, ebufp);
	}

	/* Any Account level deal ? */
	vp = PIN_FLIST_FLD_GET(pl_flistp, PIN_FLD_DEAL_OBJ, 1, ebufp);
	if (vp && !PIN_POID_IS_NULL((poid_t *)vp)) {
		PIN_FLIST_FLD_SET(v_flistp, PIN_FLD_DEAL_OBJ, vp,
			ebufp);	
	}

	PIN_FLIST_DESTROY_EX(&pl_flistp, NULL);
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_prepare_return_flist error", ebufp);
	} else {
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"fm_cust_pol_prepare_return_flist return flist", 
			r_flistp);
	}
}


/*******************************************************************
 * fm_cust_pol_mark_plan()
 * 	Find the service match and call the 
 * "fm_cust_pol_mark_service_and_deal" function to mark the service 
 * and deals.  
 *******************************************************************/
void
fm_cust_pol_mark_plan(	
	pcm_context_t 	*ctxp, 
	pin_flist_t	*ap_flistp, 
	pin_flist_t	*r_flistp, 
	pin_errbuf_t	*ebufp)
{

	pin_flist_t	*p_flistp = NULL;
	pin_flist_t	*s_flistp = NULL;
	int32		rec_id = 0; 
	pin_cookie_t	cookie = NULL; 
	poid_t		*s_obj = NULL;
	poid_t		*d_obj = NULL;
	poid_t		*p_obj = NULL;
	void		*vp = NULL;
	int32		package_id = 0;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/**************************************************************
	 * Now read the account products and mark the services and deals
	 * owned
	 **************************************************************/
	cookie = NULL;
	while ((p_flistp = PIN_FLIST_ELEM_GET_NEXT(ap_flistp, PIN_FLD_PRODUCTS, 
		&rec_id, 1, &cookie, ebufp)) != (pin_flist_t *)NULL) {

		/**************************************************************
		 * If the product is cancelled, then don't set the flag 
		 *  the deal owned in the account.
	 	 **************************************************************/
		vp = PIN_FLIST_FLD_GET(p_flistp, PIN_FLD_STATUS, 0, ebufp);
		if (vp && (*(int *)vp == PIN_PRODUCT_STATUS_CANCELLED)) {
			continue;
		} 

		s_obj = (poid_t *)PIN_FLIST_FLD_GET(p_flistp, 
			PIN_FLD_SERVICE_OBJ, 0, ebufp);
		p_obj = (poid_t *)PIN_FLIST_FLD_GET(p_flistp, PIN_FLD_PLAN_OBJ,
			0, ebufp);
		d_obj = (poid_t *)PIN_FLIST_FLD_GET(p_flistp, PIN_FLD_DEAL_OBJ,
			0, ebufp);

		vp = PIN_FLIST_FLD_GET(p_flistp, PIN_FLD_PACKAGE_ID, 0, ebufp);
		if (vp) {
		  package_id = *((int32 *)vp);
	        }


		fm_cust_pol_mark_service_and_deal(ctxp, p_obj, s_obj, d_obj, 
			package_id, r_flistp, ebufp);


		PIN_FLIST_DESTROY_EX(&s_flistp, NULL);
	}	

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_mark_plan error", ebufp);
	} else {
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"fm_cust_pol_mark_plan return flist", r_flistp);
	}
}

/*******************************************************************
 * fm_cust_pol_mark_service_and_deal()
 *  	This function to mark the service and deals in the return
 * flist as the account owns this service/deal.  
 *******************************************************************/
void 
fm_cust_pol_mark_service_and_deal( 
	pcm_context_t 	*ctxp, 
	poid_t		*plan_obj,
	poid_t		*s_obj, 
	poid_t		*deal_obj,
	int32           package_id,

	pin_flist_t	*r_flistp,
	pin_errbuf_t	*ebufp)
{
	int32		bought = PIN_BOOLEAN_TRUE;
	pin_flist_t	*s_flistp = NULL;
	pin_flist_t	*d_flistp = NULL;
	pin_flist_t	*p_flistp = NULL;

	void		*vp = NULL;
	pin_cookie_t	cookie = NULL;
	pin_cookie_t	s_cookie = NULL;
	int32		rec_id = 0;
	int32		p_rec_id = 0;
	int		found = PIN_BOOLEAN_FALSE; 
	

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	while ((p_flistp = PIN_FLIST_ELEM_GET_NEXT(r_flistp, PIN_FLD_PLAN,
		&p_rec_id, 1, &cookie, ebufp)) != (pin_flist_t *)NULL) {		
		vp = PIN_FLIST_FLD_GET(p_flistp, PIN_FLD_PLAN_OBJ, 0, ebufp);
		if (vp && !PIN_POID_COMPARE(vp,plan_obj, 0, ebufp)) {
			found = PIN_BOOLEAN_TRUE;
			break;
		} 
	}

	if (!found) {
		goto Cleanup;
	}

	/* Account Level deal */
	if (s_obj && PIN_POID_IS_NULL(s_obj)) {
		PIN_FLIST_FLD_SET(p_flistp, PIN_FLD_BOOLEAN, (void *)&bought,
			 ebufp);
		found = PIN_BOOLEAN_TRUE;
		goto Cleanup;
	}

	s_cookie = NULL;	
	/* Find the service and deal and Mark it */
	while ((s_flistp = PIN_FLIST_ELEM_GET_NEXT(p_flistp, PIN_FLD_SERVICES,
		 &rec_id, 1, &s_cookie, ebufp)) != (pin_flist_t *)NULL) {
		
		/* Find the deal and mark it */
		found = PIN_BOOLEAN_FALSE;	
		cookie = NULL;

		while ((d_flistp = PIN_FLIST_ELEM_GET_NEXT(s_flistp, 
			PIN_FLD_DEALS, &rec_id, 1, &cookie, ebufp)) != 
			(pin_flist_t *)NULL) {
			vp = PIN_FLIST_FLD_GET(d_flistp, PIN_FLD_DEAL_OBJ, 0,
				 ebufp);
			if (vp && deal_obj && !PIN_POID_COMPARE(vp, deal_obj, 0, 
				ebufp)) {
				vp = PIN_FLIST_FLD_GET(d_flistp, 
					PIN_FLD_BOOLEAN, 0, ebufp);

				if (vp && *(int32 *)vp == PIN_BOOLEAN_TRUE) {
					continue;
				}		
				PIN_FLIST_FLD_SET(d_flistp, PIN_FLD_BOOLEAN, 
					(void *)&bought, ebufp);

				PIN_FLIST_FLD_SET(d_flistp, 
					PIN_FLD_PACKAGE_ID, 
					(void *)&package_id, ebufp);

				found = PIN_BOOLEAN_TRUE;
				break;
			}
		}

		/**************************************************************
		* If not found, try with deal_obj in /service. Because all the 
		* existing services before this release 6.5_FP3 will have one 
		* deal_obj under each services array 
		**************************************************************/
		if (!found) {
			vp = PIN_FLIST_FLD_GET(s_flistp, PIN_FLD_DEAL_OBJ, 1,
				 ebufp);
			if (vp && deal_obj && !PIN_POID_COMPARE(vp, deal_obj, 0, 
				ebufp)) {
				PIN_FLIST_FLD_SET(d_flistp, PIN_FLD_BOOLEAN, 
					(void *)&bought, ebufp);
				found = PIN_BOOLEAN_TRUE;

       				PIN_FLIST_FLD_SET(d_flistp, 
					PIN_FLD_PACKAGE_ID,
					(void *)&package_id, ebufp);
				
			}	
		}
		
		if (found) {
			PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_BOOLEAN, 
				(void *)&bought, ebufp);
			PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_SERVICE_OBJ,
                                (void *)s_obj, ebufp);
			break;
		}
	}

Cleanup:
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_mark_service_and_deal error", ebufp);

	}

	return;
}


/***************************************************************************
* fm_cust_pol_set_subscription_obj()
*       Sets the SUBSCRIPTION_OBJ for each service based on the
*       SUBSCRIPTION_INDEX.
*       We compare the index against the element id of SERVICES array:
*       - If same, it is parent and we set the SUBSCRIPTION_OBJ as NULL poid
*       - If different, we set the SUBSCRIPTION_OBJ as SERVICE_OBJ of the
*       service present with element id as index
***************************************************************************/
void
fm_cust_pol_set_subscription_obj(
         pcm_context_t   *ctxp,
         pin_flist_t     *i_flistp,
         pin_errbuf_t    *ebufp)
{
         pin_flist_t     *pl_flistp = NULL;
         pin_flist_t     *svc_flistp = NULL;
         pin_flist_t     *subs_flistp = NULL;
         pin_flist_t     *tmp_subs_flistp = NULL;
         pin_flist_t     *tmp_svc_flistp = NULL;
         pin_flist_t     *tmp_ip_flistp = NULL;
	 pin_flist_t     *tmp_pl_flistp = NULL;
         poid_t          *s_pdp = NULL;
         pin_cookie_t    cookie = NULL;
         pin_cookie_t    cookie_p = NULL;
         int32           rec_id = 0;
         int32           p_rec_id = 0;
         int32           s_index = 0;
         void            *vp = NULL;

         if (PIN_ERR_IS_ERR(ebufp))
                 return;
         PIN_ERR_CLEAR_ERR(ebufp);

	 /*********************************************
	 * Take a copy of input flist to iterate
	 *********************************************/
	 tmp_ip_flistp = PIN_FLIST_COPY(i_flistp, ebufp);

         while ((tmp_pl_flistp = PIN_FLIST_ELEM_GET_NEXT(tmp_ip_flistp, PIN_FLD_PLAN,
                 &p_rec_id, 1, &cookie_p, ebufp)) != (pin_flist_t *)NULL) {
                 cookie = NULL;
                 rec_id = 0;

                 while ((svc_flistp = PIN_FLIST_ELEM_GET_NEXT(tmp_pl_flistp,
                         PIN_FLD_SERVICES, &rec_id, 1, &cookie, ebufp)) !=
                         (pin_flist_t *)NULL) {
                         vp = PIN_FLIST_FLD_GET(svc_flistp, PIN_FLD_SUBSCRIPTION_INDEX,
                                 1, ebufp);
                         if (vp == (void *)NULL) {
                                continue;
                         }
                         s_index = *(int32 *)vp;
                         if (s_index == rec_id) {
                                /*****************************************************
                                * If the index is same as the element id, the service
                                * is parent, hence set SUBSCRIPTION_OBJ as 0.0.0.0
                                *****************************************************/
                                s_pdp = PIN_POID_FROM_STR("0.0.0.0 0 0", NULL, ebufp);
				pl_flistp = PIN_FLIST_ELEM_GET(i_flistp, PIN_FLD_PLAN,
						p_rec_id, 0, ebufp);
				tmp_subs_flistp = PIN_FLIST_ELEM_GET(pl_flistp, PIN_FLD_SERVICES,
							rec_id, 0, ebufp);
                                PIN_FLIST_FLD_PUT(tmp_subs_flistp, PIN_FLD_SUBSCRIPTION_OBJ,
                                        s_pdp, ebufp);
                         }
                         else {
                                if(subs_flistp == (pin_flist_t *)NULL) {
                                        subs_flistp = PIN_FLIST_CREATE(ebufp);
                                }
                                /*****************************************************
                                * If the index is different, then save it as well as
                                * the element id in an array for later use
                                *****************************************************/
                                tmp_subs_flistp = PIN_FLIST_ELEM_ADD(subs_flistp, PIN_FLD_ARGS,
                                         rec_id, ebufp);
                                PIN_FLIST_FLD_SET(tmp_subs_flistp, PIN_FLD_SUBSCRIPTION_INDEX,
                                         (void *)vp, ebufp);
                         }
                 }

                 PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                                "fm_cust_pol_set_subscription_obj subs_flistp", subs_flistp);
                 /*****************************************************************************
                 * Loop through subs_flistp, find the parent service from pl_flistp and set in
                 * SERVICES array of pl_flistp as the SUBSCRIPTION_OBJ
                 ******************************************************************************/
                 cookie = NULL;
                 rec_id = 0;

		 if (subs_flistp) {
                   while ((svc_flistp = PIN_FLIST_ELEM_GET_NEXT(subs_flistp,
                         PIN_FLD_ARGS, &rec_id, 1, &cookie, ebufp)) !=
                         (pin_flist_t *)NULL) {
                         s_index = *(int32 *)PIN_FLIST_FLD_GET(svc_flistp, PIN_FLD_SUBSCRIPTION_INDEX,
                                 0, ebufp);
			 pl_flistp = PIN_FLIST_ELEM_GET(i_flistp, PIN_FLD_PLAN, p_rec_id,
				 0, ebufp);
			 /****************************************************************
			 * Get the SERVICE_OBJ at s_index in SERVICES, and set it as the
			 * SUBSCRIPTION_OBJ at rec_id in SERVICES
			 ****************************************************************/
                         tmp_svc_flistp = PIN_FLIST_ELEM_GET(pl_flistp, PIN_FLD_SERVICES,
                                 s_index, 0, ebufp);
                         s_pdp = (poid_t *)PIN_FLIST_FLD_GET(tmp_svc_flistp, PIN_FLD_SERVICE_OBJ,
                                 0, ebufp);
			 tmp_subs_flistp = PIN_FLIST_ELEM_GET(pl_flistp, PIN_FLD_SERVICES,
				 rec_id, 0, ebufp);
                         PIN_FLIST_FLD_SET(tmp_subs_flistp, PIN_FLD_SUBSCRIPTION_OBJ,
                                 (void *)s_pdp, ebufp);
                   }
                   PIN_FLIST_DESTROY_EX(&subs_flistp, NULL);
		}
        }

	 PIN_FLIST_DESTROY_EX(&tmp_ip_flistp, NULL);

         if (PIN_ERR_IS_ERR(ebufp)) {
                 PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                         "fm_cust_pol_set_subscription_obj error", ebufp);
         }
         else{
                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "fm_cust_pol_set_subscription_obj return", i_flistp);
         }
         return;
}










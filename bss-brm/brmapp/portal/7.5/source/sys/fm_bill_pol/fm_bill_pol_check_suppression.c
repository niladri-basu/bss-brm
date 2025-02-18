/*
 *
* Copyright (c) 2004, 2010, Oracle and/or its affiliates. All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef lint
static char Sccs_id[] = "@(#)$Id: fm_bill_pol_check_suppression.c /cgbubrm_7.3.2.rwsmod/1 2010/10/28 01:43:48 dbangalo Exp $";
#endif

#include <stdio.h>
#include <string.h>
#include "pin_os_string.h"
#include "pcm.h"
#include "ops/bill.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pin_bill.h"
#include "pin_cust.h"
#include "pin_pymt.h"
#include "pinlog.h"
#include "cm_cache.h"
#include "pin_flds.h"


/*******************************************************************
 * external symbol for suppression_config cm_cache pointer
 *******************************************************************/
extern cm_cache_t *fm_bill_suppression_config_ptr;

EXPORT_OP void
op_bill_pol_check_suppression();

static void
fm_bill_pol_check_suppression(
	pcm_context_t   *ctxp,
	u_int           flags,
	pin_flist_t     *in_flistp,
	pin_flist_t     **ret_flistpp,
	pin_errbuf_t    *ebufp);

static void 
fm_bill_pol_find_min_bal_max_cycle(
	char*		customer_segment_listp, 
	pin_flist_t	**ret_flistpp,
	pin_errbuf_t	*ebufp);

static void
fm_bill_pol_get_suppression_reason(
	pcm_context_t   *ctxp,
	pin_flist_t     *in_sup_flist_p,
	pin_flist_t     *in_flist_billinfo_p,
	pin_flist_t     **ret_flistpp,
	pin_errbuf_t    *ebufp);

static void 
fm_bill_pol_get_payment_adjustment_event (
	pcm_context_t	*ctxp,
	pin_flist_t	*in_flist_billinfo_p,
	pin_flist_t	**PA_event_flistpp,
	pin_errbuf_t	*ebufp);


int32
td_bill_pol_check_service_status(
        pcm_context_t   *ctxp,
        pin_flist_t     *in_flistp,
        pin_errbuf_t    *ebufp);

int32
td_bill_pol_check_events(
        pcm_context_t   *ctxp,
        pin_flist_t     *in_flistp,
        pin_errbuf_t    *ebufp);

/*********************************************************************
 * Main routine for the PCM_OP_BILL_POL_CHECK_SUPPRESSION  opcode
 ********************************************************************/

void
op_bill_pol_check_suppression(
	cm_nap_connection_t	*connp,
	u_int			opcode,
	u_int			flags,
	pin_flist_t		*in_flistp,
	pin_flist_t		**ret_flistpp,
	pin_errbuf_t		*ebufp)
{
	pcm_context_t	*ctxp = connp->dm_ctx;
	pin_flist_t     *r_flistp = NULL;
	char    flag_char[50];
	int32   service_flag = 0;
	int32   event_flag = 0;
        int32   status = 1;
        int32   exception = 0;
        int32   check_flag = 0;
	int32   inactive_status = 3;
	void*	vp = NULL;


	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);	
	/***********************************************************
	 * Debug: What did we get?
	 ***********************************************************/
	 PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, 
		 "op_bill_pol_check_suppression input flist", in_flistp);

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	 if (opcode != PCM_OP_BILL_POL_CHECK_SUPPRESSION) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"bad opcode in op_bill_pol_check_suppression", ebufp);
		return ;
	}

	/***********************************************************
	 * Call main function to do it
	 ***********************************************************/
	 fm_bill_pol_check_suppression(ctxp, flags, in_flistp, 
					&r_flistp, ebufp);

	/***********************************************************
	 * Results.
	 ***********************************************************/
	 if (PIN_ERR_IS_ERR(ebufp)) {
		*ret_flistpp = (pin_flist_t *)NULL;
		PIN_FLIST_DESTROY_EX(&r_flistp, NULL);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_bill_pol_check_suppression error", ebufp);
		return;
	 }
	 
	else {
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                 "op_bill_pol_check_suppression check for exception flist",r_flistp);

		vp = PIN_FLIST_FLD_GET(r_flistp, PIN_FLD_EXCEPTION, 1, ebufp);
		check_flag = *(int *)vp;
		if (check_flag == 0){
			/*if Bill amount is zero*/	
               		 PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"Total_bill_due:");	
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, pbo_decimal_to_str(PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_TOTAL_DUE, 0, ebufp),ebufp));
	
			if(pbo_decimal_is_zero(PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_TOTAL_DUE, 0, ebufp),ebufp)){  
			      /** Call service status check function **/
                 		service_flag = td_bill_pol_check_service_status(ctxp,in_flistp,ebufp);
		                sprintf(flag_char,"%d",service_flag);
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"Service Flag Value");
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,flag_char);

				if(service_flag==1)
				{
					/** Call billing activity status check function **/
					event_flag = td_bill_pol_check_events(ctxp,in_flistp,ebufp);
        	       			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"Event Flag Value");
					sprintf(flag_char,"%d",event_flag);
                 			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,flag_char);
				}
        	         	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
					"flist before adding flag",r_flistp);
                 		if(service_flag == 1 && event_flag ==1) {
                       			 PIN_FLIST_FLD_SET(r_flistp,PIN_FLD_RESULT,(void *)&status,ebufp);
	                         	 PIN_FLIST_FLD_SET(r_flistp,PIN_FLD_EXCEPTION,(void *)&exception,ebufp);
        	                 	 *ret_flistpp = r_flistp;
                	 	}
				else {
                        		status= 0;
	                        	PIN_FLIST_FLD_SET(r_flistp,PIN_FLD_RESULT,(void *)&status,ebufp);
        	                	PIN_FLIST_FLD_SET(r_flistp,PIN_FLD_EXCEPTION,(void *)&exception,ebufp);
                		       *ret_flistpp = r_flistp;
		       		}

		 	}	
                 	else {
		       		*ret_flistpp = r_flistp;
                 	}
		}else {
		
			*ret_flistpp = r_flistp;
		}
         }

	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, 
		"op_bill_pol_check_suppression suppression result flist", 
		*ret_flistpp);
	return ; 
}

/***************************************************************************
 * This is the main function for the opcode. It takes the Customer Segment 
 * Id from the input flist and pass it to fm_bill_pol_find_min_bal_max_cycle
 * method to search through the /config/suppression cache for a suppression
 * info object. 
 * If found it proceeds further calling fm_bill_pol_get_suppression_reason method
 * to check the whether the bill is qualified for suppression? If not 
 * it bails out indicating no suppression to the bill.
***************************************************************************/

static void
fm_bill_pol_check_suppression(
	pcm_context_t  *ctxp,
	u_int	       flags,
	pin_flist_t    *in_flistp,
	pin_flist_t    **ret_flistpp,
	pin_errbuf_t   *ebufp)
{
	int		suppression_flag = (int)PIN_RESULT_FAIL;
	int		exception_flag = (int)PIN_NO_EXCEPTION;
	pin_flist_t	*o_flistp = NULL;
	pin_flist_t	*pol_o_flistp = NULL;
	void		*vp = NULL;
	void            *vp1 = NULL;
	char*		cust_segment_list = NULL;
	poid_t*		billinfopoid = NULL;
	int32		*subordinate_flag = 0;

	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);	
	
	/***********************************************************
	* Initialize the return output flist
	***********************************************************/
	vp = NULL;
	*ret_flistpp = PIN_FLIST_CREATE(ebufp);
	billinfopoid = (poid_t *)PIN_FLIST_FLD_GET(in_flistp, 
					PIN_FLD_POID, 0, ebufp);
	PIN_FLIST_FLD_SET(*ret_flistpp, PIN_FLD_POID, 
					(void *)billinfopoid, ebufp);
	PIN_FLIST_FLD_SET(*ret_flistpp, PIN_FLD_RESULT , vp, ebufp);
	PIN_FLIST_FLD_SET(*ret_flistpp, PIN_FLD_EXCEPTION, vp, ebufp);

	/***********************************************************
	* Is this billinfo of a subordinate account ??
	* if so, need not be checked for suppression, 
	* so un-suppress/finalize the bill.
	***********************************************************/
	vp = NULL;
	vp = PIN_FLIST_FLD_GET(in_flistp, 
			PIN_FLD_PAY_TYPE, 1, ebufp);
	if (vp) {
		subordinate_flag = (int32 *)vp;
	}
	if ( subordinate_flag 
			&& *subordinate_flag == PIN_PAY_TYPE_SUBORD) {
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
			"fm_bill_pol_check_suppression subordinate "
			"billinfo need not suppress");
		goto cleanup;
	}

	/***********************************************************
	* Get the Customer Segment Ids.
	************************************************************/
	vp = NULL;
	vp = PIN_FLIST_FLD_GET(in_flistp, 
			PIN_FLD_CUSTOMER_SEGMENT_LIST, 1, ebufp);
	if (vp) {
		cust_segment_list = (char *)vp;
		/******************************************************
		* If no customer segment id available then take it as 
		* default i.e. zero 
		******************************************************/
		if (strlen(cust_segment_list) == 0) {
			cust_segment_list = "0";
		}
	}
	else {
		/*****************************************************
		* If err in getting customer segment id , take it as 
		* default i.e. zero 
		******************************************************/
		cust_segment_list = "0";
	}

	/***********************************************************
	 * Find the Threshold and Cycle Suppress from the config object.
	 ***********************************************************/
	cust_segment_list = pin_strdup(cust_segment_list);	
	fm_bill_pol_find_min_bal_max_cycle(cust_segment_list, &o_flistp, ebufp);
	pin_free(cust_segment_list);	
	if ( PIN_ERR_IS_ERR(ebufp) ) {
		PIN_ERR_CLEAR_ERR(ebufp);
		PIN_FLIST_FLD_SET(*ret_flistpp, PIN_FLD_RESULT, 
			(void *)&suppression_flag, ebufp);
		PIN_FLIST_FLD_SET(*ret_flistpp, PIN_FLD_EXCEPTION, 
			(void *)&exception_flag, ebufp);
		goto cleanup; 
	}
	if ( !o_flistp ) {
		/*******************************************************
		 * Need an empty flist
		 * if we dont have any config suppression info 
		 * available including a default one, we igonore
		 * the threshold supression, however manual account
		 * and manual bill suppression holds good.
		 *******************************************************/
		o_flistp = PIN_FLIST_CREATE( ebufp );
	}

	/************************************************************
	 * Check for Suppression for the customer
	 ************************************************************/
	fm_bill_pol_get_suppression_reason(ctxp, o_flistp, 
					in_flistp, &pol_o_flistp, ebufp);

	/************************************************************
	 * if we are here we are goint to rewrite ret_flistpp so lets
	 * clear it
	 ************************************************************/
	PIN_FLIST_DESTROY_EX(ret_flistpp, NULL);
	if ( PIN_ERR_IS_ERR(ebufp) ) {
		*ret_flistpp = (pin_flist_t *)NULL;
		PIN_FLIST_DESTROY_EX(&pol_o_flistp, NULL);
	}
	else {
		*ret_flistpp  = pol_o_flistp;
	}

cleanup:
	PIN_FLIST_DESTROY_EX(&o_flistp, NULL);
	return ; 
}


/*********************************************************
* This method returns the an output flist containing the 
* found /config/suppression object based on the customer
* segment. It return an NULL flis, the cache does not contain
* suppression information for the customer segment.
***********************************************************/

static void
fm_bill_pol_find_min_bal_max_cycle(
	char*			customer_segment_listp, 
	pin_flist_t		**ret_flistpp,
	pin_errbuf_t		*ebufp)
{
	pin_flist_t 		*cache_flistp = (pin_flist_t *)NULL;
	pin_flist_t 		*c_flistp = (pin_flist_t *)NULL;
	pin_flist_t 		*tmp_flistp = (pin_flist_t *)NULL;
	int32			err = PIN_ERR_NONE;
	cm_cache_key_iddbstr_t	kids;
	pin_decimal_t*		cur_min_balp = NULL;
	pin_decimal_t*		min_balp = NULL;
	int*			cur_min_bill_cyclesp = NULL;
	int*			min_bill_cyclesp = NULL;
	char			*temp = NULL;
	char			*sub_str = NULL;
	void*			vp1 = NULL;
	void*			vp2 = NULL;
	int			search_def_cs = 0;
	
	/******************************************************
	 * Null out results until we have some.
	 ******************************************************/
	if ( PIN_ERR_IS_ERR(ebufp) )
		return;
	PIN_ERR_CLEAR_ERR(ebufp);
	/******************************************************
	* If the cache is not enabled, short circuit right away
	******************************************************/
	if ( fm_bill_suppression_config_ptr == (cm_cache_t *)NULL ) {
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"no config flist for /config/suppression cached so " 
		"threshold suppression is not on");
		return ;
	}

	/**************************************************
	 * See if the entry is in our data dictionary cache
	 * Prepare the cm_cache_key_iddbstr_t structure to search
	 **************************************************/
	kids.id = 0; 
	kids.db = 0;
	kids.str = "/config/suppression";
	cache_flistp = cm_cache_find_entry(fm_bill_suppression_config_ptr, 
					&kids, &err);
	//PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, 
	//		"cm_cache_find_entry found flist", cache_flistp);
	switch(err) {
	case PIN_ERR_NONE:
		break;
	case PIN_ERR_NOT_FOUND:
		break;
	default:
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, 
			"fm_bill_config_suppression_object from_cache: error "
			"accessing data dictionary cache.");
		pin_set_err(ebufp, PIN_ERRLOC_CM, 
				PIN_ERRCLASS_SYSTEM_DETERMINATE, err, 0, 0, 0);
	}
	
	if (!cache_flistp) {
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, 
			"config/suppression cache Empty ");
		goto cleanup;
	}

	/**********************************************************
	 * Get the customer segment IDs from the the list and
	 * find the corresponding entry in the cache. If found 
	 * get the Minimum Threshold from among the 
 	 * multiple customer segment ids. For example
	 * if the customer segment list contains 2 ids such
	 * as 1001 and 1002. Cust Segment Id 1001 having $30 
	 * threshold and Id 1002 having $40 threshold. Then we 
	 * shall work on the flist which contain cust segment id 
	 * 1001 as it contains minimum threshold amount.
	 * It expects the customer seg lists separated by a pipe.
	 * 
	 * 1. Initiallly it get the 1st array element from the flist
	 * 2. Then in the while loop it searches for other array
	 *    elements to comopare the minimum bill amount and 
	 *    mininum bill cycles to find the least one .
	 **********************************************************/
	
	vp1 = NULL;
	temp = strtok_r(customer_segment_listp, "|", &sub_str);
	c_flistp = PIN_FLIST_ELEM_GET(cache_flistp, 
			PIN_FLD_CUSTOMER_SEGMENTS, atoi(temp), 1, ebufp);
	if (c_flistp) {
		vp1 = PIN_FLIST_FLD_GET(c_flistp, 
				PIN_FLD_MIN_BILL_AMOUNT, 1, ebufp);
		vp2 = PIN_FLIST_FLD_GET(c_flistp, 
				PIN_FLD_MAX_SUPPRESSED_CYCLES, 1, ebufp);
	}
	
	if (vp1) {
		min_balp = (pin_decimal_t *)vp1;
	}

	if (vp2) {
		min_bill_cyclesp = (int *)vp2;
	}

	/******************************************************
	* Search for other customer segment id available in the
	* list in the array
	*******************************************************/
	while( (temp = strtok_r(NULL, "|", &sub_str)) ) {
		vp1 = vp2 = NULL;
		c_flistp = PIN_FLIST_ELEM_GET(cache_flistp, 
			PIN_FLD_CUSTOMER_SEGMENTS, atoi(temp), 1, ebufp);
		if (c_flistp)
		{
			vp1 = PIN_FLIST_FLD_GET(c_flistp, 
				PIN_FLD_MIN_BILL_AMOUNT, 1, ebufp);
			vp2 = PIN_FLIST_FLD_GET(c_flistp, 
				PIN_FLD_MAX_SUPPRESSED_CYCLES, 1, ebufp);
		}

		if (vp1) {
			cur_min_balp = (pin_decimal_t *)vp1;
			if (min_balp) {
				if (pbo_decimal_compare(cur_min_balp, 
							min_balp, ebufp) <= 0) {
				  min_balp = cur_min_balp;
				}
			}
			else {
				min_balp = cur_min_balp;
			}
		}
		if (vp2) {
			cur_min_bill_cyclesp = (int *)vp2;
			if (min_bill_cyclesp) {
				if (*cur_min_bill_cyclesp < *min_bill_cyclesp) {
					min_bill_cyclesp = cur_min_bill_cyclesp;
				}
			}
			else {
				min_bill_cyclesp = cur_min_bill_cyclesp;
			}
		}
	}
	
	/*************************************************************
	* prepare the flist updating the searched min bill amount 
	* and min bill cycles among the multiple customer segments.
	* if not available then search for the default customer
	* segment
	*************************************************************/
	tmp_flistp = PIN_FLIST_CREATE(ebufp);
	search_def_cs = 0;
	if ( min_balp ) {
		PIN_FLIST_FLD_SET(tmp_flistp, PIN_FLD_MIN_BILL_AMOUNT, 
					(void *)min_balp, ebufp);
	}
	else {
		search_def_cs = 1;
	}

	if ( min_bill_cyclesp ) {
		PIN_FLIST_FLD_SET(tmp_flistp, PIN_FLD_MAX_SUPPRESSED_CYCLES, 
					(void *)min_bill_cyclesp, ebufp);
	}
	else {
		search_def_cs = 1;
	}
	
	/******************************************************
	* If no customer segment information found in the cache, 
	* then try search for a default (0). If the default customer
	* segment not available then set the ret_flistpp as NULL
	* as to igonore the threshold suppression.
	******************************************************/
	if( search_def_cs == 1 ) {
		c_flistp = PIN_FLIST_ELEM_GET(cache_flistp, 
				PIN_FLD_CUSTOMER_SEGMENTS, 0, 1, ebufp);
		if (c_flistp) {
			vp1 = PIN_FLIST_FLD_GET(c_flistp, 
				PIN_FLD_MIN_BILL_AMOUNT, 1, ebufp);
			vp2 = PIN_FLIST_FLD_GET(c_flistp, 
				PIN_FLD_MAX_SUPPRESSED_CYCLES, 1, ebufp);
		}
		if (vp1 && !min_balp) {
			PIN_FLIST_FLD_SET(tmp_flistp, PIN_FLD_MIN_BILL_AMOUNT, 
					vp1, ebufp);
		}
		if (vp2 && !min_bill_cyclesp) {
			PIN_FLIST_FLD_SET(tmp_flistp, 
					PIN_FLD_MAX_SUPPRESSED_CYCLES, 
					vp2, ebufp);
		}
	}

cleanup:
	if ( !cache_flistp ) {
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"No Suppression Information not available in the cache.");
		*ret_flistpp = NULL;
		PIN_FLIST_DESTROY_EX(&tmp_flistp, NULL);
	}
	else {
		*ret_flistpp = tmp_flistp;
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, 
			"fm_bill_pol_find_min_bal_max_cycle return flist", 
			*ret_flistpp);
	}

	PIN_FLIST_DESTROY_EX(&cache_flistp, NULL);
	return;
}

/***************************************************************
* This method checks both the qualified and exception
* reasons for checking a bill to suppress or not
****************************************************************/

static void
fm_bill_pol_get_suppression_reason(
	pcm_context_t	*ctxp,
	pin_flist_t	*in_supinfo_flist_p,
	pin_flist_t	*in_flist_billinfo_p,
	pin_flist_t	**ret_flistpp,
	pin_errbuf_t	*ebufp)
{
	pin_flist_t	*r_flistp = (pin_flist_t *)NULL;
	pin_flist_t	*payment_adjustment_event_flistp = NULL;
	poid_t*		last_bill_objp = NULL;
	pin_decimal_t*	total_duep = (pin_decimal_t *)NULL;
	pin_decimal_t*	min_bal_p = (pin_decimal_t *)NULL;
	int32*		max_cycle_p = NULL;
	int32		suppression_flag = (int)PIN_RESULT_FAIL;
	int32		exception_flag = (int)PIN_NO_EXCEPTION;
	int32		suppression_cycle_left = 0;
	int32		suppression_count = 0;
	int32		act_suppression_flag = 0;
	int32		event_cnt = 0;
	poid_t*		billinfopoidp = NULL;
	int32		act_status = (int)PIN_STATUS_CLOSED;
	void*		vp = NULL;
	
	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);
	total_duep = pin_decimal("0.0", ebufp);
	
	/***********************************************************
	* Initialize the return output flist
	***********************************************************/
	r_flistp = PIN_FLIST_CREATE(ebufp);
	vp = NULL;
	vp = PIN_FLIST_FLD_GET(in_flist_billinfo_p, PIN_FLD_POID, 0, ebufp);
	if (vp) {
		billinfopoidp = (poid_t *)vp;
	}
	
	PIN_FLIST_FLD_SET(r_flistp, PIN_FLD_POID, (void *)billinfopoidp, ebufp);
	PIN_FLIST_FLD_SET(r_flistp, PIN_FLD_RESULT , &suppression_flag, ebufp);
	PIN_FLIST_FLD_SET(r_flistp, PIN_FLD_EXCEPTION, &exception_flag, ebufp);

	/******************************************
	* Get the Minimum Balance Amt value, max 
	* bill cycle to suppress from the cache 
	* from the in_supinfo_flist_p
	*****************************************/
	vp  = (pin_decimal_t *)PIN_FLIST_FLD_GET(in_supinfo_flist_p, 
				PIN_FLD_MIN_BILL_AMOUNT, 1, ebufp);
	if (vp) {
		min_bal_p = (pin_decimal_t *)vp;
	}
	vp = (int32 *)PIN_FLIST_FLD_GET(in_supinfo_flist_p, 
				PIN_FLD_MAX_SUPPRESSED_CYCLES, 1, ebufp);
	if (vp) {
		max_cycle_p = (int32 *)vp;
	}

	/***********************************************************
	* Get the TOTAL_DUE,CYCLE_SUPPRESSED,
	* SUPPRESSION_FLAG, LAST_BILL_OBJ, ACCT_SUPPRESSED flag
	* from the input flist
	*************************************************************/
	vp = PIN_FLIST_FLD_GET(in_flist_billinfo_p, PIN_FLD_STATUS, 0, ebufp);
	if (vp) {
		act_status = *(int *)vp;
	}
	vp = PIN_FLIST_FLD_GET(in_flist_billinfo_p, 
				PIN_FLD_NUM_SUPPRESSED_CYCLES, 1, ebufp);
	if (vp) {
		suppression_count = *(int *)vp;
	}

	vp = PIN_FLIST_FLD_GET(in_flist_billinfo_p, 
				PIN_FLD_ACCT_SUPPRESSED, 1, ebufp);
	if (vp) {
		act_suppression_flag = *(int *)vp;
	}
	vp = PIN_FLIST_FLD_GET(in_flist_billinfo_p, 
				PIN_FLD_SUPPRESSION_CYCLES_LEFT, 1, ebufp);
	if (vp) {
		suppression_cycle_left = *(int *)vp;
	}

	/******************************************************
	* Getting the last bill object.
	* If this is  null then there is no bill suppression.
	*******************************************************/
	last_bill_objp = PIN_FLIST_FLD_GET(in_flist_billinfo_p, 
				PIN_FLD_LAST_BILL_OBJ, 1, ebufp);

	/**********************************************************
	 * get open_balances  from in_flist_billinfo_p 
	 ***********************************************************/
	vp = PIN_FLIST_FLD_GET(in_flist_billinfo_p, 
				PIN_FLD_TOTAL_DUE, 1, ebufp);
	if (vp) {
		PIN_DECIMAL_DESTROY_EX(&total_duep);
		total_duep = pbo_decimal_copy((pin_decimal_t *) vp, ebufp);
	}

	/****************************************************************
	 * Check for qualified reasons for Bill Suppression
	 * 1. Minimum Bill Amount >= Bill Total Due OR
	 * 2. act_suppression_flag == PIN_ACCOUNT_SUPPRESSED (in case of 
	 *    Account already suppressed) OR
	 * 3. suppression_cycle_left > 0 (in case of the bill already 
	 *    suppressed manually) 
	 *    If either of the above conditions true then set the output 
	 *    flist PIN_FLD_RESULT to suppression reason  enum identifier 
	 *    otherwise set it to PIN_RESULT_FAIL
	 * Note. If total_due is less than 0 mean, a minus figure, then
	 *    the bill should not be suppressed.
	 * 
	 *****************************************************************/
	if (pbo_decimal_sign(total_duep, ebufp) < 0) {
	//	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
	//	"excess bill amount paid, bill need to be finalized");
		goto cleanup;
	}
	
	/*****************************************************************
	* If min_bal_p is not null then check for threshold suppression
	* for the current bill as if min_balance is more than the bill
	* bill value.
	* If min_bal_p is null then ignore the threshold suppression
	* but manual bill suppression and manual account suppression
	* holds good and checked.
	*****************************************************************/
	if( min_bal_p && pbo_decimal_compare(min_bal_p, total_duep, ebufp) >= 0)
	{
		suppression_flag = (int)PIN_DUE_TO_MIN_BAL_MORE_THAN_BILL_TOTAL;
	}
	else if( suppression_cycle_left > 0 ) {
		suppression_flag = (int)PIN_DUE_TO_BILL_SUPPRESSED_MANUALLY;
	}
	else if( act_suppression_flag == (int)PIN_ACCOUNT_SUPPRESSED ) {
		suppression_flag = (int)PIN_DUE_TO_ACCOUNT_SUPPRESSED_MANUALLY;
	}
	
	/****************************************************************
	* If case of suppression , Check for Exceptional Reasons for Bill
	* Suppression
	* 1. Call fm_bill_pol_get_payment_event to test whether any payment
	*    Adjustment been done for the bill or not? If PA_event_flistpp
	*    is NULL OR
	* 2. Last Bill object is NULL OR
	* 3. Account is closed OR
	* 4. suppression_count < max_cycle to suppress
	* If either of the conditions true then set the output flist 
	* PIN_FLD_RESULT to PIN_RESULT_PASS otherwise PIN_RESULT_FAIL
	*****************************************************************/
	if (suppression_flag != (int)PIN_RESULT_FAIL ) {
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"In payment iff");
		/* Check for any payment, adjustment event*/
		if( PIN_POID_IS_NULL(last_bill_objp) ) {
			//suppression_flag = (int)PIN_RESULT_FAIL;
			//exception_flag = (int)PIN_DUE_TO_FIRST_BILL;
		//	goto cleanup;
		}
		fm_bill_pol_get_payment_adjustment_event(ctxp, 
					in_flist_billinfo_p, 
					&payment_adjustment_event_flistp, 
					ebufp);
		if ( PIN_ERR_IS_ERR(ebufp) || 
			(!payment_adjustment_event_flistp) ) {
			goto cleanup; 
		}
		else {
	//		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, 
	//			"fm_bill_pol_get_suppression_reason "
	//			"pmt adjust event output flist", 
	//			payment_adjustment_event_flistp);
		}
		event_cnt = PIN_FLIST_ELEM_COUNT(
				payment_adjustment_event_flistp, 
				PIN_FLD_RESULTS, ebufp);
		if( event_cnt >= 1 ) {
			suppression_flag = (int)PIN_RESULT_FAIL;
			exception_flag = (int)PIN_DUE_TO_PAYMENT_ADJUSTMENT_MADE;
		}
		else if( act_status == (int)PIN_STATUS_CLOSED ) {
			suppression_flag = (int)PIN_RESULT_FAIL;
			exception_flag = (int)PIN_DUE_TO_ACCOUNT_CLOSED;
		}
		/************************************************************
		 * If there is a limit to the number of cycles then check it.
		 * Suppression count is  incremented before the test because 
		 * it needs to account for this suppression in determining 
		 * the number of times it can be suppressed
		 ************************************************************/
		else if( max_cycle_p && ++suppression_count > *max_cycle_p ) {
			suppression_flag = (int)PIN_RESULT_FAIL;
			exception_flag = PIN_DUE_TO_MAX_ALLOWED_SUPPRESSION_COUNT_REACHED;
		}
		else {
			exception_flag = (int)PIN_NO_EXCEPTION;
		}
	}

cleanup:
	/***********************************************************
	 * Results.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_bill_pol_check_suppression error", ebufp);
	} else {
		PIN_FLIST_FLD_SET(r_flistp, PIN_FLD_RESULT, 
				(void*)&suppression_flag, ebufp);
	 	PIN_FLIST_FLD_SET(r_flistp, PIN_FLD_EXCEPTION, 
				(void*)&exception_flag, ebufp);
	}

	/**************************************************************
	 * the r_flist either has resulkts it obtained or in the error
	 * case it has a RESULT = failed
	 * either way we send it
	 **************************************************************/
	*ret_flistpp  = r_flistp;
	PIN_DECIMAL_DESTROY_EX(&total_duep);
	PIN_FLIST_DESTROY_EX(&payment_adjustment_event_flistp, NULL);
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"fm_bill_pol_check_suppression return flist", 
		*ret_flistpp);

	return ;
}


/******************************************************************
* This method checks for any exceptions/events occured such as 
* payment, adjustment, credit made by the customer. If so then the
* bill will not be  suppressed.
* The events to be searched are hardcoded, the customer can remove
* or add to the buffer i.e eventBuf to seach for specific event 
* for ignoring suppression.
******************************************************************/

static void 
fm_bill_pol_get_payment_adjustment_event (
	pcm_context_t	*ctxp,
	pin_flist_t	*in_flist_billinfo_p,
	pin_flist_t	**PA_event_flistpp,
	pin_errbuf_t	*ebufp)
{
	pin_flist_t 	*i_flistp = (pin_flist_t *)NULL;
	pin_flist_t 	*o_flistp = (pin_flist_t *)NULL;
	pin_flist_t 	*arg_flistp	 = (pin_flist_t *)NULL;
	poid_t		*billinfo_poid	 = NULL;
	poid_t		*account_poid	 = NULL;
	poid_t		*pdp		 = NULL;
	poid_t  	*s_pdp		 = NULL;
	time_t		next_bill_t = 0;
	time_t		last_bill_t = 0;
	void*		vp		 = NULL;
	int32   	s_flags	 = 256;
	char		templatep[2001];
	char    	eventsBuf[2000] = "'/event/billing/adjustment/account','/event/billing/adjustment/event','/event/billing/adjustment/item',\
	'/event/billing/refund/cash','/event/billing/refund/cc',\
	'/event/billing/refund/check','/event/billing/refund/dd',\
	'/event/billing/refund/payorder','/event/billing/refund/postalorder',\
	'/event/billing/refund/wtransfer','/event/billing/reversal/cc',\
	'/event/billing/reversal/check','/event/billing/reversal/dd',\
	'/event/billing/reversal/payorder',\
	'/event/billing/reversal/postalorder',\
	'/event/billing/reversal/wtransfer',\
	'/event/billing/payment/cash',\
        '/event/billing/payment/cc','/event/billing/payment/check',\
        '/event/billing/payment/dd','/event/billing/payment/payorder',\
        '/event/billing/payment/postalorder',\
        '/event/billing/payment/wtransfer',\
	'/event/billing/payment/creditcard','/event/billing/reversal/creditcard','/event/billing/refund/creditcard',\
        '/event/billing/payment/poli','/event/billing/reversal/poli','/event/billing/refund/poli'";

	/***********************************************************
	 * Payement exceptions are being commented/taken out of the
	 * eventBuf buffer. If required these event ids can be 
	 * included into the buffer in order to consider the payment
	 * exceptions.
	 ***********************************************************/
	/*'/event/billing/payment/cash',\
	'/event/billing/payment/cc','/event/billing/payment/check',\
	'/event/billing/payment/dd','/event/billing/payment/payorder',\
	'/event/billing/payment/postalorder',
	'/event/billing/payment/wtransfer'*/

	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, 
		"fm_bill_pol_get_payment_adjustment_event input flist ", 
			in_flist_billinfo_p);
	
	/***********************************************************
	* Get billinfo POID, billinfo NEXT_BILL_T and LAST_BILL_T
	***********************************************************/
	billinfo_poid = (poid_t *)PIN_FLIST_FLD_GET(in_flist_billinfo_p, 
			PIN_FLD_POID, 0, ebufp);
	
	/* Prepare the input flist to get the account object from db */
	vp = NULL;
	i_flistp = PIN_FLIST_CREATE(ebufp);
	PIN_FLIST_FLD_SET(i_flistp, PIN_FLD_POID, (void *)billinfo_poid, ebufp);
	PIN_FLIST_FLD_SET(i_flistp, PIN_FLD_ACCOUNT_OBJ, vp, ebufp);
	PIN_FLIST_FLD_SET(i_flistp, PIN_FLD_NEXT_BILL_T, vp, ebufp);
	PIN_FLIST_FLD_SET(i_flistp, PIN_FLD_LAST_BILL_T, vp, ebufp);
	
	PCM_OP(ctxp, PCM_OP_READ_FLDS, 0, i_flistp, &o_flistp, ebufp);
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, 
			"account obj read failed reading event objects. ", 
			ebufp);
		goto cleanup;
	}

	vp = PIN_FLIST_FLD_GET(o_flistp, PIN_FLD_NEXT_BILL_T, 0, ebufp);
	if (vp)
	{
		next_bill_t = *(time_t *)vp;
	}
	vp = PIN_FLIST_FLD_GET(o_flistp, PIN_FLD_LAST_BILL_T, 0, ebufp);
	if (vp)
	{
		last_bill_t = *(time_t *)vp;
	}
	/***********************************************************
	* Now search in the /event/billing/adjustment/account
	* for any event on this /account obj
	* Customer can add/modify more events based on which the bill
	* will be decided to be suppressed or not to suppress
	************************************************************/
	PIN_FLIST_DESTROY_EX(&i_flistp, NULL);
	i_flistp = PIN_FLIST_CREATE(ebufp);

	/********************************************************
	* Prepare the input flist to get the /event object from 
	* db for the account 
	********************************************************/
	account_poid = (poid_t *)PIN_FLIST_FLD_TAKE(o_flistp, 
			PIN_FLD_ACCOUNT_OBJ,0, ebufp);

	s_pdp = PIN_POID_CREATE(PIN_POID_GET_DB(account_poid), 
					"/search", -1, ebufp);
	PIN_FLIST_FLD_PUT(i_flistp, PIN_FLD_POID, (void *)s_pdp, ebufp);
	PIN_FLIST_FLD_SET(i_flistp, PIN_FLD_FLAGS, (void *)&s_flags, ebufp);

	/* select only the list of event types hardcoded. */
	sprintf(templatep, 
		"select X from /event where F1 = V1 and F2 <= V2 and F3 > V3 "
		"and event_t.poid_type in (%s) ", eventsBuf );
	PIN_FLIST_FLD_SET (i_flistp, PIN_FLD_TEMPLATE, (void *)templatep,ebufp);

	arg_flistp = PIN_FLIST_ELEM_ADD(i_flistp, PIN_FLD_ARGS, 1, ebufp);
	PIN_FLIST_FLD_PUT(arg_flistp, PIN_FLD_ACCOUNT_OBJ, 
			(void *)account_poid, ebufp);

	arg_flistp = PIN_FLIST_ELEM_ADD(i_flistp, PIN_FLD_ARGS, 2, ebufp);
	PIN_FLIST_FLD_SET(arg_flistp, PIN_FLD_END_T, 
			(void *)&next_bill_t, ebufp);

	arg_flistp = PIN_FLIST_ELEM_ADD(i_flistp, PIN_FLD_ARGS, 3, ebufp);
	PIN_FLIST_FLD_SET(arg_flistp, PIN_FLD_END_T, 
			(void *)&last_bill_t, ebufp);

	PIN_FLIST_ELEM_SET( i_flistp, NULL, PIN_FLD_RESULTS, 0, ebufp);

	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, 
			"Search /event object inpput flist ", i_flistp);
	/* Search for the /event object */
	PIN_FLIST_DESTROY_EX(&o_flistp, NULL);
	PCM_OP(ctxp, PCM_OP_SEARCH, 0, i_flistp, &o_flistp, ebufp);
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, 
		"fm_bill_pol_get_payment_adjustment_event search failed" 
		" Error loading /event object", ebufp);
		goto cleanup;
   	}
	
cleanup:
	/***********************************************************
	 * Results return flist 
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		*PA_event_flistpp = (pin_flist_t *)NULL;
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_bill_pol_get_payment_adjustment_event error", 
			ebufp);
		PIN_FLIST_DESTROY_EX(&o_flistp, NULL);
	} else {
		*PA_event_flistpp = o_flistp;
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"fm_bill_pol_get_payment_adjustment_event return flist",
			*PA_event_flistpp);
	}
	PIN_FLIST_DESTROY_EX(&i_flistp, NULL);
}
/*************************************************
CUSTOM FUNCTION TO CHECK  ACTIVE SERVICE
**************************************************/

int32
td_bill_pol_check_service_status(
        pcm_context_t   *ctxp,
        pin_flist_t     *in_flistp,
        pin_errbuf_t    *ebufp)
{

	int32   	flag = 0;
	int32   	poid_val = 0;
	int32		service_status= 0;
	pin_cookie_t    cookie = NULL;
        int32           rec_id;
        int32           element_id = 0;

	poid_t		*billinfo_pdp = NULL;
	poid_t		*account_pdp = NULL;
	poid_t  	*search_pdp = NULL;
	poid_t		*service_pdp = NULL;
	poid_t		*bal_grp_pdp = NULL;

	pin_decimal_t	*amount_due = NULL;
	amount_due = pbo_decimal_from_str("0.00",ebufp);

	pin_flist_t     *read_inflistp = NULL;
        pin_flist_t     *read_outflistp = NULL;
	pin_flist_t     *search_inflistp = NULL;
        pin_flist_t     *search_outflistp = NULL;
	pin_flist_t     *result_flistp = NULL;
        pin_flist_t     *args_flistp = NULL;
	pin_flist_t     *temp_result_flistp = NULL;
	pin_flist_t	*result_check_flistp = NULL;
	

	char		*template_search = NULL;
	char    	result_value_char[50];
	int32   	result_value = 0;
	void            *vp=NULL;
	void            *vp1=NULL;
	int32		svc_status = 10103;
	


	if (PIN_ERR_IS_ERR(ebufp))
                return;
        PIN_ERR_CLEAR_ERR(ebufp);

        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"td_bill_pol_check_service_status input flist",in_flistp);
	

	vp1 = PIN_FLIST_FLD_GET (in_flistp, PIN_FLD_TOTAL_DUE, 1, ebufp);
	if (vp1)
	{
		amount_due = (pin_decimal_t *)vp1;

	}

	billinfo_pdp = PIN_FLIST_FLD_GET (in_flistp, PIN_FLD_POID, 1, ebufp);
	read_inflistp = PIN_FLIST_CREATE(ebufp);
	PIN_FLIST_FLD_SET(read_inflistp,PIN_FLD_POID, (void *)billinfo_pdp, ebufp);
	PIN_FLIST_FLD_SET(read_inflistp,PIN_FLD_ACCOUNT_OBJ,NULL, ebufp);
	
//	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
//		"td_bill_pol_check_service_status read billinfo input flist", read_inflistp);
	PCM_OP(ctxp, PCM_OP_READ_FLDS, 0, read_inflistp, &read_outflistp, ebufp);
//	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
//		"td_bill_pol_check_service_status read billinfo output flist", read_outflistp);

	if (PIN_ERR_IS_ERR(ebufp)){
                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_ERROR,"td_bill_pol_check_service_status error in read billinfo",read_outflistp);
                goto cleanup;
        }

	account_pdp = (poid_t *) PIN_FLIST_FLD_GET(read_outflistp,PIN_FLD_ACCOUNT_OBJ,1,ebufp);
        poid_val = PIN_POID_IS_NULL(account_pdp);
	
	if(poid_val == 0) {	
		/** INPUT flist for PCM_OP_SEARCH  to search SERVICE POID item in /service *****
		************
                0 PIN_FLD_POID                      POID [0] 0.0.0.1 /search -1 0
                0 PIN_FLD_FLAGS                      INT [0] 0
                0 PIN_FLD_TEMPLATE                   STR [0] "select X from /service where F1=V1"
                0 PIN_FLD_RESULTS                  ARRAY [0] allocated 0, used 0
                0 PIN_FLD_ARGS                     ARRAY [1] allocated 1, used 1
                1     PIN_FLD_BILL_OBJ              POID [0] 0.0.0.1 /account 403686 0
                ********************************************************************************/
//		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"msg1");
		search_pdp = PIN_POID_CREATE(PIN_POID_GET_DB(account_pdp),"/search", -1, ebufp);
        	bal_grp_pdp = PIN_POID_CREATE(PIN_POID_GET_DB(account_pdp), "/balance_group", -1, ebufp);
	        search_inflistp = PIN_FLIST_CREATE(ebufp);
                PIN_FLIST_FLD_SET(search_inflistp,PIN_FLD_POID, (void *)search_pdp, ebufp);
                PIN_FLIST_FLD_SET(search_inflistp,PIN_FLD_FLAGS, (void *)&flag, ebufp);
                //template_search ="select X from /service where F1=V1";
                //template_search ="select X from /service 1, /balance_group 2 where 1.F1 = 2.F2 and 2.F3 = V3 and 1.F4 != V4 ";
		template_search ="select X from /service 1, /balance_group 2, /purchased_product 3, /billinfo 4 where 1.F1 = 2.F2 and 2.F3 = 4.F4 and 1.F5<> V5 and 1.F6 = 3.F7 and 1.F8 = 3.F9 and 4.F10 =V10 and 3.F11 < 4.F12 ";
		PIN_FLIST_FLD_SET(search_inflistp,PIN_FLD_TEMPLATE, (void *)template_search, ebufp);
                result_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_RESULTS,0,ebufp);
		PIN_FLIST_FLD_SET(result_flistp,PIN_FLD_POID, (void *)NULL, ebufp);

//		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"msg2");
                args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,1,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_BAL_GRP_OBJ, (void *)NULL, ebufp);

//		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"msg3");
		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,2,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_POID, (void *)NULL, ebufp);


//		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"msg4");
		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,3,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_BILLINFO_OBJ, (void *)NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,4,ebufp);
                //PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_STATUS, (void *)&svc_status, ebufp);
		PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_POID, (void *)NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,5,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_STATUS, (void *)&svc_status, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,6,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_POID, (void *)NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,7,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_SERVICE_OBJ, (void *)NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,8,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_ACCOUNT_OBJ, (void *)NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,9,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_ACCOUNT_OBJ, (void *)NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,10,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_POID, (void *)billinfo_pdp, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,11,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_CYCLE_START_T, (void *)NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,12,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_NEXT_BILL_T, (void *)NULL, ebufp);

//		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR,"msg5");
                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"td_bill_pol_check_service_status search input flist", search_inflistp);
                PCM_OP(ctxp, PCM_OP_SEARCH, 0, search_inflistp, &search_outflistp, ebufp);
                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"td_bill_pol_check_service_status search output flist", search_outflistp);
		
//		sprintf(result_value_char, "%d", result_value);
  //              PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
//			"Before Operation");
                PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,result_value_char);

		if (PIN_ERR_IS_ERR(ebufp)){
                        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_ERROR, 
			"td_bill_pol_check_service_status error in searching", search_outflistp);
                        goto cleanup;
                }
		
		else{
			result_check_flistp = PIN_FLIST_ELEM_GET(search_outflistp,PIN_FLD_RESULTS,0, 1,ebufp);
		
				//service_pdp = (poid_t *) PIN_FLIST_FLD_GET(search_outflistp, PIN_FLD_POID, 1, ebufp);
				//vp  =  PIN_FLIST_FLD_GET(result_check_flistp, PIN_FLD_STATUS, 1, ebufp);
		
				//if (vp) {
                		//	service_status = *(int *)vp;
        			//}

			if (result_check_flistp == NULL){
				result_value = 1;
			}
		
			//}// end while
		}
	}// END IF SEARCH BLOCK
                

	cleanup:
        if (read_inflistp != NULL){
                PIN_FLIST_DESTROY_EX(&read_inflistp, NULL);
        }
        if (read_outflistp != NULL){
                PIN_FLIST_DESTROY_EX(&read_outflistp, NULL);
        }
        if (search_pdp != NULL){
                PIN_POID_DESTROY(search_pdp,ebufp);
        }
        if (search_inflistp != NULL){
                PIN_FLIST_DESTROY_EX(&search_inflistp, NULL);
        }
        if (search_outflistp != NULL){
                PIN_FLIST_DESTROY_EX(&search_outflistp, NULL);
        }

 	//sprintf(result_value_char, "%d", result_value);
        //PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"After Operation");
        //PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,result_value_char);
        return result_value;
}// END OF CUSTOM FUNCTION

/*************************************************************
CUSTOM FUNCTION TO CHECK EVENTS
************************************************/
int32
td_bill_pol_check_events(
        pcm_context_t   *ctxp,
        pin_flist_t     *in_flistp,
        pin_errbuf_t    *ebufp)
{
        poid_t  *bill_pdp = NULL;
        poid_t  *search_pdp = NULL;
        poid_t  *billinfo_pdp = NULL;
	poid_t	*acc_pdp = NULL;
	
	pin_flist_t	*bal_impact_flistp = NULL;
        pin_flist_t     *search_inflistp = NULL;
        pin_flist_t     *search_outflistp = NULL;

        int32   flag = 0;
        char    *template_search = NULL;
        char    result_value_char[50];
        pin_flist_t     *result_flistp = NULL;
        pin_flist_t     *args_flistp = NULL;
        pin_flist_t     *temp_result_flistp = NULL;
        poid_t          *item_pdp = NULL;
        int32   result_value = 1;
        int32   array_elem = 0;
        int32   counter = 0;
        int32   loop_counter =0;
        int32   poid_val = 0;
        pin_flist_t     *read_inflistp = NULL;
        pin_flist_t     *read_outflistp = NULL;

	if (PIN_ERR_IS_ERR(ebufp))
                return;
        PIN_ERR_CLEAR_ERR(ebufp);

        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"td_bill_pol_check_events input flist",in_flistp);

        //bill_pdp = (poid_t *) PIN_FLIST_FLD_GET(in_flistp,PIN_FLD_LAST_BILL_OBJ,1,ebufp);
        billinfo_pdp = (poid_t *) PIN_FLIST_FLD_GET(in_flistp,PIN_FLD_POID,1,ebufp);

        read_inflistp = PIN_FLIST_CREATE(ebufp);
        PIN_FLIST_FLD_SET(read_inflistp,PIN_FLD_POID, (void *)billinfo_pdp, ebufp);
	PIN_FLIST_FLD_SET(read_inflistp,PIN_FLD_ACCOUNT_OBJ, NULL, ebufp);
        PIN_FLIST_FLD_SET(read_inflistp,PIN_FLD_BILL_OBJ,NULL, ebufp);

//	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
//		"td_bill_pol_check_events read billinfo input flist", read_inflistp);
        PCM_OP(ctxp, PCM_OP_READ_FLDS, 0, read_inflistp, &read_outflistp, ebufp);
  //      PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
//		"td_bill_pol_check_events read billinfo output flist", read_outflistp);

        if (PIN_ERR_IS_ERR(ebufp)){
                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_ERROR,
		"td_bill_pol_check_events error in read billinfo",read_outflistp);
                goto cleanup;
        }

        bill_pdp = (poid_t *) PIN_FLIST_FLD_GET(read_outflistp,PIN_FLD_BILL_OBJ,1,ebufp);
	acc_pdp = (poid_t *) PIN_FLIST_FLD_GET(read_outflistp,PIN_FLD_ACCOUNT_OBJ,1,ebufp);
        poid_val = PIN_POID_IS_NULL(bill_pdp);

        if(poid_val == 0) {
                /** INPUT flist for PCM_OP_SEARCH  to search line item in bill *****************
                0 PIN_FLD_POID                      POID [0] 0.0.0.1 /search -1 0
                0 PIN_FLD_FLAGS                      INT [0] 0
                0 PIN_FLD_TEMPLATE                   STR [0] "select X from /item where F1=V1"
                0 PIN_FLD_RESULTS                  ARRAY [0] allocated 0, used 0
                0 PIN_FLD_ARGS                     ARRAY [1] allocated 1, used 1
                1     PIN_FLD_BILL_OBJ              POID [0] 0.0.0.1 /bill 1569418 0
                ********************************************************************************/
                search_pdp = PIN_POID_CREATE(PIN_POID_GET_DB(bill_pdp),"/search", -1, ebufp);
                search_inflistp = PIN_FLIST_CREATE(ebufp);
                PIN_FLIST_FLD_SET(search_inflistp,PIN_FLD_POID, (void *)search_pdp, ebufp);
                PIN_FLIST_FLD_SET(search_inflistp,PIN_FLD_FLAGS, (void *)&flag, ebufp);
                //template_search ="select X from /item where F1=V1";

		template_search = "select X from /item 1, /event 2, /purchased_product 3, /billinfo 4 where 1.F1 = 2.F2 and 2.F3 = 3.F4 and 1.F5= V5 and 1.F6= 4.F7 and 3.F8 <= 4.F9 and 1.F10=V10";
                PIN_FLIST_FLD_SET(search_inflistp,PIN_FLD_TEMPLATE, (void *)template_search, ebufp);
                result_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_RESULTS,0,ebufp);
                args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,1,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_POID, NULL, ebufp);
		
		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,2,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_ITEM_OBJ, NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,3,ebufp);
		bal_impact_flistp = PIN_FLIST_ELEM_ADD(args_flistp,PIN_FLD_BAL_IMPACTS,0,ebufp);
                PIN_FLIST_FLD_SET(bal_impact_flistp,PIN_FLD_OFFERING_OBJ, NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,4,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_POID, NULL, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,5,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_BILL_OBJ,(void *) bill_pdp, ebufp);

		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,6,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_BILLINFO_OBJ, NULL, ebufp);

		 args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,7,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_POID, NULL, ebufp);

		 args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,8,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_CYCLE_START_T, NULL, ebufp);

		 args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,9,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_NEXT_BILL_T, NULL, ebufp);
		
		args_flistp = PIN_FLIST_ELEM_ADD(search_inflistp,PIN_FLD_ARGS,10,ebufp);
                PIN_FLIST_FLD_SET(args_flistp,PIN_FLD_ACCOUNT_OBJ,(void *)acc_pdp, ebufp);

                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"td_bill_pol_check_events search input flist", search_inflistp);
                PCM_OP(ctxp, PCM_OP_SEARCH, 0, search_inflistp, &search_outflistp, ebufp);
                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"td_bill_pol_check_events search output flist", search_outflistp);

  //              sprintf(result_value_char, "%d", result_value);
    //            PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
//			"Before Operation");
                PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,result_value_char);

                if (PIN_ERR_IS_ERR(ebufp)){
                        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_ERROR,
                                "td_bill_pol_check_events error in searching", search_outflistp);
                        goto cleanup;
                }
		else {
                        array_elem = PIN_FLIST_ELEM_COUNT(search_outflistp,PIN_FLD_RESULTS,ebufp);
                        if(array_elem >= 1){
                                for(loop_counter=0; loop_counter < array_elem; loop_counter++){
                                        temp_result_flistp = PIN_FLIST_ELEM_GET(search_outflistp, PIN_FLD_RESULTS, loop_counter, 1, ebufp);
                                        item_pdp = PIN_FLIST_FLD_GET(temp_result_flistp, PIN_FLD_POID, 1, ebufp);
                                        if((strcmp(PIN_POID_GET_TYPE(item_pdp),"/item/misc")!=0)&&(strcmp(PIN_POID_GET_TYPE(item_pdp),"/item/misc_niltax")!=0)){
                                                PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
							"Relevant Item Found!!!");
                                        counter++;
                                        }
                                }
                        }
                        //sprintf(result_value_char, "%d", array_elem);
                        //PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"Array Element Count");
                        //PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,result_value_char);
                        //if(array_elem > 1) {
                        //      result_value = 1;
                        //}
                        if(counter>=1){
                                result_value = 0;
                                PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
					"I am Happy to Generate Your Bill");
                        }
                        else{
                                PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
					"Your Bill will be suppressed");
                        }
                }
        }

        cleanup:
        if (read_inflistp != NULL){
                PIN_FLIST_DESTROY_EX(&read_inflistp, NULL);
        }
        if (read_outflistp != NULL){
                PIN_FLIST_DESTROY_EX(&read_outflistp, NULL);
        }
        if (search_pdp != NULL){
                PIN_POID_DESTROY(search_pdp,ebufp);
        }
        if (search_inflistp != NULL){
                PIN_FLIST_DESTROY_EX(&search_inflistp, NULL);
        }
        if (search_outflistp != NULL){
                PIN_FLIST_DESTROY_EX(&search_outflistp, NULL);
        }
        //PIN_FLIST_DESTROY_EX( &search_inflistp, NULL);
        //}
  //      sprintf(result_value_char, "%d", result_value);
  //      PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
//		"After Operation");
        PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,result_value_char);
        return result_value;
}

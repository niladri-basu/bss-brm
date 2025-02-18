/*
* Copyright (c) 2004, 2010, Oracle and/or its affiliates. All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef lint
static  char Sccs_id[] = "@(#)$Id: fm_reserve_pol_post_dispute.c /cgbubrm_7.3.2.rwsmod/3 2010/05/20 06:30:14 sreevenk Exp $";
#endif

/***************************************************************************
 * This file contains the PCM_OP_RESERVE_POL_POST_DISPUTE  operation.
 *
 * This file makes use of routines from fm_reserve_create
 *
 * These routines are generic and work for all account types.
 ***************************************************************************/
 
#include <stdio.h>
#include <string.h>
#include <math.h>
#ifdef MSDOS
#include <WINDOWS.h>
#endif

#include "pcm.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pinlog.h"
#include "pin_reserve.h"
#include "fm_utils.h"
#include "pin_bill.h"
#include "pin_rate.h"
#include "pin_reserve.h"
#include "ops/reserve.h"


/*******************************************************************
 * Routines contained within.
 *******************************************************************/
EXPORT_OP void op_reserve_pol_post_dispute();


/*******************************************************************
 * Routines called from fm_reserve_pol_post_dispute
 *******************************************************************/
static void fm_reserve_get_dispute_events();
static void fm_reserve_set_flist_for_reservation();
static void fm_reserve_create_reservation();

/*******************************************************************
 * Main routine for the PCM_OP_RESERVE_POL_POST_DISPUTE operation.
 *******************************************************************/
void 
op_reserve_pol_post_dispute(connp, opcode, flags, i_flistp, r_flistpp, ebufp)
        cm_nap_connection_t     *connp;
        int32                   opcode;
        int32                   flags;
        pin_flist_t             *i_flistp;
        pin_flist_t             **r_flistpp;
        pin_errbuf_t            *ebufp;
{
	pcm_context_t		*ctxp = connp->dm_ctx;
	poid_t			*item_poidp;
	poid_t			*a_pdp;
	pin_flist_t             *res_flistp = NULL;
	pin_flist_t             *search_flistp = NULL;
	pin_flist_t             *sub_reser_listp = NULL;
	pin_flist_t             *out_flistp = NULL;
	pin_flist_t             *items_flistp = NULL;
	int32			local_trans = 0;
	const char		*poid_type = NULL;
	
	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);
	
	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	*r_flistpp = NULL;
	
	    if (opcode != PCM_OP_RESERVE_POL_POST_DISPUTE) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_reserve_pol_post_dispute", ebufp);
		return;
		/*****/
	}
	
	 /***********************************************************
	 * Debug: What did we get?
	 ***********************************************************/
	 PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_reserve_pol_post_dispute input flist", i_flistp);
	
	 /***********************************************************
	 * Retrieve dispute item from input flist 
	 ***********************************************************/
	item_poidp = (poid_t *) PIN_FLIST_FLD_GET(i_flistp, 
	 			PIN_FLD_ITEM_OBJ, 0, ebufp);
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
		"op_reserve_pol_post_dispute error: incorrect input flist",
		ebufp);
		return;	
	}
	/***********************************************************
	*just a sanity check that given item should be dispute one
	***********************************************************/
	poid_type = PIN_POID_GET_TYPE(item_poidp);
	if(!poid_type || (strcmp(poid_type, PIN_OBJ_TYPE_ITEM_DISPUTE)))
	{
	      pin_set_err(ebufp, PIN_ERRLOC_FM, 
		PIN_ERRCLASS_SYSTEM_DETERMINATE,
		PIN_ERR_BAD_POID_TYPE, 0, 0, 0);
	      PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
		"dispute item type is not supplied in input flist", 
		ebufp);
	       return;
	}


	/*****************************************************
	*Get all dispute events that are to be reserved  
	*****************************************************/ 
	fm_reserve_get_dispute_events(ctxp, item_poidp, &search_flistp, ebufp);
	
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_FLIST_LOG_ERR("fm_reserve_get_dispute_events"
		" returned error",
		ebufp);
		PIN_FLIST_DESTROY_EX(&search_flistp, NULL);
		return;
	}
	
	PIN_FLIST_FLD_SET(search_flistp, PIN_FLD_ITEM_OBJ, (poid_t *)item_poidp,
				ebufp);
	/*****************************************************************
	* Debug: print Search Results
	*****************************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "Search Results", search_flistp);
	
	/*****************************************************************
	* sets the flist for Resource Reservation
	*****************************************************************/
	fm_reserve_set_flist_for_reservation(ctxp, search_flistp, &res_flistp,
			ebufp);
	/***********************************************************
         * Errors?
         ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_reserve_pol_post_dispute error", ebufp);
			PIN_FLIST_DESTROY_EX(&search_flistp, NULL);
		return;
	} else {
		PIN_ERR_CLEAR_ERR(ebufp);
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"fm_reserve_set_flist_for_reservation return flist", 
			res_flistp);
	}  
	PIN_FLIST_DESTROY_EX(&search_flistp, NULL);
	
	
	/*****************************************************
         *  for PCM_OP_RESERVE_CREATE
         ******************************************************/
	 fm_reserve_create_reservation(ctxp, res_flistp, &out_flistp, ebufp);

	/***********************************************************
	 * Errors?
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_reserve_pol_post_dispute error", ebufp);
		PIN_FLIST_DESTROY_EX(&res_flistp, NULL); 
		return;
	} else {
		PIN_FLIST_FLD_SET(out_flistp, PIN_FLD_POID, 
				(void *)item_poidp, ebufp);	 
		/***************************************************
		* set  the return flist
		***************************************************/
		PIN_ERR_CLEAR_ERR(ebufp);
		PIN_FLIST_DESTROY_EX(&res_flistp, NULL); 
		*r_flistpp = out_flistp;
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		     "op_reserve_pol_post_dispute return flist", *r_flistpp);
	}  
	
	return;
}

/*************************************************************
 * Search to get dispute events from a dispute item
 *************************************************************/
static void fm_reserve_get_dispute_events(ctxp, item_pdp, r_flistpp, ebufp)
        pcm_context_t*     ctxp;
	poid_t*        item_pdp;
	pin_flist_t** r_flistpp;
	pin_errbuf_t*     ebufp; 
{
        pin_flist_t    *s_flistp    = NULL;
        pin_flist_t  *sub_flistp    = NULL;
        pin_flist_t  *arg_flistp    = NULL;
	pin_flist_t  *ret_flistp    = NULL;
	poid_t	   *search_poidp    = NULL;	
        poid_t     *d_event_poidp   = NULL;
	
        char          *search_template;
        u_int32       s_flags = 256;
        int64         database = PIN_POID_GET_DB(item_pdp);
	
	if (PIN_ERR_IS_ERR(ebufp))
                return;
        PIN_ERR_CLEAR_ERR(ebufp);

	/******************************************
         * Form flist for search 
         *****************************************/
        s_flistp = PIN_FLIST_CREATE(ebufp);
        search_poidp = PIN_POID_CREATE(database, "/search", -1, ebufp);
        PIN_FLIST_FLD_PUT(s_flistp, PIN_FLD_POID, (void *)search_poidp, ebufp);
        search_template = " select X from /event where F1 = V1 and F2 like V2 ";
        PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_TEMPLATE, (void *)search_template, 
				ebufp);

        PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_FLAGS, (void *)&s_flags, ebufp);

        arg_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS, 1, ebufp);
        PIN_FLIST_FLD_SET(arg_flistp, PIN_FLD_ITEM_OBJ, (void *)item_pdp, 
				ebufp);
        arg_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS, 2, ebufp);
        d_event_poidp = PIN_POID_CREATE(database, PIN_OBJ_TYPE_EVENT_DISPUTE,
				-1, ebufp);
	PIN_FLIST_FLD_PUT(arg_flistp, PIN_FLD_POID, (void *)d_event_poidp, 
				ebufp);
	sub_flistp =  PIN_FLIST_CREATE(ebufp);
	PIN_FLIST_FLD_SET(sub_flistp, PIN_FLD_POID, NULL, ebufp);
	PIN_FLIST_FLD_SET(sub_flistp, PIN_FLD_SESSION_OBJ, NULL, ebufp);
	PIN_FLIST_ELEM_SET(s_flistp, sub_flistp, PIN_FLD_RESULTS, 0, ebufp);

        /*****************************************************************
         * Search for dispute events to be settled 
         *****************************************************************/
        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Search Input Flist", s_flistp);

        PCM_OP(ctxp, PCM_OP_SEARCH, 0, s_flistp, &ret_flistp, ebufp);

        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Search Output Flist", ret_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "Seacrh  error", ebufp);
		 PIN_FLIST_DESTROY_EX(&s_flistp, NULL);
		 PIN_FLIST_DESTROY_EX(&sub_flistp, NULL);
		 return;
	} 
        /* Deallocate maemories */
        PIN_FLIST_DESTROY_EX(&s_flistp, NULL);
	PIN_FLIST_DESTROY_EX(&sub_flistp, NULL);
	
	*r_flistpp = ret_flistp;
}
/*****************************************************************
* sets the flist for Resource Reservation
*****************************************************************/
static void fm_reserve_set_flist_for_reservation(ctxp, i_flistp, r_flistpp, ebufp)
        pcm_context_t*     ctxp;
	pin_flist_t*   i_flistp;
	pin_flist_t**   r_flistpp;
	pin_errbuf_t*     ebufp; 
{
	int32		elem_id = 0;
	int32		elem_id1 = 0;
	int32		elem_id2 = 0;
	int32		elem_id3 = 0;
	int32		event_id = 0;
	int32		event1_id = 0;
	int32		event2_id = 0;
	int32		bal_id = 0;
	int32		elem_res_id = 0;
	int32		elem_bal_id = 0;
	pin_decimal_t	*temp_amountp = 0;
	pin_decimal_t	*amountp = 0;
	pin_decimal_t	*amountp1 = 0;
	pin_decimal_t   *tmp_bal_amountp = 0;
	poid_t		*ac_pdp;
	poid_t		*a_pdp;
	poid_t		*item_poidp;
	poid_t		*temp_ac_pdp;
	poid_t 		*event_pdp;
	int32		*res_idp;
	poid_t		*item_pdp;
	pin_cookie_t	cookie = NULL;
	pin_cookie_t	cookie1 = NULL;
	pin_cookie_t	cookie2 = NULL;
	pin_cookie_t	cookie3 = NULL;
	pin_flist_t	*res_flistp;
	pin_flist_t	*item_disp_flistp = NULL;
	pin_flist_t	*bal_imp_flistp = NULL;
	pin_flist_t	*bal_new_flistp = NULL;
	pin_flist_t	*sub_bal_flistp = NULL;
	pin_flist_t	*result_flistp = NULL;
	pin_flist_t	*read_flistp = NULL;
	pin_flist_t	*bal_flistp = NULL;
	pin_flist_t	*a_flistp = NULL;
	pin_flist_t	*ia_flistp = NULL;	
	pin_flist_t	*b_flistp = NULL;
	pin_flist_t	*c_flistp = NULL;
	pin_flist_t	*d_flistp = NULL;
	pin_flist_t	*e_flistp = NULL;
	pin_flist_t	*f_flistp = NULL;
	pin_flist_t	*event_flistp = NULL;
	pin_time_t 	*expiration_t;
	pin_flist_t	*out_flistp = NULL;
	pin_flist_t	*tmp_flistp = NULL;
	int32 		i = 0;
	int32		res_found_flag = 0;
	int32		result;
	int32		impact_type;
	void		*vp = NULL;
	void		*dummyp = NULL;
	
	
	if (PIN_ERR_IS_ERR(ebufp))
                return;
        PIN_ERR_CLEAR_ERR(ebufp);
	
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Input Flist in fm_reserve_set_flist_for_reservation", 
			i_flistp);
	res_flistp = PIN_FLIST_CREATE(ebufp);
	item_poidp = (poid_t *) PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_ITEM_OBJ, 
				0, ebufp);
	PIN_FLIST_FLD_SET(res_flistp, PIN_FLD_POID, 
				(void *)item_poidp, ebufp);
	
	 /***********************************************************
         * Errors?
         ***********************************************************/
        if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "fm_reserve_set_flist_for_reservation error", ebufp);
		result = PIN_RESULT_FAIL;
		PIN_FLIST_FLD_SET(res_flistp, PIN_FLD_RESULT,(void *)&result, 
				ebufp);
		*r_flistpp = res_flistp;
		return;
	}
	
	event_flistp = PIN_FLIST_CREATE(ebufp);
	
	/*********************************************************************
	 * This while loop goes through the events and then find out the
	 * available resources based on the BALANCE_IMPACT & SUB_BAL_IMPACT 
	 * array, compose together and then send for the resource reservation.
	 *********************************************************************/
	while ( (result_flistp = PIN_FLIST_ELEM_GET_NEXT (i_flistp, 
		 PIN_FLD_RESULTS, &elem_id, 1, &cookie, ebufp)) != 
     		 (pin_flist_t *)NULL )
	{
		event_pdp = (poid_t *)PIN_FLIST_FLD_GET( result_flistp, 
				PIN_FLD_POID, 0, ebufp);
		read_flistp = PIN_FLIST_CREATE(ebufp);
		PIN_FLIST_FLD_SET(read_flistp, PIN_FLD_POID, 
					(void *)event_pdp, ebufp);
		tmp_flistp = PIN_FLIST_ELEM_ADD(read_flistp,
				PIN_FLD_SUB_BAL_IMPACTS, PIN_ELEMID_ANY, ebufp);
		PIN_FLIST_FLD_SET(tmp_flistp, PIN_FLD_SUB_BALANCES,
					dummyp, ebufp);
		PIN_FLIST_ELEM_ADD( read_flistp,
				PIN_FLD_BAL_IMPACTS, PIN_ELEMID_ANY, ebufp);
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_ar_reserve_dispute: i/p Flist for Read Fields",
			read_flistp);
		PCM_OP(ctxp, PCM_OP_READ_FLDS, 0, read_flistp, &ia_flistp, 
			ebufp);
		
	
		if (PIN_ERR_IS_ERR(ebufp)) {
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_ar_reserve_dispute: Error during read error", ebufp);
			PIN_FLIST_DESTROY_EX (&read_flistp, NULL );
			PIN_FLIST_DESTROY_EX (&ia_flistp, NULL );
			PIN_FLIST_DESTROY_EX (&event_flistp, NULL );
			return;
		}
		
		PIN_FLIST_DESTROY_EX (&read_flistp, NULL );
		
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Output Flist for Read Object", ia_flistp);
		
		a_flistp = PIN_FLIST_ELEM_ADD(event_flistp, PIN_FLD_EVENTS, 
			event_id, ebufp);
		PIN_FLIST_FLD_SET(a_flistp, PIN_FLD_POID, (void *)event_pdp, 
				  ebufp);
		 
		cookie1 = NULL;
		while ( (b_flistp = PIN_FLIST_ELEM_GET_NEXT (ia_flistp, 
			PIN_FLD_SUB_BAL_IMPACTS, &bal_id, 1, &cookie1, ebufp))
			!=	(pin_flist_t *)NULL )
		 {
			c_flistp = PIN_FLIST_ELEM_ADD(a_flistp, 
				PIN_FLD_SUB_BAL_IMPACTS,  event1_id , ebufp);
			res_idp = (int32 *)PIN_FLIST_FLD_GET(b_flistp, 
				PIN_FLD_RESOURCE_ID, 0, ebufp);
			PIN_FLIST_FLD_SET(c_flistp, PIN_FLD_RESOURCE_ID, 
				(void *)res_idp,  ebufp);
			sub_bal_flistp = (pin_flist_t *)PIN_FLIST_ELEM_GET(
						b_flistp, PIN_FLD_SUB_BALANCES,
						PIN_ELEMID_ANY, 0, ebufp);   
			expiration_t  = (pin_time_t *)PIN_FLIST_FLD_GET(
				sub_bal_flistp, PIN_FLD_VALID_TO, 1, ebufp);
			if (expiration_t == (pin_time_t *) NULL)
				expiration_t =  (pin_time_t *) &i;
			PIN_FLIST_FLD_SET(c_flistp, PIN_FLD_VALID_TO, 
				(void *)expiration_t, ebufp);
			event1_id = event1_id + 1;
		 }
		 PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Output Flist After adding sub_bal_impacts", a_flistp);
		 event1_id = 0;
		 bal_id = 0;
		 cookie2 = NULL;
		 while ( (d_flistp = PIN_FLIST_ELEM_GET_NEXT (ia_flistp, 
			 PIN_FLD_BAL_IMPACTS, &bal_id, 1, &cookie2, ebufp)) 
		 	!= (pin_flist_t *)NULL )
		 {
			ac_pdp = (poid_t *)PIN_FLIST_FLD_GET( d_flistp, 
				PIN_FLD_ACCOUNT_OBJ, 0, ebufp);
			res_idp	= (int32 *)PIN_FLIST_FLD_GET( d_flistp, 
				PIN_FLD_RESOURCE_ID, 0, ebufp);
			amountp = (pin_decimal_t *)PIN_FLIST_FLD_GET( d_flistp, 
				PIN_FLD_AMOUNT, 0, ebufp);
			vp = (int32 *)PIN_FLIST_FLD_GET( d_flistp, 
				PIN_FLD_IMPACT_TYPE, 0, ebufp);
			if (vp)
			{
				impact_type = *(int32 *)vp;
				/********************************************
				* Reservation should not happen for Tax-portion
				* In case of Tax-Reversal for dispute event,
				* ignore bal_impact for tax-reversal where 
				* Impact_type ==  PIN_IMPACT_TYPE_TAX  
				**********************************************/
				if ( impact_type ==  PIN_IMPACT_TYPE_TAX )
					continue;
			}
			amountp1 = pbo_decimal_negate ( amountp, ebufp );
			f_flistp = PIN_FLIST_ELEM_ADD(a_flistp, 
				PIN_FLD_BAL_IMPACTS,  event2_id, ebufp);
			PIN_FLIST_FLD_SET( f_flistp, PIN_FLD_POID, 
				(void *)ac_pdp, ebufp);
			PIN_FLIST_FLD_SET( f_flistp, PIN_FLD_RESOURCE_ID,
				(void *)res_idp, ebufp);
			PIN_FLIST_FLD_PUT(f_flistp, PIN_FLD_AMOUNT, 
				(void *)amountp1, ebufp);
			event2_id = event2_id + 1;		
		 }
		event2_id = 0;
		bal_id = 0;
		event_id += 1;
	}
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"Event Flist before creating Resource"
		" Reservation flist" , event_flistp);
	
	cookie = NULL;
	while ( (e_flistp = PIN_FLIST_ELEM_GET_NEXT (event_flistp, 
		 PIN_FLD_EVENTS, &elem_id1, 1, &cookie, ebufp)) != 
     		 (pin_flist_t *)NULL )
	{
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Events flist inside while" , e_flistp);
		sub_bal_flistp = (pin_flist_t *)PIN_FLIST_ELEM_GET(e_flistp,
					PIN_FLD_SUB_BAL_IMPACTS ,elem_id2, 0, 
					ebufp);
		expiration_t = (pin_time_t *)PIN_FLIST_FLD_GET( sub_bal_flistp, 
					PIN_FLD_VALID_TO, 1, ebufp);
		cookie1 = NULL;
		while ( (bal_imp_flistp = PIN_FLIST_ELEM_GET_NEXT (e_flistp, 
			 PIN_FLD_BAL_IMPACTS, &bal_id, 1, &cookie1, ebufp)) != 
			 (pin_flist_t *)NULL )
		{
		  
			a_pdp = (poid_t *)PIN_FLIST_FLD_GET( bal_imp_flistp, 
					PIN_FLD_POID, 0, ebufp);
			res_idp	= (int32 *)PIN_FLIST_FLD_GET( bal_imp_flistp, 
					PIN_FLD_RESOURCE_ID, 0, ebufp);
			amountp	= (pin_decimal_t *)PIN_FLIST_FLD_GET( 
					bal_imp_flistp, PIN_FLD_AMOUNT, 
					0, ebufp);
		
			cookie2 = NULL;
			while(( out_flistp = PIN_FLIST_ELEM_GET_NEXT(res_flistp, 
				PIN_FLD_RESERVATION_LIST, &elem_res_id, 1, 
			  	&cookie2, ebufp)) != (pin_flist_t *)NULL)
			  {
				res_found_flag = 0;
				cookie3 = NULL;
				while(( bal_flistp = PIN_FLIST_ELEM_GET_NEXT(
					out_flistp, PIN_FLD_BALANCES, 
					&elem_bal_id, 1, &cookie3, ebufp)) != 
					(pin_flist_t *)NULL)
				{
					if ( (res_idp != NULL) && (elem_bal_id == *res_idp))
					{
					   temp_amountp = (pin_decimal_t *)
					   	PIN_FLIST_FLD_GET(bal_flistp, 
						PIN_FLD_AMOUNT, 1, ebufp);
					   tmp_bal_amountp = pbo_decimal_copy(
						amountp,ebufp);
					   pbo_decimal_add_assign
					   	( tmp_bal_amountp, temp_amountp, ebufp);
					   PIN_FLIST_FLD_PUT(bal_flistp,
					   	PIN_FLD_AMOUNT, 
						(void *)tmp_bal_amountp, ebufp);
					   res_found_flag = 1;
					}
					else
					{
					   res_found_flag = 0;
					}
				}
			  }
		
			  if( !res_found_flag ) 
			  {
				out_flistp = PIN_FLIST_ELEM_ADD(res_flistp, 
						PIN_FLD_RESERVATION_LIST, 
						elem_id3, ebufp);
				PIN_FLIST_FLD_SET(out_flistp, PIN_FLD_POID,
						(void *)a_pdp, ebufp);
				PIN_FLIST_FLD_SET(out_flistp, 
						PIN_FLD_SESSION_OBJ,
						(void *)item_poidp, ebufp);
				PIN_FLIST_FLD_SET(out_flistp, 
						PIN_FLD_EXPIRATION_T, 
						(void *)expiration_t, ebufp);
				if (res_idp != NULL) {
					bal_new_flistp = PIN_FLIST_ELEM_ADD(out_flistp,
							PIN_FLD_BALANCES,
							*res_idp, ebufp);
					PIN_FLIST_FLD_SET(bal_new_flistp, 
						PIN_FLD_AMOUNT,
						(void *)amountp, ebufp);  
				}
				elem_id3 += 1;
			}
		}
	}
	
	PIN_FLIST_DESTROY_EX (&event_flistp, NULL );
	PIN_FLIST_DESTROY_EX (&ia_flistp, NULL );
	
	 /***********************************************************
         * Errors?
         ***********************************************************/
        if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "fm_reserve_set_flist_for_reservation error", ebufp);
		result = PIN_RESULT_FAIL;
		PIN_FLIST_FLD_SET(res_flistp, PIN_FLD_RESULT,(void *)&result, 
				ebufp);
		*r_flistpp = res_flistp;
		return;
	}
	*r_flistpp = res_flistp;
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Output Flist in fm_reserve_set_flist_for_reservation", 
			res_flistp );
	
}
/*****************************************************************
* Reserves the Resource based on amount
*****************************************************************/
static void fm_reserve_create_reservation(ctxp, i_flistp, r_flistpp, ebufp)
        pcm_context_t*     	ctxp;
	pin_flist_t*   		i_flistp;
	pin_flist_t**   	r_flistpp;
	pin_errbuf_t*     	ebufp; 
{
	int32  			*resultp;
	int32			elem_id = 0;
	int32			elem1_id = 0;
	pin_flist_t*   		out_flistp = NULL;
	pin_flist_t*   		ii_flistp = NULL;
	pin_flist_t*   		res_flistp = NULL;
	pin_flist_t*   		res_list_flistp = NULL;
	pin_cookie_t		cookie = NULL;
	poid_t			*res_poidp;
	int32			result;
	
	if (PIN_ERR_IS_ERR(ebufp))
                return;
        PIN_ERR_CLEAR_ERR(ebufp);
	
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Input Flist  in fm_reserve_create_reservation", 
			i_flistp );
	out_flistp = PIN_FLIST_CREATE(ebufp);
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "fm_reserve_create_reservation error", ebufp);
		result = PIN_RESULT_FAIL;
		PIN_FLIST_FLD_SET(out_flistp, PIN_FLD_RESULT,(void *)&result, 
				ebufp);
		*r_flistpp = out_flistp;
		return;
	}
	while ( (ii_flistp = PIN_FLIST_ELEM_GET_NEXT (i_flistp, 
		 PIN_FLD_RESERVATION_LIST, &elem_id, 1, &cookie, ebufp)) != 
     		 (pin_flist_t *)NULL )
	{
	
         /*****************************************************************
          * Call PCM_OP_RESERVE_CREATE
          *****************************************************************/ 
	PCM_OP(ctxp, PCM_OP_RESERVE_CREATE, 0, ii_flistp, &res_flistp, ebufp);
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Output  Flist From PCM_OP_RESERVE_CREATE", res_flistp);
	resultp = (int32 *)PIN_FLIST_FLD_GET( res_flistp, 
		PIN_FLD_RESERVATION_ACTION, 0, ebufp);
	if (!PIN_ERR_IS_ERR(ebufp) && (*resultp == PIN_RESERVATION_SUCCESS))
	{
		res_poidp = (poid_t *)PIN_FLIST_FLD_GET( res_flistp, 
				PIN_FLD_POID, 0, ebufp);
	}	
	else
	{
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "fm_reserve_create_reservation error", ebufp);
		result = PIN_RESULT_FAIL;
		PIN_FLIST_FLD_SET(out_flistp, PIN_FLD_RESULT,
				(void *)&result, ebufp);
		*r_flistpp = out_flistp;
		PIN_FLIST_DESTROY_EX(&res_flistp, NULL);		
		return;
	}			 
	
	res_list_flistp = PIN_FLIST_ELEM_ADD(out_flistp, 
				PIN_FLD_RESERVATION_LIST, elem1_id, ebufp);
	PIN_FLIST_FLD_SET(res_list_flistp, PIN_FLD_POID,
				(void *)res_poidp, ebufp);			

	PIN_FLIST_DESTROY_EX(&res_flistp, NULL);
	}

	result = PIN_RESULT_PASS;
	PIN_FLIST_FLD_SET(out_flistp, PIN_FLD_RESULT,(void *)&result, ebufp);
	
	*r_flistpp = out_flistp;
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Output Flist in fm_reserve_create_reservation", 
			*r_flistpp );
}

/*
 *
 *      Copyright (c) 2004 - 2007 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 */

/**********************************************************************
 * This file contains the PCM_OP_RESERVE_POL_POST_SETTLEMENT billing operation.
 *
 * These routines are generic and work for all account types.
 **********************************************************************/

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
#include "pin_bill.h"
#include "fm_utils.h"
#include "ops/bill.h"
#include "ops/reserve.h"
/*******************************************************************
 * Routines contained within.
 *******************************************************************/
EXPORT_OP void op_reserve_pol_post_settlement();
EXPORT_OP void fm_reserve_get_reservation_objects();

/*******************************************************************
 * Routines called from fm_reserve_pol_post_settlement
 *******************************************************************/
void fm_reserve_get_reservation_objects();

/*******************************************************************
 * Routines needed from elsewhere.
 *******************************************************************/
/*******************************************************************
 * Main routine for the PCM_OP_RESERVE_POL_POST_SETTLEMENT operation.
 *******************************************************************/
void
op_reserve_pol_post_settlement(connp, opcode, flags, i_flistp, r_flistpp, ebufp)
        cm_nap_connection_t     *connp;
        int32                   opcode;
        int32                   flags;
        pin_flist_t             *i_flistp;
        pin_flist_t             **r_flistpp;
        pin_errbuf_t            *ebufp;
{
	pcm_context_t           *ctxp = connp->dm_ctx;

        pin_flist_t             *ii_flistp = NULL;
        pin_flist_t             *res_flistp  = NULL;
        pin_flist_t             *res1_flistp  = NULL;
        pin_flist_t             *reserve_obj_flistp= NULL;
        pin_flist_t             *reserve_flistp= NULL;
        pin_flist_t             *ret_flistp= NULL;
        poid_t                  *item_poidp    = NULL;
        poid_t                  *account_obj_poidp    = NULL;
        poid_t                  *reserve_obj_poidp  = NULL;

        pin_cookie_t            cookie = NULL;
        int32                   elem_id = 0;
        int32                   e_count = 0;
        int32                   local_trans = 0;
        int                     result = PIN_RESULT_PASS;
        char*                   res_descrp;
        const char 		*poid_type = NULL;

        if (PIN_ERR_IS_ERR(ebufp))
                return;
        PIN_ERR_CLEAR_ERR(ebufp);

        /***********************************************************
         * Null out results until we have some.
         ***********************************************************/
        *r_flistpp = NULL;

            if (opcode != PCM_OP_RESERVE_POL_POST_SETTLEMENT) {
                pin_set_err(ebufp, PIN_ERRLOC_FM,
                        PIN_ERRCLASS_SYSTEM_DETERMINATE,
                        PIN_ERR_BAD_OPCODE, 0, 0, opcode);
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "op_reserve_pol_post_settlement", ebufp);
                return;
                /*****/
        }

         /***********************************************************
         * Debug: What did we get?
         ***********************************************************/
         PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                "op_reserve_pol_post_settlement input flist", i_flistp);

         /***********************************************************
         * Retrieve dispute item from input flist
         ***********************************************************/
         item_poidp = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_ITEM_OBJ, 0, ebufp);
        if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "op_reserve_pol_post_settlement error: wrong input flist",
                         ebufp);
                return;
        }
        /***********************************************************
         * Just a sanity check that given item should be dispute one
         ***********************************************************/
	poid_type = PIN_POID_GET_TYPE(item_poidp);
	if(!poid_type || (strcmp(poid_type, PIN_OBJ_TYPE_ITEM_DISPUTE)))
        {
                pin_set_err(ebufp, PIN_ERRLOC_FM,
                                PIN_ERRCLASS_SYSTEM_DETERMINATE,
                                PIN_ERR_BAD_POID_TYPE, 0, 0, 0);
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                   "poid in i/p flist is not of a dispute item", ebufp);

                return;
        }


         /*****************************************************
          *Get all reservation objects that are to be released
          *****************************************************/
         fm_reserve_get_reservation_objects(ctxp, item_poidp, &res_flistp, ebufp);

        if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_FLIST_LOG_ERR("fm_reserve_get_reservation_objects"
                        " returned error",
                        ebufp);
                return;
        }

        /*****************************************************************
          * Debug: print Search Results
          *****************************************************************/
           PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Search Results", res_flistp);

        /*****************************************************
          * Form input flist for PCM_OP_RESERVE_RELEASE
          *****************************************************/
        ii_flistp = PIN_FLIST_CREATE(ebufp);
        account_obj_poidp = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_ACCOUNT_OBJ, 0, ebufp);
        PIN_FLIST_FLD_SET(ii_flistp, PIN_FLD_POID, (void *)account_obj_poidp,
                ebufp);
        while((reserve_flistp = PIN_FLIST_ELEM_GET_NEXT(res_flistp,
                                        PIN_FLD_RESULTS, &elem_id, 1, &cookie,
                                        ebufp)) != (pin_flist_t *)NULL)
        {
                reserve_obj_poidp = PIN_FLIST_FLD_GET(reserve_flistp,
                                        PIN_FLD_POID, 0, ebufp);
                reserve_obj_flistp = PIN_FLIST_ELEM_ADD(ii_flistp,
                         PIN_FLD_RESERVATION_LIST, e_count++, ebufp);
                PIN_FLIST_FLD_SET(reserve_obj_flistp, PIN_FLD_RESERVATION_OBJ,
                         (void *)reserve_obj_poidp, ebufp);
        }

        /*********************************************************************
         * Open a transaction
        **********************************************************************/
        local_trans = fm_utils_trans_open(ctxp, PCM_TRANS_OPEN_LOCK_OBJ,
            account_obj_poidp, ebufp);


        /*****************************************************************
          * Debug: print input flist for PCM_OP_RESERVE_RELEASE
          *****************************************************************/
           PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Input Flist For PCM_OP_RESERVE_RELEASE", ii_flistp);

         /*****************************************************************
	 * Call PCM_OP_RESERVE_RELEASE
          *****************************************************************/
        PCM_OP(ctxp, PCM_OP_RESERVE_RELEASE, 0, ii_flistp, &res1_flistp, ebufp);
        if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "op_reserve_pol_post_settlement: PCM_OP_RESERVE_RELEASE"
                        "returned error", ebufp);
                goto Done;
        } else {
        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Output  Flist From PCM_OP_RESERVE_RELEASE",
                        res1_flistp);
        }
        /*****************************************************************
          * Prepare output flist
          *****************************************************************/
        ret_flistp = PIN_FLIST_CREATE(ebufp);
        res_descrp = (char*)"Successfully Released";
        account_obj_poidp = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_ACCOUNT_OBJ, 0, ebufp);
        PIN_FLIST_FLD_SET(ret_flistp, PIN_FLD_POID, (void *)account_obj_poidp,
                 ebufp);
        PIN_FLIST_FLD_SET(ret_flistp, PIN_FLD_RESULT, (void*)&result, ebufp);
        PIN_FLIST_FLD_SET(ret_flistp, PIN_FLD_DESCR, (void *)res_descrp, ebufp);

        Done:
                PIN_FLIST_DESTROY_EX(&ii_flistp, NULL);
                PIN_FLIST_DESTROY_EX(&res_flistp, NULL);
                PIN_FLIST_DESTROY_EX(&res1_flistp, NULL);

        /***********************************************************
         * Errors?
         ***********************************************************/
        if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "op_reserve_pol_post_settlement error", ebufp);
                fm_utils_trans_abort(ctxp, NULL);
                ret_flistp = PIN_FLIST_CREATE(ebufp);
                res_descrp = (char*)"Failed to Release";
                result = PIN_RESULT_FAIL;
                account_obj_poidp = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_ACCOUNT_OBJ,
                                        0, ebufp);
                PIN_FLIST_FLD_SET(ret_flistp, PIN_FLD_POID,
                                        (void *)account_obj_poidp, ebufp);
                PIN_FLIST_FLD_SET(ret_flistp, PIN_FLD_RESULT,
                                        (void*)&result, ebufp);
                PIN_FLIST_FLD_SET(ret_flistp, PIN_FLD_DESCR,
                                        (void *)res_descrp, ebufp);
                *r_flistpp = ret_flistp;
                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                     "op_reserve_pol_post_settlement return flist", *r_flistpp);
        } else {

                /***************************************************
                * Point the real return flist to the right thing.
                ***************************************************/
                PIN_ERR_CLEAR_ERR(ebufp);
                fm_utils_trans_close(ctxp, local_trans, ebufp);
                *r_flistpp = ret_flistp;
                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                     "op_reserve_pol_post_settlement return flist", *r_flistpp);
        }

        return;
}


/*************************************************************
 * Search to get all reservation objects for a given dispute item
 *************************************************************/
void fm_reserve_get_reservation_objects(ctxp, item_pdp, r_flistpp, ebufp)
        pcm_context_t*     ctxp;
        poid_t*        item_pdp;
        pin_flist_t** r_flistpp;
        pin_errbuf_t*     ebufp;
{
        pin_flist_t    *s_flistp    = NULL;
        pin_flist_t  *sub_flistp    = NULL;
        pin_flist_t  *arg_flistp    = NULL;
        poid_t     *search_poidp    = NULL;
        poid_t     *d_reservation_poidp   = NULL;

        char          *search_template;
        u_int32       s_flags = 256;
        u_int32       reserve_status;
        int64         database = PIN_POID_GET_DB(item_pdp);

        /******************************************
         * Form flist for search
         *****************************************/
        s_flistp = PIN_FLIST_CREATE(ebufp);
        search_poidp = PIN_POID_CREATE(database, "/search", -1, ebufp);
        PIN_FLIST_FLD_PUT(s_flistp, PIN_FLD_POID, (void *)search_poidp, ebufp);
        search_template = " select X from /reservation where F1 = V1 and "
                " F2 != V2 and F3 like V3 ";
        PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_TEMPLATE, (void *)search_template,
                        ebufp);

        PIN_FLIST_FLD_SET(s_flistp, PIN_FLD_FLAGS, (void *)&s_flags, ebufp);

        arg_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS, 1, ebufp);
        PIN_FLIST_FLD_SET(arg_flistp, PIN_FLD_SESSION_OBJ, (void *)item_pdp,
                         ebufp);
        arg_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS, 2, ebufp);
        reserve_status = PIN_RESERVATION_RELEASED;
        PIN_FLIST_FLD_SET(arg_flistp, PIN_FLD_RESERVATION_STATUS,
                (void *)&reserve_status, ebufp);
        arg_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS, 3, ebufp);
        d_reservation_poidp = PIN_POID_CREATE(database,
                        "/reservation", -1, ebufp);
        PIN_FLIST_FLD_PUT(arg_flistp, PIN_FLD_POID, (void *)d_reservation_poidp,
                        ebufp);
        sub_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_RESULTS, 0, ebufp);
        PIN_FLIST_FLD_SET(sub_flistp, PIN_FLD_ACCOUNT_OBJ, NULL, ebufp);
        PIN_FLIST_FLD_SET(sub_flistp, PIN_FLD_POID, NULL, ebufp);

        /*****************************************************************
         * Search for reservation to be released
         *****************************************************************/
        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Search Input Flist", s_flistp);

        PCM_OP(ctxp, PCM_OP_SEARCH, 0, s_flistp, r_flistpp, ebufp);

        /***********************************************************
         * Errors?
         ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
                PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
                        "fm_reserve_get_reservation_objects: PCM_OP_SEARCH"
                        "returns error", ebufp);
        } else {

                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                        "Search Output Flist", *r_flistpp);
        }

        /* Deallocate memories */
        PIN_FLIST_DESTROY_EX(&s_flistp, NULL);
}



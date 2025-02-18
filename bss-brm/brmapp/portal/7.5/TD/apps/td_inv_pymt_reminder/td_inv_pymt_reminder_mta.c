/*******************************************************************
 *
 *	Copyright (c) 1999-2007 Oracle. All rights reserved.
 *
 *	This material is the confidential property of Oracle Corporation
 *	or its licensors and may be used, reproduced, stored or transmitted
 *	only in accordance with a valid Oracle license or sublicense agreement.
 *
 *------------------------------------------------------------------------------
 * Author: Dev Sharma
 * Date:   23-July-2014
 *------------------------------------------------------------------------------ 
*******************************************************************/

#ifndef lint
static  char    Sccs_id[] = "@(#)%Portal Version: pin_mta_test.c:CUPmod7.3PatchInt:1:2007-Feb-07 06:51:33 %";
#endif

#include <stdio.h>
#include <stdlib.h>
#include "pcm.h"
#include "pin_errs.h"
#include "pinlog.h"

#include "pin_mta.h"
#include "cm_fm.h"
#include "ops/pymt.h"

#include "fm_utils.h"
#include "fm_bill_utils.h"
#include "ops/base.h"
#include "pin_pymt.h"
#include "pin_errs.h"
#include "pinlog.h"
/*******************************************************************
 * During real application development, there is no necessity to implement 
 * empty MTA call back functions. Application will recognize implemented
 * functions automatically during run-time.
 *******************************************************************/

pin_flist_t*  td_get_inv_dd_info(
                 pcm_context_t   *ctxp,
                 pin_flist_t     *op_in_flistp,
                 pin_flist_t     *srch_res_flistp,
		 pin_errbuf_t    *ebufp);

/*Global variable */
int create_count;
char *profile_id = NULL;

/*Function to generate notification event. 07-Nov-2014 -Dev/Sukanya*/
extern void
td_generate_notification_event(
      pcm_context_t           *ctxp,
      poid_t                  *acct_pdp,
      char              *bill_no,
      char              *action_strp,
      pin_flist_t       *i_flistp,
      pin_flist_t       **r_flistp,
      pin_errbuf_t            *ebufp);

/*******************************************************************
 * Configuration of application
 * Called prior MTA_CONFIG policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_config(
		pin_flist_t		*param_flistp,
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{
	int32		rec_id = 0;
	pin_cookie_t	cookie = 0;
	pin_cookie_t	prev_cookie = 0;
	pin_flist_t	*flistp = 0;
	char		*option = 0;
	int32		mta_flags = 0;
	void		*vp = 0;
	int32		i = 0;
	long		vp_l;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_config parameters flist", 
					   param_flistp);
	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_config application info flist", 
					   app_flistp);

	vp = PIN_FLIST_FLD_GET (app_flistp, PIN_FLD_FLAGS, 0,ebufp);
	if(vp)
		mta_flags = *((int32*)vp);

	/***********************************************************
         * The new flag MTA_FLAG_VERSION_NEW has been introduced to
         * differentiate between new mta & old mta applications as
         * only new applications have the ability to drop PIN_FLD_PARAMS
         * for valid parameters . It is only for new apps that
         * checking err_params_cnt is valid, otherwise for old applications
         * this check without a distincion for new applications would hamper
         * normal functioning.
         ***********************************************************/
	mta_flags = mta_flags | MTA_FLAG_VERSION_NEW;
	while((flistp = /*!=NULL*/
		   PIN_FLIST_ELEM_GET_NEXT(param_flistp, PIN_FLD_PARAMS, &rec_id,
								   1, &cookie, ebufp))!= NULL){
		
		option = PIN_FLIST_FLD_GET (flistp, PIN_FLD_PARAM_NAME, 0, ebufp);
		/***************************************************
		 * Test options options.
		 ***************************************************/
		if(option && (strcmp(option, "-batch_mode") == 0)) {	

			mta_flags = mta_flags | MTA_FLAG_BATCH_MODE;	

			PIN_FLIST_ELEM_DROP(param_flistp, PIN_FLD_PARAMS, rec_id, ebufp);
			cookie = prev_cookie;

		} else if(option && (strcmp(option, "-header_number") == 0)) {

			vp = PIN_FLIST_FLD_GET (flistp, PIN_FLD_PARAM_VALUE, 1, ebufp);

			if(vp == 0) {
				mta_flags = mta_flags | MTA_FLAG_USAGE_MSG;
			}else{
				i = atoi ((char*)vp);
				PIN_FLIST_FLD_SET (app_flistp, PIN_FLD_HEADER_NUM, &i, ebufp);
			}

			PIN_FLIST_ELEM_DROP(param_flistp, PIN_FLD_PARAMS, rec_id, ebufp);
			cookie = prev_cookie;

		}else if(option && (strcmp(option, "-increment") == 0)) {

			vp = PIN_FLIST_FLD_GET (flistp, PIN_FLD_PARAM_VALUE, 1, ebufp);

			if(vp) {
				i = atoi ((char*)vp);
				PIN_FLIST_FLD_SET (app_flistp, PIN_FLD_INCR_AMOUNT, &i, ebufp);
			}

			PIN_FLIST_ELEM_DROP(param_flistp, PIN_FLD_PARAMS, rec_id, ebufp);
			cookie = prev_cookie; 
		}else if(option && (strcmp(option, "-error") == 0)) {

			vp = PIN_FLIST_FLD_GET (flistp, PIN_FLD_PARAM_VALUE, 1, ebufp);

			if(vp == 0) {
				mta_flags = mta_flags | MTA_FLAG_USAGE_MSG;
			}else{
				i = atoi ((char*)vp);
				PIN_FLIST_FLD_SET (app_flistp, PIN_FLD_OPS_ERROR, &i, ebufp);
			}

			PIN_FLIST_ELEM_DROP(param_flistp, PIN_FLD_PARAMS, rec_id, ebufp);
			cookie = prev_cookie;

		} else if(option && (strcmp(option, "-opt2") == 0)) {

			PIN_FLIST_FLD_SET (app_flistp, PIN_FLD_ACTION_NAME, option, ebufp);
			
			vp = PIN_FLIST_FLD_GET (flistp, PIN_FLD_PARAM_VALUE, 1, ebufp);

			if((vp == 0) || (strcmp ("param2.1 param2.2", vp) != 0)) {
				mta_flags = mta_flags | MTA_FLAG_USAGE_MSG;
			}else{
				PIN_FLIST_FLD_SET (app_flistp, PIN_FLD_FILTER_STRING, vp, ebufp);
			}

			PIN_FLIST_ELEM_DROP(param_flistp, PIN_FLD_PARAMS, rec_id, ebufp);
			cookie = prev_cookie;

		} else if(option && (strcmp(option, "-opt3") == 0)) {

			vp = PIN_FLIST_FLD_GET (flistp, PIN_FLD_PARAM_VALUE, 1, ebufp);

			if((vp == 0) || (strcmp ("param3.1", vp) != 0)) {
				mta_flags = mta_flags | MTA_FLAG_USAGE_MSG;
			}else{
				PIN_FLIST_FLD_SET (app_flistp, PIN_FLD_CRITERION, vp, ebufp);
			}
		
			PIN_FLIST_ELEM_DROP(param_flistp, PIN_FLD_PARAMS, rec_id, ebufp);
			cookie = prev_cookie;
		} 
		else if(option && (strcmp(option, "-profilename") == 0)) {

                        vp = PIN_FLIST_FLD_GET (flistp, PIN_FLD_PARAM_VALUE, 1, ebufp);

                        if((vp == 0) ) {
                                mta_flags = mta_flags | MTA_FLAG_USAGE_MSG;
                        }else{
                                PIN_FLIST_FLD_SET (app_flistp, PIN_FLD_PROFILE_ID, vp, ebufp);


                        }

                        PIN_FLIST_ELEM_DROP(param_flistp, PIN_FLD_PARAMS, rec_id, ebufp);
                        cookie = prev_cookie;
                }//Added Dev Sharma
                else if(option && (strcmp(option, "-reminderdate") == 0)) {

                        vp = PIN_FLIST_FLD_GET (flistp, PIN_FLD_PARAM_VALUE, 1, ebufp);

                        if((vp == 0) ) {
                                mta_flags = mta_flags | MTA_FLAG_USAGE_MSG;
                        }else{
				vp_l = atol((char *)PIN_FLIST_FLD_GET (flistp, PIN_FLD_PARAM_VALUE, 1, ebufp));	
				PIN_FLIST_FLD_SET (app_flistp, PIN_FLD_DUE_T, (void *)&vp_l, ebufp);

                        }

                        PIN_FLIST_ELEM_DROP(param_flistp, PIN_FLD_PARAMS, rec_id, ebufp);
                        cookie = prev_cookie;
                }//Added Dev Sharma
		else {
			prev_cookie = cookie;
		}
	}

	PIN_FLIST_FLD_SET (app_flistp, PIN_FLD_FLAGS, &mta_flags, ebufp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_config error", ebufp);
	}
	return;
}

/*******************************************************************
 * Post configuration of application
 * Called after MTA_CONFIG policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_config(
		pin_flist_t		*param_flistp,
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_config parameters flist", 
					   param_flistp);
	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_config application info flist", 
					   app_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_config error", ebufp);
	}
	return;
}

/*******************************************************************
 * Usage information for the specific app.
 * Called prior MTA_USAGE policy opcode
 *******************************************************************/
PIN_EXPORT void
pin_mta_usage(
		char	*prog)
{

	pin_errbuf_t	ebuf;
	pin_flist_t	*ext_flistp = NULL;
	char		*usage_str = NULL;

	char		*format = "\nUsage:\t %s [-verbose] [-test] \n"
			"\t\t -header_number <number> \n"
			"\t\t -increment <!-- <number> --> ; default 1\n"
			"\t\t -batch_mode ; default single mode\n"
			"\t\t -opt2 param2.1 param2.2\n"
			"\t\t -opt3 param3.1\n";

	PIN_ERRBUF_CLEAR (&ebuf);
	
	usage_str = (char*)pin_malloc( strlen(format) + strlen(prog) + 1 );

	if (usage_str == NULL) {
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR,"No Memory error");
		return;
	}

	sprintf(usage_str, format ,prog);

	ext_flistp =
		pin_mta_global_flist_node_get_no_lock (PIN_FLD_EXTENDED_INFO,
											   &ebuf);

	PIN_FLIST_FLD_SET (ext_flistp, PIN_FLD_DESCR, usage_str, &ebuf)

	if (PIN_ERR_IS_ERR(&ebuf)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_usage error", &ebuf);
	}
	if (usage_str) {
		pin_free(usage_str);
	}
	return;
}

/*******************************************************************
 * Usage information for the specific app.
 * Called after MTA_USAGE policy opcode
 * Information passed from customization layer
 * can be processed and displayed here
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_usage(
		pin_flist_t		*param_flistp,
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{
	pin_flist_t	*ext_flistp = NULL;
	void		*vp = 0;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_usage parameters flist", 
					   param_flistp);
	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_usage application info flist", 
					   app_flistp);

	ext_flistp =
		pin_mta_global_flist_node_get_no_lock (PIN_FLD_EXTENDED_INFO,
											   ebufp);

	vp = PIN_FLIST_FLD_GET (ext_flistp, PIN_FLD_DESCR, 1, ebufp);

	if(vp) {
		printf("%s",(char*) vp);
	}

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_usage error", ebufp);
	}
	return;
}

/*******************************************************************
 * Initialization of application
 * Called prior MTA_INIT_APP policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_init_app(
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_app application info flist", 
					   app_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_init_app error", ebufp);
	}
	return;
}

/*******************************************************************
 * Post initialization of application
 * Called after MTA_INIT_APP policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_init_app(
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_init_app application info flist", 
					   app_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_init_app error", ebufp);
	}
	return;
}

/*******************************************************************
 * Application defined search criteria.
 * Called prior MTA_INIT_SEARCH policy opcode
 *******************************************************************/
PIN_EXPORT void
pin_mta_init_search(
		pin_flist_t		*app_flistp,
		pin_flist_t		**s_flistpp,
		pin_errbuf_t	*ebufp)
{

	 pin_flist_t     *s_flistp = NULL;

	 char            template[500] = {"select /*+ index(bill_t TD_BILL_DUE_T__ID)*/ X from /bill 1, /payinfo 2, /billinfo 3, /profile/collections_params 4 where (2.F1 = V1 or (2.F13 = V13 and 2.F14 >= V14)) and 1.F2 = 2.F3 and 1.F4 > V4 and 1.F5 <= V5 and 1.F5 >= (V5 - 864000) and 1.F2 = 3.F6 and 2.F8 = 3.F9 and 3.F7 = V7 and 3.F10 = 4.F11 and 4.F12 = V12 and not exists (select 1 from td_notification_t td where td.bill_no = bill_t.bill_no) "};

         int32           s_flags = 256;
         poid_t          *s_pdp = NULL;
         int64           id = -1;
         int64           db = 0;
         void            *vp = NULL;
         pin_flist_t     *tmp_flistp = NULL;
	 pin_flist_t     *tmp_flistp_1 = NULL;

         poid_t          *inv_search_obj = NULL;
         poid_t          *dd_search_obj = NULL;
         pin_decimal_t   *due = NULL;
         due = pbo_decimal_from_str("0.0",ebufp);
         time_t          now = (time_t)0;
         
	 time_t          sysdate_before_N_days ;
	 time_t          *sysdate_after_N_days ;
         int32           *locale = (int32 *)NULL;
         int             err;
	 //char		 *profile_id = NULL;

	 int exempt_flag = 0;


         if (PIN_ERR_IS_ERR(ebufp)){
                 return;
         }
         PIN_ERRBUF_CLEAR (ebufp);


         PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_search application info flist", app_flistp);

         /*======================================================================
          *       Read buffer days for /payinfo/dd setup date from pin.conf file
          ======================================================================*/
         pin_conf("-", "dd_buffer_days", PIN_FLDT_INT, (caddr_t *)&locale, &(err));

        /*======================================================================
         *      Check mod_t for /payinfo/dd
	 *	if customer has setup DD recently and as per NZ policy Auto debit will not be triggered for them.  
	 *	rather invoice reminder will be send to even those customers
         *======================================================================*/
	 now = pin_virtual_time((time_t *)NULL);
	 //sysdate_before_N_days = (now - 2 * 86400);
         sysdate_before_N_days = (now - *locale * 86400);
	/*======================================================================
         *       Read No of days and profile_id
         *======================================================================*/
         profile_id = PIN_FLIST_FLD_GET(app_flistp, PIN_FLD_PROFILE_ID, 0, ebufp);
         sysdate_after_N_days = (time_t *)PIN_FLIST_FLD_GET(app_flistp, PIN_FLD_DUE_T, 0, ebufp);
	
	  /***********************************************************
          * Allocate the flist for searching.
          ***********************************************************/
          s_flistp = PIN_FLIST_CREATE(ebufp);

         /**********************************************************
          * Search flist for OBRM Initiated Payment
          ***********************************************************
        0 PIN_FLD_POID                      POID [0] 0.0.0.1 /search -1 0
0 PIN_FLD_FLAGS                      INT [0] 256
0 PIN_FLD_TEMPLATE                   STR [0] "select /\*+ index(bill_t TD_BILL_DUE_T__ID)*/ /*X from /bill 1, /payinfo 2, /billinfo 3, /profile/collections_params 4 where (2.F1 = V1 or (2.F13 = V13 and 2.F14 >= V14)) and 1.F2 = 2.F3 and 1.F4 > V4 and 1.F5 <= V5 and 1.F5 >= (V5 - 864000) and 1.F2 = 3.F6 and 2.F8 = 3.F9 and 3.F7 = V7 and 3.F10 = 4.F11 and 4.F12 = V12 and not exists (select 1 from td_notification_t  td where td.bill_no=bill_t.bill_no) "
	0 PIN_FLD_RESULTS                  ARRAY [0] allocated 7, used 7
	1     PIN_FLD_POID                  POID [0] NULL
	1     PIN_FLD_ACCOUNT_OBJ           POID [0] NULL
	1     PIN_FLD_AR_BILLINFO_OBJ       POID [0] NULL
	1     PIN_FLD_BILL_NO                STR [0] NULL
	1     PIN_FLD_DUE_T               TSTAMP [0] (0) 01/01/1970 05:30:00:000 AM
	1     PIN_FLD_INVOICE_OBJ           POID [0] NULL
	1     PIN_FLD_DUE          DECIMAL [0] NULL
	0 PIN_FLD_ARGS                     ARRAY [1] allocated 1, used 1
	1     PIN_FLD_POID                  POID [0] 0.0.0.1 /payinfo/invoice -1 0
	0 PIN_FLD_ARGS                     ARRAY [2] allocated 1, used 1
	1     PIN_FLD_ACCOUNT_OBJ           POID [0] NULL
	0 PIN_FLD_ARGS                     ARRAY [3] allocated 1, used 1
	1     PIN_FLD_ACCOUNT_OBJ           POID [0] NULL
	0 PIN_FLD_ARGS                     ARRAY [4] allocated 1, used 1
	1     PIN_FLD__DUE          DECIMAL [0] 0
	0 PIN_FLD_ARGS                     ARRAY [5] allocated 1, used 1
	1     PIN_FLD_DUE_T               TSTAMP [0] (1424862000) 25/02/2015 16:30:00:000 PM
	0 PIN_FLD_ARGS                     ARRAY [6] allocated 1, used 1
	1     PIN_FLD_ACCOUNT_OBJ           POID [0] NULL
	0 PIN_FLD_ARGS                     ARRAY [7] allocated 1, used 1
	1     PIN_FLD_EXEMPT_FROM_COLLECTIONS    INT [0] 0
	0 PIN_FLD_ARGS                     ARRAY [8] allocated 1, used 1
	1     PIN_FLD_POID                  POID [0] NULL
	0 PIN_FLD_ARGS                     ARRAY [9] allocated 1, used 1
	1     PIN_FLD_PAYINFO_OBJ           POID [0] NULL
	0 PIN_FLD_ARGS                    ARRAY [10] allocated 20, used 1
	1     PIN_FLD_POID                  POID [0] NULL
	0 PIN_FLD_ARGS                     ARRAY [11] allocated 20, used 1
	1     PIN_FLD_COLLECTIONS_PARAMS    ARRAY [0] allocated 2, used 2
	2       PIN_FLD_BILLINFO_OBJ    POID [0] NULL poid pointer
	0 PIN_FLD_ARGS                     ARRAY [12] allocated 20, used 1
	1     PIN_FLD_COLLECTIONS_PARAMS    ARRAY [0] allocated 2, used 2
	2       PIN_FLD_PROFILE_ID     STR [0] "Profile 1"
        0 PIN_FLD_ARGS                     ARRAY [13] allocated 1, used 1
        1     PIN_FLD_POID                   POID [0] 0.0.0.1 /payinfo/dd -1 0
        0 PIN_FLD_ARGS          	   ARRAY [14] allocated 20, used 1
        1     PIN_FLD_MOD_T        	   TSTAMP [0] (1427801804) Wed Apr  1 00:36:44 2015
	*/
	/***********************************************************
         * Allocate the search poid and give it to the flist.
         ***********************************************************/

         vp = PIN_FLIST_FLD_GET (app_flistp, PIN_FLD_POID_VAL, 0, ebufp);
         if(vp)
                 db = PIN_POID_GET_DB ((poid_t*)vp);

         s_pdp = PIN_POID_CREATE(db, "/search", id, ebufp);
         PIN_FLIST_FLD_PUT(s_flistp, PIN_FLD_POID,
                                           (void *)s_pdp, ebufp);

         PIN_FLIST_FLD_SET (s_flistp, PIN_FLD_FLAGS, &s_flags, ebufp);

         PIN_FLIST_FLD_SET (s_flistp, PIN_FLD_TEMPLATE, template, ebufp);

         /***********************************************************
          * Search arguments
          ***********************************************************/
         	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 1, ebufp);
         inv_search_obj = PIN_POID_CREATE(db, "/payinfo/invoice", id, ebufp);
         PIN_FLIST_FLD_PUT(tmp_flistp, PIN_FLD_POID, (void *)inv_search_obj, ebufp);

	 	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 2, ebufp);
         PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_ACCOUNT_OBJ, NULL ,ebufp);

         	tmp_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS,3, ebufp);
         PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_ACCOUNT_OBJ, NULL ,ebufp);

         	tmp_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS,4, ebufp);
         PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_DUE,due,ebufp);

         	tmp_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS,5, ebufp);
         //PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_DUE_T,&sysdate_before_N_days,ebufp);
	 PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_DUE_T,sysdate_after_N_days,ebufp);
	
	 	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 6, ebufp);
     	 PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_ACCOUNT_OBJ, NULL,ebufp);

	 	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 7, ebufp);
	 PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_EXEMPT_FROM_COLLECTIONS,&exempt_flag,ebufp); 
	
	 	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 8, ebufp);
         PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_POID, NULL ,ebufp);
	
	 	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 9, ebufp);
         PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_PAYINFO_OBJ, NULL ,ebufp);

	 //Added for change in schedule
	 	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 10, ebufp);
         PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_POID, NULL ,ebufp);

	 	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 11, ebufp);
         tmp_flistp_1 = PIN_FLIST_ELEM_ADD (tmp_flistp,PIN_FLD_COLLECTIONS_PARAMS,0, ebufp);
	 PIN_FLIST_FLD_SET(tmp_flistp_1,PIN_FLD_BILLINFO_OBJ, NULL ,ebufp);

	 	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 12, ebufp);
	 tmp_flistp_1 = PIN_FLIST_ELEM_ADD (tmp_flistp,PIN_FLD_COLLECTIONS_PARAMS,0, ebufp);
         PIN_FLIST_FLD_SET(tmp_flistp_1,PIN_FLD_PROFILE_ID, (void *)profile_id ,ebufp);

	 	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 13, ebufp);
         dd_search_obj = PIN_POID_CREATE(db, "/payinfo/dd", id, ebufp);
	 PIN_FLIST_FLD_PUT(tmp_flistp, PIN_FLD_POID, (void *)dd_search_obj, ebufp);
	 
		tmp_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS,14, ebufp);
	 PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_MOD_T,&sysdate_before_N_days,ebufp)	
         /***********************************************************
          * Search results
          ***********************************************************/
         tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_RESULTS, 0, ebufp);
          vp = 0;
         PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_POID, NULL, ebufp);
         PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_BILL_NO, vp, ebufp);
         PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_DUE, vp, ebufp);
         PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_DUE_T, (time_t *)vp, ebufp);
         PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_ACCOUNT_OBJ, vp, ebufp);
         PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_AR_BILLINFO_OBJ, vp, ebufp);

         PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_search Payment info Search flist", s_flistp);

         if (PIN_ERR_IS_ERR(ebufp)) {
                 PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_init_search error", ebufp);

                 PIN_FLIST_DESTROY_EX (&s_flistp,0);
         }else{
                 *s_flistpp = s_flistp;

                 PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_search Payment info Search flist", s_flistp);
                 PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "search flist", s_flistp);
         }


	switch (err) {
        case PIN_ERR_NONE:
		free(locale);
	}
	if(due != (pin_decimal_t *) NULL)
                 pbo_decimal_destroy(&due);
         return;


}

/*******************************************************************
 * Application defined search criteria.
 * Called after MTA_INIT_SEARCH policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_init_search(
		pin_flist_t		*app_flistp,
		pin_flist_t		*search_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_init_search application info flist", 
					   app_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_init_search search flist", 
					   search_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_init_search error", ebufp);
	}
	return;
}

/*******************************************************************
 * Search results may be updated, modified or enriched
 * Called prior MTA_TUNE policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_tune(
		pin_flist_t		*app_flistp,
		pin_flist_t		*srch_res_flistp,
		pin_errbuf_t	*ebufp)
{
	pin_flist_t	*multi_res_flistp = NULL;
	pin_flist_t	*tmp_flistp = NULL;
	int32		i = 0;
	int32		mta_flags = 0;
	void		*vp = 0;
	pin_cookie_t	s_cookie = 0;
	int32		s_rec_id = 0;
	pin_cookie_t	m_cookie = 0;
	int32		m_rec_id = 0;
	int64		db = 0;
	int64		id = 0;
	pin_const_poid_type_t		type = 0;
	poid_t		*pdp = 0;
	poid_t		*n_pdp = 0;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_tune application info flist", 
					   app_flistp);
	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_tune search results flist", 
					   srch_res_flistp);

	vp = PIN_FLIST_FLD_GET (app_flistp, PIN_FLD_OPS_ERROR, MTA_OPTIONAL,ebufp);
	if(vp)
		i = *((int32*)vp);

	if (i) {

		while((multi_res_flistp = 
			   PIN_FLIST_ELEM_GET_NEXT(srch_res_flistp, PIN_FLD_MULTI_RESULTS,
									   &s_rec_id, 1, &s_cookie, ebufp)) != NULL) {

			m_cookie = 0;
			while((tmp_flistp = 
				   PIN_FLIST_ELEM_GET_NEXT(multi_res_flistp, PIN_FLD_RESULTS,
										   &m_rec_id, 1, &m_cookie, ebufp)) != NULL) {

				vp = PIN_FLIST_FLD_TAKE (tmp_flistp, PIN_FLD_POID, 0, ebufp);

				if(vp) {
					pdp = (poid_t*)vp;
					db = PIN_POID_GET_DB (pdp);
					id = PIN_POID_GET_ID (pdp);
					type = PIN_POID_GET_TYPE (pdp);
					id = id * i;
					n_pdp = PIN_POID_CREATE (db, type,id, ebufp);
					PIN_POID_DESTROY (pdp, ebufp);

					PIN_FLIST_FLD_PUT (tmp_flistp, PIN_FLD_POID, n_pdp, ebufp);
				}
			}
		}
	}

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_tune error", ebufp);
	}
	return;
}

/*******************************************************************
 * Search results may be updated, modified or enriched
 * Called after MTA_TUNE policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_tune(
		pin_flist_t		*app_flistp,
		pin_flist_t		*srch_res_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_tune application info flist", 
					   app_flistp);
	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_tune search results flist", 
					   srch_res_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_tune error", ebufp);
	}
	return;
}

/*******************************************************************
 * Function executed after seach results were processed
 * Called prior MTA_JOB_DONE policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_job_done(
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_job_done application info flist", 
					   app_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_job_done error", ebufp);
	}
	return;
}

/*******************************************************************
 * Function executed after seach results were processed
 * Called after MTA_JOB_DONE policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_job_done(
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_job_done application info flist", 
					   app_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_job_done error", ebufp);
	}
	return;
}

/*******************************************************************
 * Function executed at application exit
 * Called prior MTA_EXIT policy opcode
 *******************************************************************/
PIN_EXPORT void
pin_mta_exit(
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{
	         if (PIN_ERR_IS_ERR(ebufp)) {
                 return;
         }
         PIN_ERRBUF_CLEAR (ebufp);

         pcm_context_t   *ctxp_1;
         poid_t*     poidp=NULL;
         poid_t*     account_poid=NULL;
         pin_flist_t     *flistp = NULL;
         pin_flist_t     *eventSub = NULL;
         pin_flist_t     *r_flistp = NULL;

         int64            db = 1;

         ctxp_1 = pin_mta_main_thread_pcm_context_get(ebufp);
	

         flistp = PIN_FLIST_CREATE(ebufp);
         poidp = PIN_POID_CREATE(db,"/event/notification/td_payment_processing",-1,ebufp);
         PIN_FLIST_FLD_PUT(flistp,PIN_FLD_POID,poidp,ebufp);

         if( create_count >0 )
         {
	     PIN_FLIST_FLD_SET(flistp,PIN_FLD_COUNT, &create_count,ebufp);
         PCM_OP(ctxp_1,PCM_OP_PUBLISH_GEN_PAYLOAD,0,flistp,&r_flistp,ebufp);

		 PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Output flist for BRM Payment notification", r_flistp);

         } else

         {
             PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,"No records to process... ");

         }

	 //PIN_POID_DESTROY(poidp, NULL);
         if(flistp)
                 PIN_FLIST_DESTROY_EX(&flistp,NULL);
         if(r_flistp)
                 PIN_FLIST_DESTROY_EX(&r_flistp,NULL);

	 if (PIN_ERR_IS_ERR(ebufp)) {
                 PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_exit error", ebufp);
         }
         return;
}

/*******************************************************************
 * Function executed at application exit
 * Called after MTA_EXIT policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_exit(
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_exit application info flist", 
					   app_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_exit error", ebufp);
	}
	return;
}

/*******************************************************************
 * Initialization of worker thread
 * Called prior MTA_WORKER_INIT policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_worker_init(
		pcm_context_t	*ctxp,
		pin_flist_t		*ti_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_init thread info flist", 
					   ti_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_worker_init error", ebufp);
	}
	return;
}

/*******************************************************************
 * Post initialization of worker thread
 * Called after MTA_WORKER_INIT policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_worker_init(
		pcm_context_t	*ctxp,
		pin_flist_t		*ti_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_worker_init thread info flist", 
					   ti_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_worker_init error", ebufp);
	}
	return;
}

/*******************************************************************
 * Function called when new job is avaialble to worker
 * Called prior MTA_WORKER_JOB policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_worker_job(
		pcm_context_t	*ctxp,
		pin_flist_t		*srch_res_flistp,
		pin_flist_t		**op_in_flistpp,
		pin_flist_t		*ti_flistp,
		pin_errbuf_t	*ebufp)
{

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_job search results flist", 
					   srch_res_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_job thread info flist", 
					   ti_flistp);


	*op_in_flistpp = PIN_FLIST_COPY (srch_res_flistp, ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_job prepared flist for main opcode", 
					   *op_in_flistpp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_worker_job error", ebufp);
	}
	return;
}


/*******************************************************************
 * Function called when new job is avaialble to worker
 * Called after MTA_WORKER_JOB policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_worker_job(
		pcm_context_t	*ctxp,
		pin_flist_t		*srch_res_flistp,
		pin_flist_t		*op_in_flistp,
		pin_flist_t		*ti_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_worker_job search results flist", 
					   srch_res_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_worker_job thread info flist", 
					   ti_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_worker_job prepared flist for main opcode", 
					   op_in_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_worker_job error", ebufp);
	}
	return;
}

/*******************************************************************
 * Main application opcode is called here
 *******************************************************************/
PIN_EXPORT void 
pin_mta_worker_opcode(
		pcm_context_t	*ctxp,
		pin_flist_t		*srch_res_flistp,
		pin_flist_t		*op_in_flistp,
		pin_flist_t		**op_out_flistpp,
		pin_flist_t		*ti_flistp,
		pin_errbuf_t	*ebufp)
{
         pin_flist_t     *iflistp = NULL;
	 pin_flist_t	 *oflistp = NULL;
//	 pin_flist_t     *tmp_flistp = NULL;
         pin_flist_t     *res_flistp = NULL;
	 pin_flist_t	 *payinfo_flistp = NULL;
         pin_flist_t     *inv_dd_info_flistp = NULL;
	 pin_flist_t	*sub_flistp = NULL;

	 u_int		 *pay_type = NULL;
	 poid_t          *s_pdp = NULL;
         char		 *poid_type = NULL;
	 char            *template = NULL;
         char            *first_name = NULL;
         char            *last_name = NULL;
	 int32           s_flags = 256;
 

	 poid_t          *poidp = NULL;
         int             *status = (int*)1;
	 int		 *flags = (int*)1;


	 void            *account_obj = NULL;
	 pin_flist_t     *i_flistp_acc = NULL;
	 pin_flist_t     *r_flistp_acc = NULL;
	 pin_flist_t     *o_flistp = NULL;
	 char		*account_no = NULL;
	 char		*bill_no =NULL; 
	 void		*amount = NULL;
	 void           *billinfo_obj = NULL;
	 int64           db = 1;
	
	 char	buf[200];
	 
	 if (PIN_ERR_IS_ERR(ebufp)) {
			return;
	 }
	 PIN_ERRBUF_CLEAR (ebufp);

		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_opcode prepared flist for main opcode", 
						   op_in_flistp);


		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "op_in_flistp", op_in_flistp);
			
		sprintf(buf, "profile_id-----> %s", profile_id);
		PIN_ERR_LOG_MSG (PIN_ERR_LEVEL_DEBUG, buf);
		/*Invoke td_get_inv_dd_info function */	
		res_flistp = td_get_inv_dd_info(ctxp,op_in_flistp,srch_res_flistp,ebufp);
        
	        PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "payinfo_read_flistp", res_flistp);
                
		if(PIN_ERR_IS_ERR(ebufp)){
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,"Error in td_get_inv_dd_info",ebufp);
			return;
		}

		if((res_flistp == NULL)
			||((PIN_FLIST_ELEM_COUNT(res_flistp,PIN_FLD_RESULTS,ebufp)==0)))	
		{
                      PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "No INV or DD info avialable..");
                      goto cleanup;
                }

		//if((PIN_FLIST_ELEM_COUNT(res_flistp,PIN_FLD_INV_INFO,ebufp)==0) && (PIN_FLIST_ELEM_COUNT(res_flistp,PIN_FLD_DD_INFO,ebufp)==0))
		payinfo_flistp = PIN_FLIST_ELEM_GET(res_flistp, PIN_FLD_RESULTS, 0, 0, ebufp);
		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "INV or DD INFO details for the account is...",payinfo_flistp);

                /*Get /payinfo/dd or /payinfo/invoice preferred contact number*/
		if(!strcmp(PIN_POID_GET_TYPE(PIN_FLIST_FLD_GET(payinfo_flistp,PIN_FLD_POID,0,ebufp)),"/payinfo/dd"))
		{	
		/*Get /payinfo/dd preferred contact number*/
			inv_dd_info_flistp = PIN_FLIST_ELEM_GET(payinfo_flistp, PIN_FLD_DD_INFO, 0, 0, ebufp);
		}
		else{
		/*Get /payinfo/invoice preferred contact number*/
			inv_dd_info_flistp = PIN_FLIST_ELEM_GET(payinfo_flistp, PIN_FLD_INV_INFO, 0, 0, ebufp);
		}
		/*Get amount and billinfo obj*/
                amount = PIN_FLIST_FLD_GET(op_in_flistp,PIN_FLD_DUE,0,ebufp);
		billinfo_obj = PIN_FLIST_FLD_GET(op_in_flistp,PIN_FLD_AR_BILLINFO_OBJ,0,ebufp);
		bill_no	= PIN_FLIST_FLD_GET(op_in_flistp,PIN_FLD_BILL_NO,0,ebufp);	

                /***********************************************************
                Allocate the flist for creating object.
                ***********************************************************/
		//Find Account_no
		account_obj = PIN_FLIST_FLD_GET(op_in_flistp, PIN_FLD_ACCOUNT_OBJ, 0, ebufp);
		

		if (account_obj != NULL) {
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "Get Account Number for account POID");
	

				i_flistp_acc = PIN_FLIST_CREATE(ebufp);
				PIN_FLIST_FLD_SET(i_flistp_acc, PIN_FLD_POID, account_obj, ebufp);
				PIN_FLIST_FLD_SET(i_flistp_acc, PIN_FLD_ACCOUNT_NO, NULL, ebufp);

				PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,"Read Flds input flist for Account_No", i_flistp_acc);
				
				PCM_OP(ctxp, PCM_OP_READ_FLDS, 0, i_flistp_acc, &r_flistp_acc, ebufp);

				if (PIN_ERR_IS_ERR(ebufp)) {
		                        PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,"Error in PCM_OP_READ_FLDS",ebufp);
                		        /*Release memory*/
                        		PIN_FLIST_DESTROY_EX(&i_flistp_acc, ebufp);
                		}

				PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,"Read Flds Output flist for  Account_No", r_flistp_acc);

				account_no = PIN_FLIST_FLD_GET(r_flistp_acc, PIN_FLD_ACCOUNT_NO, 0, ebufp);
		
				/*Release Memory*/
				PIN_FLIST_DESTROY_EX(&i_flistp_acc, ebufp);
			}


		/***********************************************************
		 * Create input Object for payment notification
		 ***********************************************************/
		iflistp = PIN_FLIST_CREATE(ebufp);
        	poidp = PIN_POID_CREATE(db,"/event/notification/inv_pymt_reminder",-1,ebufp);
		PIN_FLIST_FLD_PUT(iflistp,PIN_FLD_POID,poidp,ebufp);

		PIN_FLIST_FLD_SET(iflistp,PIN_FLD_ACCOUNT_OBJ,account_obj,ebufp);
		PIN_FLIST_FLD_SET(iflistp,PIN_FLD_BILLINFO_OBJ, billinfo_obj, ebufp);
                //PIN_FLIST_FLD_SET(iflistp,PIN_FLD_PROFILE_ID, profile_id, ebufp);

		sub_flistp = PIN_FLIST_ELEM_ADD (iflistp, PIN_FLD_INV_INFO,0, ebufp);	
		PIN_FLIST_FLD_COPY(op_in_flistp,PIN_FLD_DUE_T,sub_flistp,PIN_FLD_DUE_T,ebufp);
		PIN_FLIST_FLD_COPY(op_in_flistp,PIN_FLD_BILL_NO,sub_flistp,PIN_FLD_BILL_NO,ebufp);
                PIN_FLIST_FLD_SET(sub_flistp,PIN_FLD_ACCOUNT_NO, account_no, ebufp);
		PIN_FLIST_FLD_COPY(inv_dd_info_flistp,PIN_FLD_FIRST_NAME,sub_flistp,PIN_FLD_FIRST_NAME,ebufp);
                PIN_FLIST_FLD_COPY(inv_dd_info_flistp,PIN_FLD_LAST_NAME,sub_flistp,PIN_FLD_LAST_NAME,ebufp);
		PIN_FLIST_FLD_SET(sub_flistp,PIN_FLD_AMOUNT, amount, ebufp);
		PIN_FLIST_FLD_SET(sub_flistp,PIN_FLD_PROFILE_ID, profile_id, ebufp);
		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Notification inflist", iflistp);

            	PCM_OP(ctxp,PCM_OP_PUBLISH_GEN_PAYLOAD,0,iflistp, &oflistp,ebufp);

               	if (PIN_ERR_IS_ERR(ebufp)) {
                       	PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,"Error in PCM_OP_PUBLISH_GEN_PAYLOAD",ebufp);
               		/*Release memory*/
			PIN_POID_DESTROY(poidp, NULL);
			PIN_FLIST_DESTROY_EX(&iflistp, ebufp);
		}


		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Worker opcode Create Object out flist", oflistp);
	
		/*Changes for SMS notification audit. 07-Nov-2014 -Dev Sharma*/
                /*Start*/
                o_flistp = NULL;
                td_generate_notification_event(ctxp,account_obj,bill_no,"Pymt Reminder",iflistp,&o_flistp, ebufp);
                
		if (PIN_ERR_IS_ERR(ebufp)) {
                         PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,"td_generate_notification_event Error",ebufp);
                         PIN_FLIST_DESTROY_EX(&iflistp,ebufp);
                         
		return;
                }
                PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,"td_generate_notification_event: Audit event",o_flistp);
               /*End*/
	
		*op_out_flistpp = o_flistp;

		if (PIN_ERR_IS_ERR(ebufp)) {
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_worker_opcode error", ebufp);
		}
		else{
			PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_opcode output flist from main opcode", *op_out_flistpp);
		}
		
		cleanup:
		
		/*Release memory*/
                //PIN_POID_DESTROY(poidp, NULL);
                PIN_FLIST_DESTROY_EX(&iflistp, NULL);
		PIN_FLIST_DESTROY_EX(&r_flistp_acc, NULL);
		PIN_FLIST_DESTROY_EX(&res_flistp, NULL);
		return;
}

/*******************************************************************
 * Function called when worker completed assigned job
 * Called prior MTA_WORKER_JOB_DONE policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_worker_job_done(
		pcm_context_t	*ctxp,
		pin_flist_t		*srch_res_flistp,
		pin_flist_t		*op_in_flistp,
		pin_flist_t		*op_out_flistp,
		pin_flist_t		*ti_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_job_done search results flist", 
					   srch_res_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_job_done prepared flist for main opcode", 
					   op_in_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_job_done output flist from main opcode", 
					   op_out_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_job_done thread info flist", 
					   ti_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_worker_job_done error", ebufp);
	}
	return;
}

/*******************************************************************
 * Function called when worker completed assigned job
 * Called after MTA_WORKER_JOB_DONE policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_worker_job_done(
		pcm_context_t	*ctxp,
		pin_flist_t		*srch_res_flistp,
		pin_flist_t		*op_in_flistp,
		pin_flist_t		*op_out_flistp,
		pin_flist_t		*ti_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_worker_job_done search results flist", 
					   srch_res_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_worker_job_done prepared flist for main opcode", 
					   op_in_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_worker_job_done output flist from main opcode", 
					   op_out_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_worker_job_done thread info flist", 
					   ti_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_worker_job_done error", ebufp);
	}
	return;
}

/*******************************************************************
 * Worker thread exit function
 * Called prior MTA_WORKER_EXIT policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_worker_exit(
		pcm_context_t	*ctxp,
		pin_flist_t		*ti_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_exit thread info flist", 
					   ti_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_worker_exit error", ebufp);
	}
	return;
}

/*******************************************************************
 * Worker thread exit function
 * Called after MTA_WORKER_EXIT policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_post_worker_exit (
		pcm_context_t	*ctxp,
		pin_flist_t		*ti_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_worker_exit thread info flist", 
					   ti_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_post_worker_exit error", ebufp);
	}
	return;
}


/*******************************************************************
 * Obsolete callback API , supported for backward compatibility
 * There are several drawbacks in keeping using obsolete function,
 * one of them obsolete functions do not match MTA policy opcodes ...
 *******************************************************************/
/*******************************************************************
 * User-defined initialization.
 * Add user specified arguments or parameters to arg_flistp.
 * Should not be used , since there is better approach with pin_mta_config
 * and pin_mta_post_config, pin_mta_init_app and pin_mta_post_init_app.
 *******************************************************************/
PIN_EXPORT void
pin_mta_init_job(
		int				argc,
		char			*argv[],
		int				*work_modep,
		pin_flist_t		**arg_flistpp,
		pin_errbuf_t	*ebufp)
{
	pin_flist_t	*arg_flistp = NULL;
	int32 i = argc;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	*arg_flistpp = 0;

	*work_modep = MTA_WORKMODE_SINGLE;

	arg_flistp = PIN_FLIST_CREATE(ebufp);

	PIN_FLIST_FLD_SET (arg_flistp, PIN_FLD_ATTRIBUTE, &i , ebufp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_init_job error", ebufp);

		PIN_FLIST_DESTROY_EX (&arg_flistp,0);
	}else {
		*arg_flistpp = arg_flistp;

		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_job arguments flist", 
						   arg_flistp);
	}

	return;
}

/*******************************************************************
 * User-defined hotlist initialization.
 * Should not be used , since there is better approach with search flist
 * option reading from a file.
 *******************************************************************/
PIN_EXPORT void
pin_mta_init_hotlist(
		pin_flist_t		*app_flistp,
		pin_flist_t		**hot_flistpp,
		pin_errbuf_t	*ebufp )
{

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_hotlist application info flist", 
					   app_flistp);

	*hot_flistpp = 0;

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_init_hotlist error", ebufp);
	}
	return;
}

/*******************************************************************
 * Do the real job for each work unit.
 * Should not be used, better approach pin_mta_worker_opcode 
 * and rest of pin_mta_worker_* functions
 *******************************************************************/	
PIN_EXPORT void
pin_mta_exec_work_unit(
		pcm_context_t	*ctxp,
		pin_flist_t		*app_flistp,
		pin_flist_t		*i_flistp,
		pin_errbuf_t	*ebufp)
{
	pin_flist_t	*tmp_flistp = NULL;
	pin_flist_t	*r_flistp = NULL;
	int32		i = 1;
	int32		mta_flags = 0;
	void		*vp = 0;
	pin_cookie_t	cookie = 0;
	int32		rec_id = 0;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_exec_work_unit application info flist", 
					   app_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_exec_work_unit input flist", 
					   i_flistp);

	vp = PIN_FLIST_FLD_GET (app_flistp, PIN_FLD_FLAGS, 0,ebufp);
	if(vp)
		mta_flags = *((int32*)vp);

	vp = PIN_FLIST_FLD_GET (app_flistp, PIN_FLD_INCR_AMOUNT, 1,ebufp);
	if(vp)
		i = *((int32*)vp);


	if(mta_flags & MTA_FLAG_BATCH_MODE) {

		while((tmp_flistp = 
			   PIN_FLIST_ELEM_GET_NEXT(i_flistp, PIN_FLD_RESULTS,
									   &rec_id, 1, &cookie, ebufp)) != NULL) {

			PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_HEADER_NUM, &i, ebufp);
			PCM_OP (ctxp, PCM_OP_INC_FLDS, 0, tmp_flistp, &r_flistp, ebufp);


			PIN_FLIST_DESTROY_EX (&r_flistp, ebufp);
		}


	} else {
		tmp_flistp = PIN_FLIST_COPY(i_flistp, ebufp);

		PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_HEADER_NUM, &i, ebufp);

		PCM_OP (ctxp, PCM_OP_INC_FLDS, 0, tmp_flistp, &r_flistp, ebufp);

		PIN_FLIST_DESTROY_EX (&tmp_flistp, 0);
		PIN_FLIST_DESTROY_EX (&r_flistp, ebufp);
	}

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_exec_work_unit error", ebufp);
	}
	return;
}

/*******************************************************************
 * Cleanup. 
 * Should not be used, better approach is to use pin_mta_exit and 
 * pin_mta_post_exit; in such cases, no need to destroy app_flist :-)
 * doing this to test backward compatibility, just in case ...
 * and destroying passed copy of app_flistp ...
 *******************************************************************/
PIN_EXPORT void
pin_mta_cleanup_job(
		pin_flist_t		*app_flistp,
		pin_errbuf_t	*ebufp)
{

	pin_flist_t	*app_flistp_x = app_flistp;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_clean_up application info flist", 
					   app_flistp);

	PIN_FLIST_DESTROY_EX (&app_flistp_x, ebufp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
						 "pin_mta_cleanup_job error", ebufp);
	}
	return;
}

/***********************************************************
 * td_get_inv_dd_info new function written for getting the 
 * customer INV informatiom.
 ***********************************************************/
pin_flist_t*  
td_get_inv_dd_info(
	pcm_context_t   *ctxp,
        pin_flist_t     *op_in_flistp,
        pin_flist_t     *srch_res_flistp,
	pin_errbuf_t    *ebufp)
 {
	pin_flist_t     *i_flistp = NULL;
	pin_flist_t   	*tmp_flistp = NULL;
        pin_flist_t   	*o_flistp = NULL;

	poid_t          *account_pdp = NULL;
        poid_t         	*billinfo_pdp = NULL;
	poid_t         	*payinfo_pdp = NULL;

	char            template[100]={"select X from /payinfo 1, /billinfo 2 where 2.F1 = V1 and 2.F2 = 1.F3 and 1.F4 = V4 "};
        int32           s_flags = 256;
	poid_t          *s_pdp = NULL;
	void		*vp = NULL;
	int32		db;


	/***********************************************************
	 * Check the error buffer.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "In the function td_get_inv_dd_info", op_in_flistp);
        billinfo_pdp = (poid_t *)PIN_FLIST_FLD_GET (op_in_flistp, PIN_FLD_AR_BILLINFO_OBJ, 0, ebufp);
        account_pdp = (poid_t *)PIN_FLIST_FLD_GET (op_in_flistp, PIN_FLD_ACCOUNT_OBJ, 0, ebufp);
        
        i_flistp = PIN_FLIST_CREATE(ebufp);

        vp = PIN_FLIST_FLD_GET (op_in_flistp, PIN_FLD_POID, 0, ebufp);
        if(vp)
                db = PIN_POID_GET_DB ((poid_t*)vp);

        s_pdp = PIN_POID_CREATE(db, "/search", -1, ebufp);
        PIN_FLIST_FLD_PUT(i_flistp, PIN_FLD_POID, (void *)s_pdp, ebufp);
        PIN_FLIST_FLD_SET (i_flistp, PIN_FLD_FLAGS, &s_flags, ebufp);
        PIN_FLIST_FLD_SET (i_flistp, PIN_FLD_TEMPLATE, template, ebufp);
	
        tmp_flistp = PIN_FLIST_ELEM_ADD(i_flistp, PIN_FLD_ARGS,1, ebufp);
        PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_POID, billinfo_pdp ,ebufp);

	tmp_flistp = PIN_FLIST_ELEM_ADD(i_flistp, PIN_FLD_ARGS,2, ebufp);
        s_pdp = PIN_POID_CREATE(db, "/payinfo", -1, ebufp);
	PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_PAYINFO_OBJ, s_pdp ,ebufp);

	tmp_flistp = PIN_FLIST_ELEM_ADD(i_flistp, PIN_FLD_ARGS, 3, ebufp);
        PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_POID, s_pdp ,ebufp);

	tmp_flistp = PIN_FLIST_ELEM_ADD(i_flistp, PIN_FLD_ARGS, 4, ebufp);
        PIN_FLIST_FLD_SET(tmp_flistp,PIN_FLD_ACCOUNT_OBJ, account_pdp ,ebufp);

	/*Result flist*/
	tmp_flistp = PIN_FLIST_ELEM_ADD(i_flistp, PIN_FLD_RESULTS, 0, ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Payinfo Search input", i_flistp);
        /***********************************************************
         * Call the DM to do the search.
        ***********************************************************/
        PCM_OP (ctxp, PCM_OP_SEARCH, 0, i_flistp, &o_flistp, ebufp);
	

		/* Error? */
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "td_get_inv_dd_info error", ebufp);
		PIN_FLIST_DESTROY_EX(&i_flistp, NULL);
		if(o_flistp)
			PIN_FLIST_DESTROY_EX(&o_flistp, NULL);
        }

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Payinfo Search output", o_flistp);
        /* Free local memory */
        if(i_flistp)
		PIN_FLIST_DESTROY_EX(&i_flistp, NULL);
	PIN_POID_DESTROY(s_pdp, NULL);
	
return o_flistp;
}


/*Function to generate notification event. 07-Nov-2014 -Dev Sharma*/
void
td_generate_notification_event(
        pcm_context_t           *ctxp,
        poid_t                  *acct_pdp,
	char			*bill_no,
        char                    *action_strp,
        pin_flist_t             *i_flistp,
        pin_flist_t             **r_flistp,
        pin_errbuf_t            *ebufp)
{
        pin_flist_t      *event_flistp = NULL;
        pin_flist_t      *er_flistp = NULL;
        pin_flist_t      *event_sub = NULL;
        pin_flist_t      *dunning_info = NULL;
        poid_t           *event_poid = NULL;
        int              db = 1;
        int              str_len = 0;
	time_t           current_time = pin_virtual_time((time_t*)NULL);
        char             *programName = "publish_event_notification";
        char             *name = "publish_event_notification";
	char 		 *str_buf = NULL;
	int 		  size = 4000;
	

	if (PIN_ERR_IS_ERR(ebufp))
                return;
        PIN_ERR_CLEAR_ERR(ebufp);
      
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "td_generate_notification_event: input flist", i_flistp);
     

	/******************************
	 * Convert input flist into XML
	 *****************************/
	//PIN_FLIST_TO_STR(i_flistp, &flist_strp, &str_len, ebufp);
        //PIN_FLIST_TO_XML( i_flistp, PIN_XML_BY_SHORT_NAME, 0,&dbuf.strp, &dbuf.strsize, "pymt_reminder", ebufp );
	PIN_FLIST_TO_XML( i_flistp, PIN_XML_BY_SHORT_NAME, 0, &str_buf, &size, "pymt_reminder", ebufp ); 
	/***********************************************************
         * Call the PCM_OP_CREATE_OBJ to create event
         ***********************************************************/
      event_flistp = PIN_FLIST_CREATE(ebufp);
      event_poid = PIN_POID_CREATE(db, "/td_notification", (int64)-1, ebufp);
      PIN_FLIST_FLD_PUT(event_flistp,PIN_FLD_POID, (void *)event_poid, ebufp);
      PIN_FLIST_FLD_SET(event_flistp, PIN_FLD_ACCOUNT_OBJ, (void *)acct_pdp,ebufp);
      PIN_FLIST_FLD_SET(event_flistp, PIN_FLD_BILL_NO, (void *)bill_no, ebufp);
      PIN_FLIST_FLD_SET(event_flistp, PIN_FLD_DESCR, str_buf, ebufp);
      PIN_FLIST_FLD_SET(event_flistp, PIN_FLD_ACTION_STR, action_strp, ebufp); 

      PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "Record event input", event_flistp);
      
      PCM_OP(ctxp, PCM_OP_CREATE_OBJ, 0, event_flistp, r_flistp, ebufp);

      if (PIN_ERR_IS_ERR(ebufp)){
            PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "td_generate_notification_event:"
                                    "error before creating the event", ebufp);
            PIN_FLIST_DESTROY_EX(&event_flistp, NULL);
	    if(str_buf != NULL)
        	pin_free(str_buf);
	return;
      }

      PIN_FLIST_DESTROY_EX(&event_flistp, NULL);
      if(str_buf != NULL)
	pin_free(str_buf);
 
      PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG, "PCM_OP_CREATE_OBJ output",*r_flistp);
      return;

}


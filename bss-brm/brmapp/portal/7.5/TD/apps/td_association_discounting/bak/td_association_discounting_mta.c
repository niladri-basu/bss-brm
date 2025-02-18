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

pin_flist_t*  td_get_active_owner(
                 pcm_context_t   *ctxp,
                 pin_flist_t     *op_in_flistp,
                 pin_flist_t     *srch_res_flistp,
		 pin_errbuf_t    *ebufp);

/*Global variable */
int create_count;

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
		} else {
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

	 char            template[400] = {"select X from /profile/offer_details where F1 = V1 and F2 = V2 and F3 = V3 "};

         int32           s_flags = 256;
         poid_t          *s_pdp = NULL;
         int64           id = -1;
         int64           db = 0;
         void            *vp = NULL;
         pin_flist_t     *arg_flistp = NULL;
	 pin_flist_t     *data_flistp = NULL;


	 char		*ass_owner = "ASSOCIATION_OWNER";
	 char		*dom = "DOM";
	 char           *dom_val = "15";

         if (PIN_ERR_IS_ERR(ebufp)) {
                 return;
         }
         PIN_ERRBUF_CLEAR (ebufp);


         PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_search application info flist", app_flistp);
		
	  /***********************************************************
          * Allocate the flist for searching.
          ***********************************************************/
          s_flistp = PIN_FLIST_CREATE(ebufp);

         /**********************************************************
          * Search flist for OBRM Initiated Payment
          ***********************************************************
		0 PIN_FLD_POID           POID [0] 0.0.0.1 /search/pin -1 0
		0 PIN_FLD_FLAGS           INT [0] 256
		0 PIN_FLD_TEMPLATE        STR [0] "select X from /profile/offer_details where F1 = V1 and F2 = V2 and F3 = V3 "
		0 PIN_FLD_ARGS          ARRAY [1] allocated 20, used 1
		1        PIN_FLD_EXTRATING    SUBSTRUCT [0] allocated 20, used 1
		2            PIN_FLD_LABEL           STR [0] "ASSOCIATION_OWNER"
		0 PIN_FLD_ARGS          ARRAY [2] allocated 20, used 1
		1        PIN_FLD_DATA_ARRAY    ARRAY [5] allocated 20, used 4
		2            PIN_FLD_NAME            STR [0] "DOM"
		0 PIN_FLD_ARGS          ARRAY [3] allocated 20, used 1
		1        PIN_FLD_DATA_ARRAY    ARRAY [5] allocated 20, used 4
		2            PIN_FLD_VALUE            STR [0] "15"
	  	0 PIN_FLD_RESULTS       ARRAY [0]  allocated 20, used 2
	  	1        PIN_FLD_DATA_ARRAY    ARRAY [*]  allocated 20, used 4


	  ***********************************************************
          * Allocate the search poid and give it to the flist.
          ***********************************************************/

	 PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "I am here1");

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
         arg_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 1, ebufp);
         data_flistp = PIN_FLIST_SUBSTR_ADD(arg_flistp, PIN_FLD_EXTRATING, ebufp);
	 PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_LABEL, ass_owner, ebufp);

	 arg_flistp = PIN_FLIST_ELEM_ADD (s_flistp,PIN_FLD_ARGS, 2, ebufp);
         data_flistp = PIN_FLIST_ELEM_ADD(arg_flistp, PIN_FLD_DATA_ARRAY, 6, ebufp);
	 PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_NAME, dom, ebufp);

         arg_flistp = PIN_FLIST_ELEM_ADD(s_flistp, PIN_FLD_ARGS,3, ebufp);
         data_flistp = PIN_FLIST_ELEM_ADD(arg_flistp, PIN_FLD_DATA_ARRAY, 6, ebufp);
	 PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_VALUE, dom_val, ebufp);

	
         /***********************************************************
          * Search results
          ***********************************************************/
         arg_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_RESULTS, 0, ebufp);
         vp = 0;
         //PIN_FLIST_FLD_SET (arg_flistp, PIN_FLD_POID, NULL, ebufp);
         PIN_FLIST_ELEM_ADD (arg_flistp, PIN_FLD_DATA_ARRAY, PIN_ELEMID_ANY, ebufp);


         if (PIN_ERR_IS_ERR(ebufp)) {
                 PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_init_search error", ebufp);

                 PIN_FLIST_DESTROY_EX (&s_flistp,0);
         }else{
                 *s_flistpp = s_flistp;

                 PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_search Payment info Search flist", s_flistp);
                 PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "search flist", s_flistp);
         }


	//switch (err) {
        //case PIN_ERR_NONE:
	//	free(locale);
	//}
	//if(due != (pin_decimal_t *) NULL)
          //       pbo_decimal_destroy(&due);
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
	 pin_flist_t     *tmp_flistp = NULL;
         pin_flist_t     *res_flistp = NULL;
         pin_flist_t     *inv_info_flistp = NULL;
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

	 int		*active_member_count = NULL;	

	 if (PIN_ERR_IS_ERR(ebufp)) {
			return;
		}
	 PIN_ERRBUF_CLEAR (ebufp);

		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_opcode prepared flist for main opcode", 
						   op_in_flistp);


		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "op_in_flistp", op_in_flistp);
			

		tmp_flistp = td_get_active_owner(ctxp, op_in_flistp, srch_res_flistp, ebufp);
        

                
		if ((PIN_ERR_IS_ERR(ebufp))||(PIN_FLIST_ELEM_COUNT(tmp_flistp,PIN_FLD_RESULTS,ebufp)==0)){
                       PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, "No INV info avialable..");
                      goto cleanup;
                 }


		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "INV INFO details for the account is...",tmp_flistp);

		res_flistp = PIN_FLIST_ELEM_GET(tmp_flistp,PIN_FLD_RESULTS,0,0,ebufp);

		/*Get preferred contact number*/
		
		inv_info_flistp = PIN_FLIST_ELEM_GET(res_flistp,PIN_FLD_INV_INFO,0,0,ebufp);

		/*Get amount and billinfo obj*/
                amount = PIN_FLIST_FLD_GET(op_in_flistp,PIN_FLD_TOTAL_DUE,0,ebufp);
		billinfo_obj = PIN_FLIST_FLD_GET(op_in_flistp,PIN_FLD_AR_BILLINFO_OBJ,0,ebufp);
		bill_no	= PIN_FLIST_FLD_GET(op_in_flistp,PIN_FLD_BILL_NO,0,ebufp);	

                /***********************************************************
                Allocate the flist for creating object.
                ***********************************************************/
		// Find Account_no
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
                //PIN_FLIST_FLD_SET(iflistp,PIN_FLD_ACCOUNT_NO, account_no, ebufp);
		sub_flistp = PIN_FLIST_ELEM_ADD (iflistp, PIN_FLD_INV_INFO,0, ebufp);	
		PIN_FLIST_FLD_COPY(op_in_flistp,PIN_FLD_DUE_T,sub_flistp,PIN_FLD_DUE_T,ebufp);
		PIN_FLIST_FLD_COPY(op_in_flistp,PIN_FLD_BILL_NO,sub_flistp,PIN_FLD_BILL_NO,ebufp);
                PIN_FLIST_FLD_SET(sub_flistp,PIN_FLD_ACCOUNT_NO, account_no, ebufp);
		PIN_FLIST_FLD_COPY(inv_info_flistp,PIN_FLD_FIRST_NAME,sub_flistp,PIN_FLD_FIRST_NAME,ebufp);
                PIN_FLIST_FLD_COPY(inv_info_flistp,PIN_FLD_LAST_NAME,sub_flistp,PIN_FLD_LAST_NAME,ebufp);
		PIN_FLIST_FLD_SET(sub_flistp,PIN_FLD_AMOUNT, amount, ebufp);
		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Notification inflist", iflistp);

            	PCM_OP(ctxp,PCM_OP_PUBLISH_GEN_PAYLOAD,0,iflistp,&oflistp,ebufp);

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
                //td_generate_notification_event(ctxp,account_obj,bill_no,"Pymt Reminder",iflistp,&o_flistp, ebufp);
                
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
                //PIN_POID_DESTROY(&poidp, NULL);
                PIN_FLIST_DESTROY_EX(&iflistp, NULL);

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
 * td_get_active_owner new function written for getting the 
 * active owner informatiom.
 ***********************************************************/
pin_flist_t*  
td_get_active_owner(
	pcm_context_t   *ctxp,
        pin_flist_t     *op_in_flistp,
        pin_flist_t     *srch_res_flistp,
	pin_errbuf_t    *ebufp)
 {
	pin_flist_t   *sv_flistp = NULL;
        pin_flist_t   *argv_flistp = NULL;
        pin_flist_t   *data_flistp = NULL;
	pin_flist_t   *resv_flistp = NULL;
	pin_flist_t   *flistp = NULL;
        poid_t        *s_pdp = NULL;
        int32         s_flags = 256;
       
        int32           rec_id = 0;
        pin_cookie_t    cookie = 0; 
	char	      *ass_member = "ASSOCIATION_MEMBER";
	char	      *ass_owner_id = "OWNER_ID";
	char	      *ass_owner = NULL;
	int32	      *count = NULL;
	char            template[256] = {"select count(1) from /profile/offer_details 1, /purchased_discount 2 where 1.F1=2.F2 and 1.F3=V3 and 1.F4=V4 and 1.F5=V5 "};

	/***********************************************************                                  
	0 PIN_FLD_POID           POID [0] 0.0.0.1 /search/pin -1 0
	0 PIN_FLD_FLAGS           INT [0] 1
	0 PIN_FLD_TEMPLATE        STR [0] "select count(1) from /profile/offer_details 1, /purchased_discount 2 where 1.F1=2.F2 and 1.F3=V3 and 1.F4=V4 and 1.F5=V5 "
	0 PIN_FLD_ARGS          ARRAY [1] allocated 20, used 1
	1        PIN_FLD_EXTRATING    SUBSTRUCT [0] allocated 20, used 1
	2            PIN_FLD_OFFERING_OBJ   POID [0] NULL
	0 PIN_FLD_ARGS          ARRAY [2] allocated 20, used 1
	1              PIN_FLD_POID           POID [0] NULL
	0 PIN_FLD_ARGS          ARRAY [3] allocated 20, used 1
	1        PIN_FLD_EXTRATING    SUBSTRUCT [0] allocated 20, used 1
	2            PIN_FLD_LABEL           STR [0] "ASSOCIATION_MEMBER"
	0 PIN_FLD_ARGS          ARRAY [4] allocated 20, used 1
	1        PIN_FLD_DATA_ARRAY    ARRAY [1] allocated 20, used 4
	2            PIN_FLD_NAME            STR [0] "OWNER_ID"
	0 PIN_FLD_ARGS          ARRAY [5] allocated 20, used 1
	1        PIN_FLD_DATA_ARRAY    ARRAY [1] allocated 20, used 4
	2            PIN_FLD_VALUE            STR [0] "ORACLE"
	0 PIN_FLD_RESULTS       ARRAY [0]  allocated 20, used 2
	1   PIN_FLD_AMOUNT DECIMAL [0] NULL

	*/
        /***********************************************************
	 * Check the error buffer.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);


	while((flistp = /*!=NULL*/
                   PIN_FLIST_ELEM_GET_NEXT(op_in_flistp, PIN_FLD_DATA_ARRAY, &rec_id,
                                                                   1, &cookie, ebufp))!= NULL){

	ass_owner_id = PIN_FLIST_FLD_GET (flistp, PIN_FLD_NAME, 1, ebufp);
               
	if(!strcmp(ass_owner_id,"OWNER_ID")){ 
       	ass_owner = PIN_FLIST_FLD_GET (flistp, PIN_FLD_VALUE, 1, ebufp);

	/***********************************************************
 	* Allocate the flist for searching.
	 ***********************************************************/
        sv_flistp = PIN_FLIST_CREATE(ebufp);
        s_pdp = PIN_POID_CREATE(1, "/search/pin", (int64)-1, ebufp);
        PIN_FLIST_FLD_PUT(sv_flistp, PIN_FLD_POID, (void *)s_pdp, ebufp);
	PIN_FLIST_FLD_SET (sv_flistp, PIN_FLD_FLAGS, &s_flags, ebufp);
	PIN_FLIST_FLD_SET (sv_flistp, PIN_FLD_TEMPLATE, template, ebufp);
                
       	/***********************************************************
         * Search arguments
      	 ***********************************************************/
 	argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,1, ebufp);
        data_flistp = PIN_FLIST_SUBSTR_ADD(argv_flistp, PIN_FLD_EXTRATING, ebufp);
        PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_OFFERING_OBJ, NULL, ebufp); 

	argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,2, ebufp);
	PIN_FLIST_FLD_PUT(argv_flistp, PIN_FLD_POID, NULL,  ebufp);

        argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,3, ebufp);
        data_flistp = PIN_FLIST_SUBSTR_ADD(argv_flistp, PIN_FLD_EXTRATING, ebufp);
        PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_LABEL, ass_member, ebufp);

        argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,4, ebufp);
        data_flistp = PIN_FLIST_ELEM_ADD(argv_flistp, PIN_FLD_DATA_ARRAY,1, ebufp);
        PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_NAME, ass_owner_id, ebufp);

        argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_ARGS,5, ebufp);
        data_flistp = PIN_FLIST_ELEM_ADD(argv_flistp, PIN_FLD_DATA_ARRAY,1, ebufp);
        PIN_FLIST_FLD_PUT(data_flistp, PIN_FLD_VALUE, ass_owner, ebufp);
		
       	/***********************************************************
       	* Search results
        ***********************************************************/
	argv_flistp = PIN_FLIST_ELEM_ADD (sv_flistp, PIN_FLD_RESULTS, 0, ebufp);
	PIN_FLIST_FLD_PUT(argv_flistp, PIN_FLD_AMOUNT, NULL, ebufp);

        PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Active owner Search Input Flist:td_get_active_owner ",
                                           sv_flistp);
        /***********************************************************
	 * Call the DM to do the search.
 	***********************************************************/
       	PCM_OP (ctxp, PCM_OP_SEARCH, 0, sv_flistp, &resv_flistp, ebufp);

       	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "Active owner Search Output Flist:td_get_active_owner ",
                                           resv_flistp);
        /* Free local memory */
	PIN_FLIST_DESTROY_EX(&sv_flistp, NULL);

		/* Error? */
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "sample_read_obj_search error", ebufp);
        }
	}
	}
return resv_flistp;
}

/*******************************************************************************
 *  td_payment_allocate.c
 *  - This MTA application  is used for payment allocation processing
 *  for 2D 
 *  - This MTA fetches the accounts having unallocated payments and open items then 
 *     calls for allocation
 *  Author:	Dev Sharma		Date:	22-Aug-2015	
 *******************************************************************************/

#ifndef lint
static  char    Sccs_id[] = "@(#)%Portal Version: vfq_payment_allocate.c:CUPmod7.3PatchInt:1:2007-Feb-07 06:51:33 %";
#endif

#include <stdio.h>

#include "pcm.h"
#include "pin_errs.h"
#include "pinlog.h"
#include "pin_pymt.h"
#include "pin_bill.h"
#include "pin_mta.h"
#include "custom_opcodes.h"

/*******************************************************************
 * During real application development, there is no necessity to implement 
 * empty MTA call back functions. Application will recognize implemented
 * functions automatically during run-time.
 *******************************************************************/

/* Defining Global variables  */
time_t	item_start_t = 0;

/* Local function declaration */

time_t truncate_time(time_t date) ;

/*******************************************************************
 * Configuration of application
 * Called prior MTA_CONFIG policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_config(
	pin_flist_t	*param_flistp,
	pin_flist_t	*app_flistp,
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
			"\t\t -increment <number> ; default 1\n"
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

	ext_flistp = pin_mta_global_flist_node_get_no_lock (PIN_FLD_EXTENDED_INFO, &ebuf);

	PIN_FLIST_FLD_SET (ext_flistp, PIN_FLD_DESCR, usage_str, &ebuf)

	if (PIN_ERR_IS_ERR(&ebuf)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_usage error", &ebuf);
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

	ext_flistp = pin_mta_global_flist_node_get_no_lock (PIN_FLD_EXTENDED_INFO, ebufp);

	vp = PIN_FLIST_FLD_GET (ext_flistp, PIN_FLD_DESCR, 1, ebufp);

	if(vp) {
		printf("%s",(char*) vp);
	}

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_post_usage error", ebufp);
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
		
	int32			*pin_value;
	int32			pin_status;
	int32			item_srch_days = 0;
	time_t 			poid_start_t = 0;
	time_t 			now_t = 0;
	time_t			item_min_t = 0;
	char			msg [256];
	
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_app application info flist", app_flistp);
	
	/*
	 *  2D - Read pin.conf to get number of days before we want to search item poids
	 */

	pin_conf("-", "item_srch_days", PIN_FLDT_INT, (caddr_t *)&pin_value, &pin_status);
	switch ( pin_status ){
		case PIN_ERR_NONE:
			item_srch_days = *(int32 *) pin_value;
			sprintf (msg, "item_srch_days = %d", item_srch_days);
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, msg);
			free(pin_value);
			
			/* Get starting item poid and store it in application flist */
			now_t = pin_virtual_time(NULL);
			item_start_t = truncate_time(now_t - (86400 * item_srch_days));			
		 break;
		default:
			pin_set_err(ebufp, PIN_ERRLOC_APP, PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_INVALID_CONF, 0, 0, pin_status);
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"Failed to get 'item_srch_days' configuration value", ebufp);
	}
	  
	  
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_init_app error", ebufp);
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

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_init_app application info flist", app_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_post_init_app error", ebufp);
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

	pin_flist_t		*s_flistp = NULL;
	pin_flist_t		*tmp_flistp = NULL;
	poid_t			*s_pdp = NULL;
	poid_t			*bill_pdp = NULL;
	pin_decimal_t 	*dp = NULL;
	
	int64			id = -1;
	int64			db = 1;
	void			*vp = NULL;
	
	int32			i = 0;
	int32			s_flags = 256;

	int             item_status;
	int				paytype_cc = 10003;
	int				paytype_dd = 10005;
	int				paytype_inv = 10001;
	char			*template = "select /*+ full(billinfo_t) full(item_t) parallel(billinfo_t,2) parallel(item_t,2)*/ X from /billinfo 1, /item 2 where 1.F1 = 2.F2 and 2.F3 = V3 and (2.F4 = V4 or 2.F8 = V8) and 2.F5 = V5 and ( 1.F6 = V6 or 1.F7 = V7 or 1.F9 = V9 ) and 2.F10 < V10 and 2.F11 >=  V11 ";
	
	
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_search application info flist", app_flistp);

	/*
	 *  Search Template: Searches all open payment and adjustment items having due < 0 and linked to postpaid billinfos
	 * 		To limit the search, only item poids generated few days (configurable) before are searched. 
	 *
	 *	0 PIN_FLD_POID           POID [0] 0.0.0.1 /search/pin -1 0
	 *	0 PIN_FLD_FLAGS           INT [0] 256
	 *	0 PIN_FLD_TEMPLATE        STR [0] "select X from /billinfo 1, /item 2 where 1.F1 = 2.F2 and 2.F3 = V3 and (2.F4 = V4 or 2.F8 = V8) and 2.F5 = V5 and ( 1.F6 = V6 or 1.F7 = 	V7 or 1.F9 = V9 ) and 2.F10 < V10 and 2.F11 >=  V11 "
	 *	0 PIN_FLD_ARGS          ARRAY [1] allocated 20, used 1
	 *	1     PIN_FLD_POID           POID [0] NULL poid pointer
	 *	0 PIN_FLD_ARGS          ARRAY [2] allocated 20, used 1
	 *	1     PIN_FLD_AR_BILLINFO_OBJ   POID [0] NULL poid pointer
	 *	0 PIN_FLD_ARGS          ARRAY [3] allocated 20, used 1
	 *	1     PIN_FLD_BILL_OBJ       POID [0] 0.0.0.1 /bill 0 0
	 *	0 PIN_FLD_ARGS          ARRAY [4] allocated 20, used 1
	 *	1     PIN_FLD_POID           POID [0] 0.0.0.1 /item/payment -1 0
	 *	0 PIN_FLD_ARGS          ARRAY [5] allocated 20, used 1
	 *	1     PIN_FLD_STATUS         ENUM [0] 2
	 *	0 PIN_FLD_ARGS          ARRAY [6] allocated 20, used 1
	 *	1     PIN_FLD_PAY_TYPE       ENUM [0] 10003
	 *	0 PIN_FLD_ARGS          ARRAY [7] allocated 20, used 1
	 *	1     PIN_FLD_PAY_TYPE       ENUM [0] 10005
	 *	0 PIN_FLD_ARGS          ARRAY [8] allocated 20, used 1
	 *	1     PIN_FLD_POID           POID [0] 0.0.0.1 /item/adjustment -1 0
	 *	0 PIN_FLD_ARGS          ARRAY [9] allocated 20, used 1
	 *	1     PIN_FLD_PAY_TYPE       ENUM [0] 10001
	 *	0 PIN_FLD_ARGS          ARRAY [10] allocated 20, used 1
	 *	1     PIN_FLD_DUE          DECIMAL [0] 0.000000000000000
	 *	0 PIN_FLD_ARGS          ARRAY [11] allocated 20, used 1
	 *	1     PIN_FLD_CREATED_T    TSTAMP [0] (123456678)
	 *	0 PIN_FLD_RESULTS       ARRAY [0] allocated 20, used 2
	 *	1     PIN_FLD_POID           POID [0] NULL poid pointer
	 *	1     PIN_FLD_ACCOUNT_OBJ    POID [0] NULL poid pointer
     */

	*s_flistpp = 0;
	s_flistp = PIN_FLIST_CREATE(ebufp);

	vp = PIN_FLIST_FLD_GET (app_flistp, PIN_FLD_POID_VAL, 0, ebufp);
	if(vp)
		db = PIN_POID_GET_DB ((poid_t*)vp);
		
	s_pdp = PIN_POID_CREATE(db, "/search/pin", id, ebufp);
	PIN_FLIST_FLD_PUT(s_flistp, PIN_FLD_POID, (void *)s_pdp, ebufp);

	PIN_FLIST_FLD_SET (s_flistp, PIN_FLD_FLAGS, &s_flags, ebufp);
	
	PIN_FLIST_FLD_SET (s_flistp, PIN_FLD_TEMPLATE,(void *)template, ebufp);

	/***********************************************************
	 * Search arguments
	 ***********************************************************/
	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 1, ebufp);
	PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_POID, (void *)NULL, ebufp);
	

	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 2, ebufp);
	PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_AR_BILLINFO_OBJ,(void *)NULL , ebufp);

	bill_pdp = PIN_POID_CREATE(db, "/bill", 0, ebufp);
	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 3, ebufp);
	PIN_FLIST_FLD_PUT (tmp_flistp, PIN_FLD_BILL_OBJ, (void *)bill_pdp, ebufp);

	vp = PIN_POID_CREATE(db, "/item/payment", -1, ebufp);
	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 4, ebufp);
	PIN_FLIST_FLD_PUT (tmp_flistp, PIN_FLD_POID, (void *)vp, ebufp);

	item_status = PIN_ITEM_STATUS_OPEN;
	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 5, ebufp);
	PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_STATUS, &item_status, ebufp);

	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 6, ebufp);
	PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_PAY_TYPE,&paytype_cc , ebufp);

	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 7, ebufp);
	PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_PAY_TYPE, &paytype_dd, ebufp);

	vp = PIN_POID_CREATE(db, "/item/adjustment", -1, ebufp);
	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 8, ebufp);
	PIN_FLIST_FLD_PUT (tmp_flistp, PIN_FLD_POID, (void *)vp, ebufp);

	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 9, ebufp);
	PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_PAY_TYPE, &paytype_inv, ebufp);

	dp = pbo_decimal_from_double (0.00, ebufp);
	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 10, ebufp);
	PIN_FLIST_FLD_PUT (tmp_flistp, PIN_FLD_DUE,(void *)dp, ebufp);
	
	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_ARGS, 11, ebufp);
	PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_CREATED_T, &item_start_t, ebufp);

	/***********************************************************
	 * Search results
	 ***********************************************************/
	tmp_flistp = PIN_FLIST_ELEM_ADD (s_flistp, PIN_FLD_RESULTS, 0, ebufp);
	PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_POID, (poid_t *)NULL, ebufp);
	PIN_FLIST_FLD_SET (tmp_flistp, PIN_FLD_ACCOUNT_OBJ, (poid_t *)NULL, ebufp);
	

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_init_search error", ebufp);

		PIN_FLIST_DESTROY_EX (&s_flistp, 0);
	}else{
		*s_flistpp = s_flistp;

		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_init_search: search flist for 2D pymt allocation", s_flistp);
	}

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

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_init_search application info flist", app_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_init_search search flist", search_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_post_init_search error", ebufp);
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
	int32		rec_id = 0;
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
										   &m_rec_id, 1, &m_cookie, ebufp)) != NULL) 			     {

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
	int32 		mul_res_count 	= 0;
	int32		i	      	= 0;
	int64           tmp_count 	= 0;
	int32		bi_id		= 0;
	int32           m_rec_id 	= 0;
	pin_cookie_t    m_cookie 	= NULL;
	pin_flist_t	*tmp_mul_flist 	= NULL;
	pin_flist_t	*tmp_res_flist 	= NULL;
	poid_t		*bi_poid      	= NULL;
	pin_flist_t	*tmp_flist	= NULL;
	
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_tune application info flist", 
					   app_flistp);
	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_tune search results flist", 
					   srch_res_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_post_tune error", ebufp);
	}
	return;
}

/*******************************************************************
 * Function executed after seach results were processed
 * Called prior MTA_JOB_DONE policy opcode
 *******************************************************************/
PIN_EXPORT void 
pin_mta_job_done(
		pin_flist_t	*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_job_done application info flist", app_flistp);

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
		pin_flist_t	*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_job_done application info flist", app_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_post_job_done error", ebufp);
	}
	return;
}

/*******************************************************************
 * Function executed at application exit
 * Called prior MTA_EXIT policy opcode
 *******************************************************************/
PIN_EXPORT void
pin_mta_exit(
		pin_flist_t	*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_exit application info flist", app_flistp);

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
		pin_flist_t	*app_flistp,
		pin_errbuf_t	*ebufp)
{
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_post_exit application info flist", 
					   app_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_post_exit error", ebufp);
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

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_init thread info flist", ti_flistp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_worker_init error", ebufp);
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
	pin_flist_t	*in_flistp = NULL;

	int32		bill_flags = 2;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERRBUF_CLEAR (ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_opcode search results flist", 
					   srch_res_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_opcode prepared flist for main opcode", 
					   op_in_flistp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_opcode thread info flist", 
					   ti_flistp);
					   
	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_opcode output flist from main opcode", *op_out_flistpp);

	in_flistp = PIN_FLIST_CREATE(ebufp);
	PIN_FLIST_FLD_COPY(op_in_flistp, PIN_FLD_ACCOUNT_OBJ,in_flistp, PIN_FLD_POID, ebufp);
        PIN_FLIST_FLD_COPY(op_in_flistp, PIN_FLD_POID, in_flistp, PIN_FLD_BILLINFO_OBJ, ebufp);
	PIN_FLIST_FLD_SET(in_flistp, PIN_FLD_FLAGS, &bill_flags, ebufp);
        PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG,  "TD_OP_PYMT_ALLOCATE input flist", in_flistp);


	PCM_OP(ctxp, TD_OP_PYMT_ALLOCATE, SRCH_DISTINCT, in_flistp, op_out_flistpp, ebufp);

	PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG,"TD_OP_PYMT_ALLOCATE output flist", *op_out_flistpp); 

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "pin_mta_worker_opcode error", ebufp);

		PIN_FLIST_DESTROY_EX (op_out_flistpp, 0);
	}else{
		PIN_ERR_LOG_FLIST (PIN_ERR_LEVEL_DEBUG, "pin_mta_worker_opcode output flist", *op_out_flistpp);
	}

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


/**
  * Strips the hours / mins / seconds from the input timestamp.
  *
  * @param date the input timestamp
  *
  * @returns a timestamp equivalent to midnight of the date contained in the input timestamp.
  */
time_t truncate_time(time_t date)
{
        time_t truncated_time ;
        struct tm tm ;

        gmtime_r(&date, &tm) ;
        tm.tm_sec = tm.tm_min = tm.tm_hour = 0 ;
        truncated_time = mktime(&tm) ;

        return truncated_time ;
}


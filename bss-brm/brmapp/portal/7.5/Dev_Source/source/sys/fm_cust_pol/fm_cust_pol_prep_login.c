/*******************************************************************
 *
 * Copyright (c) 1999, 2009, Oracle and/or its affiliates. 
 * All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static  char Sccs_Id[] = "@(#)$Id: fm_cust_pol_prep_login.c /cgbubrm_7.3.2.rwsmod/1 2009/08/04 23:37:19 pjegan Exp $";
#endif

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/timeb.h>
#include "pin_sys.h"
#include "pin_os.h"
#include "pcm.h"
#include "ops/cust.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pin_cust.h"
#include "pinlog.h"
#include "fm_utils.h"

EXPORT_OP void
op_cust_pol_prep_login(
        cm_nap_connection_t	*connp,
	int32			opcode,
        int32			flags,
        pin_flist_t		*in_flistp,
        pin_flist_t		**ret_flistpp,
        pin_errbuf_t		*ebufp);

static void
fm_cust_pol_prep_login(
        cm_nap_connection_t	*connp,
	pin_flist_t		*in_flistp,
        int32			flags,
	pin_flist_t		**out_flistpp,
        pin_errbuf_t		*ebufp);

static void
fm_cust_pol_prep_login_domain(
	char			*login,
	char			*domain,
	char			*result,
	int			result_size,
	pin_errbuf_t		*ebufp );

extern void
fm_cust_pol_gen_gsm_login(
	char			*generated_login,
	int32			size);


void
fm_cust_pol_gen_tcf_login(
        char            *generated_login,
        int32           size);
/*******************************************************************
 * Main routine for the PCM_OP_CUST_POL_PREP_LOGIN  command
 *******************************************************************/
void
op_cust_pol_prep_login(
        cm_nap_connection_t	*connp,
	int32			opcode,
        int32			flags,
        pin_flist_t		*in_flistp,
        pin_flist_t		**ret_flistpp,
        pin_errbuf_t		*ebufp)
{
	pin_flist_t		*r_flistp = NULL;

	/***********************************************************
	 * Null out results until we have some.
	 ***********************************************************/
	*ret_flistpp = NULL;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Insanity check.
	 ***********************************************************/
	if (opcode != PCM_OP_CUST_POL_PREP_LOGIN) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"bad opcode in op_cust_pol_prep_login", ebufp);
		return;
	}

	/***********************************************************
	 * We will not open any transactions with Policy FM
	 * since policies should NEVER modify the database.
	 ***********************************************************/

	/***********************************************************
	 * Log input flist
	 ***********************************************************/
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_cust_pol_prep_login input flist", in_flistp);

	/***********************************************************
	 * Call main function to do it
	 ***********************************************************/
	fm_cust_pol_prep_login(connp, in_flistp, flags, &r_flistp, ebufp);

	/***********************************************************
	 * Results.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		*ret_flistpp = (pin_flist_t *)NULL;
		PIN_FLIST_DESTROY_EX(&r_flistp, NULL);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_cust_pol_prep_login error", ebufp);
	} else {
		*ret_flistpp = r_flistp;
		PIN_ERR_CLEAR_ERR(ebufp);
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_cust_pol_prep_login return flist", r_flistp);
	}

	return;
}

/*******************************************************************
 * fm_cust_pol_prep_login()
 *
 *	Prep the login to be ready for on-line registration.
 *
 *	XXX HARDCODE - STUBBED PROTOTYPE ONLY XXX
 *
 *******************************************************************/
static void
fm_cust_pol_prep_login(
        cm_nap_connection_t	*connp,
	pin_flist_t		*in_flistp,
	int32                   flags,
	pin_flist_t		**out_flistpp,
        pin_errbuf_t		*ebufp)
{
	pcm_context_t		*ctxp = connp->dm_ctx;
	poid_t			*o_pdp = NULL;
	char			*domain = NULL;
	char			*login = NULL;
	const char		*type = NULL;
	char			*name = NULL;
	char			logout[512];
	char                    generated_login[255];
        pin_cookie_t            cookie = NULL;
        pin_flist_t             *flistp = NULL;
        int32                   elemid;
	int32			err;
	int32			*flag = NULL;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Prep outgoing flist
	 ***********************************************************/
	*out_flistpp = PIN_FLIST_CREATE(ebufp);

	o_pdp = (poid_t *)PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_POID, 0, ebufp);
	PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_POID, (void *)o_pdp, ebufp);

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_prep_login error", ebufp);
		return;
	}

	/***********************************************************
	 * Now for the login.
	 ***********************************************************/
	login = (char *)PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_LOGIN, 1, ebufp);
	
	type = PIN_POID_GET_TYPE(o_pdp);

	/***********************************************************
	 * if /service/gsm then we need to generate a unique login
	 * during registration
	 ***********************************************************/
	if (!strncmp(type, "/service/gsm", 12)) {
		if ( 
			login &&
			( 
				(flags & PCM_OPFLG_CUST_REGISTRATION) ||
				(fm_utils_op_is_ancestor(connp->coip,
					PCM_OP_CUST_COMMIT_CUSTOMER)) ||
				(fm_utils_op_is_ancestor(connp->coip,
					PCM_OP_CUST_MODIFY_CUSTOMER))
			)
		) {

			fm_cust_pol_gen_gsm_login(generated_login, 255);

			PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_LOGIN,
					generated_login,
					ebufp);
		} else if ( login ) {
			/*
			 * else leave what here, if user try to change it
			 * valid login will catch it
			 */
			 PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_LOGIN,
				(void *)login, ebufp);
		}

		cookie = NULL;
		for(
			flistp = PIN_FLIST_ELEM_GET_NEXT( in_flistp,
				PIN_FLD_ALIAS_LIST, &elemid, 0, &cookie, ebufp );
			ebufp->pin_err == PIN_ERR_NONE;
			flistp = PIN_FLIST_ELEM_GET_NEXT( in_flistp,
				PIN_FLD_ALIAS_LIST, &elemid, 0, &cookie, ebufp )
		) {
			PIN_FLIST_ELEM_SET( *out_flistpp, flistp,
				PIN_FLD_ALIAS_LIST, elemid, ebufp );
		}
		if ( ebufp->pin_err == PIN_ERR_NOT_FOUND ) {
			PIN_ERR_CLEAR_ERR( ebufp );
		}

		return;
	}

	/***********************************************************
	* if /service/telco then we need to generate a unique login 
	* during registration
	***********************************************************/
	if ((!strcmp(type, "/service/telco")) || 
		(!strncmp(type, "/service/telco/", 15))) {
		if ( 
			login && (
				(flags & PCM_OPFLG_CUST_REGISTRATION) ||
		    		(fm_utils_op_is_ancestor(connp->coip, 
					     PCM_OP_CUST_COMMIT_CUSTOMER)) ||
		    		(fm_utils_op_is_ancestor(connp->coip, 
					     PCM_OP_CUST_MODIFY_CUSTOMER))
			)
		) {

			fm_cust_pol_gen_tcf_login(generated_login, 255);
			
			PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_LOGIN, 
					  generated_login,
					  ebufp);
		} else if ( login ) {
			/* 
			 * else leave what here, if user try to change it
			 * valid login will catch it 
			 */
			PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_LOGIN,
					(void *)login, ebufp);
		}

		cookie = NULL;
		for( 
		    flistp = PIN_FLIST_ELEM_GET_NEXT( in_flistp, 
			PIN_FLD_ALIAS_LIST, &elemid, 0, &cookie, ebufp );
		    ebufp->pin_err == PIN_ERR_NONE;
		    flistp = PIN_FLIST_ELEM_GET_NEXT( in_flistp, 
			PIN_FLD_ALIAS_LIST, &elemid, 0, &cookie, ebufp ) 
		) {

			PIN_FLIST_ELEM_SET( *out_flistpp, flistp, 
					PIN_FLD_ALIAS_LIST, elemid, ebufp );
		}
		if ( ebufp->pin_err == PIN_ERR_NOT_FOUND ) {
			PIN_ERR_CLEAR_ERR( ebufp );
		}

		return;
	}
	if ( type && !strcmp(type, "/service/email")) {

		/* If conf'ed force default domain */

		pin_conf("fm_cust_pol", "domain", PIN_FLDT_STR,
			(caddr_t *)&(domain), &(err));

		if (domain != (char *)NULL) {

			/* attach correct domain */
			if ( login ) {
				fm_cust_pol_prep_login_domain( login, domain, 
					logout, sizeof(logout), ebufp );

				PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_LOGIN,
					(void *)logout, ebufp);
			}

			/**************************************************************
			 * Check for NULL login. If login is not found in the input,
			 * then set it as an empty string so that it will fail at
			 * PCM_OP_CUST_POL_VALID_LOGIN opcode. We can't have a service 
			 * with NULL or empty login as it may cause security breach. 
			 **************************************************************/
			if (!login && fm_utils_op_is_ancestor(
				connp->coip, PCM_OP_CUST_CREATE_SERVICE)) {
				PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_LOGIN,
						(void *)"", ebufp);
			}
		
			cookie = NULL;
			for ( 
			    flistp = PIN_FLIST_ELEM_GET_NEXT( in_flistp, 
				PIN_FLD_ALIAS_LIST, &elemid, 0, &cookie, ebufp );
			    ebufp->pin_err == PIN_ERR_NONE;
			    flistp = PIN_FLIST_ELEM_GET_NEXT( in_flistp, 
				PIN_FLD_ALIAS_LIST, &elemid, 0, &cookie, ebufp )
			) {

				if ( flistp ) {
					name = PIN_FLIST_FLD_GET( flistp, 
							PIN_FLD_NAME,
							1, ebufp );
				} else {
					name = NULL;
				}
				if ( name ) {
					fm_cust_pol_prep_login_domain( name, domain,
							logout, sizeof(logout),
							ebufp );
					flistp = PIN_FLIST_ELEM_ADD( *out_flistpp, 
							PIN_FLD_ALIAS_LIST, 
							elemid, ebufp );

					PIN_FLIST_FLD_SET( flistp, PIN_FLD_NAME,
							(void *)logout, ebufp );
				} else {
					PIN_FLIST_ELEM_SET( *out_flistpp, NULL, 
							PIN_FLD_ALIAS_LIST, 
							elemid, ebufp );
				}
			}
		
			if ( ebufp->pin_err == PIN_ERR_NOT_FOUND ) {
				PIN_ERR_CLEAR_ERR( ebufp );
			}

			free(domain);

		} else {
			pin_set_err(ebufp, PIN_ERRLOC_FM,
				PIN_ERRCLASS_SYSTEM_DETERMINATE,
				PIN_ERR_INVALID_CONF, PIN_FLD_LOGIN, 0, err);
		}
		
	} else {
		/* Just keep what we have */
		if ( login ) {
			PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_LOGIN,
					(void *)login, ebufp);
		}

		/**************************************************************
		 * Check for NULL login. If login is not found in the input,
		 * then set it as an empty string so that it will fail at
		 * PCM_OP_CUST_POL_VALID_LOGIN opcode. We can't have a service 
		 * with NULL or empty login as it may cause security breach. 
		 **************************************************************/
		if (!login && fm_utils_op_is_ancestor(
                        connp->coip, PCM_OP_CUST_CREATE_SERVICE)) {
			PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_LOGIN,
					(void *)"", ebufp);
		}
	
		cookie = NULL;
		for( 
		    flistp = PIN_FLIST_ELEM_GET_NEXT( in_flistp, 
			PIN_FLD_ALIAS_LIST, &elemid, 0, &cookie, ebufp );
		    ebufp->pin_err == PIN_ERR_NONE;
		    flistp = PIN_FLIST_ELEM_GET_NEXT( in_flistp, 
			PIN_FLD_ALIAS_LIST, &elemid, 0, &cookie, ebufp ) 
		) {

			PIN_FLIST_ELEM_SET( *out_flistpp, flistp, 
					PIN_FLD_ALIAS_LIST, elemid, ebufp );
		}
		if ( ebufp->pin_err == PIN_ERR_NOT_FOUND ) {
			PIN_ERR_CLEAR_ERR( ebufp );
		}

	}

	/***********************************************************
	 * Error?
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_prep_login error", ebufp);
	}

	return;
}


/*******************************************************************
 * fm_cust_pol_prep_login_domain():
 *
 *	Used to create a login with domain for email services
 *
 *******************************************************************/
static void
fm_cust_pol_prep_login_domain(
	char			*login,
	char			*domain,
	char			*result,
	int			result_size,
	pin_errbuf_t		*ebufp )
{
	int			i = 0;
	char			*ptr = NULL;

	memset( result, 0, result_size );

	if ( login && domain ) {
		strncpy( result, login, result_size - 1 );

		/* Force login to lower case for email names */

		i = 0;
		while( result[i] != '\0' ) {
			result[i] = tolower( result[i] );
			i++;
		}

		/* if it already has a domain remove it */
		ptr = (char *)strchr( result, '@' );
		if ( ptr != (char *)NULL ) {
			*ptr = '\0';
		}

		/* if there is room add the domain */
		if ( strlen( result ) + strlen( domain ) + 1 < result_size ) {
			strcat(result, "@");
			strcat(result, domain);
		}
	} else {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_INVALID_CONF, PIN_FLD_LOGIN, 0, 0);
	}
	return;
}


/*******************************************************************
 * fm_cust_pol_gen_gsm_login:
 *
 *      Generate a unique login used by /service/gsm and subtype
 *
 *      Returns a unique identifier based on the local algorithm.
 *      Currently a string comprising Host-name, Process-id, Thread-id,
 *      Millisecond-timestamp and a local cpter.
 *      "MilliSecond-Timestamp-local_cpter-PID-TID-hostname"
 *******************************************************************/
void
fm_cust_pol_gen_gsm_login(
	char            *generated_login,
	int32           size)
{
	struct timeb    timeStruct;
	char            tmp_time[50];
	static int32    init = 0; /* indicate if init done */
	static char     *the_hostname = NULL;
	static int32    the_pid = 0;
	static int32    cpter = 0;

	if((generated_login == 0) || (size <= 0))
		return;

	/**************************************************************
	 * Get the current millisecond timestamp.
	 **************************************************************/
	ftime(&timeStruct);
	memset(tmp_time, 0, sizeof(tmp_time));
	pin_strftimet(tmp_time, sizeof(tmp_time),
		"%Y%m%d-%H%M%S",  timeStruct.time);

	/**************************************************************
	 * If not cached, cache hostname and pid /tid
	 **************************************************************/
	if (0 == init) {
		the_pid = getpid();
		the_hostname = pin_malloc(size);
		if (gethostname(the_hostname, size -1) == -1) {
			strcpy(the_hostname, "<unknown>");
		}
		init = 1;
	}

	/**************************************************************
	 * Login String = millisec-timestamp-local_cpter-pid-tid-hostname
	 **************************************************************/
	snprintf(generated_login, size, "%03hu-%s-%d-%d-%d-%s",
		timeStruct.millitm, tmp_time, cpter++,
		the_pid, pin_thread_id(), the_hostname);

	return;
}



/*******************************************************************
 * fm_cust_pol_gen_tcf_login:
 *
 *      Generate a unique login used by /service/telco and subtype
 *
 *	Returns a unique identifier based on the local algorithm.
 *	Currently a string comprising Host-name, Process-id, Thread-id,
 *	Millisecond-timestamp and a local cpter.
 *	"MilliSecond-Timestamp-local_cpter-PID-TID-hostname"
 *******************************************************************/
void
fm_cust_pol_gen_tcf_login(
	char		*generated_login,
	int32		size)
{
	struct timeb 	timeStruct;
	char		tmp_time[50];
	static int32    init = 0; /* indicate if init done */
	static char     *the_hostname = NULL;
	static int32    the_pid = 0;
	static int32    cpter = 0;
	
	if((generated_login == 0) || (size <= 0))
		return;

	/**************************************************************
	 * Get the current millisecond timestamp.
	 **************************************************************/
	ftime(&timeStruct);
	memset(tmp_time, 0, sizeof(tmp_time));
	pin_strftimet(tmp_time, sizeof(tmp_time), 
		      "%Y%m%d-%H%M%S",  timeStruct.time);

	/**************************************************************
	 * If not cached, cache hostname and pid /tid 
	 **************************************************************/
	if (0 == init) {
		the_pid = getpid();
		the_hostname = pin_malloc(size);
		if (gethostname(the_hostname, size -1) == -1) {
			strcpy(the_hostname, "<unknown>");
		}
		init = 1;
	}

	/**************************************************************
	 * Login String = millisec-timestamp-local_cpter-pid-tid-hostname
	 **************************************************************/
	snprintf(generated_login, size, "%03hu-%s-%d-%d-%d-%s", 
		 timeStruct.millitm, tmp_time, cpter++, 
		 the_pid, pin_thread_id(), the_hostname);

	return;
}


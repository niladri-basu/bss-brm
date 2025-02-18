/*******************************************************************
 *
* Copyright (c) 1999, 2011, Oracle and/or its affiliates. All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static  char Sccs_Id[] = "@(#)$Id: fm_cust_pol_valid_passwd.c /cgbubrm_main.rwsmod/1 2011/08/15 23:03:22 dbangalo Exp $";
#endif

#include <stdio.h>
#include <stdlib.h> 
 
#include "pcm.h"
#include "ops/cust.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pin_cust.h"
#include "pinlog.h"

#define FM_PWD_MAX_PASSWD	255
#define FM_PWD_INVALID_PASSWD	"&aes|"

/*******************************************************************
 * Routines contained herein.
 *******************************************************************/
EXPORT_OP void
op_cust_pol_valid_passwd(
        cm_nap_connection_t	*connp,
	u_int			opcode,
        u_int			flags,
        pin_flist_t		*in_flistp,
        pin_flist_t		**ret_flistpp,
        pin_errbuf_t		*ebufp);

static void
fm_cust_pol_valid_passwd(
	pcm_context_t		*ctxp,
	pin_flist_t		*in_flistp,
	pin_flist_t		**out_flistpp,
        pin_errbuf_t		*ebufp);

static void
fm_cust_pol_valid_pwd_srvc(
	pcm_context_t		*ctxp,
	pin_flist_t		*i_flistp,
	pin_flist_t		*r_flistp,
        pin_errbuf_t		*ebufp);


/*******************************************************************
 * Routines needed from elsewhere.
 *******************************************************************/
extern void
fm_cust_pol_validate_fld_value (
	pcm_context_t   *ctxp,
	pin_flist_t     *in_flistp,
	pin_flist_t     *i_flistp,
	pin_flist_t     *r_flistp,
	u_int           pin_fld_field_num,
	u_int           pin_fld_element_id,
	char            *cfg_name,
	int             type,
	pin_errbuf_t    *ebufp);
 
/*******************************************************************
 * Main routine for the PCM_OP_CUST_POL_VALID_PASSWD  command
 *******************************************************************/
void
op_cust_pol_valid_passwd(
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
	if (opcode != PCM_OP_CUST_POL_VALID_PASSWD) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"bad opcode in op_cust_pol_valid_passwd", ebufp);
		return;
	}

	/***********************************************************
	 * Call main function to do it
	 ***********************************************************/
	fm_cust_pol_valid_passwd(ctxp, in_flistp, &r_flistp, ebufp);

	/***********************************************************
	 * Results.
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		*ret_flistpp = (pin_flist_t *)NULL;
		PIN_FLIST_DESTROY(r_flistp, NULL);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_cust_pol_valid_passwd error", ebufp);
	} else {
		*ret_flistpp = r_flistp;
		PIN_ERR_CLEAR_ERR(ebufp);
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_cust_pol_valid_passwd return flist", r_flistp);
	}

	return;
}

/*******************************************************************
 * fm_cust_pol_valid_passwd()
 *
 *	Validate the given passwd according to the given poid type.
 *
 *******************************************************************/
static void
fm_cust_pol_valid_passwd(
	pcm_context_t		*ctxp,
	pin_flist_t		*in_flistp,
	pin_flist_t		**out_flistpp,
        pin_errbuf_t		*ebufp)
{
	pin_flist_t		*r_flistp = NULL;

	poid_t			*o_pdp;
	const char		*o_type = NULL;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Create outgoing flist
	 ***********************************************************/
	r_flistp = PIN_FLIST_CREATE(ebufp);
	*out_flistpp = r_flistp;

	/***********************************************************
	 * Get (and add) the object poid.
	 ***********************************************************/
	o_pdp = (poid_t *)PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_POID, 0, ebufp);
	PIN_FLIST_FLD_SET(r_flistp, PIN_FLD_POID, (void *)o_pdp, ebufp);

	/***********************************************************
	 * We might have different rules for different services.
	 ***********************************************************/
	o_type = PIN_POID_GET_TYPE(o_pdp);

	if (!strncmp(o_type, "/service", 8)) {

		/* Any service password */
		fm_cust_pol_valid_pwd_srvc(ctxp, in_flistp, r_flistp, ebufp);

	} else {

		/* Error - unknown/usupported type */
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_POID_TYPE, PIN_FLD_POID, 0, 0);

	}

	/***********************************************************
	 * Error?
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_valid_passwd error", ebufp);
	}

	return;
}

/*******************************************************************
 * fm_cust_pol_valid_pwd_srvc():
 *
 *	Validate the service level password.
 *
 *******************************************************************/
static void
fm_cust_pol_valid_pwd_srvc(
	pcm_context_t		*ctxp,
	pin_flist_t		*i_flistp,
	pin_flist_t		*r_flistp,
        pin_errbuf_t		*ebufp)
{
	u_int			result;
        const char              *pwd = NULL;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/***********************************************************
	 * Pass by default.
	 ***********************************************************/
	result = PIN_CUST_VERIFY_PASSED;
	PIN_FLIST_FLD_SET(r_flistp, PIN_FLD_RESULT, (void *)&result, ebufp);

	pwd = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_PASSWD_CLEAR, 0, ebufp); 
	if (pwd && !strncmp(pwd, FM_PWD_INVALID_PASSWD, strlen(FM_PWD_INVALID_PASSWD))) {
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, " Invalid Password."); 
		pin_errbuf_set_err( ebufp, PIN_ERRLOC_FM, PIN_ERRCLASS_SYSTEM_DETERMINATE,
                                     PIN_ERR_VALIDATION_FAILED, 0, 0, 0, PIN_DOMAIN_ERRORS,
                                     PIN_ERR_VALIDATE_PASSWORD,1, 0, NULL);
		goto cleanup;
		/***********/
	}



	/***********************************************************
	 * If it's there, is it too long?
         * Try to validate based on /config/fld_validate (Pswd) obj.
         ***********************************************************/
	fm_cust_pol_validate_fld_value( ctxp, i_flistp, i_flistp, r_flistp,
		PIN_FLD_PASSWD_CLEAR,
		0,              /* element_id   */
		"Pswd",
		1,
		ebufp);

cleanup:
	/***********************************************************
	 * Error?
	 ***********************************************************/
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_valid_pwd_srvc error", ebufp);
	}

	return;
}


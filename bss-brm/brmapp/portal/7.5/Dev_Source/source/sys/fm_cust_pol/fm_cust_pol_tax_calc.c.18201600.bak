/*******************************************************************
 *
 *      Copyright (c) 2001-2008 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static  char Sccs_Id[] = "@(#)%Portal Version: fm_cust_pol_tax_calc.c:RWSmod7.3.1Int:1:2007-Jun-28 05:35:06 %";
#endif

/************************************************************************
 * Contains the following operations:
 *
 *   PCM_OP_CUST_POL_TAX_CALC - can be used to calculate taxes using those
 *                              custom tax rates.
 *
 ************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "pcm.h"
#include "ops/cust.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pinlog.h"
#include "pin_bill.h"
#include "pin_cust.h"
#include "pin_rate.h"
#include "fm_utils.h"
#include "fm_bill_utils.h"

/************************************************************************
 * Forward declarations.
 ************************************************************************/
EXPORT_OP void
op_cust_pol_tax_calc(
	cm_nap_connection_t	*connp,
	int32			opcode,
	int32			flags,
	pin_flist_t		*in_flistp,
	pin_flist_t		**out_flistpp,
	pin_errbuf_t		*ebufp);

void
fm_cust_pol_tax_calc(
	pcm_context_t		*ctxp,
	pin_flist_t		*in_flistp,
	pin_flist_t		**out_flistpp,
	pin_errbuf_t		*ebufp);

static void
fm_cust_pol_build_subtotal(
	pin_flist_t		*os_flistp,
	int32			j_level,
	pin_decimal_t		*tax_amt,
	pin_decimal_t		*tax_rate,
	pin_decimal_t		*amt_taxed,
	pin_decimal_t		*amt_exempt,
	pin_decimal_t		*amt_gross,
	char			*name,
	char			*descr,
	int32			loc_mode,
	int32			precision,
	int32			round_mode,
	pin_errbuf_t		*ebufp);

static void
fm_cust_pol_do_juris_only(
	pin_flist_t		*in_flistp,
	pin_flist_t		**out_flistpp,
	pin_errbuf_t		*ebufp);

static pin_decimal_t *
fm_cust_pol_get_amt_exempt(
	pin_flist_t		*in_flistp,
	int32			j_level,
	pin_decimal_t		*g_amt,
	pin_errbuf_t		*ebufp);

static void
fm_cust_pol_parse_tax_locale(
	char			*locale,
	char			*city,
	char			*state,
	char			*zip,
	char			*country,
	char			*code);


/* Symbol defines */
#define STR_LEN		480
#define TOK_LEN		80
#define RatePrecision	6

/* Global variable (from fm_cust_pol_tax_init)  */
extern pin_flist_t *Tax_Table;
PIN_IMPORT void fm_utils_tax_get_taxcodes();


/*******************************************************************
 * Main routine for the PCM_OP_CUST_POL_TAX_CALC command
 *******************************************************************/
void
op_cust_pol_tax_calc(
	cm_nap_connection_t	*connp,
	int32			opcode,
	int32			flags,
	pin_flist_t		*in_flistp,
	pin_flist_t		**out_flistpp,
	pin_errbuf_t		*ebufp)
{
	pcm_context_t		*ctxp = connp->dm_ctx;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/*
	 * Insanity check.
	 */
	if (opcode != PCM_OP_CUST_POL_TAX_CALC) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_cust_pol_tax_calc opcode error", ebufp);
		return;
	}

	/*
	 * Debug - What we got.
	 */
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_cust_pol_tax_calc input flist", in_flistp);

	/*
	 * Do the actual op in a sub. 
	 */
	fm_cust_pol_tax_calc(ctxp, in_flistp, out_flistpp, ebufp);

	/*
	 * Error?
	 */
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_DEBUG,
			"op_cust_pol_tax_calc error", ebufp);
	} else {
		/*
		 * Debug: What we're sending back.
		 */
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_cust_pol_tax_calc return flist", *out_flistpp);
	}

	return;
}


/*******************************************************************
 * fm_cust_pol_tax_calc()
 *
 * Use this policy to do your tax calculation using the tax data 
 * that was loaded into the internal data structure that was 
 * declared in fm_cust_pol_tax_init.
 *
 *******************************************************************/
void 
fm_cust_pol_tax_calc(
	pcm_context_t	*ctxp,
	pin_flist_t	*in_flistp,
	pin_flist_t	**out_flistpp,
	pin_errbuf_t	*ebufp)
{
	pin_flist_t	*t_flistp = NULL;   /* in taxes array */
	pin_flist_t	*ot_flistp = NULL;  /* out taxes array */
	pin_flist_t	*os_flistp = NULL;  /* out subtotal array */
	pin_flist_t	*flistp = NULL;
	pin_cookie_t	cookie = NULL;
	pin_cookie_t	cookie2 = NULL;
	int32		elemid = 0;
	int32		elemid2 = 0;
	int32		elemcnt = 0;
	int32		j_level = 0;
	char		*j_list = NULL;
	char		*descr = NULL;
	char		*str_tax_rate = NULL;
	void		*vp = NULL;
	char		*taxcode = NULL;
	char		*locale = NULL;
	char		city[TOK_LEN];
	char		state[TOK_LEN];
	char		zip[TOK_LEN];
	char		county[TOK_LEN];
	char		country[TOK_LEN];
	char		code[TOK_LEN];
	char		name[STR_LEN];
	char		msg[STR_LEN];
	pin_decimal_t	*tax_rate=NULL; 
	pin_decimal_t	*tot_tax=NULL;
	pin_decimal_t	*tax_amt=NULL;
	pin_decimal_t	*amt_gross=NULL;
	pin_decimal_t	*amt_taxed = NULL;
	pin_decimal_t	*amt_exempt = NULL;
	int32 		tax_pkg = PIN_RATE_TAXPKG_CUSTOM;
	int32		tax_rule = 0;
	int32		loc_mode = 0;
	int32		precision = 6;
	int32		round_mode = ROUND_HALF_UP;
	time_t		*startTm = NULL;
	time_t		*endTm = NULL;
	time_t		*transDt = NULL;
	time_t		now = 0;


	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/* Create the return flist */
	*out_flistpp = PIN_FLIST_CREATE(ebufp);

	/* Set the account POID */
	vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_POID, 0, ebufp);
	PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_POID, (void *)vp, ebufp);

	/* check for jurisdiction only ? */
	vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_COMMAND, 1, ebufp);
	if ((vp != (void*)NULL) && (*(int32*)vp == PIN_CUST_TAX_VAL_JUR)) {
		fm_cust_pol_do_juris_only(in_flistp, out_flistpp, ebufp);
		goto CleanUp;
		/***********/
        }

	/* get the transaction date = END_T */
	transDt = (time_t*) PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_END_T,
		1, ebufp);
	if (transDt == (time_t*)NULL) {
		/* not available. use current time */
		now = pin_virtual_time((time_t*)NULL);
		transDt = &now;
	}

	/* get precision, if any */
	vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_ROUNDING, 1, ebufp);
        if (vp != (void*)NULL) {
		precision = *(int32*)vp;
	}

	/* get rounding mode, if any */
	vp = PIN_FLIST_FLD_GET(in_flistp, PIN_FLD_ROUNDING_MODE, 1, ebufp);
	if (vp != (void*)NULL) {
		round_mode = *(int32*)vp;
	}

	/* Loop through array of incoming taxes */
	while ((t_flistp = PIN_FLIST_ELEM_GET_NEXT(in_flistp, PIN_FLD_TAXES,
		&elemid, 1, &cookie, ebufp)) != (pin_flist_t*)NULL) {

		/* initialize */
		tot_tax = pbo_decimal_from_str("0.0",ebufp);
		tax_amt = (pin_decimal_t*)NULL;
		tax_rate = (pin_decimal_t*)NULL;
		amt_gross = (pin_decimal_t*)NULL;
		amt_taxed = (pin_decimal_t*)NULL;
		amt_exempt = (pin_decimal_t*)NULL;
		j_level = elemcnt = 0;
		descr = "Zero Taxes"; 
		loc_mode = 0;

		/* add a tax array into the return flist */
		ot_flistp = PIN_FLIST_ELEM_ADD(*out_flistpp, 
			PIN_FLD_TAXES, elemid, ebufp);

		/* Add package type to the taxes array */
		PIN_FLIST_FLD_SET(ot_flistp, PIN_FLD_TAXPKG_TYPE,
			(void*)&tax_pkg, ebufp);

		/* add the total taxes to the taxes array */
		PIN_FLIST_FLD_PUT(ot_flistp, PIN_FLD_TAX, 
			(void*)pbo_decimal_round (tot_tax,
			(int32)precision,round_mode,ebufp), ebufp);

		/* get taxcode */
		taxcode = (char*) PIN_FLIST_FLD_GET(t_flistp,
			PIN_FLD_TAX_CODE, 1, ebufp);
		if (taxcode == (char*)NULL) {
			/* no taxcode? then skip */
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
				"No taxcode!  Skipping ...");
			continue;
			/*******/
		}

		/* get tax locale = PIN_FLD_SHIP_TO */
		locale = (char*) PIN_FLIST_FLD_GET(t_flistp,
			PIN_FLD_SHIP_TO, 1, ebufp);
		if (locale == (char*)NULL) {
			/* no tax locale? then skip */
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
				"No SHIP_TO locale!  Skipping ...");
			continue;
			/*******/
		}

		/* get location mode */
		vp =  PIN_FLIST_FLD_GET(t_flistp,
			PIN_FLD_LOCATION_MODE, 1, ebufp);
		if (vp) {
			loc_mode = *(int32 *)vp;
		}
		/* initialize */
		city[0] = county[0] = state[0] = zip[0] = country[0] = '\0';
		code[0] = name[0] = '\0'; 

		/* parse the locale */
		fm_cust_pol_parse_tax_locale(locale, city, state, zip,
			country, code);

		/* get taxable amount */
		vp = PIN_FLIST_FLD_GET(t_flistp, 
			PIN_FLD_AMOUNT_TAXED, 1, ebufp);
		if (vp == (void*)NULL) {
			/* no amount?  default to zero */
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
				"No AMOUNT_TAXED!  Defaulting to 0.");
			amt_gross = pbo_decimal_from_str("0.0",ebufp);
		} else {
			amt_gross = pbo_decimal_copy((pin_decimal_t*)vp, ebufp);
		}

		/* construct the taxed jurisdiction */
		if (*code) {
			sprintf(name, "%s; %s; %s; %s; %s; [%s]",
				country, state, city, county, zip, code);
		} else {
			sprintf(name, "%s; %s; %s; %s; %s",
				country, state, city, county, zip);
		}

		elemid2 = 0; cookie2 = NULL;
		/* compute tax for each matching taxcode in the table */
		while ((flistp = PIN_FLIST_ELEM_GET_NEXT(Tax_Table, 
			PIN_FLD_TAXES, &elemid2, 1, &cookie2, ebufp))
						!= (pin_flist_t*)NULL) {

			/* get the taxcode */
			vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_TAX_CODE,
				1, ebufp);

			/* taxcode match? */
			if (vp) {
				if (strcmp((char*)vp, taxcode) != 0) {
					/* taxcode did not match */
					sprintf(msg,"Checking taxcode %s with %s. Skipping ...",
						taxcode, (char*)vp);
					PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, msg);
					continue;
					/*******/
				} else {
					/* taxcode matches */
				sprintf(msg, "Checking taxcode %s with %s. Matched!", 
						taxcode, (char*)vp);
					PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, msg);
				}
			}
			else {
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_WARNING, "no tax code available");	
			}
			/* get validity dates */
			startTm = (time_t*) PIN_FLIST_FLD_GET(flistp,
				PIN_FLD_START_T, 1, ebufp);
			endTm = (time_t*) PIN_FLIST_FLD_GET(flistp,
				PIN_FLD_END_T, 1, ebufp);

			/* tax rate valid? */
			if (startTm && endTm && *startTm && *endTm &&
			    ((*transDt < *startTm) || (*transDt >= *endTm))) {
				/* tax rate is not valid */
				sprintf(msg,
				"Taxcode %s has expired rate. Skipping ...\n",
					taxcode);
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, msg);
				continue;
				/*******/
			} else {
				/* tax rate is valid */
				sprintf(msg, "Taxcode %s has valid rate!\n",
					taxcode);
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, msg);
			}

			/* get jurisdiction level */
			vp =  PIN_FLIST_FLD_GET(flistp, 
				PIN_FLD_TYPE, 1, ebufp);
			if (vp) {
				j_level = *(int32 *)vp;
			}
			else {
				j_level = 0;
			}
			switch (j_level) {
			case PIN_RATE_TAX_JUR_FED:
				locale = country;
				break;
			case PIN_RATE_TAX_JUR_STATE:
				locale = state;
				break;
			case PIN_RATE_TAX_JUR_COUNTY:
				locale = county;
				break;
			case PIN_RATE_TAX_JUR_CITY:
				locale = city;
				break;
			default:
				/* unsupported level */
				sprintf(msg,
		"Unsupported jurisdiction level %d!  Skipping ...", j_level);
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, msg);
				continue;
				/*******/
			}

			/* check for location mode */
			if (loc_mode != PIN_RATE_LOC_ADDRESS) {
#ifdef MATCH_NPA_ONLY
				code[3] = '\0';
#endif
				locale = code;
			}

			/* get jurisdiction list (nexus) for the level */
			j_list = (char*) PIN_FLIST_FLD_GET(flistp, 
				PIN_FLD_NAME, 1, ebufp);

			if (j_list) {
				/* is locale in jurisdiction list? */
				if (j_list && (strstr(j_list, "*") || strstr(j_list, locale))) {
					/* locale in jurisdiction list */
					sprintf(msg,
			     		"Locale %s is in juris list '%s' for taxcode %s\n",
						locale, j_list, taxcode);
					PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, msg);
				} else {
					/* locale not in jurisdiction list */
					sprintf(msg,
	      				"Locale %s not in juris list '%s' for taxcode %s. Skipping ...\n",
						locale, j_list, taxcode);
					PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, msg);
					continue;
					/*******/
				} 
			}
			else {
				continue;
			}

			/* get exemptions, if any */
			amt_exempt = fm_cust_pol_get_amt_exempt(in_flistp,
				j_level, amt_gross, ebufp);
			
			/* get tax rate */
			vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_PERCENT,
				1, ebufp);
			if (vp == (void*)NULL) {
				/* no tax rate?  default to zero */
				tax_rate = pbo_decimal_from_str("0.0",ebufp);
			} else {
				tax_rate = pbo_decimal_copy((pin_decimal_t*)vp,
					ebufp);
			}
		
			str_tax_rate = pbo_decimal_to_str(tax_rate,ebufp);
			sprintf(msg, "Tax rate for taxcode %s is %s.", 
				taxcode,str_tax_rate); 
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, msg);

			/* get tax rule */
			vp =  PIN_FLIST_FLD_GET(flistp, 
				PIN_FLD_TAX_WHEN, 1, ebufp);
			if (vp) {
				tax_rule = *(int32*)vp;
			}
			else {
				tax_rule = 0;
			}
			/* this is the amount that will be taxed */
			/* amt_taxed = amt_gross - amt_exempt; */
			amt_taxed = pbo_decimal_subtract(amt_gross,
				amt_exempt,ebufp);


			/* tax on tax? */
			if (tax_rule == 1 || tax_rule == 5) {
				/* amt_taxed += tot_tax; */
				pbo_decimal_add_assign(amt_taxed,
					tot_tax, ebufp);
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
					"Tax on tax rule applied.");
			}

			/* calculate tax */
			if (tax_rule == 2 || tax_rule == 6) {
				/* The tax_rate is the flat fee */
				/* tax_amt = tax_rate; 
				   tax_rate = 0.0;
				*/
				tax_amt = tax_rate;
				tax_rate = pbo_decimal_from_str("0.0", ebufp);
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
					"Flat fee rule applied.");
			} else if (tax_rule == 3 || tax_rule == 7) {
				/* The tax is included in the amount */
				pin_decimal_t *base_amt = NULL; 
				pin_decimal_t *adj_rate = NULL;

				/* adj_rate = 1 + tax_rate */
				adj_rate = pbo_decimal_from_str("1.0", ebufp);
				pbo_decimal_add_assign(adj_rate, tax_rate,
					ebufp); 
                                /* base_amt = amt_taxed / (1 + tax_rate); */
				base_amt = pbo_decimal_divide(amt_taxed,
					adj_rate, ebufp);
                                /* tax_amt = amt_taxed - base_amt; */
				tax_amt = pbo_decimal_subtract(amt_taxed,
					base_amt, ebufp);
                                /* amt_taxed = base_amt; */
				pbo_decimal_destroy(&amt_taxed);
				amt_taxed = base_amt;
				pbo_decimal_destroy(&adj_rate);

				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
					"Inclusive tax rule applied.");
			} else {
				/* The tax_rate is a percentage */
				/* tax_amt = amt_taxed * tax_rate; */
				tax_amt = pbo_decimal_multiply(amt_taxed,
					tax_rate, ebufp);
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
					"Standard tax rule applied.");
			}

			/* add a subtotal array into the taxes array */ 
			os_flistp = PIN_FLIST_ELEM_ADD(ot_flistp, 
				PIN_FLD_SUBTOTAL, elemcnt++, ebufp);

			/* include the tax in the total? */
			if (tax_rule >= 0 && tax_rule <= 3) {
				PIN_FLIST_FLD_PUT(os_flistp, PIN_FLD_TAX, 
					(void*)pbo_decimal_round(tax_amt,
					 (int32)precision, round_mode, ebufp ), ebufp);
				/* tot_tax += tax_amt; */
				pbo_decimal_add_assign(tot_tax, tax_amt, ebufp);
				
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
					"Cumulative tax rule applied.");
			} else {
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
					"Non-cumulative tax rule applied.");
			}

			/* get tax description */
			descr = (char*) PIN_FLIST_FLD_GET(flistp, 
				PIN_FLD_DESCR, 1, ebufp);

			/* build the subtotals array */
			fm_cust_pol_build_subtotal(os_flistp, j_level,
				tax_amt, tax_rate, amt_taxed, amt_exempt,
				amt_gross, name, descr, loc_mode, precision,
				round_mode, ebufp); 
 
                	if (amt_taxed) {
                       		 pbo_decimal_destroy(&amt_taxed);
                	}
                	if ( amt_exempt) {
                       		 pbo_decimal_destroy(&amt_exempt);
                	}
                	if ( tax_rate ) {
                       		 pbo_decimal_destroy(&tax_rate);
                	}
                	if ( tax_amt ) {
                        	pbo_decimal_destroy(&tax_amt);
                	}
			if (str_tax_rate ) {
				free(str_tax_rate);
			}

		}

		if (elemcnt == 0) {
			/* No taxes computed.  Just add a (default)
			 * subtotal array into the taxes array.
			 */ 
			os_flistp = PIN_FLIST_ELEM_ADD(ot_flistp, 
				PIN_FLD_SUBTOTAL, elemcnt, ebufp);

			tax_amt = pbo_decimal_from_str("0.0", ebufp);
		        tax_rate = pbo_decimal_from_str("0.0", ebufp);
        		amt_taxed = pbo_decimal_from_str("0.0", ebufp);
        		amt_exempt = pbo_decimal_from_str("0.0", ebufp); 


			/* initialize subtotal array */ 
			fm_cust_pol_build_subtotal(os_flistp, j_level, tax_amt,
				tax_rate, amt_taxed, amt_exempt, amt_gross,
				name, descr, loc_mode, precision, round_mode,
				ebufp); 
		}


		/* add the total taxes to the taxes array */
		PIN_FLIST_FLD_PUT(ot_flistp, PIN_FLD_TAX, 
			(void*)pbo_decimal_round(tot_tax,
			(int32)precision,round_mode,ebufp), ebufp);

		if (amt_gross) {
			pbo_decimal_destroy(&amt_gross);
		}
		if (amt_taxed) {
			pbo_decimal_destroy(&amt_taxed);
		}
		if ( amt_exempt) {
			pbo_decimal_destroy(&amt_exempt);
		}
		if ( tot_tax ) {
			pbo_decimal_destroy(&tot_tax);
		}
		if ( tax_rate ) {
			pbo_decimal_destroy(&tax_rate);
		}
		if ( tax_amt ) {
			pbo_decimal_destroy(&tax_amt);
		}

	} /* end while */

CleanUp:
	
	/* Error? */
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_cust_pol_tax_calc error", ebufp);
	}

	return;
}


/*******************************************************************
 * fm_cust_pol_build_subtotal ()
 *
 *******************************************************************/
static void
fm_cust_pol_build_subtotal(
	pin_flist_t		*os_flistp,
	int32			j_level,
	pin_decimal_t		*tax_amt,
	pin_decimal_t		*tax_rate,
	pin_decimal_t		*amt_taxed,
	pin_decimal_t		*amt_exempt,
	pin_decimal_t		*amt_gross,
	char			*name,
	char			*descr,
	int32			loc_mode,
	int32			precision,
	int32			round_mode,
	pin_errbuf_t		*ebufp)
{
	int32		subtype = PIN_RATE_TAX_TYPE_SALES;

	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/* fill in the subtotal array */
	PIN_FLIST_FLD_SET(os_flistp, PIN_FLD_TYPE, (void*)&j_level,ebufp);
	PIN_FLIST_FLD_SET(os_flistp, PIN_FLD_NAME, (void*)name, ebufp);
	PIN_FLIST_FLD_PUT(os_flistp, PIN_FLD_AMOUNT_GROSS,
		(void*)pbo_decimal_round(amt_gross,
		 (int32)precision,round_mode,ebufp), ebufp);
	PIN_FLIST_FLD_PUT(os_flistp, PIN_FLD_TAX,
		(void*)pbo_decimal_round(tax_amt,
	 	(int32)precision,round_mode,ebufp), ebufp);
	PIN_FLIST_FLD_PUT(os_flistp, PIN_FLD_PERCENT,
		(void*)pbo_decimal_round(tax_rate, 
		(int32)RatePrecision, round_mode,ebufp), ebufp);
	PIN_FLIST_FLD_PUT(os_flistp, PIN_FLD_AMOUNT_TAXED,
		(void*)pbo_decimal_round(amt_taxed, 
	        (int32)precision,round_mode,ebufp ), ebufp);
	PIN_FLIST_FLD_PUT(os_flistp, PIN_FLD_AMOUNT_EXEMPT,
		(void*)pbo_decimal_round(amt_exempt, 
		(int32)precision,round_mode,ebufp), ebufp);
	PIN_FLIST_FLD_SET(os_flistp, PIN_FLD_SUBTYPE, (void*)&subtype, ebufp);
	PIN_FLIST_FLD_SET(os_flistp, PIN_FLD_DESCR, (void*)descr, ebufp);
	PIN_FLIST_FLD_SET(os_flistp, PIN_FLD_LOCATION_MODE,
		(void*)&loc_mode, ebufp);

	return;
}


/*******************************************************************
 * fm_cust_pol_do_juris_only ()
 *
 *******************************************************************/
static void
fm_cust_pol_do_juris_only(
	pin_flist_t		*in_flistp,
	pin_flist_t		**out_flistpp,
	pin_errbuf_t		*ebufp)
{
	int32		result = 1;

	/* no address validation. just return PASSED */
	PIN_FLIST_FLD_SET(*out_flistpp, PIN_FLD_RESULT, (void *)&result, ebufp);

	return;
}


/*******************************************************************
 * fm_cust_pol_get_amt_exempt ()
 *
 *******************************************************************/
static pin_decimal_t *
fm_cust_pol_get_amt_exempt(
	pin_flist_t		*in_flistp,
	int32			j_level,
	pin_decimal_t		*g_amt,
	pin_errbuf_t		*ebufp)
{
	pin_flist_t	*flistp = NULL;
	pin_cookie_t	cookie = NULL;
	int32		elemid = 0;
	pin_decimal_t	*rate =NULL; 
	void		*vp = NULL;

	/* Walk the EXEMPTIONS looking for matching jurisdiction level */
	while ((flistp = PIN_FLIST_ELEM_GET_NEXT(in_flistp, PIN_FLD_EXEMPTIONS,
		&elemid, 1, &cookie, ebufp)) != (pin_flist_t*)NULL) {

		vp = PIN_FLIST_FLD_GET(flistp, PIN_FLD_TYPE, 0, ebufp);
		if (vp && (j_level == *(int32*)vp)) {
			/* Match found */
			rate = (pin_decimal_t*)PIN_FLIST_FLD_GET(flistp,
				PIN_FLD_PERCENT, 0, ebufp);
			return pbo_decimal_multiply(g_amt, rate, ebufp); 
			/*****/
		}
	}

	return pbo_decimal_from_str("0.0",ebufp);
}


/*******************************************************************
 * fm_cust_pol_parse_tax_locale()
 *
 *******************************************************************/
static void
fm_cust_pol_parse_tax_locale(
	char		*locale,
	char		*city,
	char		*state,
	char		*zip,
	char		*country,
	char		*code)
{
	char	*p = NULL;
	char	delim = ';';

	/* format = "city; state; zip; country"  */
	if (locale != (char*)NULL) {
		p = locale;
		fm_utils_tax_parse_fld(&p, city, delim);
		fm_utils_tax_parse_fld(&p, state, delim);
		fm_utils_tax_parse_fld(&p, zip, delim);
		fm_utils_tax_parse_fld(&p, country, delim);
		fm_utils_tax_parse_fld(&p, code, delim);

		/* get rid of any "-" in Zip+4 code */
		p = (char*)strchr(zip, '-');
		while (p && (*p != '\0')) {
			*p = *(p + 1);
			p++;
		}
	}

	/* get rid of square brackets */
	if (code[0] == '[') {
		p = code;
		while ((*(p+1) != ']') && (*(p+1) != ',')) {
			*p = *(p+1);
			p++;
		}
		*p = '\0';
	}

	return;
}

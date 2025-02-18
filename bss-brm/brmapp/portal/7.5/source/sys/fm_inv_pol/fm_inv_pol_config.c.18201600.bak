/*******************************************************************
 *
 *      Copyright (c) 1999-2006 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static  char    Sccs_id[] = "@(#)%Portal Version: fm_inv_pol_config.c:BillingVelocityInt:2:2006-Sep-05 04:29:30 %";
#endif

#include <stdio.h>	/* for FILE * in pcm.h */
#include "ops/inv.h"
#include "pcm.h"
#include "cm_fm.h"


#ifdef WIN32
__declspec(dllexport) void * fm_inv_pol_config_func();
#endif


/*******************************************************************
 *******************************************************************/
struct cm_fm_config fm_inv_pol_config[] = {
	/* opcode as a u_int, function name (as a string) */
	{ PCM_OP_INV_POL_PREP_INVOICE,
				"op_inv_pol_prep_invoice" },
	{ PCM_OP_INV_POL_FORMAT_INVOICE,
				"op_inv_pol_format_invoice" },
	{ PCM_OP_INV_POL_FORMAT_VIEW_INVOICE,
				"op_inv_pol_format_view_invoice" },
	{ PCM_OP_INV_POL_FORMAT_INVOICE_HTML,
				"op_inv_pol_format_invoice_html" },
	{ PCM_OP_INV_POL_FORMAT_INVOICE_DOC1,
				"op_inv_pol_format_invoice_doc1" },
	{ PCM_OP_INV_POL_FORMAT_INVOICE_XML,
				"op_inv_pol_format_invoice_xml" },
	{ PCM_OP_INV_POL_FORMAT_INVOICE_XSLT,
				"op_inv_pol_format_invoice_xslt" },
	{ PCM_OP_INV_POL_SELECT,
				"op_inv_pol_select" },
	{ PCM_OP_INV_POL_POST_MAKE_INVOICE,
				"op_inv_pol_post_make_invoice" },
	{ 0,(char *)0 }
};

#ifdef WIN32
void *
fm_inv_pol_config_func()
{
	return ((void *) (fm_inv_pol_config));
}
#endif

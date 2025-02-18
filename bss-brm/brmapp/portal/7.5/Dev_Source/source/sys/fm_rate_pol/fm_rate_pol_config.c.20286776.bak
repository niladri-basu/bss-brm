/* continuus file information --- %full_filespec: fm_rate_pol_config.c~7.1.3:csrc:1 % */
/*******************************************************************
 *
 *  @(#) %full_filespec: fm_rate_pol_config.c~7.1.3:csrc:1 %
 *
 *      Copyright (c) 1999 - 2006 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its subsidiaries or licensors and may be used, reproduced, stored
 *      or transmitted only in accordance with a valid Oracle license or
 *      sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static  char    Sccs_id[] = "@(#)%Portal Version: fm_rate_pol_config.c:ServerIDCVelocityInt:2:2006-Sep-06 16:41:23 %";
#endif

#include <stdio.h>	/* for FILE * in pcm.h */
#include "ops/rate.h"
#include "pcm.h"
#include "cm_fm.h"

#ifdef MSDOS
__declspec(dllexport) void * fm_rate_pol_config_func();
#endif

/*******************************************************************
 *******************************************************************/
struct cm_fm_config fm_rate_pol_config[] = {
	/* opcode as a u_int, function name (as a string) */
	{ PCM_OP_RATE_POL_TAX_LOC,		"op_rate_pol_tax_loc" },
	{ PCM_OP_RATE_POL_POST_RATING,		"op_rate_pol_post_rating" },
	{ PCM_OP_RATE_POL_GET_TAX_SUPPLIER,	"op_rate_pol_get_tax_supplier"},
	{ PCM_OP_RATE_POL_MAP_TAX_SUPPLIER,	"op_rate_pol_map_tax_supplier"},
	{ PCM_OP_RATE_POL_PRE_TAX,		"op_rate_pol_pre_tax"},
	{ PCM_OP_RATE_POL_POST_TAX,		"op_rate_pol_post_tax"},
	{ PCM_OP_RATE_POL_GET_TAXCODE,		"op_rate_pol_get_taxcode"},
	{ PCM_OP_RATE_POL_EVENT_ZONEMAP,	"op_rate_pol_event_zonemap"},
	{ PCM_OP_RATE_POL_PRE_RATING,		"op_rate_pol_pre_rating"},
	{ PCM_OP_RATE_POL_PROCESS_ERAS,		"op_rate_pol_process_eras"},
	{ 0,	(char *)0 }
};

#ifdef MSDOS
void *
fm_rate_pol_config_func()
{
  return ((void *) (fm_rate_pol_config));
}
#endif


/*
 *
* Copyright (c) 2001, 2014, Oracle and/or its affiliates. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef lint
static const char Sccs_id[] = "@(#)$Id: fm_reserve_pol_custom_config.c /cgbubrm_7.5.0.rwsmod/1 2014/12/17 10:41:47 vivilin Exp $";
#endif

#include <stdio.h>	/* for FILE * in pcm.h */
#include "ops/reserve.h"
#include "pcm.h"
#include "cm_fm.h"


#ifdef MSDOS
__declspec(dllexport) void * fm_reserve_pol_custom_config_func();
#endif


/*******************************************************************
 *******************************************************************/
struct cm_fm_config fm_reserve_pol_custom_config[] = {
	/* opcode as a u_int, function name (as a string) */
/*    
	{ PCM_OP_RESERVE_POL_PREP_CREATE,	"op_reserve_pol_prep_create"},
	{ PCM_OP_RESERVE_POL_PREP_EXTEND,	"op_reserve_pol_prep_extend"},
	{ PCM_OP_RESERVE_POL_PRE_RELEASE,	"op_reserve_pol_pre_release"},
	{ PCM_OP_RESERVE_POL_POST_DISPUTE,	"op_reserve_pol_post_dispute"},
	{ PCM_OP_RESERVE_POL_POST_SETTLEMENT,	"op_reserve_pol_post_settlement"},
*/    
	{ 0,	(char *)0 }
};

#ifdef MSDOS
void *
fm_reserve_pol_custom_config_func()
{
  return ((void *) (fm_reserve_pol_custom_config));
}
#endif


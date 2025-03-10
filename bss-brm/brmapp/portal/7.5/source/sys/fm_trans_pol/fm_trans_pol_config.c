/*******************************************************************
 *
* Copyright (c) 1999, 2014, Oracle and/or its affiliates. All rights reserved.
 *
 * This material is the confidential property of Oracle Corporation. or its
 * subsidiaries or licensors and may be used, reproduced, stored or transmitted
 * only in accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: fm_trans_pol_custom_config.c /cgbubrm_7.5.0.rwsmod/1 2014/12/17 10:41:47 vivilin Exp $";
#endif

#include <stdio.h>	/* for FILE * in pcm.h */
#include "ops/base.h"
#include "pcm.h"
#include "cm_fm.h"

#ifdef MSDOS
__declspec(dllexport) void * fm_trans_pol_custom_config_func();
#endif

/*******************************************************************
 * Opcodes handled by this FM.
 *******************************************************************/
struct cm_fm_config fm_trans_pol_custom_config[] = {
	/* opcode as a u_int, function name (as a string) */
/*    
	{ PCM_OP_TRANS_POL_OPEN,		"op_trans_pol_open" },
	{ PCM_OP_TRANS_POL_PREP_COMMIT,		"op_trans_pol_prep_commit" },
	{ PCM_OP_TRANS_POL_COMMIT,		"op_trans_pol_commit" },
	{ PCM_OP_TRANS_POL_ABORT,		"op_trans_pol_abort" },
*/    
	{ 0,	(char *)0 }
};

#ifdef MSDOS
void *
fm_trans_pol_custom_config_func()
{
  return ((void *) (fm_trans_pol_custom_config));
}
#endif


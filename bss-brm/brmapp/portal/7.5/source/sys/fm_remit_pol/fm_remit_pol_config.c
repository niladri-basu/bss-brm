/*
* Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: fm_remit_pol_custom_config.c /cgbubrm_7.5.0.rwsmod/1 2014/12/17 10:41:46 vivilin Exp $";
#endif

#include <stdio.h>	/* for FILE * in pcm.h */
#include "ops/remit.h"
#include "pcm.h"
#include "cm_fm.h"

#define FILE_LOGNAME "fm_remit_pol_custom_config.c(1)"

#ifdef MSDOS
__declspec(dllexport) void * fm_remit_pol_custom_config_func();
#endif


/*******************************************************************
 *******************************************************************/
struct cm_fm_config fm_remit_pol_custom_config[] = {
	/* opcode as a int, function name (as a string) */
/*    
	{ PCM_OP_REMIT_POL_SPEC_QTY, "op_remit_pol_spec_qty" },
*/    
	{ 0,	(char *)0 }
};

#ifdef MSDOS
void *
fm_remit_pol_custom_config_func()
{
  return ((void *) (fm_remit_pol_custom_config));
}
#endif


/* Continuus file information --- %full_filespec: fm_remit_pol_config.c~2:csrc:1 % */
/*
 * @(#) %full_filespec: fm_remit_pol_config.c~2:csrc:1 %
 *
 *      Copyright (c) 2000 - 2006 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef lint
static  char    Sccs_id[] = "@(#) %full_filespec: fm_remit_pol_config.c~2:csrc:1 %";
#endif

#include <stdio.h>	/* for FILE * in pcm.h */
#include "ops/remit.h"
#include "pcm.h"
#include "cm_fm.h"

#define FILE_LOGNAME "fm_remit_pol_config.c(1)"

#ifdef MSDOS
__declspec(dllexport) void * fm_remit_pol_config_func();
#endif


/*******************************************************************
 *******************************************************************/
struct cm_fm_config fm_remit_pol_config[] = {
	/* opcode as a int, function name (as a string) */
	{ PCM_OP_REMIT_POL_SPEC_QTY, "op_remit_pol_spec_qty" },
	{ 0,	(char *)0 }
};

#ifdef MSDOS
void *
fm_remit_pol_config_func()
{
  return ((void *) (fm_remit_pol_config));
}
#endif


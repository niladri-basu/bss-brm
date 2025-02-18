/*
 *
* Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: fm_gl_pol_custom_config.c /cgbubrm_7.3.2.rwsmod/1 2010/05/06 14:49:35 mnarasim Exp $";
#endif

#include <stdio.h>	/* for FILE * in pcm.h */
#include "ops/bill.h"
#include "pcm.h"
#include "cm_fm.h"

#ifdef WIN32
__declspec(dllexport) void * fm_gl_pol_custom_config_func();
#endif


/********************************************************************
 * If you want to customize any of the op-codes commented below, you 
 * need to uncomment it. 
 *
 *******************************************************************/
struct cm_fm_config fm_gl_pol_custom_config[] = {
	/* opcode as a u_int, function name (as a string) */
/*	 { PCM_OP_GL_POL_EXPORT_GL,		
		(char *)"op_gl_pol_export_gl" }, */
/*	 { PCM_OP_GL_POL_PRE_UPDATE_JOURNAL,		
		(char *)"op_gl_pol_pre_update_journal" }, */
	{ 0,	(char *)0 }
};

#ifdef WIN32
void *
fm_gl_pol_custom_config_func()
{
  return ((void *) (fm_gl_pol_custom_config));
}
#endif

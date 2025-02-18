/*
 *
* Copyright (c) 2007, 2011, Oracle and/or its affiliates. All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: fm_ar_pol_custom_config.c /cgbubrm_7.3.2.rwsmod/1 2011/01/06 06:16:02 shibvarg Exp $";
#endif

#include <stdio.h>      /* for FILE * in pcm.h */
#include "ops/ar.h"
#include "pcm.h"
#include "cm_fm.h"

#ifdef WIN32
__declspec(dllexport) void * fm_ar_pol_custom_config_func();
#endif


/********************************************************************
 * If you want to customize any of the op-codes commented below, you
 * need to uncomment it.
 *
 *******************************************************************/
struct cm_fm_config fm_ar_pol_custom_config[] = {
	/* opcode as a u_int, function name (as a string) */
/*        { PCM_OP_AR_POL_REVERSE_WRITEOFF,               "op_ar_pol_reverse_writeoff" },		*/
/*        { PCM_OP_AR_POL_GET_EVENT_RUM_CHARGE_DETAIL,    "op_ar_pol_get_event_rum_charge_detail"},	*/
/*        { PCM_OP_AR_POL_PRE_EVENT_ADJUSTMENT,           "op_ar_pol_pre_event_adjustment"},		*/
        { 0,    (char *)0 }
};

#ifdef WIN32
void *
fm_ar_pol_custom_config_func()
{
  return ((void *) (fm_ar_pol_custom_config));
}
#endif


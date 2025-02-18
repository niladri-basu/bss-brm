/*
 *
 *      Copyright (c) 2005 - 2006 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef lint
static  char    Sccs_id[] = "@(#)%Portal Version: fm_bal_pol_config.c:BillingVelocityInt:3:2006-Sep-05 21:51:54 % ";
#endif

#include <stdio.h>      /* for FILE * in pcm.h */
#include "ops/bal.h"
#include "pcm.h"
#include "cm_fm.h"

#ifdef MSDOS
__declspec(dllexport) void * fm_bal_pol_config_func();
#endif

struct cm_fm_config fm_bal_pol_config[] = {
        /* opcode as a u_int, function name (as a string) */
        { PCM_OP_BAL_POL_GET_BAL_GRP_AND_SVC, "op_bal_pol_get_bal_grp_and_svc" },
        { 0,    (char *)0 }
};

#ifdef MSDOS 
void *
fm_bal_pol_config_func()
{
  return ((void *) (fm_bal_pol_config));
}
#endif

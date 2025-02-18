/*
* Copyright (c) 2003, 2014, Oracle and/or its affiliates. All rights reserved.
 *      This material is the confidential property of Oracle Corporation 
 *      or its subsidiaries or licensors and may be used, reproduced, stored
 *      or transmitted only in accordance with a valid Oracle license or 
 *      sublicense agreement.
 */

#ifndef lint
static const char Sccs_id[] = "@(#)$Id: fm_process_audit_pol_custom_config.c /cgbubrm_7.5.0.portalbase/1 2014/12/17 11:11:56 vivilin Exp $";
#endif

#include <stdio.h>
#include <string.h>

#include <pcm.h>
#include <pinlog.h>

#include "cm_fm.h"
#include "ops/process_audit.h"

#define FILE_LOGNAME "fm_process_audit_pol_custom_config.c(1)"

#ifdef MSDOS
__declspec(dllexport) void * fm_process_audit_pol_custom_config_func();
#endif


/*******************************************************************
 *******************************************************************/
struct cm_fm_config fm_process_audit_pol_custom_config[] = {
	/* opcode as a int32, function name (as a string) */
/*    
	{ PCM_OP_PROCESS_AUDIT_POL_CREATE, "op_process_audit_pol_create" },
	{ PCM_OP_PROCESS_AUDIT_POL_CREATE_AND_LINK, "op_process_audit_pol_create_and_link" },
	{ PCM_OP_PROCESS_AUDIT_POL_ALERT, "op_process_audit_pol_alert" },
	{ PCM_OP_PROCESS_AUDIT_POL_CREATE_WRITEOFF_SUMMARY, "op_process_audit_pol_create_writeoff_summary" },
*/    
	{ 0,	(char *)0 }
};

#ifdef MSDOS
void *
fm_process_audit_pol_custom_config_func()
{
  return ((void *) (fm_process_audit_pol_custom_config));
}
#endif

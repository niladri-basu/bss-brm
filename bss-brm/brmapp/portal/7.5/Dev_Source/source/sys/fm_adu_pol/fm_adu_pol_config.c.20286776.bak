/******************************************************************************
 *
 *      Copyright (c) 2007 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 ******************************************************************************/

#include "pcm.h"
#include "cm_fm.h"
#include "ops/cust.h"

PIN_EXPORT void * fm_adu_pol_config_func();

struct cm_fm_config fm_adu_pol_config[] = {
	/* opcode as a u_int, function name (as a string) */
	{ PCM_OP_ADU_POL_DUMP, "op_adu_pol_dump", CM_FM_OP_OVERRIDABLE },
	{ PCM_OP_ADU_POL_VALIDATE, "op_adu_pol_validate", CM_FM_OP_OVERRIDABLE },
	{ 0,	(char *)0 }
};

void *
fm_adu_pol_config_func() {
	return ((void *) (fm_adu_pol_config));
}


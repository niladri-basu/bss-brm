/*	
 *	@(#)%Portal Version: dm_opstore.h:CommonIncludeInt:1:2006-Sep-11 05:26:10 %
 *	
 *	Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *	
 *	This material is the confidential property of Oracle Corporation or its
 *	licensors and may be used, reproduced, stored or transmitted only in
 *	accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _PCM_DM_OPSTORE_OPS_H_
#define _PCM_DM_OPSTORE_OPS_H_

/*
 * This file contains the opcode definitions for the DM Opstore PCM API.
 */

/* 
   NAME: TOTAL RANGE; USED RANGE; RESERVED RANGE; ASSOCIATED FM (if any)
   =====================================================================
   PCM_DM_OPSTORE_OPS: 1131..1150; 1131..1131; 1132..1150; None
 */

#include "ops/base.h"

	/* opcodes for dm opstore */
#define PCM_OP_ALDM_REPLAY_LOGS			1131
	/* reserved - 1132 - 1150 */

#endif /* _PCM_DM_OPSTORE_OPS_H_ */

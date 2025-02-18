/*	
 *	@(#)%Portal Version: publish.h:CommonIncludeInt:1:2006-Sep-11 05:26:42 %
 *	
 *	Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *	
 *	This material is the confidential property of Oracle Corporation or its
 *	licensors and may be used, reproduced, stored or transmitted only in
 *	accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _PCM_PUBLISH_OPS_H_
#define _PCM_PUBLISH_OPS_H_

/*
 * This file contains the opcode definitions for the Publish PCM API.
 */

/* 
   NAME: TOTAL RANGE; USED RANGE; RESERVED RANGE; ASSOCIATED FM (if any)
   =====================================================================
   PCM_PUBLISH_OPS: 1300..1309; 1300..1301; 1302..1309; fm_publish
 */

#include "ops/base.h"

#define PCM_OP_PUBLISH_EVENT 1300
#define PCM_OP_PUBLISH_GEN_PAYLOAD 1301
        /* Reserved - 1309 */

#endif /* _PCM_PUBLISH_OPS_H_ */


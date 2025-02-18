/*	
 *	@(#)%Portal Version: reserve.h:CommonIncludeInt:3:2006-Sep-11 05:25:40 %
 *	
 *	Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *	
 *	This material is the confidential property of Oracle Corporation or its
 *	licensors and may be used, reproduced, stored or transmitted only in
 *	accordance with a valid Oracle license or sublicense agreement.
 */

/*
 * This file contains the opcode definitions for the RESERVE PCM API.
 */

/* 
   NAME: TOTAL RANGE; USED RANGE; RESERVED RANGE; ASSOCIATED FM (if any)
   =====================================================================
   PCM_RESERVE_OPS:     2300..2350;  2300..2305;  2306..2350; fm_reserve
   PCM_RESERVE_POL_OPS: 2351..2399; 2351..2353; 2354..2399; fm_reserve_pol
 */

#ifndef _PCM_RESERVE_OPS_H_
#define _PCM_RESERVE_OPS_H_

	/* opcodes for Reservation */
#define PCM_OP_RESERVE_CREATE			2300
#define PCM_OP_RESERVE_ASSOCIATE		2301
#define PCM_OP_RESERVE_EXTEND			2302
#define PCM_OP_RESERVE_RELEASE			2303
#define PCM_OP_RESERVE_FIND_OBJ			2304
#define PCM_OP_RESERVE_RENEW			2305

	/* reserve 2306	to 2350 */

#define PCM_OP_RESERVE_POL_PREP_CREATE		2351
#define PCM_OP_RESERVE_POL_PREP_EXTEND		2352
#define PCM_OP_RESERVE_POL_PRE_RELEASE		2353
#define PCM_OP_RESERVE_POL_POST_SETTLEMENT	2354
#define PCM_OP_RESERVE_POL_POST_DISPUTE		2355
        /* reserved through 2399 */

#endif

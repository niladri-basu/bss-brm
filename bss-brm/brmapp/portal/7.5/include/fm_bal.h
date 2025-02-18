/*
 *
 * Copyright (c) 2003, 2008, Oracle and/or its affiliates.All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef _FM_BAL_H
#define	_FM_BAL_H


/*******************************************************************
@(#)%Portal Version: fm_bal.h:PortalBase7.2PatchInt:1:2005-Dec-05%
 *******************************************************************/

/*******************************************************************
 * BAL Definitions.
 *
 * All values defined here are embedded in the database
 * and therefore *cannot* change!
 *******************************************************************/

/*
 * PCM_OP_BAL values.
 */
#define	PIN_BAL_GET_ACCT_AND_SVC	0x02
#define	PIN_BAL_GET_BARE_RESULTS	0x01
/* get all the sub-balances regardless of time */
#define	PIN_BAL_GET_ALL_BARE_RESULTS	0x04
/* default is not to optimize */
#define	PIN_BAL_TO_OPTIMIZE	0x08
/* get the sub-balances based on a period instead of a timepoint */
#define PIN_BAL_GET_BASED_ON_PERIOD 0x10
/* get the sub-balances exist within the period */
#define PIN_BAL_GET_WITHIN_PERIOD 0x80
/* get the balance group poid only */
#define PIN_BAL_GET_POID_ONLY 0x20
/* cache the initial results -- internal only*/
#define PIN_BAL_CACHE_RESULTS 0x40

#define PIN_BAL_SORT_USE_VALID_FROM 0x0
#define PIN_BAL_SORT_USE_VALID_TO   0x1
/* two more options for sub-balance consumption order */
#define PIN_BAL_SORT_USE_NEWEST_VALID_FROM 0x2
#define PIN_BAL_SORT_USE_NEWEST_VALID_TO   0x3

#define PIN_BAL_USE_START_T 0x0
#define PIN_BAL_USE_END_T 0x1

#define PIN_BAL_TODAYS_BITS 0x7FFF0000

#define STAR_CONTRIB_STR  "*"
#define DEF_CONTRIB_BIT         0x02
#define NO_MATCH_BIT            0x04

/* PIN_FLD_FLAGS for PCM_OP_BAL_GET_BAL_GRP_AND_SVC */
#define PIN_BAL_GET_SERVICE_DEFAULT		0
#define PIN_BAL_GET_SERVICE_LOGIN		1
#define PIN_BAL_GET_SERVICE_TRANSFER_LIST	2
#define PIN_BAL_GET_DEFAULT_BAL_GRP		3
#define PIN_BAL_GET_DEFAULT_BAL_GRP_AND_SVC	4
#define PIN_BAL_GET_ALL_BAL_GRP_AND_SVC         5

#endif	/*_FM_BAL_H*/

/* Copyright (c) 2014, Oracle and/or its affiliates. All rights reserved.*/
 
/* 
   NAME 
     ece.h

   DESCRIPTION 
     This file contains the opcode declarations for ECE.

   NOTES
     Call to these opcodes will be redirected to ECE via
     EM Gateway.

   MODIFIED   (MM/DD/YY)
   kpramod     05/26/14 - Creation

*/

#ifndef _PCM_ECE_OPS_H_
#define _PCM_ECE_OPS_H_

/*
   NAME:            TOTAL RANGE; USED RANGE; RESERVED RANGE; ASSOCIATED FM (if any)
   ================================================================================
   PCM_ECE_OPS:      1281..1299; 1281..1281;     1282..1299;
 */

#include "ops/base.h"

/* Opcodes for ece */
#define PCM_OP_BAL_GET_ECE_BALANCES  1281

#endif                                              /* _PCM_ECE_OPS_H_ */

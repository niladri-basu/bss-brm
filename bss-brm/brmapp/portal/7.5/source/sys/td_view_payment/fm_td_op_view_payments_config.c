#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: fm_td_op_view_payments_config.c 3907 2013-08-11 09:36:25Z jdenoud $";
#endif

#include <stdio.h>
#include "pcm.h"
#include "cm_fm.h"
#include "pin_cust.h"
#include "custom_opcodes.h"



struct cm_fm_config fm_td_op_view_payments_config[] = {
        /* opcode as a u_int, function name (as a string) */
        { TD_OP_AR_VIEW_PAYMENTS,"op_td_view_payments"},
    	{ TD_OP_AR_VIEW_ADJUSMENTS,"op_td_view_adjustments"},
        { 0,    (char *)0 }
};

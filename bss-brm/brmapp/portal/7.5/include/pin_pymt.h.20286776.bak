/* file information --- @(#)$Id: pin_pymt.h /cgbubrm_7.3.2.rwsmod/2 2009/01/14 23:11:27 agangwar Exp $ */
/*
 *
 * Copyright (c) 2004, 2009, Oracle and/or its affiliates.All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef _PIN_PYMT_H
#define	_PIN_PYMT_H

/*******************************************************************
 * Payment FM Definitions.
 *******************************************************************/

/*******************************************************************
 * pin.conf related.
 *******************************************************************/
#define FM_PYMT_POL			"fm_pymt_pol"
#define FM_CC_VALIDATE_TOKEN		"cc_validate"
#define FM_CC_COLLECT_TOKEN		"cc_collect"
#define FM_CC_REVALIDATE_TOKEN		"cc_revalidation_interval"
#define FM_CC_VALIDATE_FLAG_DEFAULT	1
#define FM_CC_COLLECT_FLAG_DEFAULT	1
#define FM_CC_REVALIDATE_DEFAULT	3600

#define FM_DD_VALIDATE_TOKEN		"dd_validate"
#define FM_DD_COLLECT_TOKEN		"dd_collect"
#define FM_DD_REVALIDATE_TOKEN		"dd_revalidation_interval"
#define FM_DD_VALIDATE_FLAG_DEFAULT	1
#define FM_DD_COLLECT_FLAG_DEFAULT	1
#define FM_DD_REVALIDATE_DEFAULT	3600

/*******************************************************************
 * PCM_OP_BILL_CHARGE Fields.
 *******************************************************************/
/*
 * PIN_FLD_CMD - Online bank operation run.
 */
typedef enum pin_charge_cmd {
	PIN_CHARGE_CMD_NONE =		0,
	PIN_CHARGE_CMD_VERIFY =		1,
	PIN_CHARGE_CMD_AUTH_ONLY =	2,
	PIN_CHARGE_CMD_AUTHORIZE =	3,	/* No Longer Supported */
	PIN_CHARGE_CMD_CONDITION =	4,
	PIN_CHARGE_CMD_DEPOSIT =	5,
	PIN_CHARGE_CMD_REFUND =		6,
	PIN_CHARGE_CMD_RFR =		7,
	PIN_CHARGE_CMD_RESUBMIT =	8,
	PIN_CHARGE_CMD_RECOVER_PAYMENT = 9,
	PIN_CHARGE_CMD_GET_DEPOSIT_RES = 11
} pin_charge_cmd_t;

/*
 * PIN_FLD_RESULT - Result of an online bank operation.
 */
typedef enum pin_charge_result {
	PIN_CHARGE_RES_PASS =		0,
	PIN_CHARGE_RES_FAIL_NO_ANS =	1,
	PIN_CHARGE_RES_FAIL_ADDR_AVS =	2,
	PIN_CHARGE_RES_FAIL_ADDR_LOC =	3,
	PIN_CHARGE_RES_FAIL_ADDR_ZIP =	4,
	PIN_CHARGE_RES_FAIL_CARD_BAD =	5,
	PIN_CHARGE_RES_SRVC_UNAVAIL =	6,
	PIN_CHARGE_RES_FAIL_DECL_SOFT =	7,
	PIN_CHARGE_RES_FAIL_DECL_HARD =	8,
	PIN_CHARGE_RES_FAIL_NO_MIN =	9,
	PIN_CHARGE_RES_INVALID_CMD =	10,
	PIN_CHARGE_RES_FAIL_SELECT_ITEMS = 11,
	PIN_CHARGE_RES_CVV_BAD  = 12,
	PIN_CHARGE_RES_NO_CREDIT_BALANCE      = 13,
	PIN_CHARGE_RES_FAIL_LOGICAL_PROBLEM   = 14,
	PIN_CHARGE_RES_FAIL_FORMAT_ERROR      = 15,
	PIN_CHARGE_RES_FAIL_INVALID_CONTENT   = 16,
	PIN_CHARGE_RES_FAIL_TECHNICAL_PROBLEM = 17,
	PIN_CHARGE_RES_DEPOSIT_PENDING = 777, 
	PIN_CHARGE_RES_AUTH_PENDING = 888,
	PIN_CHARGE_RES_CHECKPOINT = 	999,
	PIN_CHARGE_RES_OFFSET = 1000
} pin_charge_result_t;

/*
 * PIN_FLD_SELECT_RESULT - Result of the select items.
 */
#define	PIN_SELECT_RESULT_PASS		0
#define	PIN_SELECT_RESULT_FAIL		1

/*
 * PIN_FLD_PAYMENT_RESULT - Result of the payment.
 */
#define	PIN_PAYMENT_RES_PASS		0
#define	PIN_PAYMENT_RES_FAIL		1

/*
 * PIN_PAYMENT_BATCH_FLAGS - Payment batch flags.
 * the flags are implemented as bitmask
 */
/*Means checkpoints were searched for this batch*/
#define PIN_PAYMENT_BATCH_CHKPTS	0x1

/*
 * PIN_FLD_SELECT_STATUS - Status of select items
 */
#define	PIN_SELECT_STATUS_EXACT_MATCH		0x1
#define	PIN_SELECT_STATUS_UNDER_PAYMENT		0x2
#define	PIN_SELECT_STATUS_OVER_PAYMENT		0x4
#define	PIN_SELECT_STATUS_MANUAL_ALLOC		0x8
#define	PIN_SELECT_STATUS_ALLOCATION_DEFERRED	0x10
#define PIN_SELECT_STATUS_MBI_DISTRIBUTED       0x20

/*
 * PCM_OP_PYMT_ITEM_SEARCH - PIN_FLD_RESULT_FORMAT values.
 */
#define	PIN_ITEM_SEARCH_FORMAT_ITEMS	0
#define	PIN_ITEM_SEARCH_FORMAT_BILLS	1

/*
 * PCM_OP_PYMT_ITEM_SEARCH - PIN_FLD_SEARCH_TYPE values.
 */
#define	PIN_ITEM_SEARCH_TYPE_ACCOUNT	0
#define	PIN_ITEM_SEARCH_TYPE_HIERARCHY	1
#define PIN_ITEM_SEARCH_TYPE_INVOICE	2

/*
 * PIN_FLD_CHANNEL_ID -Default value for Payment Channel Id
 */
#define PIN_PAYMENT_DEFAULT_CHANNEL_ID	0

/*******************************************************************
 * Modular Payment opcode node structure for sorting input flists by
 * opcode.
 *******************************************************************/
typedef struct fm_pymt_op_node {
        u_int           opcode;         /* Opcode called        */
        pin_flist_t     *i_flistp;      /* Input flist          */
        pin_flist_t     *r_flistp;      /* Result flist         */
        struct  fm_pymt_op_node *next; 	/* Next node in list    */
} fm_pymt_op_node_t;

/*
 * PIN_FLD_PAY_TYPE
 *
 * If new values are added, they should be added to the
 * PCM_OP_CUST_POL_VALID_PAYINFO op as well.
 *
 */
typedef enum pin_pay_type {
	PIN_PAY_TYPE_UNDEFINED 	 =     0,	/* invalid - used during acct create */
	PIN_PAY_TYPE_PREPAID 	 = 10000,	/* prepaid to keep negative balance */
	PIN_PAY_TYPE_INVOICE 	 = 10001,	/* invoiced monthly */
	PIN_PAY_TYPE_DEBIT 	 = 10002,	/* checking account debit */
	PIN_PAY_TYPE_CC 	 = 10003,	/* Credit Card */
	PIN_PAY_TYPE_DDEBIT 	 = 10004,	/* French Direct Debit */
	PIN_PAY_TYPE_DD 	 = 10005,  	/* US/Canadian Direct Debit */ 
	PIN_PAY_TYPE_SMARTC 	 = 10006,	/* Smartcard */
	PIN_PAY_TYPE_SUBORD 	 = 10007,	/* roll up to parent account */
	PIN_PAY_TYPE_CASH  	 = 10011,	/* cash payments for payment tool */
	PIN_PAY_TYPE_CHECK  	 = 10012,	/* check payments for payment tool */
	PIN_PAY_TYPE_WTRANSFER 	 = 10013,	/* wire transfer payments for payment tool */
	PIN_PAY_TYPE_PAYORDER 	 = 10014,	/* Inter bank payment order payments for payment tool */
	PIN_PAY_TYPE_POSTALORDER = 10015,	/* Postal order payments for payment tool */
	PIN_PAY_TYPE_VOUCHER 	 = 10016,	/* Voucher payments */
	PIN_PAY_TYPE_FAILED	 = 10017	/* Failed payment */
} pin_pay_type_t;

/************************************************************************
 * PCM_OP_PYMT_APPLY_FEE
************************************************************************/
#define PIN_APPLY_FEE_TRUE              	0 /* Apply payment fee */
#define PIN_APPLY_FEE_FALSE             	1 /* Do not apply payment fee*/
#define PIN_APPLY_FEE_EVENT_CREATED_TRUE 	0 /* Payment fee event created */
#define PIN_APPLY_FEE_EVENT_CREATED_FALSE 	1 /* Payment fee event not created */
#define PIN_OBJ_NAME_EVENT_FAILED_PAYMENT  	"Failed Payment Batch"
#define PIN_OBJ_EVENT_BILLING_FEE_FAILED_PAYMENT	"/event/billing/fee/failed_payment"

/************************************************************************
 * Payment Incentive feature
************************************************************************/
#define PIN_INCENTIVE_MANUAL_REVERSAL 	  0x1  /* Reverse Incentives manually */

#define PIN_OBJ_TYPE_EVENT_BILL_PAYMENT   "/event/billing/payment"
#define PIN_OBJ_TYPE_EVENT_BILL_INCENTIVE "/event/billing/incentive"
#define PIN_OBJ_NAME_EVENT_BILL_INCENTIVE "Incentive event"

/************************************************************************
 * Payment Result
 * This Enumeration is used to populate PIN_FLD_STATUS field. This enumeration
 * reflects the result of payment. Was the payment successful, did it fail
 * or if the payment is falling into suspense.
 * Value Range.
 * Succesful Payment: - 0 to 14
 * Suspense Payment: -  15 to 29
 * Failed Payment:- 	30 to 44
************************************************************************/
typedef enum pin_pymt_result {
	PIN_PYMT_SUCCESS				= 0,
		PIN_PYMT_WRITEOFF_SUCCESS		= 10,
	PIN_PYMT_SUSPENSE				= 15, 
		PIN_PYMT_FAILED_SUSPENSE 		= 16,
		PIN_PYMT_RECYCLED_SUSPENSE 		= 17,
		PIN_PYMT_FAILED_RECYCLED_SUSPENSE 	= 18,
		PIN_PYMT_RETURNED_SUSPENSE 		= 19,
	PIN_PYMT_FAILED					= 30,
	PIN_PYMT_STATUS_MAX				= 45
} pin_pymt_result_t;
	
/**********************************************************************
 * Payment Status Macros. These Macros are used to identify the status of the
 * payment. 
 **********************************************************************/
/*************************************
 * Check if it is a Successful payment
 *************************************/
 
#define IS_PYMT_SUCCESS(status)   \
		((((status >= PIN_PYMT_SUCCESS ) && (status < PIN_PYMT_SUSPENSE)) || (status >= PIN_PYMT_STATUS_MAX)) ?  \
		(1) : (0))

/**************************************
 * Check if payment is Suspended
 **************************************/
#define IS_PYMT_SUSPENSE(status)   \
		(((status >= PIN_PYMT_SUSPENSE) && (status < PIN_PYMT_FAILED)) ?  \
		(1) : (0))

/*************************************
 * Check if it is a Failed payment
 *************************************/
#define IS_PYMT_FAILED(status)   \
		(((status >= PIN_PYMT_FAILED) && (status < PIN_PYMT_STATUS_MAX)) ?  \
		(1) : (0))

/*******************************************************************
 * Response code from ACH
 ******************************************************************/
#define PIN_ACH_RESPONSE_APPROVED               "VC=100"
#define PIN_ACH_RESPONSE_INVALID_CRAD           "VC=201"
#define PIN_ACH_RESPONSE_BAD_AMOUNT             "VC=202"
#define PIN_ACH_RESPONSE_UNKONWN_ERROR          "VC=204"
#define PIN_ACH_RESPONSE_NETWORK_ERROR          "VC=301"
#define PIN_ACH_RESPONSE_INSUFFICIENT_FUNDS     "VC=302"
#define PIN_ACH_RESPONSE_DECLINE                "VC=303"
#define PIN_ACH_RESPONSE_CALL                   "VC=401"
#define PIN_ACH_RESPONSE_DEFAULT_CALL           "VC=402"
#define PIN_ACH_RESPONSE_PICKUP                 "VC=501"
#define PIN_ACH_RESPONSE_LOST                   "VC=502"
#define PIN_ACH_RESPONSE_EXPIERED_CARD          "VC=522"
#define PIN_ACH_RESPONSE_DO_NOT_HONOR           "VC=530"
#define PIN_ACH_RESPONSE_BAD_CARD               "VC=602"
#define PIN_ACH_RESPONSE_INVALID_EXPIRATION     "VC=605"
#define PIN_ACH_RESPONSE_INVALID_TRANSACTION_TYPE "VC=606"
#define PIN_ACH_RESPONSE_INVALID_AMOUNT         "VC=607"
#define PIN_ACH_RESPONSE_RESTRICTED_CARD        "VC=806"

/******************************************************************
 * Payment Suspense Management
 * First Name and Last Name Used for identifying the Suspense
 * Account
 ******************************************************************/
#define PIN_SUSPENSE_FNAME "PAYMENT"
#define PIN_SUSPENSE_LNAME "SUSPENSE"

/******************************************************************
 * Payment Suspense Management
 * Array Index for Payment Reasons Array PIN_FLD_PAYMENT_REASON 
 ******************************************************************/
#define PIN_PYMT_GLID_REASON_ID_INDEX		0
#define PIN_PYMT_USER_ACTION_REASON_ID_INDEX	1
#define PIN_PYMT_ORIG_REASON_ID_INDEX		2

/*******************************************************************
 * Payment Reason ID
 * Value Range for Payment Reason ID
 * Default Reason Code: - 0
 * Range for Successful: - 0 to 1000 
 * Range for Failed Payment: - 1001 to 2000
 * Range for Suspense: - 2001 to 3000
 * Range for User Action Id : - 3001 to 4000
 * Range for WriteOff Suspended Payment : - 4001 to 5000 
 * Reason ID from 0 to 100,000 are reserved for Portal defined 
 * Payment reason IDs.
 ******************************************************************/
#define PIN_REASON_ID_NONE                      0 /*to be removed */
#define PIN_REASON_ID_DEFAULT                   0
#define PIN_REASON_ID_APPROVED                  0
#define PIN_REASON_ID_INVALID_CARD              1001
#define PIN_REASON_ID_BAD_AMOUNT                1002
#define PIN_REASON_ID_UNKONWN_ERROR             1003
#define PIN_REASON_ID_NETWORK_ERROR             1004
#define PIN_REASON_ID_INSUFFICIENT_FUNDS        1005
#define PIN_REASON_ID_DECLINE                   1006
#define PIN_REASON_ID_CALL                      1007
#define PIN_REASON_ID_DEFAULT_CALL              1008
#define PIN_REASON_ID_PICKUP                    1009
#define PIN_REASON_ID_LOST                      1010
#define PIN_REASON_ID_EXPIERED_CARD             1011
#define PIN_REASON_ID_DO_NOT_HONOR              1012
#define PIN_REASON_ID_BAD_CARD                  1013
#define PIN_REASON_ID_INVALID_EXPIRATION        1014
#define PIN_REASON_ID_INVALID_TRANSACTION_TYPE  1015
#define PIN_REASON_ID_INVALID_AMOUNT            1016
#define PIN_REASON_ID_RESTRICTED_CARD           1017
#define PIN_REASON_ID_FAIL_NO_ANS               1018
#define PIN_REASON_ID_FAIL_ADDR_AVS             1019
#define PIN_REASON_ID_FAIL_ADDR_LOC             1020
#define PIN_REASON_ID_FAIL_ADDR_ZIP             1021
#define PIN_REASON_ID_FAIL_CARD_BAD             1022
#define PIN_REASON_ID_FAIL_DECL_SOFT            1023
#define PIN_REASON_ID_FAIL_SRVC_UNAVAIL         1024
#define PIN_REASON_ID_FAIL_DECL_HARD            1025
#define PIN_REASON_ID_FAIL_NO_MIN               1026
#define PIN_REASON_ID_INVALID_CMD               1027
#define PIN_REASON_ID_FAIL_SELECT_ITEMS         1028
#define PIN_REASON_ID_FAIL_CVV_BAD              1029
#define PIN_REASON_ID_NO_CREDIT_BALANCE         1030
#define PIN_REASON_ID_FAIL_LOGICAL_PROBLEM      1031
#define PIN_REASON_ID_FAIL_FORMAT_ERROR         1032
#define PIN_REASON_ID_FAIL_INVALID_CONTENT      1033
#define PIN_REASON_ID_FAIL_TECHNICAL_PROBLEM    1034

#define PIN_REASON_ID_SUSPENSE_DEFAULT		2999
#define PIN_REASON_ID_ACCT_NOT_FOUND		2001
#define PIN_REASON_ID_ACCT_STATUS_CLOSED	2002
#define PIN_REASON_ID_BILL_NOT_FOUND		2003
#define PIN_REASON_ID_INVALID_TRANS_ID 		2004
#define PIN_REASON_ID_MISSING_TRANS_ID		2005
#define PIN_REASON_ID_RECYCLED_PAYMENT		2006
#define PIN_REASON_ID_MBI_DISTRIBUTION_REQD     2007
#define PIN_REASON_ID_MBI_DISTRIBUTED_PAYMENT	2008
#define PIN_REASON_ID_REVERSAL_AS_UNALLOCATABLE 4999
#define PIN_REASON_ID_REVERSAL_FOR_RECYCLING    4001

/***************************************************************
 * Reason ID related to Sponsored Topup
 ***************************************************************/
#define PIN_REASON_ID_TOPUP_CREDIT 		5
#define PIN_REASON_ID_TOPUP_DEBIT		4


/***************************************************************
 * Reason Domain ID
 ***************************************************************/
#define PIN_PYMT_REASON_DOMAIN_ID		100
#define PIN_PYMT_FAILED_REASON_DOMAIN_ID	13
#define PIN_PYMT_SUSPENSE_REASON_DOMAIN_ID	14
#define PIN_PYMT_SUSPENSE_USER_ACTION_DOMAIN_ID	15
#define PIN_PYMT_SUSPENSE_REVERSAL_DOMAIN_ID    16

/***************************************************************
 * Reason DOMAIN ID related to Sponsored Topup
 ***************************************************************/
#define PIN_PYMT_TOPUP_CREDIT_REASON_DOMAIN_ID		8
#define PIN_PYMT_TOPUP_DEBIT_REASON_DOMAIN_ID		1

/***************************************************************
 * Maximum Transaction ID length for non online payments 
 ***************************************************************/
#define PIN_PYMT_NON_ONLINE_TRANSID_LENGTH	30

/*************************************************************
 * Payment Batch
 *************************************************************/
#define PIN_OBJ_NAME_EVENT_BATCH_PAYMENT       "Payment Batch"
#define PIN_OBJ_EVENT_BILLING_BATCH_PAYMENT    "/event/billing/batch/payment"

/*************************************************************
 * Refund Batch
 *************************************************************/

#define PIN_OBJ_NAME_EVENT_BATCH_REFUND       "Refund Batch"
#define PIN_OBJ_EVENT_BILLING_BATCH_REFUND    "/event/billing/batch/refund"

#endif	/*_PIN_PYMT_H*/

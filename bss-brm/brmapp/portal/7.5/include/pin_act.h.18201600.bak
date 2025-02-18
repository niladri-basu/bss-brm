/* @(#)$Id: pin_act.h /cgbubrm_7.3.2.rwsmod/4 2009/09/22 03:54:56 lnandi Exp $ */
/*******************************************************************
 *
 *      
 * Copyright (c) 1996, 2009, Oracle and/or its affiliates. 
 * All rights reserved. 
 *      
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/

#ifndef _PIN_ACT_H
#define	_PIN_ACT_H

#ifndef _REGEX_H_
#if defined(__hpux) || defined(__aix)
#include <regex.h>
#endif 
#endif 

/*******************************************************************
 * Activity Tracking FM Definitions.
 *******************************************************************/

/*******************************************************************
 * Object Name Strings
 *******************************************************************/
#define PIN_OBJ_NAME_EVENT_ACT 		"Activity Tracking Event Log"
#define PIN_OBJ_NAME_EVENT_SESSION	"Activity Session Log"
#define PIN_OBJ_NAME_EVENT_VERIFY	"Activity Verification Log"
#define PIN_OBJ_NAME_EVENT_CREDIT_THRESHOLD "Credit Threshold Notification Log"
#define PIN_OBJ_NAME_EVENT_CREDIT_LIMIT	"Credit Limit Notification Log"
#define PIN_OBJ_NAME_EVENT_DATE_THRESHOLD "Date Threshold Notification Log"
#define PIN_OBJ_NAME_EVENT_DATE_EXPIRE	"Date Expiration Notification Log"
#define PIN_OBJ_NAME_EVENT_DELETE_ACCT	"Account Object Deletion Log"
#define PIN_OBJ_NAME_EVENT_PRE_DELETE_ACCT   "Account Object Pre Deletion Log"
#define PIN_OBJ_NAME_EVENT_DELETE_SRVC	"Service Object Deletion Log"
#define PIN_OBJ_NAME_EVENT_SERVICE	"Service Object Update Log"
#define PIN_OBJ_NAME_EVENT_SCHEDULE_CREATE "Schedule Create Event Log"
#define PIN_OBJ_NAME_EVENT_SCHEDULE_MODIFY "Schedule Modify Event Log"
#define PIN_OBJ_NAME_EVENT_SCHEDULE_EXECUTE "Schedule Execute Event Log"
#define PIN_OBJ_NAME_EVENT_SCHEDULE_DELETE "Schedule Delete Event Log"
#define PIN_OBJ_NAME_SCHEDULE		"Schedule Object"
#define PIN_OBJ_NAME_EVENT_PROFILE "Profile Object Update Log"
#define PIN_OBJ_NAME_EVENT_CUSTOMER        "Customer Modification Event Log"
                
/*******************************************************************
 * Object Type Strings
 *******************************************************************/
#define	PIN_OBJ_TYPE_EVENT_ACT		"/event/activity"
#define	PIN_OBJ_TYPE_EVENT_ADMIN	"/event/activity/admin"
#define	PIN_OBJ_TYPE_EVENT_SESSION	"/event/session"
#define PIN_OBJ_TYPE_EVENT_VERIFY	"/event/activity/verify"
#define PIN_OBJ_TYPE_EVENT_CREDIT_THRESHOLD	"/event/notification/threshold"
#define PIN_OBJ_TYPE_EVENT_CREDIT_THRESHOLD_BELOW	"/event/notification/threshold_below"
#define PIN_OBJ_TYPE_EVENT_CREDIT_LIMIT	"/event/notification/limit"
#define PIN_OBJ_TYPE_EVENT_DATE_THRESHOLD "/event/notification/datethreshold"
#define PIN_OBJ_TYPE_EVENT_DATE_EXPIRE	"/event/notification/datexpire"
#define PIN_OBJ_TYPE_EVENT_DELETE_ACCT	"/event/notification/account/delete"
#define PIN_OBJ_TYPE_EVENT_PRE_DELETE_ACCT   "/event/notification/account/pre_delete"
#define PIN_OBJ_TYPE_EVENT_DELETE_SRVC	"/event/notification/service/delete"
#define PIN_OBJ_TYPE_EVENT_SERVICE	"/event/notification/service/modify"
#define PIN_OBJ_TYPE_EVENT_SCHEDULE_CREATE "/event/schedule/create"
#define PIN_OBJ_TYPE_EVENT_SCHEDULE_MODIFY "/event/schedule/modify"
#define PIN_OBJ_TYPE_EVENT_SCHEDULE_EXECUTE "/event/schedule/execute"
#define PIN_OBJ_TYPE_EVENT_SCHEDULE_DELETE "/event/schedule/delete"
#define PIN_OBJ_TYPE_EVENT_ACCOUNT_CREATE "/event/notification/account/create"
#define PIN_OBJ_TYPE_EVENT_REG_COMPLETE "/event/notification/customer/reg_complete"
#define PIN_OBJ_TYPE_EVENT_UNIQUENESS_CONFIRMED "/event/notification/customer/uniqueness_confirmed"
#define PIN_OBJ_TYPE_EVENT_DEAL_CHANGE "/event/notification/deal/change"
#define PIN_OBJ_TYPE_EVENT_DEAL_CHANGE_COMPLETE "/event/notification/deal/change_complete"
#define PIN_OBJ_TYPE_EVENT_CUSTOMER_PRE_MODIFY "/event/notification/customer/pre_modify"
#define PIN_OBJ_TYPE_EVENT_CUSTOMER_MODIFY "/event/notification/customer/modify"
#define PIN_OBJ_TYPE_EVENT_SERVICE_PRE_UPDATE "/event/notification/service/pre_change"
#define PIN_OBJ_TYPE_EVENT_SERVICE_POST_UPDATE "/event/notification/service/post_change"
#define PIN_OBJ_TYPE_EVENT_SERVICE_PRE_CREATE "/event/notification/service/pre_create"
#define PIN_OBJ_TYPE_EVENT_SERVICE_PRE_PURCHASE "/event/notification/service/pre_purchase"
#define PIN_OBJ_TYPE_EVENT_SERVICE_CREATE "/event/notification/service/create"
#define PIN_OBJ_TYPE_EVENT_PROFILE_CREATE "/event/notification/profile/create"
#define PIN_OBJ_TYPE_EVENT_PROFILE_MODIFY "/event/notification/profile/modify"
#define PIN_OBJ_TYPE_EVENT_PROFILE_PRE_MODIFY "/event/notification/profile/pre_modify"
#define PIN_OBJ_TYPE_EVENT_PROFILE_DELETE "/event/notification/profile/delete"
#define PIN_OBJ_TYPE_EVENT_BILL_NOW "/event/notification/service_item/bill_now"
#define PIN_OBJ_TYPE_EVENT_MAKE_BILL "/event/notification/service_item/make_bill"
#define PIN_OBJ_TYPE_EVENT_MAKE_BILL_START  "/event/notification/service_item/make_bill_start"
#define PIN_OBJ_TYPE_EVENT_BILL_DELAY "/event/notification/service_item/bill_delay"
#define PIN_OBJ_TYPE_EVENT_DEAL_TRANSITION "/event/notification/deal/transition"
#define PIN_OBJ_TYPE_EVENT_DEAL_TRANSITION_COMPLETE "/event/notification/deal/transition_complete"
#define PIN_OBJ_TYPE_EVENT_PLAN_TRANSITION "/event/notification/plan/transition"
#define PIN_OBJ_TYPE_EVENT_PLAN_TRANSITION_COMPLETE "/event/notification/plan/transition_complete"
#define PIN_OBJ_TYPE_EVENT_BILL_START "/event/notification/billing/start"
#define PIN_OBJ_TYPE_EVENT_BILL_END "/event/notification/billing/end"
#define PIN_OBJ_TYPE_EVENT_BILL_START_PARTIAL  "/event/notification/billing/start_partial"
#define PIN_OBJ_TYPE_EVENT_BILL_END_PARTIAL  "/event/notification/billing/end_partial"
#define PIN_OBJ_TYPE_EVENT_ROLLOVER_START "/event/notification/rollover/start"
#define PIN_OBJ_TYPE_EVENT_ROLLOVER_END "/event/notification/rollover/end"
#define PIN_OBJ_TYPE_EVENT_CYCLE_START "/event/notification/cycle/start"
#define PIN_OBJ_TYPE_EVENT_CYCLE_END "/event/notification/cycle/end"
        
/*******************************************************************
 * Event Description Strings
 *******************************************************************/
#define PIN_EVENT_DESCR_ACT		"Activity"
#define PIN_EVENT_DESCR_SESSION		"Session"
#define PIN_EVENT_DESCR_CREDIT_THRESHOLD "Credit Threshold Exceeded"
#define PIN_EVENT_DESCR_CREDIT_LIMIT	"Credit Limit Exceeded"
#define PIN_EVENT_DESCR_DATE_THRESHOLD	"Date Threshold Exceeded"
#define PIN_EVENT_DESCR_DATE_EXPIRE	"Date Expire"
#define PIN_EVENT_DESCR_DELETE_ACCT	"Account Object Deleted"
#define PIN_EVENT_DESCR_PRE_DELETE_ACCT	"Account Object Delete Begin"
#define PIN_EVENT_DESCR_DELETE_SRVC	"Service Object Deleted"
#define PIN_EVENT_DESCR_SERVICE		"Service Object Updated"
#define PIN_EVENT_DESCR_SERVICE_PRE_MODIFY "Service Object Update begin"
#define PIN_EVENT_DESCR_SERVICE_POST_MODIFY "Service Object Update complete"
#define PIN_EVENT_DESCR_SERVICE_CREATE "Service Object Created"
#define PIN_EVENT_DESCR_SCHEDULE_CREATE "Schedule Object Created"
#define PIN_EVENT_DESCR_SCHEDULE_MODIFY "Schedule Object Modified"
#define PIN_EVENT_DESCR_SCHEDULE_EXECUTE "Schedule Object Executed"
#define PIN_EVENT_DESCR_SCHEDULE_DELETE "Schedule Object Deleted"
#define PIN_EVENT_DESCR_CUSTOMER_PRE_MODIFY "Customer Object pre Modification"
#define PIN_EVENT_DESCR_CUSTOMER_MODIFY "Customer Object Modified"
#define PIN_EVENT_DESCR_PROFILE_CREATE "Profile Object Created"
#define PIN_EVENT_DESCR_PROFILE_MODIFY "Profile Object Modified"
#define PIN_EVENT_DESCR_PROFILE_PRE_MODIFY "Profile Object about to be modified"
#define PIN_EVENT_DESCR_PROFILE_DELETE "Profile Event Deleted"

/*******************************************************************
 * PCM_OP_POL_ACT_SPEC_VERIFY fields
 *******************************************************************/
/*
 * PIN_FLD_TYPE - type of check to perform
 */
typedef enum pin_act_check {
	PIN_ACT_CHECK_UNDEFINED =	0,
	PIN_ACT_CHECK_ACCT_TYPE =	1,
	PIN_ACT_CHECK_ACCT_STATUS =	2,
        PIN_ACT_CHECK_ACCT_PASSWD =	3,
        PIN_ACT_CHECK_SRVC_TYPE =	4,
        PIN_ACT_CHECK_SRVC_STATUS =	5,
        PIN_ACT_CHECK_SRVC_PASSWD =	6,
        PIN_ACT_CHECK_CREDIT_AVAIL =	7,
        PIN_ACT_CHECK_DUPE_SESSION =	8
} pin_act_check_t;

/*
 * PIN_FLD_SCOPE - Scope of check to be performed.
 */
typedef enum pin_act_verify_scope {
        PIN_ACT_VERIFY_SCOPE_SNAPSHOT = 1,
        PIN_ACT_VERIFY_SCOPE_MASTER =   2
} pin_act_verify_scope_t;

/*
 * PIN_FLD_SUBTYPE - scope of check to perform
 */
typedef enum pin_act_scope {
	PIN_ACT_SCOPE_UNDEFINED =	0,
	PIN_ACT_SCOPE_SRVC_OBJ =	1,
	PIN_ACT_SCOPE_SRVC_TYPE =	2
} pin_act_scope_t;

/*
 * PIN_FLD_STATUS - Status of a schedule object
 */
typedef enum pin_schedule_status {
        PIN_SCHEDULE_STATUS_PENDING = 0,
        PIN_SCHEDULE_STATUS_DONE = 1,
        PIN_SCHEDULE_STATUS_ERROR = 2,
	PIN_SCHEDULE_STATUS_PENDING_UNDELETABLE = 3
} pin_schedule_status_t;

/*
 * PIN_FLD_PASSWD_STATUS - Status of passwd
 */
typedef enum pin_passwd_status {
	PIN_PASSWDSTATUS_NORMAL = 0,
	PIN_PASSWDSTATUS_TEMPORARY = 1,
	PIN_PASSWDSTATUS_EXPIRES = 2,
	PIN_PASSWDSTATUS_INVALID = 3
} pin_passwd_status_t;

/*
 * PIN_FLD_RESOURCE_STATUS, PIN_FLD_RESULT - 
 * for PCM_OP_ACT_CHEKC_RESOURCE_THRESHOLD - 
 * Status of the Resource Threshold status
 */
typedef enum pin_resource_status {
        PIN_RESOURCE_STATUS_RED = 0,
        PIN_RESOURCE_STATUS_GREEN = 1,
        PIN_RESOURCE_STATUS_YELLOW =  2
} pin_resource_status_t;

/*
 * PIN_FLD_TYPE 
 * for PCM_OP_ACT_CHEKC_RESOURCE_THRESHOLD - 
 * Authorization types
 */
typedef enum pin_authorization_types {
        PIN_TYPE_AUTH  = 0,
        PIN_TYPE_REAUTH = 1
} pin_authorization_types_t;

/*******************************************************************
 * PCM_OP_ACT_VERIFY fields.
 *******************************************************************/
/*
 * PIN_FLD_RESULT - result of a act_verify operation.
 */

#define	PIN_ACT_VERIFY_PASSED		PIN_BOOLEAN_TRUE
#define	PIN_ACT_VERIFY_FAILED		PIN_BOOLEAN_FALSE

/*
 * Deletion flags
 */
#define PIN_ACT_DELETE_RESERVATION_OBJ		1
#define PIN_ACT_DELETE_ASO			2 

/*
 * PIN_FLD_REASON - reason for result act_verify operation. 
 */

#define	PIN_ACT_VERIFY_PASSED_LOGIN		0
#define	PIN_ACT_VERIFY_FAILED_LOGIN		2
#define	PIN_ACT_VERIFY_PASSED_TEMPPASSWD	4
#define	PIN_ACT_VERIFY_FAILED_EXPPASSWD		5
#define	PIN_ACT_VERIFY_FAILED_INVALIDPASSWD	6
#define PIN_ACT_VERIFY_SERVICE_LOCKED		7

/* Lock status for pcm_client and admin_client services */
#define PIN_SERVICE_LOCKED			PIN_BOOLEAN_TRUE	

/*******************************************************************
 * PCM_OP_ACT_MULTI_AUTHORIZE fields.
 *******************************************************************/
/*
 * modes of multi_authorize call
 */
#define MULTI_AUTH_MODE_INTERN_BAL_AND_RR 0
#define MULTI_AUTH_MODE_INTERN_BAL_AND_NO_RR 1
#define MULTI_AUTH_MODE_EXTERN_MONETARY_BAL_AND_NO_RR 2

/*
 * PIN_FLD_RESULT - result of an act_multi_authorize operation.
 */

#define PIN_ACT_MULTI_AUTH_PASSED       PIN_BOOLEAN_TRUE
#define PIN_ACT_MULTI_AUTH_FAILED       PIN_BOOLEAN_FALSE

/*
 * PIN_FLD_REASON - reason for the result of act_multi_auth operation.
 * PCM_OP_ACT_MULTI_AUTHORIZE uses codes between 101-120
 */

#define PIN_ACT_MULTI_AUTH_LOGIN_NOT_FOUND         101
#define PIN_ACT_MULTI_AUTH_RATING_FAILURE          102
#define PIN_ACT_MULTI_AUTH_RESERVATION_FAILURE     103
#define PIN_ACT_MULTI_AUTH_INPUT_ERR               104

/* Introduced new MODE for PCM_OP_ACT_UPDATE_SESSION to skip calling ACT USAGE */
#define PIN_ACT_UPDATE_SESSION_SKIP_RATING 0x08000

/*******************************************************************
 * PCM_OP_ACT_EVENT defines.
 *******************************************************************/
typedef enum pin_act_item_type {
	PIN_ACT_ITEM_INDIVIDUAL =	1,
	PIN_ACT_ITEM_CUMULATIVE =	2,
	PIN_ACT_ITEM_PRE_CREATE =	3
} pin_act_item_type_t;

/*******************************************************************
 * Data structures used with fm_act module.
 *******************************************************************/
typedef struct notify_entry {
	u_int		opcode;
	u_int		opflag;
	char		expr[256];
} notify_t;

typedef struct notify_table {
	u_int		howmany;
	notify_t 	*table;
} notify_table_t;

typedef struct spec_rates_entry {
	u_int		opcode;
	u_int		opflag;
	char		expr[256];
#if defined(__hpux) || defined(_REGEX_H) || defined(_pin_os_regex_h_) || defined(__aix)
	regex_t		compiled_expr;
#else
	char		compiled_expr[256];
#endif
} spec_rates_t;

typedef struct spec_rates_table {
	u_int		howmany;
	spec_rates_t 	*table;
} spec_rates_table_t;

typedef struct verify_entry {
	u_int		type;
	u_int		flags;
	char		descr[255];
} verify_t;

typedef struct verify_table {
	u_int		howmany;
	verify_t 	*table;
} verify_table_t;


/*******************************************************************
 * Data structures used for FLIST trimming before sending to RTP
 *******************************************************************/
#define MAX_TRIM_DEPTH 5

struct FIELDS_INFO {
        int                 level;
        int                 pin_fld_id;
        int                 fld_type;
        int                 record_id;
        int                 next_idx;
};

struct EVENT_FIELDS_INFO {
        char                event_type[192];
        int                 flags;
        struct FIELDS_INFO  *fields_info;
        int                 size_evt_match;
        int                 size_fields_info;
};

struct EVENT_ACCOUNT_INFO {
        char                event_type[192];
        int                 flags;
        pin_flist_t         *flistp;
        int                 size_evt_match;
};

struct EVENT_SERVICE_INFO {
        char                event_type[192];
        int                 flags;
        pin_flist_t         *flistp;
        int                 size_evt_match;
};

extern int                             fm_act_trim_add_req;
extern struct EVENT_ACCOUNT_INFO       *fm_act_trim_evt_acc_info;
extern int                             fm_act_trim_evt_acc_info_cnt;
extern struct EVENT_SERVICE_INFO       *fm_act_trim_evt_ser_info;
extern int                             fm_act_trim_evt_ser_info_cnt;

extern struct EVENT_FIELDS_INFO        *fm_act_trim_info;
extern int                             fm_act_trim_info_cnt;
extern int                             fm_act_trim_using_drop;
extern int                             bill_time_discount_when;

#define OP_ACT_USAGE_LAST_SERVICE_OBJ "last_service"

#endif	/*_PIN_ACT_H*/

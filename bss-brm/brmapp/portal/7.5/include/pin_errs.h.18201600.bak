/*	
 *	@(#)%Portal Version: pin_errs.h:CommonIncludeInt:27:2006-Sep-11 05:27:12 %
 *	
* Copyright (c) 1996, 2011, Oracle and/or its affiliates. All rights reserved. 
 *	
 *	This material is the confidential property of Oracle Corporation or its
 *	licensors and may be used, reproduced, stored or transmitted only in
 *	accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _PIN_ERRS_H
#define _PIN_ERRS_H


#define PIN_ERR_NONE                         0
#define PIN_ERR_NO_MEM                       1
#define PIN_ERR_NO_MATCH                     2
#define PIN_ERR_NOT_FOUND                    3
#define PIN_ERR_BAD_ARG                      4
#define PIN_ERR_BAD_XDR                      5
#define PIN_ERR_BAD_FIRST_READ               6
#define PIN_ERR_BAD_READ                     7
#define PIN_ERR_NO_SOCKET                    8
#define PIN_ERR_BAD_TYPE                     9
#define PIN_ERR_DUPLICATE                   10
#define PIN_COMPARE_EQUAL                   11
#define PIN_COMPARE_NOT_EQUAL               12
#define PIN_ERR_MISSING_ARG                 13
#define PIN_ERR_BAD_POID_TYPE               14
#define PIN_ERR_BAD_CRYPT                   15
#define PIN_ERR_BAD_WRITE                   16
#define PIN_ERR_DUP_SUBSTRUCT               17
#define PIN_ERR_BAD_SEARCH_ARG              18
#define PIN_ERR_BAD_SEARCH_ARG_RECID        19
#define PIN_ERR_DUP_SEARCH_ARG              20
#define PIN_ERR_NONEXISTANT_POID            21
#define PIN_ERR_POID_DB_IS_ZERO             22
#define PIN_ERR_UNKNOWN_POID                23
#define PIN_ERR_NO_SOCKETS                  24
#define PIN_ERR_DM_ADDRESS_LOOKUP_FAILED    25
#define PIN_ERR_IM_ADDRESS_LOOKUP_FAILED    25  /* compat with old */
#define PIN_ERR_DM_CONNECT_FAILED           26
#define PIN_ERR_IM_CONNECT_FAILED           26  /* compat with old */
#define PIN_ERR_NAP_CONNECT_FAILED          27  /* connect to CM failed */
#define PIN_ERR_INVALID_RECORD_ID           28
#define PIN_ERR_STALE_CONF                  29
#define PIN_ERR_INVALID_CONF                30
#define PIN_ERR_WRONG_DATABASE              31
#define PIN_ERR_DUP_ARG                     32
#define PIN_ERR_BAD_SET                     33
#define PIN_ERR_BAD_CREATE                  34
#define PIN_ERR_BAD_FIELD_NAME              35
#define PIN_ERR_BAD_OPCODE                  36
#define PIN_ERR_TRANS_ALREADY_OPEN          37
#define PIN_ERR_TRANS_NOT_OPEN              38
#define PIN_ERR_NULL_PTR                    39
#define PIN_ERR_BAD_FREE                    40
#define PIN_ERR_FILE_IO                     41
#define PIN_ERR_NONEXISTANT_ELEMENT         42
#define PIN_ERR_STORAGE                     43  /* underlying DM storage */
#define PIN_ERR_TRANS_TOO_MANY_POIDS        44  /* transactions attempted */
                                                /* to too many DMs */
#define PIN_ERR_TRANS_LOST                  45  /* transaction lost, DM */
                                                /* went away during a trans. */
#define PIN_ERR_BAD_VALUE                   46  /* For whe what we get from
                                                   the DB just doesn't make
                                                   any sense */
#define PIN_ERR_PARTIAL                     47  /* For batching...at least one
                                                   post Litle err occurred. */
#define PIN_ERR_NOT_YET_DONE                48  /* op, xdr, ... not done yet */
#define PIN_ERR_STREAM_IO                   49  /* IO error on data stream */
#define PIN_ERR_STREAM_EOF                  50  /* EOF on data stream */
#define PIN_ERR_OP_NOT_OUTSTANDING          51  /* no op in progress */
#define PIN_ERR_OP_ALREADY_BUSY             52  /* op already in progress */
#define PIN_ERR_OP_ALREADY_DONE             53  /* op already done, */
                                                 /* no callback... set */
#define PIN_ERR_NO_DATA_FIELDS              54  /* (DM err) in_flist with no */
                                                /* data fields on it */
#define PIN_ERR_PROHIBITED_ARG              55  /* "prohibited on create" */
#define PIN_ERR_BAD_LOGIN_RESULT            56  /* login attempt failed */
#define PIN_ERR_CM_ADDRESS_LOOKUP_FAILED    57  /* lookup of CM address bad */
#define PIN_ERR_BAD_LOGIN_REDIRECT_INFO     58  /* connect redirect info bad */
#define PIN_ERR_TOO_MANY_LOGIN_REDIRECTS    59  /* too many connect redirects */
                                                /* perhaps a loop in config? */
#define PIN_ERR_STEP_SEARCH                 60  /* bad op, expected */
                                                /* STEP_NEXT/STEP_END */
#define PIN_ERR_STORAGE_DISCONNECT          61  /* connection to underlying */
                                                /* DM storage was lost */
#define PIN_ERR_NOT_GROUP_ROOT              62  /* Not the root of a group*/
#define PIN_ERR_BAD_LOCKING                 63  /* OS locking error */
#define PIN_ERR_AUTHORIZATION_FAIL          64
#define PIN_ERR_NOT_WRITABLE                65  /* Not writable */
#define PIN_ERR_UNKNOWN_EXCEPTION           66  /* Unknown C++ exception */
#define PIN_ERR_START_FAILED                67  /* Failed to start servers */
#define PIN_ERR_STOP_FAILED                 68  /* Failed to stop servers */
#define PIN_ERR_INVALID_QUEUE               69  /* Invalid queue */
#define PIN_ERR_TOO_BIG                     70  /* something was too big */
#define PIN_ERR_BAD_LOCALE                  71  /* Invalid Locale passed */
#define PIN_ERR_CONV_MULTIBYTE              72  /* Error conversion */
#define PIN_ERR_CONV_UNICODE                73  /* Error conversion */
#define PIN_ERR_BAD_MBCS                    74  /* Error conversion */
#define PIN_ERR_BAD_UTF8                    75  /* Error conversion */
#define PIN_ERR_CANON_CONV                  76  /* Error canon conversion */
#define PIN_ERR_UNSUPPORTED_LOCALE          77  /* Unsupported locale */
#define PIN_ERR_CURRENCY_MISMATCH           78  /* Parent/child currency mismatch*/
#define PIN_ERR_DEADLOCK                    79  /* Transaction rolled back due to resource contention */
#define PIN_ERR_BACKDATE_NOT_ALLOWED        80  /* ledger report posted */
#define PIN_ERR_CREDIT_LIMIT_EXCEEDED       81  /* ledger report posted already */
#define PIN_ERR_IS_NULL                     82  /* value is "NULL" - not set */
#define PIN_ERR_DETAILED_ERR                83  /* detailed error - msg_id, uses enhanced errbuf */
#define PIN_ERR_PERMISSION_DENIED           84  /* Operation not allowed; data not viewable */
#define PIN_ERR_PDO_INTERNAL                85  /* The PDO data objects error */
#define PIN_ERR_IPT_DNIS                    86  /* The DNIS is not authorized. */
#define PIN_ERR_DB_MISMATCH                 87  /* Db. nos. did not match */ 
#define PIN_ERR_NO_CREDIT_BALANCE           88  /* No credit balance available for the account */
#define PIN_ERR_NOTHING_TO_BILL             89  /* No new items to bill */
#define PIN_ERR_MASTER_DOWN                 90  /* The main Infranet is down. */
#define PIN_ERR_OPCODE_HNDLR_INIT_FAIL      91  /* Initialization of opcode handler at JS failed */
#define PIN_ERR_STMT_CACHE                  92  /* statement cache problem */
#define PIN_ERR_CACHE_SIZE_ZERO             93  /* Tried to init cm_cache with zero size */
#define PIN_ERR_INVALID_OBJECT              94  /* Object may have moved to another database - as in AMT/MultiDB*/
#define PIN_ERR_VALIDATE_ADJUSTMENT         95  /* Validate adjustment policy opcode returns failure */
#define PIN_ERR_SYSTEM_ERROR                96  /* Generic system error during running application */
#define PIN_ERR_BILLING_ERROR               97  /* Error during billing run */
#define PIN_ERR_AUDIT_COMMIT_FAILED         98  /* Commit for the audit tables failed */
#define PIN_ERR_NOT_SUPPORTED               99  /* Operation not supported */
#define PIN_ERR_INVALID_SER_FORMAT         100  /* Serialized format received from database is incorrect */
#define PIN_ERR_READ_ONLY_TXN              101  /* Cannot insert/update in a r/o txn */
#define PIN_ERR_VALIDATION_FAILED          102  /* Deals/plans validation failed*/
#define PIN_ERR_PROC_BIND                  103  /* Binding for Procedure arguments failed */
#define PIN_ERR_PROC_EXEC                  104  /* Procedure returned Application Specific error */
#define PIN_ERR_STORAGE_FAILOVER           105  /* RAC Failover Message */
#define PIN_ERR_RETRYABLE                  106  /* Error due to failover - operation is 
                                                   retryable if needed */
#define PIN_ERR_NOT_PRIMARY                107  /* Not the primary instance */
#define PIN_ERR_NOT_ACTIVE                 107  /* Instance is not active */
#define PIN_ERR_TIMEOUT                    108  /* Request timeout */
#define PIN_ERR_CONNECTION_LOST            109  /* Connection lost */
#define PIN_ERR_FEATURE_DISABLED           110  /* Feature is disabled */
#define PIN_ERR_INVALID_STATE              111  /* Invalid State*/
#define PIN_ERR_NO_SECONDARY               112  /* No secondary instance*/
#define PIN_ERR_ACCT_CLOSED                113  /* Account is in Closed State */
#define PIN_ERR_EM_CONNECT_FAILED          114  /* CM-EM connection failure */
#define PIN_ERR_FAST_FAIL                  115  /* fast fail in dual timeout */
#define PIN_ERR_BAD_ENC_SCHEME             116  /* Bad encryption scheme */
#define PIN_ERR_MAX_BILL_WHEN              117  /* Error to be raised when bill_when crosses max value */
#define PIN_ERR_PERF_LIMIT_REACHED         118  /* Performance limit was reached */
#define PIN_ERR_ACTIVE_NOT_READY           119  /* TIMOS passive instance in transition to be active during switchover/failover but is not active ready yet */				
#define PIN_ERR_POID_ALREADY_LOCKED        120	/* Used to indicate already locked poids */
#define PIN_ERR_SERVICE_LOCKED             121  /* Used by SOX */

/*
 * the class of error
 */
#define PIN_ERRCLASS_SYSTEM_DETERMINATE      1
#define PIN_ERRCLASS_SYSTEM_INDETERMINATE    2
#define PIN_ERRCLASS_SYSTEM_RETRYABLE        3
#define PIN_ERRCLASS_APPLICATION             4
#define PIN_ERRCLASS_SYSTEM_SUSPECT          5

/*
 * which subsystem gave the error
 */
#define PIN_ERRLOC_PCM                       1
#define PIN_ERRLOC_PCP                       2  /* internal error */
#define PIN_ERRLOC_CM                        3
#define PIN_ERRLOC_DM                        4
#define PIN_ERRLOC_IM                        4  /* compatibility with old */
#define PIN_ERRLOC_FM                        5
#define PIN_ERRLOC_FLIST                     6  /* flist manipulation problem */
#define PIN_ERRLOC_POID                      7  /* poid manipulation problem */
#define PIN_ERRLOC_APP                       8
#define PIN_ERRLOC_QM                        9  /* QM (qmflist) framework */
#define PIN_ERRLOC_PCMCPP                   10  /* PCM C++ wrappers */
#define PIN_ERRLOC_LDAP                     11  /* Pin LDAP libraries */
#define PIN_ERRLOC_NMGR                     12  /* Node Manager */
#define PIN_ERRLOC_INFMGR                   13  /* Infranet Manager */
#define PIN_ERRLOC_UTILS                    14  /* Portal utility */
#define PIN_ERRLOC_JS                       15  /* Java Server Framework error */
#define PIN_ERRLOC_JSAPP                    16  /* Java Server App/Opcode handler error */
#define PIN_ERRLOC_PDO                      17  /* PDO Data Objects error */
#define PIN_ERRLOC_EM                       18
#define PIN_ERRLOC_RTP                      19  /* Realtime Pipeline */
#define PIN_ERRLOC_TIMOS                    20  /* Timos */
#define PIN_ERRLOC_ADT                      21  /* Errors in ADT lib (iscript) */

#endif /*_PIN_ERRS_H*/

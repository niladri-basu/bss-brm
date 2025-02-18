INF_EVENT                               | Event received: '%s'.                         | 31001
WRN_NO_EVENTS                           | No events registered.                         | 31002
ERR_CONVERTING_FLIST                    | FLIST string cannot be converted. '%s'        | 31003
ERR_GETTING_FLIST_FIELD                 | Cannot get field '%s' from FLIST.             | 31004
ERR_CONVERTING_FLIST_TO_STR             | Compact FLIST cannot be converted to string. '%s'     | 31005
ERR_DEQUEUE_EVENT                       | Dequeue event exception ('%s').               | 31006
ERR_QUEUE_NOT_INSTALLED                 | Database queueing infrastructure has not been installed.      | 31007
ERR_QUEUE_NOT_FOUND                     | Queue '%s' does not exist.                    | 31008
ERR_DEQUEUE_NOT_ENABLED                 | Dequeuing for queue '%s' is disabled.         | 31009
ERR_PURGE_EVENT_RET                     | Purging redundant events from queue '%s' failed (retVAlue = '%s').    | 31010
ERR_PURGE_EVENT_EXCEPT                  | Purging redundant events from queue '%s' failed (exception = '%s').   | 31011
INF_PURGE_EVENT                         | Purging '%s' event(s) from queue '%s' succeeded.      | 31012
INF_BACKLOG_COMPLETE                    | Backlog processing completed, start of CDR processing.        | 31013
ERR_OPENING_LOG_FILE                    | Fail to open the log file                     | 31014
ERR_WRITING_LOG_FILE                    | Fail to write to the log file                 | 31015
ERR_STATVIEW_NO_ACCESS                  | View to the Queue Table '%s' cannot be accessed  | 31016
INF_CONNECTION_STATUS                   | Database connection = '%s', deq_event proc = '%s', purge_event proc = '%s'. | 31017
INF_CONNECTION_RETRY                    | Database connection retries = '%s'.           | 31018
INF_CONNECTION_CREATE                   | Create new database connection ('%s').        | 31019
INF_CONNECTION_SUCCESS                  | Successfully create database connection ('%s').       | 31020
INF_CONNECTION_SLEEP                    | Sleep '%s' milliseconds between database connection attempts. | 31021
INF_RETRY_INTERVAL                      | Retry interval between connection attempts = '%s' (milliseconds).           | 31022
INF_PIPELINE_SEND_MESSAGE               | Send message '%s' to pipeline controller. | 31023
ERR_ENQUEUE_EVENT                       | Enqueue event exception ('%s').               | 31024
ERR_RECEIVE_EVENT			| Delivery of bus. event to DAT plugin failed (receiveEvent()). | 31025
INF_MAX_CDR_PROC_TIME			| Maximum no of CDRProcess time is  %s | 31026
INF_MIN_CDR_PROC_TIME			| Minimum no of CDRProcess time is  %s | 31027
INF_CUR_NUM_BUSS_EVENT			| Current total number of buss. events %s | 31028
INF_CUR_BUSS_EVENT_PROC_RATE		| Current buss. events processing rate %s | 31029
INF_CUR_CDR_PROC_FLG			| Current CDR Processing Flag %s | 31030
INF_CUR_MAX_NUM_MESG			| Current Maximum Number of Message %s | 31031
INF_CUR_MIN_NUM_MESG			| Current Minimum Number of Message %s | 31032
INF_CUR_BUSS_EVNT_CYCLE			| Current Business Event Cycle No.  %s | 31033
INF_CUR_CDR_CYCLE			| Current CDR Cycle No.  %s | 31034
INF_BUSS_EVENT_STRT			| Starting Business Event Processing | 31035
INF_CDR_STRT				| Starting CDR Processing | 31036
ERROR_REG_ENTRY_NOT_FOUND		| Error: Registry entry not found for %s | 31037
INF_REG_ENTRY_NOT_FOUND			| Info: Registry entry not found for %s | 31038
INF_INTERLEAVING_STAT_REQD              | Info: Interleaving statistics reqd is set as | 31039
INF_INTERLEAVING_STAT_NOT_REQD          | Info: Interleaving statistics not reqd | 31040
INF_PROC_REMAINING_EVENTS_NOT_REQD      | Info: Process all events in queue before cdr processing not reqd. | 31041
INF_INTERLEAVING_REQD                   | Info: Interleaving feature required is set to %s | 31042
INF_INTERLEAVING_NOT_REQD               | Info: Interleaving feature not required | 31043
INF_PROCESS_ALL_EVENTS_ON_STARTUP       | Info: Process all events in queue before cdr processing | 31044
INF_MAX_EVENT_PROCESS_TIME              | Info : Maximum business event process time is set to %s | 31045
INF_MAX_CDR_PROCESS_TIME                | Info : Maximum CDR process time is set to %s | 31046
INF_CDR_IN_PROCESS                      | Info : In CDR processing state ... | 31047
INF_BUS_EVENT_IN_PROCESS                | Info : In Event processing state ... | 31048
ERR_OPENING_QUEUE                       | Error : Could not open the Queue errorCode:'%s'| 31049
INF_DBDISCONNECT_SUCCESSFUL             | Info : Disconnect from event queue successfully | 31050
INF_DBCONNECT_SUCCESSFUL                | Info : Connect to event queue successfully | 31051
INF_LISTENER_RECONNECT_FAILED           | Info : Reconnect to event queue failed. Listener Module will try to reconnect later. | 31052 
INF_WAITING_FOR_TRANS_COMMIT            | Info : Waiting for current transaction to commit. | 31053 
INF_TRANS_COMMITTED                     | Info : Transaction Commited. | 31054
INF_DEQUEUE_DISABLED                    | Info : Disabled Dequeue Operation | 31055
INF_DEQUEUE_ENABLED                     | Info : Enabled Dequeue Operation | 31056
INF_DEQUEUE_STAT                        | Info : Dequeue Statistics: %s | 31057
INF_DEQUEUE_STAT_REQD                   | Info : Dequeue Statistics is set as true| 31058
INF_DEQUEUE_STAT_NOT_REQD               | Info : Dequeue Statistics not required | 31059
INF_ENABLE_STAT_DEMANDED                | Info : Request to enable statistics for %s | 31060
INF_AMM_ACKQUEUE_CHANGED                | Info : AMM acknowledgement queue is now changed to '%s' | 31061

#=================================================================
# Infranet Pipeline Server DAT::ResubmitBatch Messages
#
# Number Range: 40101-40200
#----------------------------------------------------------------
# Note: Add only numbers inside the allocated range.
#       Do not change existing numbers.
#=================================================================

# Normal / Info messages
INF_INVALID_CLEANUP_THRESHOLD_VALUE | Invalid value entered for QueueFileCleanUpThreshold, using 100 as default. | 40101

# Warnings
WRN_RESUBMITINFO_NOTFOUND   | ResubmitInfo not found for Pipeline %s and File %s. | 40102
WRN_RENAME_FAILED           | Cannot rename %s to %s, Error %s.                   | 40108
WRN_PIPELINE_NOT_FOUND      | Pipeline %s not found for resubmitted batch %s.     | 40109

# Errors
ERR_PROCESS_RESUBMIT_JOB    | Error occured while processing ResubmitJob : %s.      | 40103
ERR_ENQUEUE_DATA            | Error enqueuing data : %s.     | 40104
ERR_INVALID_OPERATION       | Operation %s, %s.              | 40105
ERR_REMOVE_OLD_ITEMS        | Error occured while removing already Processed Items | 40106
ERR_OPENFILE_FAILED         | Cannot open file %s, Error %s. | 40107
ERR_CREATE_TEMP_FILE        | Cannot create temporary file, Error %s. | 40110

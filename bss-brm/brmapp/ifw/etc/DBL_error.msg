#=================================================================
# Portal Pipeline Server DBL Messages
#
# Number Range: 11201-11300
#----------------------------------------------------------------
# Note: Add only numbers inside the allocated range.
#       Do not change existing numbers.
#=================================================================

INF_DBL_START                    | Program dbLoader Version %s started.                   | 11201
INF_DBL_STOP                     | Program dbLoader Version %s stopped.                   | 11202
ERR_CANNOT_CREATE_CTL_QUEUE      | Cannot create queue of controller-files.               | 11203
ERR_CANNOT_CREATE_RECORD         | Cannot create record.                                  | 11204
ERR_CANNOT_CREATE_CONTROLLER     | Cannot create controller (%s, %s).                     | 11205
INF_DB_INSERT                    | Record inserted (%s).                                  | 11206
INF_DB_UPDATE                    | Record updated (%s).                                   | 11207
ERR_DB_INSERT                    | Cannot insert record (%s).                             | 11208
ERR_DB_UPDATE                    | Cannot update record (%s).                             | 11209
ERR_DB_UPDATE_AND_INSERT         | Transaction failed. Message: '%s'. Record: '%s'.       | 11210
ERR_AGGREGATION_UNKNOWN          | Unknown aggregation function.                          | 11211
ERR_READ_RECORD                  | Cannot read record.                                    | 11212
INF_BEGIN_DB_TRANSACTION         | Transaction started.                                   | 11213
INF_COMMIT_DB_TRANSACTION        | Transaction ok. Commit.                                | 11214
INF_DB_TRANSACTION_DONE          | %s records moved.                                      | 11215
ERR_ROLLBACK_DB_TRANSACTION      | Transaction failed. Rollback.                          | 11216
INF_DB_TRANSACTION_STATISTIC     | Transaction statistic: %s.                             | 11217
INF_START_RUNNING_CLT            | Start running controlfile (%s).                        | 11218
ERR_START_RUNNING_CLT            | Cannot start running controlfile (%s).                 | 11219
INF_STOP_RUNNING_CLT             | Stop running controlfile (%s).                         | 11220
ERR_STOP_RUNNING_CLT             | Error while running controlfile (%s).                  | 11221
ERR_TABLE_NOT_FOUND              | Table '%s' not found in database.                      | 11222
INF_DATABASE_CONNECTION_DO       | Move records into table '%s'.                          | 11223
INF_DATABASE_CONNECTION_UNDO     | REMOVE RECORDS FROM TABLE '%s'.                        | 11224
ERR_DATABASE_CONNECTION          | Cannot connect database.                               | 11225
ERR_MOVE_FILES                   | Cannot move file from '%s' to '%s'.                    | 11226
INF_MOVE_FILES                   | File moved from '%s' to '%s'.                          | 11227
INF_EMPTY_DATAFILE               | Datafile is empty. Nothing done.                       | 11228
ERR_PRIMARY_KEY_IS_NULL          | Primary key has null value. Record: '%s'.              | 11229
ERR_COLUMN_UNKNOWN               | Column '%s' is unknown.                                | 11230
ERR_DBL_GENERIC                  | ERROR '%s' in file '%s' line '%s' msg '%s' detail '%s'.| 11231
INF_SORT_TIME                    | %s seconds needed for sorting datafiles.               | 11232
INF_LOCKING_TABLE                | Locking table '%s' in exclusive mode.                  | 11233
INF_TABLE_LOCKED                 | Table '%s' locked in exclusive mode.                   | 11234
ERR_LOCKING_TABLE                | Could not lock table '%s' in exclusive mode.           | 11235

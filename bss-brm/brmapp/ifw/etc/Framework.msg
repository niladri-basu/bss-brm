#================================================================= 
# Infranet Pipeline Server Framework Messages  
# 
# Number Range: 00001-10000  
#----------------------------------------------------------------
# Note: Add only numbers inside the allocated range.
#       Do not change existing numbers.
#================================================================= 
# 05-Aug-2003: Introduction of error number ranges 
#================================================================= 

INF_LOG_START                      |  ================================ %s SERVER STARTED ================================ | 00001
INF_LOG_STOP                       |  ================================ %s SERVER STOPPED ================================ | 00002
ERR_OBJ_NOT_REGISTERABLE           |  The object '%s' could not be registered. | 00003
ERR_OBJ_ALREADY_REGISTERED         |  '%s' is already registered as '%s'. | 00004
ERR_OBJ_NOT_INITIALIZED            |  The object '%s' is not initialized. | 00005
ERR_REG_PARSE_FAILED               |  Registry parse failed near '%s'. | 00006
ERR_REG_SUBTREE_NOT_FOUND          |  Registry subtree '%s' not found. | 00007
ERR_REG_NAME_NOT_FOUND             |  Registry name '%s' not found. | 00008
ERR_REG_VALUE_IS_EMPTY             |  Found empty value for registry item, where a value was expected. | 00009
ERR_CANNOT_INIT_INPUT_STREAM       |  Cannot initialise the input stream object. | 00010
ERR_CANNOT_INIT_INPUT_STREAM_INTERFACE  |  Cannot initialise the input stream interface object. | 00011
ERR_CANNOT_INIT_OUTPUT_STREAM      |  Cannot initialise the output stream object. | 00012
ERR_CANNOT_INIT_OUTPUT_STREAM_INTERFACE  |  Cannot initialise the output stream interface object. | 00013
ERR_CANNOT_INIT_OUTPUT_COLLECTION  |  Cannot initialise the output collection. | 00014
INF_INP_STR_NOT_FOUND              |  InputStream not found for device in registry '%s'. | 00015
INF_OUT_STR_NOT_FOUND              |  OutputStream not found for device in registry '%s'. | 00016
ERR_NO_PATH_NAME                   |  No path name given. | 00017
ERR_NO_DIR                         |  Directory '%s' not accessible. | 00018
ERR_INVALID_PATTERN                |  Directory pattern '%s' is invalid. | 00019
ERR_DLOPEN_FAILED                  |  Cannot open shared library '%s'; %s. | 00020
ERR_DLSYM_FAILED                   |  Cannot get address of generator function '%s'; %s. | 00021
ERR_CREATE_OBJECT_FAILED           |  Cannot create object '%s' (invalid (NULL) pointer). | 00022
ERR_INVALID_QUEUE_SIZE             |  Queue size < 0. | 00023
ERR_INVALID_REG_BASE_NAME          |  Registry base name of '%s' does not match '%s'. | 00024
ERR_FILENAME_MISSING               |  File name not set for '%s'. | 00025
ERR_OPEN_FILE_FAILED               |  Cannot open file '%s'. | 00026
ERR_FILE_EOF                       |  Tried to read past end of file '%s'. | 00027
INF_FILE_EOF                       |  Finished reading file '%s'. | 00028
INF_FILE_OPENED                    |  File '%s' opened. | 00029
INF_FILE_CLOSED                    |  File '%s' closed. | 00030
ERR_FILE_READ_ERR                  |  Error reading from file '%s'. | 00031
ERR_FILE_WRITE_ERR                 |  Error writing into file '%s'. | 00032
ERR_INPUT_PATH_NOT_FOUND           |  Entry for input path not found in registry. | 00033
INF_INPUT_PREFIX_NOT_FOUND         |  Entry for input prefix not found in registry. | 00034
INF_INPUT_SUFFIX_NOT_FOUND         |  Entry for input suffix not found in registry. | 00035
ERR_DONE_PATH_NOT_FOUND            |  Entry for done path not found in registry. | 00036
INF_DONE_PREFIX_NOT_FOUND          |  Entry for done prefix not found in registry. | 00037
INF_DONE_SUFFIX_NOT_FOUND          |  Entry for done suffix not found in registry. | 00038
ERR_ERROR_PATH_NOT_FOUND           |  Entry for error path not found in registry. | 00039
INF_ERROR_PREFIX_NOT_FOUND         |  Entry for error prefix not found in registry. | 00040
INF_ERROR_SUFFIX_NOT_FOUND         |  Entry for error suffix not found in registry. | 00041
ERR_RETURN_PATH_NOT_FOUND          |  Entry for return path not found in registry. | 00042
INF_RETURN_PREFIX_NOT_FOUND        |  Entry for return prefix not found in registry. | 00043
INF_RETURN_SUFFIX_NOT_FOUND        |  Entry for return suffix not found in registry. | 00044
INF_TEMP_PREFIX_NOT_FOUND          |  Entry for temp prefix not found in registry. '%s' | 00045
INF_ERROR_TEMP_NOT_FOUND           |  Entry for temp prefix not found in registry. '%s' | 00046
INF_EMPTYTIMEOUT_NOT_FOUND         |  Entry for empty directory timeout not found in registry. '%s' | 00047
ERR_DIR_EMPTY                      |  Reading from empty directory '%s'. | 00048
ERR_DIR_NOT_ACCESSIBLE             |  Directory '%s' is not accessible. | 00049
ERR_OPEN_DIR_FAILED                |  Cannot open directory '%s'; error message '%s'. | 00050
ERR_READ_DIR_FAILED                |  Error reading from directory '%s'; error message '%s'. | 00051
ERR_FILE_NOT_MOVED                 |  File '%s' could not be moved to '%s'. | 00052
ERR_TMPFILE_NOT_MOVED              |  Temporary file '%s' could not be moved to '%s'. | 00053
INF_FILE_MOVED                     |  File '%s' moved to '%s'. | 00054
ERR_CREATE_THREAD_FAILED           |  Cannot create thread instance for '%s'; invalid thread body. | 00055
ERR_INVALID_THREAD_STATE           |  Invalid thread state in '%s'; %s; %s. | 00056
ERR_THREAD_EXCEPTION               |  Exception detected in '%s'; %s; %s. | 00057
ERR_MISSING_ARGUMENT               |  Argument '%s' not in message '%s'. | 00058
ERR_MISSING_MESSAGE_FILE_NAME      |  Message file name is missing. | 00059
ERR_OPEN_MESSAGE_FILE              |  %s: Message file '%s' could not open. | 00060
ERR_NO_MESSAGE_FILE                |  There are no message file found. Path : %s | 00061
ERR_WRONG_TOKEN_COUNT              |  Wrong token count in input file. Line: %s | 00062
ERR_LINE_NOT_INSERTED_DOUBLE       |  Could not insert line into message DB (double key). Line %s | 00063
ERR_LINE_NOT_INSERTED_INVALID      |  Could not insert line into message DB (invalid key). Line %s | 00064
ERR_MISSING_LOG_FILE_NAME          |  Log output file name is missing. | 00065
ERR_RENAME_LOG_FILE                |  Cannot rename old logfile. | 00066
ERR_OPEN_LOG_FILE                  |  %s: Cannot open log file '%s'. | 00067
ERR_TEMP_FILE_NOT_MOVED            |  Cannot move temporary input file '%s'. | 00068
ERR_INPUT_TEMP_FILE_NOT_MOVED      |  '%s': Cannot move temporary input file '%s' to input file '%s'. | 00069
ERR_INPUT_FILE_NOT_MOVED           |  '%s': Cannot move input file '%s' to temporary file '%s'. | 00070
ERR_INPUT_TEMP_FILE_NOT_MOVED_TO_DONE_ERR  |  '%s': Cannot move temporary file '%s' to done or err file '%s'. | 00071
ERR_INPUT_DONE_FILE_NOT_MOVED_TO_ERR       |  '%s': Cannot move done file '%s' to error file '%s'. | 00072
ERR_INPUT_DONE_FILE_NOT_MOVED_TO_INPUT     |  '%s': Cannot move done file '%s' to input file '%s'. | 00073
INF_TEMP_FILE_MOVED                |  Temporary input file '%s' renamed. | 00074
ERR_REG_UPDATE_FAILED              |  Command processing failed for '%s'. | 00075
ERR_OUTPUT_PATH_NOT_FOUND          |  The output path does not exists or is not accesible. | 00076
INF_OUTPUT_PREFIX_NOT_FOUND        |  Registry entry for output prefix not found | 00077
INF_OUTPUT_SUFFIX_NOT_FOUND        |  Registry entry for output suffix not found | 00078
ERR_OUTPUT_NOT_OPEN                |  Cannot close output stream (not open). | 00079
ERR_OUTPUT_ALREADY_OPEN            |  Output stream already opened. | 00080
ERR_OUTPUT_TEMP_FILE_NOT_MOVED_TO_OUTPUT  |  '%s': Cannot move temporary file '%s' to output file '%s'. | 00081
ERR_CANNOT_RENAME_OUTPUT_FILE      |  Cannot rename temporary output file '%s'. | 00082
INF_RENAME_OUTPUT_FILE             |  Output file '%s' renamed. | 00083
ERR_DELETE_OUTPUT_FILE             |  '%s': Cannot delete output file '%s'. | 00084
INF_DELETE_OUTPUT_FILE             |  Output file '%s' deleted. | 00085
INF_NO_ERROR_RATES_FOUND           |  No maximal error rates specified in registry. | 00086
ERR_ERROR_RATE_VALUE_NOT_SPECIFIED |  No value specified for error '%s'. | 00087
ERR_ERROR_RATE_ALREADY_DEFINED     |  Error rate for '%s' already specified. | 00088
ERR_ILLEGAL_STREAM_NUM             |  Tried to use illegal stream number '%s' for output. | 00089
INF_BEGIN_STREAM                   |  Beginning to process stream '%s'. | 00090
INF_END_STREAM                     |  End of the processing of stream '%s'. | 00091
INF_PIPELINE_START                 |  The pipeline '%s' is started (active). | 00092
INF_PIPELINE_STOP                  |  The pipeline '%s' is stopped (inactive). | 00093
INF_ABORT_REQUESTED                |  Abort requested for pipeline '%s'. | 00094
ERR_NO_DEFAULT_OUTPUT_DEVICE       |  No default output device. | 00095
ERR_REG_ENTRY_NOT_FOUND            |  Registry entry '%s' not found. | 00096
WRN_SEMAPHORE_NOT_PROCESSED        |  Semaphore was not processed; check spelling. | 00097
INF_FKT_ACTIVE                     |  Function '%s' is active. | 00098
INF_FCT_ACTIVE                     |  Function '%s' is active. | 00099
INF_FKT_INACTIVE                   |  Function '%s' is inactive. | 00100
INF_FCT_INACTIVE                   |  Function '%s' is inactive. | 00101
ERR_OBJ_NOT_FOUND                  |  The object '%s' could not be found. | 00102
ERR_OBJ_NOT_REGISTERED             |  The object '%s' is not registered. | 00103
INF_STATISTIC_EDR                  |  Total number of%sEDRs: %s, %s (= %s%) are corrupted. | 00104
INF_STATISTIC_MSGNAME              |  %s%sEDRs with message %s (= %s%). | 00105
INF_STATISTIC_DURA_TIME            |  %s seconds have been used to process %s%sEDRs (%s EDRs/sec). | 00106
INF_EDR_REJECTED                   |  The EDR is rejected. | 00107
INF_EDR_DISCARDED                  |  The EDR is discarded. | 00108
INF_EDR_SKIPED                     |  The EDR is skiped. | 00109
ERR_STREAM_NOT_FOUND               |  Could not create any statistic informations for this device. | 00110
ERR_UNKNOWN_DISCARD_FKT            |  Valid functions are [ Discard or Skip ] | 00111
INF_NO_REG_VALUE                   |  No registry entry '%s' found. | 00112
ERR_INVALID_REG_VALUE              |  Invalid value '%s' for '%s'. | 00113
ERR_INVALID_REG_ENTRIES            |  Invalid Registry Entries. %s  | 00114
ERR_INVALID_STATE                  |  Received EDR invalid in the current state. | 00115
ERR_SEQ_SAVE                       |  Error saving sequence information to stream. | 00116
ERR_SEQ_INIT                       |  Default sequence file generated. Please check file content.  | 00117
ERR_SEQ_FILE_INVALID               |  Error reading / parsing sequence number file '%s'. | 00118
ERR_INVALID_SEQ_NUM                |  Invalid sequence number '%s'. | 00119
ERR_SEQ_CHECK_FAILED               |  Sequence check failed. | 00120
ERR_SEQ_MASTER_CONTROL             |  False master controller type in '%s' configured. | 00121
INF_ERR_RATE_EXCEEDED              |  The rate of the error type '%s' (%s%) was exceeded with %s%, rejecting file. | 00122
ERR_FILE_NOT_WRITABLE              |  File '%s' is not writable. | 00123
ERR_READONLY_FILE_NOT_PROCESSED    |  File '%s' is not writable, contents not processed. | 00124
ERR_DELETE_FILE                    |  Cannot delete file '%s'. | 00125
ERR_SEQ_ALREADY_PROCESSED          |  Stream with sequence number '%s' was already processed. | 00126
ERR_SEQ_GAP                        |  Sequence number '%s' is to high. | 00127
INF_REG_UPDATE_IN_PROGRESS         |  Command processing in progress, queuing the request. | 00128
INF_BEGIN_REG_UPDATE               |  Begin to process the command for registry update: '%s' . | 00129
INF_END_REG_UPDATE                 |  End of the command processing. | 00130
INF_ERROR_REG_UPDATE               |  Error occurred during command processing: %s. | 00131
INF_PROGRAM_START                  |  Program %s started. | 00132
INF_PROGRAM_STOP                   |  Program %s stopped. | 00133
INF_COPYRIGHT                      |  Copyright %s. | 00134
ERR_OPEN_SOCIAL_FILE               |  Cannot open social number file '%s'. | 00135
ERR_DATA_PLUGIN_INVALID            |  Module '%s' is invalid. | 00136
ERR_DATA_PLUGIN_NOT_FOUND          |  Module '%s' cannot be found in the DataPool. | 00137
ERR_PLUGIN_TYPE_INVALID            |  Module '%s' has a wrong type. | 00138
ERR_CHARGED_ZONE_NOT_FOUND         |  The EDR charged zone cannot be found for '%s'. | 00139
INF_NO_UTC_OFFSET                  |  No UTC-Offset. Using default value +00:00 | 00140
INF_ILL_UTC_OFFSET                 |  Illegal UTC-Offset or unknown format. (+-00:00)  | 00141
ERR_IN_RECEIVED_MESSAGE            |  Message %s was invalid. | 00142
ERR_REG_VALUE_INVALID              |  Registry entry '%s' has invalid value '%s'. | 00143
ERR_ZONEMODEL_NOT_CONFIGURED       |  Zone model '%s' has not been configured. | 00144
ERR_ILL_RECORD_TYPE                |  Illegal record type '%s' found. | 00145
ERR_EDR_BUILD_RECORD_NOT_FILLED    |  '%s' - EDR buildt record field not filled. | 00146
ERR_DOUBLE_SEQ_NUMBER              |  Double sequence number found (sequence number: '%s'). | 00147
ERR_GAP_IN_SEQ_NUMBER              |  Gap in sequence number found (start missing sequence number: '%s', end missing sequence number: '%s'). | 00148
INF_MAX_ERROR_RATES_NOT_FOUND      |  No maximal error rates defined. | 00149
ERR_CANNOT_INIT_OUTPUT_MODULE      |  Cannot initialise the output module. | 00150
ERR_EVAL_ENVIRONMENT               |  Cannot evaluate environment '%s'. | 00151
ERR_NO_REQUEST                     |  Request %s returned with no value. | 00152
INF_SEQUENCE_COMMIT                |  New sequence number commited. | 00153
INF_SEQUENCE_ROLLBACK              |  Sequence number rollback. | 00154
INF_NEW_SEQ_NUMBER                 |  New sequence number '%s' for '%s'. | 00155
INF_EDR_NUMBER                     |  The EDR with number '%s' (starting at byteposition: %s) contains the errors : | 00156
INF_STOP_PIPELINE_WAIT             |  Waiting for pipeline '%s' to become inactive after stopping ... | 00158
INF_PIPELINE_NOT_STARTED           |  Pipeline '%s' cannot be started because stop is in progress. | 00159
INF_RECY_FOUND_FILE                |  Found file '%s' for recycling. | 00160
INF_RECY_FILE_MOVE                 |  Move reject file '%s' to '%s' for recycling. | 00161
ERR_RECY_FILE_NOT_MOVED            |  The file '%s' could not be moved to '%s' for recycling. | 00162
INF_RECY_INCOMMING                 |  The %s procedure is now working on the detected file '%s'. | 00163
INF_RECY_LAST_EDR                  |  The last item of the recycle file '%s' is detected. | 00164
ERR_RECY_FILE_NOT_INSERT           |  Could not insert file name '%s' into hash table. | 00165
INF_RECY_START                     |  EDR Recycling Test | 00166
INF_RECY_NO_OF_EDRS                |  Number of process EDRs                    : %s | 00167
INF_RECY_NO_OF_REJ_EDRS            |  Number of rejected EDRs                   : %s | 00168
INF_RECY_NO_OF_ACC_EDRS            |  Number of acceptable EDRs                 : %s | 00169
INF_RECY_REJ_PERC                  |  Reject percentage                         : %s | 00170
INF_RECY_MAX_REJ_PERC              |  Max allowed reject percentage             : %s | 00171
INF_RECY_ACC_CHARGE                |  Accumulated wholesale charge of acc. EDRs : %s | 00172
INF_RECY_ACC_RETAIL_CHARGE         |  Accumulated retail charge of acc. EDRs    : %s | 00173
INF_RECY_ACC_DURATION              |  Accumulated duration of acc. EDRs         : %s | 00174
INF_RECY_REJ_CHARGE                |  Accumulated wholesale charge of rej. EDRs : %s | 00175
INF_RECY_REJ_RETAIL_CHARGE         |  Accumulated retail charge of rej. EDRs    : %s | 00176
INF_RECY_REJ_DURATION              |  Accumulated duration of rej. EDRs         : %s | 00177
INF_RECY_CALC_REJECTION            |  Check MaxErrorRates for %s : desired value (%s) - actual value (%s) = %s | 00178
INF_RECY_CHECK_OK                  |  Check successful. | 00179
INF_RECY_CHECK_NOT_OK              |  Check failed. | 00180
INF_RECY_CHECKS_SUCCESS            |  All checks are successful. File can be recycled. | 00181
INF_RECY_CHECKS_FAILED             |  One or more checks failed. File can't be recycled. | 00182
ERR_RECYTEST_FILE_NOT_COPY         |  The file %s could not copy to %s for test recycling. | 00183
INF_RECYTEST_FILE_COPY             |  Copy reject file '%s' to '%s' for test recycling. | 00184
ERR_INVALID_SOCIAL_NO              |  Invalid social number '%s'. | 00185
INF_START_LOADING_DATA             |  Start data loading from file '%s'. | 00186
INF_FINISHED_LOADING_DATA          |  Finished data loading (%s). | 00187
INF_START_LOADING_DBDATA           |  Start data loading from database table '%s'. | 00188
INF_FINISHED_LOADING_DBDATA        |  Finished data loading (%s). | 00189
ERR_LOADING_ABORTED                |  Loading data aborted after %s records. | 00190
ERR_NO_CUSTOMER                    |  No customer data for cli %s in input record. | 00191
ERR_NO_SUBSCRIBER                  |  No subscriber data for cli %s in input record. | 00192
ERR_NO_CLI                         |  No cli in input record. | 00193
ERR_READING_CONTRACT_PERIOD        |  Can't convert contract period length '%s' for cli %s. | 00194
ERR_READING_SPECIALIST_SYSTEM      |  Can't convert specialist system number '%s' for cli %s. | 00195
INF_BUILDING_CONTRACT_ID_FAILED    |  Can't build contract identifier from '%s' for cli %s. | 00196
ERR_INVALID_DATE                   |  Can't build date '%s' for cli '%s'. | 00197
ERR_INVALID_DATETIME               |  %s. Can't build datetime '%s' for cli '%s'. | 00198
ERR_NUMBER_OF_FIELDS_IN_RECORD     |  Found '%s' instead of '%s' fields in record '%s'%s. | 00199
ERR_LOADING_CUSTOMER_DATA          |  Loading customer data failed. | 00200
ERR_INSERTING_CLI                  |  Error loading cli '%s' (probably duplicated) | 00201
ERR_BUILD_DESC_TREE                |  Error while opening/reading description tree (%s). | 00202
INF_BOOL_FLAG_ACTIVE               |  The flag %s in module %s is set active. | 00203
INF_BOOL_FLAG_INACTIVE             |  The flag %s in module %s is set inactive. | 00204
ERR_DAT_PREFDESC_INS_TREE_FILE     |  Can't insert line %s from file %s into prefix description table. | 00205
ERR_DAT_PREFDESC_INS_TREE_DB       |  Can't insert line %s from table %s into prefix description table. | 00206
ERR_CALLTYPE_NOT_FOUND             |  No calltype found for edr (%s). | 00207
ERR_A_CUSTOMER_NOT_FOUND           |  A-Customer not found (%s). | 00208
ERR_NO_SPLITTING_PERFORMED         |  No splitting performed (spec-sys = %s). | 00209
INF_CALLTYPES_LOADED               |  Calltype definitions loaded (%s). | 00210
INF_CZT_MAP_ENTRYS_LOADED          |  CZT-Mapping entrys loaded (%s). | 00211
INF_DATABASE_OPENED                |  Database '%s' version '%s' opened with user '%s'. | 00212
ERR_CANNOT_OPEN_DATABASE           |  Cannot open database '%s'; user '%s'; password '%s'; server message '%s'. | 00213
ERR_CANNOT_DECRYPT_PASSWORD        |  Cannot decrypt password '%s'; user '%s'. | 00214
ERR_CANNOT_INIT_DB_VERSION         |  Cannot initialise database version, error '%s'. | 00215
ERR_DB_VERSIONS_NOT_FOUND          |  Database versions '%s' not found. | 00216
ERR_DATABASE                       |  Database error '%s'. | 00217
ERR_DB_CONNECTION_MODULE           |  Database connection module is invalid. | 00218
ERR_DEF_IS_INCOMPLETE              |  The field definition '%s' is incomplete. | 00219
ERR_LEN_IS_MISSING                 |  The first item in field definition %s must a number. | 00220
ERR_UNKNOWN_COL_TYPE               |  Unknown colType (%s) in section info. | 00221
ERR_UNKNOWN_ROW_TYPE               |  Unknown rowType (%s) in section info. | 00222
ERR_UNKNOWN_FIELD_NAME             |  Unknown field name (%s) in section info. | 00223
ERR_MISSING_REFERENCE_NAME         |  Missing reference name in block description. | 00224
ERR_REFERENCENAME_NOT_IN_DEF       |  The reference name %s is not in the alias description. | 00225
ERR_SPECIAL_FUNCTIONS_FAILED       |  The routine 'specialFunctions' in pipeline %s failed. | 00226
ERR_BLOCKID_UNKNOWN                |  Can't find an index for id %s. | 00227
WRN_CONTRACT_NOT_FOUND             |  Contract %s not found. | 00228
WRN_CLI_NOT_FOUND                  |  Cli %s not found. | 00229
WRN_DEST_CLI_NOT_FOUND             |  Destination cli %s not found. | 00230
ERR_INSUFFICIENT_MEMORY            |  Insufficient memory available. | 00231
ERR_LOADING_DBTABLE                |  Error while loading database table %s. | 00232
ERR_BLOCK_DESC_NOT_FOUND           |  Block description not found (%s). | 00233
ERR_REC_DESC_NOT_FOUND             |  Record description not found (%s). | 00234
INF_NUM_LINES_READ                 |  %s lines read. | 00235
INF_IGNORE_CLI                     |  Duplicate cli, ignoring %s. | 00236
INF_REPLACE_CLI                    |  Duplicate cli, replacing %s. | 00237
INF_MAP_TABLE_ENTRIES              |  %s mapping table loaded (%s entries). | 00238
ERR_SOURCE_VALUE                   |  Source parameter must be either 'Database' or 'File'. | 00239
ERR_SETUP_CALLTYPE                 |  Failure during setup of calltype table. | 00240
ERR_INVALID_LINE_LENGTH            |  The input line length for record number %s is invalid. | 00241
ERR_RECY_FILE_OPEN                 |  The recycle database file '%s' can't be opening. | 00242
ERR_RECY_FILE_WRITE                |  Couln't write to recycle database file. Try line '%s' to insert. | 00243
ERR_LOADING_TIMEMODEL              |  Loading time model failed '%s'. | 00244
INF_NUM_OF_CAL_ENTRIES             |  %s calendar entries loaded into memory. | 00245
INF_TARIFFMODEL_LOADED             |  Tariff model '%s' loaded. | 00246
INF_NUM_OF_TARIF_LOADED            |  %s tariff models loaded into memory. | 00247
INF_NUM_OF_DAYRATES_LOADED         |  %s dayrates loaded into memory. | 00248
INF_PRICEMODEL_LOADED              |  Price model '%s' loaded. | 00249
INF_NUM_OF_TIMEMODEL_LOADED        |  %s time models loaded into memory. | 00250
INF_LOADING_FCT_PLUGIN             |  Loading function module %s - Version %s. | 00251
INF_UNLOADING_FCT_PLUGIN           |  Unloading function module %s. | 00252
INF_LOADING_DATA_PLUGIN            |  Loading data module %s - Version %s. | 00253
INF_UNLOADING_DATA_PLUGIN          |  Unloading data module %s. | 00254
INF_PREFIX_DATA_NOT_LOADED         |  The data file %s is not accessible.  | 00255
ERR_PREFIX_DATA_NO_DELIM           |  Invalid delimiter count in line %s. | 00256
INF_ACCESS_CODES                   |  Using telephone access codes NAC %s - IAC %s - CC %s - MCC %s - IACS %s - NDC %s | 00257
INF_USED_SPEC_VERSION              |  Using '%s' to check the Specification Version Number. | 00258
INF_USED_RELEASE_VERSION           |  Using '%s' to check the Release Version. | 00259
ERR_EDR_CREATE                     |  Failed to create new EDR container. | 00260
ERR_READING_FILE                   |  Error checking read line. Exception caught in '%s'; %s; %s. | 00261
ERR_VALUE_CONV_FAIL                |  Error converting value(s): %s. | 00262
ERR_INVALID_RECORD_LENGTH          |  Defined RecordLength (%s) does not match length (%s) of read line. | 00263
INF_REPLACE_APPEND_NOT_FOUND       |  Registry entry for replace / append not found. Using default (replace). | 00264
WRN_ILLEGAL_SPECIALDAYRATE         |  Illegal values in special dayrate %s. | 00265
INF_DELETE_OLD_DATA                |  Delete old data from data module %s. | 00266
INF_RELOAD_DATA                    |  Reload data for data module %s. | 00267
INF_LOAD_DATA                      |  Start loading data for data module %s.  | 00268
INF_ADD_DATA                       |  Adding data for data module %s.  | 00269
ERR_DUPLICATE_NUMPORTDATA          |  '%s' Duplicate Number Portability Data found for the CLI '%s' and the Portation TimeStamp '%s'.  | 00270
ERR_SETUP_OUTPUT                   |  Error setup output line. Exception caught in '%s'; %s; %s (line=%s). | 00271
INF_DESTINATION_NOT_FOUND          |  No destination entry for output stream. | 00272
INF_DESTINATION                    |  Using destination '%s' in output stream.  | 00273
INF_SOURCE_NOT_FOUND               |  No source entry for output stream. | 00274
INF_SOURCE                         |  Using source '%s' in output stream.  | 00275
ERR_WRITE_DEF_EDR_NOT_FOUND        |  Registry entry 'WriteDefaultEdr' not found. | 00276
ERR_STR_LEAVING_THREAD             |  Critical stream error. Shutting down pipeline. | 00277
ERR_TARIFF_PLUGIN_INV              |  Tariff model data module invalid. | 00278
ERR_ZONE_PLUGIN_INV                |  Zone model data module invalid. | 00279
ERR_CALENDAR_PLUGIN_INV            |  Calendar data module invalid. | 00280
ERR_TIME_PLUGIN_INV                |  Time model data module invalid. | 00281
ERR_PRICE_PLUGIN_INV               |  Price model data module invalid. | 00282
ERR_EMPTY_CHARGEPACKET_LIST        |  No charge-packets found in charge breakdown record. | 00283
ERR_CUST_FILENAME_EMPTY            |  Empty customer filename specified. | 00284
ERR_CLIMAP_FILENAME_EMPTY          |  Empty cli mapping filename specified. | 00285
ERR_CUG_FILENAME_EMPTY             |  Empty closed usergroup filename specified. | 00286
INF_READING_CALLTYPES              |  Reading calltypes from file %s. | 00287
ERR_CALLTYPE_INVALID               |  Invalid call type: %s: %s. | 00288
WRN_CZTENTRY_INVALID               |  Invalid CZT map entry: %s. | 00289
WRN_ZONEMAP_INVALID                |  Invalid zone map entry: %s. | 00290
WRN_CCENTRY_INVALID                |  Invalid call class map entry: %s. | 00291
ERR_SETUP_CZT_MAPTABLE             |  Error while setting up CZT map table from database. | 00292
INF_LOADING_INPUT_PLUGIN           |  Loading input module %s - Version %s. | 00293
INF_UNLOADING_INPUT_PLUGIN         |  Unloading input module %s.            | 00294
INF_LOADING_OUTPUT_PLUGIN          |  Loading output module %s - Version %s. | 00295
INF_UNLOADING_OUTPUT_PLUGIN        |  Unloading output module %s.            | 00296
INF_ZONE_MAP_LOADED                |  Zone mapping data loaded (%s). | 00297
INF_TIME_STATISTIC                 |  System was started at %s; uptime is %s. | 00298
INF_INPUT_BUFFER_STATUS            |  Input buffer status for pipeline %s    : capacity = %s, entries = %s. | 00299
INF_FUNCTION_BUFFER_STATUS         |  Function buffer status for pipeline %s : capacity = %s, entries = %s. | 00300
INF_OUTPUT_BUFFER_STATUS           |  Output buffer status for pipeline %s   : capacity = %s, entries = %s. | 00301
ERR_REG_LOCK_FILE_EXISTS           |  Registry lock file '%s' already exists. | 00302
WRN_INVALID_CLI_RANGE              |  Ignoring invalid cli range (%s). | 00303
WRN_INVALID_CLI                    |  Ignoring invalid cli %s. | 00304
ERR_RESOLVE_STREAM_NUMBER          |  Failure while resolving stream number for %s. | 00305
INF_READING_CZT                    |  Reading czt mapping definitions from file %s. | 00306
ERR_SETUP_FSM                      |  Failure during setup of finite state machine. | 00307
ERR_FAILURE_FSM                    |  Failure in finite state machine: %s. | 00308
ERR_CON_ATTACHED_FIELD             |  The attached field information has not the right format. Must be BLOCKNAME.FIELDNAME, is %s). | 00309
ERR_NO_ORIGINAL_RECORD             |  Missing the original block. | 00310
INF_SYNC_WITH_OUTPUT               |  Synchronisation between input- and output-module is active. | 00311
ERR_INSERT_HASH                    |  Failure during insert in hash map. | 00312
ERR_INIT_SEG_TARIFF_LINK           |  Failure during initialization of tariff segment link table. | 00313
ERR_NOSP_ID_NOT_FOUND              |  NOSP-Id not found for Frm=%s and AreaCode=%s. | 00314
INF_SEGTARIFF_LNK_LOADED           |  Segment tariff model link table loaded (%s entries). | 00315
ERR_ACTIVATED_DATE_INVALID         |  Contract %s has an invalid activation date. | 00316
INF_REUSE_DB                       |  Reuse the old data. (%s) | 00317
INF_CLEAR_DB                       |  All data were lost. The database is empty. (%s) | 00318
INF_ZONEMODEL_RELOADED             |  Zone model '%s' reloaded. | 00319
ERR_ZONETREE_NOT_FOUND             |  Cannot find digit tree in configuration data for zone model '%s'. | 00320
ERR_ZONEENTRY_NOT_FOUND            |  Cannot find entry in zone model '%s' for origin '%s', destin '%s', call date '%s' and service '%s'. | 00321
ERR_INVALID_DATABASE_VALUE         |  Database value for field '%s' is invalid. | 00322
ERR_PLUGIN_NOT_VALID               |  The module '%s' is invalid and cannot be used. | 00323
INF_USE_CALLCLASS_AS_DEFZONE       |  Using callclass as default zone = %s | 00324
ERR_NO_CUSTOMER_DATA               |  No customer data present. | 00325
ERR_CUSTOMER_DATA_INVALID          |  Invalid customer data. | 00326
ERR_NO_DATABASE_PLUGIN             |  No database plugin present. | 00327
ERR_NO_CUSTOMER_PLUGIN             |  No customer plugin present. | 00328
ERR_INVALID_PLUGIN_STATE           |  Invalid internal module state in %s. | 00329
ERR_MAPPING_TABLE_INVALID          |  The mapping table is invalid. | 00330
ERR_LINK_TABLE_INVALID             |  The link table %s is invalid. | 00331
ERR_NOT_USABLE                     |  The object '%s' is not usable. | 00332
ERR_PIPELINE_NOT_USABLE            |  The pipeline '%s' is not usable; PIPELINE DEACTIVATED; please check the pipeline log for error messages and start the pipeline manually. | 00333
ERR_IN_SECTION                     |  Error in section %s. | 00334
INF_CHANGING_NORMALIZED_NUMBERS    |  Changing normalized numbers = %s | 00335
WRN_EQUAL_TARIFFIND_DATE           |  Both tariff indicators have same date for contract %s. | 00336
INF_SEQ_OUT_OF_RANGE               |  Sequence out of range. Setting sequence to min value. | 00337
INF_OFF_OUT_OF_RANGE               |  Offset out of range. Setting offset to min value. | 00338
UNKNOW_LOGLEVEL                    |  The specified log level is unknown. Valid values are normal, warning, minor, major and critical. | 00339
ACTUAL_LOGLEVEL                    |  The actual log level is %s. All messages with this or higher severity will be logged. | 00340
INF_DELETE_DIALEDDIGITS_IF_CALLCLASS  |  Deleting DialedDigits if CallClass = '%s'. | 00341
WRN_INVALID_ACTIVATED_DATE         |  Invalid activation date, ignoring contract %s. | 00342
INVALID_FORMAT_DESC                |  The format description for '%s' is invalid. | 00343
FORMAT_DESC_IS_INCOMPLETE          |  The format description is incomplete (HEADER, DETAIL, TRAILER). | 00344
INF_NO_EVENTS_DEFINED              |  No events defined in the registry. | 00345
INF_NUM_OF_EVENTS                  |  %s events found in registry. | 00346
INF_CHILD_EXIT                     |  Exit state of child process (%s) was %s. | 00347
INF_CHILD_SIGNAL                   |  Child process (%s) was terminated by signal %s. | 00348
INF_UNKNOWN_CHILD_EXIT             |  Exit state of child process (%s) is unknown. | 00349
INF_CHILD_STARTED                  |  Event (%s) received and process (%s) started.  | 00350
ERR_UNKNOWN_EVENT_TYPE             |  Event %s has unknown event type. | 00351
ERR_SCRIPT_NOT_EXIST               |  Cannot find external program (%s). | 00352
ERR_SCRIPT_NOT_EXE                 |  External program (%s) is not executable. | 00353
ERR_CANNOT_FORK                    |  Cannot create child process.  | 00354
ERR_INCORRECT_FORMAT_OBJ           |  The format description object couldn't be founded or is invalid. | 00355
ERR_CONVERSION_FAILED              |  Edr conversion failed (%s). | 00356
ERR_EDR_ALIAS_NOT_FOUND            |  The specified field alias %s couldn't founded. | 00357
ERR_INDEX_NOT_CREATED              |  Couldn't create the index for alias %s. | 00358
ERR_EDR_BLOCK_NOT_FOUND            |  The specified block alias %s couldn't founded. | 00359
ERR_DOUBLE_ALIAS_NAME              |  The reference to the alias %s exist more than one times. | 00360
ERR_ONLY_ONE_EXTERNAL_DATAFIELD    |  There can be only one external data field for %s. | 00361
ERR_ALIAS_IS_IN_WRONG_BLOCK        |  The alias %s is in the wrong block. | 00362
WRN_INVALID_HISTORY_DATE           |  Contract '%s' has an invalid history date '%s', using '%s' | 00363
ERR_FILE_READ_OS                   |  %s: Error reading from file '%s'. | 00364
ERR_FILE_WRITE_OS                  |  %s: Error writing into file '%s'. | 00365
ERR_FILE_OPEN_OS                   |  %s: Cannot open file '%s'. | 00366
ERR_FILE_MOVE_OS                   |  %s: Cannot move file '%s' to '%s'. | 00367
ERR_FILE_CLOSE_OS                  |  %s: Cannot close file '%s'. | 00368
WRN_FILE_REMOVE_OS                 |  %s: Cannot remove file '%s'. | 00369
ERR_FILE_REMOVE_OS                 |  %s: Cannot remove file '%s'. | 00370
INF_SPECIALIST_SYSTEM_LOADED       |  %s specialist systems loaded. | 00371
INF_SPLITTING_PREFIX_LOADED        |  %s splitting prefix entries loaded. | 00372
INF_SPLITTING_TYPE_LOADED          |  %s splitting types loaded. | 00373
ERR_CONVERSION_BAS_DATE            |  %s could not be converted to BAS_Date. | 00374
ERR_CONVERSION_INT                 |  %s is no valid integer value. | 00375
ERR_LAST_LOAD_RELOAD_FAILED        |  The last load/reload operation has failed. | 00376
ERR_UNKNOWN_SPLITTING_RULES        |  Unknown type of splitting rules `%s'. | 00377
ERR_INVALID_FCI_COLL_ORDER         |  Invalid order of FCI collection entries (%s). | 00378
ERR_INVALID_FCI_COLL_ENTRIES       |  Invalid number of FCI collection entries (%s). | 00379
ERR_INVALID_SEQ_VALUE              |  The configuration value for %s is invalid (%s). | 00380
ERR_OFF_MIN_GREATER_MAX            |  The min offset is greater than the max offset. | 00381
ERR_SEQ_MIN_GREATER_MAX            |  The min sequence number is greater than the max sequence number. | 00382
ERR_SEQ_ENTRY_NOT_FOUND            |  Cannot find entry "%s" in the sequence control file. | 00383
ERR_NO_SEQ_VALUE                   |  Sequence field "%s" in sequence control file has no value. | 00384
ERR_SEQ_MASTER_CONTROLLER          |  Unknown or wrong master controller for sequence sharing. | 00385
ERR_NOT_USABLE_REASON              |  Module is not usable: %s. | 00386
INF_INTERPRETER_LOG_PIPELINE       |  %s | 00387
INF_LOADING_SCRIPT                 |  Loading script %s. | 00388
INF_COMPILED_SCRIPT                |  Compiled %s lines successfully. | 00389
ERR_CREATE_SCRIPT                  |  Error loading script %s: %s. | 00390
ERR_INIT_TSC_MAPTABLE              |  Failed to init map table: %s. | 00391
ERR_NO_DEFAULT_SENTENCE            |  There is no default sentence defined in the format description. | 00392
ERR_UNKNOWN_DEFAULT_SENTENCE       |  Output Stream %s : The default line couldn't be identified. Check your format description. | 00393
ERR_DEFAULT_WITH_WRONG_ID          |  Output Stream %s : The default block has a wrong id. Check your format description. | 00394
ERR_SEGMENT_NOT_DEFINED            |  No segment defined for `%s`. | 00395
ERR_REDO_POOL_ENTRY_NOT_FOUND      |  Redo pool entry '%s' not found in function pool. | 00396
ERR_CUST_FILE_VERSION              |  Illegal customer file version %s. | 00397
ERR_STREAM_TO_EDR_FAILED           |  Stream to EDR conversion failed. EDR container created, but not written to input buffer. | 00398
ERR_INVALID_INPUT_RECORD           |  Check length, numeric values or date fields for their correctness. (record:%s) | 00399
ERR_UNKNOWN_ALIGNMENT              |  Unknow alignment text in %s. It set to left. | 00400
ERR_LINE_NOT_IDENTIFIED            |  The line couldn't identified: %s | 00401
ERR_CHARGE_ITEM_INVALID            |  ChargeItem %s invalid. | 00402
ERR_MISSING_VALUES_FOR_FIELD       |  Find a reference field entry without id's in block %s. | 00403
ERR_MISSING_REFERENCE_FIELD        |  Find some container references without a field reference in block %s. | 00404
ERR_DEFAULT_BLOCK_NOT_FOUND        |  The specified default block name %s doesn't exist in the description. | 00405
ERR_DATA_INVALID                   |  The data in field %s in invalid. | 00406
INF_NO_OUTPUT_BLOCK                |  %s can't be used as a output block. Check the registry entries: ReferenceField and ContainerID. | 00407
ERR_VERSION_CHECK_FAILED           |  Version check for database '%s' and '%s' failed. | 00408
INF_VERSION_CHECK_DISABLED         |  Version check for database '%s' disabled. | 00409
ERR_DB_VERSION_CHECK               |  Wrong database version. Please check module and database version. | 00410
ERR_DB_CONNECTION_NOT_VALID        |  Could not connect to database. %s  | 00411
ERR_DUPLICATE_IRULE_PARAMETER      |  Duplicate iRule parameter '%s' found in file '%s'. | 00412
ERR_PARAMETER_FILE_INVALID         |  The iRule parameter file '%s' has an invalid format. | 00413
ERR_MULTIPLE_RESTART_FILES         |  Found more than one restart file in directory '%s'. | 00414
ERR_DB_COMMIT_TRANSACTION          |  Cannot commit database transaction '%s'. | 00415
ERR_DB_STATEMENT_EXECUTE           |  Cannot execute database statement '%s', message '%s'. | 00416
ERR_DB_NUMBER_OF_ROWS              |  Statement '%s' does not return exactly one row. | 00417
WRN_NO_VALID_ENTRY                 |  Entry '%s' in file '%s' is invalid and ignored. | 00418
INF_CURSOR_OPENED                  |  The database stream '%s' was opened. | 00419
INF_CURSOR_CLOSED                  |  The database stream '%s' was closed. | 00420
ERR_MODULE_NOT_EXIST               |  The module '%s' which was configrated as an event originator does not exist. | 00421
INF_DB_INPUT_STR_STATEMENT         |  Executed SQL '%s'-statement was '%s'. | 00422
ERR_SETUP_INPUT_GRAMMAR            |  Input grammar setup failed: %s | 00423
ERR_SETUP_OUTPUT_GRAMMAR           |  Output grammar setup failed: %s | 00424
ERR_CREATE_INPUT_PARSER            |  Failed to create input parser: %s | 00425
ERR_CREATE_OUTPUT_PARSER           |  Failed to create output parser: %s | 00426
ERR_CREATE_INDEX                   |  EDR index creation failed: %s | 00427
ERR_CREATE_ALIAS_MAP_INDEX         |  No AliasMap entry found for Reference '%s' and logical Name '%s'. | 00428
ERR_GETTING_DATADESCR              |  Failed to get the data description. | 00429
ERR_GRAMMAR_SYMBOL_LOOKUP          |  Symbol lookup for `%s' failed: %s | 00430
WRN_NO_ENDTRANSACTION              |  A beginTransaction arrives before the endTransaction in %s. | 00431
ERR_NO_EDRFACTORY                  |  Can't get the factory to create EDRs in %s. | 00432
ERR_PARSE_DESCRIPTIONS             |  Failed to parse EDR description: %s | 00433
INF_UNITS_PER_TRANSACTION_NOT_FOUND |  Registry entry units per transaction not found: %s | 00434
ERR_TAM_ENTRY_NOT_FOUND            |  Cannot find entry "%s" in the transaction manager map. | 00435
ERR_TAM_ENTRY_NOT_REMOVED          |  Cannot remove entry "%s" from the transaction manager map. | 00436
ERR_TAM_STREAM_NOT_FOUND           |  Cannot find stream name "%s" for transaction id "%s". | 00437
ERR_TAM_FILE_WRITE_ERR             |  Error writing into binary transaction log file '%s', message '%s'. | 00438
ERR_TAM_FILE_READ_ERR              |  Error reading from binary transaction log file '%s', message '%s'. | 00439
ERR_TAM_ABORT_REQUESTED            |  Abort requested for transaction manager '%s'. | 00440
ERR_TAM_INIT_FAILED                |  Failed to init transaction manager '%s'. | 00441
ERR_DOUBLE_TRANSACTION_ID          |  Double transaction id '%s' found. | 00442
ERR_DOUBLE_TRANS_MODULE            |  Transaction module '%s' was attached more than once. | 00443
ERR_TRANS_ID_REG_ENTRY_NOT_FOUND   |  Registry entry '%s' not found in transaction id information file '%s'. | 00444
ERR_TRANS_ID_REG_INVALID_VALUE     |  Invalid value '%s' for '%s' in transaction id information file '%s'. | 00445
ERR_COMMIT_TRANSACTION             |  Module '%s' failed to commit transaction '%s'. | 00446
ERR_CANCEL_TRANSACTION             |  Module '%s' failed to cancel transaction '%s'. | 00447
ERR_ROLLBACK_TRANSACTION           |  Module '%s' failed to rollback transaction '%s'. | 00448
INF_BEGIN_TRANSACTION              |  Transaction '%s' started. | 00449
INF_COMMIT_TRANSACTION             |  Transaction '%s' committed. | 00450
INF_CANCEL_TRANSACTION             |  Transaction '%s' canceled. | 00451
INF_ROLLBACK_TRANSACTION           |  Transaction '%s' rolled back. | 00452
ERR_EDR_FACTORY_NOT_FOUND          |  EDR-Factory '%s' not found. | 00453
INF_FILE_EXIST                     |  File '%s' exist and is writable. | 00454
ERR_FILE_EXIST                     |  File '%s' exist. | 00455
ERR_FILE_NOT_FOUND                 |  File '%s' not found. | 00456
ERR_INVALID_REJECT_STREAM_NUMBER   |  Stream number is out of range. | 00457
ERR_REJECT_STREAM_NOT_DEFINED      |  Reject-stream not defined in '%s'. | 00458
ERR_ROLLBACK_FAILED_INPUT          |  Rollback failed in input-controller. | 00459
ERR_CANCEL_FAILED_INPUT            |  Cancel failed in input-controller. | 00460
ERR_ADD_DATABLOCK                  |  Cannot add Datablock '%s' to EDR-C. | 00461
INF_EDR_FIELD_NAME                 |  Using EDR-C field '%s' for logical field '%s'. | 00462
INF_EDR_BLOCK_NAME                 |  Using EDR-C block '%s' for logical block '%s'. | 00463
ERR_INPUT_MAPPING_FAILED           |  Input mapping `%s' failed: %s. | 00464
ERR_CREATE_EDR_INDEX               |  EDR index creation failed: %s (name=`%s', key=`%s' and reference=`%s'). | 00465
ERR_ZONEMODEL_NOT_FOUND            |  Zonemodel-Id (%s) not found in zone data-module. | 00466
ERR_RATEPLAN_NOT_FOUND             |  Rateplan '%s' not found in rateplan data-module. | 00467
ERR_NO_EVENTHANDLER_FOUND          |  Eventhandler not found in module '%s'. | 00468
ERR_OUTPUT_MAPPING_FAILED          |  Output mapping failed: %s. | 00469
INF_EDR_HAS_ERROR                  |  '%s' has errors -> rollback is demanded (Transaction: '%s')" | 00470
ERR_PARSE_ERROR_STREAM             |  Parse error on input stream: %s. | 00471
ERR_PARSE_ERROR_DATA               |  Parse error on plugin data: %s. | 00472
ERR_RECY_CANCEL_FAILED             |  PreRecycle: Failed to cancel transaction '%s'. Cannot find stream name '%s' in the recycle map. | 00473
ERR_RECY_ROLLBACK_FAILED           |  PreRecycle: Failed to rollback transaction '%s'. Cannot move file '%s'. | 00474
ERR_RECY_CANNOT_SET_ITEM_TYPE      |  PreRecycle: Cannot set the transaction item type for transaction '%s'. | 00475
INF_RECY_DELETE_TMPINPUT_FILE      |  PreRecycle: Temporary input file '%s' deleted. | 00476
ERR_RECY_DELETE_TMPINPUT_FILE      |  PreRecycle: Cannot delete temporary input file '%s'. | 00477
ERR_CORBA_EXCEPTION                |  CORBA exception: %s. | 00478
ERR_TRANSFER_CUTOFF_VIOLATED       |  TransferCutOff Date (%s) violated with %s. | 00479
ERR_INVALID_RECORD_NUMBER          |  Invalid number of records: %s, counted: %s. | 00480
ERR_INVALID_FIRST_CALL_TIMESTAMP   |  Invalid first call timestamp: %s, calculated: %s. | 00481
ERR_INVALID_LAST_CALL_TIMESTAMP    |  Invalid last call timestamp: %s, calculated: %s. | 00482
ERR_SETUP_EDRFACTORY               |  EDR factory setup failed: %s. | 00483
ERR_CUST_A_VALUE_NOT_FOUND         |  Missing value for field '%s' of Customer A | 00484
ERR_CUST_A_IDENTIFICATION_UNKNOWN  |  Customer identification technique for used service ('%s') not found | 00485
WRN_NO_SEQUENCE_NUMBER_ADDEDTO_TRANSACTION  |  No new sequencenumber generated for sequence. | 00486
ERR_CONTROLLER_HAS_WRONG_TYPE      |  Pipeline controller has wrong type in '%s'. | 00487
ERR_CONTROLLER_CONFIGURATION       |  Pipeline controller configuration has error in '%s'. | 00488
ERR_INIT_EDR_ITERATOR              |  Failed to initialize edr iterator for `%s'. | 00489
ERR_TAP3_RET                       |  TAP3 return: sev(%s), errCode(%s), tag(%s), depth(%s), offset(%s), arrayIdx(%s), oprtmsg(%s), ruleID(%s). | 00490
ERR_CIBER_RET                      |  CIBER return: retReason(%s), retCode(%s), fieldId(%s), ruleID(%s). | 00491
ERR_INPUT_REQUEST_ROLLBACK         |  The input has requested a rollback (reason=%s). | 00492
INF_SEQ_CHECK_GENERATION           |  Sequence generation and check can not be configured in one sequencer for '%s'! | 00493
WRN_CANNOT_DETERMINE_OUTSTREAMNAME |  Can not determine the output-filename for streamname '%s'. | 00494
ERR_WRITE_FILE                     |  Can not create/write file '%s'. | 00495
ERR_INCORRECT_FILLER_LENGTH        |  Invalid record Filler length, expected: '%s', received: '%s'. | 00496
ERR_CANNOT_JOIN_EVENT_HANDLER_PROC |  Cannot connect to event handler process: %s | 00497
INF_TRANSACTION_ROLLBACK_DEMANDED  | Rollback demanded for transaction '%s'. | 00498
INF_TRANSACTION_CANCEL_DEMANDED    | Cancel demanded for transaction '%s'. | 00499
INF_TRANSACTION_REDOCANCEL_DEMANDED| Redo cancel demanded for transaction '%s'. | 00500
WRN_NO_STREAMLOG_DEFINED           | Stream log not defined. | 00501
ERR_CANNOT_FIND_EVENT_HANDLER_PROC | Cannot locate the event handler daemon! | 00502
INF_THREAD_CREATED          	   | Thread instance ID '%s'; and Name '%s'. | 00503
ERR_CAN_NOT_GET_FACTORY            | Cannot get factory '%s'. | 00504
ERR_DD_NOT_READ                    | Cannot read the data dictionary. | 00505
ERR_PCM_ERROR                      | PCM Error: err: %s field: %s loc %s errclass: %s rec_id: %s resvd: %s resvd2: %s  - %s | 00506
ERR_SYSCATALOG_ENTRY_NOT_FOUND     | System catalog entry '%s' not found | 00507
ERR_INDEX_NOT_FOUND                | Container index not found. | 00508
ERR_THREAD_STACKSET_FAILED         | Failed to set stack size of thread | 00509
ERR_DB_START_TRANSACTION           | Error starting database transaction: '%s' | 00510
ERR_MEM_MON_PROCESS_LIMIT          | %sReached process size limit.  Size: %s KB, limit: %s KB | 00511
ERR_MEM_MON_MEMORY_LIMIT           | %sReached specified memory usage limit.  System Usage: %s KB, System Limit: %s KB | 00512
INF_TXNBATCHING_ON                 | Transaction batching is on. | 00513
WRN_TXNLOGGING_OFF                 | Transaction logging is off, make sure that you are doing testing only! | 00514
INF_TXNTIMEOUT_ON                  | Transaction timeout is on, it is '%s' milisecond. | 00515
INF_PROC_TIME_STATISTICS	   | Plugin processing time statistics: '%s' |00516
ERR_CANNOT_GET_DMT_DMCONNECTION    | %s: Cannot get a DMT::DMConnection | 00517
ERR_XML_PARSE_SAX        	   | Exception parsing XML: Line: %s Column: %s: %s | 00518
ERR_XML_PARSE_XML        	   | Exception parsing XML: %s | 00519
ERR_XML_PARSE_EDR        	   | Exception parsing XML: near Attribute: %s: %s | 00520
ERR_XML_PARSE_UNKNOWN    	   | Unknown exception parsing XML | 00521
ERR_INIT_XERCES                    | Error: Xerces-c Initialization. Exception message: %s | 00522
ERR_XML_INPUT_MAPPING_FAILED       | EDR XML generation failed: Input mapping `%s' failed: %s. | 00523
INF_TXN_ROC_AND_TRANSIENT_COMMIT_BATCHING_ON | Batching for transactions involving ROC and/or transient objects only is on. | 00524
INF_CANCEL_TRANSACTION_DEMANDED    | Transaction '%s' cancel demanded by '%s'- '%s'. | 00525
INF_ROLLBACK_TRANSACTION_DEMANDED  | Transaction '%s' rollback demanded by '%s'-'%s'. | 00526
INF_HIGH_AVAILABILITY              | Info for High Availability: '%s' | 00527
ERR_PREPARE_COMMIT_TRANSACTION     | Module '%s' failed to prepare commit transaction '%s'.  | 00528
ERR_USR_PROCESS_KILLED             | Killed external process '%s' after it timed out.  | 00529
INF_NO_WAITTIME_DEFINED            | TimeToWait parameter is not defined for events in '%s', default to 0.  | 00530
INF_PROCTIME_INSTRUMENTATION       | ProcTime instrumentation is %s  | 00531
INF_SERVER_TYPE                    | Server type is '%s'. | 00532
ERR_NO_INDEX                       | Index '%s' not found. | 00533
INF_HA_ROLE                        | High availability role is: %s | 00534
INF_HA_STATE                       | High availability state is: %s | 00535
ERR_INVALID_HA_ROLE                | The peer instance has already assumed the %s role | 00536
INF_IPC_BUFFER_STATUS              | IPCQueues buffer status for queue %s    : capacity = %s, entries = %s. | 00537
ERR_INSUFFICIENT_SEGMENTSIZE       |  Segment size specified in timos registry is too small. Please increase the Segment size and restart timos | 00538
ERR_FLIST_INPUT_ERROR              | Error while processing FLIST message: %s | 00539
ERR_DIAMETER_INPUT_ERROR           | Error while processing DIAMETER message: %s | 00540
ERR_MBI_INPUT_ERROR                | Error while processing MBI message: %s | 00541
ERR_UNLINK_FILE_ERROR              | Error %s while attempting to unlink of temp file: %s | 00542
ERR_OPEN_FILE_ERROR                | Error %s while attempting to open of temp file: %s | 00543
ERR_WRITE_FILE_ERROR               | Error %s while attempting to write of temp file: %s | 00544
ERR_CLOSE_FILE_ERROR               | Error %s while attempting to close of temp file: %s | 00545
ERR_RENAME_FILE_ERROR              | Error %s while attempting to rename of temp file: %s | 00546
ERR_TXN_TIMEOUT                    | Timeout while waiting for the next request in a transaction: %s | 00547
ERR_RELEASE_OBJ_LOCK               | Error while releasing lock for object: %s | 00548
INF_POID_STATISTIC                 | Processing time: '%s', opcode call time: '%s'. | 00549
ERR_REPLENISH_POID_CACHE_FAILED	   | Error while processing poids: %s. | 00550
INF_HA_HEALTH			   | High availability Health is: %s | 00551
INF_PROCTIME_DETAIL                | ProcTime detailed instrumentation is %s  | 00552
INF_PROCESS_SIGNAL		   | Signal received %s. | 00553
ERR_PROCESS_EXIT		   | Attempt to exit process due to signal. | 00554
INF_BULK_DATA_SYNC_STARTED		   | Bulk Data Synchronization started. | 00555
INF_BULK_DATA_SYNC_QUEUE_COMPLETE  	   | Bulk Data Synchronization queueing complete. | 00556
INF_BULK_DATA_SYNC_COMPLETED	   | Bulk Data Synchronization completed. | 00557
ERR_BULK_DATA_SYNC_ABORTED  	   | Bulk Data Synchronization aborted. %s | 00558
INF_BULK_DATA_SYNC_QUEUE_IN_PROGRESS  	   | Bulk Data Synchronization queueing is in progress. | 00559
ERR_DELETION_ASS_CBD_FAILURE       | Failure in deleteion of ASS_CBD block. | 00560
ERR_DELETION_CP_FAILURE            | Failure in deleteion of CP block. | 00561
ERR_DELETION_TP_FAILURE            | Failure in deleteion of TP block. | 00562
INF_FRAMEWORK_STATE_CHANGE         | Framework state transition from '%s' to '%s'. | 00563
ERR_CONNECT_REJECTED               | Connect from '%s' rejected | 00564
INF_TIMOS_STATE_CHANGE             | TIMOS state transition from '%s' to '%s'. | 00565
ERR_INCORRECT_FILE_NAME_SPECIFICATION      | Error encountered in building the output filename from the given specification: '%s' for the input file - '%s'. Defaulting to regular file naming technique for this file . | 00566
ERR_IGNORE_REGISTRY_ENTRY             | Registry entry - Name : '%s' Value : '%s' is ignored %s | 00567
ERR_START_OVERLOAD_DETECTION       | Failed to start/restart overload detection, %s. | 00568
ERR_ZONE_VALUE_NOT_FOUND           | ZoneValue not found for ZM-Id=%s, Date=%s, SC=%s, A#=%s, B#=%s. | 00569
ERR_SESSION_PUT_ON_HOLD            | Session %s is put on hold due to being passive. | 00570
ERR_SESSION_REJECTED               | Session %s is rejected due to being passive.  | 00571
INF_WAIT_PIPELINE_START            | Waiting for pipeline '%s' to start ... | 00572
INF_REBALANCE_CONNECTION           | Rebalance existing server connection <%s>. | 00573
INF_ADD_SERVER_INSTANCE            | Add server instance '%s'. | 00574
INF_REFRESH_SERVER_INSTANCE        | Refresh server instances. | 00575
ERR_INVALID_TOKEN_COUNT            | Number of HA role mediator token should be one but found %s. | 00576
ERR_TOKEN_READ_FAILED              | Failed to read HA role mediator token. | 00577
ERR_SHUTDOWN_FAIL_TO_COMPLETE      | Shutdown request fails to complete. | 00578
INF_HOT_STANDBY_QUEUE_FULL         | Hot standby queue is full. | 00579
ERR_TOKEN_UPDATE_FAILED            | Failed to update HA role mediator token. | 00580
ERR_TOKEN_ACCESS_TIMEOUT           | Timeout while accessing HA role mediator token for read or update. | 00581
INF_TOKEN_ACCESS_RETRY             | Retry accessing HA role mediator token for read or update. | 00582
INF_HOT_STANDBY_STATE              | Hot standby state '%s'. | 00583
INF_HOT_SYNC_STATE                 | Hot synchronization state '%s'. | 00584
ERR_INVALID_TOKEN_DB_NO            | Invalid HA role mediator token db number.  Found %s and expected to be %s. | 00585
ERR_TRACEPOINTS_CONFIGURATION	   | TraceEndPoint is less than TraceStartPoint | 00586
ERR_TRACE_START_POINT_NOT_FOUND    | TraceStartPoint not found | 00587
ERR_EDRTRACE_STREAMLOG_CREATION_FAIL | Error in EDR trace stream log creation | 00588
ERR_PLUGIN_NOT_FOUND		   | Invalid plugin name : '%s' | 00589
ERR_SYSTEM_ERROR		   | Unexpected error, errno '%s' '%s' '%s' | 00590
WRN_REG_ENTRY_OBSOLETE             | Obsolete registry entry: %s | 00591
ERR_TAP3_FATAL                     | TAP3 Fatal: Field Name: %s, Tag: %s, Error Code: %s, Description: %s | 00592
ERR_TAP3_SEVERE                    | TAP3 Severe: Field Name: %s, Tag: %s, Error Code: %s, Description: %s | 00593
ERR_TAP3_WARNING                   | TAP3 Warning: Field Name: %s, Tag: %s, Error Code: %s, Description: %s | 00594
ERR_DIR_NOT_WRITEABLE              | Directory "%s" is not writable. | 00595
INF_NOT_INSTANTIATING_PIPELINE_COLLECTION | Not instantiating the pipeline collection, please make sure that this is the desired configuration. | 00596
INF_NOT_COPYING_SDS_PRIME          | Not copying SDS' to SDS, please make sure that this is the desired configuration. | 00597
INF_BACKEND_OFF                    | The event post processing backend is disabled. | 00598
INF_TXN_ROC_AND_TRANSIENT_COMMIT_BATCHING_FORCED_OFF | Not updating batching for ROC and/or Transient transactions when there is transaction log writing. | 00599
INF_SYSTEM_STARTUP                 | The system is starting up. | 00600
ERR_CREATE_INSTANCE                | Error creating instance of "%s". | 00601
INF_SYSTEM_READY                   | The system is ready to process data. | 00602
INF_SHUTDOWN                       | Received MSG_SHUTDOWN, aborting processing. | 00603
ERR_BAD_SCHEMA_SOURCE              | Bad schema source: %s. | 00604
INF_TRANSACTION_CANCEL_ALL_DEMANDED | Cancel demanded for all transactions in Pipeline '%s'. | 00605
ERR_REG_NAME_NOT_FOUND_SETTING_DEFAULT | Registry name '%s' not found. Setting default value of '%s'. | 00606
ERR_REG_VALUE_INVALID_SETTING_DEFAULT | Registry entry '%s' has invalid value . Setting default value of '%s'. | 00607
ERR_MODULE_NOT_FOUND| Module '%s' defined to be load dependent on '%s' is not found.| 00608
INF_CALCULATED_THREAD_COUNT| The ParallelLoadManager has calculated '%s' as the maximum possible number of threads required for parallel loading of %s. | 00609
INF_LOAD_STARTED | Loading of '%s' started: Thread id '%s'. | 00610
INF_LOAD_DONE | Loading of '%s' completed: Thread id '%s'. | 00611
INF_PARALLEL_LOADING_ENABLED | Parallel loading has been enabled. | 00612
INF_PARALLEL_LOADING_DISABLED | Parallel loading has been disabled %s. | 00613
INF_BATCH_LOAD_STARTED | Loading of batch '%s' started. | 00614
INF_BATCH_LOAD_DONE | Loading of batch '%s' completed. | 00615
ERR_PARALLEL_INIT_FAILED | Parallel initialization of '%s' failed. | 00616
INF_MODE_SET_FROM_REG | Mode set as '%s' in the registry. This value has been given priority. | 00617
ERR_CALCULATE_SPAN | Error in calculating span. | 00618
INF_PARALLEL_INIT_STARTED | Parallel initialization of '%s' started. | 00619
INF_PARALLEL_INIT_FINISHED | Parallel initialization of '%s' finished. | 00620
ERR_ACQUIRE_GUARD_FAILED | Acquiring guard for '%s' failed. | 00621
ERR_FIELD_TYPE_MISMATCH  | Field type mismatch for field '%s' defined as type '%s'. Expected '%s'.| 00622
INF_OUTPUT_MULTITHREADED_STATUS | '%s' | 00623
INF_PIPELINE_NOT_MULTITHREADED | '%s' | 00624
INF_THREAD_COMPLETED | '%s' thread with id = '%s' completed. | 00625
ERR_EDR_FACTORY_CREATION_FAILED | '%s' | 00626
INF_THREAD_COMMENCE | '%s' thread with id = '%s' started. | 00627
ERR_REG_MULTIPLICATION_FAILED | The registry multiplication for the block '%s' failed. Reason: '%s' | 00628
ERR_FILE_TRUNCATE_FAILED           |  Truncate failed for the file %s. | 00629

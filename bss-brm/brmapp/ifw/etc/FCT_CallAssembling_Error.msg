INF_CALLS_ASSEMBLED          | %s splitted calls assembled.                       |  15401
INF_CALLS_FLUSHED            | %s unfinished calls older than %s days flushed.    |  15402
INF_CALLS_REMOVED            | %s closed calls older than %s days removed.        |  15403
INF_AWAIT_ALL_CDRS           | AwaitAllCDRs = %s.                                 |  15404
INF_ASSEMBLE_VOLUME_DATA     | AssembleVolumeData = %s.                           |  15405
INF_CALL_DUR_TOLERANCE       | CallDurationTolerance = %s                         |  15406
INF_KEEP_CALL_OPEN           | KeepCallOpen Semaphore = %s.                       |  15407
INF_SELECTIVE_FLUSH          | FlushServiceCode Semaphore = %s.                   |  15408
ERR_CHAIN_REFERENCE_MISSING  | Chain reference is missing.                        |  15409
ERR_SPURIOUS_MESSAGE         | Ignoring spurious message %s.                      |  15410
ERR_EMPTY_MESSAGE            | Reject Message %s is missing arguments.            |  15411
ERR_NO_CHAIN_REFERENCE       | Chain reference is missing in message %s.          |  15412
ERR_INVALID_STATE_INDICATOR  | State %s is unexpected.                            |  15413
ERR_INVALID_CHAIN_REFERENCE  | Could not find data for chain reference %s.        |  15414
ERR_REJECTED_EDR_NOT_IN_WORKFILE | The rejected edr is no longer in workfile. Chain reference= '%s', LongDurationIndicator= '%s', StartTimestamp= '%s'                      |  15415
ERR_EDR_ALREADY_CLOSED           | The edr with the following chain reference is already closed: Chain reference= '%s', LongDurationIndicator= '%s', StartTimestamp= '%s'   |  15416
ERR_UNKNOWN_WORKFILE_VERSION     | Cannot read workfile: %s - because of unknown version#: %s                       |  15417
ERR_NOT_CA_WORKFILE              | File: %s is not a Call Assembling workfile.                                      |  15418
ERR_EDR_FILE_DOESNT_EXIST    | EDRFile::initialize() failed because file: '%s' does not exist.                      |  15421
ERR_BAD_EDR_FILE_STREAM      | std::fstream operation has failed for file: '%s'                                     |  15422
ERR_CANNOT_CLEANUP_EDR_FILE  | cannot remove file: '%s' during EDRFileManager::cleanupEDRFiles() operation.         |  15423
ERR_EDR_FILE_NOT_INDEXED     | the following file: '%s' is referenced, but not available in the EDR file index.     |  15424
ERR_CANNOT_CREATE_INDEX_FILE_STREAM   | unable to create the EDR index std::fstream for file: '%s'                  |  15425
ERR_UNABLE_TO_SERIALIZE_INDEX_ITEM   | unable to serialize an index item to the EDR index file named: '%s'          |  15426
ERR_CANNOT_OPEN_INDEX_FILE_STREAM    | unable to open the EDR index std::fstream for file: '%s'                     |  15427
ERR_INDEX_FILE_RENAME_FAILED    | unable to rename tmp to index file: '%s' during IndexFile::commitFile() operation.|  15428
ERR_VALID_DETAIL_DURING_FLUSH   | during flush operation, the restored EDR with CHAIN_REFERENCE==%s does not pass the isValidDetail() test.     |  15429
ERR_INVALID_TRANSID_IN_REJECT_MSG | The transaction id sent by FCT_Reject to FCT_CallAssembling is invalid: '%s'.   |  15430 
ERR_CALL_MISSING_FROM_DELETION_VECTOR | The rejected call '%s' is missing from the CallDeletionVector.              |  15431
ERR_MULTI_CALL_SECTION_MISSING_ELEMENTS | The MultiDataElementCallSection is missing DataElements.                  |  15432
ERR_FLUSH_LIMIT_IN_PROGRESS | Error: semaphore FlushLimit=%s is already in progress, FlushLimit must complete before sending UpgradeFlushLimit. | 15433
ERR_UPGRADE_FLUSH_LIMIT_IN_PROGRESS | Error: semaphore UpgradeFlushLimit=%s is already in progress, UpgradeFlushLimit must complete before sending FlushLimit. | 15434
ERR_PRODUCING_DEFAULT_EDR | Error: cannot produce default EDR for container '%s' during a flush operation. | 15435
ERR_CANNOT_FIND_DEFAULT_OUTPUT_STREAM | Cannot lookup the defaultOutputStream during an UpgradeFlushLimit semaphore. Attempted location: %s | 15437
ERR_CREATING_CONTAINER_INDEX | Unable to create DETAIL container index from EDRFactory. | 15438
ERR_RECYCLED_CALL_RECORD_MISSING | Error, CallRecord missing for recycled call, '%s'. | 15439
ERR_RECYCLED_EDR_NOT_FOUND_IN_MAP | Error, RecycleRequest failed for chain ref '%s'. | 15440
ERR_REJECT_CALL_RECORD_MISSING | Error, finding CallRecord during FCT_Reject AssemblyLogic lookup request. '%s' | 15441
ERR_DELETION_MISSING_CALL_RECORD | Error, expected CallRecord missing from map during CallDeletionVector cleanup. '%s' | 15442
ERR_RESTORE_ASSEMBLY_LOGIC_FAILED | Error, unable to restore AssemblyLogic in CallRecord::restore() | 15443
ERR_UNUSED_EDRS_IN_PROCESS_RESULT | Error, un-used edrs remaining in the destructed ProcessResult object. | 15444
ERR_INCLUSIVE_LOGIC_TOO_MANY_ACTIVE_CALL_SECTIONS | Error InclusiveLogic, SingleElementCallSection has too many ACTIVE CallSections.  | 15445
ERR_INCLUSIVE_LOGIC_FLUSHZONE_OUT_OF_POSITION | Error InclusiveLogic, Flushzone is out-of-position. | 15446
ERR_INCLUSIVE_FLUSHZONE_LOGIC | Error InclusiveLogic, Errant Flushzone for ChainReference '%s'. | 15447
ERR_MISUSE_VIRTUAL_FUNCTION | Error, virtual function '%s' is not allowed. | 15448
ERR_LATEPARTIAL_EDR  | Late EDR received and marked invalid; chain reference = %s. | 15449
ERR_REJECT_CALL_SECTION_MISSING | Error, finding CallSection during FCT_Reject notification request. ChainRef='%s' StartTime='%s' | 15450
INF_MAX_DURATION  | MaxDuration = %s. |  15451
INF_CALLS_RESTORED  | %s calls restored | 15452
INF_CALLS_UPGRADED  | %s calls upgraded | 15453
INF_CALL_ASSEMBLY_MODE | CallAssembly is running in MODE:%s  |  15454
ERR_UPGRADE_MODE_FAILURE | CallAssembly Error while Upgrading EDR with ChainRef=%s and StartTime=%s  | 15455
ERR_DOM_EXCEPTION | DOMException caught in %s: Message=%s  | 15456
ERR_SAX_EXCEPTION | SAXException caught in %s: Message=%s  | 15457
ERR_XML_EXCEPTION | XMLException caught in %s: Message=%s  | 15458
ERR_XML_MEMORY_EXCEPTION | Xerces OutOfMemoryException caught in %s: Message=%s  | 15459
ERR_XML_IMPORT_FILE_MISSING | Unable to process ImportDataFromXml semaphore because supplied XML file '%s' is missing. | 15460
INF_CALLS_EXPORTED_TO_XML  | %s calls succesfully exported to XML. | 15461
INF_CALLS_IMPORTED_FROM_XML  | %s calls succesfully imported from XML | 15462
ERR_F_SEGMENT_ALREADY_RECEIVED | Error : An F segment has been already received with the same chain reference| 15463
ERR_L_SEGMENT_ALREADY_RECEIVED | Error : An L segment has been already received with the same chain reference| 15464

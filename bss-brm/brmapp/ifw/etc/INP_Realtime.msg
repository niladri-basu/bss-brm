#=================================================================
# Portal Pipeline Server INP::Realtime Messages
#
# Number Range: 10801-10900
#----------------------------------------------------------------
# Note: Add only numbers inside the allocated range.
#       Do not change existing numbers.
#=================================================================
# 01-July-2004: Initial version
#=================================================================

ERR_REALTIME_MISSING_OPCODE_LIST       | RealtimePipeline: XML element list <OpcodeMap> missing in xml file: %s        | 10801
ERR_REALTIME_MISSING_OPCODE_NODE       | RealtimePipeline: XML element <OpcodeMap> missing in xml file: %s             | 10802
ERR_REALTIME_MISSING_INPUT_MAP_LIST    | RealtimePipeline: XML element list <InputMap> missing in xml file: %s         | 10803
ERR_REALTIME_MISSING_INPUT_MAP_NODE    | RealtimePipeline: XML element <InputMap> missing in xml file: %s              | 10804
ERR_REALTIME_CREATING_CONTAINER_INDEX  | RealtimePipeline: Unable to create EDR Container Index for container name: %s | 10805
ERR_REALTIME_PRODUCING_EDR             | RealtimePipeline: Unable to produce EDR Container from index named: %s        | 10806
ERR_REALTIME_CANNOT_DUPLICATE_EDR      | RealtimePipeline: Unexcepted to duplicate EDR.                                | 10807
ERR_REALTIME_UNKNOWN_EXCEPTION         | RealtimePipeline: Unknown exception in function: %s                           | 10808
ERR_REALTIME_MISSING_REQUIRED_FLIST_FIELD   | RealtimePipeline: The expected Input Flist field is missing: %s          | 10809
ERR_REALTIME_BLOCKINDEX_NOT_IN_FACTORY      | RealtimePipeline: Container BlockIndex is missing in Factory: %s         | 10810
ERR_REALTIME_INDEX_NOT_IN_FACTORY      | RealtimePipeline: Container Index is missing in Factory: %s                   | 10811
ERR_REALTIME_REG_INTERPRETER           | RealtimePipeline: IScript interpreteris missing.                              | 10812
ERR_REALTIME_INSERT_FLIST_EXT          | RealtimePipeline: IScript Flist extension is missing.                         | 10813
ERR_REALTIME_READ_REGISTRY_FAILED      | RealtimePipeline: ReadRegistry() failed for INP::Realtime module.             | 10814
ERR_REALTIME_OPEN_ISCRIPT_FAILED       | RealtimePipeline: Unable to open iscript mapping file: %s                     | 10815
ERR_REALTIME_COMPILE_ISCRIPT_FAILED    | RealtimePipeline: Unable to complie iscript mapping file: %s                  | 10816
ERR_REALTIME_NULL_EDR_FACTORY          | RealtimePipeline: Null EDR factory returned from edrFactory()                 | 10817
ERR_REALTIME_EXECUTE_ISCRIPT_FAILED    | RealtimePipeline: Failed to execute realtime iscript.                         | 10818
ERR_REALTIME_PUSH_EDR_FAILED           | RealtimePipeline: Failed to push EDRs onto InputDevice.                       | 10819
ERR_REALTIME_CREATE_DEFAULT_EDR_FAILED | RealtimePipeline: Unable to create a default edr for CM error propagation.    | 10820
ERR_REALTIME_CANNOT_CREATE_DOMBUILDER  | RealtimePipeline: Unable to create a DOMBuilder parser from DOMImplementationLS object. | 10821
ERR_REALTIME_EDR_TYPE_MISMATCH         | RealtimePipeline: Type mismatch error, unable to map pin_fld_t:%s to EDR field: %s in function appendValueToEDR() | 10822
ERR_REALTIME_EDR_FIELD_MAPPING_MISMATCH  | RealtimePipeline: EDRField type mismatch error, unable to map value:%s to EDR field type: %s in function readConstants() | 10823
ERR_REALTIME_PROPAGATE_BLOCK_INVALID_ARG  | RealtimePipeline: PropagateBlock blockname:%s is not a valid candidate for propogation. | 10824
ERR_REALTIME_PROPAGATE_BLOCK_MISSING  | RealtimePipeline: PropagateBlock blockname:%s is not a member of the current EDR. | 10825
ERR_REALTIME_PROPAGATE_BLOCK_INVALID_DEPTH  | RealtimePipeline: PropagateBlock blockname:%s has an invalid depth for propogation. | 10826
ERR_REALTIME_PROPAGATE_BLOCK_LOOKUP_SOURCE_BLOCK  | RealtimePipeline: PropagateBlock blockname:%s has missing source EDR::Datablock at index %s | 10827
ERR_REALTIME_PROPAGATE_BLOCK_CLONE  | RealtimePipeline: PropagateBlock blockname:%s, unable to clone source EDR::Datablock at index %s | 10828
ERR_REALTIME_PROPAGATE_BAD_DATABLOCK_VALUE  | RealtimePipeline: PropagateBlock blockname:%s, unable to find target EDR::DatablockValue at index [%s,%s] | 10829

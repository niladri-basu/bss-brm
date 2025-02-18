#================================================================= 
# LoadIfwConfig utility Messages 
# 
# Number Range: 00001-00100  
#----------------------------------------------------------------
# Note: Add only numbers inside the allocated range.
#       Do not change existing numbers.
#================================================================= 
# 29-Jan-2008: Introduction of error number ranges 
#================================================================= 

INF_LOG_START                      |  ================================ %s LOADIFWCONFIG STARTED ================================ | 00001
INF_LOG_STOP                       |  ================================ %s LOADIFWCONFIG STOPPED ================================ | 00002
ERR_OBJ_NOT_INITIALIZED            |  The object '%s' is not initialized. | 00005
ERR_REG_PARSE_FAILED               |  Registry parse failed near '%s'. | 00006
ERR_REG_SUBTREE_NOT_FOUND          |  Registry subtree '%s' not found. | 00007
ERR_REG_NAME_NOT_FOUND             |  Registry name '%s' not found. | 00008
ERR_REG_VALUE_IS_EMPTY             |  Found empty value for registry item, where a value was expected. | 00009
ERR_NO_PATH_NAME                   |  No path name given. | 00017
ERR_NO_DIR                         |  Directory '%s' not accessible. | 00018
ERR_INVALID_PATTERN                |  Directory pattern '%s' is invalid. | 00019
ERR_CREATE_OBJECT_FAILED           |  Cannot create object '%s' (invalid (NULL) pointer). | 00022
ERR_SYSTEM_ERROR		   | Unexpected error, errno '%s' '%s' '%s' | 00023
WRN_REG_ENTRY_OBSOLETE             | Obsolete registry entry: %s | 00024
ACTUAL_LOGLEVEL                    |  The actual log level is %s. All messages with this or higher severity will be logged. | 00025
LIC_STARTED                        |  LOADIFWCONFIG START TIME. | 00026
LIC_STOPPED                        |  LOADIFWCONFIG END TIME.   | 00027

0 PIN_FLD_OBJ_DESC                 ARRAY [0] allocated 13, used 13
1     PIN_FLD_STATUS                ENUM [0] 1
1     PIN_FLD_CREATE_ACCESS          STR [0] "Any"
1     PIN_FLD_SM_INFO                STR [0] NULL
1     PIN_FLD_IS_PARTITIONED         INT [0] 0
1     PIN_FLD_WRITE_ACCESS           STR [0] "Self"
1     PIN_FLD_READ_ACCESS            STR [0] "Self"
1     PIN_FLD_NAME                   STR [0] "/config/pricing_admin"
1     PIN_FLD_AUDIT_FLAG             INT [0] 0
1     PIN_FLD_PARTITION_MODE         STR [0] ""
1     PIN_FLD_OBJ_ELEM             ARRAY [0] allocated 11, used 11
2         PIN_FLD_FIELD_NAME         STR [0] "PIN_FLD_CONFIG_INFO"
2         PIN_FLD_MOD_PERMISSION     STR [0] "Writeable"
2         PIN_FLD_CREATE_PERMISSION  STR [0] "Optional"
2         PIN_FLD_SM_INFO            STR [0] ""
2         PIN_FLD_ORDER          DECIMAL [0] 0.000
2         PIN_FLD_SM_ITEM_NAME       STR [0] "pricing_admin_config_info_t"
2         PIN_FLD_AUDITABLE          INT [0] 0
2         PIN_FLD_FIELD_NUM         ENUM [0] 7440
2         PIN_FLD_OBJ_ELEM         ARRAY [1] allocated 11, used 11
3             PIN_FLD_FIELD_NAME     STR [0] "PIN_FLD_HOSTNAME"
3             PIN_FLD_MOD_PERMISSION STR [0] "Writeable"
3             PIN_FLD_CREATE_PERMISSION    STR [0] "Optional"
3             PIN_FLD_SM_INFO        STR [0] NULL
3             PIN_FLD_ORDER      DECIMAL [0] 0.000
3             PIN_FLD_SM_ITEM_NAME   STR [0] "hostname"
3             PIN_FLD_ENCRYPTABLE    INT [0] 0
3             PIN_FLD_AUDITABLE      INT [0] 0
3             PIN_FLD_LENGTH         INT [0] 60
3             PIN_FLD_DESCR          STR [0] "The name of the Pipeline db server host."
3             PIN_FLD_LABEL          STR [0] ""
2         PIN_FLD_OBJ_ELEM         ARRAY [2] allocated 11, used 11
3             PIN_FLD_FIELD_NAME     STR [0] "PIN_FLD_LOGIN"
3             PIN_FLD_MOD_PERMISSION STR [0] "Writeable"
3             PIN_FLD_CREATE_PERMISSION    STR [0] "Optional"
3             PIN_FLD_SM_INFO        STR [0] NULL
3             PIN_FLD_ORDER      DECIMAL [0] 0.000
3             PIN_FLD_SM_ITEM_NAME   STR [0] "login"
3             PIN_FLD_ENCRYPTABLE    INT [0] 0
3             PIN_FLD_AUDITABLE      INT [0] 0
3             PIN_FLD_LENGTH         INT [0] 60
3             PIN_FLD_DESCR          STR [0] "The username to log into the Pipeline db server."
3             PIN_FLD_LABEL          STR [0] ""
2         PIN_FLD_OBJ_ELEM         ARRAY [3] allocated 11, used 11
3             PIN_FLD_FIELD_NAME     STR [0] "PIN_FLD_NAME"
3             PIN_FLD_MOD_PERMISSION STR [0] "Writeable"
3             PIN_FLD_CREATE_PERMISSION    STR [0] "Optional"
3             PIN_FLD_SM_INFO        STR [0] NULL
3             PIN_FLD_ORDER      DECIMAL [0] 0.000
3             PIN_FLD_SM_ITEM_NAME   STR [0] "name"
3             PIN_FLD_ENCRYPTABLE    INT [0] 0
3             PIN_FLD_AUDITABLE      INT [0] 0
3             PIN_FLD_LENGTH         INT [0] 60
3             PIN_FLD_DESCR          STR [0] "The name of the Pipeline db."
3             PIN_FLD_LABEL          STR [0] ""
2         PIN_FLD_OBJ_ELEM         ARRAY [4] allocated 11, used 11
3             PIN_FLD_FIELD_NAME     STR [0] "PIN_FLD_PASSWD"
3             PIN_FLD_MOD_PERMISSION STR [0] "Writeable"
3             PIN_FLD_CREATE_PERMISSION    STR [0] "Optional"
3             PIN_FLD_SM_INFO        STR [0] NULL
3             PIN_FLD_ORDER      DECIMAL [0] 0.000
3             PIN_FLD_SM_ITEM_NAME   STR [0] "passwd"
3             PIN_FLD_ENCRYPTABLE    INT [0] 1
3             PIN_FLD_AUDITABLE      INT [0] 0
3             PIN_FLD_LENGTH         INT [0] 79
3             PIN_FLD_DESCR          STR [0] "The password to log into the Pipeline db server."
3             PIN_FLD_LABEL          STR [0] ""
2         PIN_FLD_OBJ_ELEM         ARRAY [5] allocated 11, used 11
3             PIN_FLD_FIELD_NAME     STR [0] "PIN_FLD_PORT"
3             PIN_FLD_MOD_PERMISSION STR [0] "Writeable"
3             PIN_FLD_CREATE_PERMISSION    STR [0] "Optional"
3             PIN_FLD_SM_INFO        STR [0] NULL
3             PIN_FLD_ORDER      DECIMAL [0] 0.000
3             PIN_FLD_SM_ITEM_NAME   STR [0] "port"
3             PIN_FLD_ENCRYPTABLE    INT [0] 0
3             PIN_FLD_AUDITABLE      INT [0] 0
3             PIN_FLD_LENGTH         INT [0] 0
3             PIN_FLD_DESCR          STR [0] "The port number for connection to the Pipeline db server host."
3             PIN_FLD_LABEL          STR [0] ""
2         PIN_FLD_OBJ_ELEM         ARRAY [6] allocated 11, used 11
3             PIN_FLD_FIELD_NAME     STR [0] "PIN_FLD_SERVER_TYPE"
3             PIN_FLD_MOD_PERMISSION STR [0] "Writeable"
3             PIN_FLD_CREATE_PERMISSION    STR [0] "Optional"
3             PIN_FLD_SM_INFO        STR [0] NULL
3             PIN_FLD_ORDER      DECIMAL [0] 0.000
3             PIN_FLD_SM_ITEM_NAME   STR [0] "server_type"
3             PIN_FLD_ENCRYPTABLE    INT [0] 0
3             PIN_FLD_AUDITABLE      INT [0] 0
3             PIN_FLD_LENGTH         INT [0] 60
3             PIN_FLD_DESCR          STR [0] "The Pipeline db type, e.g., oracle.  This has to match the alias of a driver configuration group in the configuration file on the client machine."
3             PIN_FLD_LABEL          STR [0] ""
2         PIN_FLD_DESCR              STR [0] "Substruct containing Pipeline server log-in info."
2         PIN_FLD_LABEL              STR [0] ""
1     PIN_FLD_AU_SM_INFO             STR [0] NULL
1     PIN_FLD_DESCR                  STR [0] "Config object for Pipeline server log-in info."
1     PIN_FLD_LABEL                  STR [0] ""

#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# @(#)%Portal Version: pin_res.pl:PortalBase7.3.1Int:3:2007-Aug-28 21:48:27 %
#=======================================================================
#  @(#)%Portal Version: pin_res.pl:PortalBase7.3.1Int:3:2007-Aug-28 21:48:27 %
# 
# Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Resource file for Portal Base Installation perl scripts
# Language: English
#=============================================================

$HOSTNAME = `hostname`;
chop( $HOSTNAME );

$IDS_DB2_CHARSET_INCORRECT = <<END
\nThe CHARACTER SET for your chosen database   ( %s )
does not match the value in pin_setup.values ( %s ).
Please correct \$DM_DB2\{\'sm_charset\'\} in pin_setup.values
and then run this install program again.\n
END
;

$IDS_DB2_DATABASE_NOT_FOUND = <<END
\nAlias:        %s
The database alias name or database name could not be found.  SQLSTATE=%s
Please contact your DB2 DBA regarding this error message.
Then run this install program again.\n
END
;

$IDS_UNKNOWN_DB_CONNECT_ERROR_DB2 = <<END
\nUser:         %s
Password:     %s
Alias:        %s
\nUnable to connect to the database ( SQLSTATE=%s ).
Please make sure you entered the correct 'user', 'password', and 'alias'
for MAIN_DB in pin_setup.values.  Then run this install program again.\n
END
;

$IDS_INVALID_USERNAME_DB2 = <<END
\nUser:         %s
Password:     %s
Alias:        %s
\nThe username and/or password supplied is incorrect ( SQLSTATE=%s ).
Please make sure you entered the correct 'user', 'password', and 'alias'
for MAIN_DB in pin_setup.values, and then run this install program again.\n
END
;

$IDS_INVALID_NAME = <<END
\n\nTablespace name cannot begin with "SYS".\n
END
;

$IDS_BUFFER_POOL_NOT_ENOUGH_MEM = <<END
\n\nUnable to obtain the total memory for all buffer pools, it will attempt to
start up only the default buffer pool.\n
END
;

$IDS_INVALID_BUFFER_POOL = <<END
\n\nThe Buffer pool specified for tablespace creation does not exist. Please ensure that
the buffer pool was created successfully before using the buffer pool in the tablespace 
creation.\n
END
;


$IDS_MISMATCH_BUFFER_POOL = <<END
\n\nThe pagesize for the tablespace does not match the pagesize of the Buffer pool. Please
correct the mismatch before creating the tablespace.\n
END
;

$IDS_FILE_SYSTEM_FULL = <<END
\n\nUnable to create tablespace. The file system is full.\n
END
;

##################
# Oracle Strings
##################
$IDS_CHARSET_INCORRECT = <<END
\nThe CHARACTER SET for your chosen database   ( %s )
does not match the value in pin_setup.values ( %s ).
Please correct \$DM_ORACLE\{\'sm_charset\'\} in pin_setup.values
and then run this install program again.\n
END
;

$IDS_NLS_LANG_INCORRECT_NT = <<END
\nThe CHARACTER SET for your chosen database   ( %s )
does not match your NLS_LANG System variable ( %s ).
Please correct your NLS_LANG System variable,
reboot your machine, and then run this install program again.\n
END
;

$IDS_NLS_LANG_INCORRECT_UNIX = <<END
\nThe CHARACTER SET for your chosen database        ( %s )
does not match your NLS_LANG environment variable ( %s ).
Please correct your NLS_LANG environment variable
and then run this install program again.\n
END
;

$IDS_UNKNOWN_DB_CONNECT_ERROR_NT = <<END
\nUser:         %s
Password:     %s
Host:         %s
NLS_LANG System variable:  %s
\nUnable to connect to the database ( Oracle Error %s ).
Please make sure you entered the correct 'user', 'password', and 'Host'
for MAIN_DB in pin_setup.values, and that the NLS_LANG System variable
is correct.  If NLS_LANG needs to be changed, please reboot your machine
after making the change.  Then run this install program again.\n
END
;

$IDS_UNKNOWN_DB_CONNECT_ERROR_UNIX = <<END
\nUser:         %s
Password:     %s
Alias:        %s
NLS_LANG environment variable:  %s
\nUnable to connect to the database ( Oracle Error %s ).
Please make sure you entered the correct 'user', 'password', and 'alias'
for MAIN_DB in pin_setup.values, and that the NLS_LANG environment variable
is correct.  Then run this install program again.\n
END
;

$IDS_TNSNAME_INVALID = <<END
\n%s is not a valid service name for this machine. 
Please make sure  you have created this entry in the TNSNAMES.ORA file,
and then run this install program again.\n
END
;

$IDS_NODB_AT_MACHINE = <<END
\n%s is not a valid alias for this machine. 
Please make sure you have created the database,
and then run this install program again.\n
END
;

$IDS_INVALID_USERNAME = <<END
\nUser:         %s
Password:     %s
Alias:        %s
The login credentials you have supplied are not valid.
Please make sure you entered the correct 'user', 'password', and 'alias'
for MAIN_DB in pin_setup.values, and then run this install program again.\n
END
;

$IDS_INVALID_USERNAME_SYSTEM = <<END
\nUser:         %s
Password:     %s
Alias:        %s
The SYSTEM login credentials you have supplied are not valid.
Please make sure you entered the correct 'system_user', 'system_password',
and 'alias' for MAIN_DB in pin_setup.values, then run this install program again.\n
END
;

$IDS_NO_TNS_LISTENER =  <<END
\nThere is no listener for the service name you have supplied (%s).
Please make sure the TNSNAMES.ORA file entry is correct, and that
Oracle is started on the machine running the database.
Then run this install program again.\n
END
;

$IDS_DB2_ERROR_CREATING_TABLESPACE = <<END
\nUser:         %s
Password:     %s
Alias:        %s
SQL command:  %s
\nThe following DB2 Error occurred, when running the above SQL command:
    %s
Please contact your DB2 DBA, and then do the following
on the machine where your DB2 Server is located:
    Make sure this directory:  %s
    is writable by user 'db2' and has at least %s free space available.
    Remove the following file, if it exists:  %s
\nThen run this install program again.\n
END
;

$IDS_ORACLE_ERROR_CREATING_TABLESPACE = <<END
\nUser:         %s
Password:     %s
Alias:        %s
SQL command:  %s
\nThe following Oracle Error occurred, when running the above SQL command:
    %s
Please contact your Oracle DBA, and then do the following
on the machine where your Oracle Server is located:
    Make sure this directory:  %s
    is writable by user 'oracle' and has at least %s free space available.
    Remove the following file, if it exists:  %s
\nThen run this install program again.\n
END
;

$IDS_SQLSERVER_ERROR_CREATING_DATABASE = <<END
\nUser:         %s
Password:     %s
Host:         %s
MS SQLserver Errors occurred, when creating the %s database:  %s
\nPlease contact your SQLserver DBA, and then do the following
on the machine where your SQLserver Server is located:
    Make sure this directory:  %s
    is writable by the SQLserver administrator
    and has at least %s MB free space available.
\nThen run this install program again.\n
END
;

$IDS_DB2_ERROR = <<END
\nUser:         %s
Password:     %s
Alias:        %s
SQL command:  %s
\nThe following DB2 Error occurred, when running the above SQL command:
    %s
Please contact your DB2 DBA regarding this error message.
Then run this install program again.\n
END
;

$IDS_ORACLE_ERROR = <<END
\nUser:         %s
Password:     %s
Alias:        %s
SQL command:  %s
\nThe following Oracle Error occurred, when running the above SQL command:
    %s
Please contact your Oracle DBA regarding this error message.
Then run this install program again.\n
END
;

$IDS_SQLSERVER_ERROR = <<END
\nUser:         %s
Password:     %s
Host:         %s
SQL command:  %s
MS SQLserver Errors occurred, when creating the %s database:  %s
Please contact your SQLserver DBA regarding this error message.
Then run this install program again.\n
END
;

$IDS_SQLSERVER_ERROR_DATABASE_EXISTS = <<END
\nSQL command:  %s
\nThe MS SQLserver database specified already exists.\n
END
;

$IDS_SQLSERVER_ERROR_USER_EXISTS = <<END
\nUser:         %s
Password:     %s
Host:         %s
The MS SQLserver login, user or role %s already exists.\n
END
;

$IDS_UNKNOWN_DB_CONNECT_ERROR_SQLSERVER = <<END
\nUser:         %s
Password:     %s
Host:         %s
\nUnable to connect to the database ( SQLserver Error %s ).
Please make sure you entered the correct 'user', 'password', and 'Host'
for MAIN_DB in pin_setup.values.  Then run this install program again.\n
END
;
$IDS_ENV_VARIABLES_NOT_FOUND = <<END
\n*****Error: The environment variable %s is required to setup this product.
Please set up this environment variable and run pin_setup again.\n
END
;
$IDS_ENV_VARIABLES_PATH_INVALID = <<END
\n*****Error: The directory path entered for environment variable %s is invalid.
Please set up valid path for this environment variable and run pin_setup again.\n
END
;
$IDS_LOG_TIME = 
"\n\n#===========================================================
# Log for installation started at %s.
#===========================================================\n";


$IDS_UNABLETOLOGTO = "Unable to open logfile %s.\n";
$IDS_UNABLETOPIPETO = "Unable to pipe to %s.\n";
$IDS_CONFIGURING_PIN_CONF = "%s: Generating pin.conf file\n";
$IDS_CONFIGURING_DATABASE = "%s: Configuring database\n";
$IDS_UPGRADE_CONFIGURING_DATABASE = "%s: Upgrading 7.3 Patch schema\n";
$IDS_PIN_CONF_GENERATE = "\n pin.conf is generated under %s \n ";
$IDS_CM_PIN_CONF_APPEND_SUCCESS = "\n %s entries are appended to %s \n ";
$IDS_TEMP_PIN_CONF = "append_to_cm_pin_conf";
$IDS_APPEND_TO_FILE_MESSAGE =
"\nWarning:  File not found:  %s
          To complete the %s install, append the following file
          to the %s file:
          \"%s\"\n\n";
$IDS_APPEND_PIN_CONF_MESSAGE =
"\nWarning:  File not found:  %s
          To complete the %s install, append the following file
          to the sys/cm/pin.conf file and then restart the CM process:
          \"%s\"\n\n";
$IDS_UPDATE_CM_PIN_CONF_MESSAGE =
"\nWarning:  File not found:  %s
          To complete the %s install, update the following entries in
          %s
          and then restart the CM process:\n\n";
$IDS_SHOW_TIME = 
"#===========================================================
# Installation started at %s.
#===========================================================\n";
$IDS_EXECUTING_COMMAND = "Executing %s\n";
$IDS_SQLSTATEMENT = "#--- Executing SQL statement:\n%s\n";
$IDS_SQLRESULTS = "#------------- SQL Results:\n%s\n#-------------\n";
$IDS_PRE_FOUND = "pin_pre_cmp_%s.pl was found. Executing...\n";
$IDS_POST_FOUND = "pin_post_cmp_%s.pl was found. Executing...\n";

$IDS_DD_OBJECTS_LOADING = "Loading objects from file %s \n";
$IDS_CREATE_INDEXES_FILE = "Execute SQL statement from file %s \n";
$IDS_DD_DROP_FILE = "Dropping table from file %s \n";

$IDS_DATABASE_ALREADY_FULL = "There are already some tables for Portal Base in the database.\n";
$IDS_DROPPING_TABLES ="The Portal Base installation is about to drop all the tables from this database.\n";
$IDS_TABLES_DROPPED = "All tables have been dropped.\n";
$IDS_SCRIPT_SKIPPED = "**%s was skipped...\n";
$IDS_TESTNAP_FAILED = "\n\n*** Error:  Testnap failed, indicating that Portal Base is not up\n";
$IDS_TESTNAP_SUCCESS = "\n\nTestnap has successfully connected to the CM.\nPortal Base is up and running.\n";
$IDS_WAITING_FOR_PORTAL = "\nWaiting %s seconds for Portal Base to start\n";
$IDS_WAITING_FOR_COMPONENT = "\nWaiting %s seconds for $CurrentComponent to start\n";
$IDS_BUS_PARAMS_LOADING = "\nLoading Pin bus params into database\n";	
$IDS_BUS_PARAMS_FAILED = "\n*** Error:  Pin bus params not loaded properly\n";
$IDS_BUS_PARAMS_SUCCESS = "\n\nPin bus params successfully loaded\n";
$IDS_GLIDS_LOADING = "\nLoading GLIDs into database\n";	
$IDS_GLIDS_FAILED = "\n*** Error:  GLIDs not loaded properly\n";
$IDS_GLIDS_SUCCESS = "\n\nGLIDs successfully loaded\n";
$IDS_GLCHART_LOADING = "\nLoading GLCHARTACCTSs into database\n";	
$IDS_GLCHART_FAILED = "\n*** Error:  GLCHARTACCTSs not loaded properly\n";
$IDS_GLCHART_SUCCESS = "\n\nGLCHARTACCTSs successfully loaded\n";
$IDS_RUMS_LOADING = "\nLoading RUMs into database\n";	
$IDS_RUMS_FAILED = "\n*** Error:  RUMs not loaded properly\n";
$IDS_RUMS_SUCCESS = "\n\nRUMs successfully loaded\n";
$IDS_USAGE_LOADING = "\nLoading Usage Maps into database\n";	
$IDS_USAGE_FAILED = "\n*** Error:  Usage Maps not loaded properly\n";
$IDS_USAGE_SUCCESS = "\n\nUsage Maps successfully loaded\n";
$IDS_EVENT_LOADING = "\nLoading Event Maps into database\n";	
$IDS_EVENT_FAILED = "\n*** Error:  Event Maps not loaded properly\n";
$IDS_EVENT_SUCCESS = "\n\nEvent Maps successfully loaded\n";
$IDS_BEIDS_LOADING = "\nLoading BEIDs into database\n";	
$IDS_BEIDS_FAILED = "\n*** Error:  BEIDs not loaded properly\n";
$IDS_BEIDS_SUCCESS = "\n\nBEIDs successfully loaded\n";
$IDS_BUSINESS_TYPE_LOADING = "\nLoading Business Types into database\n";	
$IDS_BUSINESS_TYPE_FAILED = "\n*** Error:  Business Types not loaded properly\n";
$IDS_BUSINESS_TYPE_SUCCESS = "\n\nBusiness Types successfully loaded\n";

$IDS_ACH_LOADING = "\nLoading ACH data into database\n";	
$IDS_ACH_FAILED = "\n*** Error:  ACH data not loaded properly\n";
$IDS_ACH_SUCCESS = "\n\nACH data successfully loaded\n";

$IDS_CONTRIBUTOR_LOADING = "\nLoading CONTRIBUTOR data into database\n";	
$IDS_CONTRIBUTOR_FAILED = "\n*** Error:  CONTRIBUTOR data not loaded properly\n";
$IDS_CONTRIBUTOR_SUCCESS = "\n\nCONTRIBUTOR data successfully loaded\n";

$IDS_EVENT_RECORD_MAP_LOADING = "\nLoading Event Record Map file into database\n";	
$IDS_EVENT_RECORD_MAP_FAILED = "\n*** Error:  Event Record Map file not loaded properly\n";
$IDS_EVENT_RECORD_MAP_SUCCESS = "\n\nEvent Record Map file types successfully loaded\n";

$IDS_TRANSITION_LOADING = "\nLoading TRANSITION types into database\n";	
$IDS_TRANSITION_FAILED = "\n*** Error:  TRANSITION types not loaded properly\n";
$IDS_TRANSITION_SUCCESS = "\n\nTRANSITION types successfully loaded\n";

$IDS_HISTORY_ON_LOADING = "\nEnabling Portal to Audit GSM objects\n";	
$IDS_HISTORY_ON_FAILED = "\n*** Error:  Enabling Portal to Audit GSM objects failed\n";
$IDS_HISTORY_ON_SUCCESS = "\n\nPortal successfully enabled to Audit GSM objects\n";

$IDS_SPECS_LOADING = "\nLoading BEIDs into database\n";	
$IDS_SPECS_FAILED = "\n*** Error:  BEIDs not loaded properly\n";
$IDS_SPECS_SUCCESS = "\n\nBEIDs successfully loaded\n";

$IDS_SPEC_IMPACT_LOADING = "\nLoading Spec Impact categories into database\n";	
$IDS_SPEC_IMPACT_FAILED = "\n*** Error:  Spec Impact categories not loaded properly\n";
$IDS_SPEC_IMPACT_SUCCESS = "\n\nSpec Impact categories successfully loaded\n";

$IDS_SPEC_RATES_LOADING = "\nLoading Spec Rates categories into database\n";	
$IDS_SPEC_RATES_FAILED = "\n*** Error:  Spec Rates categories not loaded properly\n";
$IDS_SPEC_RATES_SUCCESS = "\n\nSpec Rates categories successfully loaded\n";

$IDS_SUSPENSE_REASON_LOADING = "\nLoading Suspense Reason Codes into database\n";
$IDS_SUSPENSE_REASON_FAILED = "\n*** Error: Suspense Reason Codes Maps not loaded properly\n";
$IDS_SUSPENSE_REASON_SUCCESS = "\n\nSuspense Reason Codes successfully loaded\n";

$IDS_SUSPENSE_REASON_STRINGS_LOADING = "\nLoading localized strings for Suspense Reason Codes into database\n";
$IDS_SUSPENSE_REASON_STRINGS_FAILED = "\n*** Error: Localized strings for Suspense Reason Codes not loaded properly\n";
$IDS_SUSPENSE_REASON_STRINGS_SUCCESS = "\n\nLocalized strings for Suspense Reason Codes successfully loaded\n";

$IDS_BATCH_SUSPENSE_REASON_LOADING = "\nLoading Batch Suspense Reason Codes into database\n";
$IDS_BATCH_SUSPENSE_REASON_FAILED = "\n*** Error: Batch Suspense Reason Codes Maps not loaded properly\n";
$IDS_BATCH_SUSPENSE_REASON_SUCCESS = "\n\nBatch Suspense Reason Codes successfully loaded\n";

$IDS_BATCH_SUSPENSE_REASON_STRINGS_LOADING = "\nLoading localized strings for Batch Suspense Reason Codes into database\n";
$IDS_BATCH_SUSPENSE_REASON_STRINGS_FAILED = "\n*** Error: Localized strings for Batch Suspense Reason Codes not loaded properly\n";
$IDS_BATCH_SUSPENSE_REASON_STRINGS_SUCCESS = "\n\nLocalized strings for Batch Suspense Reason Codes successfully loaded\n";

$IDS_SUSPENSE_EDITABLE_FLDS_LOADING = "\nLoading Suspense Editable Fields into database\n";
$IDS_SUSPENSE_EDITABLE_FLDS_FAILED = "\n*** Error: Suspense Editable Fields Maps not loaded properly\n";
$IDS_SUSPENSE_EDITABLE_FLDS_SUCCESS = "\n\nSuspense Editable Fields successfully loaded\n";

$IDS_EDR_FIELD_MAPPING_LOADING = "\nLoading EDR Field Mapping into database\n";
$IDS_EDR_FIELD_MAPPING_FAILED = "\n*** Error: EDR Field Mapping not loaded properly\n";
$IDS_EDR_FIELD_MAPPING_SUCCESS = "\n\nEDR Field Mapping successfully loaded\n";

$IDS_IMPACT_LOADING = "\nLoading Impact categories into database\n";	
$IDS_IMPACT_FAILED = "\n*** Error:  Impact categories not loaded properly\n";
$IDS_IMPACT_SUCCESS = "\n\nImpact categories successfully loaded\n";

$IDS_DROPPED_LOADING = "\nLoading Dropped Call Credits into database\n";	
$IDS_DROPPED_FAILED = "\n*** Error:  Dropped Call Credits not loaded properly\n";
$IDS_DROPPED_SUCCESS = "\n\nDropped Call Credits successfully loaded\n";

$IDS_MSEXCHANGE_EMAIL_LOADING = "\nLoading \/config\/msexchange email tags into database\n";
$IDS_MSEXCHANGE_EMAIL_FAILED  = "\n*** Error:  \/config\/msexchange email tags not loaded properly\n";
$IDS_MSEXCHANGE_EMAIL_SUCCESS = "\n\/config\/msexchange email tags successfully loaded\n";
$IDS_MSEXCHANGE_ORG_LOADING   = "\nLoading \/config\/msexchange org tags into database\n";
$IDS_MSEXCHANGE_ORG_FAILED    = "\n*** Error:  \/config\/msexchange org tags not loaded properly\n";
$IDS_MSEXCHANGE_ORG_SUCCESS   = "\n\/config\/msexchange org tags successfully loaded\n";

$IDS_NUMBER_DEVICE_LOADING = "\nLoading Number device permit map into database\n";
$IDS_NUMBER_DEVICE_FAILED = "\n*** Error: Number device permit map  not loaded properly\n";
$IDS_NUMBER_DEVICE_SUCCESS = "\n\n Number device permit map successfully loaded\n";

$IDS_NUMBER_DEVICE_STATE_LOADING = "\nLoading Number device state into database\n";
$IDS_NUMBER_DEVICE_STATE_FAILED = "\n*** Error:  Number device state not loaded properly\n";
$IDS_NUMBER_DEVICE_STATE_SUCCESS = "\n\nNumber device state successfully loaded\n";

$IDS_NUMBER_CONFIG_LOADING = "\nLoading Number config into database\n";
$IDS_NUMBER_CONFIG_FAILED = "\n*** Error:  Number config not loaded properly\n";
$IDS_NUMBER_CONFIG_SUCCESS= "\n\nNumber config successfully loaded\n";

$IDS_NUMBER_NETWORK_LOADING = "\nLoading Number network elements into database\n";
$IDS_NUMBER_NETWORK_FAILED = "\n*** Error:  Number network elements not loaded properly\n";
$IDS_NUMBER_NETWORK_SUCCESS = "\n\nNumber network elements successfully loaded\n";

$IDS_NUMBER_CATEGORIES_STRINGS_LOADING = "\nLoading localized strings for Number categories into database\n";
$IDS_NUMBER_CATEGORIES_STRINGS_FAILED = "\n*** Error: Localized strings for Number categories not loaded properly\n";
$IDS_NUMBER_CATEGORIES_STRINGS_SUCCESS = "\n\nLocalized strings for Number categories successfully loaded\n";

$IDS_NUMBER_DEVICE_STRINGS_LOADING = "\nLoading localized strings for Number device into database\n";
$IDS_NUMBER_DEVICE_STRINGS_FAILED = "\n*** Error: Localized strings for Number device not loaded properly\n";
$IDS_NUMBER_DEVICE_STRINGS_SUCCESS = "\n\nLocalized strings for Number device successfully loaded\n";

$IDS_NUMBER_VANITIES_STRINGS_LOADING = "\nLoading localized strings for Number vanities into database\n"; 
$IDS_NUMBER_VANITIES_STRINGS_FAILED = "\n*** Error: Localized strings for Number vanities not loaded properly\n";
$IDS_NUMBER_VANITIES_STRINGS_FAILED = "\n\nLocalized strings for Number vanities successfully loaded\n";

$IDS_SIM_DEVICE_LOADING = "\nLoading Sim device permit map into database\n";
$IDS_SIM_DEVICE_FAILED = "\n*** Error: Sim device permit map  not loaded properly\n";
$IDS_SIM_DEVICE_SUCCESS = "\n\n Sim device permit map successfully loaded\n";

$IDS_SIM_DEVICE_STATE_LOADING = "\nLoading Sim device state into database\n";
$IDS_SIM_DEVICE_STATE_FAILED = "\n*** Error:  Sim device state not loaded properly\n";
$IDS_SIM_DEVICE_STATE_SUCCESS = "\n\nSim device state successfully loaded\n";

$IDS_SIM_CONFIG_LOADING = "\nLoading Sim config into database\n";
$IDS_SIM_CONFIG_FAILED = "\n*** Error:  Sim config not loaded properly\n";
$IDS_SIM_CONFIG_SUCCESS= "\n\nSim config successfully loaded\n";

$IDS_SIM_NETWORK_LOADING = "\nLoading Sim network elements into database\n";
$IDS_SIM_NETWORK_FAILED = "\n*** Error:  Sim network elements not loaded properly\n";
$IDS_SIM_NETWORK_SUCCESS = "\n\nSim network elements successfully loaded\n";

$IDS_SIM_STATUS_STRINGS_LOADING = "\nLoading localized strings for Sim status into database\n";
$IDS_SIM_STATUS_STRINGS_FAILED = "\n*** Error: Localized strings for Sim status not loaded properly\n";
$IDS_SIM_STATUS_STRINGS_SUCCESS = "\n\nLocalized strings for Sim status successfully loaded\n";

$IDS_SIM_CARD_STRINGS_LOADING = "\nLoading localized strings for Sim card into database\n";
$IDS_SIM_CARD_STRINGS_FAILED = "\n*** Error: Localized strings for Sim card not loaded properly\n";
$IDS_SIM_CARD_STRINGS_SUCCESS = "\n\nLocalized strings for Sim card successfully loaded\n";

$IDS_SIM_DEVICE_STRINGS_LOADING = "\nLoading localized strings for Sim device into database\n"; 
$IDS_SIM_DEVICE_STRINGS_FAILED = "\n*** Error: Localized strings for Sim device not loaded properly\n";
$IDS_SIM_DEVICE_STRINGS_FAILED = "\n\nLocalized strings for Sim device successfully loaded\n";

$IDS_PRICE_LOADING = "\nLoading Price List into database\n";	
$IDS_PRICE_FAILED = "\n*** Error:  Price List not loaded properly\n";
$IDS_PRICE_SUCCESS = "\n\nPrice List successfully loaded\n";

$IDS_PIPELINE_SCHEMA_INIT_FAILED = "\nPipeline Schema has not been initialized;Skipping loading of Tailormade plans and Discount model stored procedure\n";
$IDS_PIPELINE_SCHEMA_INIT_SUCCESS = "\nPipeline Schema has been initialized. Loading the Tailormade plan and discount model stored procedure\n";
$IDS_LOAD_TAILORMADE_PROCDURE_SUCCESS = "\n Tailormade plans stored procedure has been loaded successfully !!\n";
$IDS_LOAD_DISCOUNTMODEL_PROCDURE_SUCCESS = "\n Tailormade plans stored procedure has been loaded successfully !!\n";

$IDS_PORTALBASE_SCHEMA_INIT_FAILED = "\nPortalBase Schema has not been initialized;Skipping loading of unlock service stored procedure\n";
$IDS_PORTALBASE_SCHEMA_INIT_SUCCESS = "\nPortalBase Schema has been initialized. Loading the unlock service stored procedure\n";

$IDS_DEVICE_MGMT_LOADING = "\nCreating the scripts for the Device Management loaders\n";	

$IDS_TEMPLATES_LOADING = "\nLoading Sample Templates into database\n";	
$IDS_TEMPLATES_FAILED = "\n*** Error:  Sample Templates not loaded properly\n";
$IDS_TEMPLATES_SUCCESS = "\n\nSample Templates successfully loaded\n";

$IDS_TERACOMM_LOADING = "\nLoading \/config\/teracomm object into database\n";
$IDS_TERACOMM_FAILED = "\n*** Error:  \/config\/teracomm object not loaded properly\n";
$IDS_TERACOMM_SUCCESS = "\n\/config\/teracomm object successfully loaded\n";
$IDS_TERACOMM_TAGS_LOADING = "\nLoading \/config\/teracommtags object into database\n";
$IDS_TERACOMM_TAGS_FAILED = "\n*** Error:  \/config\/teracommtags object not loaded properly\n";
$IDS_TERACOMM_TAGS_SUCCESS = "\n\/config\/teracommtags object successfully loaded\n";

$IDS_BERTELSMANN_LOADING = "\nLoading pin_country_currency_map object into database\n";
$IDS_BERTELSMANN_FAILED = "\n*** Error:  pin_country_currency_map object not loaded properly\n";
$IDS_BERTELSMANN_SUCCESS = "\npin_country_currency_map object successfully loaded\n";

$IDS_GSM_TAGS_LOADING = "\nLoading GSM telco tags into database\n";
$IDS_GSM_TAGS_FAILED = "\n*** Error:  GSM telco tags not loaded properly\n";
$IDS_GSM_TAGS_SUCCESS = "\n GSM telco tags successfully loaded\n";

$IDS_GSM_PROVISIONING_LOADING = "\nLoading GSM telco provsioning into database\n";
$IDS_GSM_PROVISIONING_FAILED = "\n*** Error:  GSM telco provsioning not loaded properly\n";
$IDS_GSM_PROVISIONING_SUCCESS = "\n GSM telco provsioning successfully loaded\n";

$IDS_GSM_SERVICE_LOADING = "\nLoading GSM telco service order into database\n";
$IDS_GSM_SERVICE_FAILED = "\n*** Error:  GSM telco service order not loaded properly\n";
$IDS_GSM_SERVICE_SUCCESS = "\n GSM telco service order successfully loaded\n";

$IDS_GSM_ORDER_STATE_LOADING = "\nLoading GSM telco service order data into database\n";
$IDS_GSM_ORDER_STATE_FAILED = "\n*** Error:  GSM telco service order data not loaded properly\n";
$IDS_GSM_ORDER_STATE_SUCCESS = "\n GSM telco service order data successfully loaded\n";

$IDS_GSM_ORDER_STATE_FAX_LOADING = "\nLoading GSM telco service order fax into database\n";
$IDS_GSM_ORDER_STATE_FAX_FAILED = "\n*** Error:  GSM telco service order fax loaded properly\n";
$IDS_GSM_ORDER_STATE_FAX_SUCCESS = "\n GSM telco service order fax successfully loaded\n";

$IDS_GSM_ORDER_STATE_SMS_LOADING = "\nLoading GSM telco service order sms into database\n";
$IDS_GSM_ORDER_STATE_SMS_FAILED = "\n*** Error:  GSM telco service order sms not loaded properly\n";
$IDS_GSM_ORDER_STATE_SMS_SUCCESS = "\n GSM telco service order sms successfully loaded\n";

$IDS_GSM_ORDER_STATE_TELEPHONY_LOADING = "\nLoading GSM telco service order telephony into database\n";
$IDS_GSM_ORDER_STATE_TELEPHONY_FAILED = "\n*** Error:  GSM telco service order telephony not loaded properly\n";
$IDS_GSM_ORDER_STATE_TELEPHONY_SUCCESS = "\n GSM telco service order telephony successfully loaded\n";

$IDS_GSM_PERMIT_MAP_NUM_LOADING = "\nLoading GSM permit map number into database\n";
$IDS_GSM_PERMIT_MAP_NUM_FAILED = "\n*** Error:  GSM permit map number not loaded properly\n";
$IDS_GSM_PERMIT_MAP_NUM_SUCCESS = "\n GSM permit map number successfully loaded\n";

$IDS_GSM_PERMIT_MAP_SIM_LOADING = "\nLoading GSM permit map number into database\n";
$IDS_GSM_PERMIT_MAP_SIM_FAILED = "\n*** Error:  GSM permit map number not loaded properly\n";
$IDS_GSM_PERMIT_MAP_SIM_SUCCESS = "\n GSM permit map number successfully loaded\n";

$IDS_GPRS_EVENT_MAP_LOADING = "\nLoading GPRS event map into database\n";
$IDS_GPRS_EVENT_MAP_FAILED = "\n*** Error:  GPRS event map not loaded properly\n";
$IDS_GPRS_EVENT_MAP_SUCCESS = "\n GPRS event map successfully loaded\n";

$IDS_GPRS_SERVICE_ORDER_LOADING = "\nLoading GPRS service order into database\n";
$IDS_GPRS_SERVICE_ORDER_FAILED = "\n*** Error:  GPRS service order not loaded properly\n";
$IDS_GPRS_SERVICE_ORDER_SUCCESS = "\n GPRS service order object successfully loaded\n";

$IDS_GPRS_PROVISIONING_LOADING = "\nLoading GPRS provisioning into database\n";
$IDS_GPRS_PROVISIONING_FAILED = "\n*** Error:  GPRS provisioning not loaded properly\n";
$IDS_GPRS_PROVISIONING_SUCCESS = "\n GPRS provisioning successfully loaded\n";

$IDS_GPRS_TAGS_LOADING = "\nLoading GPRS tags into database\n";
$IDS_GPRS_TAGS_FAILED = "\n*** Error:  GPRS tags not loaded properly\n";
$IDS_GPRS_TAGS_SUCCESS = "\n GPRS tags successfully loaded\n";

$IDS_GPRSAAA_LOADING = "\nLoading AAA opcode tcf object into database\n";
$IDS_GPRSAAA_FAILED = "\n*** Error:  AAA opcode tcf object not loaded properly\n";
$IDS_GPRSAAA_SUCCESS = "\n AAA opcode tcf object successfully loaded\n";

$IDS_GPRSAAA_RESERVATION_LOADING = "\nLoading GPRS AAA reservation into database\n";
$IDS_GPRSAAA_RESERVATION_FAILED = "\n*** Error:  GPRS AAA reservation not loaded properly\n";
$IDS_GPRSAAA_RESERVATION_SUCCESS = "\n GPRS AAA reservation successfully loaded\n";

$IDS_AAA_RESERVATION_LOADING = "\nLoading AAA reservation into database\n";
$IDS_AAA_RESERVATION_FAILED = "\n*** Error:  AAA reservation not loaded properly\n";
$IDS_AAA_RESERVATION_SUCCESS = "\n AAA reservation successfully loaded\n";

$IDS_GPRSAAA_PARAMS_LOADING = "\nLoading GPRS AAA params into database\n";
$IDS_GPRSAAA_PARAMS_FAILED = "\n*** Error:  GPRS AAA params not loaded properly\n";
$IDS_GPRSAAA_PARAMS_SUCCESS = "\n GPRS AAA params successfully loaded\n";

$IDS_GSMAAA_LOADING = "\nLoading AAA opcode tcf object into database\n";
$IDS_GSMAAA_FAILED = "\n*** Error:  AAA opcode tcf object not loaded properly\n";
$IDS_GSMAAA_SUCCESS = "\n AAA opcode tcf object successfully loaded\n";

$IDS_GSMAAA_RESERVATION_DATA_LOADING = "\nLoading GSM AAA reservation data into database\n";
$IDS_GSMAAA_RESERVATION_DATA_FAILED = "\n*** Error:  GSM AAA reservation data not loaded properly\n";
$IDS_GSMAAA_RESERVATION_DATA_SUCCESS = "\n GSM AAA reservation data successfully loaded\n";

$IDS_GSMAAA_RESERVATION_TEL_LOADING = "\nLoading GSM AAA reservation telephony into database\n";
$IDS_GSMAAA_RESERVATION_TEL_FAILED = "\n*** Error:  GSM AAA reservation telephony not loaded properly\n";
$IDS_GSMAAA_RESERVATION_TEL_SUCCESS = "\n GSM AAA reservation telephony successfully loaded\n";

$IDS_GSMAAA_FAX_PARAMS_LOADING = "\nLoading GSM AAA fax params into database\n";
$IDS_GSMAAA_FAX_PARAMS_FAILED = "\n*** Error:  GSM AAA fax params not loaded properly\n";
$IDS_GSMAAA_FAX_PARAMS_SUCCESS = "\n GSM AAA fax params successfully loaded\n";

$IDS_GSMAAA_SMS_PARAMS_LOADING = "\nLoading GSM AAA sms params into database\n";
$IDS_GSMAAA_SMS_PARAMS_FAILED = "\n*** Error:  GSM AAA sms params not loaded properly\n";
$IDS_GSMAAA_SMS_PARAMS_SUCCESS = "\n GSM AAA sms params successfully loaded\n";

$IDS_GSMAAA_PARAMS_LOADING = "\nLoading GSM AAA params into database\n";
$IDS_GSMAAA_PARAMS_FAILED = "\n*** Error:  GSM AAA params not loaded properly\n";
$IDS_GSMAAA_PARAMS_SUCCESS = "\n GSM AAA params successfully loaded\n";

$IDS_GSMAAA_TEL_PARAMS_LOADING = "\nLoading GSM AAA telephony params into database\n";
$IDS_GSMAAA_TEL_PARAMS_FAILED = "\n*** Error:  GSM AAA telephony params not loaded properly\n";
$IDS_GSMAAA_TEL_PARAMS_SUCCESS = "\n GSM AAA telephony params successfully loaded\n";

$IDS_GSMAAA_DATA_PARAMS_LOADING = "\nLoading GSM AAA data params into database\n";
$IDS_GSMAAA_DATA_PARAMS_FAILED = "\n*** Error:  GSM AAA data params not loaded properly\n";
$IDS_GSMAAA_DATA_PARAMS_SUCCESS = "\n GSM AAA data params successfully loaded\n";

$IDS_TCFAAA_RESERVATION_DATA_LOADING = "\nLoading TCF AAA reservation data into database\n";
$IDS_TCFAAA_RESERVATION_DATA_FAILED = "\n*** Error:  TCF AAA reservation data not loaded properly\n";
$IDS_TCFAAA_RESERVATION_DATA_SUCCESS = "\n TCF AAA reservation data successfully loaded\n";

$IDS_VOUCHER_MAP_LOADING = "\nLoading Voucher permit map into database\n";
$IDS_VOUCHER_MAP_FAILED = "\n*** Error:  Voucher permit map not loaded properly\n";
$IDS_VOUCHER_MAP_SUCCESS = "\n Voucher permit map successfully loaded\n";

$IDS_VOUCHER_CONFIG_LOADING = "\nLoading Voucher config into database\n";
$IDS_VOUCHER_CONFIG_FAILED = "\n*** Error:  Voucher config not loaded properly\n";
$IDS_VOUCHER_CONFIG_SUCCESS = "\n Voucher config successfully loaded\n";

$IDS_VOUCHER_DEVICE_LOADING = "\nLoading Voucher device into database\n";
$IDS_VOUCHER_DEVICE_FAILED = "\n*** Error:  Voucher device not loaded properly\n";
$IDS_VOUCHER_DEVICE_SUCCESS = "\n Voucher device successfully loaded\n";

$IDS_VOUCHER_ORDER_LOADING = "\nLoading Voucher order into database\n";
$IDS_VOUCHER_ORDER_FAILED = "\n*** Error:  Voucher order not loaded properly\n";
$IDS_VOUCHER_ORDER_SUCCESS = "\n Voucher order successfully loaded\n";

$IDS_VOUCHER_DEALERS_LOADING = "\nLoading pin_dealers into database\n";
$IDS_VOUCHER_DEALERS_FAILED = "\n*** Error:  pin_dealers not loaded properly\n";
$IDS_VOUCHER_DEALERS_SUCCESS = "\n pin_dealers successfully loaded\n";

$IDS_VOUCHER_CARD_TYPE_LOADING = "\nLoading pin_recharge_card_type into database\n";
$IDS_VOUCHER_CARD_TYPE_FAILED = "\n*** Error:  pin_recharge_card_type  not loaded properly\n";
$IDS_VOUCHER_CARD_TYPE_SUCCESS = "\n pin_recharge_card_type successfully loaded\n";

$IDS_VOUCHER_DEVICE_STRINGS_LOADING = "\nLoading Voucher device strings into database\n";
$IDS_VOUCHER_DEVICE_STRINGS_FAILED = "\n*** Error:  Voucher device strings not loaded properly\n";
$IDS_VOUCHER_DEVICE_STRINGS_SUCCESS = "\n Voucher device strings successfully loaded\n";

$IDS_VOUCHER_ORDER_STRINGS_LOADING = "\nLoading Voucher order strings into database\n";
$IDS_VOUCHER_ORDER_STRINGS_FAILED = "\n*** Error:  Voucher order strings not loaded properly\n";
$IDS_VOUCHER_ORDER_STRINGS_SUCCESS = "\n Voucher order strings successfully loaded\n";

$IDS_TCF_TAGS_LOADING = "\nLoading pin_telco_tags into database\n";
$IDS_TCF_TAGS_FAILED = "\n*** Error:  pin_telco_tags not loaded properly\n";
$IDS_TCF_TAGS_SUCCESS = "\n pin_telco_tags successfully loaded\n";

$IDS_TCF_PROV_LOADING = "\nLoading pin_telco_provisioning into database\n";
$IDS_TCF_PROV_FAILED = "\n*** Error:  pin_telco_provisioning not loaded properly\n";
$IDS_TCF_PROV_SUCCESS = "\n pin_telco_provisioning successfully loaded\n";

$IDS_TCF_SERVICE_LOADING = "\nLoading pin_telco_service_order_state into database\n";
$IDS_TCF_SERVICE_FAILED = "\n*** Error:  pin_telco_service_order_state not loaded properly\n";
$IDS_TCF_SERVICE_SUCCESS = "\n pin_telco_service_order_state successfully loaded\n";

$IDS_TCF_NOTIFY_LOADING = "\nLoading pin_notify_telco into database\n";
$IDS_TCF_NOTIFY_FAILED = "\n*** Error:  pin_notify_telco not loaded properly\n";
$IDS_TCF_NOTIFY_SUCCESS = "\n pin_notify_telco successfully loaded\n";

$IDS_NOTIFY_LOADING = "\nLoading pin_notify into database\n";
$IDS_NOTIFY_FAILED = "\n*** Error:  pin_notify not loaded properly\n";
$IDS_NOTIFY_SUCCESS = "\n pin_notify successfully loaded\n";

$IDS_INVOICE_TEMPLATE_LOADING = "\nLoading pin_load_invoice_template into database\n";
$IDS_INVOICE_TEMPLATE_FAILED = "\n*** Error:  pin_load_invoice_template not loaded properly\n";
$IDS_INVOICE_TEMPLATE_SUCCESS = "\n pin_load_invoice_template successfully loaded\n";

$IDS_TCF_PERMIT_LOADING = "\nLoading pin_device_permit_map_num_telco into database\n";
$IDS_TCF_PERMIT_FAILED = "\n*** Error:  pin_device_permit_map_num_telco not loaded properly\n";
$IDS_TCF_PERMIT_SUCCESS = "\n pin_device_permit_map_num_telco successfully loaded\n";

$IDS_TCF_PERMITTED_SERVICE_TYPES_LOADING = "\nLoading pin_service_framework_permitted_service_types into database\n";
$IDS_TCF_PERMITTED_SERVICE_TYPES_FAILED = "\n*** Error:  pin_service_framework_permitted_service_types not loaded properly\n";
$IDS_TCF_PERMITTED_SERVICE_TYPES_SUCCESS = "\n pin_service_framework_permitted_service_types successfully loaded\n";

$IDS_RA_CONTROLPOINT_LOADING = "\nLoading pin_config_controlpoint_link into database\n";
$IDS_RA_CONTROLPOINT_FAILED = "\n*** Error:  pin_config_controlpoint_link not loaded properly\n";
$IDS_RA_CONTROLPOINT_SUCCESS = "\n pin_config_controlpoint_link successfully loaded\n";

$IDS_IFW_SYNC_QUEUE_CREATION = "\nCreating Default Queue in the Queue database\n";
$IDS_IFW_SYNC_QUEUE_CREATION_FAILED = "\n*** Error: Queue creation failed in the Queue Database\n";
$IDS_IFW_SYNC_QUEUE_CREATION_SUCCESS = "\nDefault Queue successfully created in the Queue Database\n";

$IDS_DM_AQ_QUEUE_CREATION = "\nCreating Default Queue in the Queue database\n";
$IDS_DM_AQ_QUEUE_CREATION_FAILED = "\n*** Error: Queue creation failed in the Queue Database\n";
$IDS_DM_AQ_QUEUE_CREATION_SUCCESS = "\nDefault Queue successfully created in the Queue Database\n";

$IDS_ZONEMAP_LOADING = "\nLoading Zone Maps into database\n";	
$IDS_ZONEMAP_FAILED = "\n*** Error:  Zone Maps not loaded properly\n";
$IDS_ZONEMAP_SUCCESS = "\n\nZone Maps successfully loaded\n";

$IDS_STARTING = "Starting %s...\n";
$RESTARTING_CM = "Restarting the Connection Manager to flush cached information\n";
$IDS_MSGS_LOADING = "\nLoading Localized Messages into database\n";
$IDS_MSGS_FAILED = "\n*** Error:  Localized Messages not loaded properly\n";
$IDS_MSGS_SUCCESS = "\nLocalized Messages successfully loaded\n";

$IDS_NOTE_CONFIG_LOADING = "\nLoading Note Config object into database\n";
$IDS_NOTE_CONFIG_FAILED = "\n*** Error: Note Config object not loaded properly\n";
$IDS_NOTE_CONFIG_SUCCESS = "\nNote Config object successfully loaded\n";

$IDS_PIN_TELCO_AAA_PARAMS_LOADING = "\nLoading pin_telco_aaa_params to create  /config/aaa object \n";
$IDS_PIN_TELCO_AAA_PARAMS_FAILED = "\n*** Error: pin_telco_aaa_params not loaded properly\n";
$IDS_PIN_TELCO_AAA_PARAMS_SUCCESS = "\n\npin_telco_aaa_params Codes successfully loaded\n";

$IDS_RERATE_FLDS_LOADING = "\nLoading pin_rerate fields \n";
$IDS_RERATE_FLDS_FAILED = "\nLoad pin_rerate fields failed\n";
$IDS_RERATE_FLDS_SUCCESS = "\nLoad pin_rerate fields successful\n";

$IDS_PIN_INIT_FAILED = <<END
*** Error:  Unable to update the Portal Base database.
            Exiting from the install without finishing successfully.
            Please check for errors in %s
            and then rerun this program.
END
;

$IDS_DNA_REP_SETUP = "\nSetting up DNA replication\n";
$IDS_DNA_REP_DB_SETUP = "\nSetting up replication for database %s\n";
$IDS_DNA_SETUP_FAILED = "\n*** Error: DNA database configuration failed\n";
$IDS_DNA_REP_FAILED = "\n*** Error: Failed while setting up replication for database %s\n";
$IDS_DNA_CREATE_OBJS = "\nExecuting replication script %s\n";
$IDS_DNA_CREATE_OBJS_FAILED = "\n*** Error: Failed while executing replication script %s\n";
$IDS_DNA_GET_DBNR = "\nObtaining database number for database %s\n";
$IDS_DNA_GET_DBNR_FAILED = "\n*** Error: Failed while getting database number for database %s\n";
$IDS_DNA_OPENTEMP_FAILED = "\n*** Error: Failed to create temp file to get database number\n";
$IDS_GSM_LOADING ="\nTurning on Audit for the database fields\n";
$IDS_GSM_FAILED ="\n****Error: Failed to turn on Audit for the database fields %s\n"; 
$IDS_GSM_SUCCESS ="\nAuditing enabled for database fields\n";

$IDS_SUCCESS = "\n\n!! Your installation has completed !!\n";
$IDS_CLASSIDS_PL_FOUND = "\nFound pin_gen_classid_values.pl.  Executing ... \n";

$IDS_GENERIC_PIN_CONF_HEADER = <<END
#======================================================================
#
# You can edit this file to suit your specific configuration:
#  -- You can change the default values of an entry.
#  -- You can exclude an optional entry by adding the # symbol
#     at the beginning of the line.
#  -- You can include a commented entry by removing the # symbol.
#
# Before you make any changes to this file, save a backup copy.
#
# To edit this file, follow the instructions in the commented sections.
# For more information on the general syntax of configuration entries,
# see "Reference Guide to Portal Configuration Files" in the Portal
# online documentation.
#======================================================================
END
;

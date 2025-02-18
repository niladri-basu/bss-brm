#=============================================================
#  @(#)%Portal Version: pin_cnf_acctsync.pl:InstallVelocityInt:7:2005-Jul-07 16:46:04 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#=============================================================
$ACCTSYNC_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Portal with IFW Synchronization Data Manager
#
#
# This configuration file is automatically installed and configured with
# default values during Portal installation. You can edit this file to:
#   -- change the default values of the entries.
#   -- disable an entry by inserting a crosshatch (#) at the start of
#        the line.
#   -- enable a commented entry by removing the crosshatch (#).
# 
# Before you make any changes to this file, save a backup copy.
#
# When editing this file, follow the instructions in each section.
# For more information on the general syntax of configuration entries,
# see "Reference Guide to Portal Configuration Files" in the Portal
# online documentation.
#************************************************************************
END
;

%ACCTSYNC_PINCONF_ENTRIES_COMMON = (

  "queue_map_file_description", <<END
#========================================================================
# queue_map_file
#
# File contains the queue object name for each databasequeue names and 
# which events are sent to which queues.
#========================================================================
END
	,"queue_map_file", "- dm_ifw_sync queue_map_file ./$DM_IFW_SYNC{'queue_map_file'}"


	,"connect_retries_description", <<END
#========================================================================
# connect_retries
#
# Specifies the number of times that the IFW Sync Data Manager retries a
# connection to the Oracle database server.
#
# If this entry is missing or disabled, the default value is 1.
# If you have problems connecting to the database, increase the number
# of retries. You can use any number.
#========================================================================
END
	,"connect_retries", "- dm_ifw_sync connect_retries $DM_IFW_SYNC{'connect_retries'}"

,"retry_interval_description", <<END
#========================================================================
# retry_interval
#
# Interval time in seconds between each retry
#========================================================================
END
	,"retry_interval", "- dm_ifw_sync retry_interval $DM_IFW_SYNC{'retry_interval'}"

, "dm_loglevel_description", <<END
#========================================================================
# dm_loglevel
#
# Specifies how much information the IFW Sync Data Manager logs.
# 
# The value for this entry can be:
#
#    0 = no logging
#    1 = (Default) log error messages only
#    2 = log error messages and warnings
#    3 = log error, warning, and debugging messages
#========================================================================
END
	, "dm_loglevel", "- dm loglevel $DM_IFW_SYNC{'log_level'}"
,"crypt_description", <<END
#========================================================================
# crypt <encryption scheme tag>
#
# Associates a four-byte tag with an encryption algorithm and secret
# key combination.
#
# Specify the encryption algorithm by naming the shared binary object that
# contains the code.
#
# The secret key is a string of characters enclosed in double quotation
# marks. The quotation marks are not considered part of the secret key.
# Any character allowed in a C-language string is allowed in the secret
# key string.
#
# The configurations below show an example for Solaris, an example for
# HP and an example for Windows NT. Notice the difference in shared
# binary object names, which is required by the conventions of the
# underlying operating system.
#========================================================================
END
	,"crypt",
"#- crypt md5| \$\{PIN_HOME\}/lib/${LIBRARYPREFIXVAR}pin_crypt4dm\$\{LIBRARYEXTENSION\} \"Abracadabra dabracaabrA\""
	
);

%ACCTSYNC_PINCONF_ENTRIES_ORACLE = (

"queuing_database_description", <<END
#========================================================================
# queuing_database
#
# Specifies the database alias name of the database to which the DM connects to
# enqueue messages.
#
# This is the database alias you defined when setting up your database for queuing.
# For example, for Oracle this is the SQL*NET alias defined in the
# tnsnames.ora file.
#========================================================================
END
	,"queuing_database", "- dm_ifw_sync sm_database $DM_IFW_SYNC{'queuing_db_alias'}"

,"queuing_database_id_description", <<END
#========================================================================
# queuing_database_id
#
# Specifies the database user name that the ifw_sync DM uses to log in to the
# Queuing database.
#========================================================================
END
	,"queuing_database_id", "- dm_ifw_sync sm_id $DM_IFW_SYNC{'queuing_db_user'}"

,"queuing_database_pw_description", <<END
#========================================================================
# queuing_database_pw
#
# Specifies the password for the user specified in the queuing_database_id entry.
#========================================================================
END
	,"queuing_database_pw", "- dm_ifw_sync sm_pw $DM_IFW_SYNC{'queuing_db_password'}"
	
	,"dm_plugin_name_oracle_description", <<END
#========================================================================
# dm_plugin_name_oracle
#
# Specifies a pointer to a shared library that contains the code that
# implements the required interfaces of dm_eai, as defined in
# dm_eai_plugin.h. Replace the entry with the name of the implemented
# plugin.
#========================================================================
END
	, "dm_plugin_name_oracle", "- dm plugin_name ./$DM_IFW_SYNC{'plugin_oracle'}"

);

%ACCTSYNC_PINCONF_ENTRIES_SQLSERVER = (

	"dm_mq_server_name_description", <<END
#========================================================================
# dm_mq_server_name
#
# Specifies the server name where MSMQ resides.
#========================================================================
END
	,"dm_mq_server_name", "- dm_ifw_sync_msmq mq_server_name $DM_IFW_SYNC{'server_name'}"

,"dm_queue_module_description", <<END
#========================================================================
# dm_queue_module
#
# Specifies the MSMQ library name.
#========================================================================
END
	,"dm_queue_module", "- dm_ifw_sync_msmq queue_module $DM_IFW_SYNC{'queue_module'}"
	
    ,"dm_plugin_name_odbc_description", <<END
#========================================================================
# dm_plugin_name_odbc
#
# Specifies a pointer to a shared library that contains the code that
# implements the required interfaces of dm_eai, as defined in
# dm_eai_plugin.h. Replace the entry with the name of the implemented
# plugin.
#========================================================================
END
	, "dm_plugin_name_odbc", "- dm plugin_name ./$DM_IFW_SYNC{'plugin_odbc'}"
);

%ACCTSYNC_CM_PINCONF_ENTRIES = (
"ifw_sync_fm_required_description", <<END
#========================================================================
# ifw_sync_fm_required
#
# Required Facilities Modules (FM) configuration entries
# The entries below specify the required FMs that are linked to the CM when
# the CM starts. The FMs required by the CM are included in this file when
# you install Portal. 
#
# Caution: DO NOT modify these entries unless you need to change the
#          location of the shared library file. DO NOT change the order of
#          these entries, because certain modules depend on others being
#          loaded before them.
#========================================================================
END
  , "ifw_sync_fm_required",<<END
- cm fm_module \$\{PIN_HOME\}/lib/fm_ifw_sync\$\{LIBRARYEXTENSION\} fm_ifw_sync_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_ifw_sync_pol\$\{LIBRARYEXTENSION\} fm_ifw_sync_pol_config$FM_FUNCTION_SUFFIX - pin
END
  ,"ifw_sync_dm_pointer_description", <<END
#========================================================================
# ifw_sync_dm_pointer
# Specifies where to find the external manager that provides the opcode 
# for IFW Synchronization.
#========================================================================
END
  , "ifw_sync_dm_pointer"
  , "- cm dm_pointer $DM_IFW_SYNC{'db_num'} ip $DM_IFW_SYNC{'hostname'} $DM_IFW_SYNC{'port'}  # dm_ifw_sync"	
 );
 
 

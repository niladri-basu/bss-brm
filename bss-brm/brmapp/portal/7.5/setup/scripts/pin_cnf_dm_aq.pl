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
$DM_AQ_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Portal with DM_AQ Data Manager
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

%DM_AQ_PINCONF_ENTRIES = (

  "queue_map_file_description", <<END
#========================================================================
# queue_map_file
#
# File contains the queue object name for each databasequeue names and 
# which events are sent to which queues.
#========================================================================
END
	,"queue_map_file", "- dm_aq queue_map_file $DM_AQ{'queue_map_file'}"
	,"queuing_database_description", <<END
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
	,"queuing_database", "- dm_aq sm_database $DM_AQ{'queuing_db_alias'}"
	,"queuing_database_id_description", <<END
#========================================================================
# queuing_database_id
#
# Specifies the database user name that the DM uses to log in to the
# Queuing database.
#========================================================================
END
	,"queuing_database_id", "- dm_aq sm_id $DM_AQ{'queuing_db_user'}"
	,"queuing_database_pw_description", <<END
#========================================================================
# queuing_database_pw
#
# Specifies the password for the user specified in the queuing_database_id entry.
#========================================================================
END
	,"queuing_database_pw", "- dm_aq sm_pw $DM_AQ{'queuing_db_password'}"
	,"connect_retries_description", <<END
#========================================================================
# connect_retries
#
# Specifies the number of times that the dm_aq retries a
# connection to the queue.
#
# If this entry is missing or disabled, the default value is 1.
# the number of retries - you can use any number.
#========================================================================
END
	,"connect_retries", "- dm_aq connect_retries $DM_AQ{'connect_retries'}"

,"retry_interval_description", <<END
#========================================================================
# retry_interval
#
# Interval time in seconds between each retry
#========================================================================
END
	,"retry_interval", "- dm_aq retry_interval $DM_AQ{'retry_interval'}"

, "dm_loglevel_description", <<END
#========================================================================
# dm_loglevel
#
# Specifies how much information this DM should log.
#
# The value for this entry can be:
#  -- 0: no logging
#  -- 1: log error messages only. (Default)
#  -- 2: log error messages and warnings.
#  -- 3: log error messages, warnings, and debugging messages.
#========================================================================
END
	, "dm_loglevel", "- dm loglevel $DM_AQ{'log_level'}"

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
	
, "internal_option_description", <<END
#========================================================================
# internal_option
# specify to disable the NAGLE algorithm for sockets.
# default 0 is to enable the NAGLE algorithm
#
#========================================================================
END
	,"internal_option", "- - pcm_nagle_disable 0"

, "service_poid_description", <<END
#==================================================================================
# service_poid
# Enables the filtering of events generated from the specified service and drop it
# from sending to the queue.This is used for specifying the service_poid associated
# with the external integrated application so that the events generated due to the
# action initiated by the system will not be sent to the system for sync.
#
# The entry is commented by default and has value of 0.0.0.1 /service/admin_client 2
#===================================================================================
END
	, "service_poid", "#- dm_aq service_poid $DM_ORACLE{'db_num'} /service/admin_client 2"

	,"dm_aq_plugin_name_description", <<END
#========================================================================
# dm_aq_plugin_name
#
# Specifies a pointer to a shared library that contains the code that
# implements the required interfaces of dm_eai, as defined in
# dm_eai_plugin.h. Replace the entry with the name of the implemented
# plugin.
#========================================================================
END
	, "dm_aq_plugin_name", "- dm plugin_name $DM_AQ{'location'}/$DM_AQ{'plugin_oracle'}"


);

%DM_AQ_CM_PINCONF_ENTRIES = (

   "dm_aq_dm_pointer_description", <<END
#========================================================================
# dm_aq_dm_pointer
# Specifies where to find the external manager that provides the opcode 
# for CRM Synchronization.
#========================================================================
END
  , "dm_aq_dm_pointer"
  , "- cm dm_pointer $DM_AQ{'db_num'} ip $DM_AQ{'hostname'} $DM_AQ{'port'}  # dm_aq"	

);

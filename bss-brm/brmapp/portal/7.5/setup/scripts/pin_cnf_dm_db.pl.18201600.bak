#=======================================================================
#  $Id: pin_cnf_dm_db.pl /cgbubrm_main.portalbase/2 2011/05/27 16:17:50 ngougol Exp $
# 
# Copyright (c) 2005, 2011. Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
##
## Also requires DM pin.cnf entries
##
#************************************************************************
# Configuration Entries to Control Permissions to the Data Dictionary
#
#
# Use the entries below to specify what this Data Manager can
# modify in the data dictionary.
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
#
# In all cases, if the value of the entry is "1", the Data Manager can
# make the changes. If the value is "0" or missing, the Data Manager
# can't make the changes.
#************************************************************************

%DM_ORACLE_DB_PINCONF_ENTRIES = (

	"stmt_cache_entries_description", <<END
#========================================================================
# stmt_cache_entries
#
# Specifies the maximum number of Oracle statement handles to cache, to
# improve Portal performance.
#
# The value for this entry can be:
#
#    0 = Disable the statement cache.
#    1 = (Default) 32
#
# Note: If you need to cache more statement handles, please consult with
#       Portal PPSG for advice. For more details, see the online document
#       "Portal Configuration and Tuning Guide."
#========================================================================
END
	,"stmt_cache_entries", "- dm stmt_cache_entries $DM{'stmt_cache_entries'}"
);


%DM_ODBC_DB_PINCONF_ENTRIES = (

	"dm_mr_enable_description", <<END
#========================================================================
# dm_mr_enable 1
#
# Specifies to use database cursors to fetch multiple rows.
#
# This entry must ALWAYS be set to 1, to work around a known bug in
# Microsoft SQL Server and its ODBC driver components. Do not change it.
#========================================================================
END
	,"dm_mr_enable", "- dm dm_mr_enable 1"
);

%DM_DB2_DB_PINCONF_ENTRIES = (

        "dm_blob_size_description", <<END
#======================================================================
# dm_blob_size
#
# This parameter is used to specify the maximum blob size in ddls for db2
# Default        524288
# Valid Range    16384 - 671088664
#
#======================================================================
END
        ,"dm_blob_size", "- dm dm_blob_size 524288"
	,"dm_not_logged_for_blobs_description", <<END
#======================================================================
# dm_not_logged_for_blobs
#
# Used to specify the logging options for blobs in DB2
#
# Valid values: 0 or 1
# Default : 0 
# The value 0 is used to specify  "LOGGED" as the blob option and the value 1 
# for  "NOT LOGGED".
#======================================================================
END
	,"dm_not_logged_for_blobs","- dm dm_not_logged_for_blobs 0"
);

%DM_DB_PINCONF_ENTRIES = (
	"dd_0sm_database_ddl_description", <<END
#========================================================================
# sm_database_ddl
#
# Specifies whether to use Data Definition Language (DDL) when updating
# the data dictionary tables for object type changes.
#
# The value for this entry can be:
#
#    0 = Update the data dictionary for changes but don't execute DDLs,
#          such as for creating tables and adding columns.
#    1 = Use DDL to ensure that objects are mapped correctly to tables.
#========================================================================
END
	,"dd_0sm_database_ddl", "- dm sm_".$DM{'db'}->{'vendor'}."_ddl $DM{'uses_ddl'}"
	,"dd_write_enable_objects_description", <<END
#========================================================================
# dd_write_enable_objects
#
# Specifies whether this Data Manager can edit, create, and delete
# custom storable classes in the data dictionary.
#
# Note: If you want the DM to be able to modify predefined storable
#       classes, see the entry for dd_write_enable_portal_objects.
#
#  The value for this entry can be:
#
#  0 = Disables editing, creating and deleting custom storable classes in the
#  data dictionary.
#  1 = Enables editing, creating and deleting custom storable classes in the
#  data dictionary.
#  Default: 0
#
#========================================================================
END
	,"dd_write_enable_objects", "- dm dd_write_enable_objects $DM{'enable_write_objects'}"
	,"dd_write_enable_fields_description", <<END
#========================================================================
# dd_write_enable_fields
#
# Specifies whether this Data Manager can create fields in the data
# dictionary.
#
# The value for this entry can be:
#
#  0 = Disable creating fields in the data dictionary.
#  1 = Enable creating fields in the data dictionary.
#  Default: 0
#========================================================================
END
	,"dd_write_enable_fields", "- dm dd_write_enable_fields $DM{'enable_write_fields'}"
	,"dd_write_enable_portal_objects_description", <<END
#========================================================================
# dd_write_enable_portal_objects
#
# Specifies whether this Data Manager can delete predefined Portal
# storable classes and add and delete fields in one of those classes.
#
# Note: If you want to modify custom storable classes but protect
#       predefined classes from accidental changes, use the
#       dd_write_enable_objects and dd_write_enable_fields entries.
#
# The value for this entry can be:
#       0 = Disables Data Manager for deleting predefined Portal
#           storable classes and also to add and delete fields in one of those classes.
#       1 = Enables Data Manager for deleting predefined Portal
#           storable classes and to add and delete fields in one of those classes.
# Default: 0
#
#========================================================================
END
	,"dd_write_enable_portal_objects", "- dm dd_write_enable_portal_objects $DM{'enable_write_portal_objects'}"
	,"db_0_sm_database_description", <<END
#************************************************************************
# Configuration Entries for Connecting to the Portal Database
#************************************************************************
#
#========================================================================
# sm_database
#
# Specifies the database alias name.
#
# This is the SQL*NET alias you defined in the tnsnames.ora file when you
# set up the Oracle database. This entry was configured when you installed
# Portal, so you shouldn't have to change it.
# This is the database alias you defined when setting up your database.
# For example, for Oracle this is the SQL*NET alias defined in the
# tnsnames.ora file.  This entry was configured when you installed Portal,
# so you shouldn't have to change it.
#
# Note: If you have multiple database hosts, such as an Oracle Parallel
#       Server configuration, include a separate sm_database configuration
#       entry for each host.
#========================================================================
END
	,"db_0_sm_database", "- dm sm_database $DM{'db'}->{'alias'}"
	,"db_sm_id_description", <<END
#========================================================================
# sm_id
#
# Specifies the database user name that the DM uses to log in to the
# Portal database.
#
# This entry was configured when you installed Portal, but you can
# change it.
#
# Note: With Oracle, for example, you can use the OPS\$ option to log in
#       to the database without a password. See the Portal Install Guide
#       and Oracle documentation for more information.
#========================================================================
END
	,"db_sm_id", "- dm sm_id $DM{'db'}->{'user'}"
	,"db_sm_pw_description", <<END
#========================================================================
# sm_pw
#
# Specifies the password for the user specified in the sm_id entry.
#
# This password was configured when you installed Portal, but you
# should change it. The DM uses this password when logging in to the
# Portal database.
#
# Note: With Oracle, if you use the OPS\$ option, you don't have to
#       include this configuration entry. If you include the password
#       entry, read-protect this configuration file.
#========================================================================
END
	,"db_sm_pw", "- dm sm_pw $DM{'db'}->{'password'}"
        ,"sm_charset_description", <<END

#========================================================================
# sm_charset
#
#========================================================================
END
	,"sm_charset", "- dm sm_charset $DM{'sm_charset'}"
	,"crypt_description", <<END
#========================================================================
# crypt
# <encryption scheme tag>
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
"#- crypt md5| \$\{PIN_HOME\}/lib/${LIBRARYPREFIXVAR}pin_crypt4dm64\$\{LIBRARYEXTENSION\} \"Abracadabra dabracaabrA\""
	,"dm_in_batch_size_description", <<END
#======================================================================
# dm_in_batch_size
#
# Number of objects to batch up and retrieve in one go when retrieving
# data from sub-tables (arrays or substructs) in a search query
#
# If the value is "1", then portal defaults to the old behaviour
# The maximum value is 160
# 
# The default value is 80, which means up to 80 objects will be retrieved
# at one time. If the number required is greater than this, then the
# dm will request 80 mod n rows first, followed by batches of 80 from
# the database
#======================================================================
END
	 ,"dm_in_batch_size", "- dm dm_in_batch_size $DM{'in_batch_size'}",
);

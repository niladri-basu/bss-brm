#=======================================================================
# 
# Copyright (c) 2005, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$PIPELINE_DB_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Pricing Admin Framework
#
# You can edit this configuration file to suit your specific configuration:
#  -- You can change the default values of a parameter
#  -- You can exclude a parameter by adding the # symbol
#     at the beginning of the line
#  -- You can uncomment a parameter by removing the # symbol.
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

%PRICING_ADMIN_PINCONF_ENTRIES_COMMON = (
	"pipeline_default_table_space_name_description", <<END
#========================================================================
# pipeline_default_table_space_name
#
# - pipeline default_table_space_name <default table space for user>
#
# The tablespace that newly created Oracle users are assigned to. 
# The default value is INTEGRATE_TS_1_DAT.
# If this parameter isn’t included, Oracle assigns the user to the 
# SYSTEM tablespace.
#========================================================================
END
	,"pipeline_default_table_space_name", "- pipeline default_table_space_name INTEGRATE_TS_1_DAT"
	,"pipeline_default_role_name_description", <<END

#========================================================================
# pipeline_default_role_name
#
# - pipeline_default_role_name  <default roles for user>
#
#  The name of the role that has select, insert, delete, and update privileges on IFW_* and JSA_* tables. 
#  The default value is INTEGRATE_ROLE_ALL.
#========================================================================
END
	,"pipeline_default_role_name", "- pipeline database_role_name  INTEGRATE_ROLE_ALL"
	,"pipeline_host_description", <<END

#========================================================================
# pipeline_host
#
# - pipeline host <Host Name>
#
# The host name for the server where the pipeline database is located.
#========================================================================
END
	,"pipeline_host", "- pipeline host $PRICING_ADMIN{'host_name'}"

	,"pipeline_db_description", <<END
#========================================================================
# pipeline_db
#
# - pipeline db <database instance>
#
# The name of the pipeline database instance.
#========================================================================
END
	,"pipeline_db", "- pipeline db pindb"

	,"pipeline_login_name_description", <<END

#========================================================================
# pipeline_login_name
#
# - pipeline login_name <database login name>
#
# The default pipeline database username.
# Important : You must specify a value the login_name before you run 
#             the pricing_admin.pl script with the -init option.
#========================================================================
END
	,"pipeline_login_name", "- pipeline login_name integrate"
	,"pipeline_login_pw_description", <<END

#========================================================================
# pipeline_login_pw
#
# - pipeline login_pw <database user password>
#
# The password of default pipeline database user.
# Important : You must specify a value for login_pw before you run 
#             the pricing_admin.pl script with the -init option.
#========================================================================
END
	,"pipeline_login_pw", "- pipeline login_pw &aes|09|0D5E11BFDD97D2769D9B0DBFBD1BBF7E29AE33E3CD30119B4667038FA1BEE8706F"

	,"pricing_db_alias_description", <<END
#========================================================================
# pricing_db_alias
#
# - pipeline db_alias <database alias>
#
# The alias used to log in to the pipeline database if the server is Oracle. 
# Make sure that the tnsnames.ora file contains an entry with this alias as well.
#========================================================================
END
	,"pricing_db_alias", "- pipeline db_alias ttal"

);

%PRICING_ADMIN_PINCONF_ENTRIES_ORACLE = (
	
	"pipeline_port_oracle_description", <<END
#========================================================================
# pipeline_port_oracle
#
# - pipeline port <The port number>
#
# The port number used by the pipeline database listener.
#========================================================================
END
	,"pipeline_port_oracle", "- pipeline port $PRICING_ADMIN{'oracle_port_number'}"
	
	,"pipeline_db_type_oracle_description", <<END
#========================================================================
# pipeline_db_type_oracle
#
# - pipeline db_type <Type of database>
#
# The name of the database vendor. 
# The value should be one of the system database driver groups of entries in jsaconf.properties.
# Enter either oracle or SQLServer.
#========================================================================
END
	,"pipeline_db_type_oracle", "- pipeline db_type $PRICING_ADMIN{'oracle_db_type'}"

	,"pipeline_admin_oracle_description", <<END
#========================================================================
# pipeline_admin_oracle
#
# - pipeline admin <database admin name>
#
# The DBA on the pipeline database that has user creation privileges.
#========================================================================
END
	,"pipeline_admin_oracle", "- pipeline admin $PRICING_ADMIN{'oracle_admin_name'}"
	
	,"pipeline_admin_pw_oracle_description", <<END
#========================================================================
# pipeline_admin_pw_oracle
#
# - pipeline admin_pw <admin password>
#
# The password of the DBA account.
#========================================================================
END
	,"pipeline_admin_pw_oracle", "- pipeline admin_pw $PRICING_ADMIN{'oracle_admin_passwd'}"
	
);

%PRICING_ADMIN_PINCONF_ENTRIES_SQLSERVER = (
	
	"pipeline_port_odbc_description", <<END
#========================================================================
# pipeline_port_odbc
#
# - pipeline port <The port number>
#
# The port number used by the pipeline database listener.
#========================================================================
END
	,"pipeline_port_odbc", "- pipeline port $PRICING_ADMIN{'odbc_port_number'}"
	
	,"pipeline_db_type_odbc_description", <<END
#========================================================================
# pipeline_db_type_odbc
#
# - pipeline db_type <Type of database>
#
# The name of the database vendor. 
# The value should be one of the system database driver groups of entries in jsaconf.properties.
# Enter either oracle or SQLServer.
#========================================================================
END
	,"pipeline_db_type_odbc", "- pipeline db_type $PRICING_ADMIN{'odbc_db_type'}"

	,"pipeline_admin_odbc_description", <<END
#========================================================================
# pipeline_admin_odbc
#
# - pipeline admin <database admin name>
#
# The DBA on the pipeline database that has user creation privileges.
#========================================================================
END
	,"pipeline_admin_odbc", "- pipeline admin $PRICING_ADMIN{'odbc_admin_name'}"
	
	,"pipeline_admin_pw_odbc_description", <<END
#========================================================================
# pipeline_admin_pw_odbc
#
# - pipeline admin_pw <admin password>
#
# The password of the DBA account.
#========================================================================
END
	,"pipeline_admin_pw_odbc", "- pipeline admin_pw $PRICING_ADMIN{'odbc_admin_passwd'}"
	
);

#=======================================================================
#  @(#)%Portal Version: pin_cnf_infmgr_cli.pl:InstallVelocityInt:1:2005-Mar-25 18:12:53 %
# 
# Copyright (c) 2005, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$INFMGR_CLI_PINCONF_HEADER  = <<END
#************************************************************************
# Configuration File for the infmgr_cli Utility
#
#
# Use this file to specify how infmgr_cli connects with Portal Manager.
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

%INFMGR_CLI_PINCONF_ENTRIES = (
	"cm_ptr_description", <<END
#========================================================================
# cm_ptr
# 
# Specifies a pointer to an Portal Manager.
#
# Use a separate entry for each Portal Manager. If infmgr_cli can't
# find the first Portal Manager, it looks for the next in the list.
#
# Each entry includes three values:
#
#    <protocol> = "ip", for this release
#    <host>     = the name or IP address of the computer running the
#                   Portal Manager
#    <port>     = the TCP port number of the Portal Manager on this
#                   computer
#
# The port number should match a corresponding infmgr_port entry with
# the same port number in the Portal Manager configuration file. The
# default, 11980, is a commonly specified port for Portal Manager.
#========================================================================
END
	,"cm_ptr", "- nap cm_ptr ip $INFMGR{'hostname'} $INFMGR{'port'}"
	,"cm_ptr_userid_description", <<END
#========================================================================
# userid
#
# Specifies the database number and service type for the Portal
# database. 
#
# The CM uses the database number to identify the Portal database 
# and to connect to the correct Data Manager. For connections that don't
# require a login name and password, the CM also passes the service
# type to the database.
#
# The database number, in the form 0.0.0.N, is the number assigned to 
# your Portal database when you installed the system. The default
# is 0.0.0.1.
#
# The service type is /service/pcm_client and the ID is 1.
# DO NOT change these values.
#========================================================================
END
	,"cm_ptr_userid", "- - userid $DM{'db_num'} /service/pcm_client 1"
	,"cm_ptr_login_description", <<END
#************************************************************************
# The next three entries specify login information for Portal Manager:
#************************************************************************
#
#========================================================================
# login_type
#
# Specifies whether the login name and password are required.
#
# The value for this entry can be:
#
#    0 = Only a user ID is required.
#    1 = (Default) Both a name and a password are required.
#========================================================================
END
	,"cm_ptr_login", "- nap login_type 1"
	,"login_name_description", <<END
#========================================================================
# login_name
#
# Specifies the login name to use when infmgr_cli requests a connection to
# Portal Manager. 
#========================================================================
END
	,"login_name", "- nap login_name root.$DM{'db_num'}"
	,"login_pw_description", <<END
#========================================================================
# login_pw
#
# Specifies the password to use when infmgr_cli connects to Portal
# Manager.
#========================================================================
END
 ,"login_pw", "- nap login_pw   &aes|08|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5D40C305EDF3D77DF111AAB8F781E92122"
 );

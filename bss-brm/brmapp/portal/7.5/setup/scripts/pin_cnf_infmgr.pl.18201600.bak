#=======================================================================
#  @(#)%Portal Version: pin_cnf_infmgr.pl:InstallVelocityInt:4:2005-Mar-25 18:12:55 %
# 
# Copyright (c) 2005, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$INFMGR_PINCONF_HEADER  = <<END
#************************************************************************
# Configuration File for Portal Manager
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

%INFMGR_PINCONF_ENTRIES = (
	"infmgr_port_description", <<END
#========================================================================
# infmgr_port
# 
# Specifies the port number of the computer where Portal Manager runs. 
#
# This number should be greater than 1000, unless you start Portal
# Manager as root. The default, 11980, is a commonly specified port for
# Portal Manager.
#========================================================================
END
	,"infmgr_port", "- infmgr infmgr_port $INFMGR{'port'}"
	,"infmgr_name_description", <<END
#========================================================================
# infmgr_name
# 
# Specifies the name or IP address of the computer where Portal Manager
# runs.
#
# The name can be:
#
#    - (hyphen)                = Portal can use any IP address on the
#                                  computer running Portal Manager.
#
#    <host name or IP address> = Portal should use a particular IP
#                                  address on the computer running
#                                  Portal Manager.
#
# This entry is optional. If you remove or disable it, Portal
# uses gethostname to find the IP address of the Portal Manager 
# computer.
#========================================================================
END
	,"infmgr_name", "- infmgr infmgr_name $INFMGR{'hostname'}"
	,"infmgr_logfile_description", <<END
#========================================================================
# infmgr_logfile
#
# Specifies the full path to the log file for Portal Manager.
#
# You can enter any valid path.
#========================================================================
END
	,"infmgr_logfile", "- infmgr infmgr_logfile \$\{PIN_LOG_DIR\}/infmgr/infmgr.pinlog"
	,"node_ptr_description", <<END
#========================================================================
# node_ptr
#
# Specifies the nodes that Portal Manager should monitor.
#
# Set up one configuration entry for each node. To set up an entry, 
# remove the crosshatch (#) at the start of the line and enter values for:
#
#    <node name>   = the name of the node; this name must be unique
#                      within the Portal network
#    <host>        = the host name or IP address of the computer running
#                      the node manager
#    <port number> = the port number of the computer running the node
#                      manager
#========================================================================
#- infmgr node_ptr <node name> <host name> <port number>
END
	,"node_ptr", "- infmgr node_ptr $NMGR{'hostname'} $NMGR{'hostname'} $NMGR{'port'}"
	,"satellitecm_ptr_description", <<END

#========================================================================
# satellitecm_ptr
#
# Specifies the satellite CMs.
#
# Use one configuration entry for each satellite CM. To do so, remove 
# the crosshatch (#) at the start of the line and enter values for:
#
#    <satellite CM name> = the name of the CM
#    <proto>             = the protocol
#    <host>              = the host name or IP address of the computer
#                            running this node
#    <port number>       = the port number of the computer running this
#                            node
#========================================================================
END
	,"satellitecm_ptr",
 "#- infmgr satellitecm_ptr 'satelliteCM1' ip <host name> <port number>"
	,"logmgr_port_description", <<END

#========================================================================
# logmgr_port
#
# Starts an Portal Manager thread for collecting all log messages sent
# by Node Managers.
#
# To enable this feature, remove the crosshatch (#) from the start of the
# line and enter the port number where you want Portal Manager to listen.
#========================================================================
END
	,"logmgr_port", "#- logmgr_port <port number>"
	,"sec_enabled_description", <<END
#========================================================================
# sec_enabled
#
# Enables security checking.
#
# If this value is 1, Portal Manager reads information about the 
# authorized hosts and the user name from the client file. Users can
# connect to Portal Manager only if their host and user names are
# specified in this client file.
#========================================================================
END
       ,"sec_enabled", "- infmgr  sec_enabled $INFMGR{'sec_enabled'}" );


%INFMGR_CM_PINCONF_ENTRIES = (
  "infmgr00_conn00", <<END
#************************************************************************
# Configuration Entries for Connecting to Portal Manager 
#
# The entries below enable this CM to connect to the CM on which
# Portal Manager is running.
#************************************************************************
END
  ,"infmgr00_conn01_infmgr_pointer_description",  <<END
#========================================================================
# infmgr_pointer 
# 
# Specifies the host name and port number of the Portal Manager CM 
# to which you want this CM to connect.
#
#    infmgr_name = the host name of the Portal Manager
#    infmgr_port = the port used by the Portal Manager
#========================================================================
END
  ,"infmgr00_conn01_infmgr_pointer", "- cm infmgr_pointer $INFMGR{'hostname'} $INFMGR{'port'}",
  ,"infmgr00_conn02_infmgr_login_type_description",  <<END
#========================================================================
# infmgr_login_type
#
# Specifies whether the login name and password are required for logging
# in to the Portal Manager host.
#
# The value for this entry can be:
#
#    0 = Only a user ID is required.
#    1 = (Default) Both a name and a password are required.
#========================================================================
END
  ,"infmgr00_conn02_infmgr_login_type", "- cm infmgr_login_type 1",
  ,"infmgr00_conn03_infmgr_login_name_description",  <<END
#========================================================================
# infmgr_login_name 
#
# Specifies the login name to use when this CM connects to the Portal
# Manager host.
#
# If login_type is 0, you don't need to specify a login name.
#========================================================================
END
  ,"infmgr00_conn03_infmgr_login_name", "- cm infmgr_login_name root.$DM{'db_num'}",
  ,"infmgr00_conn04_infmgr_login_pw_description",  <<END      
#========================================================================
# infmgr_login_pw
#
# Specifies the password to use when this CM connects to the Portal  
# Manager host.
#
# If login_type is 0, you don't need to specify a password.
#========================================================================
END
  ,"infmgr00_conn04_infmgr_login_pw", "- cm infmgr_login_pw &aes|08|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5D40C305EDF3D77DF111AAB8F781E92122"
 );

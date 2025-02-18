#=======================================================================
#  @(#)%Portal Version: pin_cnf_nmgr.pl:InstallVelocityInt:4:2005-Mar-25 18:12:03 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$NMGR_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Node Manager
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

%NMGR_PINCONF_ENTRIES = (
	"nmgr_port_description", <<END
#========================================================================
# nmgr_port
# 
# Specifies the port number of the computer where Node Manager runs. 
#
# This number should be greater than 1000, unless you start Node Manager 
# as root. The default, 11970, is a commonly specified port for Node
# Manager.
#========================================================================
END
	,"nmgr_port", "- nmgr nmgr_port $NMGR{'port'}"
	,"nmgr_name_description", <<END
#========================================================================
# nmgr_name
# 
# Specifies the name or IP address of the computer where Node Manager runs.
#
# The name can be:
#
#    - (hyphen)                = Portal can use any IP address on the
#                                  computer running Node Manager.
#
#    <host name or IP address> = Portal should use a particular IP
#                                  address on the Node Manager computer.
#
# This entry is optional. If you remove or disable it, Portal
# uses gethostname to find the IP address of the Node Manager computer.
#========================================================================
END
	,"nmgr_name", "- nmgr nmgr_name $NMGR{'hostname'}"
	,"nmgr_logfile_description", <<END
#========================================================================
# nmgr_logfile
#
# Specifies the full path to the log file used by Node Manager.
#
# You can enter any valid path.
#========================================================================
END
	,"nmgr_logfile", "- nmgr nmgr_logfile \$\{PIN_LOG_DIR\}/nmgr/nmgr.pinlog"
	,"logmgr_pointer_description", <<END
#========================================================================
# logmgr_pointer
#
# Specifies a pointer to Portal Manager.
#
# This is where Node Manager sends its log information. To use this entry,
# remove the crosshatch (#) at the start of the line and enter values for:
#
#     <host> = the host name or IP address of the computer running
#                Portal Manager
#     <port> = the port number of the computer running Portal Manager
#========================================================================
#- nmgr logmgr_pointer <host name> <port>
END
	,"logmgr_pointer", "#- nmgr logmgr_pointer $INFMGR{'hostname'} $INFMGR{'port'}"
	,"start_servers_description", <<END
#========================================================================
# start_servers
#
# Starts all Portal processes at startup.
#
# The value for this entry can be:
#
#    0 = You must start the processes manually.
#    1 = Node Manager starts all processes.
#========================================================================
END
	,"start_servers", "- nmgr start_servers $NMGR{'start_servers'}"
	,"sec_enabled_description", <<END
#========================================================================
# sec_enabled
#
# Enables security checking.
#
# The value for this entry can be:
#
#    0 = Node Manager does not check host or user names.
#    1 = Node Manager reads information about the authorized hosts and
#          the user name from the client file. Users can connect to Node
#          Manager only if their host and user names are specified in
#          this client file.
#========================================================================
END
	,"sec_enabled", "- nmgr sec_enabled $NMGR{'sec_enabled'}"
	,"server_info_description",  <<END
#========================================================================
# server_info
#
# Specifies pointers to the Portal processes you want Node Manager to
# monitor, such as the CM and DM.
#
# For each process, use this syntax:
#     - -  server_info  <process_name>  <program_path>  <working_path>
#                       <host_name> <port>
#
# where:
#  -- <process_name>: name of the Infranet process, such as "dm1"
#         CM: name must contain substring "cm" and no substring "dm"
#         DM: name must contain substring "dm" and no substring "cm"
#  -- <program_path>: path to the program executable for the process
#  -- <working_path>: path to the working directory for the process
#  -- <host_name>   : Host name where the server will be running
#  -- <port>        : Port number where the server is listening
#========================================================================
END
	,"server_info", 
"- - server_info $NMGR{'dm_name'} \$\{PIN_HOME\}/bin/dm $DM{'pin_conf_location'} - $DM{'port'}
- - server_info $NMGR{'cm_name'} \$\{PIN_HOME\}/bin/cm $CM{'pin_conf_location'} - $MAIN_CM{'port'}"
	,"server_dep_description", <<END
#========================================================================
# server_dep
#
# Specifies a list of processes on which a process depends.
#
# The list tells Node Manager to start the listed process before it starts
# the dependent process. For example, you must start the DM before you
# start the CM. For each dependent process, use this syntax:
#
#    - - server_dep <dependent_process> <process1> <process2> ..
#
# where:
#
#    <dependent_process> = the name of the Portal process, such as "dm1",
#                            that depends on other processes
#    <processN>          = the name of the process that must be started
#                            before the dependent process
#========================================================================
END
	,"server_dep", "- - server_dep $NMGR{'cm_name'} $NMGR{'dm_name'}"
	,"cell_name_description", <<END
#========================================================================
# cell_name
#
# Lists all processes in one instance (cell) of Portal.
#
# Use this syntax:
#
#    - - cell_name <cell_name> <process_name1> <process_name2> .. 
#
# where:
#
#    <cell_name>     = the name of the Portal cell; this can be any 
#                        name you choose
#    <process_nameN> = the name of a process associated with that cell,
#                        such as "cm1"
#========================================================================
END
	,"cell_name","#- - cell_name <cellName> <serverName1> <serverName2> .. "
	,"cluster_name_description", <<END
#========================================================================
# cluster_name
#
# Lists all processes that are in one cluster.
#
# Use this syntax:
#
#    - - cluster_name <cluster_name> <process_name1> <process_name2> ..
#
# where:
#
#    <cluster_name>  = the name of the Portal cluster; this can be any 
#                        name you choose
#    <process_nameN> = the name of a process associated with that cluster,
#                        such as "cluster1"
#========================================================================
END
	,"cluster_name", "#- - cluster_name <clusterName> <serverName1> <serverName2> .. "
 );

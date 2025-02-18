#=======================================================================
#  @(#)%Portal Version: pin_cnf_cmmp.pl:InstallVelocityInt:4:2005-Mar-25 18:13:11 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$CMMP_PINCONF_HEADER  =  <<END 
#************************************************************************
# Configuration File for Connection Manager Master Process (CMMP)
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

%CMMP_PINCONF_ENTRIES = (
	"cm_name_description", <<END
#========================================================================
# cm_name
#
# Specifies the name of the computer where the CMMP runs.
# 
# The name can be:
#
#    - (hyphen)                = Portal can use any IP address on the
#                                  CMMP computer.
#
#    <host name or IP address> = Portal should use a particular IP
#                                  address on the CMMP computer.
#
# This entry is optional. If you remove or disable it, Portal uses
# gethostname to find the IP address of the CMMP computer.
#========================================================================
END
	,"cm_name", "- cm cm_name $CMMP{'hostname'}"
	,"cm_ports_description", <<END
#========================================================================
# cm_ports
#
# Specifies the port number of the computer where the CMMP runs.
# 
# The default, 11960, is a commonly specified port for the CMMP.
# Make sure the port number does not conflict with another service.
# For example, if you run the CM and CMMP on the same computer, you
# must give one of them a different port number, because the default 
# for each is 11960. This number must be greater than 1000, unless
# you start the process as root.
#
# The parameter following the port number is a required tag, which
# can be any text you choose. The default tag is pin.
#========================================================================
END
	,"cm_ports", "- cm cm_ports $CMMP{'port'} pin"
	,"reserved_entries_description", <<END
#========================================================================
# Reserved Entries
#
# The next three entries, userid, dm_pointer and dm_attributes, are reserved
# for use by Portal. DO NOT change them.
#========================================================================
END
	,"reserved_entries",
"- cm userid $MAIN_DM{'db_num'} /service 1
- cm dm_pointer $MAIN_DM{'db_num'} ip $MAIN_DM{'hostname'} $MAIN_DM{'port'}
- cm dm_attributes $MAIN_DM{'db_num'} scoped,assign_account_obj,searchable"
        ,"cm_login_module_description", <<END
#========================================================================
# cm_login_module
#
# Specifies a pointer to the file that handles login requests for the CMMP.
# 
# This entry must point to the cmmp_v1 file on your system, or the CMMP
# will not work. If necessary, change the file-name extension in this 
# entry to match the extension of the file installed on your system: 
#
#    .so  for Solaris
#    .sl  for HP-UX
#    .dll for Windows NT
#========================================================================
END
	,"cm_login_module", "- cm cm_login_module \$\{PIN_HOME\}/sys/cmmp/cmmp_v1\$\{LIBRARYEXTENSION\}"
	,"redirect_description", <<END
#========================================================================
# redirect
#
# Specifies pointers to each CM on the system.
#
# Each pointer includes the name or IP address and the port number of the
# computer running a CM. The port number must match the number for the
# cm_ports configuration entry of the CM on that computer.
#========================================================================
END
	,"redirect", "- cm redirect - $CM{'hostname'} $CM{'port'}"
	,"cmmp_algorithm_description", <<END
#========================================================================
# cmmp_algorithm
#
# cmmp uses this parameter to distribute load on the CMs in "redirect"
# entries in pin.conf file. If it is set to one, the cmmp follows the
# round_robin technique for load distribution, otherwise it will select
# the random number (randonly selected CM from the "redirect" list).
# cmmp_algorithm        1       #round_robin selection of next cm
# cmmp_algorithm        0       #random selection of next cm
#========================================================================
END
	,"cmmp_algorithm", "- cm cmmp_algorithm	$CMMP{'cmmp_algorithm'}"
	,"keepalive_description", <<END
#========================================================================
# keepalive
#
# (Windows NT only) Specifies whether to monitor the TCP connection.
#
# Note: This entry is not needed for UNIX systems, which generally
#       clean up the TCP socket when a connection is lost.
#
# The value for this entry can be:
#
#    0 = (Default) The TCP connection is not monitored.
#    1 = The CM sets the TCP keepalive flag in its connection to the
#          client, forcing the connection to be monitored actively. You
#          can detect a lost connection quickly and clean up the CM and DM.
#========================================================================
END
	,"keepalive", "- cm keepalive $CM{'keep_alive'}"
	,"cm_log_0cm_logfile_description", <<END
#************************************************************************
# Configuration Entries for CMMP Logging
#
# The entries below specify how the CMMP logs information about its
# activity.
#************************************************************************
#
#========================================================================
# cm_logfile
#
# Specifies the full path to the log file used by the CMMP.
#
# You can enter any valid path.
#========================================================================
END
	,"cm_log_0cm_logfile", "- cm cm_logfile \$\{PIN_LOG_DIR\}/cmmp/cmmp.pinlog"
	,"cm_log_cm_loglevel_description", <<END
#========================================================================
# cm_loglevel
#
# Specifies how much information the CMMP logs.
# 
# The value for this entry can be:
#
#    0 = no logging
#    1 = (Default) log error messages only
#    2 = log error messages and warnings
#    3 = log error, warning, and debugging messages
#========================================================================
END
	,"cm_log_cm_loglevel","- cm cm_loglevel $CM{'log_level'}"
	,"cm_log_cm_logformat_description", <<END
#========================================================================
# cm_logformat
#
# Specifies which PINLOG format should be used.
# 
# The value for this entry can be:
#
#    0 = Use the original format. The date is locale-specific.
#    1 = Format the date as yyyy-mm-dd. The time includes milliseconds
#========================================================================
END
	,"cm_log_cm_logformat","- cm cm_logformat $CM{'log_format'}"
	,"cm_data_file_description", <<END
#************************************************************************
# Configuration Entry for CMMP Cache File
#************************************************************************
#
#========================================================================
# cm_data_file
#
# Specifies the name and location of the shared-memory file that caches
# some global information for the CMMP, to improve performance.
# 
# The CMMP deletes the previous shared-memory file when it stops, and
# creates a new one each time it starts. The file-name extension is the
# process ID of the CMMP.
#
# If you remove the optional %d parameter from the entry, the CMMP leaves
# the shared-memory file on your system. You can use that file for
# debugging,but you must remove it before you can restart the CMMP.
#========================================================================
END
	,"cm_data_file", "- cm cm_data_file \$\{PIN_LOG_DIR\}/cmmp/cm.data.%d" );

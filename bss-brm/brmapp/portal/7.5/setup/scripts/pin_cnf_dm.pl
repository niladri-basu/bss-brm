#=======================================================================
#  @(#)$Portal Version: pin_cnf_dm.pl:InstallVelocityInt:5:2005-Jun-02 05:18:30$ 
# 
# Copyright (c) 2005, 2013, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$DM_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for $CurrentComponent
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

$VIRTCOL_PINCONF_HEADER  =  <<END
################################################################################
#
# Copyright (c) 2012, 2013, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license
#       or sublicense agreement.
#
################################################################################
################################################################################

##
# Beginning of VCOL general processing configuration
#
END
;

%DM_PINCONF_ENTRIES = (
	"dm_0n_fe_description", <<END
#************************************************************************
# Queue Management Information
#
# The entries below specify how this Portal process should manage
# transactions.
#
# For information on tuning the queuing entries to improve performance, 
# see the online document "Portal Configuration and Tuning Guide."
#************************************************************************
#
#========================================================================
# dm_n_fe
# 
# Specifies the number of front ends this DM creates and uses.
#
# The allowable range of values is:
#
#    Minimum = 1
#    Maximum = 16
#========================================================================
END
	,"dm_0n_fe", "- dm dm_n_fe $DM{'front_ends'}"
	,"dm_max_per_fe_description",  <<END
#========================================================================
# dm_max_per_fe
# 
# Specifies the maximum number of connections for each front end.
#
# The allowable range of values is:
#
#    Minimum                 = 8
#    Maximum (in Windows NT) = 63
#    Maximum (in UNIX)       = 512
#========================================================================
END
	,"dm_max_per_fe", "- dm dm_max_per_fe $DM{'max_frontends'}"
	,"dm_n_be_description", <<END 
#========================================================================
# dm_n_be
# 
# Specifies the number of back ends this DM creates and uses.
#
# The allowable range of values is:
#
#    Minimum = 1
#    Maximum = 256
#
# Important: Creating an Portal account requires two connections, one
#    transaction connection and one regular connection. You must have at
#    least two back ends for each account you are creating at one time.
#    See the online document "Portal Configuration and Tuning Guide."
#========================================================================
END
	,"dm_n_be", "- dm dm_n_be $DM{'back_ends'}"
	,"dm_trans_be_max_description", <<END
#========================================================================
# dm_trans_be_max
# 
# Specifies the maximum number of back ends that can be used for
# processing transactions.
#
# By default, as many as half of the back ends can process transactions. 
# To increase the number of back ends for processing transactions, remove
# the crosshatch (#) from the beginning of the line for this entry and
# enter the number you want. The number must be no greater than the total
# number of back ends (dm_n_be).
#========================================================================
END
	,"dm_trans_be_max", "- dm dm_trans_be_max $DM{'max_back_ends'}"
	,"dm_shmsize_description",  <<END
#========================================================================
# dm_shmsize
#
# (UNIX only) Specifies the size of shared memory segment, in bytes, that
# is shared between the front ends and back ends for this DM.
#
# The allowable range of values is:
#
#    Minimum = 2097152 bytes (2 MB)
#    Maximum = 274877905920 bytes  (Approx. 256 GB)
#
# Solaris: You must edit the /etc/system file because the system default
#          for the maximum allowable shared-memory segment is too low.
#          See "Problems with memory management" in the online
#          documentation.
#========================================================================
END
	,"dm_shmsize", "- dm dm_shmsize $DM{'shmsize'}"
	,"dm_bigsize_description", <<END
#========================================================================
# dm_bigsize
#
# (UNIX only) Specifies the size of shared memory for "big" shared memory structures,
# such as those used for large searches (those with more than 128 results)
# or for PIN_FLDT_BUF fields larger than 4 KB.
#
# The allowable range of values is:
#
#    Minimum = 262144 bytes (256 KB)
#    Maximum = 206158429184 bytes (Approx. 192 GB)
#
# This value cannot be more than the value specified in qm_shmsize, in the
# qm configuration file.
#
# If you get memory errors, increase the value.
#========================================================================
END
	,"dm_bigsize", "- dm dm_bigsize $DM{'bigsize'}"
	,"dm_port_description", <<END
#========================================================================
# dm_port
#
# Specifies the port number for this DM.
#
# This number was assigned to the DM when you installed Portal. If you
# change the port, make sure the port number does not conflict with
# another service. This number must be greater than 1000, unless you start
# the process as root. 
#
# The CM configuration file must have a corresponding dm_pointer entry
# with the same port number.
#========================================================================
END
	,"dm_port", "- dm dm_port $DM{'port'}"
	,"dm_name_description", <<END
#========================================================================
# dm_name
#
# Specifies the name of the computer where this DM runs.
# 
# The name can be:
#
#    - (hyphen)                = Portal can use any IP address on the
#                                  DM computer.
#
#    <host name or IP address> = Portal should use a particular IP
#                                  address on the DM computer.
#
# This entry is optional. If you remove or disable it, Portal uses
# gethostname to find the IP address of the DM computer.
#========================================================================
END
	,"dm_name", "- dm dm_name $DM{'hostname'}"
	,"dm_db_no_description", <<END
#========================================================================
# dm_db_no
#
# Specifies the database number for this DM.
#
# The format is 0.0.0.n  / 0, where n is your database number.
# The default database number for the Portal Data Manager (Oracle or
# SQL Server) is 1. Other default database numbers are:
#
#    0.0.0.2   Clear Commerce
#    0.0.0.2   Paymentech
#    0.0.0.3   Email Data Manager
#    0.0.0.4   Taxware DM
#    0.0.4.1   Activity Log Data Manager
#    0.0.5.x   LDAP Data Manager
#========================================================================
END
	,"dm_db_no", "- dm dm_db_no $DM{'db_num'} / 0"
	,"dm_logfile_description", <<END
#========================================================================
# dm_logfile
#
# Specifies the full path to the log file used by this DM.
#
# You can enter any valid path.
#========================================================================
END
	,"dm_logfile", "- dm dm_logfile \$\{PIN_LOG_DIR\}/$CurrentComponent/$CurrentComponent.pinlog"
	,"dm_restart_children_description", <<END
#========================================================================
# dm_restart_children
#
# Specifies whether to replace child processes.
#
# The value for this entry can be:
#
#    0 = Do not replace child processes.
#    1 = (Default) The DM master process replaces any child DM processes
#          that fail. 
#========================================================================
END
	,"dm_restart_children", "- dm dm_restart_children $DM{'restart_children'}"
        ,"dm_restart_delay_description", <<END
#=======================================================================
# dm_restart_delay
#
# Specify interval delay when spawning and respawning dm back ends.
# If not specified, the default value "0" will be used. That is,
# there is no delay between spawning and respawning dm back ends.
# This is required when you want to control the dm spawning or
# connection bahavior.
#
# For NT system, this value is based on milliseconds.
# For Unix system, this value is based on microseconds.
#========================================================================
END
        ,"dm_restart_delay", "#- dm dm_restart_delay 0"
	,"dm_sm_obj_description", <<END
#========================================================================
# dm_sm_obj
#
# Specifies a pointer to the Storage Manager shared library that contains
# the code that the Data Manager uses to interact with the database.
#
# Portal was set up with the correct file during installation.
# DO NOT change this configuration entry.
#========================================================================
END
	,"dm_sm_obj", "- dm dm_sm_obj $DM{'library'}"
	,"dm_trans_timeout_description", <<END
#========================================================================
# dm_trans_timeout
#
# Specifies the timeout value, in minutes, to be used by dm back-end 
# processes in receiving the next opcode of a transaction.
#
# The value for this entry can be:
#
#    0 or less      = (Default) A DM back-end process waits forever
#                       for the next opcode request.
#    greater than 0 = A DM back-end process waits until the specified
#                       number of minutes have gone by and then, if no
#                       opcode request has arrived, aborts the transaction.
#
# This parameter takes effect if and only if a DM back-end process is 
# processing a transaction.
#========================================================================
END
	,"dm_trans_timeout", "- dm dm_trans_timeout $DM{'trans_timeout'}"
	,"extra_search_description", <<END
#========================================================================
# extra_search
#
# Specifies if we want to do extra search count(*) on sub tables
# so we can allocate memory optimally
#
# The value for this entry can be:
#
#    0 			= (Default) not do the extra search 
#    1 			= do the extra search and allocate memory optimally.
##========================================================================
END
	,"extra_search", "- dm extra_search 0"
	,"sm_svcname_description", <<END
#========================================================================
# sm_svcname
#
# Database service name.
#
# This is the service_name you used to define SQL*NET alias (sm_database)
# in the tnsnames.ora file when you set up the Oracle database.
# By default, this entry was not configured when you install Infranet.
# You should only enable this when you need 10g RAC HA support.
#========================================================================
END
	,"sm_svcname", "#- dm sm_svcname <service_name>"	
 );

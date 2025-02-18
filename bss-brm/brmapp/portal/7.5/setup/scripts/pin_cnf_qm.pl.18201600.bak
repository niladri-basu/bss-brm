#=======================================================================
#  @(#)%Portal Version: pin_cnf_qm.pl:InstallVelocityInt:4:2005-Mar-25 18:14:24 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$QM_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Queue Management
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
#
# The entries below specify how this Portal process should manage
# transactions.
#
# For information on tuning the queuing entries to improve performance,
# see the online document "Portal Configuration and Tuning Guide."
#************************************************************************
END
;

%QM_PINCONF_ENTRIES = (
	"qm_0n_fe_description", <<END
#========================================================================
# qm_n_fe
# 
# Specifies the number of front ends the program creates and uses.
#
# The allowable range of values is:
#
#    Minimum = 1
#    Maximum = 16
#
# Note: For a credit-card processing data manager, set this value to 1.
#========================================================================
END
	,"qm_0n_fe", "- $CurrentComponent qm_n_fe $QM{'front_ends'}"
	,"qm_max_per_fe_description", <<END
#========================================================================
# qm_max_per_fe
# 
# Specifies the maximum number of connections for each front end.
#
# The allowable range of values is:
#
#    Minimum = 8
#    Maximum = 128
#========================================================================
END
	,"qm_max_per_fe", "- $CurrentComponent qm_max_per_fe $QM{'max_frontends'}"
	,"qm_n_be_description",	 <<END
#========================================================================
# qm_n_be
# 
# Specifies the number of back ends the program creates and uses.
#
# The allowable range of values is:
#
#    Minimum = 1
#    Maximum = 256
#
# Note: For dm_fusa, if you use fusamux, set this value between 4 and 8. 
#       If you don’t use fusamux, set this value to 2 (one for a single
#       batch and one for online processing).
#========================================================================
END
	,"qm_n_be", "- $CurrentComponent qm_n_be $QM{'back_ends'}"
	,"qm_shmsize_description", <<END
#========================================================================
# qm_shmsize
#
# (UNIX only) Specifies the size of the shared-memory segment that is
# shared between the front ends and back ends for this Portal process.
#
# Note: On Windows NT systems, Portal ignores this entry.
#
# Use the suffix "K" to express the memory in kilobytes (units of 1024
# bytes) or the suffix "M" to express the memory in megabytes (units of
# 1024 kilobytes). For example, the entry "6M" means 6291456 bytes.
#
# The allowable range of values is:
#
#    Minimum = 1M
#    Maximum = 512M
#
# Solaris: You must edit the /etc/system file, because the system default
#     for the maximum allowable shared-memory segment is too low. 
#     See "Problems with memory management" in the online documentation.
#========================================================================
END
	,"qm_shmsize", "- $CurrentComponent qm_shmsize $QM{'shmsize'}"
	,"qm_bigsize_description", <<END
#========================================================================
# qm_bigsize
#
# (UNIX only) Specifies the size of shared memory for "big" shared-memory
# structures, such as those used for searches.
#
# Note: On Windows NT systems, Portal ignores this entry.
# 
# The allowable range of values is:
#
#    Minimum = 256K
#    Maximum = 512M
#
# This value cannot be more than the value specified in qm_shmsize.
#
# If you get memory errors, increase the value.
#========================================================================
END
	,"qm_bigsize", "- $CurrentComponent qm_bigsize $QM{'bigsize'}"
	,"qm_port_description", <<END 
#========================================================================
# qm_port
#
# Specifies the port number for this Portal process.
#
# This number was assigned to this process when you installed Portal. If
# you change the port, make sure the port number does not conflict with
# another service. This number must be greater than 1000, unless you start
# the process as root. 
#
# The CM configuration file must have a corresponding dm_pointer entry
# with the same port number.
#========================================================================
END
	,"qm_port", "- $CurrentComponent qm_port $QM{'port'}"
	,"qm_logfile_description", <<END
#========================================================================
# qm_logfile
#
# Specifies the full path to the log file used by this Portal process.
#
# You can enter any valid path.
#========================================================================
END
	,"qm_logfile", "- $CurrentComponent qm_logfile \$\{PIN_LOG_DIR\}/$CurrentComponent/$CurrentComponent.pinlog"
	,"qm_restart_children_description", <<END
#========================================================================
# qm_restart_children
#
# Specifies whether to replace child processes.
#
# The value for this entry can be:
#
#    0 = The DM doesn't replace child processes.
#    1 = (Default) The DM master process replaces any child DM processes
#          that fail.
#
# You might set this value to 0 for testing, but it should be 1 for
# production use.
#========================================================================
END
	,"qm_restart_children", "- $CurrentComponent qm_restart_children $QM{'restart_children'}"
	,"qm_debug_description", <<END
#========================================================================
# Queue Management Debugging
#
# The entries below specify which debugging information is printed to the
# program's log file.
#
# qm_debug       = print debugging information for all daemons that use
#                    queue management
# qm_debug_front = print debugging information for the front ends of
#                    this daemon only
# qm_debug_back  = print debugging information for the back ends of
#                    this daemon only
#
# To use one or more of these entries, remove the crosshatch (#) from the
# start of the line and enter a valid value or combination of values in
# hexadecimal format.
#
# For the main debugging entry:
#
#    1 = Print detailed error information.
#    2 = Print main loop tracing.
#    4 = Print transaction tracing.
#
# For the front-end and back-end debugging entries:
#
#    1 = Print information on new connections.
#    2 = Print input information.
#    4 = Print operation done information.
#    8 = Print output information.
#========================================================================
END
	,"qm_debug",
"#- $CurrentComponent qm_debug		0x07	# example: print all debug info
#- $CurrentComponent qm_debug_front	0x0F	# example: print all debug info, front end
#- $CurrentComponent qm_debug_back		0x0F	# example: print all debug info, back end"
 );

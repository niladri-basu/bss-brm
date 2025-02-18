#=======================================================================
#  @(#)%Portal Version: pin_cnf_mta.pl:PortalBase7.3.1PatchInt:1:2008-Feb-24 23:52:17 %
# 
# Copyright (c) 2005, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$MTA_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Multithreading Application (MTA) Framework
#
# This configuration file controls how MTA (MultiThreraded Application)
# programs run. Several MTA applications, such as pin_inv_accts and
# pin_inv_export, can use this file. Some parameter names and values are
# generic; each of the generic entries begins with "- pin_mta", as in
# this example:
#
#   - pin_mta        fetch_size  30000
#
# Every other parameter name and value is specific to one application
# and begins with that application's name, as in this example:
#
#   - pin_inv_accts  fetch_size  40000
#
# Application-specific values always override generic values.
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

%MTA_PINCONF_ENTRIES = (
	"mta_logfile_description", <<END
#========================================================================
# mta_logfile
#
# Specifies the full path to the log file used by this MTA application.
#
# You can enter any valid path.
#========================================================================
END
	,"mta_logfile", "- pin_mta logfile \$\{PIN_LOG_DIR\}/$CurrentComponent/$CurrentComponent.pinlog"
	,"mta_loglevel_description", <<END
#========================================================================
# loglevel
#
# Specifies how much information the applications log.
#
# The value for this entry can be:
#
#    0 = no logging
#    1 = (Default) log error messages only
#    2 = log error messages and warnings
#    3 = log error, warning, and debugging messages
#========================================================================
END
        ,"mta_loglevel", "- pin_mta loglevel 1"
	,"mta_performance_description", <<END
#========================================================================
# mta_performance
#
# Performance Parameters
# 
# The entries below govern how the MTA applications pull data from the
# database and tranfer the data to the application space. They also
# define how many threads (children) are used to process the data in
# the application.
#
#    children   = number of threads used to process the accounts in the
#                 application
#    per_batch  = number of accounts processed by each child
#    per_step   = number of accounts returned in each database search
#    fetch_size = number of accounts cached in application memory
#                 before processing starts
#
# Some applications do not use all of these performance parameters. For
# example, pin_inv_accts does not use per_batch.
#
# You can edit these entries to improve performance of MTA applications.
# Different MTA applications process accounts differently, so you
# usually need to configure these entries differently for each
# application. To specify an entry for a single MTA application, replace 
# the generic name "pin_mta" with the name of the specific application.
# For example, you might have these entries:
#
#    - pin_mta          fetch_size  30000
#    - pin_inv_accts    fetch_size  50000
#
# For a complete explanation of setting these variables for best
# performance, see the online document "Portal Configuration and
# Tuning Guide."
#========================================================================
END
	,"mta_performance",
"- pin_mta       children        $MTA{'mta_children'}
- pin_mta       per_batch       $MTA{'mta_per_batch'}
- pin_mta       per_step        $MTA{'mta_per_step'}
- pin_mta       fetch_size      $MTA{'mta_fetch_size'}"
	,"mta_respawn_threads_description",	 <<END
#========================================================================
# respawn_threads
# 
# Respawns worker threads if they exit due to an error. Threads are
# respawned if necessary after every search cycle.
# Valid options are :-
# 0 - No respawning , 1 - respawn threads
# The default is 0 for no respawning.
#========================================================================
END
	,"mta_respawn_threads", "- pin_mta respawn_threads 0"
	,"mta_max_errs_description",	 <<END
#========================================================================
# max_errs
# 
# Specifies the maximum number of errors that the application can ignore.
#
# This entry is optional. By default, max_errs = fetch_size.
#========================================================================
END
	,"mta_max_errs", "- pin_mta max_errs $MTA{'mta_max_errs'}"
	,"mta_multi_db_description", <<END
#========================================================================
# multi_db
#
# Enables or disables the multidatabase capability of MTA.
#
# If you enable multi_db, MTA uses global searching instead of the
# normal searching. The value for this entry can be:
#
#    0 = (Default) Disable global searching
#    1 = Enable global searching
#========================================================================
END
	,"mta_multi_db", "- pin_mta multi_db $MTA{'mta_multi_db'}"
	,"mta_hotlist_description", <<END
#========================================================================
# hotlist
#
# Specifies the location (path and file name) of the hot-list file.
#
# A hot list is a file containing an array of POIDs that need to be
# handled by the MTA application's working threads first. This priority
# lets some threads begin working on some known large or complex accounts
# and bills as early as possible. The array of POIDs might be hard-coded
# in the file that lists hosts, or the file could be generated by some
# other application.
#
# The array of POIDs must be in flist format. Refer to the example
# files in the distribution for more information about the hot-list file.
#========================================================================
END
	,"mta_hotlist", "- pin_mta hotlist $MTA{'mta_hotlist'}"
	,"mta_monitor_description", <<END
#========================================================================
# monitor
#
# Specifies the location of shared memory (the memory-map file).
#
# Use this entry to set the path and name of a shared memory-map file.
# This binary file stores information about the running MTA application.
# With help from another application such as pin_mta_monitor, you can
# view and adjust the number of threads that are running in the MTA
# application without interrupting it.
#========================================================================
END
	,"mta_monitor", "- pin_mta monitor $MTA{'mta_monitor'}" 
);

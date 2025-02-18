# @(#)%Portal Version: pin_cnf_pin_billd.pl:InstallVelocityInt:4:2005-Mar-25 18:12:18 %
#=======================================================================
#  @(#)%Portal Version: pin_cnf_pin_billd.pl:InstallVelocityInt:4:2005-Mar-25 18:12:18 %
# 
# Copyright (c) 2004, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$PIN_BILLD_PINCONF_HEADER =  <<END
#************************************************************************
# Configuration Entries for Logging Problems with the Billing Programs
#
#
# Use these entries to specify how the billing applications log
# information about their activity.
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


%PIN_BILLD_PINCONF_ENTRIES = (
	"pin_billd_0logfile_description", <<END
#========================================================================
# logfile
#
# Specifies the full path to the log file for the billing application.
#
# You can enter any valid path.
#========================================================================
END
	,"pin_billd_0logfile", "- pin_billd logfile \$\{PIN_LOG_DIR\}/pin_billd/pin_billd.pinlog"
	,"pin_billd_loglevel_description", <<END
#========================================================================
# loglevel
#
# Specifies how much information the billing application logs.
# 
# The value for this entry can be:
#
#    0 = no logging
#    1 = (Default) log error messages only
#    2 = log error messages and warnings
#    3 = log error, warning, and debugging messages
#========================================================================
END
	,"pin_billd_loglevel", "- pin_billd loglevel 2"
	,"pin_billd_performance_description", <<END
#========================================================================
# Performance Entries
#
# Specify how the billing application processes accounts.
#
#     children   = the number of threads used to process the accounts
#     per_batch  = the number of accounts processed by each child
#     fetch_size = the number of accounts cached in system memory
#                    before processing
#
# You can edit these entries to improve performance of billing
# applications. Different billing applications process accounts
# differently, so you usually need to configure these entries differently
# for each application. To specify an entry for a single billing
# application, replace the generic name "pin_billd" with the specific 
# name of the application. For example, you might have these entries:
#
#    - pin_collect      per_batch    240
#    - pin_bill_accts   per_batch   3000
#
# For a complete explanation of setting these variables for best
# performance, see the online document "Portal Configuration
# and Tuning Guide."
#
# Note: The invoice-generation application doesn't use the pin_billd
#       default values. You must set the values for that application
#       independently. See the guidelines for those entries elsewhere
#       in this configuration file.
#========================================================================
END
	,"pin_billd_performance",
"- pin_billd	children	$BILLING{'billing_children'}
- pin_billd	per_batch	$BILLING{'billing_per_batch'}
- pin_billd	fetch_size	$BILLING{'billing_fetch_size'}"
	,"pin_billd_merchant_description", <<END
#========================================================================
# merchant
#
# The merchant entry is not supported in this release. DO NOT change 
# this entry.
#========================================================================
END
	,"pin_billd_merchant", "- pin_billd merchant XXX"
	,"pin_billd_cb_delay_description", <<END
#========================================================================
# config_billing_delay
#
# Specifies a delay for disabling the automatic triggering of billing
#
# If the system is configured to record delayed batch usage events in
# Portal, this entry lets you specify the delay, in days, before the
# billing is run. The value cannot be more days than one accounting cycle.
#
# When the pin_bill_accts application runs as part of the
# daily program pin_bill_day, it waits through the specified  delay to
# pick up accounts for billing. However, if a real-time or batch event
# triggers billing during this delay, cycle fees are charged as if there
# were no delay (without running the complete billing).
#
# By default, this configuration parameter is disabled, so the autobilling
# trigger is enabled. This is a system-wide parameter only.
#
# This entry is the same as one in the CM configuration file
#
# In the enabled entry below, the billing run is not delayed but avoids auto
# triggering of billing
#========================================================================
END
	,"pin_billd_cb_delay", "#- pin_bill_accts     config_billing_delay 10"
	,"deadlock_retry_count_description", <<END
#========================================================================
# Deadlock Retry Count
#
# Specified the number of attempts to bill an account again in 
# case of a deadlock error.
#
# This entry is required for SQL Server databases.  For other databases,
# this is an optional parameter.  For better performance this count 
# should be set depending on the volumes of the accounts to be billed.
#
#========================================================================
END
	,"deadlock_retry_count", "- pin_bill_accts  deadlock_retry_count  20"	
	,"pin_billd_set_error_status_description", <<END
#========================================================================
# set_error_status
#
# This entry is used to set the PIN_BILL_ERROR(4) value to billing status 
# field of billinfo object for the subordordinate accounts and parent accounts 
# if the billing failed for subordinate accounts due to some reason.
# 
# By default, this configuration parameter is disabled, and the billing_status 
# is not updated by pin_bill_accts.
#
# If the value of the entry is 1 , the billing status is updated with 
# PIN_BILL_ERROR value for both both subordinate and parent billinfo objects
#
# If the value is 0 (zero) the billing_status is not updated with the 
# PIN_BILL_ERROR value.
#
#========================================================================
END
	,"pin_billd_set_error_status", "#- pin_bill_accts set_error_status 1"
	,"pin_billd_minimum_description", <<END
#========================================================================
# minimum
#
# Specifies the minimum balance for retrieving accounts during
# credit-card collection (pin_collect).
#
# Use this entry to set a minimum threshold for the amount due on an
# account when searching for accounts for collection. The pin_collect
# billing application retrieves only those accounts with pending
# receivables greater than the minimum you specify. This improves
# collection performance by filtering out accounts that have either no
# balance due or a very small balance due.
#
# The minimum value is expressed in the account currency. If you do
# business in more than one currency, set the minimum low enough to
# retrieve accounts in any of the currencies. For example, if you have
# accounts in both dollars and yen, setting the minimum at "1.00" flags
# an account with a minimum pending receivable of either one dollar or
# one yen.
#
# This entry does not specify the amount below which you won't charge a
# customer's credit card. You set that amount in a billing policy,
# PCM_OP_BILL_POL_PRE_COLLECT, which lets you specify minimum values for
# each account currency. 
#========================================================================
END
	,"pin_billd_minimum", "- pin_billd minimum $BILLING{'minimum'}"
	,"pin_mta_hotlist_description", <<END
#=====================================================================
# hotlist 
# 
# Use this entry to set the location (path and filename) of the hot 
# list file. 
# 
# A hot list is a file containing an array of poids, which need to be 
# handled by the mta application's working threads first. This 
# allows some threads to begin working on some known large or complex 
# accounts/bills as early as possible. The array of poids might be 
# hard-coded in the host list file, or possibly the file could be 
# generated by some other application. 
# 
# The array of poids must be in flist format. Refer to the example 
# files in the distribution for more information about this file. 
#======================================================================
END
	,"pin_mta_hotlist", "- pin_mta hotlist hotlist"
	,"pin_mta_loglevel_description", <<END
#======================================================================
# loglevel 
# 
# How much information the applications should log. 
# 
# The value for this entry can be: 
#  -- 0: no logging 
#  -- 1: log error messages only 
#  -- 2: log error messages and warnings 
#  -- 3: log error messages, warnings, and debugging messages 
#======================================================================
END
	,"pin_mta_loglevel", "- pin_mta loglevel 2"
        ,"unset_error_status_description", <<END
#======================================================================
#unset_error_status
# 
# Specifies whether the billing status of the billinfo object is to be 
# set to PIN_BILL_ERROR in case of billing error. 
# 
# The value for this entry can be: 
# 
#    0 = (Default) Sets the billing status in the billinfo object. 
#    1 = Does not set the billing status in the billinfo object. 
# 
# By default when an error is encountered while billing, the status of 
# billinfo object is set to PIN_BILL_ERROR. 
#======================================================================
END
        ,"unset_error_status", "- pin_bill_accts unset_error_status 0"
	,"pin_mta_max_errs_description", <<END
#======================================================================
# max_errs 
# 
# Use this entry to set the max errors that can be ignored in the app. 
# This parameter is optional. If left unspecified, max_errs = fetch_size 
#======================================================================
END
	,"pin_mta_max_errs", "- pin_mta max_errs 5000"
	,"pin_mta_multi_db_description", <<END
#====================================================================== 
# multi_db 
# 
# Enables or disables the multidatabase capability of MTA. 
# 
# If you enable multi_db, MTA uses global searching instead of the 
# normal searching. The value for this entry can be: 
# 
#    0 = (Default) Disable global searching 
#    1 = Enable global searching 
#====================================================================== 
END
	,"pin_mta_multi_db", "- pin_mta multi_db 0"
	,"pin_mta_monitor_description", <<END
#====================================================================== 
# monitor 
# 
# Use this entry to set the path and name of shared memory map file. 
# This binary file stores information about the running mta application. 
# With the help of another application (like pin_mta_monitor), you can 
# view and modify the number of threads that are running in the MTA 
# application without interrupting the application. 
# 
#======================================================================
END
	,"pin_mta_monitor", "- pin_mta monitor monitor"
	,"pin_mta_performance_description", <<END
#======================================================================
# Performance Parameters 
# 
# These parameters govern how the MTA applications pulls data from the 
# database and tranfers it to the application space. They also 
# define how many threads (children) are used to process the data in 
# the application. 
# 
#  -- children:   number of threads used to process the accounts in the 
#                 application 
#  -- per_batch:  number of accounts processed by each child 
#  -- per_step:   number of accounts returned in each database search 
#  -- fetch_size: number of accounts cached in application memory 
#                 before processing starts 
# 
# Not all application use all these performance parameters. For example, 
# pin_inv_accts does not use per_batch. 
# 
# You can edit these entries to improve the performance of MTA 
# applications. You typically need to configure these parameters 
# differently for each application. To specify an entry for 
# a specific MTA application, replace the generic "pin_mta" 
# name with the specific name of the application. In the following 
# example pin_inv_accts will use 50000 for the fetch size whereas other 
# applications using this configuration file will use 30000 for the 
# fetch_size : 
#   - pin_mta          fetch_size  30000 
#   - pin_inv_accts    fetch_size  50000 
# 
# For a complete explanation of setting these variables 
# for best performance, see "Improving System Performance" in 
# the online documentation. 
# 
#======================================================================
END
	,"pin_mta_performance"
	,"- pin_mta       children        5 
- pin_mta       per_batch       500 
- pin_mta       per_step        1000 
- pin_mta       fetch_size      5000"
	
	,"pin_mta_logfile_description", <<END
#========================================================================
# mta_logfile 
# 
# Specifies the full path to the log file used by this MTA application. 
# 
# You can enter any valid path. 
#======================================================================== 
END
	,"pin_mta_logfile", "- pin_mta logfile \$\{PIN_LOG_DIR\}/pin_billd/pin_mta.pinlog"     
        ,"pin_billd_enforce_billing_description", <<END

#======================================================================
#  Enforce billing.
#
#  To record the billing state correctly if billing delay feature is on.
#======================================================================
END
        ,"pin_billd_enforce_billing", "- pin_bill_accts enforce_billing  $BILLING{'enforce_billing'}"
);

%PIN_TB_PINCONF_ENTRIES = (
	"pin_trial_bill_accts_db_description", <<END
#************************************************************************
# Configuration File for Portal Trial Billing Applications
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
#
#========================================================================
# Entries for pin_trial_bill_accts
#
# These entries are used for pin_trial_bill_accts configuration only.
#
# Note: Enable these entries only if you want different applications
#       configured differently.
#========================================================================
#
#- pin_trial_bill_accts        children        5
#- pin_trial_bill_accts        per_batch       500
#- pin_trial_bill_accts        per_step        1000
#- pin_trial_bill_accts        fetch_size      5000
#- pin_trial_bill_accts        hotlist         hot_list
#- pin_trial_bill_accts        monitor         monitor
#- pin_trial_bill_accts        max_errs        1
#- pin_trial_bill_accts        multi_db        0
#
#========================================================================
# Default database number
#
# Specifies the default database number for searching.
#========================================================================
END
	,"pin_trial_bill_accts_db", "- pin_trial_bill_accts database $DM{'db_num'} /search 0"
	,"pin_trial_bill_purge_db_description", <<END
#======================================================================
#  The trial billing threshold
#
#  Specifies the maximum number of accounts pin_trial_bill_accts can
#  retrieve from the search and trial-bill.
#  No threshold is used by default in the search.
#======================================================================
#- pin_trial_bill_accts threshold 1000

#======================================================================
# Entries for pin_trial_bill_purge
#
# These entries are used in the pin_trial_bill_purge configuration only.
#
#======================================================================

#- pin_trial_bill_purge        children        5
#- pin_trial_bill_purge        per_batch       500
#- pin_trial_bill_purge        per_step        1000
#- pin_trial_bill_purge        fetch_size      5000
#- pin_trial_bill_purge        hotlist         hot_list
#- pin_trial_bill_purge        monitor         monitor
#- pin_trial_bill_purge        max_errs        1

#======================================================================
# Default DB number for the search.
#
# Specifies the default database number for searching.
#========================================================================
END
	,"pin_trial_bill_purge_db", "- pin_trial_bill_purge database $DM{'db_num'} /search 0"
);

%PIN_BILL_CYCLE_ENTRIES = (
	"billing_segment_config_refresh_delay_description", <<END
#========================================================================
# billing segment config refresh delay
#
# Specifies how often the data in the cached /config/billing_segment
# object is automatically refreshed with data from the database.
#
# IMPORTANT  To refresh this data periodically without restarting the CM,
# you must uncomment this entry.
#
# To prevent this data from being automatically refreshed, comment out
# this entry.
#
# The value for this entry is in seconds.
#
# For example, to refresh the data every 24 hours, set this entry to
# 84600 (60 seconds x 60 minutes x 24 hours).
# 
#========================================================================
END
	,"billing_segment_config_refresh_delay", "#- fm_cust billing_segment_config_refresh_delay 86400"
	,"fm_cust_billing_segment_description", <<END
#========================================================================
# cust billing segment
#
# Allocates size attributes of the CM cache to the 
# PIN_FLD_BILLING_SEGMENTS array in the /config/billing_segment object.
# This array stores the IDs and descriptions of all the billing segments
# in your system.
#
# This entry is required to add this data to the cache when the CM
# starts.
#
# The default settings are usually adequate, but if necessary, you can
# increase the allocated cache space by editing the [cache size] value
# below. For changes to take effect, the CM must be restarted.
#
# Syntax
#
#   - cm_cache fm_cust_billing_segment [number of entries], 
#                         [cache size], [hash size]
#
# Parameters
#
#   [number of entries]   The number of entries in the cache
#                         allocated to this data. The default is 1.
#
#   [cache size]          The memory in bytes of the cache
#                         allocated to this data. The default is 51200.
#
#   [hash size]           The number of buckets allocated to this data.
#                         The default is 1.
#
#========================================================================
END
	,"fm_cust_billing_segment", "- cm_cache fm_cust_billing_segment 1, 51200, 1"
	,"fm_cust_login_exclusion_description", <<END
#========================================================================
# cust login exclusion
#
# Allocates size attributes of the CM cache to the 
# PIN_FLD_LOGIN_EXCLUSION array in the /config/login_exclusion object.
# This array stores the IDs and descriptions of all the login exclusions
# in your system.
#
# This entry is required to add this data to the cache when the CM
# starts.
#
# The default settings are usually adequate, but if necessary, you can
# increase the allocated cache space by editing the [cache size] value
# below. For changes to take effect, the CM must be restarted.
#
# Syntax
#
#   - cm_cache fm_cust_login_exclusion [number of entries], 
#                         [cache size], [hash size]
#
# Parameters
#
#   [number of entries]   The number of entries in the cache
#                         allocated to this data. The default is 1.
#
#   [cache size]          The memory in bytes of the cache
#                         allocated to this data. The default is 51200.
#
#   [hash size]           The number of buckets allocated to this data.
#                         The default is 1.
#
#========================================================================
END
	,"fm_cust_login_exclusion", "- cm_cache fm_cust_login_exclusion 1, 51200, 1"
	,"fm_cust_dom_map_description", <<END
#========================================================================
# fm cust dom map
#
# Allocates size attributes of the CM cache to the PIN_FLD_MAP array in
# the /config/billing_segment object. This array stores all the billing
# segment and accounting day of month (DOM) associations in your system.
#
# This entry is required to add this data to the cache when the CM
# starts.
#
# The default settings are usually adequate, but if necessary, you can
# increase the allocated cache space by editing the [cache size] value
# below. For changes to take effect, the CM must be restarted.
#
# Syntax
#
#   - cm_cache fm_cust_dom_map [number of entries], [cache size],
#                         [hash size]
#
# Parameters
#
#   [number of entries]   The number of entries in the cache allocated
#                         to this data. The default is 1.
#
#   [cache size]          The memory in bytes of the cache allocated to
#                         this data. The default is 102400.
#
#   [hash size]           The number of buckets allocated to this data.
#                         The default is 1.
#
#========================================================================
END
	,"fm_cust_dom_map","- cm_cache fm_cust_dom_map 1, 102400, 1"	
);

#=======================================================================
#  @(#)%Portal Version: pin_cnf_monitor_balance.pl:InstallVelocityInt:2:2005-Jun-03 11:58:03 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$PIN_MONITOR_BALANCE_PINCONF_HEADER  =  <<END
#======================================================================
# Configuration File for the Monitor Balance Utility
#======================================================================
#
#======================================================================
# Use this file to specify how the Monitor Balance utility
# connects with Portal.
#
# A copy of this configuration file is automatically installed and 
# configured with default values when you install Portal. However,
# you can edit this file to suit your specific configuration:
#  -- You can change the default value of an entry.
#  -- You can exclude an optional entry by adding the # symbol
#     at the beginning of the line.
#  -- You can include a commented entry by removing the # symbol.
#
# Before you make any changes to this file, save a backup copy.
#
# To edit this file, follow the instructions in the commented sections.
# For more information on the general syntax of configuration entries,
# see "Reference Guide to Portal Configuration Files" in the Portal
# online documentation.
#======================================================================
END
;

%PIN_MONITOR_BALANCE_PINCONF_ENTRIES = (
	"pin_monitor_balance_logfile_description", <<END
#======================================================================
# pin_monitor_balance_logfile
#
# Name and location of the log file used by this Portal process.
#
#======================================================================
END
	,"pin_monitor_balance_logfile"
	,"- pin_monitor_balance logfile \$\{PIN_LOG_DIR\}/pin_monitor/pin_monitor.pinlog"

	,"pin_monitor_balance_loglevel_description", <<END
#======================================================================
# pin_monitor_balance_loglevel
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
	,"pin_monitor_balance_loglevel"
	, "- pin_monitor_balance loglevel 2"

 );

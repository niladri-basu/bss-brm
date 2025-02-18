#=======================================================================
#  @(#)%Portal Version: pin_cnf_pin_rerate.pl:InstallVelocityInt:8:2005-Jun-27 19:11:14 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$PIN_RERATE_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Rerating and Rebilling
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

%PIN_RERATE_PINCONF_ENTRIES = (

	"pin_rerate_logfile_description", <<END
#======================================================================
# pin_rerate_logfile
#
# Name and location of the log file used by this Portal process.
#
#======================================================================
END
	,"pin_rerate_logfile"
	,"- pin_rerate logfile \$\{PIN_LOG_DIR\}/pin_rerate/pin_rerate.pinlog"

	,"pin_rerate_loglevel_description", <<END
#======================================================================
# pin_rerate_loglevel
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
	,"pin_rerate_loglevel"
	, "- pin_rerate loglevel 2"

	,"pin_rerate_performance_description", <<END
#======================================================================
# Entries for pin_rerate
#
# These entries are used in the pin_rerate configuration only.
#
#======================================================================
END
	,"pin_rerate_performance",
"#- pin_rerate        children        $RERATING{'rerating_children'}
#- pin_rerate        per_batch       $RERATING{'rerating_per_batch'}
#- pin_rerate        per_step        $RERATING{'rerating_per_step'}
#- pin_rerate        fetch_size      $RERATING{'rerating_fetch_size'}
#- pin_rerate        max_errs        $RERATING{'rerating_max_errs'}"


	,"pin_rerate_database_type_description", <<END
#======================================================================
# Database Type for rerate
#
# - rerate database_type oracle -----------> this means oracle
# - rerate database_type SqlServer ------> this means sql_server
# If no entry is there in pin.conf then assuming database type as oracle.
#
#======================================================================
END
	,"pin_rerate_database_type"
	,"- pin_rerate database_type oracle"

	,"pin_rerate_database_description", <<END
#======================================================================
# Default DB number for the search.
#======================================================================
END
	,"pin_rerate_database"
	,"- pin_rerate database $DM_ORACLE{'db_num'} /search 0"
	
	,"pin_rerate_delay_description", <<END
#======================================================================
# Delay for the rerating jobs.
#
# Rerating will only select jobs created before the delay period. 
# The delay period is the current time minus the delay.
#
# By default there is no delay.
#
# Specify the delay in seconds
#======================================================================
END
	,"pin_rerate_delay"
	,"#- pin_rerate delay 300"

	,"pin_rerate_description", <<END
#======================================================================
# Entries for pin_rerate
#
# These entries are used in the pin_rerate -rerate steps only for 
# performance improvement.
#
#======================================================================
END
        ,"pin_rerate",
"#- pin_rerate        rerate_children        5
#- pin_rerate        rerate_per_step       1000
#- pin_rerate        rerate_fetch_size        5000"
);
 

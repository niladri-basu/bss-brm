#=======================================================================
#  $Portal Version: pin_cnf_pin_subscription.pl:InstallVelocityInt:4:2005-Mar-25 18:11:51 $
# 
# Copyright (c) 2005, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$PIN_SUBSCRIPTION_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Triggering flexible Cycle Forward, Cycle 
# Rollover, Expired Discount Cleanup and Expire Sub-balance cleanup.
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


%PIN_SUBSCRIPTION_PINCONF_ENTRIES = (

	"pin_mta_performance_description", <<END
#======================================================================
# pin_mta_performance
#
# Entries for pin_subscription
#
# These entries are used in the pin_subscription configuration only.
#
#======================================================================
END
	,"pin_mta_performance",
"#- pin_mta        children        $SUBSCRIPTION{'subscription_children'}
#- pin_mta        per_batch       $SUBSCRIPTION{'subscription_per_batch'}
#- pin_mta        per_step        $SUBSCRIPTION{'subscription_per_step'}
#- pin_mta        fetch_size      $SUBSCRIPTION{'subscription_fetch_size'}
#- pin_mta        max_errs        $SUBSCRIPTION{'subscription_max_errs'}"

	,"pin_mta_database_description", <<END
#======================================================================
# Default DB number for the search.
#======================================================================
END
	,"pin_mta_database"
	,"- pin_mta database $DM_ORACLE{'db_num'} /search 0"

        ,"pin_sub_balance_cleanup_application_description", <<END
#======================================================================
#
# Some parameters for pin_sub_balance_cleanup application to manipulate
# the database directly.
#
#======================================================================
END
        ,"pin_sub_balance_cleanup_application",
"- pin_sub_balance_cleanup db_user $DM{'db'}->{'user'}
- pin_sub_balance_cleanup db_password $DM{'db'}->{'password'}
- pin_sub_balance_cleanup db_name $DM{'db'}->{'alias'}
- pin_sub_balance_cleanup db_accesslib oci11g72"

        ,"pin_purge_application_description", <<END
#======================================================================
#
# Some parameters for pin_purge application to manipulate
# the database directly.
#
#======================================================================
END
        ,"pin_purge_application",
"- pin_purge db_user $DM{'db'}->{'user'}
- pin_purge db_password $DM{'db'}->{'password'}
- pin_purge db_oraclePwd $DM{'db'}->{'password'}
- pin_purge db_name $DM_TT{'data_store'}
- pin_purge batch_size 1000"

	,"pin_purge_logfile_description", <<END
#======================================================================
# pin_purge_logfile
#
# Name and location of the log file used by this Portal process.
#
#======================================================================
END
	,"pin_purge_logfile"
	,"- pin_purge logfile \$\{PIN_LOG_DIR\}/pin_subscription/pin_purge.pinlog"

	,"pin_purge_loglevel_description", <<END
#======================================================================
# pin_purge_loglevel
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
	,"pin_purge_loglevel"
	,"- pin_purge loglevel 2"
 );

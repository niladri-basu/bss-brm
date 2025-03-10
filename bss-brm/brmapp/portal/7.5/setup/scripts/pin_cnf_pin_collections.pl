#=============================================================
#  @(#) % %
# 
# Copyright (c) 2005, 2012, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
#==============================================================

%COLLECTIONS_CM_PINCONF_ENTRIES = (

  	"collections_config_profiles_cache_description", <<END
#=======================================================================
# collections_config_profiles_cache
#
#=======================================================================
END
  	, "collections_config_profiles_cache", "- cm_cache fm_collections_config_profiles_cache 32, 20480, 16"
  	, "collections_config_actions_cache_description", <<END
#=======================================================================
# collections_config_actions_cache
#
#=======================================================================
END
  	, "collections_config_actions_cache", "- cm_cache fm_collections_config_actions_cache 256, 40960, 64"
	, "collections_config_scenario_cache_description", <<END
#=======================================================================
# collections_config_scenario_cache
#
#=======================================================================
END
        , "collections_config_scenario_cache", "- cm_cache fm_collections_config_scenario_cache 256, 40960, 64"
        , "collections_actions_dependency_description", <<END
#=======================================================================
# collections_action_dependency
# By default this feature is disabled(0).
#=======================================================================
END
        , "collections_actions_dependency", "#- fm_collections collections_action_dependency 1"
        , "fm_collections_description", <<END
#=======================================================================
# fm_collections
# If the value of the old_overdue_behavior is 0
# The latest bill due date is considered to calculate the over due date.
# If the value of the old_overdue_behavior is 1
# The earliest bill due date is considered to calculate the over due date.
# The default will value will be 0.
#
#=======================================================================
END
        , "fm_collections", "#- fm_collections old_overdue_behavior 1"
  	, "collections_fm_required_description", <<END
#========================================================================
# collections_fm_required
#
#========================================================================
END
  	, "collections_fm_required", <<END
- cm fm_module \$\{PIN_HOME\}/lib/fm_collections\$\{LIBRARYEXTENSION\} fm_collections_config$FM_FUNCTION_SUFFIX fm_collections_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_collections_pol\$\{LIBRARYEXTENSION\} fm_collections_pol_config$FM_FUNCTION_SUFFIX - pin
END
);


%COLLECTIONS_PINCONF_ENTRIES = (
	"pin_collections_db_description", <<END
#************************************************************************
# Configuration File for Portal Collections Applications
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
# Entries for pin_collections_process
#
# These entries are used for pin_collections configuration only.
#
#========================================================================
#
#- pin_collections_process        children        5
#- pin_collections_process        pay_type        0
#- pin_collections_process        per_batch       500
#- pin_collections_process        per_step        1000
#- pin_collections_process        fetch_size      5000
#- pin_collections_process        hotlist         hot_list
#- pin_collections_process        monitor         monitor
#- pin_collections_process        max_errs	  1
#
#========================================================================
# Default database number
#
# Specifies the default database number for searching.
#========================================================================
END
	,"pin_collections_db", "- pin_collections_process database $DM{'db_num'} /search 0"
	,"pin_collections_min_due_description", <<END
#======================================================================
# Minimum amount due that might force the account to get in collections
#
# This system-wide entry can override the configuration set by Collection 
# Configuration Application.
#======================================================================
END
	,"pin_collections_min_due", "#- pin_collections_process minimum_due 0.0"
	,"pin_collections_use_current_description", <<END
#======================================================================
# pin_collections_use_current
# This entry is to determine the date to calculate action due date.
# To use the the entry date, as configured in the scenario enter 0.
# This is the default.
# To use the current date (i.e the day which you are running
# pin_collections_process) enter 1.
#
#======================================================================
END
        ,"pin_collections_use_current", "#- pin_collections_process use_current_time 1"	
	,"pin_collections_send_dunning_description", <<END
#========================================================================
# Entries for pin_collections_send_dunning
#
# These entries are used in the pin_collections_send_dunning configuration only.
#
#========================================================================
#
#- pin_collections_send_dunning        children        5
#- pin_collections_send_dunning        per_batch       500
#- pin_collections_send_dunning        per_step        1000
#- pin_collections_send_dunning        fetch_size      5000
#- pin_collections_send_dunning        hotlist         hot_list
#- pin_collections_send_dunning        monitor         monitor
#- pin_collections_send_dunning        max_errs        1
#
#========================================================================
# Default database number
#
# Specifies the default database number for searching.
#========================================================================
END
	,"pin_collections_send_dunning", "- pin_collections_send_dunning database $DM{'db_num'} /search 0" 
	,"pin_collections_delivery_preference_description", <<END
#======================================================================
# Send(printing/emailing) preference for non-invoice accounts
#
# This entry only works for non-invoice accounts to determine whether
# to print or email the dunning letters.
#
# For now, the valid options are:
#   0 - emailing, Non-zero - printing
# And the default value will be non-zero (printing).
#======================================================================
END
	,"pin_collections_delivery_preference", "#- pin_collections_send_dunning delivery_preference 1" 
	,"pin_collections_email_option_description", <<END
#======================================================================
# Email option
#
# This entry is to determine whether the dunning letter should be attached
# in the email or sent in the email body.
# Two options to be chosen,
# 0 - Send as email body (default); 1 - Send as attachment
#======================================================================
END
	,"pin_collections_email_option", "#- pin_collections_send_dunning email_option 0"
	,"pin_collections_email_body_description", <<END
#======================================================================
# Email body
#
# When one chooses to send dunning letters as email attachments, he can
# put some customized message in the email body.  This entry gives
# the path to a text file of the letter for the customized info.
# Note, it only takes effect when the previous "email_invoice" entry
# is set to 1.
#======================================================================
END
	,"pin_collections_email_body", "#- pin_collections_send_dunning email_body ./letter"
	,"pin_collections_publish_description", <<END
#======================================================================
# This is an optional pin.conf entry.
#
# Uncommenting this entry would generate a notification event, sent
# to DM_AQ when pin_collections_process is run.
# The event will contain the start time and the end time of the
# pin_collections_process.
#
# The value for this entry can be:
#
#    0 = (Default) Do not generate notification event
#    1 = Generate notification event
#======================================================================
END
	,"pin_collections_publish", "#- pin_collections_process publish_run_details 1"
 );

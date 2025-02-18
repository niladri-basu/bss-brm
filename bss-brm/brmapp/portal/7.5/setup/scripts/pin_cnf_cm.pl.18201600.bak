#=======================================================================
#  @(#)%Portal Version: pin_cnf_cm.pl:PortalBase7.3.1Int:2:2007-Sep-20 01:16:39 %
# 
# Copyright (c) 2005, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$CM_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for the Connection Manager (CM)
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

%CM_PINCONF_ENTRIES = (
	"cm_0", <<END
#************************************************************************
# CM Connectivity Configuration Entries
#
# The entries below specify how the CM connects with other Portal
# processes.
#************************************************************************
END
	,"cm_ports_description", <<END
#========================================================================
# cm_ports
#
# Specifies the port number of the computer where the CM runs.
# 
# This number was assigned to this process when you installed Portal.
# The default, 11960, is a commonly specified port for the CM. If you
# change the port, make sure the port number does not conflict with
# another service. This number must be greater than 1000, unless you
# start the process as root. 
#
# The parameter following the port number is a required tag that
# identifies the set of FMs you use with this CM. The tag matches the tag
# at the end of the fm_module entries elsewhere in this file.
# The default tag is pin.
#========================================================================
END
	,"cm_ports", "- cm cm_ports $CM{'port'} pin"
	,"cm_name_description",  <<END
#========================================================================
# cm_name
#
# Specifies the name of the computer where the CM runs.
# 
# The name can be:
#
#    - (hyphen)                = Portal can use any IP address on the 
#                                  CM computer.
#
#    <host name or IP address> = Portal should use a particular IP
#                                  address on the CM computer.
#
# This entry is optional. If you remove it from the file, Portal uses
# gethostname to find the IP address of the CM computer.
#========================================================================
END
	,"cm_name","- cm cm_name $CM{'hostname'}"
	,"userid_description", <<END
#========================================================================
# userid
#
# Identifies the CM for logging into the Data Manager.
# 
# The identification includes the Portal database number, 
# object type (/service or /account), and the service object ID 1. 
# The CM uses the database number to identify the Portal database 
# and to connect to the correct Data Manager.
#
# The database number, in the form 0.0.0.N, is the number assigned to 
# your Portal database when you installed the system. The default
# is 0.0.0.1.
#
# For connections that don't require a login name and password, the CM
# also passes the service type to the database.
#
# This entry is reserved for Portal; DO NOT change it.
#========================================================================
END
	,"userid", "- cm userid $DM{'db_num'} /service 1"
	,"login_audit_description", <<END
#========================================================================
# login_audit
#
# Creates the session event�s storable object for each client application.
#
# The value for this entry can be:
#
#    0 = Portal doesn't create this object.
#    1 = (Default) Portal creates a storable object for the session
#           event when a client application requests a login.
#
# To turn off session-event logging, remove the crosshatch (#) from the
# beginning of the line for this entry and replace 1 with 0.
#========================================================================
END
	,"login_audit","#- cm login_audit $CM{'login_audit'}"
	,"cm_login_module_description", <<END
#========================================================================
# cm_login_module
#
# Specifies the protocol for verifying applications that try to log in to
# the CM.
# 
# The value for this entry can be:
#
#    cm_login_null.dll  = The CM should only verify the service.
#    cm_login_pw001.dll = The CM should verify the service and also ask
#                           the application for a login name and validate
#                           the password.
#========================================================================
END
	,"cm_login_module", "- cm cm_login_module $CM{'pin_conf_location'}/cm_login_pw001\$\{LIBRARYEXTENSION\}"
	,"dm_pointer_description", <<END
#========================================================================
# dm_pointer
#
# Specifies where to find one or more Data Managers for the Portal
# database.
#
# Use a separate dm_pointer for each DM on your system. 
# Each dm_pointer includes three values:
#
#    -- the database number, such as 0.0.0.1
#    -- the IP address or host name of the DM computer
#    -- the port number of the DM service
#========================================================================
END
	,"dm_pointer", "- cm dm_pointer $DM{'db_num'} ip $DM{'hostname'} $DM{'port'}"
        ,"dm_attributes_description", <<END
#========================================================================
# dm_attributes
#
# Specifies attributes associated with a particular database.
#
# These attributes are for every DM that belongs to a configured database
# number. Specify any or all of these values in a comma-separated list
# with no spaces:
#
#   scoped             = Turn on scoping enforcement. 
#   assign_account_obj = Assign an "owning" account reference when the
#                          object is created. This is typically used by
#                          database DMs.
#   searchable         = The DM is a database DM.
#========================================================================
END
        ,"dm_attributes", "- cm dm_attributes $DM{'db_num'} assign_account_obj, scoped, searchable"
	,"cm_max_connects_description",  <<END
#========================================================================
# cm_max_connects
#
# Specifies the maximum number of client connections to the CM.
# 
# The parent CM listens on the port for new connections and spawns a
# child process for each one. Use this entry to limit the maximum number
# of child CMs that are spawned by a single CM parent process (or thread).
#========================================================================
END
	,"cm_max_connects", "#- cm cm_max_connects $CM{'max_connects'}"
	,"log_session_description", <<END
#========================================================================
# log_session
#
# Specifies log session statistics.
#
# This entry is reserved for Portal. DO NOT change it.
#========================================================================
END
	,"log_session", "#- cm log_session $CM{'log_session'}"
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
#    1 = The CM sets the TCP "keepalive" flag for its connection to the
#          client, forcing the connection to be monitored actively. If the
#          connection is lost, you can detect it quickly and clean up the
#          CM and DM.
#========================================================================
END
	,"keepalive", "#- cm keepalive $CM{'keepalive'}"
	,"timeout_description", <<END
#========================================================================
# timeout
#
# Specifies the timeout value for receiving the next opcode request
# from an application.
#
# The value for this entry can be:
#
#    0 or less      = (Default) A CM child process waits infinitely for
#                       the next opcode request.
#    greater than 0 = A CM child process waits until the specified number
#                       of minutes has elapsed and then, if no opcode 
#                       request has arrived, the CM child process terminates.
#========================================================================
END
	,"timeout", "#- cm cm_timeout $CM{'timeout'}"
	,"cm_ylog0", <<END
#************************************************************************
# Configuration Entries for CM Logging
#
# The entries below specify how the CM logs information about its activity.
#************************************************************************
END
	,"cm_ylog_logfile_description", <<END
#========================================================================
# cm_logfile
#
# Specifies the full path to the log file used by the CM.
#
# You can enter any valid path.
# 
# If you use multiple CMs, you can set all of them to log to the same file
# (use the same cm_logfile entry in each configuration file) or set each
# CM to log to a unique file.
#========================================================================
END
	,"cm_ylog_logfile", "- cm cm_logfile \$\{PIN_LOG_DIR\}/cm/cm.pinlog"
	,"cm_ylog_level_description",  <<END
#========================================================================
# cm_loglevel
#
# Specifies how much information the CM logs.
# 
# The value for this entry can be:
#
#    0 = no logging
#    1 = (Default) log error messages only
#    2 = log error messages and warnings
#    3 = log error, warning, and debugging messages
#========================================================================
END
	,"cm_ylog_level", "- cm cm_loglevel $CM{'log_level'}"
        ,"passwd_age_description",  <<END
#========================================================================
# passwd_age
#
# Specifies the number of days after which password expires.
#
# The value for this entry can be:
#
#    Any desired positive value.
#   
#========================================================================
END
        ,"passwd_age", "- cm passwd_age $CM{'passwd_age'}"
	,"cm_ylog_format_description",  <<END
#========================================================================
# cm_logformat
#
# Specifies which PINLOG format to use.
# 
# The value for this entry can be:
#
#    0 = Use the original format. The date is locale-specific.
#    1 = Format the date as yyyy-mm-dd. The time includes milliseconds
#========================================================================
END
	,"cm_ylog_format", "- cm cm_logformat $CM{'log_format'}"	
      ,"discounting_em_group_description", <<END
#========================================================================
# discounting_em_group
#
# Defines a member opcode in a group of opcodes provided by an
# External Manager (EM). 
#
# The group tag must match the tag in the "em_pointer" entries below.
# 
# Each group includes two values:
#
#    -- the EM tag, a string of 1 to 15 characters, that matches the
#         em_pointer tags
#    -- the opcode name or number
#========================================================================
END
        ,"discounting_em_group", "- cm em_group discounting PCM_OP_RATE_DISCOUNT_EVENT"
	,"discounting_em_pointer_description", <<END
#========================================================================
# discounting_em_pointer
#
# Specifies where to find the External Manager(s) that provide other
# opcodes to the CM.
#
# Use a separate pointer for each EM on your system.
# 
# Each pointer includes four values:
#
#    <em tag>           = a string of 1 to 15 characters that matches
#                           the em_group keys
#    <address type tag> = "ip", for this release
#    <host>             = the name or IP address of the computer running
#                           the EM
#    <port>             = the TCP port number of the EM on this computer
#========================================================================
END
      ,"discounting_em_pointer", "- cm em_pointer discounting ip $DISCOUNTING{'hostname'} $DISCOUNTING{'port'}"
      ,"rerating_em_group_description", <<END
#========================================================================
# rerating_em_group
#
# Defines a member opcode in a group of opcodes provided by an
# External Manager (EM). 
#
# The group tag must match the tag in the "em_pointer" entries below.
# 
# Each group includes two values:
#
#    -- the EM tag, a string of 1 to 15 characters, that matches the
#         em_pointer tags
#    -- the opcode name or number
#========================================================================
END
      ,"rerating_em_group", "- cm em_group rerating PCM_OP_RATE_PIPELINE_EVENT"
      ,"rerating_em_pointer_description", <<END
#========================================================================
# rerating_em_pointer
#
# Specifies where to find the External Manager(s) that provide other
# opcodes to the CM.
#
# Use a separate pointer for each EM on your system.
# 
# Each pointer includes four values:
#
#    <em tag>           = a string of 1 to 15 characters that matches
#                           the em_group keys
#    <address type tag> = "ip", for this release
#    <host>             = the name or IP address of the computer running
#                           the EM
#    <port>             = the TCP port number of the EM on this computer
#========================================================================
END
      ,"rerating_em_pointer", "- cm em_pointer rerating ip $RERATING{'hostname'} $RERATING{'port'}"
      ,"zoning_em_group_description", <<END
#========================================================================
# zoning_em_group
#
# Defines a member opcode in a group of opcodes provided by an
# External Manager (EM). 
#
# The group tag must match the tag in the "em_pointer" entries below.
# 
# Each group includes two values:
#
#    -- the EM tag, a string of 1 to 15 characters, that matches the
#         em_pointer tags
#    -- the opcode name or number
#========================================================================
END
        ,"zoning_em_group", "- cm em_group zoning PCM_OP_RATE_GET_ZONEMAP_INFO"
	,"zoning_em_pointer_description", <<END
#========================================================================
# zoning_em_pointer
#
# Specifies where to find the External Manager(s) that provide other
# opcodes to the CM.
#
# Use a separate pointer for each EM on your system.
# 
# Each pointer includes four values:
#
#    <em tag>           = a string of 1 to 15 characters that matches
#                           the em_group keys
#    <address type tag> = "ip", for this release
#    <host>             = the name or IP address of the computer running
#                           the EM
#    <port>             = the TCP port number of the EM on this computer
#========================================================================
END
          ,"zoning_em_pointer", "- cm em_pointer zoning ip $ZONING{'hostname'} $ZONING{'port'}"
	  ,"required_fm_description", <<END
#========================================================================
# fm_required
#
# Required Facilities Modules (FM) configuration entries
#
# The entries below specify the required FMs that are linked to the CM when
# the CM starts. The FMs required by the CM are included in this file when
# you install Portal. 
#
# Caution: DO NOT modify these entries unless you need to change the
#          location of the shared library file. DO NOT change the order of
#          these entries, because certain modules depend on others being
#          loaded before them.
#========================================================================
END
	,"required_fm",  
"- cm fm_module \$\{PIN_HOME\}/lib/fm_utils\$\{LIBRARYEXTENSION\} fm_utils_config$FM_FUNCTION_SUFFIX fm_utils_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_bill_utils\$\{LIBRARYEXTENSION\} fm_bill_utils_config$FM_FUNCTION_SUFFIX fm_bill_utils_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_sdk\$\{LIBRARYEXTENSION\} fm_sdk_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_act\$\{LIBRARYEXTENSION\} fm_act_config$FM_FUNCTION_SUFFIX fm_act_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_subscription\$\{LIBRARYEXTENSION\} fm_subscription_config$FM_FUNCTION_SUFFIX fm_subscription_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_subscription_pol\$\{LIBRARYEXTENSION\} fm_subscription_pol_config$FM_FUNCTION_SUFFIX fm_subscription_pol_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_rate\$\{LIBRARYEXTENSION\} fm_rate_config$FM_FUNCTION_SUFFIX fm_rate_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_rate_pol\$\{LIBRARYEXTENSION\} fm_rate_pol_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_group\$\{LIBRARYEXTENSION\} fm_group_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_cust\$\{LIBRARYEXTENSION\} fm_cust_config$FM_FUNCTION_SUFFIX fm_cust_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_zonemap\$\{LIBRARYEXTENSION\} fm_zonemap_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_cust_pol\$\{LIBRARYEXTENSION\} fm_cust_pol_config$FM_FUNCTION_SUFFIX fm_cust_pol_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_bill\$\{LIBRARYEXTENSION\} fm_bill_config$FM_FUNCTION_SUFFIX fm_bill_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_bill_pol\$\{LIBRARYEXTENSION\} fm_bill_pol_config$FM_FUNCTION_SUFFIX fm_bill_pol_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_pymt\$\{LIBRARYEXTENSION\} fm_pymt_config$FM_FUNCTION_SUFFIX fm_pymt_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_pymt_pol\$\{LIBRARYEXTENSION\} fm_pymt_pol_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_bal\$\{LIBRARYEXTENSION\} fm_bal_config$FM_FUNCTION_SUFFIX fm_bal_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_bal_pol\$\{LIBRARYEXTENSION\} fm_bal_pol_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_inv\$\{LIBRARYEXTENSION\} fm_inv_config$FM_FUNCTION_SUFFIX fm_inv_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_inv_pol\$\{LIBRARYEXTENSION\} fm_inv_pol_config$FM_FUNCTION_SUFFIX fm_inv_pol_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_act_pol\$\{LIBRARYEXTENSION\} fm_act_pol_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_price\$\{LIBRARYEXTENSION\} fm_price_config$FM_FUNCTION_SUFFIX fm_price_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_price_pol\$\{LIBRARYEXTENSION\} fm_price_pol_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_gl\$\{LIBRARYEXTENSION\} fm_gl_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_perm\$\{LIBRARYEXTENSION\} fm_perm_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_global_search\$\{LIBRARYEXTENSION\} fm_global_search_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_gel\$\{LIBRARYEXTENSION\} fm_gel_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_zonemap_pol\$\{LIBRARYEXTENSION\} fm_zonemap_pol_config$FM_FUNCTION_SUFFIX fm_zonemap_pol_get_lineage_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_ar\$\{LIBRARYEXTENSION\} fm_ar_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_ar_pol\$\{LIBRARYEXTENSION\} fm_ar_pol_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_remit\$\{LIBRARYEXTENSION\} fm_remit_config$FM_FUNCTION_SUFFIX fm_remit_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_remit_pol\$\{LIBRARYEXTENSION\} fm_remit_pol_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_reserve\$\{LIBRARYEXTENSION\} fm_reserve_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_device\$\{LIBRARYEXTENSION\} fm_device_config$FM_FUNCTION_SUFFIX fm_device_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_device_pol\$\{LIBRARYEXTENSION\} fm_device_pol_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_custcare\$\{LIBRARYEXTENSION\} fm_custcare_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_filter_set\$\{LIBRARYEXTENSION\} fm_filter_set_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_rerate\$\{LIBRARYEXTENSION\} fm_rerate_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_suspense\$\{LIBRARYEXTENSION\} fm_suspense_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_asm\$\{LIBRARYEXTENSION\} fm_asm_config$FM_FUNCTION_SUFFIX - pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_monitor\$\{LIBRARYEXTENSION\} fm_monitor_config$FM_FUNCTION_SUFFIX - pin"
	,"pol_0", <<END
#************************************************************************
# Configuration Entries for Policies
#************************************************************************
END
	,"pol_em_db_description",  <<END
#========================================================================
# em_db
#
# Specifies the Email Data Manager database number.
# 
# Delivery FMs use this entry to locate the email database. The value must
# be the same as the dm_db_no entry in the  configuration file for the
# email DM.
#========================================================================
END
	,"pol_em_db","- fm_delivery em_db $EMAIL_DM{'db_num'} /_em_db 0"
	,"pol_config_payment_description", <<END
#========================================================================
# config_payment
#
# Configures the Modular Payment Interface.
#
# The default Portal object ID is 200, but you can override it by 
# creataing another configuration object in the database and modifying
# this entry.
#========================================================================
END
	,"pol_config_payment", "- fm_pymt config_payment $DM{'db_num'} /config/payment 200"
	,"pol_timestamp_rounding_description", <<END
#========================================================================
# timestamp_rounding
#
# Specifies how to round timestamps of account products.
#
# The value for this entry can be:
#
#    0 = (Default) Do not round timestamps.
#    1 = Round account product timestamps to midnight.
#========================================================================
END
	,"pol_timestamp_rounding", "- fm_bill timestamp_rounding $CM{'timestamp_rounding'}"
	,"pol_stop_bill_closed_accounts_description", <<END
#======================================================================
# stop_bill_closed_accounts
#
# By default, you can configure BRM to enable or disable billing of closed
# accounts.
# When billing of closed accounts is disabled, BRM excludes closed accounts
# from the billing run when the following conditions are met:
# 
# The account.s total balance due for every bill unit is zero.
# Note  For hierarchical accounts, the total balance due includes the totals
# from the subordinate bill unit of their child accounts.
# 
# Now for these conditions to be checked during billing the following parameter
# stop_bill_closed_accounts should be marked as 1.
# ,
# If this parameter is marked as 1 then,  during billing of the cycle in which
# the billinfo with zero total due became closed ,the assesment of the above
# conditions will happen. There will be a zero amount bill generated for this
# cycle but due to assesment the bill unit (billinfo) fo this closed account
# will be marked such that it will not be picked up for billing in the future.
# 
# By default the value of this parameter is 0 which means billing of closed
# accounts with zero total due is allowed unrestricted.
#======================================================================
END
	,"pol_stop_bill_closed_accounts", "- fm_bill stop_bill_closed_accounts $CM{'stop_bill_closed_accounts'}"
        ,"pol_use_number_of_days_in_month_description", <<END
#======================================================================
# use_number_of_days_in_month
#
# Specifies how to calculate the proration scale when purchasing or
# cancelling a monthly product.
#
# The value for this entry can be:
#
#    0 = (Default) Base the calculation on the number of days in the
#        cycle.
#    1 = Base the calculation on the number of days in the current
#        month. If the starting and ending dates of the cycle are in
#        the same month, base the calculation on the number of days in
#        the month.
#======================================================================
END
        ,"pol_use_number_of_days_in_month", "#- fm_bill use_number_of_days_in_month $CM{'use_number_of_days_in_month'}"
	,"pol_cycle_delay_use_special_days_description", <<END
#======================================================================
# cycle_delay_use_special_days
#
# Specifies whether or not to use the special days if delay is defined 
# in cycles
# 
# The values for this entry can be:
# 0 = (Default) Do not use the special days
# 1 = Use special days
# 
#======================================================================
END
        ,"pol_cycle_delay_use_special_days", "#- fm_bill cycle_delay_use_special_days $CM{'cycle_delay_use_special_days'}"
        ,"apply_rollover_description", <<END
#======================================================================
# apply_rollover
# Apply rollovers if this value is set to 1 
# 
# If you do not use rollovers, you can disable rollover calculation by using 
# this entry. This entry is on by default, that is, rollovers are applied, 
# but you can turn it off to increase performance. 
#======================================================================
END
        ,"apply_rollover", "#- fm_bill apply_rollover 1"
        ,"config_billing_cycle_description", <<END
#======================================================================
## config_billing_cycle 
# 
# Specifies how long after the billing cycle ends that new events are   
# considered for the previous month.s bill.   
# 
# Set this entry to specify how long after the end of the billing cycle the   
# new events are considered for the previous month.s bill. If this value is 
# greater than config_billing_delay CM errors out. 
# Note: config_billing_cycle should be <= config_billing_delay 
# By default this value is set to 0.
#======================================================================
END
        ,"config_billing_cycle", "#- fm_bill config_billing_cycle 0"
        ,"cycle_delay_align_description", <<END
#======================================================================
# cycle_delay_align 
# 
# Specifies whether to align the product purchase, cycle, and 
# usage start and end times to the accounting cycle. 
# 
# If this value is 1 and if you configure delayed purchase, cycle, or usage 
# start and end times, they will be aligned to the accounting cycle provided 
# the delayed start and end time is a whole number, not a fraction 
# and also the delay should be measured in cycles. 
# By default this entry is set to 0 which means start and end times 
# are not aligned to the accounting cycle. 
#======================================================================
END
        ,"cycle_delay_align", "#- fm_bill cycle_delay_align 0"
        ,"advance_bill_cycle_description", <<END
#======================================================================
# advance_bill_cycle 
# 
# Sets the first billing date to be the day after account creation 
# 
# If you want to set the first billing date to be the day after account 
# creation set this value to 1. By default, this entry is set to 0 which 
# means that account is billed normally after one month. 
#======================================================================= 
END
        ,"advance_bill_cycle", "#- fm_bill advance_bill_cycle 0"
        ,"open_item_actg_include_prev_total_description", <<END
#======================================================================
# open_item_actg_include_prev_total 
# 
# Includes previous bill totals to the pending receivable value calculated 
# during billing for accounts with open item accounting type. 
# 
# If you want to include the previous balance of open items in the total   
# amount due of the current bill unit during open item accounting set this   
# value to 1. By default, this value is set to 0 which means the previous 
# total is not added to the pending amount due during open item accounting. 
#======================================================================
END
        ,"open_item_actg_include_prev_total", "#- fm_bill open_item_actg_include_prev_total 0"
        ,"valid_backward_interval_description", <<END
#======================================================================
# valid_backward_interval 
# 
# Prevents billing when billing date is set in the past 
# 
# To control auto-triggered billing for events in the past, you can set a   
# value for the valid_backward_interval entry. 
# By default, this entry is set to 0. This means that validation of 
# billing time and current time is not performed. 
#======================================================================
END
        ,"valid_backward_interval", "#- fm_bill valid_backward_interval 0"
	,"pol_calc_cycle_from_cycle_start_t_description", <<END
#======================================================================
# calc_cycle_from_cycle_start_t
#
# Specifies whether or not to use the cycle-start-t of the product instance
# to calculate the cycle for backdated multi-month cycle fees.
# 
# The values for this entry can be:
# 0 = (Default) Use account-next-t to determine the cycle.
# 1 = Use cycle-start-t and BILLING DOM to determine the cycle.
# 
#======================================================================
END
        ,"pol_calc_cycle_from_cycle_start_t", "#- fm_bill calc_cycle_from_cycle_start_t $CM{'calc_cycle_from_cycle_start_t'}"
	,"pol_cb_delay_description", <<END
#======================================================================
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
# This entry is the same as the config_billing_delay entry in the
# pin_billd configuration file.
#
# In the enabled entry below, the billing run is not delayed but avoids auto
# triggering of billing.
#======================================================================
END
	,"pol_cb_delay", "#- fm_bill config_billing_delay $CM{'config_billing_delay'}"
	,"pol_invoice_dir_description", <<END
#========================================================================
# invoice_dir
#
# Specifies the directory where invoices are stored.
#
# This must be the same directory specified in the "-directory" parameter
# of the pin_invoice_gen utility.
#========================================================================
END
	,"pol_invoice_dir", "- fm_bill invoice_dir $BILLING{'pin_conf_location'}/invoice_dir"
	,"pol_overdue_tolerance_description", <<END 
#========================================================================
# overdue_tolerance
#
# Specifies how Portal treats amounts applied to the item when they are
# less than the amount due as a result of euro and EMU conversions.
#
# The tolerance values defined for Portal resources can cause some
# variation between the converted amount and the billed amount.
#
# The value for this entry can be:
#
#    none              = Do not apply tolerance values defined for
#                          resources.
#    primary           = Apply tolerance values only if the amount applied 
#                          to the item is in the primary currency.
#    secondary         = Apply tolerance values only if the amount applied 
#                          to the item is in the secondary currency.
#    primary_secondary = Apply tolerance values if the amount applied to
#                          the item is in either currency.
#========================================================================
END
	,"pol_overdue_tolerance", "- fm_bill overdue_tolerance $CM{'overdue_tolerance'}"
	,"pol_underdue_tolerance_description", <<END
#========================================================================
# underdue_tolerance
#
#
# Specifies how Portal treats amounts applied to the item when they are
# more than the amount due as a result of euro and EMU conversions.
#
# The tolerance values defined for Portal resources can cause some
# variation between the converted amount and the billed amount.
#
# The value for this entry can be:
#
#    none              = Do not apply tolerance values defined for
#                          resources.
#    primary           = Apply tolerance values only if the amount applied 
#                          to the item is in the primary currency.
#    secondary         = Apply tolerance values only if the amount applied 
#                          to the item is in the secondary currency.
#    primary_secondary = Apply tolerance values if the amount applied to
#                          the item is in either currency.
#========================================================================
END
	,"pol_underdue_tolerance", "- fm_bill underdue_tolerance $CM{'underdue_tolerance'}"
	,"pol_cancel_tolerance_description", <<END
#========================================================================
# cancel_tolerance
#
# Specifies the cancellation tolerance of account products, in minutes.
#
# This is the time after a product is purchased when it can be cancelled
# with a full refund. For example, this tolerance is needed when a
# customer service representative assigns the wrong product to a customer
# and needs to cancel it.
#========================================================================
END
	,"pol_cancel_tolerance", "#- fm_bill cancel_tolerance $CM{'cancel_tolerance'}"
        ,"pol_purchase_fees_backcharge_description", <<END
#======================================================================
# purchase_fees_backcharge
#
# Specifies Future purchase of product that starts in current billing
# cycle.
#
# The value for this entry can be: 
#
#  1 = Apply any deferred product purchase fees to this cycle.
#  0 = (Default) It will be applied to next cycle. 
#======================================================================
END
        ,"pol_purchase_fees_backcharge", "#- fm_bill purchase_fees_backcharge $CM{'purchase_fees_backcharge'}"
	,"pol_validate_acct_description", <<END
#========================================================================
# validate_acct
#
# Specifies the account for logging credit-card validations during
# registration.
#
# You can't store this information with each account, because validation
# of a credit card is performed before the account is created. The default
# account is:
#
#     0.0.0.1 /account 1
#
# which is the root account in your database. You can change "1" to some
# other account, so long as it has a bill type that isn't affected by
# billing operations or events.
#========================================================================
END
	,"pol_validate_acct", "- fm_pymt_pol validate_acct $DM{'db_num'} /account 1"
	,"pol_creation_logging_description", <<END
#========================================================================
# creation_logging
#
# Specifies event logging for non-dollar events.
#
# The value for this entry can be:
#
#    0 = (Default) Ignore non-dollar creation events during registration,
#          thus saving storage space and speeding account creation.
#    1 = Log these events.
#========================================================================
END
	,"pol_creation_logging", "- fm_cust creation_logging $CM{'creation_logging'}"
        ,"pol_sender_description", <<END
#========================================================================
# sender
#
# Specifies the postmaster name.
#
# By default, the email sender is "postmaster".
#========================================================================
END
        ,"pol_sender", "- fm_cust_pol sender $EMAIL_DM{'sender'}"
	,"apply_folds_description", <<END
#========================================================================
# apply_folds
#
# To apply folds set this value to 1 
# 
# If you do not use folds, you can disable fold calculation by using 
# this entry. This entry is on by default, that is, folds are applied, 
# but you can turn it off to increase performance. 
#
#========================================================================
END
	,"apply_folds", "#- fm_bill apply_folds 1"
	,"pol_domain_description", <<END
#========================================================================
# domain
#
# Specifies the email domain assigned to customers during registration.
#
# You can use any domain name, such as "myfirm.com" or "teacup.co.uk".
#========================================================================
END
	,"pol_domain", "- fm_cust_pol domain $EMAIL_DM{'domain'}"
	,"pol_merchant_description", <<END
#========================================================================
# merchant
#
# Specifies the merchant to receive money collected during credit-card
# processing.
#
# Portal attaches this merchant name to the account when creating the
# account. This name must match a merchant name entry in the configuration
# file for the credit-card processing data manager. For example, if the
# merchant is "psi", the merchant name in the configuration file for the
# credit-card DM must be "mid_psi".
#
# After you set up a merchant name with the credit-card processing
# company, replace "test" in this entry with the actual merchant name.
#========================================================================
END
	,"pol_merchant", "- fm_cust_pol merchant $CC_DM{'merchant_name'}"
        ,"pol_taxation_switch_description", <<END
#======================================================================
# taxation_switch
#
# Specifies whether taxation should be enabled/disabled in Portal.
#
#       0  - Taxation is disabled
#       1  - Enable real-time taxation
#       2  - Enable cycle-time taxation
#       3  - (Default) Enable both real and cycle time taxation
#
# Note: Disabling taxation will disable the following entries:
#
#   tax_valid           - Address and VAT validation
#   tax_return_loglevel - Specify how messages from tax engine are logged
#   tax_return_juris    - Specify if taxes should be summarized by juris level
#   include_zero_tax    - Include zero tax amounts into event's tax juris
#   cycle_tax_interval  - Specify if subords' taxes are rolled to parent
#
#======================================================================
END
        ,"pol_taxation_switch", "#- fm_bill taxation_switch $TAX_DM{'taxation_switch'}"
	,"pol_tax_supplier_map_description", <<END
#========================================================================
# tax_supplier_map
#
# Specifies the location of the tax_supplier.map file.
#
# You need to include this entry only if the tax package (such as Taxware,
# Vertex, or BillSoft) is the primary source of tax-supplier information
# and you have created a tax_supplier.map file. If Portal is the primary
# source of tax supplier information, you don't need the map file or this
# entry.
#
# To use this entry, remove the crosshatch (#) from the beginning of its
# line and replace <file_path> with the path to the tax_supplier.map file.
#========================================================================
END
	,"pol_tax_supplier_map", "#- fm_rate tax_supplier_map $CM{'pin_conf_location'}/tax_supplier_map"
	,"pol_taxcodes_map_description", <<END
#========================================================================
# taxcodes_map
#
# Specifies the location of the taxcodes_map file.
#
# The taxcodes_map file maps Portal tax codes to products of the tax
# packages that Portal supports.
#========================================================================
END
	,"pol_taxcodes_map", "- fm_rate taxcodes_map $CM{'pin_conf_location'}/taxcodes_map"
	,"pol_cycle_tax_interval_description", <<END
#========================================================================
# cycle_tax_interval
#
# How to calculate deferred taxes for hierarchies.
#
# This entry is used to determine tax computation of parent and
# children accounts.  If the entry is set to 'billing', the tax
# for the subordinate account will go to the parent account.  So, 
# at the end of the cycle, the parent will have both taxes (own
# and subord's). If the entry is set to 'accounting' (default), 
# then the tax for the subordinate will go to the subordinate 
# account, and the tax for the parent will go to the parent 
# account.  To use this entry, remove the crosshatch (#) from 
# the beginning of the line and specify 'billing' or 'accounting'.
#========================================================================
END
	,"pol_cycle_tax_interval", "#- fm_bill cycle_tax_interval $TAX_DM{'tax_interval'}"
        ,"item_search_batch_description", <<END
#========================================================================
# item_search_batch
#
# Specifies the number of items returned when performing a step search. 
# By default, BRM returns 1000 items with each step of the search. 
# If you do not want to use step-search set the number of returned items to 0. 
#========================================================================
END
        ,"item_search_batch", "- fm_bill     item_search_batch     1000"
	,"pol_validate_deal_dependencies_description", <<END
#======================================================================
# validate_deal_dependencies
#
# Specifies whether to validate the deal pre_requisites and mutually
# exclusive relations. These relations can be configured thru the Pricing
# Tool.
#
# If this flag is enabled by setting a non-zero value say 1.
# If enabled then during purchase, cancel, status change, etc will do
# the deal level validations pre_requisite and mutually exclusive. If
# not valid, error message is logged.
#
# By default, this configuration parameter is disabled(commented) so
# there is no deal level validation. This is a system-wide parameter only.
#
#======================================================================
END
	,"pol_validate_deal_dependencies", "#- fm_utils validate_deal_dependencies $CM{'validate_deal_dependencies'}"
	,"pol_tax_return_loglevel_description", <<END
#========================================================================
# tax_return_loglevel
#
# Specifies how much information the tax engine should report.
#
# The value for this entry can be:
#
#    0 = Do not report any messages from the tax engine.
#    1 = Report messages from the tax engine as errors.
#    2 = (Default) Report messages from the tax engine as warnings.
#========================================================================
END
	,"pol_tax_return_loglevel", "# - fm_rate tax_return_loglevel $TAX_DM{'tax_return_loglevel'}"
	,"pol_tax_return_juris_description", <<END
#========================================================================
# tax_return_juris
#
# Specifies if taxes should be summarized by jurisdiction level.
#
# The value for this entry can be:
#
#    summarize = Summarize taxes by jurisdiction level. (Default).
#    itemize   = Do not summarize taxes by jurisdiction level.
#========================================================================
END
	,"pol_tax_return_juris", "# - fm_rate tax_return_juris $TAX_DM{'tax_return_juris'}"
	,"pol_include_zero_tax_description", <<END
#========================================================================
# include_zero_tax
#
# Specify whether to include zero tax amounts into the tax
# jurisdictions for the event's balance impacts.
#
# The values for this entry can be:
#
#    0 = Do not include zero tax amounts. (Default).
#    1 = Include zero tax amounts.
#========================================================================
END
	,"pol_include_zero_tax", "# - fm_rate include_zero_tax $TAX_DM{'include_zero_tax'}"
	,"long_cycle_roundup_description", <<END
#========================================================================
# long_cycle_roundup
#
# Round up for long cycle if this flag is 1
#
# If this value is "1", the fm_rate round up the long cycle to ceiling
# to charge for full cycle arrear. '0' value of this flag will keep the
# default processing. Default value for this flag will be treated as '0'
#========================================================================
END
	,"long_cycle_roundup", "#- fm_rate rating_longcycle_roundup_flag  1"
	,"rating_refresh_product_interval_description", <<END
#========================================================================
# rating_refresh_product_interval
#
# Specifies the interval, after which product will be refreshed in cache
#
# Default value of refresh_product_interval is configured as 3600 seconds.
#========================================================================
END
	,"rating_refresh_product_interval", "# - fm_rate  refresh_product_interval 3600"
	,"rating_log_refresh_product_description", <<END
#========================================================================
# rating_log_refresh_product
#
# To turn on this option, change the fm_rate log_refresh_product entry in the 
# CM configuration file (pin.conf) to 1. If this entry is absent or set to zero, 
# Portal does not log changes to the price lists. 
#
# Default value of log_refresh_product is configured as 0.
#========================================================================
END
	,"rating_log_refresh_product", "# - fm_rate  log_refresh_product 0"
	,"fm_rate_rate_cache_size_description", <<END
#========================================================================
# rate_cache_size
#
# Specifies the cache size, in kilobytes, for price list data.
#
# The default size is 2048 KB. The cache is stored in the cm_data_file.
# See the entry for cm_data_file elsewhere in this configuration file for
# more information.
# 
# Note: This entry applies only if you turn on price list caching by
#       modifying the fm_module entry for fm_rate_config. For more
#       information, see "Syntax for Facilities Module entries" in the
#       online documentation.
#========================================================================
END
	,"fm_rate_rate_cache_size", "- fm_rate rate_cache_size $CM{'rate_cache'}"
	,"extra_rate_flags_description", <<END
#========================================================================
# extra_rate_flags
#
# Default value of extra_rate_flags is configured as 0x00.
#========================================================================
END
	,"extra_rate_flags", "# - fm_rate extra_rate_flags 0"
	,"rating_max_scale_description", <<END
#========================================================================
# rating_max_scale
#
# rating_max_scale defines the precison level of decimal values
#
# Default value of rating_max_scale is configured as 10 decimal place
#========================================================================
END
	,"rating_max_scale", "# - fm_rate  rating_max_scale 10"
	,"rating_cycle_arrear_proration_description", <<END
#========================================================================
# rating_cycle_arrear_proration
#
# Specifies the proration settings that address customers with cycle 
# arrears fees who purchase, inactivate and reactivate products within 
# the first cycle. 
# 
# The value for this entry can be: 
#    0 = Purchasing 
#    1 = Cancellation 
# 
# Default Value is 1.
#========================================================================
END
	,"cycle_arrear_proration", "# - fm_rate cycle_arrear_proration 1"
	,"rating_timezone_description", <<END
#========================================================================
# rating_timezone
#
# Define the timezone to be used to rate the event
#
# Default value of rating_timezone is configured as default i.e server time zone
#========================================================================
END
	,"rating_timezone", " - fm_rate  rating_timezone US/Pacific"
	,"timezone_file_description", <<END
#========================================================================
# timezone_file
#
# The timezone_file entry specifies the location of the file through which 
# custom time zone entries can be added.
#
# Custom time zone entries can be added in the sample_timezone.txt file
#========================================================================
END
	,"timezone_file", "# - fm_rate timezone_file sample_timezone.txt"
	,"rating_include_zero_tax_description", <<END
#========================================================================
# rating_include_zero_tax
#
# Flag to control tax calculation on rated value
#
# Default value of include_zero_tax is configured as False
#========================================================================
END
	,"rating_include_zero_tax", "# - fm_rate  include_zero_tax 0"	
	,"tax_reversal_with_tax_description", <<END
#======================================================================
# tax_reversal_with_tax
#
# Specifies whether Portal will apply a tax reversal for an adjustment, dispute, 
# or settlement if the opcode does not specify a tax treatment.
#
# The value for this entry can be:
#
#    1 = A tax reversal will not occur.
#    2 = A tax reversal will occur.
#
# If this line is commented out, the tax reversal will not occur.
#======================================================================
END
	,"tax_reversal_with_tax"
	, "#- fm_ar tax_reversal_with_tax 1"
	,"fm_ar_tax_now_description", <<END
#========================================================================
# fm_ar_tax_now
#
# Specifies whether a tax calculation for an account adjustment
# will be deferred to billing time or occur when the adjustment is created.
#
# The value for this entry can be:
#
#    0 = The tax calculation will be deferred.
#    1 = The tax calculation will take place at adjustment creation time.
#
# If this line is commented out, the tax calculation is deferred.
#========================================================================
END
	,"fm_ar_tax_now", "#- fm_ar tax_now 0"
	,"pol_intro_dir_description", <<END
#========================================================================
# intro_dir
#
# Specifies the location of the introductory message.
#
# The message lets a customer confirm desire for the account. Enter the
# location of files that contain the introductory message you want to send
# to customers during registration, before each account is created.
#========================================================================
END
	,"pol_intro_dir"," - fm_cust_pol intro_dir $CM{'pin_conf_location'}/intro"
	,"pol_config_dir_description", <<END
#========================================================================
# config_dir
#
# Specifies the location of ISP configuration data.
#
# Configuration data for an Internet service provider includes the
# mail-server address that you send to the customer's client software
# upon registration.
#========================================================================
END
	,"pol_config_dir", "- fm_cust_pol config_dir $CM{'pin_conf_location'}/config"
	,"pol_welcome_dir_description", <<END
#========================================================================
# welcome_dir
#
# Specifies the location of the welcome message.
#
# Enter the location of files that contain the welcome message you send 
# to customers during registration, after the account is created.
#========================================================================
END
	,"pol_welcome_dir", "- fm_cust_pol welcome_dir $CM{'pin_conf_location'}/welcome"
	,"pol_new_account_welcome_msg_description", <<END
#======================================================================
# new_account_welcome_msg
#
# Specifies whether Portal should send a default welcome message when
# it creates a new account.
#
# The value for this entry can be:
#
#    0 = (Default) Do not send a welcome message.
#    1 = Send a welcome message when creating a new account.
#======================================================================
END
	,"pol_new_account_welcome_msg", "- fm_cust_pol new_account_welcome_msg $CM{'send_new_account_welcome_msg'}"
	,"pol_country_description", <<END
#========================================================================
# country
#
# Specifies the default country.
#
# If a customer doesn�t enter a country name during registration, this 
# country is automatically assigned to the customer's account. The default
# is "USA".
#========================================================================
END
	,"pol_country", "- fm_cust_pol country $CM{'default_country'}"
	,"pol_cc_checksum_description", <<END
#========================================================================
# cc_checksum
#
# Specifies whether to run a checksum validation on the customer's credit
# card.
# 
# The value for this entry can be:
#
#    0 = Do not perform this validation.
#    1 = (Default) Use a checksum to validate the credit card during
#          registration. 
#========================================================================
END
	,"pol_cc_checksum", "- fm_cust_pol cc_checksum $CC_DM{'run_checksum'}"
	,"pol_tax_valid_description",  <<END
#========================================================================
# tax_valid
#
# Specifies how to validate the state and ZIP code during registration.
# Validation is possible only if the taxation_switch is enabled and the
# appropriate tax DM is running.
#
# The value for this entry can be:
#
#    0 = (Default) Do not check the ZIP code. 
#    1 = Use Taxware Sales/Use to validate the ZIP code. (The Taxware DM
#          must be running).
#    2 = Use Taxware WorldTax to validate the ZIP code. (The Taxware DM
#          must be running).
#    3 = Use Quantum to validate the ZIP code. (The Vertex DM must be
#          running).
#    4 = Use CommTax21 to validate the ZIP code. (The Vertex DM must be
#          running).
#    5 = Use EZTax to validate the ZIP code. (The BillSoft DM must be
#          running).
#========================================================================
END
	,"pol_tax_valid", "- fm_cust_pol tax_valid $TAX_DM{'validate_zip'}"
	,"pol_currency_description",  <<END
#========================================================================
# currency
#
# Specifies the default account currency.
# 
# By default, Portal uses US dollars as the currency for accounts. 
# Portal checks to see if another currency was specified when the 
# account was created. If you don't specify the currency when you create
# customer accounts and you want to use a different currency for each
# account, change this entry.
#
# To use a different currency, remove the crosshatch (#) from the
# beginning  of the line for this entry and replace 840 with another
# currency code. For a list of currency codes, see pin_currency.h.
#========================================================================
END
	,"pol_currency", "- fm_cust_pol currency $CM{'currency'}"
	,"pol_minimum_threshold_description", <<END
#========================================================================
# minimum
#
# Specifies the minimum balance for retrieving accounts for collection.
#
# Use this entry to set a minimum threshold for the amount due on an
# account when searching for accounts for collection. Portal retrieves
# only those accounts with a pending receivable greater than the minimum
# that you specify. This improves collection performance by filtering out
# accounts whose balance due is zero or very small.
#
# You usually need to include this entry only if you use custom
# applications to process accounts for collection. If you use Portal
# billing applications, set the minimum threshold for collection in the
# configuration file for the billing utility, pin_billd.
#
# The minimum value is expressed in terms of the account currency.
# If you do business in more than one currency, set the minimum low
# enough to retrieve accounts in any of the currencies. For example,
# if you have accounts in both dollars and yen, then setting the minimum
# at 2.00 flags any accounts whose pending receivable is neither less
# than two dollars nor less than two yen.
#
# The default minimum threshold is 2.00.
#
# Note: This entry does NOT specify the amount below which you won't 
#       charge a customer. You set that amount in a billing policy,
#       PCM_OP_BILL_POL_PRE_COLLECT, which lets you specify minimum
#       values for each account currency. 
#========================================================================
END
	,"pol_minimum_threshold", "- fm_pymt_pol minimum $CM{'min_balance'}"
	,"pol_actg_dom_description",  <<END
#========================================================================
# actg_dom
#
# Specifies the day of the month when Portal should bill accounts.
#
# By default, Portal will use as a billing day either the day from 
# the actg_dom stanza (if it is specified), or the day on which the
# account was created.
#
# During account creation, it is possible to change this default by
# specifying a desirable billing day.
# In this case, the actg_dom stanza will not be used.
#  
# Portal may use as a billing day either days from 1 to 28, or all
# days from 1 to 31. 
# Please, see the documentation for the 31 billing day feature of how
# to change/set the appropriate behavior.
# 
#========================================================================
END
	,"pol_actg_dom", "# - fm_cust_pol actg_dom $CM{'acct_dom'}"
	,"pol_actg_type_description", <<END
#========================================================================
# actg_type
#
# Specifies whether to use open-item accounting.
#
# By default, Portal uses balance-forward accounting for billinfos. 
# Portal checks to see which accounting was specified when the billinfos
# was created. If you don't specify the accounting type when you create
# customer billinfos, and you want to use open-item accounting for all
# billinfos, set the below configuration entry to 1.
# If you want to use balance forward accounting set the below configuration
# entry to 2.
#========================================================================
END
	,"pol_actg_type", "- fm_cust_pol actg_type $CM{'acct_type'}"
	,"pol_bill_when_description", <<END
#========================================================================
# bill_when
#
# Specifies the number of accounting cycles before the customer is billed.
#
# By default, Portal bills for each accounting cycle. Portal checks
# to see if another billing cycle was specified when the account was
# created. If you don't specify the billing cycle when you create customer
# accounts and you want to specify a longer billing cycle for all accounts, 
# change this configuration entry.
#
# The default value is 1, specifying a one-month cycle. To change it,
# remove the crosshatch (#) from the start of the line for this entry and
# replace the "1" another number. For example, for quarterly billing, you
# would use "3" to specify a three-month cycle.
#========================================================================
END
	,"pol_bill_when", "- fm_cust_pol bill_when $BILLING{'when'}"
	,"pol_gl_segments_description", <<END
#========================================================================
# gl_segment
#
# Specifies the default general ledger segment for an account.
#
# Portal uses the general ledger segment when posting a GL report to
# identify the general ledger group to which the account belongs. If you
# do not specify the general ledger segment elsewhere when you create
# the account, Portal uses this default segment.
#
# The default is a period ("."), to indicate the root segment. You can
# change this default to another segment, such as ".myfirm".
#========================================================================
END
	,"pol_gl_segments", "- fm_cust_pol gl_segment $CM{'gl_segments'}"
	,"pol_cc_validate_description", <<END
#========================================================================
# cc_validate
#
# Specifies whether to validate customer credit cards during registration.
#
# The value for this entry can be:
#
#    0 = Portal doesn't validate the card.
#    1 = (Default) Portal validates the card.
#========================================================================
END
	,"pol_cc_validate", "- fm_pymt_pol cc_validate $CC_DM{'validate'}"
	,"pol_cc_revalidation_interval_description", <<END
#========================================================================
# cc_revalidation_interval
#
# Specifies the time limit, in seconds, for trying to revalidate a 
# customer's credit card during registration.
#
# Portal won't attempt to validate a credit card till
# specified time has not elapsed. The default
# time limit is 3600 seconds (60 minutes).
#========================================================================
END
	,"pol_cc_revalidation_interval", 
		"- fm_pymt_pol cc_revalidation_interval $CC_DM{'re_interval'}"
	,"pol_cc_collect_description", <<END
#========================================================================
# cc_collect
#
# Specifies whether to collect the current balance of an account during
# registration.
#
# The value for this entry can be:
#
#    0 = Don't charge the customer during registration.
#    1 = (Default) Charge the customer during registration.
#========================================================================
END
	,"pol_cc_collect", "- fm_pymt_pol cc_collect $CC_DM{'collect'}"
	,"fm_rate_0", <<END
#************************************************************************
# Configuration Entries for Rating Policies (fm_rate)
#************************************************************************
END

	,"fm_rate_taxware_db_description", <<END
#========================================================================
# taxware_db
#
# Specifies the database number of the Taxware database.
#
# If you use Taxware, enable this entry by removing the crosshatch (#)
# from the beginning of the line and verifying that the database number
# matches the number specified in the dm_pointer entry of the Taxware DM
# configuration file.
#========================================================================
END
	,"fm_rate_taxware_db", "#- fm_rate taxware_db $TAX_DM{'db_num'} /_tax_db 0"
        ,"rollover_zeroout_discounts_description", <<END
#========================================================================
# rollover_zeroout_discounts
#
# This is to support the Negative Discounts functionality 
# in the previous releases. Now the discount grants are all negative, 
# so if the bucket goes positive, we need a configuration to 
# zero-out the positive bucket. Rollover configuration for buckets gone 
# positive. 
#========================================================================
END
        ,"rollover_zeroout_discounts", "#- fm_rate rollover_zeroout_discounts 0"
	,"fm_rate_rate_vertex_db_description", <<END
#========================================================================
# vertex_db
#
# Specifies the database number of the Vertex database.
#
# If you use Vertex, enable this entry by removing the crosshatch (#)
# from the beginning of the line and verifying that the database number
# matches the number specified in the dm_pointer entry of the Vertex DM
# configuration file.
#========================================================================
END
	,"fm_rate_vertex_db", "#- fm_rate vertex_db $DM_VERTEX{'db_num'} /_tax_db 0"
	,"fm_rate_provider_loc_description", <<END
#========================================================================
# provider_loc
#
# Specifies the city, state, ZIP code, and country where you
# provide services to your customers.
#
# Taxware uses this information to find tax rates.
#========================================================================
END
	,"fm_rate_provider_loc", "- fm_rate_pol provider_loc $TAX_DM{'provider_loc'}"
	,"fm_subs_num_billing_cycles_description", <<END
#========================================================================
# num_billing_cycles
#
# Specifies the maximum number of billing cycles allowed between the current
# time and the backdated event time of a backdated operation.
#
# The default is 1 billing cycle.
#
#========================================================================
END
	,"fm_subs_num_billing_cycles", "- fm_subs num_billing_cycles 1"
	,"fm_subs_backdate_window_description", <<END
#========================================================================
# backdate_window
#
# Specifies the minimum time difference needed between the
# current time and the backdated event time for triggering automatic
# rerating.
#
# The default is 3600 seconds.
#
#========================================================================
END
	,"fm_subs_backdate_window", "- fm_subs backdate_window 3600"
        ,"fm_deal_purchase_for_closed_account_description", <<END
#========================================================================
# deal_purchase_for_closed_account
#
# Specifies whether an inactive or closed account or service can purchase a
# deal or not.
#
# The values for this entry can be:
# 0 = (Default) Do not allow purchase
# 1 = Allow purchase
#
#========================================================================
END
        ,"fm_deal_purchase_for_closed_account", "#fm_bill deal_purchase_for_closed_account 0"
	,"backdate_trigger_auto_rerate_description", <<END
#========================================================================
# backdate_trigger_auto_rerate
#
# Specifies whether to create auto-rerate job objects used by pin_rerate.
#
# The value for this entry can be:
#
#    0 = (Default) The /job/rerate object is not automatically created
#           for backdated actions that could cause the need for rerating
#    1 = The /job/rerate object is automatically created.The application 
#          pin_rerate can look for these objects and use them to determine  
#          which events need rerating and how far back to go.
#=======================================================================
END
	,"backdate_trigger_auto_rerate", "- fm_subs backdate_trigger_auto_rerate 0"
	,"keep_cancelled_products_or_discounts_description", <<END
#========================================================================
# keep_cancelled_products_or_discounts
#
# Specifies whether to keep canceled products and discounts
#
# The value for this entry can be:
# 1 = (Default) Keeps the canceled products and discounts
# 0 = Deletes the canceled products and discounts. If the canceled products 
#     and discounts are deleted, then rerating will not work. 
#
#========================================================================
END
	,"keep_cancelled_products_or_discounts", "- fm_subscription_pol keep_cancelled_products_or_discounts 1"
	,"non_currency_mfuc_description", <<END
#========================================================================
# non_currency_mfuc
#
# Aggregation counter for Monthly Fee and Usage 
#
# Default value of MFUC is configured as 1000097
#
#========================================================================
END
	,"non_currency_mfuc", "#- fm_subscription non_currency_mfuc 1000097"
	,"non_currency_cdc_description", <<END
#========================================================================
# non_currency_cdc
#
# Aggregation counter for Contract Days for Cycle fee discounts 
#
# Default value of CDC is configured as 1000099
#
#========================================================================
END
	,"non_currency_cdc", "#- fm_subscription non_currency_cdc 1000099"
	,"non_curr_cdcd_description", <<END
#========================================================================
# non_curr_cdcd
#
# Aggregation counter for Contract Days for Billing Time Discount 
#
# Default value of CDCD is configured as 1000100
#
#========================================================================
END
	,"non_curr_cdcd", "#- fm_subscription non_curr_cdcd 1000100"
	,"time_stamp_cdc_description", <<END
#========================================================================
# time_stamp_cdc
#
# Parameter that decides whether the day on which the service was reactivated
# be counted to increment contract days 
#
# Default value of time_stamp_cdc is configured as 1
#
#========================================================================
END
	,"time_stamp_cdc", "#- fm_subscription time_stamp_cdc 1"
	,"cdc_line_create_day_include_description", <<END
#========================================================================
# cdc_line_create_day_include
#
# Parameter that decides whether the day on which the Line was created be counted
# to increment contract days
#
# Default value of cdc_line_create_day_include is configured as 1
#
#========================================================================
END
	,"cdc_line_create_day_include", "#- fm_subscription cdc_line_create_day_include 1"
	,"cdc_line_cancel_day_include_description", <<END
#========================================================================
# cdc_line_cancel_day_include
#
# Parameter that decides whether the day on which the Line was created be counted 
# to decrement contract days
#
# Default value of line_cancel_day_include is configured as 1
#
#========================================================================
END
	,"cdc_line_cancel_day_include", "#- fm_subscription cdc_line_cancel_day_include 1"	
	,"balance_coordinator_description", <<END
#========================================================================
# balance_coordinator
# 
# This configuration enables Balance management FMs to work with the 
# transient /reservation_list object incase of Timos based Prepaid implementation. 
# When DM Timos is used in the Prepaid implementation, AAA 
# processing flow creates and manage the /reservation_list object for the given 
# /balance_group in Timos memory for the low latency requirements. In this case, 
# all the balance retrieval opcodes will work on the /balance_group and 
# /reservation_list objects to calculate the subscriber balance. 
# This configuration entry decides the Balance retrieval opcodes to work with 
# only 
# /balance_group or to include the /reservation_list while processing. 
# 
# When CM is connected to DM Oracle directly, then the balance_coordinator 
# entry in CM pin.conf should be set to 1. 
# 
# This variable should be set as follows 
# 
# CM connects to DM_TIMOS      - 0 - Balances opcodes will work with the 
# 				     /balance_group 
#                                    and /reservation_list objects.   
# CM connects to DM ORACLE     - 1 - Balances opcode will not work with the 
# 				     /reservation_list object. 
#=======================================================================
END
	,"balance_coordinator", "#- fm_bal balance_coordinator 1"

	,"cm_zcache_0",   <<END
#************************************************************************
# Configuration Entry for CM Cache File
#************************************************************************
#
#========================================================================
# permissioning_0
#
# This entry is reserved for Portal. DO NOT change it.
#========================================================================
END
        ,"permissioning_0", <<END
#************************************************************************
# Permissioning-Related Configuration Entries
#************************************************************************
END
        ,"permissioning_scoping_description", <<END
#========================================================================
# enforce_scoping
#
# Enables or disables limits on data access, based on the billing
# group of the associated account data. This option is used primarily 
# for branding.
#
# 0 - to disable branding 
# 1 - to enable branding 
#
#========================================================================
END
        ,"permissioning_scoping", " - cm enforce_scoping $CM{'enforce_scoping'}"
	,"primary_db_description", <<END
#========================================================================
# primary_db
#
# Denotes which database is the primary database.
#
# Use this entry in conjunction with the multi_db entry below.
#========================================================================
END
        ,"primary_db", "# - cm primary_db $DM{'db_num'} / 0"
	,"multi_db_description", <<END
#========================================================================
# multi_db
#
# Specifies whether the option for multiple databases was selected during
# installation.
#
# The value for this entry can be:
#
#    0 = The multidatabase option was not selected.
#    1 = The multidatabase option was selected.
#
# DO NOT edit this value.
#========================================================================
END
	,"multi_db", "- cm multi_db 0"
	,"cm_zcache_datafile_description",  <<END
#========================================================================
# cm_data_file
#
# Specifies the name and location of the shared memory file that caches
# some global information for the CM to improve performance.
# 
# If this file doesn't exist, Portal creates it when the CM starts.
#
# If you add the optional parameter %d to the entry, Portal creates a
# new cache file each time the CM starts, and includes the process ID of
# the CM as the filename extension. Use this option if you run more than
# one CM on a single computer and they use the same configuration file.
# Each CM creates a shared memory file identified by its process ID.
#========================================================================
END
	,"cm_zcache_datafile", "- cm cm_data_file \$\{PIN_LOG_DIR\}/cm/cm.data.%d" 
	,"event_cache_description", <<END
#========================================================================
# event_cache
#
# Enables or disables the event cache for the PIN_FLD_BAL_IMPACTS array.
# 
# You can save the cache space for invoicing by turning off this entry.
# The value for this entry can be:
#
#    0 = Disable event cache.
#    1 = (Default) Enable event cache.
#
#========================================================================
END
        ,"event_cache", "- fm_inv event_cache 1"
        ,"show_rerate_details_description", <<END
#========================================================================
# show_rerate_details
#
# Specifies whether to display shadow adjustments
# due to re-rating, in the invoice.
#
# By default we keep all the shadow adjustments that were generated
# due to re-rating.
# If this entry is set to 1, re-rated events which have RERATE_OBJ set
# will be dropped from the invoice details.
# Any shadow adjustment e.g event
# adjustment before billing will create a shadow event which still remains
# in the invoice details.
#
#    0 = (Default) Include the shadow events for rerated events in the invoice.
#    1 =  Drop the shadow events for rerated events in the invoice.
# 
#========================================================================
END
        ,"show_rerate_details", "- fm_inv_pol show_rerate_details 0"
        ,"inv_item_fetch_size_description", <<END
#========================================================================
# inv_item_fetch_size
#
# Size used for step search while searching items
# 
# This value can be changed as per the required number
# of items to be searched                                                       
#  
# Default Value is 10000
#========================================================================
END
        ,"inv_item_fetch_size", "- fm_inv inv_item_fetch_size 10000"
        ,"inv_event_fetch_size_description", <<END
#========================================================================
# inv_event_fetch_size
#
# Size used for step search while searching events
# 
# This value can be changed as per the required number
# of events to be searched                                                       
#  
# Default Value is 10000
#========================================================================
END
        ,"inv_event_fetch_size", "- fm_inv inv_event_fetch_size 10000"         
	,"pol_zonemap_update_interval_description", <<END
#======================================================================
# zonemap_update_interval
#
# Specifies an interval for revising the zone map, to tune performance.
#
# Portal periodically updates the zone map from the database, if any
# changes have occurred during the specified interval. This entry sets
# a timer for that interval. The default value is 3600 seconds (1 hour).
#======================================================================
END
    ,"pol_zonemap_update_interval_template", "- fm_zonemap_pol update_interval 3600"
	,"pol_html_template_description", <<END
#========================================================================
# html_template
#
# Specifies which template to use to generate invoices.
#
# This option specifies which template, in /config/invoice_templates, the
# PCM_OP_INV_POL_FORMAT_INVOICE_HTML opcode uses to generate invoices.
# You can create your own template in the configuration object and change
# 101 to your POID.
#
# Note: If you are setting up brand-specific invoice templates, you should
#       disable this entry by typing a crosshatch (#) at the start of its
#       line. Existence of this entry overrides the brand-specific invoice
#       templates, so any invoice template pointed to by this entry will be
#       used for all brands.
#========================================================================
END
  ,"pol_html_template", "- fm_inv_pol html_template $DM{'db_num'} /config/invoice_templates 101"
	,"pol_service_centric_invoice_description", <<END
#========================================================================
# service_centric_invoice
#
# Enables or disables the service-centric invoice feature.
#
# The value for this entry can be:
#
#    0 = (Default) Disable the feature.
#    1 = Enable the feature, so the HTML invoice will be seen to be
#          grouped by service instances.
#========================================================================
END
  ,"pol_service_centric_invoice", "- fm_inv_pol service_centric_invoice 0"
  ,"cm03_configpol01_01", <<END
#************************************************************************
# Configuration Entries for CVV & CID Credit Card  
#************************************************************************
END
  ,"cm03_configpol01_02_cvv2_required_description", <<END
#========================================================================
# cvv2_required 
#
# For Paymentech credit-card processor users, specifies whether 
# to require credit-card verification (CVV) data for Visa card
# transactions, as a method of fraud prevention. 
# 
# The value for this entry can be:
#
#    0 = (Default) Do not require CVV data.
#    1 = Require CVV data.
#
# Note: Until the end of 1999, cards could be issued without 
#       this information.
#========================================================================
END
  ,"cm03_configpol01_02_cvv2_required","- fm_pymt_pol cvv2_required 0"
  ,"cm03_configpol01_03_cid_required_description", <<END
#========================================================================
# cid_required 
#
# For Paymentech credit-card processor users, specifies whether to
# require credit-card verification (CID) data for American Express 
# card transactions, as a method of fraud prevention. 
# 
# The value for this entry can be:
#
#    0 = (Default) Do not require CID data.
#    1 = Require CID data.
#========================================================================
END
  ,"cm03_configpol01_03_cid_required","- fm_pymt_pol cid_required 0",
        ,"cm_data_dictionary_cache_description", <<END
#========================================================================
# cm_data_dictionary_cache
#
# Specifies attributes of the data-dictionary cache. This cache it utilized
# for branding purposes, and is filled as needed with the read, write and 
# modify settings for each storable class, thus allowing the cm to police 
# writes appropriately.
#
# The default settings are usually adequate, but you can change them by
# manipulating the values below. The values are the defaults, and in order
# represent [number of entries], [cache size], [hash size]
#
# Note: This cache cannot be disabled. Setting entries to zero will cause the
#       cm to fail during startup.
#
# Note: This entry will be read and the values are validated only if   
#       enforce_scoping is set to 1. 
#
#
# Note: For changes to take effect, the CM must be restarted
#========================================================================
END
	,"cm_data_dictionary_cache",  
"- cm_cache cm_data_dictionary_cache 500, 524288, 32"
        ,"fm_utils_data_dictionary_cache_description", <<END
#========================================================================
# fm_utils_data_dictionary_cache
#
# Specifies attributes of the data-dictionary cache. This cache is utilized
# by fm_utils to cache the data dictionary for lookups by the other fms.
#
# The default settings are usually adequate, but you can change them by
# manipulating the values below. The values are the defaults, and in order
# represent [number of entries], [cache size], [hash size]
#
# Note: Setting either the cache size, or number of entries to 0 (zero)
#       effectively disables the data dictionary cache. This can degrade
#       performance.
#
# Note: For changes to take effect, the CM must be restarted
#========================================================================
END
	,"fm_utils_data_dictionary_cache",  
"- cm_cache fm_utils_data_dictionary_cache $CM{'dd_cache_num_entries'}, $CM{'dd_cache_size'}, 32"
	,"fm_utils_gal_srvc_profile_cache_description", <<END
#========================================================================
# fm_utils_gal_srvc_profile_cache
#
# Specifies attributes of the service profile cache. 
#
# The default settings are usually adequate, but you can change them by
# manipulating the values below. The values are the defaults, and in order
# represent [number of entries], [cache size], [hash size]
#
# Note: For changes to take effect, the CM must be restarted
#========================================================================
END
	 ,"fm_utils_gal_srvc_profile_cache",
"- cm_cache fm_utils_gal_srvc_profile_cache 100, 1048576, 13"
	,"fm_utils_content_srvc_profile_cache_description", <<END
#========================================================================
# fm_utils_content_srvc_profile_cache
#
# Specifies attributes of the content service profile cache
#
# The default settings are usually adequate, but you can change them by
# manipulating the values below. The values are the defaults, and in order
# represent [number of entries], [cache size], [hash size]
#
# Note: For changes to take effect, the CM must be restarted
#========================================================================
END
	 ,"fm_utils_content_srvc_profile_cache",
"- cm_cache fm_utils_content_srvc_profile_cache 100, 1048576, 13"
	,"cache_references_at_start_description", <<END
#========================================================================
# cache_references_at_start
#
# Specifies whether to store objects referenced by price objects
# in memory in the CM cache when the CM starts. Objects referenced
# by price objects include BEIDs, GLIDs, tax suppliers, 
# event types, service types, and RUMs. 
#
#
# The value for this entry can be:
#
#    0 = The CM caches objects that are referenced by price objects 
#        in the CM cache every time a price list is committed. 
#         
#        In a production system where you rarely modify your price
#        list, set the flag to 0. This reserves the CM cache
#        for other uses and eliminates the need to restart the
#        CM to update the cache if you change the price list. 
#         
#    1 = (Default) The CM caches objects that are referenced by price 
#         objects one time when the CM starts. 
#
#        In a test environment where you modify your price list
#        often, set the flag to 1. This makes saving the  
#        price list faster since there is no need to load price 
#        reference objects every time you commit the price list
#        to the database. However, you must restart the CM after
#        your price list changes are committed. 
#
# Important: The objects that are referenced by price objects are 
#            created every time the CM starts. If these objects are 
#            changed in the database, the CM must be restarted to 
#            create the new information to place into the cache. 
#
#========================================================================
END
	 ,"cache_references_at_start",
"- fm_price cache_references_at_start  1"
	,"log_price_change_event_description", <<END
#========================================================================
# log_price_change_event
#
# Specifies event creation and logging for price object changes.
#
# Price object changes include changes to products, deals, and 
# plans. Logging such events creates an audit trail that is  
# useful if you need to look up previous versions of a price
# object. 
#
# The value for this entry can be:
#
#    0 = (Default) Do not create events when price object changes 
#        are made, thus saving storage space.
#    1 = Create and log an event for each changed price object.
#========================================================================
END
	 ,"log_price_change_event",
"- fm_price log_price_change_event  0"
	,"rate_change_description", <<END
#========================================================================
# rate_change
#
# Enables or disables the enhanced rate change management feature.
# 
# If this feature is enabled then rate changes for cycle events
# in the middle of the cycle will be handled according to old and
# new rates prorated. If disabled only the old rate will be applied
#
#    0 = (Default) Disable enhanced rate change management feature.
#    1 = Enable enhanced rate change management feature.
#
#========================================================================
END
        ,"rate_change", "- fm_subscription rate_change 0"
	,"non_currency_linecount_description", <<END
#========================================================================
# non_currency_linecount
#
# Aggregation counter for number of lines
#
#    Default value of  linecount (lc) is configured as  1000101.
#
#========================================================================
END
        ,"non_currency_linecount", "#- fm_subscription non_currency_lc 1000101"
	,"fm_price_prod_provisioning_cache_description", <<END
#========================================================================
# fm_price_prod_provisioning_cache
#
# Specifies attributes of the CM cache for the size of product  
# provisioning tags.
#
# This entry is required because provisioning tags are not 
# placed in the CM cache when the CM starts.
#
# Important: If this entry is missing, the CM cannot start 
#            and an error is logged in the cm.pinlog file. 
#
# The default settings are usually adequate, but you can change 
# them by editing the values below. For changes to take effect, 
# the CM must be restarted.
#
#- cm_cache fm_price_prod_provisioning_cache [number of entries]
#                          [cache size]  [hash size]
# 
# [number of entries] = the number of entries in the cache
#                       for product provisioning tags. The 
#                       default is 100.
#        [cache size] = the memory in bytes of the cache  
#                       for product provisioning tags. The 
#                       default is 102400.
#         [hash size] = the number of buckets for product 
#                       provisioning tags (used in the 
#                       hashing algorithm). The default is 13.
#
#========================================================================
END
	 ,"fm_price_prod_provisioning_cache",
"- cm_cache fm_price_prod_provisioning_cache 100, 102400, 13"
	,"fm_price_cache_beid_description", <<END
#========================================================================
# fm_price_cache_beid
#
# Specifies attributes of the CM cache for the size of beid.
#
# This entry is required in order to place resources and
# and rules into the cache when the CM starts.
#
# Important: If this entry is missing, the CM cannot start
#            and an error is logged in the cm.pinlog file.
#
# The default settings are usually adequate, but you can change
# them by editing the values below. For changes to take effect,
# the CM must be restarted.
#
#- cm_cache fm_price_cache_beid [number of entries]
#                          [cache size]  [hash size]
#
# [number of entries] = the number of entries in the cache
#                       for beid rules. The
#                       default is 200.
#        [cache size] = the memory in bytes of the cache
#                       for beid rules . The
#                       default is 524228.
#         [hash size] = the number of buckets for beid
#                       rules  (used in the
#                       hashing algorithm). The default is 32.
#
#========================================================================
END
	 ,"fm_price_cache_beid",
"- cm_cache fm_price_cache_beid 200, 524288, 32"
	,"propagate_discount_description",<<END
#========================================================================
# Enable immediate propagation of shared discount
# when a new discount is added/deleted to the group
# or a member subscribes/unsubscribes to the group.
# By default, it is disabled. Set the value to '1'
# to enable.
#========================================================================
END
,"propagate_discount", "- fm_subscription propagate_discount 0"
        ,"event_fetch_size_description", <<END
#========================================================================
# event_fetch_size
#
# Size used for step search while searching events in 
# rerating/rebilling
# 
# This value can be changed as per the required number
# of events to be searched                                                       
#  
# Default Value is 10000
#========================================================================
END
	,"event_fetch_size", 
"#- fm_subscription event_fetch_size 10000"         
        ,"inv_perf_features_description", <<END
#========================================================================
# inv_perf_features
#
# This entry is required to retain the balance_impact array in an event
#
# Default Value is 0x00000010
#========================================================================
END
        ,"inv_perf_features",
"- fm_inv inv_perf_features 0x00000010"
);


%DDEBIT_CM_ENTRIES = (
  "cm04_dd00", <<END
#************************************************************************
# Configuration Entries for Direct Debit
#************************************************************************
END
  ,"cm04_dd02_dd_validate_description",<<END
#========================================================================
# dd_validate
#
# Specifies whether to validate customers� direct-debit accounts
# during registration.
#
# The value for this entry can be:
#
#    0 = Do not validate the account.
#    1 = (Default) Validate the account.
#========================================================================
END
  ,"cm04_dd02_dd_validate", 
"- fm_pymt_pol dd_validate $CC_DM{'validate'}"
  ,"cm04_dd03_dd_revalidation_interval_description",<<END
#========================================================================
# dd_revalidation_interval
#
# Specifies the time limit, in seconds, before Portal tries to
# revalidate a customer's direct-debit account during registration.
#
# Portal won't attempt to validate an account till 
# the specified time hasn't elapsed. The default time limit is
# 3600 seconds (1 hour). 
#========================================================================
END
  ,"cm04_dd03_dd_revalidation_interval", 
"- fm_pymt_pol dd_revalidation_interval $CC_DM{'re_interval'}"
  ,"cm04_dd04_dd_collect_description",<<END
#========================================================================
# dd_collect
#
# Specifies whether to collect the current balance of each account
# during registration.
#
# The value for this entry can be:
#
#    0 = Do not charge the customer.
#    1 = (Default) Charge the customer for the current balance.
#========================================================================
END
  ,"cm04_dd04_dd_collect", "- fm_pymt_pol dd_collect $CC_DM{'collect'}"
 );

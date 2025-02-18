# $Header: install_vob/install_odc/Server/ISMP/Portal_Base/scripts/pin_cnf_pin_state_change.pl /cgbubrm_7.5.0.portalbase/1 2012/06/22 07:11:28 hsnagpal Exp $
#
# pin_cnf_state_change.pl
# 
# Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      pin_cnf_state_change.pl - <one-line expansion of the name>
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    ajena       06/14/12 - Creation
#
$PIN_STATE_CHANGE_PINCONF_HEADER = <<END
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

%PIN_STATE_CHANGE_PINCONF_ENTRIES = (
	"cm_ptr_0_description", <<END
#========================================================================
# cm_ptr
# 
# Specifies a pointer to the CM or CMMP. 
#
# Use a separate entry for each CM or CMMP. If testnap can't find the
# first CM or CMMP, it looks for the next in the list.
#
# Each entry includes three values:
# 
#     <protocol> = "ip", for this release
#     <host>     = the name or IP address of the computer running the
#                    CM or CMMP
#     <port>     = the TCP port number of the CM or CMMP on this computer
#
# The port number should match a corresponding cm_ports entry with
# the same port number in the CM or CMMP configuration file. The 
# default, 11960, is a commonly specified port for the CM or CMMP.
#========================================================================
END
	,"cm_ptr_0", "- nap cm_ptr ip $CM{'hostname'} $CM{'port'}"
	,"cm_ptr_userid_description", <<END
#========================================================================
# userid
#
# Specifies the database number and service type for the Portal
# database. 
#
# The CM uses the database number to identify the Portal database 
# and to connect to the correct Data Manager. For connections that don't
# require a login name and password, the CM also passes the service
# type to the database.
#
# The database number, in the form 0.0.0.N, is the number assigned to 
# your Portal database when you installed the system. The default
# is 0.0.0.1.
#
# The service type is /service/pcm_client and the ID is 1.
# DO NOT change these values.
#========================================================================
END
	,"cm_ptr_userid", "- - userid $DM{'db_num'} /service/pcm_client 1"
	,"cm_ptr_login_description", <<END
#========================================================================
# login_type
#
# Specifies whether the login name and password are required.
#
# The value for this entry can be:
#
#    0 = Only a user ID is required.
#    1 = (Default) Both a name and a password are required.
#
# By default, CMs require a user login and password when requesting an open
# context using PCM_CONTEXT_OPEN. However, you can remove this authentication
# requirement by configuring the CM with a cm_login_module of
# cm_login_null.so
#========================================================================
END
	,"cm_ptr_login", "- nap login_type 1"
	,"cm_ptr_login_name_description", <<END
#========================================================================
# login_name
#
# Specifies the login name to use when testnap connects to the CM. 
#========================================================================
END
	,"cm_ptr_login_name", "- nap login_name root.$DM{'db_num'}"
	,"cm_ptr_login_pw_description", <<END
#========================================================================
# login_pw
#
# Specifies the password to use when testnap connects to the CM.
#========================================================================
END
	,"cm_ptr_login_pw", "- nap login_pw   &aes|08|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5D40C305EDF3D77DF111AAB8F781E92122"
	,"pin_state_change_loglevel_description", <<END
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
	,"pin_state_change_loglevel", "- pin_state_change loglevel 2"
	,"state_change_performance_description", <<END
#========================================================================
# Performance Entries
#
# Specify how the pin_state_change process the data.
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
# application, replace the generic name "pin_state_change" with the specific
# name of the application. For example, you might have these entries:
#
#    - pin_collect      per_batch    240
#    - pin_bill_accts   per_batch   3000
#
# For a complete explanation of setting these variables for best
# performance, see the online document "Portal Configuration
# and Tuning Guide."
#
# Note: The invoice-generation application doesn't use the pin_state_change
#       default values. You must set the values for that application
#       independently. See the guidelines for those entries elsewhere
#       in this configuration file.
#========================================================================
END
	,"state_change_performance" 
,"- pin_state_change      children        5
- pin_state_change      per_batch       1000
- pin_state_change      fetch_size      5000"
	,"pin_state_change_mta_description", <<END
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
	,"pin_state_change_mta", "- pin_mta       children        1
- pin_mta       per_batch       500
- pin_mta       per_step        1000
- pin_mta       fetch_size      5000"
	,"multi_db_description", <<END
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
	,"multi_db", "- pin_mta multi_db 0"
);

%PIN_MTA_ENTRIES =(
        "cm_ptr_logfile_description", <<END
#========================================================================
# logfile
#
# Specifies the path to the log file for the sample application
#========================================================================
END
        ,"cm_ptr_logfile", "- pin_mta logfile \$\{PIN_LOG_DIR\}/pin_state_change/pin_mta.pinlog"
	,"cm_ptr_pin_virtual_time_description",<<END
#=======================================================================
# ptr_virtual_time
#
# Enables the use of pin_virtual_time to advance Portal time, and
# specifies the shared file for use by all Portal mangers.
#
# The entry has 2 values
#
# #/Empty       to disable / enable pin_virtual_time in all pin.conf files
#               default = #     (disable)
#
# <filepath>    location and name of the pin_virtual_time file shared by all Portal managers.
#               default = ${PIN_HOME}/lib/pin_virtual_time_file
#
#=======================================================================
END
	,"cm_ptr_pin_virtual_time","- - pin_virtual_time \$\{PIN_HOME\}/lib/pin_virtual_time_file"
);




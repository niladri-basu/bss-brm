#=============================================================
#  @(#) % %
# 
# Copyright (c) 2006, 2009, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
#==============================================================


$DM_PROV_TELCO_PINCONF_HEADER  =  <<END 
#************************************************************************
# Configuration File for PROVISIONING DM
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

%DM_PROV_TELCO_PINCONF_ENTRIES = (

"dm_provision_prov_ptr_description", <<END
#========================================================================
# dm_provision_prov_ptr
#
# Specifies address of the agent which publishes the service order
#
# Each prov_ptr includes two values:
#
#    -- the IP address or host name of the agent computer
#    -- the port number of the agent
#========================================================================
END
	, "dm_provision_prov_ptr", "- dm_provision prov_ptr ip $DM_PROV_TELCO{'hostname'} $DM_PROV_TELCO{'infranet_agent_port'}"

,"dm_provision_prov_timeout_description", <<END
#======================================================================
# dm_provision_prov_timeout
#
# Specifies a timeout when waiting for responses from Infranet
# agent.  The value is specified in seconds.  0 means no timeout.
# This timeout is mostly useful for "confirmed" orders, where
# the response is not returned until the order has been completely
# processed.
#
#======================================================================
END
	, "dm_provision_prov_timeout", "- dm_provision prov_timeout 20"

,"dm_provision_connect_retries_description", <<END
#======================================================================
# dm_provision_connect_retries
#**********************************************************************
# Reconnecting to Infranet agent
#**********************************************************************
# Specifies the number of times dm_provision tries to retry to
# connect to the Infranet agent when connecting fails.  Before
# each retry, dm_provision waits the interval specified in
# connect_retry_interval.
#
#======================================================================
END
	, "dm_provision_connect_retries", "- dm_provision connect_retries 1"

,"dm_provision_connect_retry_interval_description", <<END
#======================================================================
# dm_provision_connect_retry_interval
#
# Specifies how many seconds to wait before retrying to connect
# to the Infranet agent when connecting fails.  0 means no wait.
#
#======================================================================
END
	, "dm_provision_connect_retry_interval", "- dm_provision connect_retry_interval 2"

,"dm_provision_loglevel_description", <<END
#========================================================================
# dm_provision_loglevel
#
# Specifies how much information the dm_prov_telco logs.
#
# The value for this entry can be:
#
#    0 = no logging
#    1 = (Default) log error messages only
#    2 = log error messages and warnings
#    3 = log error, warning, and debugging messages
#========================================================================
END
	, "dm_provision_loglevel", "- dm loglevel 1"

,"dm_provision_commit_at_prep_description", <<END
#========================================================================
# dm_provision_commit_at_prep
#
# If this entry is set to 1 then dm_prov_telco will commit the BRM
# transaction AFTER publishing service order to the agent. If it is set to 0
# then dm_prov_telco will commit the BRM transaction BEFORE publishing service
# order # to the agent. Default is 0.
#========================================================================
END
	, "dm_provision_commit_at_prep", "- dm_provision commit_at_prep 0"

);	

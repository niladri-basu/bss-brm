#=======================================================================
#  @(#)%Portal Version: pin_cnf_eai.pl:InstallVelocityInt:4:2005-Mar-25 18:13:01 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$EAI_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for the EAI Framework
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


%EAI_PINCONF_ENTRIES = (
  "dm_plugin_name_description", <<END
#=========================================================================
# dm_plugin_name
#
# Specifies a pointer to a shared library that contains the code that
# implements the required interfaces of dm_eai, as defined in
# dm_eai_plugin.h. Replace the entry with the name of the implemented
# plugin.
#========================================================================
END
 , "dm_plugin_name", "- dm plugin_name ./plugin_xml\$\{LIBRARYEXTENSION\}"

 , "dm_loglevel_description", <<END
#========================================================================
# dm_loglevel
#
# Specifies how much information the dm_eai logs.
# 
# The value for this entry can be:
#
#    0 = no logging
#    1 = (Default) log error messages only
#    2 = log error messages and warnings
#    3 = log error, warning, and debugging messages
#========================================================================
END
  , "dm_loglevel", "- dm loglevel $EAI{'log_level'}"
);

%DM_HTTP_PINCONF_ENTRIES = (
  "dm_http_agent_description", <<END  
#======================================================================
# Communication with HTTP Agent.
#========================================================================
# dm_http_agent
#
# dm_http_agent
#
# Specifies a pointer to the http agent.
#
# The entry includes three values:
#
#     <protocol> = "ip", for this release
#     <host>     = the name or IP address of the computer running the
#                    agent
#     <port>     = the TCP port number of the agent on
#                    this computer
#
#========================================================================
END
 , "dm_http_agent", "#- dm dm_http_agent ip __AGENT_HOST__ <<PIN_AGENT_PORT>>" 
 , "dm_http_url_description", <<END
#========================================================================
# dm_http_url
#
#
# Specifies complete URI of the HTTP server. This is optional.
#========================================================================
END
  , "dm_http_url", "#- dm dm_http_url __AGENT_URL__"
  , "dm_http_delim_crlf_description", <<END
#========================================================================
# dm_http_delim_crlf
#
# Specifies the delimiter used in the header. This is HTTP server 
# dependent.
# The value can be 0 for \\n 
#              and 1 for \\r\\n. 
# The default value is 0.
#========================================================================
END
  , "dm_http_delim_crlf", "#- dm dm_http_delim_crlf 0"
   , "dm_http_100_continue_description", <<END
#========================================================================
# dm_http_100_continue
#
# Specifies that the dm will wait for and read a 100 Continue response. 
# Some servers send 100-Continue response even if not requested to do so.
# 
# The value can be 0 for not waiting for 100-Continue
#              and 1 for waiting for 100-Continue
# The default value is 0.
#========================================================================
END
  , "dm_http_100_continue", "#- dm dm_http_100_continue 0"
   , "dm_http_read_success_description", <<END
#========================================================================
# dm_http_read_success
#
# Specifies that the dm will wait for and read a 20x success response.
# 
# The value can be 0 for not waiting for success response
#              and 1 for waiting for success response
# The default value is 0.
#========================================================================
END
  , "dm_http_read_success", "#- dm dm_http_read_success 0"
  , "dm_http_header_send_host_name_description", <<END
#========================================================================
# dm_http_header_send_host_name
#
# Specifies that the dm will send hostname as part of header.
# 
# The value can be 0 for not sending
#              and 1 for sending
# The default value is 0.
#========================================================================
END
  , "dm_http_header_send_host_name", "#- dm dm_http_header_send_host_name 0"
);


%EAI_CM_ENTRIES = (
 "enable_publish_description", <<END
#========================================================================
# enable_eai_publish
#
# Enables publishing of business events using the EAI Framework.
#
# The value for this entry can be:
#
#    0 = (Default) Portal doesn't publish the business events.
#    1 = Portal publishes the business events through the EAI framework.
#========================================================================
END
  , "enable_publish", "- fm_publish enable_publish $EAI{'enable_publish'}"

  , "em_group_description", <<END
#========================================================================
# em_eai_group
#
# Defines the member opcode in a group provided by the EAI Framework.  
#========================================================================
END
  , "em_group", "- cm em_group publish PCM_OP_PUBLISH_GEN_PAYLOAD"

  , "em_pointer_description", <<END
#========================================================================
# em_eai_pointer
#
# Specifies where to find the external manager that provides the opcode 
# for the EAI Framework.
#========================================================================
END
  , "em_pointer", "- cm em_pointer publish ip $EAI{'em_hostname'} $EAI{'em_port'}"

  , "fm_required_description", <<END
#========================================================================
# fm_eai_required
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
  , "fm_required", <<END
- cm fm_module \$\{PIN_HOME\}/lib/fm_publish\$\{LIBRARYEXTENSION\} fm_publish_config$FM_FUNCTION_SUFFIX - pin
END
);

%DM_EAI_CM_ENTRIES = (
 "dm_pointer_description", <<END
#========================================================================
# dm_eai_pointer
#
# Specifies where to find the EAI Framework Data Manager.
#========================================================================
END
  , "dm_pointer", "- cm dm_pointer $EAI{'db_num'} ip $EAI{'hostname'} $EAI{'port'}  # dm_eai"

);

%TRANSPOL_FM_PINCONF_ENTRIES = (

  "fm_trans_pol_fm_required_description", <<END
#========================================================================
# fm_trans_pol_fm_required
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
  , "fm_trans_pol_fm_required", <<END
- cm fm_module \$\{PIN_HOME\}/lib/fm_trans_pol\$\{LIBRARYEXTENSION\} fm_trans_pol_config$FM_FUNCTION_SUFFIX - pin
END
);

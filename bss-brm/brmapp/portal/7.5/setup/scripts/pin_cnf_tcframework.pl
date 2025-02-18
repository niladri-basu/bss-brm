#=============================================================
#  @(#) % %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
#==============================================================


$TCF_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Portal Telco Framework Module
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

%TCF_CM_PINCONF_ENTRIES = (

  "tcf_fm_module_description", <<END
#========================================================================
# tcf_fm_module
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
#=======================================================================
END
  , "tcf_fm_module", <<END
- cm fm_module \$\{PIN_HOME\}/lib/fm_tcf\$\{LIBRARYEXTENSION\} fm_tcf_config$FM_FUNCTION_SUFFIX fm_tcf_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_tcf_pol\$\{LIBRARYEXTENSION\} fm_tcf_pol_config$FM_FUNCTION_SUFFIX - pin
END

 , "fm_tcf_simulate_agent_description", <<END
#========================================================================
# fm_tcf_simulate_agent
#
# In provisioning enabled environment, if provisioning needs to be simulated
# then this entry should be set to 1. By doing that service order will not be
# published to the agent. If this entry is set to 0 then service order will be
# published.
#
#=======================================================================
END
  , "fm_tcf_simulate_agent", <<END
- fm_tcf simulate_agent 1 
END

 , "fm_tcf_agent_return_description", <<END
#========================================================================
# fm_tcf_agent_return
#
# This is the value used for setting the provisioning status when
# provisioning is simulated.
#
#      0 - Provisioning is success (Default)
#      1 - Provisioning is Failed
#
#=======================================================================
END
  , "fm_tcf_agent_return", <<END
- fm_tcf agent_return 0
END

 , "fm_tcf_support_multiple_so_enabled_description", <<END
#========================================================================
# fm_tcf_support_multiple_so_enabled
#
# Entry for support_multiple_so
# Value  1 -> Enable multiple service order
# Value  0 or not configuring this entry -> Service order generation will be in sequence 
# (Original behaviour / Default Mode )
#
#=======================================================================
END
  , "fm_tcf_support_multiple_so_enabled", <<END
- fm_tcf support_multiple_so  0
END

 , "fm_tcf_provisioning_enabled_description", <<END
#========================================================================
# fm_tcf_provisioning_enabled
#
# Entry for Disabling Provisioning
#
#=======================================================================
END
  , "fm_tcf_provisioning_enabled", <<END
- fm_tcf provisioning_enabled  0
END

);

%PROVISIONING_CM_PINCONF_ENTRIES = (

	"dm_pointer_description", <<END
#========================================================================
# dm_provisioning_pointer
#
# Specifies where to find the Provisioning Data Manager.
#========================================================================
END
      , "dm_pointer", <<END
- cm dm_pointer $DM_PROV_TELCO{'db_num'} ip $DM_PROV_TELCO{'hostname'} $DM_PROV_TELCO{'port'}  # dm_prov_telco
END
	, "provisioning_db_no_description", <<END
#========================================================================
# provisioning_db_no
#
# Specifies the number of the database to which provisioning connects
# to, to send the Service Order.
#========================================================================
END
	, "provisioning_db_no", <<END
- fm_tcf prov_db $DM_PROV_TELCO{'db_num'} / 0
END
);

%PROVISIONING_FM_PINCONF_ENTRIES = (

  "provisioning_fm_required_description", <<END
#========================================================================
# provisioning_fm_required
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
  , "provisioning_fm_required", <<END
- cm fm_module \$\{PIN_HOME\}/lib/fm_prov\$\{LIBRARYEXTENSION\} fm_prov_config$FM_FUNCTION_SUFFIX fm_prov_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_prov_pol\$\{LIBRARYEXTENSION\} fm_prov_pol_config$FM_FUNCTION_SUFFIX - pin
END
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

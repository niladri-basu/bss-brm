#=============================================================
#  @(#) % %
# 
#    
# Copyright (c) 2005, 2010, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
#
#==============================================================

$ARA_FRAMEWORK_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Portal ARA_FRAMEWORK Manager Facilities Module
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

%ARA_FRAMEWORK_CM_PINCONF_ENTRIES = (
  "process_audit_manager_fm_required_description", <<END
#========================================================================
# Process_Audit_manager_fm_required
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
  , "process_audit_manager_fm_required", <<END
- cm fm_module \$\{PIN_HOME\}/lib/fm_process_audit\$\{LIBRARYEXTENSION\} fm_process_audit_config$FM_FUNCTION_SUFFIX fm_process_audit_init pin
- cm fm_module \$\{PIN_HOME\}/lib/fm_process_audit_pol_create\$\{LIBRARYEXTENSION\} fm_process_audit_pol_config$FM_FUNCTION_SUFFIX - pin
END
  ,"process_audit_db_no_description", <<END
#========================================================================
# Process_Audit_db_no
#
# Specifies the number of the database to which provisioning connects
# to, to send the Service Order.
#========================================================================
END
 , "process_audit_db_no", "- fm_process_audit primary_database $DM{'db_num'} / 0" 

  ,"writeoff_control_point_id_description", <<END
#========================================================================
# writeoff_control_point_id 
#
# For written-off EDRs, Revenue Assurance Manager collects the original 
# batch ID and the number of EDRs that were written off in the batch. 
# 
# This parameter specifies the control point ID to collect revenue 
# assurance data on written-off EDRs. For more details on control points, 
# refer to BRM documentation. 
# 
# Default value is CP_SuspenseWriteOff 
# This entry is mandatory
#========================================================================
END
 , "writeoff_control_point_id", "- fm_process_audit writeoff_control_point_id CP_SuspenseWriteOff" 

  ,"writeoff_batch_id_prefix_description", <<END
#========================================================================
# writeoff_batch_id_prefix 
#
# Specifies the prefix for batch id generated for each suspense writeoff action
#
# This is a optional, if not provided defaults to "WRITTENOFF_"
#========================================================================
END
 , "writeoff_batch_id_prefix", "- fm_process_audit writeoff_batch_id_prefix WRITTENOFF_" 
);



$RA_CHECK_THRESHOLDS_HEADER  =  <<END
#************************************************************************
# Configuration file for pin_ra_check_thresholds
#
# This configuration file is automatically installed and configured with
# default values during Infranet installation. You can edit this file to:
#   -- change the default values of the entries.
#   -- disable an entry by inserting a crosshatch (#) at the start of
#        the line.
#   -- enable a commented entry by removing the crosshatch (#).
#
# Before you make any changes to this file, save a backup copy.
#
# When editing this file, follow the instructions in each section.
# For more information on the general syntax of configuration entries,
# see "Reference Guide to Infranet Configuration Files" in the Infranet
# online documentation.
#************************************************************************
END
;

%RA_CHECK_THRESHOLDS_PINCONF_ENTRIES = (
  "logfile_description", <<END
#========================================================================
# logfile 
#
# Specifies the path to the log file for pin_ra_check_thresholds.
#
# You can enter any valid path.
#========================================================================
END
 , "logfile", "- pin_ra_check_thresholds logfile ./pin_ra_check_thresholds.pinlog" 
);

%RA_ENABLE_ERA_PINCONF_ENTRIES = (
  "pin_mta_enable_ara_description", <<END
#======================================================================
# enable_ara
#
# To enable ARA Feature
# The value for this entry can be:
#  -- 0: Disabled
#  -- 1: Enabled
#======================================================================
END
 ,"pin_mta_enable_ara", "- pin_mta enable_ara 0"
);

#======================================================================= 
# $Header: install_vob/install_odc/Server/ISMP/Portal_Base/scripts/pin_cnf_upgrade.pl /cgbubrm_7.5.0.portalbase/1 2012/09/17 02:32:16 ajena Exp $
#
# pin_cnf_upgrade.pl
# 
# Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved. 
#    This material is the confidential property of Oracle Corporation
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#========================================================================

$IPC_CM_PINCONF_HEADER  =  <<END
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

%IPC_CM_PINCONF_ENTRIES = (
        "fm_offer_profile_cache_description", <<END
#========================================================================
# fm_offer_profile_cache
#
# Specifies attributes of the CM cache for the size of offer_profiles
#
#
# Important: If this entry is missing, offer_profiles would not be fetched 
#            when static information is requested by GET_SUBSCRIBER_PROFILE.
#
# The default settings are usually adequate, but you can change
# them by editing the values below. For changes to take effect,
# the CM must be restarted.
#
#- cm_cache fm_offer_profile_cache [number of entries]
#                          [cache size]  [hash size]
#
# [number of entries] = the number of entries in the cache
#                       for offer_profiles. 
#        [cache size] = the memory in bytes of the cache
#                       for offer_profiles. 
#         [hash size] = the number of buckets for offer_profiles
#                       (used in the hashing algorithm). 
#
#========================================================================
END
         ,"fm_offer_profile_cache", "- cm_cache fm_offer_profile_cache 20, 102400, 13"
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
"- cm fm_module \$\{PIN_HOME\}/lib/fm_offer_profile\$\{LIBRARYEXTENSION\} fm_offer_profile_config$FM_FUNCTION_SUFFIX fm_offer_profile_init pin"
);
 

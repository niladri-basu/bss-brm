#=============================================================
#  @(#)%Portal Version: pin_cnf_ecr_pci.pl:PortalBase7.2PatchInt:2:2006-Feb-22 20:39:11 %
# 
# Copyright (c) 2006, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#=============================================================
$PIN_CRYPT_UPGRADE_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Portal with PIN_CRYPT_UPGRADE
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

%PIN_CRYPT_UPGRADE_PINCONF_ENTRIES= (

  "pin_crypt_upgrade_loglevel_description", <<END
#========================================================================
# Controller Logging Attributes
#
# Specifies how much information the applications log.
#
# The value for this entry can be:
#
#    0 = no logging
#    1 = (Default) log error messages only
#    2 = log error messages and warnings
#    3 = log error, warning, and debugging messages
#========================================================================
END
	,"pin_crypt_upgrade_loglevel", "- pin_crypt_upgrade loglevel $PIN_CRYPT_UPGRADE{'log_level'}"


  ,"pin_crypt_upgrade_logfile_description", <<END
#========================================================================
# Controller Logfile
#
# Specifies the full path to the log file used by this application.
#
# You can enter any valid path.
#========================================================================
END
	,"pin_crypt_upgrade_logfile", "- pin_crypt_upgrade logfile \$\{\PIN_LOG_DIR\}/pin_crypt_upgrade/pin_crypt_migrate.pinlog"

 


);

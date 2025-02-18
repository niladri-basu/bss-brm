#=======================================================================
#  @$Id: pin_cnf_load_config.pl /cgbubrm_main.portalbase/1 2011/05/25 18:11:32 meiyang Exp $
# 
# Copyright (c) 2005, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$LOAD_CONFIG_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for load config
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

%LOAD_CONFIG_PINCONF_ENTRIES = (

	"load_config_logfile_description", <<END
#======================================================================
# load_config_logfile
#
# Name and location of the log file used by this BRM process
#
#======================================================================
END
	,"load_config_logfile"
	,"- load_config logfile \$\{PIN_LOG_DIR\}/load_config/load_config.pinlog"
	,"load_config_loglevel_description", <<END
#======================================================================
# load_config_loglevel
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
	,"load_config_loglevel" 
	, "- load_config loglevel 2"
	,"load_config_validation_module_description", <<END
#======================================================================
# load_config_validation_module
#
#
# Required validation modules configuration entries.
#
# The entries below specify the required validation modules that are
# linked to the load_config application when it starts.  The modules
# required by load_config are included in this file when you install BRM.
# You may add more validation modules as needed. There is no need to
# specify the library extension for the validation module.
#
# Caution: DO NOT modify these entries unless you need to change the
#          location of the shared library.
#
#======================================================================
END
	,"load_config_validation_module", 
"- load_config validation_module libLoadValidFinancial LoadValidFinancial_init
- load_config validation_module libLoadValidRating LoadValidRating_init"

);
 

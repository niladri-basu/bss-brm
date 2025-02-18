#=======================================================================
#  @(#)%Portal Version: pin_cnf_batch_controller.pl:InstallVelocityInt:5:2005-May-04 22:09:02 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$BATCH_CONTROLLER_PINCONF_HEADER  = <<END
#************************************************************************
# Configuration File for the Sample Batch Handler application.
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


%BATCH_CONTROLLER_PINCONF_ENTRIES = (

	"sample_handler_logfile_description", <<END
#========================================================================
# sample_handler_logfile
#
# Specifies the full path to the log file for the Batch Controller.
#
# You can enter any valid path.
#========================================================================
END
	, "sample_handler_logfile", "- nap logfile \$\{PIN_HOME\}/apps/sample_handler/handler.pinlog"
);



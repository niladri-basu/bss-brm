#=============================================================
# Copyright (c) 2008, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#=============================================================
$PIN_LOAD_NOTIFICATION_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for credit_control
#************************************************************************
# Configuration file for Credit Control
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

%PIN_LOAD_NOTIFICATION_PINCONF_ENTRIES= (
"pin_credit_control_logfile_description", <<END
#========================================================================
# pin_credit_control_logfile
#
#This entry is used to set the log file name and location of load_notification_event utility
#========================================================================
END
        ,"pin_credit_control_logfile", "#- load_notification logfile \$\{\PIN_LOG_DIR\}/load_notification_event/load_notification.pinlog"

,"pin_credit_control_loglevel_description", <<END
#========================================================================
# loglevel
#
# How much information the applications should log.
#
#This entry is used to set the log level of load_notification_event utility
#
# The value for this entry can be:
#  -- 0: no logging
#  -- 1: log error messages only
#  -- 2: log error messages and warnings
#  -- 3: log error messages, warnings, and debugging messages
#========================================================================
END
        ,"pin_credit_control_loglevel", "-  load_notification loglevel 1"

);

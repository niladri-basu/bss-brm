#=============================================================
# Copyright (c) 2008, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#=============================================================
$PIN_UNLOCK_SERVICE_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for pin_unlock_service
#************************************************************************
# You use pin_unlock_service to unlock a locked service and reset the 
# user account associated with that service with a temporary password.
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

%PIN_UNLOCK_SERVICE_PINCONF_ENTRIES= (
"pin_unlock_service_logfile_description", <<END
#========================================================================
# pin_unlock_service_logfile
#
# Name and location of the log file used by this Portal process.
#========================================================================
END
        ,"pin_unlock_service_logfile", "- pin_unlock_service logfile \$\{\PIN_LOG_DIR\}/pin_unlock_service/pin_unlock_service.pinlog"

,"pin_unlock_service_loglevel_description", <<END
#========================================================================
# loglevel
#
# How much information the applications should log.
#
# The value for this entry can be:
#  -- 0: no logging
#  -- 1: log error messages only
#  -- 2: log error messages and warnings
#  -- 3: log error messages, warnings, and debugging messages
#========================================================================
END
        ,"pin_unlock_service_loglevel", "- pin_unlock_service loglevel 2"

);

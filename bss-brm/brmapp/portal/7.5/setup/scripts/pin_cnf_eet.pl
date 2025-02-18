#=======================================================================
#  @(#)%Portal Version: pin_cnf_eet.pl:PortalBase7.3.1Int:1:2007-Jun-21 21:31:54 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$EET_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for the EVENT EXTRACTION TOOL
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

%EET_PINCONF_ENTRIES = (
  "eet_logfile_description", <<END
#========================================================================
# eet_logfile
#
# Specifies the location of the Logfile
#
#========================================================================
END
 , "eet_logfile", "- pin_event_extract logfile \$\{PIN_LOG_DIR\}/pin_event_extract/pin_event_extract.pinlog"

 , "eet_loglevel_description", <<END
#========================================================================
# eet_loglevel
#
# Specifies how much information the Event Extraction Tool logs.
# 
# The value for this entry can be:
#
#    0 = no logging
#    1 = (Default) log error messages only
#    2 = log error messages and warnings
#    3 = log error, warning, and debugging messages
#========================================================================
END
  , "eet_loglevel", "- pin_event_extract loglevel $EVENT_EXTRACTION_TOOL{'loglevel'}"

  , "eet_filename_description", <<END
#========================================================================
# eet_filename
#
# CDR/EDR/IDR Format File Name
# 
# Format:
#  SOL42_<sender><recipient>.DAT
#  
#  <sender>     code for the sender of the file (e.g. D00D1)
#  <recipient>  code for the recipient of the file (e.g. SOL42)
#  
#  NOTE: If applicable, the appropriate sequence number will be  
#  appended to the file name.
#=========================================================================
END
  , "eet_filename", "- pin_event_extract filename $EVENT_EXTRACTION_TOOL{'filename'}"

  , "eet_UTC_Offset_description", <<END
#========================================================================
# eet_UTC_Offset
#
# UTC Time Offset - difference between local time and UTC time.
# 
# Example:
#  	Washington DC, USA   1000hrs 10/10/97
#  	UTC Time	1500hrs 10/10/97
#  	UTC Time Offset   = 10 - 15 = -0500
#  	Madrid, Spain        1600hrs 10/10/97
#  	UTC Time	1500hrs 10/10/97
#  	UTC Time Offset   = 16 - 15 = +0100
#========================================================================
END
  , "eet_UTC_Offset", "- pin_event_extract UTCoffset $EVENT_EXTRACTION_TOOL{'UTC_Offset'}"

  , "eet_spec_ver_num_description", <<END
#========================================================================
# eet_spec_ver_num
#
# Specification Version Number - format of the file stream
# 
# Range:
#  01 	for Version 1.X.X
#  02   for Version 2.X.X
#  etc.
#    
#========================================================================
END
  , "eet_spec_ver_num", "- pin_event_extract specvernum $EVENT_EXTRACTION_TOOL{'specification_version'}"

  , "eet_spec_release_ver_description", <<END
#========================================================================
# eet_spec_release_ver
#
# Release Version - release version within the specification version
# 
# Range:
#  00 	for Version X.0.X
#  01   for Version X.1.X
#  02   for Version X.2.X
#  etc.
#  
#========================================================================
END
  , "eet_spec_release_ver", "- pin_event_extract specrelver $EVENT_EXTRACTION_TOOL{'release_version'}"

  , "eet_num_threads_description", <<END
#========================================================================
# eet_num_threads
#
# Maximum number of EDR creation threads
#  
#========================================================================
END
  , "eet_num_threads", "- pin_event_extract num_threads $EVENT_EXTRACTION_TOOL{'num_threads'}"

  , "eet_step_size_description", <<END
#========================================================================
# eet_step_size
#
# Number of EDR records retrieved per database step search
#  
#========================================================================
END
  , "eet_step_size", "- pin_event_extract step_size $EVENT_EXTRACTION_TOOL{'step_size'}"

  , "eet_max_file_size_description", <<END
#========================================================================
# eet_max_file_size
#
# Maximum output file size in bytes 
# 
# NOTE: A new output file will be created when the program exceeds
# this limit.  This setting should contain a buffer since EDR(s) 
# will always be written in complete records  
#
# NOTE: A new output file could also be created if the maximum number
# of EDRs written has been reached.
#    
#========================================================================
END
  , "eet_max_file_size", "- pin_event_extract maxfilesize $EVENT_EXTRACTION_TOOL{'max_file_size'}"

  , "eet_max_EDR_num_description", <<END
#========================================================================
# eet_max_EDR_num
#
# Maximum number of EDRs allowed per output file
# 
# NOTE: A new output file will be created when the program reaches
# this limit. 
#      
#========================================================================
END
  , "eet_max_EDR_num", "- pin_event_extract maxEDRs $EVENT_EXTRACTION_TOOL{'max_EDR'}"
);


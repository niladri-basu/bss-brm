#=======================================================================
#  @(#)%Portal Version: pin_cnf_clean_rsvns.pl:InstallVelocityInt:4:2006-Apr-28 10:00:00 %
# 
# Copyright (c) 2006, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$PIN_CLEAN_ASOS_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Cleanup
#
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

%PIN_CLEAN_ASOS_PINCONF_ENTRIES = (

 "performance_parameters_description", <<END
#========================================================================
# Performance Parameters
# 
# The entries below govern how the MTA applications pull data from the
# database and tranfer the data to the application space. They also
# define how many threads (children) are used to process the data in
# the application.
#
#    children   = number of threads used to process the objects in the
#                 application
#    per_batch  = number of objects processed by each child
#    per_step   = number of objects returned in each database search
#    fetch_size = number of objects cached in application memory
#                 before processing starts
#
# Some applications do not use all of these performance parameters. For
# example, pin_inv_accts does not use per_batch.
#
# You can edit these entries to improve performance of MTA applications.
# Different MTA applications process accounts differently, so you
# usually need to configure these entries differently for each
# application. 
# For example, you might have these entries:
#
#    - pin_rerate       fetch_size  30000
#    - pin_inv_accts    fetch_size  50000
#
# For a complete explanation of setting these variables for best
# performance, see the online document "Infranet Configuration and
# Tuning Guide."
#========================================================================
END
	, "performance_parameters", 
	"- pin_clean_asos       children        $MTA{'mta_children'}
 - pin_clean_asos       per_batch       $MTA{'mta_per_batch'}
 - pin_clean_asos       per_step        $MTA{'mta_per_step'}
 - pin_clean_asos       fetch_size      $MTA{'mta_fetch_size'}"
 
	,"max_errs_description", <<END
#========================================================================
# max_errs
# 
# Specifies the maximum number of errors that the application can ignore.
#
# This entry is optional. By default, max_errs = fetch_size.
#========================================================================
END
	,"max_errs", "- pin_clean_asos max_errs 5000"	

, "default_db_number_description", <<END
#======================================================================
# Default DB number for the search.
#======================================================================
END
	,"default_db_number", "- pin_clean_asos database $RRF_DEFAULT_DB_NUM{'db_num'} /search 0"
	,"pin_clean_asos_logfile_description", <<END
#======================================================================
# pin_clean_asos_logfile
#
# Name and location of the log file used by this application
#======================================================================
END
	,"pin_clean_asos_logfile", "- pin_clean_asos logfile \$\{PIN_LOG_DIR\}/pin_clean_asos/pin_clean_asos.pinlog"

	,"pin_clean_asos_loglevel_description", <<END
#=================================================	=====================
# pin_clean_asos_loglevel
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
	,"pin_clean_asos_loglevel", "- pin_clean_asos loglevel 2"
 
 );

#=======================================================================
#  @(#)%Portal Version: pin_cnf_pin_bulk.pl:InstallVelocityInt:1:2005-Mar-25 18:11:05 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$PIN_BULK_PINCONF_HEADER  =  <<END
#======================================================================
# Configuration File for the bulk  adjustments
#======================================================================
# Use this file to specify how the bulk adjustments utility
# connects with Portal.
#
# A copy of this configuration file is automatically installed and 
# configured with default values when you install Portal. However,
# you can edit this file to suit your specific configuration:
#  -- You can change the default value of an entry.
#  -- You can exclude an optional entry by adding the # symbol
#     at the beginning of the line.
#  -- You can include a commented entry by removing the # symbol.
#
# Before you make any changes to this file, save a backup copy.
#
# To edit this file, follow the instructions in the commented sections.
# For more information on the general syntax of configuration entries,
# see "Reference Guide to Portal Configuration Files" in the Portal
# online documentation.
#======================================================================
END
;

%PIN_BULK_PINCONF_ENTRIES = (
	"deadlock_retry_count_description", <<END
#======================================================================
# deadlock_retry_count
#
# Number of retries to resolve a deadlock
#
#======================================================================
END
	,"deadlock_retry_count"
	,"#- pin_apply_bulk_adjustment deadlock_retry_count 6"
	
	,"mta_messg_show_description", <<END
#======================================================================
# mta_messg_show
#
# Display/hide MTA framework level messages
#
#======================================================================
END
	,"mta_messg_show"
	,"#- pin_apply_bulk_adjustment mta_messg_show 0"

	,"mta_results_flist_file_description", <<END
#======================================================================
# mta_results_flist_file
#
# Name of the file to which the CSV records will be written in flist format.
#======================================================================
END
	,"mta_results_flist_file"
	, "#- pin_apply_bulk_adjustment  mta_results_flist_file bulk_adj.flist"

 );

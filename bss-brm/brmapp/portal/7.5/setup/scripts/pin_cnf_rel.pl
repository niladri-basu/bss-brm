#=======================================================================
#  @(#)%Portal Version: pin_cnf_rel.pl:InstallVelocityInt:4:2005-Jun-02 23:36:47 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$REL_PINCONF_HEADER  =  <<END
#======================================================================
# Use this file to specify how to connect with Portal.
#
# A copy of this configuration file is automatically installed and
# configured with default values when you install SampleHandler. However,
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


%SAMPLE_HANDLER_PINCONF_ENTRIES = (

	"rel_sample_handler_logfile_description", <<END
#======================================================================
# rel_sample_handler_logfile
#
# Full path to the log file for this application.
#======================================================================
END
	,"rel_sample_handler_logfile"
	,"- nap logfile		$RATED_EVENT_LOADER{'sample_handler_location'}/handler.pinlog"
);

%PIN_REL_PINCONF_ENTRIES = (

	"pin_rel_logfile_description", <<END
#======================================================================
# pin_rel_logfile
#
# Full path to the log file for this application.
#======================================================================
END
	,"pin_rel_logfile"
	,"- nap logfile		$RATED_EVENT_LOADER{'location'}/handler.pinlog"

	,"pin_rel_dm_logfile_description", <<END
#========================================================================
# pin_rel_dm_logfile
#
# Specifies the full path to the log file used by this DM.
#
# You can enter any valid path.
#========================================================================
END
	,"pin_rel_dm_logfile"
	,"- pin_trel trel_logfile trel.pinlog"

	,"pin_rel_dm_pointer_description", <<END
#========================================================================
# pin_rel_dm_pointer
#
# specifies dm_timos connections for reference object cache synchronization
# dm_pointer entry includes three values:
#
#    -- the database number, such as 0.0.0.1
#    -- the IP address or host name of the DM computer
#    -- the port number of the DM service
#
# For HA enabled systems, include a separate entry for the primary dm_timos
# and secondary dm_timos for failover
#
#========================================================================
END
	, "pin_rel_dm_pointer"
	, "- cm dm_pointer $RATED_EVENT_LOADER{'db_num'} ip $RATED_EVENT_LOADER{'hostname'} $RATED_EVENT_LOADER{'port'}"

);

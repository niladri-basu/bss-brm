#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  $Oracle Version: pin_cmp_rel.pl:OracleBase7.2PatchInt:4:2005-Nov-09 03:21:31 $
# 
# Copyright (c) 2001, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Oracle installation for the Rated Event Loader Component
#
#=============================================================

use Cwd;

require "pin_oracle_functions.pl";
require "pin_cmp_dm_db.pl";

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
  require "pin_res.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}

#########################################
# Configure database for the Rated Event Loader TT
#########################################
sub configure_rel_tt_database {
  $DM_ORACLE{'db'}->{'vendor'} = "oracle";
  $f = "$RATED_EVENT_LOADER{'pin_cnf_location'}/pin_rel_tt_pre_updater_sp.plb";
  if ( -f $f ) {
    &ExecutePLB_file ($f,
	"Pre-Updater for TimesTen that needs to run in Oracle DB", # It depends on base oracle REL
	%DM_ORACLE );
  } else {
    &Output( STDERR, "ERROR: Could not find file %s\n", $f); 
    &Output( fpLogFile, "ERROR: Could not find file %s\n", $f); 
  }
}


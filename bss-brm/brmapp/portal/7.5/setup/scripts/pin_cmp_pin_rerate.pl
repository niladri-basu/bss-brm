#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_pin_rerate.pl:PortalBase7.3EAInt:1:2006-May-16 09:32:12 %
# 
# Copyright (c) 1999, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the pin_rerate Component
#
#=============================================================

use Cwd;

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}


#####
#
# Configure pin_rerate files
#
#####
sub configure_pin_rerate_config_files {
  local( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  &ReadIn_PinCnf( "pin_cnf_pin_rerate.pl" );
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%PIN_RERATE_PINCONF_ENTRIES );
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_RERATE_PINCONF_ENTRIES );
	
  &Configure_PinCnf( $RERATING{'location'}."/".$PINCONF, 
                     $PIN_RERATE_PINCONF_HEADER, 
                     %PIN_RERATE_PINCONF_ENTRIES );

  # Add MTA entries and CM entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%MTA_PINCONF_ENTRIES );
  
  # Create pin.conf entry in the ood_handler_location directory
  &Configure_PinCnf( $RERATING{'ood_handler_location'}."/".$PINCONF,
                     $MTA_PINCONF_HEADER,
                     %MTA_PINCONF_ENTRIES );
             
  # Create pin.conf entry in the ood_handler_process_location directory
  &Configure_PinCnf( $RERATING{'ood_handler_process_location'}."/".$PINCONF,
                     $MTA_PINCONF_HEADER,
                     %MTA_PINCONF_ENTRIES );
            
}


#####
#
# Additional configuration after Portal processes have started
#
#####
sub configure_pin_rerate_post_restart {

    if($SATELLITE_INSTALL eq "NO") {
    
    local( $Cmd );
    local( $CurrentDir ) = cwd();

    $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_rerate_flds -f \"$PIN_HOME/sys/data/config/pin_rerate_compare_bi.xml\"" );

    &Output( fpLogFile, $IDS_RERATE_FLDS_LOADING );
    &Output( STDOUT, $IDS_RERATE_FLDS_LOADING );

    $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

    if( $Cmd != 0 ) {
        &Output( fpLogFile, $IDS_RERATE_FLDS_FAILED );
        &Output( STDOUT, $IDS_RERATE_FLDS_FAILED );
      exit -1;
    } else {
        &Output( fpLogFile, $IDS_RERATE_FLDS_SUCCESS );
        &Output( STDOUT, $IDS_RERATE_FLDS_SUCCESS );
    }
    unlink( "$PIN_TEMP_DIR/tmp.out" );
    
    }
}  

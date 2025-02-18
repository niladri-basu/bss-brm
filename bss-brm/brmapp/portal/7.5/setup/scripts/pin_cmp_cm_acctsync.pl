#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# @(#)%Portal Version: pin_cmp_cm_acctsync.pl:InstallVelocityInt:2:2005-Mar-25 18:14:16 %
#=============================================================
#  @(#)%Portal Version: pin_cmp_cm_acctsync.pl:InstallVelocityInt:2:2005-Mar-25 18:14:16 %
# 
# Copyright (c) 2000, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the acctsync cm config Component
#
#=============================================================

use Cwd;


# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "pin_modular_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}


#########################################
# Configure Account Sync pin.conf files
#########################################
sub configure_cm_acctsync_config_files {
  local ( %CM )  = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;
  local ( %TMP ) = %EAI;

  local ( @FileReadIn );
  local ( $Start );

  %EAI = %DM_IFW_SYNC;

  &ReadIn_PinCnf( "pin_cnf_eai.pl" );
  &ReadIn_PinCnf( "pin_cnf_acctsync.pl" );
  %EAI = %TMP;

  #
  # If the sys/cm/pin.conf is there, add the entries to it.
  # If not, add the entries to the temporary pin.conf file.
  #
  # In the case of CM pin.conf entries specific to the EAI framework (array
  # %EAI_CM_ENTRIES), we only need to add them if not already present (or if
  # CM pin.conf itself is being created here)
  #
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    # Only include eai_js entries if not already present in CM pin.conf
    # In order to determine the presence, look for just one of the entries

    open( PINCONFFILE, $CM{'location'}."/".$PINCONF );
    @FileReadIn = <PINCONFFILE>;
    close( PINCONFFILE );

    $Start = &LocateEntry( "enable_eai_publish", @FileReadIn );

    if ( $Start == -1 ) { # Entry not found, so need to create!
      &AddArrays( \%EAI_CM_ENTRIES, \%ACCTSYNC_CM_PINCONF_ENTRIES );
      $Start = &LocateEntry( "fm_trans_pol_fm_required", @FileReadIn );
      if( $Start == -1 ) { #trans_pol entry not present. Add it here
        &AddArrays( \%TRANSPOL_FM_PINCONF_ENTRIES, \%ACCTSYNC_CM_PINCONF_ENTRIES );
      }
    }

    &ReplacePinConfEntries( $CM{'location'}."/".$PINCONF, %ACCTSYNC_CM_PINCONF_ENTRIES );
        
    # Display a message current component entries are appended to cm/pin.conf file.
    &Output( STDOUT, $IDS_CM_PIN_CONF_APPEND_SUCCESS,
    			$CurrentComponent,
   			$CM{'location'}."/".$PINCONF);       
  }
  else
  {
    # Include eai_js entries since CM pin.conf itself is being created now
    &AddArrays( \%EAI_CM_ENTRIES, \%ACCTSYNC_CM_PINCONF_ENTRIES );
    &AddArrays( \%TRANSPOL_FM_PINCONF_ENTRIES, \%ACCTSYNC_CM_PINCONF_ENTRIES );

    # Create temporary file, if it does not exist.
    $TEMP_PIN_CONF_FILE = $PIN_HOME."/".$IDS_TEMP_PIN_CONF;
    open( PINCONFFILE, ">> $TEMP_PIN_CONF_FILE" );
    close( PINCONFFILE );

    &ReplacePinConfEntries( "$TEMP_PIN_CONF_FILE", %ACCTSYNC_CM_PINCONF_ENTRIES );

    # Display a message saying to append this file to cm/pin.conf file.
    &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );
  }
    local( $TempDir ) = &FixSlashes( "$PIN_HOME/apps/integrate_sync" );
    local( $CurrentDir ) = cwd();

    &ReadIn_PinCnf( "pin_cnf_connect.pl" );
    chdir $TempDir;
    &Configure_PinCnf( "./".$PINCONF,
                      $CONNECT_PINCONF_HEADER,
                      %CONNECT_PINCONF_ENTRIES );
    chdir $CurrentDir;

}


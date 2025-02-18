#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# 
#
# Copyright (c) 2007, 2009, Oracle and/or its affiliates. All rights reserved. 
#
# This material is the confidential property of Oracle Corporation
# or its licensors and may be used, reproduced, stored
# or transmitted only in accordance with a valid Oracle license or
# sublicense agreement.
#
#--
#
# installation for the ADU component
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

##########################################
#
# Configure config export pin.conf files
#
##########################################
sub configure_adu_config_files {
  local ( %DM ) = %MAIN_DM;
  local ( %CM ) = %MAIN_CM;
  local( $Cmd );
  local ( $TEMP ) = $CurrentComponent;
  
  &ReadIn_PinCnf( "pin_cnf_adu.pl" );
  
  #
  # If the CM is there, add the entries to it.
  # If not, add the entries to the temporary pin.conf file.
  #
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    &ReplacePinConfEntries( $CM{'location'}."/".$PINCONF, %ADU_CM_PINCONF_ENTRIES );
    
    # Display a message current component entries are appended to cm/pin.conf file.
    &Output( STDOUT, $IDS_CM_PIN_CONF_APPEND_SUCCESS,
    			$CurrentComponent,
    			$CM{'location'}."/".$PINCONF);   
  }
  else
  {
    # Create temporary file, if it does not exist.
    $TEMP_PIN_CONF_FILE = $PIN_HOME."/".$IDS_TEMP_PIN_CONF;
    open( PINCONFFILE, ">> $TEMP_PIN_CONF_FILE" );
    close( PINCONFFILE );

    &ReplacePinConfEntries( "$TEMP_PIN_CONF_FILE", %ADU_CM_PINCONF_ENTRIES );

    # Display a message saying to append this file to cm/pin.conf file.
    &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );
  }  
   

  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  &ReadIn_PinCnf( "pin_cnf_adu.pl" );
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%ADU_PINCONF_ENTRIES );
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%ADU_PINCONF_ENTRIES );
	
  &Configure_PinCnf( $ADU{'pin_cnf_location'}."/".$PINCONF, 
                     $ADU_PINCONF_HEADER, 
                     %ADU_PINCONF_ENTRIES );  
}


#####################################
#
# Configuring database for config export
#
#####################################
sub configure_adu_database {
  
   }
1;

#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_dm_email.pl:InstallVelocityInt:2:2005-Mar-25 18:14:00 %
# Copyright (c) 1999, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the DM_EMAIL Component
#
#=============================================================

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}


######
#
# Configure DM_Email files
#
######
sub configure_dm_email_config_files {
  %QM = %DM_EMAIL;
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;
  
  #
  # update pin_ctl.conf
  #                     
   &ReplacePinCtlConfEntries( "${PIN_HOME}/bin/pin_ctl.conf", 
    			"__DM_EMAIL_PORT__",
			"$DM_EMAIL{'port'}" ); 
	
  &ReadIn_PinCnf( "pin_cnf_qm.pl" );
	
  $DM_EMAIL_PINCONF_HEADER = $QM_PINCONF_HEADER;
  &ReadIn_PinCnf( "pin_cnf_dm_email.pl" );
  &AddArrays( \%QM_PINCONF_ENTRIES, \%DM_EMAIL_PINCONF_ENTRIES );

  &Configure_PinCnf( $DM_EMAIL{'location'}."/".$PINCONF, 
                     $DM_EMAIL_PINCONF_HEADER, 
                     %DM_EMAIL_PINCONF_ENTRIES );

    #
    # If the sys/cm/pin.conf is there, add the entries to it.
    # If not, add the entries to the temporary pin.conf file.
    #

  if ( -f $CM{'location'}."/".$PINCONF ) {  

	&AddPinConfEntries( $CM{'location'}."/".$PINCONF, %DM_EMAIL_CM_PINCONF_ENTRIES );     
	
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
  
      &AddPinConfEntries( "$TEMP_PIN_CONF_FILE", %DM_EMAIL_CM_PINCONF_ENTRIES );
  
      # Display a message saying to append this file to cm/pin.conf file.
      &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                          $CM{'location'}."/".$PINCONF,
                          $CurrentComponent,
                          $TEMP_PIN_CONF_FILE );
  
  }
  
  
  
}

#######
#
# Configuring database for DM_Email
#
#######
#sub configure_dm_email_database {
#}

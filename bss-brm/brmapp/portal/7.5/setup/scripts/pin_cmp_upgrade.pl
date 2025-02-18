#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#========================================================================= 
# $Header: install_vob/install_odc/Server/ISMP/Portal_Base/scripts/pin_cmp_upgrade.pl /cgbubrm_7.5.0.portalbase/3 2013/01/24 06:53:45 hsnagpal Exp $
#
# pin_cmp_upgrade.pl
# 
# Copyright (c) 2012, 2013, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#=========================================================================

use Cwd;

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "pin_modular_functions.pl";
   require "../pin_setup.values";
   &configure_pin_conf_ipc;
}


sub configure_pin_conf_ipc{
  local ( %DM ) = %MAIN_DM;
  local ( %CM ) = %MAIN_CM;
  local( $Cmd );
  local ( $TEMP ) = $CurrentComponent;


   my $MY_PINCONF= $CM{'location'}."/".$PINCONF;
   &ReadIn_PinCnf( "pin_cnf_upgrade.pl" );
 
   if ( -f $MY_PINCONF)
   {
	&AddPinConfEntries( $MY_PINCONF, %IPC_CM_PINCONF_ENTRIES);
    	# Display a message current component entries are appended to cm/pin.conf file.
    	&Output( STDOUT, $IDS_CM_PIN_CONF_APPEND_SUCCESS,
                        $CurrentComponent,
                        $MY_PINCONF);
   }
   else
   {
	# Create temporary file, if it does not exist.
	$TEMP_PIN_CONF_FILE = $PIN_HOME."/".$IDS_TEMP_PIN_CONF;
	open( PINCONFFILE, ">> $TEMP_PIN_CONF_FILE" );
	close( PINCONFFILE );
	&AddPinConfEntries( "$TEMP_PIN_CONF_FILE", %IPC_CM_PINCONF_ENTRIES);
    	# Display a message current component entries are appended to cm/pin.conf file.
    	&Output( STDOUT, $IDS_CM_PIN_CONF_APPEND_SUCCESS,
                        $MY_PINCONF, $CurrentComponent, $TEMP_PIN_CONF_FILE);

   }
}

 

#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_infmgr.pl:InstallVelocityInt:1:2005-Mar-25 18:13:35 %
# 
# Copyright (c) 1999, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Portal Base Manager Component
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


#####
#
# Configure Portal Base Manager files
#
#####
sub configure_infmgr_config_files {
  local( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;
  
  #
  # update pin_ctl.conf
  #                     
  &ReplacePinCtlConfEntries( "${PIN_HOME}/bin/pin_ctl.conf", 
      			"__INFMGR_PORT__",
			"$INFMGR{'port'}" ); 
			
  &ReadIn_PinCnf( "pin_cnf_infmgr.pl" );
  &Configure_PinCnf( $INFMGR{'location'}."/".$PINCONF, 
                     $INFMGR_PINCONF_HEADER, 
                     %INFMGR_PINCONF_ENTRIES );

  # If the CM is there, add the entries to it.
  if ( -f $CM{'location'}."/".$PINCONF ) {
    &AddPinConfEntries( $CM{'location'}."/".$PINCONF, %INFMGR_CM_PINCONF_ENTRIES );
    
    # Display a message current component entries are appended to cm/pin.conf file.
    &Output( STDOUT, $IDS_CM_PIN_CONF_APPEND_SUCCESS,
    			$CurrentComponent,
   			$CM{'location'}."/".$PINCONF);    
  }
  
    
}

#######
#
# Configuring database for Infmgr
#
#######
#sub configure_infmgr_database {
#}

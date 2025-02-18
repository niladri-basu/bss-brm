#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_nmgr.pl:InstallVelocityInt:1:2005-Mar-25 18:12:08 %
# 
# Copyright (c) 1999, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Node Manager Component
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
# Configure node manager files
#
#####
sub configure_nmgr_config_files {
  local( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;
  &ReadIn_PinCnf( "pin_cnf_nmgr.pl" );
  &Configure_PinCnf( $NMGR{'location'}."/".$PINCONF, 
                     $NMGR_PINCONF_HEADER, 
                     %NMGR_PINCONF_ENTRIES );
                     
  #
  # update pin_ctl.conf
  #                     
  &ReplacePinCtlConfEntries( "${PIN_HOME}/bin/pin_ctl.conf", 
			"__NMGR_PORT__",
			"$NMGR{'port'}" );                 
}

#######
#
# Configuring database for node manager
#
#######
#sub configure_nmgr_database {
#}

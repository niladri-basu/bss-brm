#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_cmmp.pl:InstallVelocityInt:1:2005-Mar-25 18:14:08 %
# 
# Copyright (c) 1999, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Connection Manager Master Process Component
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
# Configure CMMP files
#
#####
sub configure_cmmp_config_files {
  %CM = %MAIN_CM;
  &ReadIn_PinCnf( "pin_cnf_cmmp.pl" );
  &Configure_PinCnf( $CMMP{'location'}."/".$PINCONF, 
                     $CMMP_PINCONF_HEADER, 
                     %CMMP_PINCONF_ENTRIES );
                     
  #
  # update pin_ctl.conf
  #                     
  &ReplacePinCtlConfEntries( "${PIN_HOME}/bin/pin_ctl.conf", 
			"__CMMP_PORT__",
			"$CMMP{'port'}" );                     
}

#######
#
# Configuring database for CMMP
#
#######
#sub configure_cmmp_database {
#}

#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_pin_subscription.pl:InstallVelocityInt:1:2005-Mar-25 18:11:53 %
# 
# Copyright (c) 2003, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the pin_subscription Component
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
# Configure pin_subscription files
#
#####
sub configure_pin_subscription_config_files {
  local( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  &ReadIn_PinCnf( "pin_cnf_pin_subscription.pl" );
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%PIN_SUBSCRIPTION_PINCONF_ENTRIES );
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_SUBSCRIPTION_PINCONF_ENTRIES );
	
  &Configure_PinCnf( $SUBSCRIPTION{'location'}."/".$PINCONF, 
                     $PIN_SUBSCRIPTION_PINCONF_HEADER, 
                     %PIN_SUBSCRIPTION_PINCONF_ENTRIES );

}

#######
#
# Configuring database for pin_subscription
#
#######
#sub configure_pin_subscription_database {
#}

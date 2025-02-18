#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_pin_inv.pl:InstallVelocityInt:1:2005-Mar-25 18:13:29 %
# 
# Copyright (c) 1999, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for pin_inv 
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
# Configure pin_inv files
#
#####
sub configure_pin_inv_config_files {
  local( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $PIN_INV_PINCONF_HEADER = $MTA_PINCONF_HEADER;

  &ReadIn_PinCnf( "pin_cnf_pin_inv.pl" );
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%PIN_INV_PINCONF_ENTRIES );

  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_INV_PINCONF_ENTRIES );

  &Configure_PinCnf( $PIN_INV{'location'}."/".$PINCONF, 
                     $PIN_INV_PINCONF_HEADER,
                     %PIN_INV_PINCONF_ENTRIES );
}	

#######
#
# Configuring database for pin_inv
#
#######
#sub configure_pin_inv_database {
#}

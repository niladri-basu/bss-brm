#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# 
#
# Copyright (c) 2008, 2009, Oracle and/or its affiliates. All rights reserved. 
#
# This material is the confidential property of Oracle Corporation
# or its licensors and may be used, reproduced, stored
# or transmitted only in accordance with a valid Oracle license or
# sublicense agreement.
#
#--
#
# Infranet installation for the PIN_CRYPT_UPGRADE
#
#=============================================================

#use Cwd;

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_cmp_dm_db.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";
   
   if ( $MAIN_DM{'db'}->{'vendor'} =~ /odbc/i ) {
   require "pin_odbc_functions.pl";
   }
   else{
   require "pin_oracle_functions.pl";
   }

   &ConfigureComponentCalledSeparately ( $0 );
}

##########################################
#
# Configure PIN_LOAD_NOTIFICATION pin.conf files
#
##########################################
sub configure_credit_control_config_files {
  local ( %DM ) = %MAIN_DM;
  local ( %CM ) = %MAIN_CM;
  local( $Cmd );
  local ( $TEMP ) = $CurrentComponent;
  
   
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_credit_control.pl" );
   
  $CurrentComponent = "credit_control";
  $CurrentComponent = $TEMP;

  # Add Connect and PIN_CRYPT_UPGRADE entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_LOAD_NOTIFICATION_PINCONF_ENTRIES);

  # Create pin.conf entry in the pin_crypt directory  
  &Configure_PinCnf( $CREDIT_CONTROL{'pin_cnf_location'}."/".$PINCONF,
                                $PIN_LOAD_NOTIFICATION_PINCONF_HEADER,
                                %PIN_LOAD_NOTIFICATION_PINCONF_ENTRIES); 


}

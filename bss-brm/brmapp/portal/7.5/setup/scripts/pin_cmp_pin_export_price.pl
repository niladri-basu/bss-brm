#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_pin_export_price.pl:PortalBase7.3.1Int:2:2007-Sep-24 21:16:31 %
# 
# Copyright (c) 2000, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the export price Component
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
# Configure pin export price files
#
#####
sub configure_pin_export_price_config_files {
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  
    # Add MTA entries and Connect entries

  &AddArrays( \%MTA_PINCONF_ENTRIES, \%CONNECT_PINCONF_ENTRIES );

  
  
  &Configure_PinCnf( $EXPORT_PRICE{'location'}."/".$PINCONF, 
                     $CONNECT_PINCONF_HEADER, 
                     %CONNECT_PINCONF_ENTRIES );
                       
}



#######
#
# Configuring database for pin export price
#
#######
#sub configure_pin_export_price_database {
#}

1;

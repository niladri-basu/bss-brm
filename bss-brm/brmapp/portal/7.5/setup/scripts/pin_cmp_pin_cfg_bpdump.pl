#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_pin_cfg_bpdump.pl:PortalBase7.3.1Int:2:2007-Sep-24 21:16:28 %
# 
# Copyright (c) 2007, 2009, Oracle and/or its affiliates. All rights reserved. 
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
# Configure pin_cfg_bpdump files
#
#####
sub configure_pin_cfg_bpdump_config_files {
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_pin_cfg_bpdump.pl" );
  
  # Add Connect and PIN_CFG_BPDUMP_PINCONF_ENTRIES entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_CFG_BPDUMP_PINCONF_ENTRIES );
  
  # Create pin.conf entry in the pin_cfg_bpdump directory  
  &Configure_PinCnf( $BPDUMP{'pin_cnf_location'}."/".$PINCONF,
                                $PIN_CFG_BPDUMP_PINCONF_HEADER,
                                %PIN_CFG_BPDUMP_PINCONF_ENTRIES ); 
 
                       
}
1;

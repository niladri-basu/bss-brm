#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#) % %
# 
# Copyright (c) 2006, 2009, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
# Portal installation for the dm_prov_telco Component
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


#########################################
# Configure DM Provisioning pin.conf files
#########################################
sub configure_dm_prov_telco_config_files {
  local ( %DM )  = %DM_PROV_TELCO;
  local ( %CM )  = %MAIN_CM;

  &ReadIn_PinCnf( "pin_cnf_dm.pl" );
  &ReadIn_PinCnf( "pin_cnf_dm_prov_telco.pl" );
  
  &AddArrays( \%DM_PINCONF_ENTRIES, \%DM_PROV_TELCO_PINCONF_ENTRIES );

  # Create pin.conf file in sys/dm_prov_telco directory
  &Configure_PinCnf( $DM_PROV_TELCO{'location'}."/".$PINCONF,
                                $DM_PINCONF_HEADER,
                                %DM_PROV_TELCO_PINCONF_ENTRIES );  
}

#######
#
# Configuring database for DM Provisioning
#
#######
#sub configure_dm_prov_telco_database {
#}

#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# 
#
# Copyright (c) 2007, 2009, Oracle and/or its affiliates. All rights reserved. 
#
# This material is the confidential property of Oracle Corporation
# or its licensors and may be used, reproduced, stored
# or transmitted only in accordance with a valid Oracle license or
# sublicense agreement.
#
#--
#
# Portal installation for the jca_adapter Component
#
#=============================================================

use Cwd;

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "pin_modular_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}

##########################################
#
# Configure jca_adapter pin.conf files
#
##########################################
sub configure_jca_adapter_config_files {
  local ( %DM ) = %MAIN_DM;
  local ( %CM ) = %MAIN_CM;
  
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  
  # Create pin.conf entry in the sap directory  
  &Configure_PinCnf( $JCA_ADAPTER{'pin_cnf_location'}."/".$PINCONF,
                                $CONNECT_PINCONF_HEADER,
                                %CONNECT_PINCONF_ENTRIES );  
  
}


#####################################
#
# Configuring database for jca_adapter Manager
#
#####################################
#sub configure_jca_adapter_database {
#}

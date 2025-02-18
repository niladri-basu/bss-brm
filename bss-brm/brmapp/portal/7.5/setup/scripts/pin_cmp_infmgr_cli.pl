#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_infmgr_cli.pl:InstallVelocityInt:1:2005-Mar-25 18:13:33 %
# 
# Copyright (c) 1999, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Portal Base Manager CLI Component
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
# Configure infmgr_cli files
#
#####
sub configure_infmgr_cli_config_files {
  local( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_infmgr_cli.pl" );
  &Configure_PinCnf( $INFMGR_CLI{'location'}."/".$PINCONF, 
                     $INFMGR_CLI_PINCONF_HEADER, 
                     %INFMGR_CLI_PINCONF_ENTRIES );
}

#######
#
# Configuring database for infmgr_cli
#
#######
#sub configure_infmgr_cli_database {
#}

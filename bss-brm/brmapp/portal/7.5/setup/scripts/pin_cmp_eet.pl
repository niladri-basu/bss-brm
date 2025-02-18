#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_eet.pl:InstallVelocityInt:1:2005-Mar-25 18:13:44 %
# 
# Copyright (c) 2000, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Event Extraction Tool
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


#################################################################
#
# Configure Event Extraction files
#
#################################################################
sub configure_eet_config_files {
  local( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_eet.pl" );
  
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%EET_PINCONF_ENTRIES );
  &Configure_PinCnf( $EVENT_EXTRACTION_TOOL{'location'}."/".$PINCONF,
                     $EET_PINCONF_HEADER,
                     %EET_PINCONF_ENTRIES );
}


#######
#
# Configuring database for Event Extraction
#
#######
#sub configure_eet_database {
#}

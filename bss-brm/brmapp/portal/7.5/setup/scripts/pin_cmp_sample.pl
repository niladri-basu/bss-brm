#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_sample.pl:PortalBase7.3.1PatchInt:1:2008-Feb-24 23:52:20 %
# 
# Copyright (c) 2000, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Sample Viewer Components
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
# Configure pin.conf's for Sample Components 
#
#####
sub configure_sample_config_files {

  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_mta.pl" )

  #
  # Add entries to the Sample Component's pin.conf file ...
  #
  &Configure_PinCnf( $SAMPLE{'location'}."/".$PINCONF, 
                     $CONNECT_PINCONF_HEADER,
                     %CONNECT_PINCONF_ENTRIES );
  #
  # Add entries to the Sample Viewer Component's pin.conf file ...
  #
  &Configure_PinCnf( $SAMPLE{'viewer_location'}."/".$PINCONF, 
                     $CONNECT_PINCONF_HEADER,
                     %CONNECT_PINCONF_ENTRIES );

  # Add MTA entries and CM entries
    &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%MTA_PINCONF_ENTRIES );
  
    # Create pin.conf entry in the mta_samples directory
    &Configure_PinCnf( $SAMPLE{'mta_location'}."/".$PINCONF,
                       $MTA_PINCONF_HEADER,
                       %MTA_PINCONF_ENTRIES );

}


#######
#
# Configuring database for Sample Components
#
#######
#sub configure_sample_config_database {
#}

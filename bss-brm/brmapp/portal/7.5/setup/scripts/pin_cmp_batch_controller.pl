#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_batch_controller.pl:InstallVelocityInt:2:2005-Mar-25 18:14:32 %
# 
# Copyright (c) 2000, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the BATCH_CONTROLLER Component
#


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
# Configure BATCH CONTROLLER files
#
#####
sub configure_batch_controller_config_files {

  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;

  #
  #  Configure Infranet.properties with current values ...
  #

  $i = 0;
  open( PROPFILE, "+< $BATCH_CONTROLLER{'location'}/Infranet.properties" ) || die( "Can't open $BATCH_CONTROLLER{'location'}/Infranet.properties" );
  @Array_PROP = <PROPFILE>;
  seek( PROPFILE, 0, 0 );
  while ( <PROPFILE> )
  {
    $_ =~ s/^\s*infranet\.connection.*/infranet\.connection	pcp:\/\/root.$DM{'db_num'}:\&aes|08|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5D40C305EDF3D77DF111AAB8F781E92122\@$CM{'hostname'}:$CM{'port'}\/service\/pcm_client/i;
    $_ =~ s/^\s*infranet\.log\.file.*/infranet\.log\.file	$BATCH_CONTROLLER{'location'}\/batch_controller.pinlog/i;
    $Array_PROP[$i++] = $_;
  }
  seek( PROPFILE, 0, 0 );
  print PROPFILE @Array_PROP;
  print PROPFILE "\n";
  truncate( PROPFILE, tell( PROPFILE ) );
  close( PROPFILE );


  #
  # Add entries to apps/sample_handler/pin.conf ...
  #

  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_batch_controller.pl" );

  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%BATCH_CONTROLLER_PINCONF_ENTRIES );

  &Configure_PinCnf( $BATCH_CONTROLLER{'sample_handler_location'}."/".$PINCONF,
                     $BATCH_CONTROLLER_PINCONF_HEADER,
                     %BATCH_CONTROLLER_PINCONF_ENTRIES );

}


#######
#
# Configuring database for BATCH CONTROLLER
#
#######
#sub configure_batch_controller_database {

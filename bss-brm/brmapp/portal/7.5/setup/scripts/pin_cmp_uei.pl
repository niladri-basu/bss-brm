#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# @(#)$Id: pin_cmp_uei.pl /cgbubrm_7.5.0.portalbase/1 2014/04/23 17:18:07 vivilin Exp $
# 
# Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the UEI Component
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
# Configure UEI Infranet.properties and pin.conf files
#
#####
sub configure_uei_config_files {

  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_connect.pl" );

  #
  #  Configure Infranet.properties with current values ...
  #
  $i = 0;
  open( PROPFILE, "+< $UEI{'location'}/Infranet.properties" ) || die( "Can't open $UEI{'location'}/Infranet.properties" );
  @Array_PROP = <PROPFILE>;
  seek( PROPFILE, 0, 0 );
  while ( <PROPFILE> )
  {
    $_ =~ s/infranet\.connection.*/infranet\.connection=pcp:\/\/root.$DM{'db_num'}:\&aes|08|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5D40C305EDF3D77DF111AAB8F781E92122\@$CM{'hostname'}:$CM{'port'}\/service\/pcm_client/i;
    $_ =~ s/infranet\.uel\.event_log_file_location.*/infranet\.uel\.event_log_file_location=$UEI{'location'}\//i;
    $_ =~ s/infranet\.uel\.cache_file_location.*/infranet\.uel\.cache_file_location=$UEI{'location'}\//i;
    $_ =~ s/infranet\.uel\.filter_log_file_location.*/infranet\.uel\.filter_log_file_location=$UEI{'location'}\//i;
    $_ =~ s/infranet\.uel\.load_error_file_location.*/infranet\.uel\.load_error_file_location=$UEI{'location'}\//i;
    $_ =~ s/infranet\.uel\.load_success_file_location.*/infranet\.uel\.load_success_file_location=$UEI{'location'}\//i;
    $_ =~ s/infranet\.uel\.error_log_file_location.*/infranet\.uel\.error_log_file_location=$UEI{'location'}\//i;
    $Array_PROP[$i++] = $_;
  }
  seek( PROPFILE, 0, 0 );
  print PROPFILE @Array_PROP;
  print PROPFILE "\n";
  truncate( PROPFILE, tell( PROPFILE ) );
  close( PROPFILE );

  #
  # Add entries to the pin.conf file ...
  #
  &Configure_PinCnf( $UEI{'location'}."/".$PINCONF, 
                     $CONNECT_PINCONF_HEADER,
                     %CONNECT_PINCONF_ENTRIES );

}
1;

#######
#
# Configuring database for UEI
#
#######
#sub configure_uei_database {
#}

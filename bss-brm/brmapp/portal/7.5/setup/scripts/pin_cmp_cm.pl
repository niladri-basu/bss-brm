#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# @(#)$Id: pin_cmp_cm.pl /cgbubrm_7.5.0.portalbase/1 2014/04/23 17:18:06 vivilin Exp $
# 
# Copyright (c) 1999, 2014, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Connection Manager Component
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


######
#
# Configuring CM files
#
######
sub configure_cm_config_files {
  %CM = %MAIN_CM;
  %DM = %MAIN_DM;
  
  &ReadIn_PinCnf( "pin_cnf_cm.pl" );
  &AddArrays( \%DDEBIT_CM_ENTRIES, \%CM_PINCONF_ENTRIES );
  &Configure_PinCnf( $CM{'location'}."/".$PINCONF, 
                     $CM_PINCONF_HEADER, 
                     %CM_PINCONF_ENTRIES );

  if ( ! -f $DM{'location'}."/".$PINCONF )
  {
    # Display a message saying to the cm/pin.conf file.
    &Output( STDOUT, $IDS_UPDATE_CM_PIN_CONF_MESSAGE,
                        $DM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $CM{'location'}."/".$PINCONF );

    $CM_PINCONF = $CM{'location'}."/".$PINCONF;
    open( MY_PINCONFFILE, "+< $CM_PINCONF" );
    @MyArray = <MY_PINCONFFILE>;
    close( MY_PINCONFFILE );
    $i = 0;
    while ( $i < @MyArray ) {
      if ( $MyArray[ $i ] =~ /^[^#].*(dm_pointer|em_pointer)/ ) {
        &Output( STDOUT, "$MyArray[ $i ]" );
      }
      $i = $i + 1;
    }
  }

  #
  # update pin_ctl.conf
  # 
&ReplacePinCtlConfEntries( "${PIN_HOME}/bin/pin_ctl.conf", 
			"__CM_PORT__",
			"$MAIN_CM{'port'}" );                      
}
1;

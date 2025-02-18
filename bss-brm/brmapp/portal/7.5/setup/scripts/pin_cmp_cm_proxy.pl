#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#) %%
#
# Copyright (c) 1999, 2009, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement
#
# Portal installation for the Connection Manager Proxy Component
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
# Configure cm_proxy files
#
#####
sub configure_cm_proxy_config_files {
   local ( %CM ) = %MAIN_CM;
   local ( %DM ) = %MAIN_DM;
   %QM = %CM_PROXY;

   &ReadIn_PinCnf( "pin_cnf_qm.pl" );
   &ReadIn_PinCnf( "pin_cnf_connect.pl" );
   &ReadIn_PinCnf( "pin_cnf_cm_proxy.pl" );
   &AddArrays( \%QM_PINCONF_ENTRIES, \%CM_PROXY_PINCONF_ENTRIES );
   &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%CM_PROXY_PINCONF_ENTRIES );
   &Configure_PinCnf( $CM_PROXY{'location'}."/".$PINCONF, 
                      $CM_PROXY_PINCONF_HEADER, 
                      %CM_PROXY_PINCONF_ENTRIES );
                      
  #
  # update pin_ctl.conf
  #                     
  &ReplacePinCtlConfEntries( "${PIN_HOME}/bin/pin_ctl.conf", 
			"__CM_PROXY_PORT__",
			"$CM_PROXY{'port'}" );                     
}

#######
#
# Configuring database for cm_proxy
#
#######
#sub configure_cm_proxy_database {
#}

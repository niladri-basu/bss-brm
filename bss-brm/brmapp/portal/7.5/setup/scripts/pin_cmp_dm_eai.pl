#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_dm_eai.pl:InstallVelocityInt:1:2005-Mar-25 18:14:02 %
# 
# Copyright (c) 2004, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the EAI Framework DM Component
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


#####
#
# Configure EAI pin.conf files
#
#####
sub configure_dm_eai_config_files {
  local ( %DM ) = %EAI;

  &ReadIn_PinCnf( "pin_cnf_dm.pl" );
  &ReadIn_PinCnf( "pin_cnf_eai.pl" );

  &AddArrays( \%DM_PINCONF_ENTRIES, \%EAI_PINCONF_ENTRIES );
  &AddArrays( \%DM_HTTP_PINCONF_ENTRIES, \%EAI_PINCONF_ENTRIES );

  &Configure_PinCnf( $EAI{'location'}."/".$PINCONF, 
                     $EAI_PINCONF_HEADER, 
                     %EAI_PINCONF_ENTRIES );
}

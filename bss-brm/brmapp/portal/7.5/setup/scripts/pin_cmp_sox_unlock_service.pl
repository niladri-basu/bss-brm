#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# @(#)$Id: pin_cmp_sox_unlock_service.pl /cgbubrm_7.5.0.portalbase/1 2014/04/23 17:18:07 vivilin Exp $
#
# Copyright (c) 2008, 2014, Oracle and/or its affiliates. All rights reserved.
#
# This material is the confidential property of Oracle Corporation
# or its licensors and may be used, reproduced, stored
# or transmitted only in accordance with a valid Oracle license or
# sublicense agreement.
#
#--
#
# Infranet installation for the PIN_CRYPT_UPGRADE
#
#=============================================================

#use Cwd;

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_cmp_dm_db.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";
   
   if ( $MAIN_DM{'db'}->{'vendor'} =~ /odbc/i ) {
   require "pin_odbc_functions.pl";
   }
   else{
   require "pin_oracle_functions.pl";
   }

   &ConfigureComponentCalledSeparately ( $0 );
}

##########################################
#
# Configure PIN_UNLOCK_SERVICE pin.conf files
#
##########################################
sub configure_sox_unlock_service_config_files {
  local ( %DM ) = %MAIN_DM;
  local ( %CM ) = %MAIN_CM;
  local( $Cmd );
  local ( $TEMP ) = $CurrentComponent;
  
   
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_sox_unlock_service.pl" );
   
  $CurrentComponent = "sox_unlock_service";
  $CurrentComponent = $TEMP;

  # Add Connect and PIN_CRYPT_UPGRADE entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_UNLOCK_SERVICE_PINCONF_ENTRIES);

  # Create pin.conf entry in the pin_crypt directory  
  &Configure_PinCnf( $SOX_UNLOCK{'pin_cnf_location'}."/".$PINCONF,
                                $PIN_UNLOCK_SERVICE_PINCONF_HEADER,
                                %PIN_UNLOCK_SERVICE_PINCONF_ENTRIES); 


}

# Create unlock service stored procedures                                
sub configure_sox_unlock_service_database {
  #
  #Check for the presence of PortalBase tables 'pcmsvc_lockinfo_t' and 'admsvc_lockinfo_t' to load unlock service stored procedure
  #
  if ( VerifyPresenceOfTable( "admsvc_lockinfo_t", %{$DM{"db"}} ) == -1 && VerifyPresenceOfTable( "pcmsvc_lockinfo_t", %{$DM{"db"}} ) == -1) {
             # Display a message saying that PortalBase schema has initialized and loading unlock service stored procedure
               &Output( STDOUT, $IDS_PORTALBASE_SCHEMA_INIT_SUCCESS);

               if ( $MAIN_DM{'db'}->{'vendor'} =~ /oracle/i ) {

                   &ExecutePLB_file ("$DM_ORACLE{'location'}/data/create_actlogin_unlockservice_procedures.plb",
                                     "UnlockService stored procedure",
                                     %DM_ORACLE );

               }
  }
  else {
      # Display a message saying that PortalBase schema has not initialized and skipping the unlock service stored procedure load section.
      &Output( STDOUT, $IDS_PORTALBASE_SCHEMA_INIT_FAILED);
  }
 }

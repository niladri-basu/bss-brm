#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# @(#)$Id: pin_cmp_ecr_pci.pl /cgbubrm_7.5.0.portalbase/1 2014/04/23 17:18:07 vivilin Exp $
#
# Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.
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

use Cwd;

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
# Configure PIN_CRYPT_UPGRADE pin.conf files
#
##########################################
sub configure_ecr_pci_config_files {
  local ( %DM ) = %MAIN_DM;
  local ( %CM ) = %MAIN_CM;
  local( $Cmd );
  local ( $TEMP ) = $CurrentComponent;
  
   
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_ecr_pci.pl" );
   
  $CurrentComponent = "pin_crypt_upgrade";
  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $CurrentComponent = $TEMP;
  
  # Add MTA entries and PIN_CRYPT_UPGRADE entries
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%PIN_CRYPT_UPGRADE_PINCONF_ENTRIES );
  
  # Add Connect and PIN_CRYPT_UPGRADE entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_CRYPT_UPGRADE_PINCONF_ENTRIES );
  
  # Create pin.conf entry in the pin_crypt directory  
  &Configure_PinCnf( $AES{'pin_cnf_location'}."/".$PINCONF,
                                $PIN_CRYPT_UPGRADE_PINCONF_HEADER,
                                %PIN_CRYPT_UPGRADE_PINCONF_ENTRIES ); 


}

sub configure_ecr_pci_database {


# Create ECR_PCI stored procedures                                

    if ( $MAIN_DM{'db'}->{'vendor'} =~ /oracle/i ) {
  	&ExecutePLB_file ("$DM_ORACLE{'location'}/data/create_get_fields.plb","ECR_PCI stored procedures",%DM_ORACLE);
  
    }
    if ( $MAIN_DM{'db'}->{'vendor'} =~ /odbc/i ) {
    	
# Checking if the charset is Unicode

	if ($DM_ODBC{'sm_charset'} =~ /UNICODE/i){
    
      	&ExecuteSQL_Statement_From_File ("$DM_ODBC{'location'}/data/create_get_fields_unicode_sql.source",TRUE,TRUE, %{$DM_ODBC{'db'}});
      }
      else{
      	&ExecuteSQL_Statement_From_File ("$DM_ODBC{'location'}/data/create_get_fields_sql.source",TRUE,TRUE, %{$DM_ODBC{'db'}});
      }
    }
                                
  
  
                       
  
 }

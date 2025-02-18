#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_dm_invoice.pl:InstallVelocityInt:1:2005-Mar-25 18:13:58 %
# 
# Copyright (c) 2000, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the DM_INVOICE Component
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


#######
#
# Configuring DM_INVOICE files
#
#######
sub configure_dm_invoice_config_files {
  %DM = %DM_INVOICE;
  %CM = %MAIN_CM;
  
  #
  # update pin_ctl.conf
  #                     
  &ReplacePinCtlConfEntries( "${PIN_HOME}/bin/pin_ctl.conf", 
   			"__DM_INVOICE_PORT__",
			"$DM_INVOICE{'port'}" );
  
  &ReadIn_PinCnf( "pin_cnf_dm.pl" );

  &ReadIn_PinCnf( "pin_cnf_dm_db.pl" );
  if ( $DM_INVOICE{'db'}->{'vendor'} =~ /oracle/i )
  {
    &AddArrays( \%DM_ORACLE_DB_PINCONF_ENTRIES, \%DM_DB_PINCONF_ENTRIES );
  }
  &AddArrays( \%DM_PINCONF_ENTRIES, \%DM_DB_PINCONF_ENTRIES );

  &Configure_PinCnf( $DM_INVOICE{'location'}."/".$PINCONF, 
                     $DM_PINCONF_HEADER,
                     %DM_DB_PINCONF_ENTRIES );

  # If the CM is there, add the entries to it.
  if ( -f $MAIN_CM{'location'}."/".$PINCONF ) {  
    &AddPinConfEntry( $MAIN_CM{'location'}."/".$PINCONF, "dm_invoice_dm_attributes", "- cm dm_attributes $DM_INVOICE{'db_num'} assign_account_obj" );
    &AddPinConfEntry( $MAIN_CM{'location'}."/".$PINCONF, "dm_invoice_dm_pointer", "- cm dm_pointer $DM_INVOICE{'db_num'} ip $HOSTNAME $DM_INVOICE{'port'}" );
    &AddPinConfEntry( $MAIN_CM{'location'}."/".$PINCONF, "dm_invoice_db_no", "- fm_cust_pol invoice_db $DM_INVOICE{'db_num'} /invoice 0" );
  }
  # If the PIN_INV is there, add the entries to it.
  if ( -f $PIN_INV{'location'}."/".$PINCONF ) {  
    &AddPinConfEntry( $PIN_INV{'location'}."/".$PINCONF, "pin_inv_send_inv_db", "- pin_inv_send invoice_db $DM_INVOICE{'db_num'} /invoice 0" );
    &AddPinConfEntry( $PIN_INV{'location'}."/".$PINCONF, "pin_inv_export_inv_db", "- pin_inv_export invoice_db $DM_INVOICE{'db_num'} /invoice 0" );
  }
  
  
}

#######
#
# Configuring database for DM_INVOICE
#
#######
sub configure_dm_invoice_database {
  
  $DM_INVOICE{'db'}->{'vendor'} =~ tr/A-Z/a-z/;
  require "pin_".$DM_INVOICE{'db'}->{'vendor'}."_functions.pl";
  require "pin_cmp_dm_db.pl";
  local ( $TMP ) = $DD{'location'};
  local ( $TMP2 ) = $SKIP_INIT_OBJECTS;
  local ( $TMP3 ) = $DM_INVOICE{'location'};
  local ( %DM ) = %DM_INVOICE;
  $DD{'location'} = $DM_INVOICE{'location'}."/data";
  $DM_INVOICE{'db'}->{'vendor'} = "invoice";
  $DM{'location'} = $MAIN_DM{'location'};
  
  if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
     &DropTables( %{%DM_INVOICE->{"db"}} );
  } 

  #
  # Make sure everything is writeable
  #
  &ReplacePinConfEntry( $TMP3."/".$PINCONF, 
			"dd_write_enable_fields",
			"- dm dd_write_enable_fields 1" );
  &ReplacePinConfEntry( $TMP3."/".$PINCONF, 
			"dd_write_enable_objects",
			"- dm dd_write_enable_objects 1" );
  &ReplacePinConfEntry( $TMP3."/".$PINCONF, 
			"dd_write_enable_portal_objects",
			"- dm dd_write_enable_portal_objects 1" );
  $SKIP_INIT_OBJECTS = "YES";
  &pin_pre_init( %{%DM_INVOICE->{"db"}} );
  &pin_init( %DM_INVOICE );
  &pin_post_init( %DM_INVOICE );
  $SKIP_INIT_OBJECTS = $TMP2;
  #
  # Make sure everything is back to normal
  #
  &ReplacePinConfEntry( $TMP3."/".$PINCONF, 
			"dd_write_enable_fields",
			"- dm dd_write_enable_fields $DM_INVOICE{'enable_write_fields'}" );
  &ReplacePinConfEntry( $TMP3."/".$PINCONF, 
			"dd_write_enable_objects",
			"- dm dd_write_enable_objects $DM_INVOICE{'enable_write_objects'}" );
  &ReplacePinConfEntry( $TMP3."/".$PINCONF, 
			"dd_write_enable_portal_objects",
			"- dm dd_write_enable_portal_objects $DM_INVOICE{'enable_write_portal_objects'}" );

  $DD{'location'} = $TMP;
  $DM_INVOICE{'location'} = $TMP3;
}

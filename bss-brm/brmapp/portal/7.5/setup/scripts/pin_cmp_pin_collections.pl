#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# @(#)$Id: pin_cmp_pin_collections.pl /cgbubrm_7.5.0.portalbase/2 2014/04/23 17:18:07 vivilin Exp $
#    
# Copyright (c) 2002, 2014, Oracle and/or its affiliates. All rights reserved.
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
# Portal installation for pin_inv 
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
# Configuring database for Collections
#
#######
sub configure_pin_collections_database {
  
  require "pin_".$MAIN_DM{'db'}->{'vendor'}."_functions.pl";
  require "pin_cmp_dm_db.pl";
  local ( $TMP ) = $SKIP_INIT_OBJECTS;
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;
  
  &PreModularConfigureDatabase( %CM, %DM );
  
  
    if ( (VerifyPresenceOfTable( "CONFIG_COLLECTIONS_PROFILE_T", %{$DM{"db"}} ) == 0 ) && (VerifyPresenceOfView( "CONFIG_COLLECTIONS_PROFILE_T", %{$DM{"db"}} ) == 0 )){
    
  
    $SKIP_INIT_OBJECTS = "NO";
    $USE_SPECIAL_DD_FILE = "YES";
    $SPECIAL_DD_FILE = "$DD{'location'}/dd_objects_collections.source";
    $SPECIAL_DD_INIT_FILE = "$DD{'location'}/init_objects_collections.source";
    $SPECIAL_DD_DROP_FILE = "$DD{'location'}/drop_tables_collections_".$MAIN_DM{'db'}->{'vendor'}.".source";
    $SPECIAL_DD_CREATE_INDEXES_FILE = "$DD{'location'}/create_indexes_collections_".$MAIN_DM{'db'}->{'vendor'}.".source";
  
    if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
      &DropTables( %{MAIN_DM->{"db"}} );
    }
  
    &pin_pre_modular( %{$DM{"db"}} );
    &pin_init( %DM );
    &pin_post_modular( %DM );
  
    $USE_SPECIAL_DD_FILE = "NO";
    $SKIP_INIT_OBJECTS = $TMP;
  
    &ExecuteSQL_Statement_From_File( $SPECIAL_DD_CREATE_INDEXES_FILE, TRUE, TRUE, %{$DM{'db'}} );
  
        
  
}

else {
  
  
    if ( VerifyPresenceOfFieldName( "BILLINFO_OBJ_ID0","COLLECTIONS_SCENARIO_T", %{$DM{"db"}} ) == 0 ){

      $SKIP_INIT_OBJECTS = "YES";
      $USE_SPECIAL_DD_FILE = "YES";

      #This is a special case. Two source files are called in sequence     	
      $SPECIAL_DD_FILE = "$DD{'location'}/65_67_collections_upg_dd_objects.source";
    
      &pin_pre_modular( %{$DM{"db"}} );
      &pin_init( %DM );
  
      $SPECIAL_DD_FILE = "$DD{'location'}/65_67_collections_class_upg_dd_objects.source";
    
      &pin_init( %DM );
      &pin_post_modular( %DM );

      #This is a seperate SQL file to be called for the same upgrade
      $USE_SPECIAL_DD_FILE = "NO";
      $SKIP_INIT_OBJECTS = $TMP;
      $SPECIAL_DD_SQL_FILE = "$DD{'location'}/65_67_upg_collections.sql";
  
      &ExecuteSQL_Statement_From_File( $SPECIAL_DD_SQL_FILE, TRUE, TRUE, %{$DM{'db'}} );
    
    }
}
           	
  &PostModularConfigureDatabase( %CM, %DM );

}


#####
#
# Configure collections files
#
#####
sub configure_pin_collections_config_files {
  local( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;

  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $COLLECTIONS_PINCONF_HEADER = $MTA_PINCONF_HEADER;

  &ReadIn_PinCnf( "pin_cnf_pin_collections.pl" );
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%COLLECTIONS_PINCONF_ENTRIES );

  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%COLLECTIONS_PINCONF_ENTRIES );

  &Configure_PinCnf( $COLLECTIONS{'location'}."/".$PINCONF, 
                     $COLLECTIONS_PINCONF_HEADER,
                     %COLLECTIONS_PINCONF_ENTRIES );

  #
  # If the CM is there, add the entries to it.
  # If not, add the entries to the temporary pin.conf file.
  #
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    &ReplacePinConfEntries( $CM{'location'}."/".$PINCONF, %COLLECTIONS_CM_PINCONF_ENTRIES );
    
    # Display a message current component entries are appended to cm/pin.conf file.
    &Output( STDOUT, $IDS_CM_PIN_CONF_APPEND_SUCCESS,
    			$CurrentComponent,
   			$CM{'location'}."/".$PINCONF);   
    
  }
  else
  {
    # Create temporary file, if it does not exist.
    $TEMP_PIN_CONF_FILE = $PIN_HOME."/".$IDS_TEMP_PIN_CONF;
    open( PINCONFFILE, ">> $TEMP_PIN_CONF_FILE" );
    close( PINCONFFILE );

    &ReplacePinConfEntries( "$TEMP_PIN_CONF_FILE", %COLLECTIONS_CM_PINCONF_ENTRIES );

    # Display a message saying to append this file to cm/pin.conf file.
    &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );

    if ( $^O =~ /win/i )
    {
      &Output( STDOUT, "\nPress enter to continue " );
      $TmpInput = <STDIN>;
    }
  }

}	

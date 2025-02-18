#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_rrf.pl:PortalBase7.2PatchInt:1:2005-Oct-20 02:42:02 %
# 
# Copyright (c) 2000, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Resource Reservation Framework Component
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
# Configure CM pin.conf with Resource Reservation Framework entries
#
#####
sub configure_rrf_config_files {
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;
  local ( $TEMP ) = $CurrentComponent;
  
  &ReadIn_PinCnf( "pin_cnf_rrf.pl" );
  &ReadIn_PinCnf( "pin_cnf_clean_rsvns.pl" );   
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  &ReadIn_PinCnf( "pin_cnf_clean_asos.pl" );

  #
  # If the CM is there, add the entries to it.
  # If not, add the entries to the temporary pin.conf file.
  #
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    &ReplacePinConfEntries( $CM{'location'}."/".$PINCONF, %RRF_CM_ENTRIES );
    
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

    &ReplacePinConfEntries( "$TEMP_PIN_CONF_FILE", %RRF_CM_ENTRIES );

    # Display a message saying to append this file to cm/pin.conf file.
    &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );
  };

  # Create entries for the pin_clean_rsvns
  $CurrentComponent = "pin_clean_rsvns";
  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $CurrentComponent = $TEMP;

  # Add MTA entries and pin clean reservation entries
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%PIN_CLEAN_RESERVATION_PINCONF_ENTRIES );
  
  # Add CM entries and pin clean reservation entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_CLEAN_RESERVATION_PINCONF_ENTRIES );
  
  # Create pin.conf entry in the pin_clean_rsvns directory
  &Configure_PinCnf( $RRF{'clean_rsvns_location'}."/".$PINCONF,
                     $PIN_CLEAN_RESERVATIONS_PINCONF_HEADER,
                     %PIN_CLEAN_RESERVATION_PINCONF_ENTRIES );  


  # Create entries for the pin_clean_asos
  
  $CurrentComponent = "pin_clean_asos";
  &ReadIn_PinCnf( "pin_cnf_mta.pl" );
  $CurrentComponent = $TEMP;

  # Add IDS GENERIC entries and pin clean asos entries
  &AddArrays( \%IDS_GENERIC_PIN_CONF_HEADER, \%PIN_CLEAN_ASOS_PINCONF_ENTRIES );

  # Add MTA entries and pin clean asos entries
  &AddArrays( \%MTA_PINCONF_ENTRIES, \%PIN_CLEAN_ASOS_PINCONF_ENTRIES );
  
  # Add CM entries and pin clean asos entries
  &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%PIN_CLEAN_ASOS_PINCONF_ENTRIES );
  
  # Create pin.conf entry in the asos directory
  &Configure_PinCnf( $RRF{'clean_asos_location'}."/".$PINCONF,
                     $PIN_CLEAN_ASOS_PINCONF_HEADER,
                     %PIN_CLEAN_ASOS_PINCONF_ENTRIES );  

}

sub configure_rrf_database {

  require "pin_".$MAIN_DB{'vendor'}."_functions.pl";
  require "pin_cmp_dm_db.pl";
  local ( $TMP ) = $SKIP_INIT_OBJECTS;
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;

  &PreModularConfigureDatabase( %CM, %DM );

        # checking for presence of reservation_t and if not exist (RRF is not installed) then run dd_objects_reservation.source
        #
        if ( VerifyPresenceOfTable( "RESERVATION_T", %{%DM->{"db"}} ) == 0 ){
            
            $SKIP_INIT_OBJECTS = "YES";
            $USE_SPECIAL_DD_FILE = "YES";
            $SPECIAL_DD_FILE = "$DD{'location'}/dd_objects_reservation.source";
            $SPECIAL_DD_DROP_FILE = "$DD{'location'}/drop_tables_reservation_".$MAIN_DM{'db'}->{'vendor'}.".source";
            $SPECIAL_DD_CREATE_INDEXES_FILE = "$DD{'location'}/create_indexes_reservation_".$MAIN_DM{'db'}->{'vendor'}.".source";
            
            if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
                &DropTables( %{MAIN_DM->{"db"}} );
              }
              
              &pin_pre_modular( %{%DM->{"db"}} );
              &pin_init( %DM );
              &pin_post_modular( %DM );
            
              $USE_SPECIAL_DD_FILE = "NO";
              $SKIP_INIT_OBJECTS = $TMP;
            
              &ExecuteSQL_Statement_From_File( $SPECIAL_DD_CREATE_INDEXES_FILE, TRUE, TRUE, %{%DM->{'db'}} );
          }
      
        

    #
    # If this is an upgrade from 6.5_FP3, then the reservation_t.bal_grp_obj_id0 will not be present.
    #
  
    if ( VerifyPresenceOfFieldName( "bal_grp_obj_id0","RESERVATION_T",%{%DM->{"db"}} ) == 0 ){  
       
      
      
       $SKIP_INIT_OBJECTS = "YES";
  	    $USE_SPECIAL_DD_FILE = "YES";
        $SPECIAL_DD_FILE = "$DD{'location'}/6.5_FP3_6.7_FP1_dd_objects_reservation.source";      
 	   	   
        &pin_pre_modular( %{%DM->{"db"}} );
        &pin_init( %DM );
        &pin_post_modular( %DM );
        
        $USE_SPECIAL_DD_FILE = "NO";
  	    $SKIP_INIT_OBJECTS = $TMP;
 	
    }
   
    #
    # If this is an upgrade from 7.0 to 7.2, then /reservation/active will not be present.
    #
    if ( VerifyPresenceOfObject( "/reservation/active", %{%DM->{"db"}} ) == 0 ){
    
        $SKIP_INIT_OBJECTS = "YES";
  	    $USE_SPECIAL_DD_FILE = "YES";
        $SPECIAL_DD_FILE = "$DD{'location'}/7.0_7.2_dd_objects_reservation.source";        
        
        &pin_pre_modular( %{%DM->{"db"}} );
        &pin_init( %DM );
        &pin_post_modular( %DM );
    }
  
    
    # checking for presence of reservation_rum_map_t and if it does not exist then run the 7.2_7.3_dd_objects_reservation.source

    if ( VerifyPresenceOfTable( "RESERVATION_RUM_MAP_T", %{%DM->{"db"}} ) == 0 )
    {
    
      	$SKIP_INIT_OBJECTS = "YES";
      	$USE_SPECIAL_DD_FILE = "YES";
      	$SPECIAL_DD_FILE = "$DD{'location'}/7.2_7.3_dd_objects_reservation.source";
      		 
      	#&pin_pre_modular( %{%DM->{"db"}} );
      	&pin_init( %DM );
      	#&pin_post_modular( %DM );
    
      	$USE_SPECIAL_DD_FILE = "NO";
      	$SKIP_INIT_OBJECTS = $TMP;
    }  
    &PostModularConfigureDatabase( %CM, %DM );
  }

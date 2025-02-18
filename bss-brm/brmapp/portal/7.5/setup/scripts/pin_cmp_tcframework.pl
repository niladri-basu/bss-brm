#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#) % %
# 
# Copyright (c) 2000, 2011, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
# Portal installation for the Telco Framework
#
#=============================================================

use Cwd;

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}

##########################################
#
# Configure Telco Framework pin.conf files
#
##########################################
sub configure_tcframework_config_files {
  local ( %CM ) = %MAIN_CM;
  local( %DM ) = %MAIN_DM;  
  local ( %DM_PROV ) = %DM_PROV_TELCO;
  local ( @FileReadIn );
  local ( $Start );  

  &ReadIn_PinCnf( "pin_cnf_tcframework.pl" );
  
  #
  # If the sys/cm/pin.conf is there, add the entries to it.
  # If not, add the entries to the temporary pin.conf file.
  #
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    	open( PINCONFFILE, $CM{'location'}."/".$PINCONF );
    	@FileReadIn = <PINCONFFILE>;
    	close( PINCONFFILE );

	# Search for provisioning_fm_required... If not found, we need
	# to add the provisioning fm's to the pin.conf file... We also
	# need to check if eai installed trans_pol or not.
	#
	&AddArrays( \%PROVISIONING_CM_PINCONF_ENTRIES, \%TCF_CM_PINCONF_ENTRIES );
	$Start = &LocateEntry( "provisioning_fm_required", @FileReadIn );
	if ( $Start == -1 )  # Entry not created before hence create it.
	{
		&AddArrays( \%PROVISIONING_FM_PINCONF_ENTRIES, \%TCF_CM_PINCONF_ENTRIES );
	    	$Start = &LocateEntry( "fm_trans_pol_fm_required", @FileReadIn );
	    	if( $Start == -1 ) {
	    		&AddArrays( \%TRANSPOL_FM_PINCONF_ENTRIES, \%TCF_CM_PINCONF_ENTRIES );
	    	}
	}
	&ReplacePinConfEntries( $CM{'location'}."/".$PINCONF, %TCF_CM_PINCONF_ENTRIES );
  }
  else
  {
    # Create temporary file, if it does not exist.
    $TEMP_PIN_CONF_FILE = $PIN_HOME."/".$IDS_TEMP_PIN_CONF;
    open( PINCONFFILE, ">> $TEMP_PIN_CONF_FILE" );
    close( PINCONFFILE );

    &AddArrays( \%PROVISIONING_CM_PINCONF_ENTRIES, \%TCF_CM_PINCONF_ENTRIES );
    &AddArrays( \%PROVISIONING_FM_PINCONF_ENTRIES, \%TCF_CM_PINCONF_ENTRIES );
    &AddArrays( \%TRANSPOL_FM_PINCONF_ENTRIES, \%TCF_CM_PINCONF_ENTRIES );
    &ReplacePinConfEntries( "$TEMP_PIN_CONF_FILE", %TCF_CM_PINCONF_ENTRIES );
    
    # Display a message saying to append this file to cm/pin.conf file.
    &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );

    }
    &configure_tcframework_properties_files();
}


##########################################
#
# Configure Telco Framework Infranet.properties files
#
##########################################
sub configure_tcframework_properties_files
{
    $PROP_File = $DM_PROV_TELCOFRAMEWORK{'location'}."/"."Infranet.properties";
    if( -f $PROP_File ) {
        return;
    }
    else {
        open( INFILE, ">> $PROP_File" );
        seek( PROPFILE, 0, 0 );
        print INFILE "infranet.connection=pcp://root.$DM{'db_num'}:\&aes|08|0D5E11BFDD97D2769D9B0DBFBD1BBF7E5D40C305EDF3D77DF111AAB8F781E92122\@$CM{'hostname'}:$MAIN_CM{'port'}/service/admin_client 1\n";
        print INFILE "\n";
        print INFILE "infranet.login.type=1";
        print INFILE "\n";
        print INFILE "infranet.log.level=1";
        print INFILE "\n";
        print INFILE "infranet.log.logallebuf=true";
        print INFILE "\n";
        truncate( INFILE, tell( INFILE ) );
        close( INFILE );
    }
}



###########################################
#
# Configuring database for Telco Framework
#
###########################################
sub configure_tcframework_database {
  
  require "pin_".$MAIN_DM{'db'}->{'vendor'}."_functions.pl";
  require "pin_cmp_dm_db.pl";
  local ( $TMP ) = $SKIP_INIT_OBJECTS;
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;
  
  &PreModularConfigureDatabase( %CM, %DM );

  ###################################################
  # Creating the tables for the Provisioning feature
  ###################################################
  #
  # Update Portal database ONLY if the provisioning tables are NOT PRESENT.
  #
  $SKIP_INIT_OBJECTS = "YES";
  $USE_SPECIAL_DD_FILE = "YES";

  if ( VerifyPresenceOfField( "PIN_FLD_SVC_ORDER", %{%DM->{"db"}} ) == 0 ){
  $SPECIAL_DD_FILE = "$DD{'location'}/dd_objects_service_order.source";
  $SPECIAL_DD_DROP_FILE = "$DD{'location'}/drop_tables_service_order_".$MAIN_DM{'db'}->{'vendor'}.".source";
  $SPECIAL_DD_CREATE_INDEXES_FILE = "$DD{'location'}/create_indexes_service_order_".$MAIN_DM{'db'}->{'vendor'}.".source";

  if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
      &DropTables( %{MAIN_DM->{"db"}} );
  }
   
  &pin_pre_modular( %{%DM->{"db"}} );
  &pin_init( %DM );
  &pin_post_modular( %DM );
  &ExecuteSQL_Statement_From_File( $SPECIAL_DD_CREATE_INDEXES_FILE, TRUE, TRUE, %{%DM->{'db'}} );
  }  
  
 if ( VerifyPresenceOfTable( "CONFIG_ACCOUNT_ERA_T", %{%DM->{"db"}} ) == 0 ){
    $SPECIAL_DD_FILE = "$DD{'location'}/dd_objects_config_accountera.source";
    $SPECIAL_DD_DROP_FILE = "$DD{'location'}/drop_tables_config_accountera_".$MAIN_DM{'db'}->{'vendor'}.".source";
    $SPECIAL_DD_CREATE_INDEXES_FILE = "$DD{'location'}/create_indexes_config_accountera_".$MAIN_DM{'db'}->{'vendor'}.".source";

    if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
       &DropTables( %{MAIN_DM->{"db"}} );
    }
   
    &pin_pre_modular( %{%DM->{"db"}} );
    &pin_init( %DM );
    &pin_post_modular( %DM );
    &ExecuteSQL_Statement_From_File( $SPECIAL_DD_CREATE_INDEXES_FILE, TRUE, TRUE, %{%DM->{'db'}} );
  }

  #############################################
  # Creating the tables for the Telco Framework
  #############################################
  

  if ( VerifyPresenceOfTable( "SERVICE_TELCO_T", %{%DM->{"db"}} ) == 0 ){

  $SPECIAL_DD_FILE = "$DD{'location'}/dd_objects_telco.source";
  $SPECIAL_DD_DROP_FILE = "$DD{'location'}/drop_tables_telco_".$MAIN_DM{'db'}->{'vendor'}.".source";
  $SPECIAL_DD_CREATE_INDEXES_FILE = "$DD{'location'}/create_indexes_telco_".$MAIN_DM{'db'}->{'vendor'}.".source";

  if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
    &DropTables( %{MAIN_DM->{"db"}} );
  }

  &pin_pre_modular( %{%DM->{"db"}} );
  &pin_init( %DM );
  &pin_post_modular( %DM );
  &ExecuteSQL_Statement_From_File( $SPECIAL_DD_CREATE_INDEXES_FILE, TRUE, TRUE, %{%DM->{'db'}} );

  $USE_SPECIAL_DD_FILE = "NO";
  $SKIP_INIT_OBJECTS = $TMP;
   }
  
 
  # Check for presence of active_session_telco_t and upgrade from 6.7_FP1 to 7.0.

  if ( VerifyPresenceOfTable( "ACTIVE_SESSION_TELCO_T", %{%DM->{"db"}} ) == 0 ){

    $SKIP_INIT_OBJECTS = "YES";
    $USE_SPECIAL_DD_FILE = "YES";
    $SPECIAL_DD_FILE = "$DD{'location'}/6.7_FP1_7.0_dd_objects_telco.source";
     
    &pin_pre_modular( %{%DM->{"db"}} );
    &pin_init( %DM );
    &pin_post_modular( %DM );
    
    $USE_SPECIAL_DD_FILE = "NO";
    $SKIP_INIT_OBJECTS = $TMP;

  }

 # Check for presence of config_telco_ext_ra_t and upgrade from 7.2 to 7.3
 
  if ( VerifyPresenceOfTable( "CONFIG_TELCO_EXT_RA_T", %{%DM->{"db"}} ) == -1 ){
 
 # Check for presence of PIN_FLD_LABEL and upgrade from 7.2 to 7.3
  
  if ( VerifyPresenceOfFieldName( "LABEL","CONFIG_TELCO_EXT_RA_T", %{%DM->{"db"}} ) == 0 ){
   
     $SKIP_INIT_OBJECTS = "YES";
     $USE_SPECIAL_DD_FILE = "YES";
     $SPECIAL_DD_FILE = "$DD{'location'}/7.2_7.3_dd_objects_telco.source";
      
     &pin_pre_modular( %{%DM->{"db"}} );
     &pin_init( %DM );
     &pin_post_modular( %DM );
     
     $USE_SPECIAL_DD_FILE = "NO";
     $SKIP_INIT_OBJECTS = $TMP;
     
     }
  
  }
     
  if ( VerifyPresenceOfTable( "CONFIG_SVCFW_PERM_SVC_TYPES_T", %{%DM->{"db"}} ) == 0 ){
   
     $SKIP_INIT_OBJECTS = "YES";
     $USE_SPECIAL_DD_FILE = "YES";
     $SPECIAL_DD_FILE = "$DD{'location'}/7.3Patch_7.3.1_dd_objects_svcfw_perm_svc_types.source";
      
     &pin_pre_modular( %{%DM->{"db"}} );
     &pin_init( %DM );
     &pin_post_modular( %DM );
     
     $USE_SPECIAL_DD_FILE = "NO";
     $SKIP_INIT_OBJECTS = $TMP;
     
     }
 
  &PostModularConfigureDatabase( %CM, %DM );

}

#########################################
     # Additional configuration for tcframework
     #########################################
     sub configure_tcframework_post_restart {
     
       local( $TempDir ) = &FixSlashes( "$AAA_LOAD_CONFIG_PATH" );
       local( $CurrentDir ) = cwd();
       local ( %CM ) = %MAIN_CM;
       local( %DM ) = %MAIN_DM;
     
       &ReadIn_PinCnf( "pin_cnf_connect.pl" );
     
       #
       # If the sys/data/config/pin.conf is present, then continue
       # If not, add the entries to the pin.conf file.
       #
       if (!( -e $AAA_LOAD_CONFIG_PATH."/".$PINCONF ))
       {
       	  #
     	  # Create pin.conf for loading.
     	  #
     	    &Configure_PinCnf( $AAA_LOAD_CONFIG_PATH."/".$PINCONF,
                            $CONNECT_PINCONF_HEADER,
                            %CONNECT_PINCONF_ENTRIES);
       }
     
      chdir $TempDir;
      
      &configure_tags_tcf( *MAIN_CM, *MAIN_DM ); 
      &configure_provisioning_tcf( *MAIN_CM, *MAIN_DM ); 
      &configure_service_order_tcf( *MAIN_CM, *MAIN_DM ); 
      &configure_notify_tcf( *MAIN_CM, *MAIN_DM );
      &configure_permit_map_tcf( *MAIN_CM, *MAIN_DM );
      chdir $CurrentDir;
      }
    	
    ###########################################	
   # Load the pin_telco_tags.
    ####################################################

	sub configure_tags_tcf {
	
        &Output( fpLogFile, $IDS_TCF_TAGS_LOADING );
        &Output( STDOUT, $IDS_TCF_TAGS_LOADING );

   	$Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_tags -dv pin_telco_tags");
  	 $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
    
   	if( $Cmd != 0 ) {
              &Output( fpLogFile, $IDS_TCF_TAGS_FAILED );
              &Output( STDOUT, $IDS_TCF_TAGS_FAILED );
              exit -1;
           } else {
              &Output( fpLogFile, $IDS_TCF_TAGS_SUCCESS );
              &Output( STDOUT, $IDS_TCF_TAGS_SUCCESS );
        }
   	unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
	
	##################################################
	# Load the pin_telco_provisioning.
	##################################################
	
	sub configure_provisioning_tcf {
	
             &Output( fpLogFile, $IDS_TCF_PROV_LOADING );
             &Output( STDOUT, $IDS_TCF_PROV_LOADING );
         
             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_provisioning -dv pin_telco_provisioning");
             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         
             if( $Cmd != 0 ) {
                &Output( fpLogFile, $IDS_TCF_PROV_FAILED );
                &Output( STDOUT, $IDS_TCF_PROV_FAILED );
                exit -1;
             } else {
                &Output( fpLogFile, $IDS_TCF_PROV_SUCCESS );
                &Output( STDOUT, $IDS_TCF_PROV_SUCCESS );
             }

	unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
	
	########################################################
	# Load the pin_telco_service_order_state.
	######################################################
	sub configure_service_order_tcf {
	             &Output( fpLogFile, $IDS_TCF_SERVICE_LOADING );
	             &Output( STDOUT, $IDS_TCF_SERVICE_LOADING );
	         
	             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_service_order_state -dv pin_telco_service_order_state");
	             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
	         
	             if( $Cmd != 0 ) {
	                &Output( fpLogFile, $IDS_TCF_SERVICE_FAILED );
	                &Output( STDOUT, $IDS_TCF_SERVICE_FAILED );
	                exit -1;
	             } else {
	                &Output( fpLogFile, $IDS_TCF_SERVICE_SUCCESS );
	                &Output( STDOUT, $IDS_TCF_SERVICE_SUCCESS );
             }
             unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
	
	 ##################################################
	 # Load the pin_notify_telco.
	 ##################################################
	 sub configure_notify_tcf {
	             &Output( fpLogFile, $IDS_TCF_NOTIFY_LOADING );
	             &Output( STDOUT, $IDS_TCF_NOTIFY_LOADING );
	         
	             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_notify pin_notify_telco");
	             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
	         
	             if( $Cmd != 0 ) {
	                &Output( fpLogFile, $IDS_TCF_NOTIFY_FAILED );
	                &Output( STDOUT, $IDS_TCF_NOTIFY_FAILED );
	                exit -1;
	             } else {
	                &Output( fpLogFile, $IDS_TCF_NOTIFY_SUCCESS );
	                &Output( STDOUT, $IDS_TCF_NOTIFY_SUCCESS );
	             }
             unlink( "$PIN_TEMP_DIR/tmp.out" );
	}

         ##################################################
	 # Load the pin_device_permit_map_num_telco.
	 ##################################################
	 sub configure_permit_map_tcf {
	             &Output( fpLogFile, $IDS_TCF_PERMIT_LOADING );
	             &Output( STDOUT, $IDS_TCF_PERMIT_LOADING );
	         
	             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_device_permit_map pin_device_permit_map_num_telco");
	             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
	         
	             if( $Cmd != 0 ) {
	                &Output( fpLogFile, $IDS_TCF_PERMIT_FAILED );
	                &Output( STDOUT, $IDS_TCF_PERMIT_FAILED );
	                exit -1;
	             } else {
	                &Output( fpLogFile, $IDS_TCF_PERMIT_SUCCESS );
	                &Output( STDOUT, $IDS_TCF_PERMIT_SUCCESS );
	             }
             unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
1;

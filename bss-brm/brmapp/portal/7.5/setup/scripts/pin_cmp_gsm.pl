#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# @(#)$Id: pin_cmp_gsm.pl /cgbubrm_7.5.0.portalbase/1 2014/04/23 17:18:07 vivilin Exp $
#    
# Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
# Portal installation for the GSM Component
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
# Configure GSM Manager pin.conf files
#
##########################################
sub configure_gsm_config_files {
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;
  local ( @FileReadIn );
  local ( $Start );  

  &ReadIn_PinCnf( "pin_cnf_gsm.pl" );
  
  #
  # If the sys/cm/pin.conf is there, add the entries to it.
  # If not, add the entries to the temporary pin.conf file.
  #
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    	open( PINCONFFILE, $CM{'location'}."/".$PINCONF );
    	@FileReadIn = <PINCONFFILE>;
    	close( PINCONFFILE );

	# Search for gsm_manager_fm_required... If not found, we need
	# to add the fm's to the pin.conf file... 
	#
	$Start = &LocateEntry( "gsm_manager_fm_required", @FileReadIn );
	if ( $Start == -1 )  # Entry not created before hence create it.
	{
		&ReplacePinConfEntries( $CM{'location'}."/".$PINCONF, %GSM_MANAGER_CM_PINCONF_ENTRIES );
	}

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

    &ReplacePinConfEntries( $CM{'location'}."/".$PINCONF, %GSM_MANAGER_CM_PINCONF_ENTRIES );

    # Display a message saying to append this file to cm/pin.conf file.
    &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );
    }
}

#####################################
#
# Configuring database for GSM Manager
#
#####################################
sub configure_gsm_database {
  
  require "pin_".$MAIN_DM{'db'}->{'vendor'}."_functions.pl";
  require "pin_cmp_dm_db.pl";
  local ( $TMP ) = $SKIP_INIT_OBJECTS;
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;
  
  &PreModularConfigureDatabase( %CM, %DM );

  #########################################
  # Creating the tables for the GSM Manager
  #########################################
  $SKIP_INIT_OBJECTS = "YES";
  $USE_SPECIAL_DD_FILE = "YES";
  
    if ( VerifyPresenceOfTable( "EVENT_ACTIVITY_SETTLEMENT_T", %{$DM{"db"}} ) == 0 ){
    
    $SPECIAL_DD_FILE = "$DD{'location'}/dd_objects_settlement.source";
    $SPECIAL_DD_DROP_FILE = "$DD{'location'}/drop_tables_settlement_".$MAIN_DM{'db'}->{'vendor'}.".source";
    $SPECIAL_DD_CREATE_INDEXES_FILE = "$DD{'location'}/create_indexes_settlement_".$MAIN_DM{'db'}->{'vendor'}.".source";
  
    if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
       &DropTables( %{MAIN_DM->{"db"}} );
    }
     
    &pin_pre_modular( %{$DM{"db"}} );
    &pin_init( %DM );
    &pin_post_modular( %DM );
    &ExecuteSQL_Statement_From_File( $SPECIAL_DD_CREATE_INDEXES_FILE, TRUE, TRUE, %{$DM{'db'}} );
  }

  if ( VerifyPresenceOfTable( "EVENT_SESSION_TLCO_GSM_T", %{$DM{"db"}} ) == 0 ){
  
  
  $SPECIAL_DD_FILE = "$DD{'location'}/dd_objects_telco_gsm.source";
  $SPECIAL_DD_DROP_FILE = "$DD{'location'}/drop_tables_telco_gsm_".$MAIN_DM{'db'}->{'vendor'}.".source";
  $SPECIAL_DD_CREATE_INDEXES_FILE = "$DD{'location'}/create_indexes_telco_gsm_".$MAIN_DM{'db'}->{'vendor'}.".source";

  if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
    &DropTables( %{MAIN_DM->{"db"}} );
  }

  &pin_pre_modular( %{$DM{"db"}} );
  &pin_init( %DM );
  &pin_post_modular( %DM );
  &ExecuteSQL_Statement_From_File( $SPECIAL_DD_CREATE_INDEXES_FILE, TRUE, TRUE, %{$DM{'db'}} );

  $USE_SPECIAL_DD_FILE = "NO";
  $SKIP_INIT_OBJECTS = $TMP;
  }
  
  #
  # Upgrade from 6.7FP1 to 7.0 
  #
  
  if ( VerifyPresenceOfTable( "ACTIVE_SESSION_TELCO_GSM_T", %{$DM{"db"}} ) == 0 ) {
  
   	    
    	$SKIP_INIT_OBJECTS = "YES";
    	$USE_SPECIAL_DD_FILE = "YES";
    	$SPECIAL_DD_FILE = "$DD{'location'}/6.7_FP1_7.0_dd_objects_telco_gsm.source";
    		 
    	&pin_pre_modular( %{$DM{"db"}} );
    	&pin_init( %DM );
    	&pin_post_modular( %DM );
  
    	$USE_SPECIAL_DD_FILE = "NO";
    	$SKIP_INIT_OBJECTS = $TMP; 

  }  

  #
  # Upgrade from 7.2 to 7.3
  #
  if ( VerifyPresenceOfObject( "/service/telco/gsm/roaming", %{$DM{"db"}} ) == 0 ) {
     	    
    	$SKIP_INIT_OBJECTS = "YES";
    	$USE_SPECIAL_DD_FILE = "YES";
    	$SPECIAL_DD_FILE = "$DD{'location'}/7.2_7.3_dd_objects_telco_gsm.source";
    		 
    	&pin_pre_modular( %{$DM{"db"}} );
    	&pin_init( %DM );
    	&pin_post_modular( %DM );
  
    	$USE_SPECIAL_DD_FILE = "NO";
    	$SKIP_INIT_OBJECTS = $TMP; 
   }

      #
      # If this is an upgrade from 7.2 to 7.3, then /service/settlement/roaming will not be present.
      #
      if ( VerifyPresenceOfObject( "/service/settlement/roaming", %{$DM{"db"}} ) == 0 ){
      
          $SKIP_INIT_OBJECTS = "YES";
    	    $USE_SPECIAL_DD_FILE = "YES";
          $SPECIAL_DD_FILE = "$DD{'location'}/7.2_7.3_dd_objects_settlement.source";        
          
          &pin_pre_modular( %{$DM{"db"}} );
          &pin_init( %DM );
          &pin_post_modular( %DM );
          
       	  $USE_SPECIAL_DD_FILE = "NO";
    	  $SKIP_INIT_OBJECTS = $TMP; 
      }
  &PostModularConfigureDatabase( %CM, %DM );  
}

     #########################################
     # Additional configuration for number manager
     #########################################
     sub configure_gsm_post_restart {
     
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
      &configure_tags( *MAIN_CM, *MAIN_DM ); 
      &configure_provisioning( *MAIN_CM, *MAIN_DM ); 
      &configure_service_order( *MAIN_CM, *MAIN_DM ); 
      &configure_order_state_gsm( *MAIN_CM, *MAIN_DM ); 
      &configure_order_state_fax( *MAIN_CM, *MAIN_DM ); 
      &configure_order_state_sms( *MAIN_CM, *MAIN_DM ); 
      &configure_order_state_tel( *MAIN_CM, *MAIN_DM ); 
      &configure_permit_map_num( *MAIN_CM, *MAIN_DM ); 
      &configure_permit_map_sim( *MAIN_CM, *MAIN_DM ); 

      chdir $CurrentDir;
      }


 ####################################################
 # Load the pin_telco_tags_gsm.
 #################################################       
        sub configure_tags {
	
        &Output( fpLogFile, $IDS_GSM_TAGS_LOADING );
        &Output( STDOUT, $IDS_GSM_TAGS_LOADING );
    
        $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_tags -dv pin_telco_tags_gsm");
        $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
    
        if( $Cmd != 0 ) {
           &Output( fpLogFile, $IDS_GSM_TAGS_FAILED );
           &Output( STDOUT, $IDS_GSM_TAGS_FAILED );
           exit -1;
        } else {
           &Output( fpLogFile, $IDS_GSM_TAGS_SUCCESS );
           &Output( STDOUT, $IDS_GSM_TAGS_SUCCESS );
        }
      unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
     
   ##################################################
   # Load the pin_telco_provisioning_gsm.
   ##################################################
   
      sub configure_provisioning {
	
             &Output( fpLogFile, $IDS_GSM_PROVISIONING_LOADING );
             &Output( STDOUT, $IDS_GSM_PROVISIONING_LOADING );
         
             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_provisioning -dv pin_telco_provisioning_gsm");
             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         
             if( $Cmd != 0 ) {
                &Output( fpLogFile, $IDS_GSM_PROVISIONING_FAILED );
                &Output( STDOUT, $IDS_GSM_PROVISIONING_FAILED );
                exit -1;
             } else {
                &Output( fpLogFile, $IDS_GSM_PROVISIONING_SUCCESS );
                &Output( STDOUT, $IDS_GSM_PROVISIONING_SUCCESS );
             }
         unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
     
    #####################################################
    # Load the pin_telco_service_order_state_gsm.
    #####################################################
      
      sub configure_service_order {
	
             &Output( fpLogFile, $IDS_GSM_SERVICE_LOADING );
             &Output( STDOUT, $IDS_GSM_SERVICE_LOADING );
         
             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_service_order_state -dv pin_telco_service_order_state_gsm");
             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         
             if( $Cmd != 0 ) {
                &Output( fpLogFile, $IDS_GSM_SERVICE_FAILED );
                &Output( STDOUT, $IDS_GSM_SERVICE_FAILED );
                exit -1;
             } else {
                &Output( fpLogFile, $IDS_GSM_SERVICE_SUCCESS );
                &Output( STDOUT, $IDS_GSM_SERVICE_SUCCESS );
             }
    unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
     
     #####################################################
     # Load the pin_telco_service_order_state_gsm_data.
     #####################################################
      
      sub configure_order_state_gsm {
	
             &Output( fpLogFile, $IDS_GSM_ORDER_STATE_LOADING );
             &Output( STDOUT, $IDS_GSM_ORDER_STATE_LOADING );
         
             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_service_order_state -dv pin_telco_service_order_state_gsm_data");
             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         
             if( $Cmd != 0 ) {
                &Output( fpLogFile, $IDS_GSM_ORDER_STATE_FAILED );
                &Output( STDOUT, $IDS_GSM_ORDER_STATE_FAILED );
                exit -1;
             } else {
                &Output( fpLogFile, $IDS_GSM_ORDER_STATE_SUCCESS );
                &Output( STDOUT, $IDS_GSM_ORDER_STATE_SUCCESS );
             }
             unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
	
     ##################################################
     # Load the pin_telco_service_order_state_gsm_fax.
     ##################################################
     
     sub configure_order_state_fax {
	
             &Output( fpLogFile, $IDS_GSM_ORDER_STATE_FAX_LOADING );
             &Output( STDOUT, $IDS_GSM_ORDER_STATE_FAX_LOADING );
         
             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_service_order_state -dv pin_telco_service_order_state_gsm_fax");
             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         
             if( $Cmd != 0 ) {
                &Output( fpLogFile, $IDS_GSM_ORDER_STATE_FAX_FAILED );
                &Output( STDOUT, $IDS_GSM_ORDER_STATE_FAX_FAILED );
                exit -1;
             } else {
                &Output( fpLogFile, $IDS_GSM_ORDER_STATE_FAX_SUCCESS );
                &Output( STDOUT, $IDS_GSM_ORDER_STATE_FAX_SUCCESS );
             }
	unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
	
 #####################################################
 # Load the pin_telco_service_order_state_gsm_sms.
 ###################################################
 
 
 sub configure_order_state_sms {
	
             &Output( fpLogFile, $IDS_GSM_ORDER_STATE_SMS_LOADING );
             &Output( STDOUT, $IDS_GSM_ORDER_STATE_SMS_LOADING );
         
             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_service_order_state -dv pin_telco_service_order_state_gsm_sms");
             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         
             if( $Cmd != 0 ) {
                &Output( fpLogFile, $IDS_GSM_ORDER_STATE_SMS_FAILED );
                &Output( STDOUT, $IDS_GSM_ORDER_STATE_SMS_FAILED );
                exit -1;
             } else {
                &Output( fpLogFile, $IDS_GSM_ORDER_STATE_SMS_SUCCESS );
                &Output( STDOUT, $IDS_GSM_ORDER_STATE_SMS_SUCCESS );
             }
             unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
             
#############################################################
 # Load the pin_telco_service_order_state_gsm_telephony.
 ###########################################################
 
 sub configure_order_state_tel {
	
             &Output( fpLogFile, $IDS_GSM_ORDER_STATE_TELEPHONY_LOADING );
             &Output( STDOUT, $IDS_GSM_ORDER_STATE_TELEPHONY_LOADING );
         
             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_telco_service_order_state -dv pin_telco_service_order_state_gsm_telephony");
             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         
             if( $Cmd != 0 ) {
                &Output( fpLogFile, $IDS_GSM_ORDER_STATE_TELEPHONY_FAILED );
                &Output( STDOUT, $IDS_GSM_ORDER_STATE_TELEPHONY_FAILED );
                exit -1;
             } else {
                &Output( fpLogFile, $IDS_GSM_ORDER_STATE_TELEPHONY_SUCCESS );
                &Output( STDOUT, $IDS_GSM_ORDER_STATE_TELEPHONY_SUCCESS );
             }
     unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
     
   ############################################################  
  # Load the pin_device_permit_map_num_telco_gsm.
  ############################################################
  
  sub configure_permit_map_num {
	
             &Output( fpLogFile, $IDS_GSM_PERMIT_MAP_NUM_LOADING );
             &Output( STDOUT, $IDS_GSM_PERMIT_MAP_NUM_LOADING );
         
             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_device_permit_map pin_device_permit_map_num_telco_gsm");
             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         
             if( $Cmd != 0 ) {
                &Output( fpLogFile, $IDS_GSM_PERMIT_MAP_NUM_FAILED );
                &Output( STDOUT, $IDS_GSM_PERMIT_MAP_NUM_FAILED );
                exit -1;
             } else {
                &Output( fpLogFile, $IDS_GSM_PERMIT_MAP_NUM_SUCCESS );
                &Output( STDOUT, $IDS_GSM_PERMIT_MAP_NUM_SUCCESS );
             }
     unlink( "$PIN_TEMP_DIR/tmp.out" );
	}
	
###########################################################
# Load the pin_device_permit_map_sim_telco_gsm.
############################################################

sub configure_permit_map_sim {
	
             &Output( fpLogFile, $IDS_GSM_PERMIT_MAP_SIM_LOADING );
             &Output( STDOUT, $IDS_GSM_PERMIT_MAP_SIM_LOADING );
         
             $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_device_permit_map pin_device_permit_map_sim_telco_gsm");
             $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         
             if( $Cmd != 0 ) {
                &Output( fpLogFile, $IDS_GSM_PERMIT_MAP_SIM_FAILED );
                &Output( STDOUT, $IDS_GSM_PERMIT_MAP_SIM_FAILED );
                exit -1;
             } else {
                &Output( fpLogFile, $IDS_GSM_PERMIT_MAP_SIM_SUCCESS );
                &Output( STDOUT, $IDS_GSM_PERMIT_MAP_SIM_SUCCESS );
             }
           unlink( "$PIN_TEMP_DIR/tmp.out" );
	}


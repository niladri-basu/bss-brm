#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#) % %
# 
# Copyright (c) 2003, 2009, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
# Portal installation for the ARA_FrameWork Component
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
# Configure ARA_FrameWork Manager pin.conf files
#
##########################################
sub configure_araframework_config_files {
  %CM = %MAIN_CM;
  %DM = %MAIN_DM;
  local ( @FileReadIn );
  local ( $Start );  

  &ReadIn_PinCnf( "pin_cnf_araframework.pl" );
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  

# If the sys/cm/pin.conf is there, add the entries to it.
# If not, add the entries to the temporary pin.conf file.

  if ( -f $CM{'location'}."/".$PINCONF )
  {
   	open( PINCONFFILE, $CM{'location'}."/".$PINCONF );
   	@FileReadIn = <PINCONFFILE>;
   	close( PINCONFFILE );

	# Search for araframework_fm_required... If not found, we need
	# to add the araframework fm's to the pin.conf file... We also
	#
	$Start = &LocateEntry( "process_audit_manager_fm_required", @FileReadIn );
	if ( $Start == -1 )  # Entry not created before hence create it.
	{
		&AddArrays( \%ARA_FRAMEWORK_CM_PINCONF_ENTRIES);
	}

	&AddPinConfEntries( $CM{'location'}."/".$PINCONF, %ARA_FRAMEWORK_CM_PINCONF_ENTRIES );

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

    &AddPinConfEntries( "$TEMP_PIN_CONF_FILE", %ARA_FRAMEWORK_CM_PINCONF_ENTRIES );

    # Display a message saying to append this file to cm/pin.conf file.
   &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                       $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );

   }
   
	 #
	 #  Configure pin.conf for the pin_ra_check_thresholds entries...
	 #
	 
         # Add CM entries and pin_ra_check_thresholds entries
         &AddArrays( \%CONNECT_PINCONF_ENTRIES, \%RA_CHECK_THRESHOLDS_PINCONF_ENTRIES );
   
  	 # Create pin.conf entry in the pin_ra_check_thresholds directory
  	 &Configure_PinCnf( $RRF{'thresholds_location'}."/".$PINCONF,
                     $RA_CHECK_THRESHOLDS_HEADER,
                     %RA_CHECK_THRESHOLDS_PINCONF_ENTRIES );  


   #To include enable_ara pinconf entry for /apps/pin_billd/pin.conf,/apps/pin_trial_bill/pin.conf and /apps/pin_inv/pin.conf
   
   if ( -f $BILLING{'location'}."/".$PINCONF ) {
     &AddPinConfEntries( $BILLING{'location'}."/".$PINCONF, %RA_ENABLE_ERA_PINCONF_ENTRIES );
   }

   if ( -f $PIN_INV{'location'}."/".$PINCONF ) {
     &AddPinConfEntries( $PIN_INV{'location'}."/".$PINCONF, %RA_ENABLE_ERA_PINCONF_ENTRIES );
   }

   if ( -f $TB{'location'}."/".$PINCONF ) {
     &AddPinConfEntries( $TB{'location'}."/".$PINCONF, %RA_ENABLE_ERA_PINCONF_ENTRIES );
   }

}

#####################################
#
# Configuring database for ARA_FRAMEWORK Manager
#
#####################################
sub configure_araframework_database {
  
  require "pin_".$MAIN_DM{'db'}->{'vendor'}."_functions.pl";
  require "pin_cmp_dm_db.pl";
  local ( $TMP ) = $SKIP_INIT_OBJECTS;
  local ( %CM ) = %MAIN_CM;
  local ( %DM ) = %MAIN_DM;
  
  #
  # If this is the first time RAR is installed, then
  # the proc_aud_bstat_t table will NOT be present.
  # Hence call the full dd script to create the new fields and tables.
   
  if ( VerifyPresenceOfTable( "PROC_AUD_BSTAT_T", %{%DM->{"db"}} ) == 0 ){
    
        &PreModularConfigureDatabase( %CM, %DM );
  
    	$SKIP_INIT_OBJECTS = "YES";
    	$USE_SPECIAL_DD_FILE = "YES";
    	
    	$SPECIAL_DD_DROP_INDEXES_FILE = "$DD{'location'}/drop_indexes_revenue_assurance_".$MAIN_DM{'db'}->{'vendor'}.".source";
    	$SPECIAL_DD_DROP_FILE = "$DD{'location'}/drop_tables_process_audit_".$MAIN_DM{'db'}->{'vendor'}.".source";
	$SPECIAL_DD_FILE = "$DD{'location'}/dd_objects_process_audit.source";
	$SPECIAL_DD_CREATE_INDEXES_FILE = "$DD{'location'}/create_indexes_revenue_assurance_".$MAIN_DM{'db'}->{'vendor'}.".source";

	&ExecuteSQL_Statement_From_File( $SPECIAL_DD_DROP_INDEXES_FILE, TRUE, TRUE, %{%DM->{'db'}} );

	if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
		&DropTables( %{MAIN_DM->{"db"}} );
	}

	&pin_pre_modular( %{%DM->{"db"}} );
	&pin_init( %DM );
	&pin_post_modular( %DM );

	$USE_SPECIAL_DD_FILE = "NO";
	$SKIP_INIT_OBJECTS = $TMP;
	
	&ExecuteSQL_Statement_From_File( $SPECIAL_DD_CREATE_INDEXES_FILE, TRUE, TRUE, %{%DM->{'db'}} );

	&PostModularConfigureDatabase( %CM, %DM );
    
  }
  
  #
  # If this is an upgrade install from Version RAR 2.0 to 3.0
  # the config_ra_alerts_t table will NOT be present.
  # Hence call the upgrade script to create the new field and table.
  #
  if ( VerifyPresenceOfTable( "CONFIG_RA_ALERTS_T", %{%DM->{"db"}} ) == 0 ){
    
    	&PreModularConfigureDatabase( %CM, %DM );

    	print "Updating RAR DB Schema\n";
    	$SKIP_INIT_OBJECTS = "YES";
    	$USE_SPECIAL_DD_FILE = "YES";
  	
    	$SPECIAL_DD_FILE = "$DD{'location'}/20_30_dd_objects_process_audit_delta.source";
   
    	&pin_pre_modular( %{%DM->{"db"}} );
    	&pin_init( %DM );
    	&pin_post_modular( %DM );
    
    	$USE_SPECIAL_DD_FILE = "NO";
    	$SKIP_INIT_OBJECTS = $TMP;

    	&PostModularConfigureDatabase( %CM, %DM );

  } 


  #
  # Set name for the create procedures based on Database
  #
  if ( $DM{'db'}->{'vendor'} =~ /^oracle$/ ) {
        $CREATE_PROCEDURES_FILE = "create_pkg_auditrevenue_pack.plb";
  }
  
  if ( $DM{'db'}->{'vendor'} =~ /^odbc$/ ) {
          $CREATE_PROCEDURES_FILE = "create_pkg_auditrevenue_pack_sql.source";
  }

# As DB2 and SQL is not supported as of now this part is commented
# This part can be uncommented once we start supporting it

#  else{
#        $CREATE_PROCEDURES_FILE = "create_procedures_$DM{'sm_charset'}.source";
#  }


#
# The stored procedures for each DB is loaded differently.
# Oracle has a plb file and DB2 has a delimiter. Hence each is
# loaded differently.
#
  if ( $DM{'db'}->{'vendor'} =~ /^odbc$/ ) {
    &ExecuteSQL_Statement_From_File( "$DD{'location'}/$CREATE_PROCEDURES_FILE",
                                     TRUE,
                                     TRUE,
                                     %{%DM->{'db'}} );
  }
#  elsif ( $DM{'db'}->{'vendor'} =~ /^oracle$/ ){
	
	if ( $DM{'db'}->{'vendor'} =~ /^oracle$/ ){
		&ExecutePLB_file ( "$DM_ORACLE{'location'}/data/$CREATE_PROCEDURES_FILE",
					  "Infranet Stored Procedures",
					  %DM );
		&ExecutePLB_file ( "$DD{'location'}/create_pkg_ra_search_pack.plb",
					  "RA SEARCH PACK Stored Procedures",
					  %DM );				  
	}

#  elsif ( $DM{'db'}->{'vendor'} =~ /^db2$/ )
#  {
#    &ExecuteSQL_Statement_From_File_with_delimiter( "$DD{'location'}/$CREATE_PROCEDURES_FILE",
#                                     TRUE,
#                                     TRUE,
#                                     %{%DM->{'db'}} );
#  }

 }


#########################################
# Additional configuration for ARA_FrameWork
#########################################
 sub configure_araframework_post_restart {     
     local ( %CM ) = %MAIN_CM;
     local( %DM ) = %MAIN_DM;     
     &ReadIn_PinCnf( "pin_cnf_connect.pl" );     
    
     &configure_ra_controlpoint_link( *MAIN_CM, *MAIN_DM ); 
 }

   ################################################
   # Load the pin_config_controlpoint_link.
   ##################################################
    sub configure_ra_controlpoint_link {
       &Output( fpLogFile, $IDS_RA_CONTROLPOINT_LOADING );
       &Output( STDOUT, $IDS_RA_CONTROLPOINT_LOADING );
            
       $Cmd = &FixSlashes( "$PIN_HOME/bin/load_pin_config_controlpoint_link \"$PIN_HOME/sys/data/config/pin_config_controlpoint_link\"");
       $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
        
       if( $Cmd != 0 ) {
           &Output( fpLogFile, $IDS_RA_CONTROLPOINT_FAILED );
           &Output( STDOUT, $IDS_RA_CONTROLPOINT_FAILED );
           exit -1;
       } else {
    	   &Output( fpLogFile, $IDS_RA_CONTROLPOINT_SUCCESS );
  	   &Output( STDOUT, $IDS_RA_CONTROLPOINT_SUCCESS );
       }
           unlink( "$PIN_TEMP_DIR/tmp.out" )
    }
                                

#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_dm_aq.pl
# 
# Copyright (c) 2014, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the dm_aq Component
#
#=============================================================

use Cwd;
use aes;

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}
   require "pin_modular_functions.pl";


#########################################
# Configure DM AQ pin.conf files
#########################################
sub configure_dm_aq_64_config_files {
  local ( %DM ) = %DM_AQ;
  local ( %CM ) = %MAIN_CM;
  local( $Cmd );
  local ( $publish_db_num ) = $DM_AQ{'db_num'};
  local ( $publish_format ) = "XML";
  local ( $XMLFile );
  local ( $EAI_JS_Previously_Installed ) = "No";
  local ( $i );
  local ( $Current_Dir ) = cwd();
  
# This feature is currently supported only in Unix. This need not run on Windows.
  if ( $^O =~ /win/i ) {
    return;
  }

  &ReadIn_PinCnf( "pin_cnf_dm.pl" );
  &ReadIn_PinCnf( "pin_cnf_dm_aq_64.pl" );

  &AddArrays( \%DM_PINCONF_ENTRIES, \%DM_AQ_PINCONF_ENTRIES );

  #
  #  Configure sys/dm_aq/pin.conf ...
  #
  &Configure_PinCnf( $DM_AQ{'pin_cnf_location'}."/".$PINCONF,
                     $DM_AQ_PINCONF_HEADER,
                     %DM_AQ_PINCONF_ENTRIES );

  #
  #  Configure sys/dm_aq/pin.conf 64 bit sm_obj entry ...
  #
  &ReplacePinConfEntry( $DM_AQ{'pin_cnf_location'}."/".$PINCONF,
                        "dm_sm_obj",
                        "- dm dm_sm_obj $DM_AQ_64{'library'}" );

  # If the sys/cm/pin.conf is there, add the entries to it.
  # If not, add the entries to the temporary pin.conf file.
  #
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    &ReplacePinConfEntries( $CM{'location'}."/".$PINCONF, %DM_AQ_CM_PINCONF_ENTRIES );
        
    # Display a message current component entries are appended to cm/pin.conf file.
    &Output( STDOUT, $IDS_CM_PIN_CONF_APPEND_SUCCESS,
    			$CurrentComponent,
   			$CM{'location'}."/".$PINCONF);       
  }
  else
  {
    &ReplacePinConfEntries( "$TEMP_PIN_CONF_FILE", %DM_AQ_CM_PINCONF_ENTRIES );

    # Display a message saying to append this file to cm/pin.conf file.
    &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );
  }                    

#
# Update create_dm_aq_queue.conf with the user input for tablespace and retention time
#
  local( $ConfFile ) = &FixSlashes( "$PIN_HOME/apps/pin_aq/create_sync_queue.conf" );
  open ( CONFFILE, "+< $ConfFile" ) || die( "Can't open $ConfFile" );

  seek( CONFFILE, 0, 0 );
  $out = '';
  while ( <CONFFILE> )
  {
	s /__TABLESPACE_NAME__/$DM_AQ{queuing_tablespace}/ ;
	s /__RETENTION_TIME__/$DM_AQ{retention_time}/ ;
	$out .= $_;
  }
  seek( CONFFILE, 0, 0 );
  print CONFFILE $out;
  truncate( CONFFILE, tell(CONFFILE ) );
  close( CONFFILE );
  
  #
  #  Configure payloadconfig_collections.xml with current values ...
  #
          $i = 0;
	  open( XML_FILE, "+< $EAI{'eai_js_location'}/payloadconfig_collections.xml" ) || die( "Can't open $EAI{'eai_js_location'}/payloadconfig_collections.xml" );
	  @Array_XML = <XML_FILE>;
	  seek( XML_FILE, 0, 0 );

	  while ( <XML_FILE> )
  	  {
		    $_ =~ s/Publisher DB.*/Publisher DB=\"$publish_db_num\" Format=\"$publish_format\"\>/i;
		    $Array_XML[$i++] = $_;
  	  }
  	  seek( XML_FILE, 0, 0 );
  	  print XML_FILE @Array_XML;
  	  print XML_FILE "\n";
  	  truncate( XML_FILE, tell( XML_FILE ) );
  	  close( XML_FILE );


#
    # Configure EAI_JS/infranet.properties and payloadconfig crm_sync file.
    # Return value from Cofigure_EAI_Payload is ignored.
    #

    &Configure_EAI_Payload ("payloadconfig_crm_sync.xml",
                          "payloadconfig_MergedWithCRMSync.xml",
                          $DM_AQ{'db_num'},
                          "XML");

}

#########################################
# Additional configuration for DM_AQ Data Manager
#########################################
sub configure_dm_aq_64_database {
  local( $Cmd );
  local ($Dir);
  local( $perlcmd );
  local ($TEMP) = getcwd();  # get current working directory
  $Cmd = "$PIN_HOME/apps/pin_aq";
  chdir($Cmd) || print "\n*** Error: can not change directory to $Cmd.\n\n";
   if ( ($ENABLE_ENCRYPTION eq "Yes") && ($DM_AQ{'queuing_db_password'}=~m/aes/)){
       $DM_AQ{'queuing_db_password'} = psiu_perl_decrypt_pw($DM_AQ{'queuing_db_password'});
   }  
   #
   # Run pin_portal_sync script to create the default queue
   #
   
   #This will replaced during install time.
   $perlcmd = '/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl';
   
   if ( $MAIN_DM{'db'}->{'vendor'} =~ /oracle/i ) {
   	$Cmd = "$perlcmd pin_portal_sync_oracle.pl create -l $DM_AQ{'queuing_db_user'}/$DM_AQ{'queuing_db_password'}\@$DM_AQ{'queuing_db_alias'}";
   	&Output( fpLogFile, $IDS_DM_AQ_QUEUE_CREATION );
   	&Output( STDOUT, $IDS_DM_AQ_QUEUE_CREATION );
   }
  
   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_DM_AQ_QUEUE_CREATION_FAILED );
      &Output( STDOUT,$IDS_DM_AQ_QUEUE_CREATION_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_DM_AQ_QUEUE_CREATION_SUCCESS );
      &Output( STDOUT, $IDS_DM_AQ_QUEUE_CREATION_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
   chdir($TEMP) || print "\n*** Error: can not change directory to $TEMP.\n\n";
   	
}


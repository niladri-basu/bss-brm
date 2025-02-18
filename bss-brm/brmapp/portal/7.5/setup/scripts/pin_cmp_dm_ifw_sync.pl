#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_dm_ifw_sync.pl:PortalBase7.3.1Int:2:2007-Sep-06 01:45:54 %
# 
# Copyright (c) 2002, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the dm_ifw_sync Component
#
#=============================================================

use Cwd;
use aes;

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "pin_modular_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}


#########################################
# Configure DM IFW Sync pin.conf files
#########################################
sub configure_dm_ifw_sync_config_files {
  local ( %DM ) = %DM_IFW_SYNC;
  local ( %CM ) = %MAIN_CM;
  local( $Cmd );

  &ReadIn_PinCnf( "pin_cnf_dm.pl" );
  &ReadIn_PinCnf( "pin_cnf_acctsync.pl" );

  if ( $MAIN_DM{'db'}->{'vendor'} =~ /oracle/i ) {
  	&AddArrays( \%DM_PINCONF_ENTRIES, \%ACCTSYNC_PINCONF_ENTRIES_COMMON );
  	&AddArrays( \%ACCTSYNC_PINCONF_ENTRIES_ORACLE, \%ACCTSYNC_PINCONF_ENTRIES_COMMON );
  }
  else {
  	&AddArrays( \%DM_PINCONF_ENTRIES, \%ACCTSYNC_PINCONF_ENTRIES_COMMON );
  	&AddArrays( \%ACCTSYNC_PINCONF_ENTRIES_SQLSERVER, \%ACCTSYNC_PINCONF_ENTRIES_COMMON );
  }
  
  #
  #  Configure sys/dm_ifw_sync/pin.conf ...
  #
  &Configure_PinCnf( $DM_IFW_SYNC{'pin_cnf_location'}."/".$PINCONF,
                     $ACCTSYNC_PINCONF_HEADER,
                     %ACCTSYNC_PINCONF_ENTRIES_COMMON );

#
# Create a link for the correct version of the dm_ifw_sync file for HPUX
#
if ( $^O =~ /hpux/i ){
        if ( $DM_IFW_SYNC{'oracle_version'} eq "10g" ){
		$Cmd =&FixSlashes( "ln -s $PIN_HOME/bin/dm_ifw_sync10g $PIN_HOME/bin/dm_ifw_sync");
		&ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         }         
        elsif ( $DM_IFW_SYNC{'oracle_version'} eq "11g" ){
		$Cmd =&FixSlashes( "ln -s $PIN_HOME/bin/dm_ifw_sync11g $PIN_HOME/bin/dm_ifw_sync");
		&ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
         }         
        unlink( "$PIN_TEMP_DIR/tmp.out" );
  }

#
# Update create_ifw_sync_queue.conf with the user input for tablespace and retention time
#
  local( $ConfFile ) = &FixSlashes( "$PIN_HOME/apps/pin_ifw_sync/create_ifw_sync_queue.conf" );
  open ( CONFFILE, "+< $ConfFile" ) || die( "Can't open $ConfFile" );

  seek( CONFFILE, 0, 0 );
  $out = '';
  while ( <CONFFILE> )
  {
	s /__TABLESPACE_NAME__/$DM_IFW_SYNC{queuing_tablespace}/ ;
	s /__RETENTION_TIME__/$DM_IFW_SYNC{retention_time}/ ;
	$out .= $_;
  }
  seek( CONFFILE, 0, 0 );
  print CONFFILE $out;
  truncate( CONFFILE, tell(CONFFILE ) );
  close( CONFFILE );
  
  #
  # Configure EAI_JS/infranet.properties and payloadconfig file.
  # Return value from Cofigure_EAI_Payload is ignored.
  #
  require "pin_modular_functions.pl";
  &Configure_EAI_Payload ("payloadconfig_ifw_sync.xml", 
			  "payloadconfig_MergedWithIfwSync.xml",
			  $DM_IFW_SYNC{'db_num'},
			  "FLIST");
  
}

#########################################
# Additional configuration for IFW Sync Data Manager
#########################################
sub configure_dm_ifw_sync_database {
  local( $Cmd );
  local ($Dir);
  local( $perlcmd );
  local ($TEMP) = getcwd();  # get current working directory
  $Cmd = "$PIN_HOME/apps/pin_ifw_sync";
  chdir($Cmd) || print "\n*** Error: can not change directory to $Cmd.\n\n";
  
  #This will decrypt dm_ifw_sync queue database password
  if ( ($ENABLE_ENCRYPTION eq "Yes") && ($DM_IFW_SYNC{'queuing_db_password'}=~m/aes/)){
       $DM_IFW_SYNC{'queuing_db_password'} = psiu_perl_decrypt_pw($DM_IFW_SYNC{'queuing_db_password'});
  } 
   #
   # Run pin_ifw_sync script to create the default queue
   #
   
   #This will replaced during install time.
   $perlcmd = '/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl';
   
   if ( $MAIN_DM{'db'}->{'vendor'} =~ /oracle/i ) {
   	$Cmd = "$perlcmd pin_ifw_sync_oracle.pl create -l $DM_IFW_SYNC{'queuing_db_user'}/$DM_IFW_SYNC{'queuing_db_password'}\@$DM_IFW_SYNC{'queuing_db_alias'}";
   	&Output( fpLogFile, $IDS_IFW_SYNC_QUEUE_CREATION );
   	&Output( STDOUT, $IDS_IFW_SYNC_QUEUE_CREATION );
   }
   else
   {
   	$Cmd = "$perlcmd pin_ifw_sync_odbc.pl create -q IFW_SYNC_QUEUE -s $DM_IFW_SYNC{'hostname'}";
   	&Output( fpLogFile, $IDS_IFW_SYNC_QUEUE_CREATION );
   	&Output( STDOUT, $IDS_IFW_SYNC_QUEUE_CREATION );
   }
   
   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_IFW_SYNC_QUEUE_CREATION_FAILED );
      &Output( STDOUT,$IDS_IFW_SYNC_QUEUE_CREATION_FAILED );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_IFW_SYNC_QUEUE_CREATION_SUCCESS );
      &Output( STDOUT, $IDS_IFW_SYNC_QUEUE_CREATION_SUCCESS );
   }
   unlink( "$PIN_TEMP_DIR/tmp.out" );
   chdir($TEMP) || print "\n*** Error: can not change directory to $TEMP.\n\n";
   	
}

#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)% %
# Copyright (c) 2003, 2009, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation 
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or 
#       sublicense agreement.
#
# Script to create indexes for the audit tables.
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


&execute_pin_history_on( );
&create_audit_indexes( );

#
# Run the pin_history_on utility.
#

sub execute_pin_history_on {

   local ( %CM ) = %MAIN_CM;
   local ( %DM ) = %MAIN_DM;  
   local( $Cmd );
   local( $CurrentDir ) = cwd();
   
   &ReadIn_PinCnf( "pin_cnf_connect.pl" );
   if (! -e "./".$PINCONF )
   {
       &Configure_PinCnf( "./".$PINCONF,
                          $CONNECT_PINCONF_HEADER,
                          %CONNECT_PINCONF_ENTRIES );
   }                   

   &PreModularConfigureDatabase( %CM, %DM );
   
   &Start ( $ServiceName{'dm_'.$DM{'db'}->{'vendor'}} );
   sleep ( 10 );
   &Start( $ServiceName{ "cm" } );
   sleep( 20 );  
   
   $Cmd = &FixSlashes( "$PIN_HOME/bin/pin_history_on -v $PIN_HOME/apps/integrate_sync/pin_history_on_input" );

   &Output( fpLogFile, $IDS_HISTORY_ON_LOADING );
   &Output( STDOUT, $IDS_HISTORY_ON_LOADING );

   $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );

   if( $Cmd != 0 ) {
      &Output( fpLogFile, $IDS_HISTORY_ON_FAILED );
      &Output( STDOUT, $IDS_HISTORY_ON_FAILED );
      &PostModularConfigureDatabase( %CM, %DM );
      exit -1;
   } else {
      &Output( fpLogFile, $IDS_HISTORY_ON_SUCCESS );
      &Output( STDOUT, $IDS_HISTORY_ON_SUCCESS );
   }
   
   &Stop( $ServiceName{ "cm" } );
   sleep ( 10 );
   &Stop( $ServiceName{ "dm_$MAIN_DM{'db'}->{'vendor'}" } );
   sleep ( 10 );
   
   unlink( "$PIN_TEMP_DIR/tmp.out" );
   &PostModularConfigureDatabase( %CM, %DM );
}


#
# Create indexes only for the Oracle database,
# since IFW Sync is not supported for SQL Server.
#
sub create_audit_indexes {
     
	local ( %DM ) = %MAIN_DM;
	require "pin_".$MAIN_DM{'db'}->{'vendor'}."_functions.pl";
	
	if ( $DM{'delimiter'} =~ /^$/ )
	{
		&ExecuteSQL_Statement_From_File("$DD{'location'}/create_indexes_audit_tables_".$MAIN_DM{'db'}->{'vendor'}.".source",
		TRUE, 
		TRUE, 
		%{%DM->{'db'}} );
	}
	else
	{
		&ExecuteSQL_Statement_From_File_with_delimiter("$DD{'location'}/create_indexes_audit_tables_".$MAIN_DM{'db'}->{'vendor'}.".source",
		TRUE, 
		TRUE, 
		%{%DM->{'db'}} );
	}
}    

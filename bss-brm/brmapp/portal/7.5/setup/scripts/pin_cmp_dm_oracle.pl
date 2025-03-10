#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# @(#)$Id: pin_cmp_dm_oracle.pl /cgbubrm_7.5.0.portalbase/6 2014/04/23 17:18:07 vivilin Exp $
# 
# Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the DM_ORACLE Component
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

require "pin_cmp_virtual_col.pl";

#######
#
# Configuring DM_ORACLE files
#
#######
sub configure_dm_oracle_config_files {
  %DM = %DM_ORACLE;
  local ( $ReadIn );
  &ReadIn_PinCnf( "pin_cnf_dm.pl" );
  &ReadIn_PinCnf( "pin_cnf_connect.pl" );
  
  # create sample pin.conf with default CM entries in the setup/scripts directory.
  &Configure_PinCnf( "$PIN_HOME/setup/scripts/$PINCONF",
                     $CONNECT_PINCONF_HEADER,
                     %CONNECT_PINCONF_ENTRIES );

  $DM_ORACLE_PINCONF_HEADER = $DM_PINCONF_HEADER;
  &ReadIn_PinCnf( "pin_cnf_dm_db.pl" );
  &AddArrays( \%DM_ORACLE_DB_PINCONF_ENTRIES, \%DM_DB_PINCONF_ENTRIES );
  &AddArrays( \%DM_PINCONF_ENTRIES, \%DM_DB_PINCONF_ENTRIES );

  &Configure_PinCnf( $DM_ORACLE{'location'}."/".$PINCONF, 
                     $DM_ORACLE_PINCONF_HEADER, 
                     %DM_DB_PINCONF_ENTRIES ); 
                     
  #
  # update pin_ctl.conf
  #
 
    &ReplacePinCtlConfEntries( "${PIN_HOME}/bin/pin_ctl.conf", 
			"__DM_ORACLE_PORT__",
			"$DM_ORACLE{'port'}" );
}


#######
#
# Configuring database for DM_ORACLE
#
#######
sub configure_dm_oracle_database {
  require "pin_oracle_functions.pl";
  require "pin_cmp_dm_db.pl";

  %DM = %DM_ORACLE;
  local ( %DB ) = %{$DM_ORACLE{"db"}};

  if ( $CREATE_DATABASE_TABLES =~ /YES/i )
  {
	# Create the Portal database tablespaces
	&InitializeDatabase ( %DB );
  }

  # Confirm that we can login to the database as the Portal user
  &VerifyLogin( "portal", %DB );

  $DM_ORACLE{'db'}->{'vendor'} = "oracle";

  if ( &VerifyPresenceOfData( %{$DM_ORACLE{"db"}} ) == -1 )  {
    if ( $SETUP_DROP_ALL_TABLES =~ m/^YES$/i ) {
	&DropTables( %{$DM_ORACLE{"db"}} );

	# Drop "PIN_PARTITION" package 
	&ExecuteSQL_Statement("drop package PIN_PARTITION;", TRUE, TRUE, %DB );

	# Drop "PIN_VIRTUAL_COLUMNS" package 
	&ExecuteSQL_Statement("drop package PIN_VIRTUAL_COLUMNS;", TRUE, TRUE, %DB );
    } 
  }


  #
  # Make sure everything is writeable
  #
  &ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, 
			"dd_write_enable_fields",
			"- dm dd_write_enable_fields 1" );
  &ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, 
			"dd_write_enable_objects",
			"- dm dd_write_enable_objects 1" );
  &ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, 
			"dd_write_enable_portal_objects",
			"- dm dd_write_enable_portal_objects 1" );
  &ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, 
			"dd_mark_as_portal",
			"- dm dd_mark_as_portal 1" );
  &ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, 
			"stmt_cache_entries",
			"- dm stmt_cache_entries 0" );

  &pin_pre_init( %{$DM_ORACLE{"db"}} );
  # Add Virtual Columns to database
  &AddVirtualColumns( %{$DM_ORACLE{"db"}} );
  &pin_init( %DM_ORACLE );
  &ExecutePLB_file ("$DM_ORACLE{'location'}/data/create_pkg_pin_sequence_oracle.plb",
		    "Portal PIN Sequence",
		    %DM_ORACLE );
  &pin_post_init( %DM_ORACLE );
  &pin_create_event_essential( %DM_ORACLE );

  #
  # Make sure everything is back to normal
  #
  &ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, 
			"dd_write_enable_fields",
			"- dm dd_write_enable_fields $DM_ORACLE{'enable_write_fields'}" );
  &ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, 
			"dd_write_enable_objects",
			"- dm dd_write_enable_objects $DM_ORACLE{'enable_write_objects'}" );
  &ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, 
			"dd_write_enable_portal_objects",
			"- dm dd_write_enable_portal_objects $DM_ORACLE{'enable_write_portal_objects'}" );
  &CommentOutPinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF, 
			"dd_mark_as_portal" );
    
  #
  # Perform the database updates needed for RatedEventLoader.
  #
  if ( -f "$DM{'location'}/data/create_event_v.source" )
  {
	&ExecuteSQL_Statement_From_File( "$DM{'location'}/data/create_event_v.source", 
		TRUE, 
		TRUE, 
		%{$DM{'db'}} );
  }

  # Add Partitions to database
  &AddPartitions( %{$DM_ORACLE{"db"}} );
}


#######
#
# Post configuration for DM_ORACLE
#
#######
sub configure_dm_oracle_post_configure
{
	if ( $ServiceName{ 'cm' } !~ /^$/ )
	{
		&Stop( $ServiceName{ 'cm' } );
		sleep( 6 );
	}
	&Stop ( $ServiceName{ 'dm_oracle' } );

	#
	# Reset 'dm stmt_cache_entries' to the original value, then restart dm_oracle.
	#
	&ReplacePinConfEntry( $DM_ORACLE{'location'}."/".$PINCONF,
		"stmt_cache_entries",
		"- dm stmt_cache_entries $DM_ORACLE{'stmt_cache_entries'}" );
	&Start( $ServiceName{ 'dm_oracle' } );
	if ( $ServiceName{ 'cm' } !~ /^$/ )
	{
		&Start( $ServiceName{ 'cm' } );
		sleep( 10 );
	}
}


#######
#
# This function verifies if PinPartition package is present in the database.
# If not, then run partition_utils.sql to create PIN_PARTITION package.
# After that, run partition_utils with -f option,
# which will check if the default partitions exist, and add them if necessary.
#
#######
sub AddPartitions {
  	local( %DB ) = @_;
  	local( $tmpFile ) = $PIN_TEMP_DIR."/tmp.out";
  	local( $ReadString );

	#
	# Updating the configuration for partition_utils in partition_utils.values.
	#
	&ReplacePinConfEntry( $PARTITION_UTILS{'location'}."/partition_utils.values",
		"Database alias",
		"\$MAIN_DB{'alias'} = \"".$DB{alias}."\";");

	&ReplacePinConfEntry( $PARTITION_UTILS{'location'}."/partition_utils.values",
		"Database user",
		"\$MAIN_DB{'user'} = \"".$DB{user}."\";");

	&ReplacePinConfEntry( $PARTITION_UTILS{'location'}."/partition_utils.values",
		"Database password",
		"\$MAIN_DB{'password'} = \"".$DB{password}."\";");

  	&ExecuteSQL_Statement("select object_name from user_objects where object_type= 'PACKAGE BODY' and status = 'VALID' and object_name = 'PIN_PARTITION';", TRUE, TRUE, %DB );

  	open( TMPFILE, "<$tmpFile " );
  	while( $ReadString = <TMPFILE> ) {
    		if ( $ReadString =~ m/no\s+rows\s+selected/ ) {
      			&ExecutePLB_file("../../apps/partition_utils/sql_utils/oracle/partition_utils.plb",
					  "pin_partition", %DM_ORACLE );
    		}
  	}
	close( TMPFILE );


  	if ( $SETUP_CREATE_PARTITIONS =~ m/^YES$/i ) {

		#
		# Getting current system time in seconds.
		#
		$nsec = time(); 
		#
		# Adding 2 days(172800 secs) to current time
		#
		$nsec = $nsec + 172800;
		($sec, $min, $hour, $day, $mon, $year, $weekday, $yearday, $isdst) = localtime($nsec);
		$mon = $mon + 1;
		$year = 1900 + $year;
		$startdate = sprintf("%02d%02d%d", $mon, $day, $year);

		# Use ExecuteShell so that error will be handled by partition_utils and not directed to tmp.out
        	$Cmd = &FixSlashes( '/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl '.$PIN_HOME.'/bin/partition_utils -o add -t realtime -s '.$startdate.' -u month -w 1 -q 12 -f' );
		&ExecuteShell( TRUE, $Cmd );
	}

}

# Really this procedure just loads the package to the db and initializes the Infranet.properties file
sub AddVirtualColumns {
  	local( %DB ) = @_;
  	local( $tmpFile ) = $PIN_TEMP_DIR."/tmp.out";
  	local( $ReadString );
	my($i) = 0;
	
	&Configure_VirtCol_Cnf;

	#
	#  Load the pin_virtual_columns package provided it is not already loaded
	#
  	&ExecuteSQL_Statement("select object_name from user_objects where object_type= 'PACKAGE BODY' and status = 'VALID' and object_name = 'PIN_VIRTUAL_COLUMNS';", TRUE, TRUE, %DB );

  	open( TMPFILE, "<$tmpFile " );
  	while( $ReadString = <TMPFILE> ) {
    		if ( $ReadString =~ m/no\s+rows\s+selected/ ) {
      			&ExecutePLB_file("../../apps/pin_virtual_columns/oracle/create_pkg_pin_virtual_columns.plb",
					  "pin_virtual_columns", %DM_ORACLE );
    		}
  	}
	close( TMPFILE );
}

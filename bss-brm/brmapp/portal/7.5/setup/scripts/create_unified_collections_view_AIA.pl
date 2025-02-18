#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#==================================================================== 
# $Header: bus_platform_vob/bus_platform/data/sql/create_unified_collections_view_AIA.pl /cgbubrm_7.5.0.rwsmod/1 2012/12/31 04:51:46 praghura Exp $
#
# create_unified_collections_view_AIA.pl
# 
# Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved. 
# This material is the confidential property of Oracle Corporation
# or its licensors and may be used, reproduced, stored
# or transmitted only in accordance with a valid Oracle license or
# sublicense agreement.
#
#    praghura    12/25/12 - Creation
#==================================================================== 

require "pin_functions.pl";
require "../pin_setup.values";
require "pin_oracle_functions.pl";

#
# File into which output of SQL query is written into #
#
local ( $PIN_TEMP_DIR ) = $PIN_TMP;
my ( $tmpFile ) = $PIN_TEMP_DIR."/tmp.out";

#
# Take the schema login details #
#
print "Enter the number of schemas: ";
$schema_num = <>;
chomp($schema_num);

print "Enter primary schema name: ";
$primary_schema = <>;
chomp($primary_schema);

print "\nEnter password for DB user $primary_schema: ";
system("stty -echo");
$primary_password = <>;
chomp($primary_password);
system("stty echo");


#==================================================
# Setting the primary schema login details in 
# a hash which is understood by ExecuteSQL_Statement 
# subroutine 
#==================================================
%PRIMARY_DB = ("user", $primary_schema, "password", $primary_password, "alias", $ORACLE_SID);

#=========================================
# If there is only one schema then just 
# create a synonym to the views
#=========================================
if ($schema_num == 1) {
	print "\n\nThere is only one schema. Hence creating a synonym to the collections views!!\n\n";
	$result = &ExecuteSQL_Statement("CREATE SYNONYM UNIFIED_COLL_ACTION_IF_VIEW FOR COLL_ACTION_IF_VIEW;", FALSE, FALSE, %PRIMARY_DB);
	&CheckResult($tmpFile, %PRIMARY_DB);
	$result = &ExecuteSQL_Statement("CREATE SYNONYM UNIFIED_COLL_SCENARIO_IF_VIEW FOR COLL_SCENARIO_IF_VIEW;", FALSE, FALSE, %PRIMARY_DB);
	&CheckResult($tmpFile, %PRIMARY_DB);
	print "CREATED!!\n\n";
	exit ( 0 );
}

#=========================================
# Otherwise proceed to create the unified
# views
#=========================================
print "Enter all secondary schema names: \n";
for ($i = 0; $i < ($schema_num - 1); $i++) {
        $secondary_schema[$i] = <>;
        chomp($secondary_schema[$i]);
}

for ($i = 0; $i < ($schema_num - 1); $i++) {
        print "Enter password for DB user $secondary_schema[$i]: ";
        system("stty -echo");
        $secondary_password[$i] = <>;
        chomp($secondary_password[$i]);
        system("stty echo");
}

print "\n\nGranting permissions for tables specific to primary schema!!\n\n";

for ($i = 0; $i < ($schema_num - 1); $i++) {
        $result = &ExecuteSQL_Statement("GRANT SELECT ON CONFIG_COLLECTIONS_ACTION_T TO $secondary_schema[$i] WITH GRANT OPTION;", 
								FALSE, FALSE, %PRIMARY_DB);
	&CheckResult($tmpFile, %PRIMARY_DB);
        $result = &ExecuteSQL_Statement("GRANT SELECT ON CONFIG_COLLECTIONS_SCENARIO_T TO $secondary_schema[$i] WITH GRANT OPTION;", 
								FALSE, FALSE, %PRIMARY_DB);
	&CheckResult($tmpFile, %PRIMARY_DB);
}

print "\n\nGRANTED!!!\n\n";

print "\n\nGranting permissions for tables required for collections action and scenario view!!\n\n";

for ($i = 0; $i < ($schema_num - 1); $i++) {
	#==================================================
	# Setting the secondary schema login details in
	# a hash for each of the secondary schemas which is 
	# understood by ExecuteSQL_Statement subroutine
	#==================================================
	%SECONDARY_DB = ("user", $secondary_schema[$i], "password", $secondary_password[$i], "alias", $ORACLE_SID); 
	$result = &ExecuteSQL_Statement("GRANT SELECT ON AU_COLLECTIONS_ACTION_T TO $primary_schema;", FALSE, FALSE, %SECONDARY_DB);
	&CheckResult($tmpFile, %SECONDARY_DB);
	$result = &ExecuteSQL_Statement("GRANT SELECT ON COLLECTIONS_SCENARIO_T TO $primary_schema;", FALSE, FALSE, %SECONDARY_DB);
	&CheckResult($tmpFile, %SECONDARY_DB);
	$result = &ExecuteSQL_Statement("GRANT SELECT ON BILLINFO_T TO $primary_schema;", FALSE, FALSE, %SECONDARY_DB);
	&CheckResult($tmpFile, %SECONDARY_DB);
	$result = &ExecuteSQL_Statement("GRANT SELECT ON COLL_ACTION_IF_VIEW TO $primary_schema;", FALSE, FALSE, %SECONDARY_DB);
	&CheckResult($tmpFile, %SECONDARY_DB);
	$result = &ExecuteSQL_Statement("GRANT SELECT ON COLL_SCENARIO_IF_VIEW TO $primary_schema;", FALSE, FALSE, %SECONDARY_DB);
	&CheckResult($tmpFile, %SECONDARY_DB);
}

print "\n\nGRANTED!!!\n\n";

print "\n\nCreating collections action view!!\n";


#===================================
# Forming SQL query for creation of
# unified collection action view 
#===================================
$coll_action_view = "CREATE OR REPLACE VIEW UNIFIED_COLL_ACTION_IF_VIEW AS SELECT * FROM $primary_schema.COLL_ACTION_IF_VIEW ";
for ($i = 0; $i < ($schema_num - 1); $i++) {
        $coll_action_view = $coll_action_view."UNION SELECT * FROM $secondary_schema[$i].COLL_ACTION_IF_VIEW ";
}
$coll_action_view = $coll_action_view.";";
$result = &ExecuteSQL_Statement($coll_action_view, FALSE, FALSE, %PRIMARY_DB);
&CheckResult($tmpFile, %PRIMARY_DB);

print "\n\nCREATED!!!\n\n";

print "\n\nCreating collections scenario view!!\n\n";


#===================================
# Forming SQL query for creation of
# unified collection scenario view
#===================================
$coll_scenario_view = "CREATE OR REPLACE VIEW UNIFIED_COLL_SCENARIO_IF_VIEW AS SELECT * FROM $primary_schema.COLL_SCENARIO_IF_VIEW ";
for ($i = 0; $i < ($schema_num - 1); $i++) {
        $coll_scenario_view = $coll_scenario_view."UNION SELECT * FROM $secondary_schema[$i].COLL_SCENARIO_IF_VIEW ";
}
$coll_scenario_view = $coll_scenario_view.";";
$result = &ExecuteSQL_Statement($coll_scenario_view, FALSE, FALSE, %PRIMARY_DB);
&CheckResult($tmpFile, %PRIMARY_DB);

print "\n\nCREATED!!!\n\n";


#===========================================================================
#  This function looks for Oracle Errors in the output from a SQL statement,
#  which is passed to this function as the argument '$tmpFile'.
#
#  If no errors are found, 0 is returned.
#  For errors, an error message will be displayed, then the function exits.
#
#  Arguments:
#    $tmpFile  - file which contains the SQL statement output
#    %DB       - local copy of %DB.
#  Returns:  0 if no errors
#            exit(2) if major error
#============================================================================
sub CheckResult {
	local ( $tempFile ) = shift( @_ ); 
	local ( %DB ) = @_;

	local ( $Error ) = "NONE";

	open( TMPFILE, "<$tempFile " ) || die "\n\nCannot read $tmpfile\n\n";
	while( $ReadString = <TMPFILE> ) {
		if ( $ReadString =~ /ORA-([\d]*):.*/ ) {
			$Error = $1;
			last;
		}
	}


	#
	# If no Oracle errors, then return now
	#
	if ( $Error eq "NONE" ) {
		return 0;
	}

	#
	# Process any Oracle errors found in the SQL statement output file
	#
	if ( $Error eq "12154" ) {
		print "\n\n$DB{'alias'} is not a valid service name for this machine."; 
		print "\nPlease make sure you have created this entry in the TNSNAMES.ORA file."; 
		print "\nFor further details refer to $tmpFile\n\n";
		exit( 2 );
	}
	elsif ( $Error eq "01017" ) {
		print "\n\nThe login credentials you have supplied are not valid.";
		print "\nPlease make sure you entered the correct 'user', 'password', and 'alias'.";
		print "\nFor further details refer to $tmpFile\n\n";
		exit( 2 );
	}
	elsif ( $Error eq "00942" ) {
		print "\n\nTable or view does not exist. For further details refer to $tmpFile\n\n";
		exit ( 2 );
	}
	else {
		print "\n\nUnknown error. For further details refer to $tmpFile\n\n";
		exit ( 2 );
	}

	close( TMPFILE );
	return 0;
}

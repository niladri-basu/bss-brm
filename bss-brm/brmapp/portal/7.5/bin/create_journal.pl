#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: create_journal.pl:RWSmod7.3.1Int:1:2007-Jun-28 05:20:20 %
#
# Copyright (c) 2007, 2008, Oracle and/or its affiliates. All rights reserved.
#
#  This material is the confidential property of Oracle Corporation or its
#  licensors and may be used, reproduced, stored or transmitted only in
#  accordance with a valid Oracle license or sublicense agreement.
#

#############################################################################
# This tool invokes stored procedures in package 'journal' in order to create
# temporary journal tables and move these into partitioned journal tables.
#
# It requires a configuration file containing database and other parameters.
# The database parameters will be used while invoking sqlplus.
#
# Assumes that 'sqlplus' executable is in the PATH
#
# Input:
#
#   - Configuration file for database connection and other 'static' parameters
#     (example contents below)
#        db_user=scott
#        db_password=tiger
#        db_alias=mydb
#        journal_start_date=04/15/2007 (MM/DD/YYYY)
#        journal_partition_days=5
#
#   - Mode of operation (MANDATORY): 2 modes as below
#
#   1. Mode create_temp_journals
#      Creates journals for period ending given date in temporary journal
#      tables (to be moved later into actual journal table partitions)
#
#      Additional valid switches
#      - End date in format MM/DD/YYYY (MANDATORY)
#      - Flag that tells if only currency resources need to be considered for
#        journaling (Default: All resources - both currency and non-currency)
#
#   2. Mode move_into_partitions
#      Creates journal table partitions and moves the contents of temporary
#      journal tables into these partitions
#
#      Additional valid switches
#      NONE
#
#############################################################################

use strict;
#use warnings; # Uncomment as needed

use Getopt::Long;
use POSIX;

########## Global variables ##########

my $g_SUCCESS = 0;
my $g_FAILURE = 1;

my $g_program_name; # Name of this script
my $g_mode; # Program mode of operation
my $g_verbose; # Tells if script should run in verbose mode
my $g_start_time; # Start time in seconds from when journals need to be created
my $g_end_time; # End time in seconds for create_journal()
my $g_currency_only; # Non-zero if only currency resources to be journaled
my $g_partition_days; # No. of days in each journal partition

# Database connection parameters
my $g_db_user;
my $g_db_password;
my $g_db_alias;

my $sql_command;
my $sql_output;
#############################################################################
# Start of MAIN program code
#############################################################################

# Process command line, do some validation and set some globals
&process_command_line();

if ($g_verbose) {
	&print_parameters();
}
open( file_handler,  ">temp_commands.sql") 
	or die "Can't Create temp_commands.sql: $!";

	print file_handler "SET SERVEROUTPUT ON size 100000;\n";

# Execute stored procedure create_journal() using sqlplus
if ($g_mode eq "create_temp_journals") {
	print file_handler "CALL journal.create_tmp_journals("
	                        . "$g_start_time, $g_end_time, $g_currency_only);\n";

	$sql_command = "sqlplus -silent "
					. "$g_db_user/$g_db_password\@$g_db_alias <temp_commands.sql";

}
elsif ($g_mode eq "move_into_partitions") {
	print file_handler "CALL journal.move_journals_into_partitions("
	                        . "$g_partition_days);\n";
	$sql_command = "sqlplus -silent "
					. "$g_db_user/$g_db_password\@$g_db_alias <temp_commands.sql";

}

if ($g_verbose) {
	print STDOUT "\n****** Calling sqlplus as follows:\n";
	print STDOUT "$sql_command";
}

close(file_handler);
$sql_output = `$sql_command`;
unlink "temp_commands.sql";

if ($g_verbose) {
	print STDOUT "\n****** Output of sqlplus follows:\n";
	print STDOUT "$sql_output";
}

# This check to test whether the client sqlplus was invoked properly or not. 
if(length($sql_output) == 0) {
 	print STDOUT "\n sqlplus client not invoked properly";
 		exit $g_FAILURE;
}

# Parse sqlplus out for error indicators. Sample errors are given below
#   ERROR at line 1:
#   ORA-20027: Error while creating temporary journal table : ORA-00955: ...
#
elsif ($sql_output =~ /ORA-200\d\d|ERROR |ERROR:/) {
	if (! $g_verbose) { # If we did not already print all this stuff
		&print_parameters();

		print STDOUT "\n****** Calling sqlplus as follows:\n";
		print STDOUT "$sql_command";

		print STDOUT "\n****** Output of sqlplus follows:\n";
		print STDOUT "$sql_output";
	}
	print STDOUT "\n$g_program_name: Processing FAILED\n";
	exit $g_FAILURE;
}
else {
	print STDOUT "\n$g_program_name: Processing SUCCEEDED\n";
	exit $g_SUCCESS;
}


#############################################################################
# Processes command line parameters, performs some error checking and sets
# some globals
#############################################################################
sub process_command_line() {

	my $config_file;
	my $start_date;
	my $end_date;
	my $currency_only;
	my $help_option;

	$g_program_name = $0;
	$g_program_name =~ s,.*/,,; # Strip pathname prefix if any

	GetOptions(
		'm|mode:s'		=> \$g_mode,
		'e|end_date:s'	=> \$end_date,
		'currency_only'	=> \$currency_only,
		'c|config:s'	=> \$config_file,
		'v|verbose'		=> \$g_verbose,
		'h|help'		=> \$help_option
	) or &print_usage($g_FAILURE);

	# If requested help, print help and EXIT
	&print_usage($g_SUCCESS) if $help_option; # EXIT here!

	######## Configuration file #########

	# Use default configuration file if not specified
	if (! $config_file) {
		$config_file = "create_journal.config";
		if ($g_verbose) {
			print STDOUT
			"\nInfo: Using default configuration file '$config_file'\n";
		}
	}

	# Set configuration parameters
	&set_config_parameters($config_file) || &print_usage($g_FAILURE);

	######## Mode of operation #########

	if ($g_mode ne "create_temp_journals"
			&& $g_mode ne "move_into_partitions") {
		print STDERR
			"\nERROR: Missing or invalid -mode switch\n";
		&print_usage($g_FAILURE);
	}

	######## End date #########

	if (! $end_date && $g_mode eq "create_temp_journals") {
		print STDERR
			"\nERROR: Mode 'create_temp_journals' requires end date\n";
		print "       Please provide end date with -end_date switch\n";
		&print_usage($g_FAILURE);
	}

	if ($end_date && $g_mode ne "create_temp_journals") {
		print STDERR
			"\nERROR: Switch -end_date is only valid " .
			"for mode 'create_temp_journals'\n";
		&print_usage($g_FAILURE);
	}

	######## Currency only #########

	if ($currency_only) {
		$g_currency_only = 1;
	}
	else {
		$g_currency_only = 0;
	}

	if ($g_currency_only && $g_mode ne "create_temp_journals") {
		print STDERR
			"\nERROR: Switch -currency_only is only valid " .
			"for mode 'create_temp_journals'\n";
		&print_usage($g_FAILURE);
	}

	if ($g_mode eq "create_temp_journals") {

		# Set end time for journaling (start time set elsewhere)
		$g_end_time = &convert_date_to_UTC_seconds($end_date);
		if ($g_end_time == -1) {
			&print_usage($g_FAILURE);
		}

		if ($g_start_time >= $g_end_time) {
			print STDERR
				"\nERROR: End date must be greater than "
				. "journaling start date\n";
			&print_usage($g_FAILURE);
		}
	}

	return;

} # end process_command_line


#############################################################################
# Converts user-given date from MM/DD/YYYY (or YY) to UTC seconds value
#
# Parameter 1: Date in format MM/DD/YYYY or MM/DD/YY
#
# Returns: UTC seconds value if successful, else -1
#############################################################################
sub convert_date_to_UTC_seconds {
	my $date_string = shift;

	my $ret_value = -1;
	my $day;
	my $mon;
	my $year;

	($mon, $day, $year) = split /\/|\.|-/, $date_string;

	if ($mon !~ /^\d{1,2}$/ || $mon < 1 || $mon > 12) {
		print STDERR "ERROR: $mon is an invalid value for month\n";
		return $ret_value;
	}

	if ($day !~ /^\d{1,2}$/ || $day < 1 || $day > 31) {
		print STDERR "ERROR: $day is an invalid value for day\n";
		return $ret_value;
	}

	if ($year !~ /^\d{2}$/ && $year !~ /^\d{4}$/) {
		print STDERR "ERROR: $year is an invalid value for year\n";
		return $ret_value;
	}

	$mon = $mon - 1; # January is 0

	if ($year < 70) { # Assume this is after 2000
		$year = $year + 100;
	} elsif ($year > 1900) {
		$year = $year - 1900;
	}

	my $sec  = 0;
	my $min  = 0;
	my $hour = 0;
	my $wday = 0;
	my $yday = 0;
	my $is_dst = -1; # Tells that we don't know if DST applies

	# Get time in UTC seconds
	$ret_value =
		mktime ($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $is_dst);

	return $ret_value;

} # end convert_date_to_UTC_seconds


#############################################################################
# Reads configuration file and sets global configuration parameters.
#
# Parameter 1: Name of configuration file
#
# Returns: true (1) if successful, else false (0)
#############################################################################
sub set_config_parameters {
	my $file_name = shift;
	my $param;
	my $value;
	my $start_date;

	if (! open(CONFIG_FILE, "< $file_name")) {
		print STDERR "\nERROR: Failed to open '$file_name' for reading\n";
		return 0;
	}

	while (<CONFIG_FILE>) {
		chomp;
		if ($_ !~ /=/) { # Just to avoid Perl warnings
			next;
		}

		($param, $value) = split /=/, $_;

		# Remove leading and trailing spaces
		$param =~ s/^\s+|\s+$//;
		$value =~ s/^\s+|\s+$//;

		$g_db_user = $value if ($param eq "db_user");
		$g_db_password = $value if ($param eq "db_password");
		$g_db_alias = $value if ($param eq "db_alias");
		$start_date = $value if ($param eq "journal_start_date");
		$g_partition_days = $value if ($param eq "journal_partition_days");
	}

	close CONFIG_FILE;

	if (! $g_db_user || ! $g_db_password || ! $g_db_alias) {
		print STDERR "ERROR: Database parameter(s) missing in configuration\n";
		return 0;
	}

	if (! $g_partition_days) {
		print STDERR "ERROR: Parameter 'journal_partition_days' missing "
				. "in configuration\n";
		return 0;
	}

	if (! defined $start_date) {
		print STDERR "ERROR: Parameter 'journal_start_date' missing "
				. "in configuration\n";
		return 0;
	}

	$g_start_time = &convert_date_to_UTC_seconds($start_date);
	if ($g_start_time == -1) {
		print STDERR "ERROR: Invalid journal start date in configuration\n";
		return 0;
	}

	# Sanity check of partition days
	if (!defined $g_partition_days || $g_partition_days <= 0) {
		print STDERR
			"ERROR: Invalid or missing journal partition days "
				. "in configuration\n";
		print STDERR
			"       Value should be greater than 0\n";
		return 0;
	}

	return 1;
} # end set_config_parameters


#############################################################################
# Prints command usage help message and terminates with passed exit code
#############################################################################
sub print_parameters {
	my $start_local_time_str;
	my $end_local_time_str;

	$start_local_time_str = localtime($g_start_time);
	if ($g_mode eq "create_temp_journals") {
		$end_local_time_str = localtime($g_end_time);
	}

	print STDOUT "Info: Parameters for create_journal are as below\n";
	print STDOUT "  Mode: $g_mode\n";
	if ($g_mode eq "create_temp_journals") {
		print STDOUT "  End date: $end_local_time_str\n";
		print STDOUT "  End time in seconds: $g_end_time\n";
		print STDOUT "  Currency only: "
				. ($g_currency_only ? "Yes\n" : "No\n");
	}
	print STDOUT "  Database user: $g_db_user\n";
	print STDOUT "  Database alias: $g_db_alias\n";
	print STDOUT "  Journal start date: $start_local_time_str\n";
	print STDOUT "  Journal start time in seconds: $g_start_time\n";
	print STDOUT "  Partition days: $g_partition_days\n";

} # end print_parameters


#############################################################################
# Prints command usage help message if -help switch was provided. If called
# on invalid input, advises user to run with -help for detailed information.
# In both cases, it terminates with passed exit code
#############################################################################
sub print_usage {
	my $exit_code = shift;

	if ($exit_code == $g_FAILURE) {
		print STDERR
			"TYPE '$g_program_name -help' FOR PROGRAM USAGE INFORMATION\n";
		exit $exit_code;
	}

	print STDERR <<EOM

0. Help

Usage: $g_program_name
       -help:     Print this message and exit

1. Mode 'create_temp_journals'

Creates temporary journal tables with journal entries corresponding to the
period ending with given end date. The start date will be used from
configuration the first time around. Subsequently, the start date will be
the day after the last event processed in the previous run.

Usage: $g_program_name
       -mode create_temp_journals
       -end_date <MM/DD/YYYY>
       [-currency_only]
       [-config <config-file>]
       -verbose

       -end_date: Events prior to this date will be considered for journaling
                  (Exclusive date)

       -currency_only: Only currency resources will be considered for
                       journaling. Default is 'all resources'
       -config:   Name of configuration file that contains database connection
                  and other parameters (defaults to 'create_journal.config').
                  All fields are mandatory and date format is MM/DD/YYYY.
                  Example contents of this file are as below.
                      db_user=scott
                      db_password=tiger
                      db_alias=mydb
                      journal_start_date=04/15/2007
                      journal_partition_days=5
       -verbose:  Display verbose output during script execution

2. Mode 'move_into_partitions'

Creates journal table partitions and moves the contents of temporary journal
tables into corresponding journal partitions

Usage: $g_program_name
       -mode move_into_partitions
       [-config <config-file>]
       -verbose

       -config:   Name of configuration file that contains database connection
                  and other parameters (defaults to 'create_journal.config').
                  All fields are mandatory and date format is MM/DD/YYYY.
                  Example contents of this file are as below.
                      db_user=scott
                      db_password=tiger
                      db_alias=mydb
                      journal_start_date=04/15/2007
                      journal_partition_days=5
       -verbose:  Display verbose output during script execution
EOM
	;

	exit $exit_code;
} # end print_usage

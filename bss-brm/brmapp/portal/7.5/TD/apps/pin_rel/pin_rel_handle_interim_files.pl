#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# @(#)%Portal Version: pin_rel_handle_interim_files.pl:UelEaiVelocityInt:4:2006-Sep-05 22:24:50 %
#
# Copyright (c) 2003, 2014, Oracle and/or its affiliates. All rights reserved.
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license
#       or sublicense agreement.
#
# Script: pin_rel_handle_interim_files.pl
#
# Description:
#   This script can be used by IREL to handle temporary files created
#   during the processing of a file.  It is customizable, but out-of-the-box
#   it finds files in the interim directory which start with the input file
#   name plus ".".  It then either copies the files, adding a timestamp to
#   the file name, or it deletes the files - based on the flags argument
#   passed in to this script.
#
# Usage:
#   pin_rel_handle_interim_files.pl <file> <interim_dir> <flags>
#
# Arguments:
#
#   file - Original input file name, used as a prefix pattern filter
#
#   interim_dir - Directory in which to operate on files
#
#   flags - Indicates how to handle the files
#     	0: Do nothing
#		1: Backup interim files for the given file in the given directory
#		2: Remove interim files for the given file in the given directory
#		3: Move the data files and all supported interim files to the given directory
#

use DirHandle;
use File::Basename;
use File::Copy;

# Set global constants.
#
# Note: Users can add new $FLAG_ constants and add their respective
#       handling code below (if desired).
#
$DEBUG = 0; # Set to 1 for debug level logging
$FLAG_NOOP = '0';
$FLAG_BACKUP = '1';
$FLAG_REMOVE = '2';
$FLAG_MOVE  = '3';

$SCRIPT = "pin_rel_handle_interim_files.pl";
$USAGE = "\n  usage: $SCRIPT <input_file_name> <interim_directory> <flags>\n";

# Script return values
# 0-99:    Portal reserved range
# 100-255: Customer reserved range
#
$SUCCESS = 0;
$ERROR_USAGE = 1;
$ERROR_UNSUPPORTED_FLAG = 2;
$ERROR_CANNOT_OPEN_DIRECTORY = 3;

# Source the command-line arguments
#
$file = basename($ARGV[0]); # basename() ensures it is an unqualified file name
$dir = $ARGV[1];
$flags = $ARGV[2];
$orgfile = $ARGV[3];
$rejectDir = $ARGV[4];


printDebug("arg1: file:  $file");
printDebug("arg2: dir:   $dir");
printDebug("arg3: flags: $flags");
printDebug("arg4: origfile: $orgfile");
printDebug("arg5: fileMoveDir: $rejectDir");

# Assert the mandatory arguments were provided.
#
if (($file eq '') || ($dir eq '') || ($flags eq ''))
{
	exit_err($ERROR_USAGE, $USAGE);
}

# For backups, new file extension is follows: ".saved.<current_time>"
# where current_time is the localtime in seconds since the Epoch
# (i.e. January 1, 1970 00:00:00)
#
if ($flags eq $FLAG_BACKUP)
{
	$new_file_extension = ".saved." . time;
	printDebug("new file extension: $new_file_extension");
}

# Get the (interim) files in the interim directory which match the given
# file name as a prefix pattern.
#
@files = ();
@files = getFilteredFiles($dir, $file);

# Process the found (interim) files.
#
foreach $orig_file_name (@files)
{
	printDebug("Processing file: $orig_file_name");

	if ($flags eq $FLAG_NOOP)
	{
		# No operation; just exit
		#
		printDebug("Nothing to do for given flag: $flags");
		exit($SUCCESS);
	}
	elsif ($flags eq $FLAG_BACKUP)
	{
		# Ignore the file if it is already a backed up file
		# (i.e. it ends with ".saved.<time>").
		#
		if ($orig_file_name =~ /\.saved\.[0-9]+$/)
		{
			printDebug("Skipping file: $orig_file_name");
			next;
		}

		$new_file_name = $orig_file_name . $new_file_extension;

		printDebug("Copying file: $orig_file_name to: $new_file_name");
		copy($orig_file_name, $new_file_name);
	}
	elsif ($flags eq $FLAG_REMOVE)
	{
		printDebug("Removing file: $orig_file_name");
		# REL input file should be exempted from this operation 
		if ($orig_file_name eq $orgfile)
		{
			printDebug("Skipping Removal of file: $orig_file_name");
			next;
		}
		
		unlink($orig_file_name) or
			warn "WARNING: $SCRIPT: Could not remove file: $orig_file_name\n";
	}
	elsif ($flags eq $FLAG_MOVE)
	{
		# REL input file should be exempted from this operation 
		if ($orig_file_name eq $orgfile)
		{
			printDebug("Skipping the move of file: $orig_file_name\n");
			next;
		}
	
		move($orig_file_name,$rejectDir) or
			warn "WARNING: $SCRIPT: Could not move file: $orig_file_name\n";
	}
	else
	{
		# Provide an error indicating this is an unsupported flag
		#
		exit_err($ERROR_UNSUPPORTED_FLAG, "Unsupported flags: $flags");
	}
}

printDebug("Completed processing");
exit($SUCCESS);

# Look in the given directory for files that start with
# the given prefix plus "." and return them fully qualified.
#
sub getFilteredFiles
{
	my $dir = shift;
	my $prefix = shift;

	$dir =~ s/\/$//; # remove the last character if it is a '/'.

	printDebug("Processing directory: $dir");

	my $dh = DirHandle->new($dir) or 
		exit_err($ERROR_CANNOT_OPEN_DIRECTORY, "Cannot open directory: $dir");

	return sort				# sort pathnames
		grep { -f }			# choose only files
		map { "$dir/$_" }		# create full paths
		grep { /^$prefix\./ }		# filter based on prefix + '.'
		$dh->read();			# read all entires
}

# Prints to STDOUT if $DEBUG is set to '1'.
#
sub printDebug
{
	my $string = shift;

	if ($DEBUG == 1)
	{
		print STDOUT "DEBUG: $SCRIPT: $string\n";
	}
}

# Function to exit program with error code and error messages.
#
sub exit_err
{
	$errCode = shift;
	$msg1 = shift;

	print "Error $errCode: $msg1\n";
	exit($errCode);
}

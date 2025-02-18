#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# 
# @(#)%Portal Version: pin_rel_enum_blk.pl:UelEaiVelocityInt:1:2006-Sep-05 22:24:48 %
#
#       Copyright (c) 2003-2006 Oracle. All rights reserved.
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license
#       or sublicense agreement.
#
# Script: pin_rel_enum_blk.pl
#
# Description:
#   This script can be used to manually evaluate a .blk (bulk-loadable)
#   file's fields and values.  Given a .blk file, a specific line can be
#   enumerated to show the value in each field.  Using this information,
#   a manual review of the respective control file can help to determine
#   possible mismatches which might result in SQL*Loader failures.  As such,
#   this script is best used for testing and debugging IREL customizations.
#
# Usage:
#   pin_rel_enum_blk.pl <file_name.blk> [line_number]
#
# Arguments:
#
#   file_name.blk - The IREL created bulk-loadable file
#
#   line_number - The line number which should be enumerated; default = 1
#

my $DELIMITER = '\t';
my $file = '';
my $line = 1;

# The .blk file is a mandatory first argument.
if ($ARGV[0] eq '')
{
	print "pin_rel_enum_blk.pl version 2003.05.21\n";
	print "\n  usage: pin_rel_enum_blk.pl <file_name.blk> [line_number]\n\n";
	exit;
}
else
{
	$file = $ARGV[0];
}

# The line number to enumerate is an optional second argument.
if ($ARGV[1] ne '')
{
	$line = $ARGV[1];
}
else
{
	$line = 1; # Just source the first line by default.
}

my $count = 0;
open(BLK, "$file") || die "Could not open the bulk-loadable file: $file\n";
while (<BLK>)
{
	my $currentBlkLine = $_;

	$count++;
	if ($line != $count)
	{
		 next; # skip to the right line
	}

	# Walk through this line, enumerating the values.
	print "\nLine\n$currentBlkLine\n";
	print "Field\tValue\n";
	my $field = 0;
	(my @values) = split(/$DELIMITER/, $currentBlkLine);
	foreach my $val (@values)
	{
		# Future extensions could add additional delimiting for
		# specific field types, such as poids.  But since only
		# some poids are mapped into multiple fields in the database,
		# and not all, this type of extension is not done out
		# of the box.

		$field++;
		print "$field\t$val\n";
	}
	close(BLK); # We are done.
	exit;
}

# Check if we processed the requested record.
if ($count < $line)
{
	print "Error: There are only $count records in the bulk-loadable file: $file\n";
}

exit;


#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# Copyright (c) 2003, 2010, Oracle and/or its affiliates. All rights reserved. 
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license
#       or sublicense agreement.
#
# Script: tmp_suspense_preprocess.pl
#
# Description:
#   This script is used to generate bulk loader files to update suspended usage records.
#
# Revision: 2010-09-01
#

require "getopts.pl";
use Math::BigInt;
use File::Basename;

$USAGE = 
"Usage: inFile interimDir tablesStr startPoid endPoid incrPoid flags";

#
# Define debug flag
#
$debug = 0;

#
# Define all the constants required for processing suspended usage file
#
$deli = "\t";			# field delimiter
$headerRecType = "010";		# header record type
$detailRecType = "020";		# detail record type
$creationTimePos = 6;		# creation time stamp position (position starts with 0)


#
# Script return values
# 0-99:    Portal reserved range
# 100-255: Customer reserved range
#
$PREPROCESS_SUCCESS = 0;
$USAGE_ERR = 1;
$CANT_OPEN_FILE = 2;
$MISSING_BAL_REC = 3;
$MISSING_DTL_REC = 4;
$UNSUPPORTED_TABLE = 5;
$INVALID_POID_INCREMENT_VALUE = 6;
$END_POID_NOT_MATCHED = 7;

#
# Define other constants
#
$MAX_INCREMENT_BY = 10;  # maximum increment_by value for assertion purpose

$SQL_SERVER_SUPPORT = 0;

#
# Parse command line flags.
#
($#ARGV < 6) && exit_err($USAGE_ERR, $USAGE);
$inFile = $ARGV[0];

#
# BigInt is used for the 64-bit poid_id0 since this
# Perl may not be the 64-bit version.
# Using BigInt for all arithmetic is too slow.
# So, given a starting poid_id0, it is split into two 
# ranges where there will be a rollover at the 7th place.
#

$interimDir    = $ARGV[1];  # interim directory
$tablesStr     = $ARGV[2];  # tables string separated by semicolons
$startPoid     = new Math::BigInt $ARGV[3]; # starting poid value, created by REL
$expEndPoid    = new Math::BigInt $ARGV[4]; # expected ending poid value, created by REL
$incrPoid      = $ARGV[5];  # POID increment value
$flags         = $ARGV[6];  # preprocess flags from Infranet.properties
$constStr      = $ARGV[7];  # const values <process_date,event_poid,session_poid,user_poid>
$lineConst     = "";	    # To Construct a string with constant values separated by tab.

print "Interim directory : $interimDir\n" if $debug;
print "Tables string : $tablesStr\n" if $debug;
print "Start poid value : $startPoid\n" if $debug;
print "Expected end poid value : $expEndPoid\n" if $debug;
print "Poid increment value : $incrPoid\n" if $debug;
print "Falgs : $flags\n" if $debug;

#
# Assert poid increment value
#
if ($incrPoid > $MAX_INCREMENT_BY) {
   exit_err( $INVALID_POID_INCREMENT_VALUE, "invalid poid increment value", $incrPoid);
}

# Construct a string with all the constant valuesfor SQL server support separated by tab before writing it to the bulk file.

if (length($constStr) > 0)
{
    $SQL_SERVER_SUPPORT = 1;
    @constVal = split(/;/,$constStr);
    $modifiedTime = $createdTime = $constVal[1];
    $eventPoid = $constVal[2];

    @constValPoid = split(/ /,$eventPoid);
    $poidDb = $constValPoid[0];
    $poidType = $constValPoid[1];
}

if($SQL_SERVER_SUPPORT == 1)
{
  $POID_REV            =                0;
  $READ_ACCESS         =               "L";
  $WRITE_ACCESS        =               "L";

      $lineConst =  $deli.$POID_REV.$deli.$READ_ACCESS.$deli.$WRITE_ACCESS.$deli.$createdTime.$deli.
			$modifiedTime.$deli.$poidDb.$deli.$poidType;

}

#
# construct output file names
#
$file = basename($inFile);
@table = split(/;/, $tablesStr);
$interimDir =~ s/\/$//;   # trim last char if it's '/'
for ($i = 0; $i < @table; $i++) {
    $outFile = $interimDir . "/" . $file . "." . $table[$i] . ".blk";
    if ($table[$i] =~ /^tmp_susp/i) {
        $outFile1 = $outFile;
        print "Output file 1 : $outFile1\n" if $debug;
    }
    else {
        exit_err( $UNSUPPORTED_TABLE, "Unsupported table",$table[$i]);
    }    
}

#
# Initialize some constants
#
init();   # initialize poid increment algorithm

#
# Open the input file
#

open(IN_FILE, $inFile) || exit_err( $CANT_OPEN_FILE, $inFile, $!);
open(OUT1_FILE, ">$outFile1") || exit_err( $CANT_OPEN_FILE, $outFile1, $!);

#
# Process each record in the file.
#

$line = <IN_FILE>;
while ( $line ) {
   chomp($line);

   if ($line =~ m/^$detailRecType/o) {

      #
      # When the rollover happens, increment high-order digits
      # and reset low-order digits.
      #
      $i += $incrPoid;
      if ($i >= $maxrecs) { # need to rollover
         $i -= $maxrecs;
         $high++;
      }
      $rec_id = 0;

      printf(OUT1_FILE "$line$deli$recycleTime$deli$high%07u$lineConst\n", $i);

      $line = <IN_FILE>;
   }
   elsif ($line =~ m/^$headerRecType/o) {

      #
      # Get recycle time using creation time in header record
      #
      @header = split(/$deli/, $line);
      $recycleTime = $header[$creationTimePos];

      $line = <IN_FILE>;
   }
   else {
      $line = <IN_FILE>;
   } 
}

close( IN_FILE);
close( OUT1_FILE);

exit($PREPROCESS_SUCCESS);

#
# Initialize algorithm for poid increment in order to improve efficiency.
#
sub init {
   # Using BigInt for all arithmetic is too slow.
   # So, given a starting poid_id0, it is split into two 
   # ranges where there will be a rollover at the 7th place.
   $maxrecs = 10000000; # use 10 million as rollover point

   #
   # Use the modulo off $maxrecs to compute the rollover
   # point and the high-order digits needed before and after
   # the rollover. Copy into non-BigInt
   # vars to improve printing performance.
   #
	$high = 0;
        my $rem = 0;
        my $tmp = 0;
        my $high_tmp = 0 ;

        ($high_tmp, $tmp) =  ($startPoid->bdiv($maxrecs));
        my $tmp1 =  Math::BigInt->bstr($tmp);
        $rem = $tmp1 ;
        $tmp1 =  Math::BigInt->bstr($high_tmp);
        $high = $tmp1 ;
        $i =   ($rem - $incrPoid);
}

#
# Function to exit program with error code and error messages.
#
sub exit_err {
   $errCode = shift;
   $msg1 = shift;
   $msg2 = shift;
   
   print "$errCode : $msg1 : $msg2";
   close(IN_FILE);
   close(OUT1_FILE);  
   exit( $errCode);
}


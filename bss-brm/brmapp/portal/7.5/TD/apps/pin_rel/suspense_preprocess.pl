#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: suspense_preprocess.pl:UelEaiVelocityInt:3:2006-Sep-05 22:24:30 %
#       Copyright (c) 2003-2006 Oracle. All rights reserved.
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license
#       or sublicense agreement.
#
# Script: suspense_preprocess.pl
#
# Description:
#   This script is used to generate bulk loader files to create suspended usage records.
#   It also generates template control file(s) for loading into queryable fields table dynamically
#   and updates correct data size in the template control file for loading into edr buf table.
#
# Revision: 03-12-2004
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
# Define all the constants and variable required for processing suspended usage file
#
$deli = "\t";			# field delimiter
$headerRecType = "010";		# header record type
$detailRecType = "020";		# detail record type
$edrRecType = "030";		# edr record type
$queryableRecType = "040";	# queryable fields record type
$fieldsMappingPos = 20; 	# field mapping position from header record (position starts with 0)
$edrSizePos = 9;		# edr size position from detail record (position starts with 0)
$tableColsStart = "{";		# columns start symbol
$tableColsEnd = "}";		# columns end symbol
$columnDeli = ";";		# delimiter that separates multiple column and datatype pairs
$datatypeDeli = ":";		# delimiter that separates column name and data type
$maxEdrSize = 0;		# maximum edr size found in this input file
@queryableFieldsTables = ();    # queryable fields table names

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
$MISSING_EDR_BUF_REC = 8;
$EDR_SIZE_NOT_MATCHED = 9;
$FIELDS_MAPPING_PARSE_ERROR = 10;

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
$lineConst     = "";        # To Construct a string with constant values separated by tab.

print "Interim directory : $interimDir\n" if $debug;
print "Tables string : $tablesStr\n" if $debug;
print "Start poid value : $startPoid\n" if $debug;
print "Expected end poid value : $expEndPoid\n" if $debug;
print "Poid increment value : $incrPoid\n" if $debug;
print "Flags : $flags\n" if $debug;

#
# Assert poid increment value
#
if ($incrPoid > $MAX_INCREMENT_BY) {
   exit_err( $INVALID_POID_INCREMENT_VALUE, "invalid poid increment value", $incrPoid);
}

#
# construct const values process_date,event_poid,session_poid,user_poid 
#
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
  $POID_REV               =               0;
  $READ_ACCESS            =               "L";
  $WRITE_ACCESS           =               "A";
  $STATUS                 =               0;
  $NUM_RECYCLES           =               0;
  $RECYCLE_T              =               0;
  $RECYCLE_OBJ_DB         =               0;
  $RECYCLE_OBJ_ID0        =               0;
  $RECYCLE_OBJ_TYPE       =               "";
  $RECYCLE_OBJ_REV        =               0;
  $TEST_SUSP_REASON       =               65534;
  $TEST_SUSP_SUBREASON    =               65534;
  $TEST_ERROR_CODE        =               0;
  $EDITED                 =               0;

	$lineConst =  $deli.$POID_REV.$deli.$READ_ACCESS.$deli.$WRITE_ACCESS.$deli.$STATUS.$deli.
			$NUM_RECYCLES.$deli.$RECYCLE_T.$deli.$RECYCLE_OBJ_DB.$deli.$RECYCLE_OBJ_ID0.$deli.
			$RECYCLE_OBJ_TYPE.$deli.$RECYCLE_OBJ_REV.$deli.$TEST_SUSP_REASON.$deli.$TEST_SUSP_SUBREASON.
			$deli.$TEST_ERROR_CODE.$deli.$EDITED.$deli.$createdTime.$deli.$modifiedTime.$deli.$poidDb.$deli.$poidType;
}

#
# construct output file names
#
$file = basename($inFile);
@table = split(/;/, $tablesStr);
$interimDir =~ s/\/$//;   # trim last char if it's '/'
$numQFTables = 0;
for ($i = 0; $i < @table; $i++) {
    $outFile = $interimDir . "/" . $file . "." . $table[$i] . ".blk";
    if ($table[$i] =~ /^suspended_usage_t$/i) {
        $outFile1 = $outFile;
        print "Output file 1 : $outFile1\n" if $debug;
    }
    elsif ($table[$i] =~ /^susp_usage_edr_buf$/i) {
        $outFile2 = $outFile;
        print "Output file 2 : $outFile2\n" if $debug;
    }
    else {
        #
        # Initially assume all tables other than suspended_usage_t and
        # susp_usage_edr_buf base tables are queryable fields tables.
        # Validation of these tables will be done when parsing fields
        # mapping info in generateControlFilesForQueryableFields()
        # function
        #
        $outFile3[$numQFTables] = $outFile;
        $queryableFieldsTables[$numQFTables] = $table[$i];
        print "Output file " . ($numQFTables+3) . " : $outFile3[$numQFTables]\n" if $debug;
        $numQFTables++;
    }
}

#
# Initialize some constants
#
$foundRecForFile2 = 0;
$foundRecForFile3 = 0;
init();   # initialize poid increment algorithm

#
# Open the input file
#

open(IN_FILE, $inFile) || exit_err( $CANT_OPEN_FILE, $inFile, $!);
open(OUT1_FILE, ">$outFile1") || exit_err( $CANT_OPEN_FILE, $outFile1, $!);
open(OUT2_FILE, ">$outFile2") || exit_err( $CANT_OPEN_FILE, $outFile2, $!);
for ($j = 0; $j < @queryableFieldsTables; $j++) {
   local *OUT_FILE;
   open(OUT_FILE, ">$outFile3[$j]") || exit_err( $CANT_OPEN_FILE, $outFile3[$j], $!);
   push(@OUT3_FILE, *OUT_FILE);
}

#
# Process each record in the file.
#

$line = <IN_FILE>;
while ($line) {
   if ($line =~ m/^$detailRecType/o) {
      chomp($line);

      #
      # When the rollover happens, increment high-order digits
      # and reset low-order digits.
      #
      $i += $incrPoid;
      if ($i >= $maxrecs) { # need to rollover
         $i -= $maxrecs;
         $high++;
      }

      #
      # Found another detail record without finding an edr rec for previous detail record
      #
      if( $foundRecForFile1 == 1 ) {
         exit_err( $MISSING_EDR_BUF_REC );
      }

      #
      # Reset flags for data integrity check
      #
      $foundRecForFile2 = 1;
      $foundRecForFile3 = 1;

      $baseLine = $line;
      @detail = split($deli, $line);
      $edrSize = $detail[$edrSizePos];

      $maxEdrSize = max($maxEdrSize, $edrSize);

      $line = <IN_FILE>;
   }
   elsif ($line =~ m/^$headerRecType/o) {
      chomp($line);
      @header = split($deli, $line);
      $fieldsMapping = $header[$fieldsMappingPos];
      generateControlFilesForQueryableFields($fieldsMapping);

      $line = <IN_FILE>;
   }
   elsif($line =~ m/^$edrRecType/o) {
      if( $foundRecForFile2 == 1) {
         $foundRecForFile2 = 0;

         #
         # Format from input file is <030_recType><tab><edrBuf>
         # Since <edrBuf> is a binary data, it could be spanned in multiple lines
         # Therefore, it needs to read next few lines until total read edr size
         # is equal to edr size specified in detail record
         #
         $idx = index($line, $deli) + 1;
         $edrBuf = substr($line, $idx);
         $readEdrSize = length($edrBuf);
         while ($readEdrSize < $edrSize) {
            $line = <IN_FILE>;
            $edrBuf .= $line;
            $readEdrSize += length($line);
         }
         chomp($edrBuf);
         $readEdrSize = length($edrBuf);
         if ($readEdrSize != $edrSize) {
            exit_err($EDR_SIZE_NOT_MATCHED);
         }

         #
         # Format for bulk loader file is 
         # <recLength><030_recType><tab><poidValue><tab><edrBuf>
         # The first 5 characters are length of the record that follows
         # We use this option for loading because edr buf may contain EOL characters 
         #
         $line = sprintf("$edrRecType$deli$high%07u$deli$edrBuf", $i);
         $length = length($line);
         $line = sprintf("%05u$line", $length);


        # Construct a string with all the constant valuesfor SQL server support separated by tab before writing it to the bulk file.

         printf(OUT1_FILE "$baseLine$deli$high%07u$lineConst\n", $i);
         print OUT2_FILE $line;
      }
      else {
         #
         # Found an edr rec without first finding a detail record
         #
         exit_err( $MISSING_DTL_REC, 
                   "Found an edr record without first finding a detail record");
      }
      $line = <IN_FILE>;
   }
   elsif($line =~ m/^$queryableRecType/o) {
      chomp($line);
      if( $foundRecForFile3 == 1) {
         $foundRecForFile3 = 0;

         if (@queryableFieldsTables == 1) {
            #
            # no need to split fields if there is only one queryable fields table
            #
            $file = $OUT3_FILE[0];
            printf($file "$line$deli$high%07u\n", $i);
         }
         else
         {
            #
            # split it into multiple lines according to number of columns
            # defined for each loader table from fields mapping data in header record
            # (calculated from generateControlFilesForQueryableFields() function)
            #
            $j = 0;
            $l = 0;
            ($recType, @fields) = split(/$deli/, $line);
            foreach $file (@OUT3_FILE) {
               $tmpLine = $recType . $deli;
               for ($k = 0; $k < $numColumns[$j]; $k++) {
                  $tmpLine .= $fields[$l++] . $deli;
               }
               printf($file "$tmpLine$high%07u\n", $i);
               $j++;
            }
         }
      }
      else {
         #
         # Found a queryable fields rec without first finding a detail record
         #
         exit_err( $MISSING_DTL_REC, 
                   "Found a querable fields record without first finding a detail record");
      }
      $line = <IN_FILE>;
   }
   else{
      $line = <IN_FILE>;
   } 
}

#
# If we are at end of file, without finding an edr rec for previously found detail rec.
#
if( $foundRecForFile1 == 1) {
   exit_err($MISSING_EDR_BUF_REC,
            "Found a detail record without finding an edr record");
}

close( IN_FILE);
close( OUT1_FILE);
close( OUT2_FILE);
foreach $file (@OUT3_FILE) {
   close( $file);
}

#
# Before exiting the program, verify if end poid calculated at the end 
# matches the expected end poid value passed from command line argument
#
$endPoidStr = sprintf("$high%07u", $i);
$endPoid = new Math::BigInt $endPoidStr;
print "End poid is $endPoid and expected end poid is $expEndPoid\n" if $debug;
if ($endPoid != $expEndPoid) {
   exit_err($END_POID_NOT_MATCHED, 
            "End poid after pre-processing does not match expected end poid", 
            $endPoidStr);
}

updateControlFileForBlobSize($maxEdrSize);

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
        print "high value = $high, reminder = $rem\n" if $debug;
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

   #
   # Close all open files before exiting.
   #
   close( IN_FILE);
   close( OUT1_FILE);
   close( OUT2_FILE);
   foreach $file (@OUT3_FILE) {
      close( $file);
   }
   close(CTL_FILE);
   close(TMP_FILE);
   exit( $errCode);
}

#
# Generate template control file for queryable fields table dynamically
#
sub generateControlFilesForQueryableFields {
   $fieldsMapping = $_[0];
   my %fieldsMappingForTable;

   #
   # parse fieldsMapping string
   # the format is <table_name>{<colum_name>:<data_type>[[;<column_name>:<data_type>]...]}
   #               [[<table_name>{...}]...]
   #
   $fieldsMappingLength = length($fieldsMapping);
   $tableStartIdx = 0;
   $numTables = 0;
   while ($tableStartIdx < $fieldsMappingLength) {
      $colStartIdx = index($fieldsMapping, $tableColsStart, $tableStartIdx);
      if ($colStartIdx > 0) {
         $colEndIdx = index($fieldsMapping, $tableColsEnd, $colStartIdx);
         if ($colEndIdx > 0) {
            $table = substr($fieldsMapping, $tableStartIdx, $colStartIdx - $tableStartIdx);
            $mapping = substr($fieldsMapping, $colStartIdx + 1, $colEndIdx - $colStartIdx - 1);
            $fieldsMappingForTable{uc($table)} = $mapping;
            $tableStartIdx = $colEndIdx + 1;
            print "table : $table, fields mapping : $mapping\n" if $debug;
         }
         else {
            exit_err( $FIELDS_MAPPING_PARSE_ERROR, "parse error in fields mapping");
         }
      }
      else {
         exit_err( $FIELDS_MAPPING_PARSE_ERROR, "parse error in fields mapping");
      }

      #
      # sort @queryableFieldsTables elements initially passed from command line argument
      # in the same order from fields mapping information
      #
      $notFound = 1;
      for ($j = $numTables; $j < @queryableFieldsTables; $j++) {
         if ($queryableFieldsTables[$j] =~ /$table/i) {
            $tmp = $queryableFieldsTables[$numTables];
            $queryableFieldsTables[$numTables] = $queryableFieldsTables[$j];
            $queryableFieldsTables[$j] = $tmp;
            $tmp = $OUT3_FILE[$numTables];
            $OUT3_FILE[$numTables] = $OUT3_FILE[$j];
            $OUT3_FILE[$j] = $tmp;
            $notFound = 0;
            break;
         }
      }
      if ($notFound) {
          exit_err( $UNSUPPORTED_TABLE, "Unsupported table found in fields mapping data", $table);
      }
      $numTables++;
   }

   #
   # generate control file for each queryable fields table
   #
   @tableNames = @queryableFieldsTables;
   print "number of queryable fields tables = " . @tableNames . "\n" if $debug;
   for ($j = 0; $j < @tableNames; $j++) {
      print "queryable fields tables " . ($j + 1) . " : " . $tableNames[$j] . "\n" if $debug;
      if (! exists $fieldsMappingForTable{uc($tableNames[$j])}) {
         exit_err( $UNSUPPORTED_TABLE, "Unsupported table based on fields mapping data", $tableNames[$j]);
      }
      $mapping = $fieldsMappingForTable{uc($tableNames[$j])};

      $controlFile = $tableNames[$j] . ".ctl";
      open(CTL_FILE, ">$controlFile") || exit_err( $CANT_OPEN_FILE, $controlFile, $!);

      ($me = $0) =~ s,.*/,,;

      print CTL_FILE "--\n";
      print CTL_FILE "-- $controlFile\n";
      print CTL_FILE "-- automatically generated by $me\n";
      print CTL_FILE "--\n";

      print CTL_FILE "UNRECOVERABLE\n";
      print CTL_FILE "LOAD DATA\n";
      print CTL_FILE "CHARACTERSET UTF8\n";
      print CTL_FILE "APPEND\n";
      print CTL_FILE "INTO TABLE " . uc($tableNames[$j]) . "\n";
      print CTL_FILE "SINGLEROW\n";
      print CTL_FILE "FIELDS TERMINATED BY X\'09\'\n";
      print CTL_FILE "(\n";
      print CTL_FILE " RECORD_TYPE\t\tFILLER, -- NOT LOADED\n";

      #
      # Fields mapping has format as
      # <columnName>:<dataType>;<columnName>:<dataType>;...
      # Available data types from pipeline are INTEGER, DATE, DECIMAL, and STRING.
      #
      @columns = split(/$columnDeli/, $mapping);
      for ($k = 0; $k < @columns; $k++) {
         ($column, $datatype) = split(/$datatypeDeli/, $columns[$k]);
         if ($datatype =~ /INTEGER/i || $datatype =~ /DATE/i) {
            print CTL_FILE " $column\t\tINTEGER EXTERNAL,\n";
         }
         elsif ($datatype =~ /DECIMAL/i) {
            print CTL_FILE " $column\t\tFLOAT EXTERNAL,\n";
         }
         elsif ($datatype =~ /STRING/i) {
            print CTL_FILE " $column\t\tCHAR,\n";
         }
      }
      #
      # $numColumns is used when splitting queryable fields record into
      # multiple lines in main routine
      #
      $numColumns[$j] = @columns;
   
      print CTL_FILE " OBJ_ID0\t\tINTEGER EXTERNAL\n";
      print CTL_FILE ")\n";
      close(CTL_FILE);
      print "Template control file $controlFile generated.\n" if $debug;
   }
}

#
# Update data size for edr buf column in template control file only if required
# data size is greater than the one currently specified in the template control file
#
sub updateControlFileForBlobSize {
   $size = $_[0];

   $needToUpdate = 0;
   $controlFile = "susp_usage_edr_buf.ctl";
   $tmpFile = $interimDir . "/" . $file . "." . $controlFile . ".tmp";
   open(CTL_FILE, $controlFile) || exit_err( $CANT_OPEN_FILE, $controlFile, $!);
   open(TMP_FILE, ">$tmpFile") || exit_err( $CANT_OPEN_FILE, $tmpFile, $!);

   while ($line = <CTL_FILE>) {
      if ($line =~ /EDR_BUF/i && $line =~ /CHAR\((\d+)\)/i) {
         #
         # update data size only if required size is greater than 
         # current size that is specified in template control file
         #
         if ($size > $1) {
            $line =~ s/CHAR\((\d+)\)/CHAR($size)/i;
            $needToUpdate = 1;
         }
      }
      print TMP_FILE $line;
   }
   close(CTL_FILE);
   close(TMP_FILE);

   if ($needToUpdate == 1) {
      #
      # rename temporary file to template control file
      #
      if ($^O =~ /win/i) {	# Windows
         system("copy $tmpFile $controlFile; del $tmpFile");
      }
      else {			# UNIX
         system("cp $tmpFile $controlFile; rm $tmpFile");
      }
      print "Update edr size = $size for template control file $controlFile.\n" if $debug;
   }
   else {
      # 
      # No need to update template control file - delete temporary file
      #
      if ($^O =~ /win/i) {	# Windows
         system("del $tmpFile");
      }
      else {			# UNIX
         system("rm $tmpFile");
      }
   }
}

#
# Simple math routine to return maximum value between two values
#
sub max {
   $value1 = $_[0];
   $value2 = $_[1];

   if ($value1 >= $value2) {
      return $value1;
   }
   else {
      return $value2;
   }
}

